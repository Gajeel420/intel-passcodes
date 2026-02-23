RoomModel = RoomModel or BaseClass(LuaModel)

function RoomModel:__init( ... )
	self.goldRooms={}  --金币场的房间列表
	self.mGoldGameRoomInfoDic = {} --缓存金币场房间等级信息
	self.cacheUserPlayingRoomID=-1--缓存玩家上次强制退出，重新登陆发来的房间消息
	self.directToGameInfo=nil
	--
	self.cardRooms={}  --房卡的房间列表
	self.mRoomCardDismissType=0 --保存房卡失效原因
	self.mCRequserDissolveGameBrocard=nil --房间的广播缓存
	
	self.mRoomList = {}

	self.RoomMinMone = 0   --进入游戏最少钱
	self.CurrentRoomInfo = {}
	self.IsEnterGame = false  --- 是否在游戏中
	
	--处理多房间配置自动进入 105
	self.m_LastEnterGameID = nil
	self.m_LastEnterGameRoomInfo = nil

	self:RegistProto()
end



function RoomModel:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGINOUT_ROOM,"RspLogoutRoomPara")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SRV_NOT_IN_USE,"CNotifyGameSrvNotInUse2App")
end

function RoomModel:RemoveProto( )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGINOUT_ROOM,"RspLogoutRoomPara")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SRV_NOT_IN_USE,"CNotifyGameSrvNotInUse2App")
end





function RoomModel:AddGameRoomLevel( gameid,levelInfo )
	if gameid==nil then return end
	self.mGoldGameRoomInfoDic[gameid]=levelInfo
end

function RoomModel:GetGameRoomLevel( gameid )
	if gameid == nil then return nil end
	return self.mGoldGameRoomInfoDic[gameid]
end

function RoomModel:AddUserPlayingData( )
	
end

function RoomModel:GetUserPlayingData( )
	-- body
end

function RoomModel:AddGlodRoom(roomID,roomVo)
	self.goldRooms[roomID]=roomVo
end

function RoomModel:GetGlodRoom( roomID )
	if roomID==nil then return nil end
	return self.goldRooms[roomID]
end

function RoomModel:AddCardRoom(roomID,roomVo)
	self.cardRooms[roomID]=roomVo
end

function RoomModel:GetCardRoom( roomID )
	if roomID==nil then return nil end
	return self.cardRooms[roomID]
end

function RoomModel:PlayerEnterRoom( msg )
	
	local userInfoSvr =msg
	local gameID=PlayerInfoController:GetInstance().model.mainPlayer.requestGameID--玩家请求的房间id
	local room=nil
	room=self:GetGlodRoom(userInfoSvr.m_usRoomID)
	--获取桌子
	local desk=room:GetDesk(userInfoSvr.m_usDeskIndex)
	--给桌子添加玩家
	local mDeskUser = SUserDetailInfo.New()
	mDeskUser.uiUserID=userInfoSvr.m_unUin
	mDeskUser.iGameID=userInfoSvr.m_usGameID
	mDeskUser.iRoomID=userInfoSvr.m_usRoomID
	mDeskUser.iDeskNO=userInfoSvr.m_usDeskIndex
	mDeskUser.iDeskStation=userInfoSvr.m_usDeskStation
	mDeskUser.iMoney=userInfoSvr.m_unMoney
	mDeskUser.szNickName=CommonUtil.LuaTableToStringNoEmpty(userInfoSvr.m_szNickName)
	mDeskUser.bBoy= userInfoSvr.m_usSex==1
	if desk then
		desk.DeskUsers[mDeskUser.iDeskStation]=mDeskUser
	end
	
	self:DispatchEvent(RoomConst.PlayerEnterRoom,mDeskUser)
end




--玩家离开房间
function RoomModel:PlayerLeaveRoom( msg )
	
	--判断玩家从哪个桌子离开
	local gameID=PlayerInfoController:GetInstance().model.mainPlayer.requestGameID--玩家请求的房间id
	local room=nil
	room=self:GetGlodRoom(msg.m_usRoomID)
	--获取桌子
	local desk=room:GetDesk(msg.m_usDeskIndex)
	if desk then
		desk:RemovePlayer( msg.m_unUin )
	end

	self:DispatchEvent(RoomConst.PlayerLeaveRoom,msg)
	
end

function RoomModel:GetInstance( ... )
	if RoomModel.instance==nil then
		RoomModel.instance=RoomModel.New()
	end
	return RoomModel.instance
end


-- 添加保存房间列表
function RoomModel:AddRoomList(gameID,roomList)
	-- body
	self.mRoomList[gameID] = nil
	local tmpList = {}
	for _,v in pairs(roomList) do
		
		--if v.m_nFlag == 1 then 	--过滤体验场
			table.insert(tmpList,v)
		--end
	end
	self.mRoomList[gameID] = tmpList
end


function RoomModel:GetRoolList(gameID)
	-- body
	local tmp = self.mRoomList[gameID]
	if tmp ~= nil then
		self.goldRooms = tmp
	end
	return tmp
end



