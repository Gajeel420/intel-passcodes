HallBindPhoneModel = HallBindPhoneModel or BaseClass(LuaModel)

function HallBindPhoneModel:__init( ... )
	self:RegistProto()
	self.mString_Phone=nil
end

function HallBindPhoneModel:GetInstance()
	if HallBindPhoneModel.instance == nil then
		HallBindPhoneModel.instance = HallBindPhoneModel.New()
	end
	return HallBindPhoneModel.instance
end

function HallBindPhoneModel:RegistProto()
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_AUTO_USER_SET_USERNAME_PASSWD,"CRspAutoUserSetAccountInfo")
end

function HallBindPhoneModel:CRspAutoUserSetAccountInfo(buffer)
	if buffer == nil then
		return 
	end
	local msg = self:ParseMsg(NetworkDefine.CRspAutoUserSetAccountInfo,buffer)

	if msg.m_sResultId==0 then
		UIManager:GetInstance():ShowNoteMessage("绑定成功")
		PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone = true
		local data={}
		data.PhoneString=self.mString_Phone
		LuaEvent:DispatchEvent(EventName.ACCOUNT_BindAccountCompeled)
		self:DispatchEvent(HallBindPhoneModel.EventType.BindPhoneSuccess,data)
	else
		ServerBackPrompt(msg.m_sResultId)
		self.mString_Phone=nil
	end
end



function HallBindPhoneModel:BindPhone(phoneString,passwordString)
	local phone = TrimStr(phoneString)
	self.mString_Phone=phone
	local password = TrimStr(passwordString)
	local passwordMD5 = CommonUtil.GetMd5StaticLoginPasswd(phone, password, CommonUtil.mLoginSalt)
	local send={}
	send.m_szLoginName=CommonUtil.StringToByteArrayTable(phone)
	send.m_szLoginPassword=CommonUtil.StringToByteArrayTable(passwordMD5) 
	for i=1,HallDefine.ConstDefine.E_MAX_NICK_LEN do
		if send.m_szLoginName[i]==nil then
			send.m_szLoginName[i]=0
		end
	end
	for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY do
		if send.m_szLoginPassword[i]==nil then
			send.m_szLoginPassword[i]=0
		end
	end
	Net_SendHallData(NetworkDefine.CReqAutoUserSetAccountInfo,send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_AUTO_USER_SET_USERNAME_PASSWD, 18)
end


function HallBindPhoneModel:__delete( ... )
end

HallBindPhoneModel.EventType=
{
	BindPhoneSuccess="HallBindPhoneModel.EventType.BindPhoneSuccess"
}