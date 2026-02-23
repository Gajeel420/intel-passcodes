Network = {}
Network.MsgList = {}
--buffer:服务器发来的字节数组
--dataStruct：lua定义的数据结构
Network.isConnected=false --是否已经连接
Network.isConnecting=false --连接中
Network.isLoginSuccessed=false
Network.LoginAccount = ""
function Network.Start( ... )
	Network.AddMessageEvent()
end

function Network.OnConnected()
	Network.isConnected=true
	Network.isConnecting=false
end

function Network.OnConnecting()
	Network.isConnected=false
	Network.isConnecting=true
end

function Network.IsConnecting()
	return Network.isConnecting or false
end

function SerialiseByteArray(buffer,dataStruct)
	local tbtmp = {}
	for key,v in pairs(dataStruct) do
		local keyName = v[1]
		local typeName = v[2]
		local arrayLength = v[3]
		if keyName==nil or typeName==nil or arrayLength == nil then
			print("请检查结构体----------->>>>>>","keyName:",keyName,"typeName:",typeName,"arrayLength:",arrayLength)
			return nil
		end
		if arrayLength >0 then
			tbtmp[keyName] = {}
			for i=1,arrayLength do
				table.insert(tbtmp[keyName],0)
			end
		else
			tbtmp[keyName] = 0
		end
	end
	Util.BytesToStruct(buffer,dataStruct,tbtmp)
	return tbtmp
end

--登陆流程 --accountType：enum 类型；--account:string 账号；--password string 密码
function Net_BeginLogin( accountType,account,password,randomNickName )
	Net_GoLogin(accountType,account,password,randomNickName)
end


function Net_GoLogin(accountType,account,password,randomNickName)
	if ThirdPlam.Instance.Countrys ~= "阿拉伯聯合大公國" and ThirdPlam.Instance.Countrys ~= "阿拉伯联合酋长国" 
		 and ThirdPlam.Instance.Countrys ~= "United Arab Emirates" then
	
		Network.LoginAccount = account
		local reCode=HallRegistByPhoneModel:GetInstance():GetRecommendCode() or 0
		if ConfigInfoMgr.IsRecommentLogin and reCode==0 then
			local cb=function()
				NetworkMgr:BeginLogin(accountType, account, password,randomNickName)
			end
			LuaEvent:DispatchEvent(EventName.LOGIN_SHOWRECOMMENDCODE,cb)
		else
			NetworkMgr.MyRecomendCode=reCode
			NetworkMgr:BeginLogin(accountType, account, password,randomNickName)
		end
	end
end


--发送平台消息
function Net_SendHallData(templetTable,dataTable,msgType,msgID,dstFE)
	if NetworkMgr.mHandle ~=nil then 
		if Network.isLoginSuccessed then
			NetworkMgr.mHandle:SendData(templetTable, dataTable, msgID, dstFE, msgType, 0, 0)
		end
	end
end

---发送广播服务器消息
function Net_SendBoradCastData(templetTable,dataTable,msgType,msgID,dstFE)
	if NetworkMgr.mHandle ~=nil then 
		if Network.isLoginSuccessed and NetworkMgr.mHandle.SendBraodcastData ~= nil then
			NetworkMgr.mHandle:SendBraodcastData(templetTable, dataTable, msgID, dstFE, msgType, 0, 0)
		end
	end
end

--发送平台游戏消息
function Net_SendPlatformGameData(templetTable, dataTable, m_bDstFE, enterGameMsgType, roomID, deskID)
	if NetworkMgr.mHandle ~=nil then 
		-- print("enterGameMsgType",enterGameMsgType)
		-- print("m_bDstFE",m_bDstFE)
		if Network.isLoginSuccessed then
			local msgID = m_bDstFE*100+enterGameMsgType
			NetworkMgr.mHandle:SendPlatformGameData(templetTable, dataTable, msgID, m_bDstFE, 0, roomID, deskID)
		end
	end
end

