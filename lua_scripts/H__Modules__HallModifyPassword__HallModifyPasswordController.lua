HallModifyPasswordController = HallModifyPasswordController or BaseClass(LuaController)

require"H/Modules/HallModifyPassword/HallModifyPasswordView"
require"H/Modules/HallModifyPassword/View/HallModifyPasswordPanel"

function HallModifyPasswordController:__init( ... )
	self.view = HallModifyPasswordView.New()
    self:RegistProto()
end

function HallModifyPasswordController:GetInstance()
	if HallModifyPasswordController.instance == nil then
		HallModifyPasswordController.instance = HallModifyPasswordController.New()
	end
	return HallModifyPasswordController.instance
end

--监听请求商品列表返回
function HallModifyPasswordController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_USER_CHANGE_ACCOUNT_PASSWD,"RecvChangePassword") --监听用户数据变更消息
end

function HallModifyPasswordController:__delete( ... )
	self.view = nil
end

function HallModifyPasswordController:SendChangePassword(oldPswd,newPswd)
    -- print("------------------------------------------------   oldPswd : ",oldPswd)
    -- print("------------------------------------------------   newPswd : ",newPswd)
    local szAccountName =  PlayerInfoController:GetInstance().model.mainPlayer.szAccountName
    -- 修改密码验证成功后 给服务器发送消息
    local send = {}
    send.m_unCheckTime = os.time()
    local szAccountName = PlayerInfoController:GetInstance().model.mainPlayer.szAccountName
    send.m_szLoginName = CommonUtil.StringToByteArrayTable(szAccountName)
    for i = 1, HallDefine.ConstDefine.MAX_NICK_NAME_LENGTH do
        if send.m_szLoginName[i] == nil then
            send.m_szLoginName[i] = 0
        end
    end

    local md5 = CommonUtil.GetMd5SDyLoginPasswd(szAccountName,oldPswd,send.m_unCheckTime, CommonUtil.mLoginSalt)
    -- print("------------------------------------------------   old 加密: ",md5)
    send.m_szOldLoginPasswd = CommonUtil.StringToByteArrayTable(md5)
    for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
        if send.m_szOldLoginPasswd[i]==nil then
            send.m_szOldLoginPasswd[i]=0
        end
    end
    local newMd5 = CommonUtil.GetMd5StaticLoginPasswd(szAccountName, newPswd, CommonUtil.mLoginSalt)
    -- print("------------------------------------------------   new 加密: ",newMd5)
    send.m_szNewLoginPasswd = CommonUtil.StringToByteArrayTable(newMd5)
    for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
       if send.m_szNewLoginPasswd[i]==nil then
            send.m_szNewLoginPasswd[i]=0
        end
    end

    UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Updateing_Psd_Now"),StringFormatByLanguage("NetWorkOrrer"),2);
    Net_SendHallData(NetworkDefine.CUserChangeAccountPasswdReq, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_USER_CHANGE_ACCOUNT_PASSWD, 11)
end

function HallModifyPasswordController:RecvChangePassword(buffer)
    UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    local msg = self:ParseMsg(NetworkDefine.CUserChangeAccountPasswdSvrRsp,buffer)
    -- print("-----------------------------------------  修改密码")
    -- pt(msg)
    if msg.m_sResultId == 0 then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Modify_Psd_Success"))
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallModifyPassword)
    else
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Modify_Psd_Failure"))
    end
end