---进入游戏
function RoomModel:OnEnterRoom( roomInfo )
	-- body
	if roomInfo == nil then return end

	self.CurrentRoomInfo = roomInfo

	
	self:RspRoomDeskData()
end


function RoomModel:RspRoomDeskData()
	if  SceneManager.GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game then
		return
	end

	RoomModel.GetInstance():RemoveEventListener(RoomModel.EventType.RspRoomAllDeskData,self.RspRoomDeskData,self)
	local roomInfo=self.CurrentRoomInfo

	local iMoney = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
	local minMoney = roomInfo.m_unMinMoney
	self.RoomMinMone = minMoney
	LuaToCSBridge.MinEnterGameMoney = minMoney
	if not(self:IsDeBitGame(roomInfo.m_usGameID)) and iMoney<minMoney then
		RoomController.GetInstance().CanRequest = true
		local showBoxData ={}
		showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
		local str = "Amount_Is_Not_Sufficient"--StringFormat(StringFormatByLanguage("Whether_to_go_to_the_Short"),NumberFormat(HallGoldRateSToC(self.RoomMinMone)) )
		showBoxData.context = str
		showBoxData.enterCB = function() 
			-- LuaEvent:DispatchEvent(EventName.OPEN_RECHARGEPANEL,{1})
		end--：点击确定返回；
		showBoxData.cancelCB = nil
		showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
		showBoxData.isHideAll = false--:隐藏所有按钮; 
		showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
		return
	end

	UIManager:GetInstance():ShowNetWorkMessage("Enter_Rooming","EnterRoomOverTime",8)

	

	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
	send.m_usGameID= roomInfo.m_usGameID or 0
	send.m_usRoomID= roomInfo.uRoomID  or 0
	send.m_usDeskIndex=0
	send.m_bDeskStation=0
	send.m_iMoney=iMoney
	send.m_bFlag= roomInfo.m_nFlag
	send.m_szNickName= {}
	--保证长度，
	local tmp = CommonUtil.StringToByteArrayTable(PlayerInfoController:GetInstance().model.mainPlayer.szNickName or "")	 
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		send.m_szNickName[i] = tmp[i] or 0
	end
	if PlayerInfoController:GetInstance().model.mainPlayer.bBoy then
		send.m_usSex=1
	else
		send.m_usSex=0
	end
	RoomController:GetInstance():ReqChooseDeskEnterGame(send)
end




function RoomModel:IsDeBitGame(gameID)
	
	for i = 1, #HallDefine.DebitGame do
		if gameID == HallDefine.DebitGame[i] then
			return true
		end
	end
	return false
end


--手动搓座进入游戏
---进入游戏
function RoomModel:ManualEnterRoom(gameId,roomId,deskId,seatId )

	if  SceneManager.GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game then
		return
	end

	self.CurrentRoomInfo = RoomModel:GetInstance():GetGlodRoom(roomId)

	local iMoney = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
	local minMoney = self.CurrentRoomInfo.m_unMinMoney
	self.RoomMinMone = minMoney
	LuaToCSBridge.MinEnterGameMoney = minMoney
	if  not(self:IsDeBitGame(roomInfo.m_usGameID)) and iMoney<minMoney then
		RoomController.GetInstance().CanRequest = true
		self:DispatchEvent(RoomModel.EventType.EnterRoom,false)
		local showBoxData ={}
		showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
		local str = "Amount_Is_Not_Sufficient"--StringFormat(StringFormatByLanguage("Whether_to_go_to_the_Short"),NumberFormat(HallGoldRateSToC(self.RoomMinMone)) )
		showBoxData.context = str
		showBoxData.enterCB = function() 
			-- LuaEvent:DispatchEvent(EventName.OPEN_RECHARGEPANEL,{1})
		end--：点击确定返回；
		showBoxData.cancelCB = nil
		showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
		showBoxData.isHideAll = false--:隐藏所有按钮; 
		showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
		return
	end

	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
	send.m_usGameID= gameId or 0
	send.m_usRoomID= roomId  or 0
	send.m_usDeskIndex=deskId
	send.m_bDeskStation=seatId
	send.m_iMoney=iMoney
	send.m_bFlag= 0
	send.m_szNickName= {}
	--保证长度，
	local tmp = CommonUtil.StringToByteArrayTable(PlayerInfoController:GetInstance().model.mainPlayer.szNickName or "")	 
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		send.m_szNickName[i] = tmp[i] or 0
	end
	if PlayerInfoController:GetInstance().model.mainPlayer.bBoy then
		send.m_usSex=1
	else
		send.m_usSex=0
	end
	RoomController:GetInstance():ReqChooseDeskEnterGame2(send)
end



--请求退出游戏房间
function RoomModel:ReqLogoutRoomPara(gameId,roomId,deskId)
	
	local send={}
	send.m_usGameID= gameId or 0
	send.m_usRoomID= roomId  or 0
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
	Net_SendPlatformGameData(NetworkDefine.CReqLogoutRoomPara,send,send.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGINOUT_ROOM,send.m_usRoomID, deskId)
end