--发送游戏消息
function Net_SendGameData(templetTable, dataTable, mainId,assistantID, m_bDstFE,roomID, deskID)
	if NetworkMgr.mHandle ~=nil then 
		if Network.isLoginSuccessed then
			NetworkMgr.mHandle:SendGameData(templetTable, dataTable, mainId,assistantID, m_bDstFE,roomID, deskID)
		end
	end
end

function Network.AddMessageEvent()
	LuaEvent:AddEventListener(EventName.HallNetDispatchData,Network.OnMessage,Network)
	
end

function Network:OnMessage(context)
	if context == nil then return end
	if context.m_data == nil then return end 
	local mHandleMSGID = context.m_data[0]
	local buffer = context.m_data[1]
	-- print("[@]收到 协议:",mHandleMSGID)
	if not Network.HasProtocal(mHandleMSGID) then return end 
	Network.MsgList[mHandleMSGID](buffer)
end

function Network.HasProtocal( mHandleMSGID )
	return Network.MsgList[mHandleMSGID] ~=nil
end

--注册协议
function Network.RegistProtocal(msgid,handle)
	if Network.HasProtocal(msgid) then
		print("多次订阅协议-->",msgid)
		return 
	end
	Network.MsgList[msgid] = handle
end

--注册协议
function Network.RemoveProtocal(msgid,handle)
	if Network.HasProtocal(msgid) then
		Network.MsgList[msgid] = nil
	end
end

--解析协议
function Network.ParseMsg(msgStruct,buffer,start)
	--print("KOKOKOOOPPIJp")
	local tbtmp = {}
	Network.SpawnStruct( msgStruct,tbtmp )
	start = start or 0
	--print(msgStruct==nil,"uhuiuihujo")
	DataParse.BytesToStruct(buffer,msgStruct,tbtmp,start)
	return tbtmp
end

function Network.SpawnStruct( msgStruct,tbtmp )
	
	if msgStruct and next(msgStruct) then 
		for key,v in pairs(msgStruct) do
			local keyName = v[1]
			local typeName = v[2]
			local arrayLength = v[3]
			--print(keyName,typeName,arrayLength,#msgStruct )
			if keyName==nil or typeName==nil or arrayLength == nil then
				print("请检查结构体----------->>>>>>","keyName:",keyName,"typeName:",typeName,"arrayLength:",arrayLength)
				return nil
			end
			if typeName ~="Byte" and typeName ~="Int32" and typeName ~="UInt32" and typeName ~="Boolean" and typeName ~="Int16" and typeName ~="UInt16" and typeName ~="Int64" and typeName ~="String" and typeName ~="Byte[]" and typeName ~="UInt32[]" and typeName ~="Int16[]" and typeName ~="UInt16[]" and typeName ~="Int64[]" and typeName ~="Boolean[]" then
				-- if  not Network.GetStruct(typeName) then 
				-- 	print("找不到结构体的名称:",typeName)
				-- 	return nil 
				-- else
				-- 	local st= NetworkDefine.All[structName]
				-- 	if arrayLength >0 then
				-- 		local tm1 = {}
				-- 		tbtmp[keyName] = tm1
				-- 		while(true)
				-- 		do

				-- 		end
				-- 		local tm2 = {}
				-- 		tm1[index] = Network.SpawnStruct( st,tm2)
				-- 	else
				-- 		local tm1 = {}
				-- 		tbtmp[keyName] = tm1
				-- 		Network.SpawnStruct(st,tm1)
				-- 	end	
				-- end
				tbtmp[keyName] = {}
			else
				if arrayLength >0 then
					tbtmp[keyName] = {}
					for i=1,arrayLength do
						if typeName == "String" then
							table.insert(tbtmp[keyName],"")
						else
							table.insert(tbtmp[keyName],0)
						end
					end
				else
					if typeName == "String" then
						tbtmp[keyName] = ""
					else
						tbtmp[keyName] = 0
					end
				end
			end
			
		end
	end
	return tbtmp
end

function Network.GetStruct(structName)
	return NetworkDefine.All[structName] ~= nil
end

