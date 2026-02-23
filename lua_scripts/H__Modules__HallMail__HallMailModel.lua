HallMailModel=HallMailModel or BaseClass(LuaModel)

function HallMailModel:__init( ... )
	self.index=1
	self.iReqMailCount=0
	self.listMails = {}
	self:RegistProto()
end

function HallMailModel:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_EMAIL_LIST_COMMERCE,"QueryEmailListHandle") --响应查询邮件
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_EMAIL,"NotifyClientMailHandle")	--服务器广播邮件响应
end



--发送邮件请求
function HallMailModel:ReqMailList()
	local user = PlayerInfoController:GetInstance().model.mainPlayer
	local send = {}
	send.m_unUIN = user.uiUserID
	send.m_usAreaId = user.uAreaID
    send.m_ucEmailType = 0
    send.m_usDayRange = HallDefine.FUTURE_DAYS
    send.m_usThisReqStartIndex = self.index
    send.m_usThisReqCount = 5
	Net_SendHallData(NetworkDefine.DataRequestGlodEmail,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_EMAIL_LIST_COMMERCE,20)
end

--处理服务器传过来的邮件列表
function HallMailModel:QueryEmailListHandle( buffer )
	local msg=CRspQueryGlodEmailMsgPara.Decode(buffer)  --解码
	if msg.m_sResultId==0 then
		self.iReqMailCount = self.iReqMailCount + msg.m_usThisReturnNum
		if msg.m_usThisReturnNum>0 then
			for i=1,msg.m_usThisReturnNum do
				local data=msg.m_UserEmailList[i]
				local vo={}
				vo.iEmailId=data.m_unEmailId
				vo.iTime=data.m_unTime
				vo.iEmailStatus=data.m_ucEmailStatus
				vo.strTitle=data.m_szTitle
				vo.strContent=data.m_szContent
				self:CheckMail(vo)
				table.insert(self.listMails,vo)
			end
		end
		if self.iReqMailCount<msg.m_unTotal then
			
			self.index = self.index +1
			self:ReqMailList(self.listMails)	
		else
			
			--接收完毕
			if UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMail) then
				self:DispatchEvent(HallMailConst.EventName_RefreshMail)
			else
				LuaEvent:DispatchEvent(EventName.HallEmaiNote)
			end
			
		end
	else
		ServerBackPrompt(msg.m_sResultId)
	end
end


function HallMailModel:NotifyClientMailHandle( buffer )
	local msg=CNotifyEmailMsgPara.Decode(buffer)  --解码
	local vo={}
	vo.iEmailId=msg.m_unEmailId
	vo.iTime=msg.m_unTime
	vo.iEmailStatus=msg.m_ucEmailStatus
	vo.strTitle=msg.m_szTitle
	vo.strContent=msg.m_szContent
	self:AddMail(vo)
end


function HallMailModel:GetMailList()
	return self.listMails
end

---添加一封邮件
function HallMailModel:AddMail(vo)
	self:CheckMail(vo)
	table.insert(self.listMails,vo )
	if UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMail) then
		self:DispatchEvent(HallMailConst.EventName_RefreshMail)
	else
		LuaEvent:DispatchEvent(EventName.HallEmaiNote)
	end
end

---判断是否有相同id的邮件 ，有就删除，用新的邮件
function HallMailModel:CheckMail(vo)
	local count = #self.listMails
	local index = 0
	for i = 1, count do
		local item = self.listMails[i]
		if item.iEmailId == vo.iEmailId then
			index = i
			break
		end
	end
	if index > 0 then
		self:RemoveMail(index)
	end
end

---删除邮件
function HallMailModel:RemoveMail(index)
	local mailVo=table.remove(self.listMails,index)
	-- self:DispatchEvent(MailModuleConst.EventName_RemoveMailVo,{mailVo})
	-- self:CheckUnreadMailCount()
end

---清空邮件列表
function HallMailModel:CleanMail()
	self.listMails = nil
	self.listMails = {}
end


function HallMailModel:GetInstance()
	if HallMailModel.instance==nil then
		HallMailModel.instance=HallMailModel.New()
	end
	return HallMailModel.instance
end

function HallMailModel:ReqMailListAgain()
	-- body
	self.listMails = nil
	self.listMails = {}
	self:ReqMailList()
end

function HallMailModel:__delete( ... )
	-- body
end