--请求退出游戏房间返回
function RoomModel:RspLogoutRoomPara(buffer)
	print("请求退出游戏房间返回")
	local msg = self:ParseMsg(NetworkDefine.CRspLogoutRoomPara,buffer)
	if msg.m_sResultID == 0 or msg.m_sResultID == -135 then
		print("退出房间成功！")
		self:DispatchEvent(RoomModel.EventType.RspLogoutRoomPara,true)
	else
		print("退出房间失败！")
		self:DispatchEvent(RoomModel.EventType.RspLogoutRoomPara,false)
		ServerBackPrompt(msg.m_sResultID)
	end
end



--服务器通知，服务不可用
function RoomModel:CNotifyGameSrvNotInUse2App(buffer)
	print("服务器不可用")
	RoomController.GetInstance().CanRequest = true
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	RoomController.GetInstance().mIsNeedShowNetMessage = false
	UIManager.GetInstance():ShowNoteMessage("Game_Repairing",1)
	local msg = self:ParseMsg(NetworkDefine.CNotifyGameSrvNotInUse2App,buffer)
	local data={}
	data.UId=msg.m_unUin
	data.GameId=msg.m_usGameID
	data.RoomId=msg.m_usRoomID
	self:DispatchEvent(RoomModel.EventType.CNotifyGameSrvNotInUse2App,data)
end







function RoomModel:StartMonitorJackpotEvent()
	LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)
end

function RoomModel:ShopMonitorJackpotEvent()
	LuaEvent:RemoveEventListener(EventName.GameNetDispatchData,self.HandleData,self)
end


function RoomModel:HandleData (context)
	if context == nil or context.m_data == nil then return end
	local clientID = context.m_data[0]
	local headStruct = context.m_data[1]
	local buffer = context.m_data[2]
	local state = context.m_data[3]
	local dwAssistantID=headStruct.dwAssistantID


	if dwAssistantID == NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_UPDATE_JACKPOT_INFO then 
		local msg = self:ParseMsg(NetworkDefine.CRspUpdateJackpot,buffer) 
		if msg then
			self:DispatchEvent(RoomModel.EventType.UpdataJackpot,msg)
		end
	end


end

function RoomModel:RspUserCheckOutGameCoin(data)
	-- body
	LuaEvent:DispatchEvent(EventName.RSRspUserCheckOutGameCoin,data)
end





--- 设置捕鱼游戏不显示爆分榜
--- @param mClientGameID int
function RoomModel:SetTopScoreDisplay(mClientGameID)
	--local mClientGameID = ConfigModuleModel.GetInstance().listGameID[gameID]
	if StringStartsWith(mClientGameID,"4") then
		HallNotifyModel.GetInstance().IsShowTopScorePanel = false
	end
end


-- --处理多房间配置自动进入 105
function RoomModel:SetLastEnterGameID(GameID)
	self.m_LastEnterGameID = GameID
end

function RoomModel:GetLastEnterGameID()
	return self.m_LastEnterGameID
end

function RoomModel:ResetLastEnterGameRoomInfo()
	self.m_LastEnterGameRoomInfo = nil
end

function RoomModel:GetLastEnterGameRoomInfo()
	return self.m_LastEnterGameRoomInfo
end

function RoomModel:SetLastEnterGameRoomInfo(enterRoomIndex)
	if self.m_LastEnterGameRoomInfo == nil then
		self.m_LastEnterGameRoomInfo = {}
		if self.m_LastEnterGameID then
			local roomList = self:GetRoolList(self.m_LastEnterGameID)
			for i=1,#roomList do
				self.m_LastEnterGameRoomInfo[i] = false
			end
		end
	end

	if #self.m_LastEnterGameRoomInfo >= enterRoomIndex then
		self.m_LastEnterGameRoomInfo[enterRoomIndex] = true
	else
		print("-----------  房间是否进入过信息 错误")
	end
end

function RoomModel:GetNextCanEnterGameRoomIndex()
	local data = {}
	for i=1,#self.m_LastEnterGameRoomInfo do
		if self.m_LastEnterGameRoomInfo[i] == false then
			table.insert(data,i)
		end
	end

	local roomIndex = nil
	if #data > 1 then
		local temp = math.random(1,#data)
		roomIndex = data[temp]
	elseif #data == 1 then
		roomIndex = data[1]
	end

	return roomIndex
end


function RoomModel:__delete( ... )
	self:RemoveProto()
	self:ShopMonitorJackpotEvent()
end


RoomModel.EventType={
	RspRoomAllDeskData="RoomModel.EventType.RspRoomAllDeskData",
	RspLogoutRoomPara="RoomModel.EventType.RspLogoutRoomPara",
	EnterRoom="RoomModel.EventType.EnterRoom",
	UpdataJackpot="RoomModel.EventType.UpdataJackpot",
	CNotifyGameSrvNotInUse2App="RoomModel.EventType.CNotifyGameSrvNotInUse2App",
	RsqDeskPlayerListNewData = "RoomModel.EventType.RsqDeskPlayerListNewData",   --桌子数据通知 
}