LoginPanelModel = LoginPanelModel or BaseClass(LuaModel)

function LoginPanelModel:__init()
    self.mIP = "未知"
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_DOMAIN_CFG_BY_VIP,"CQueryDomainCfgByVipRsp")	--服务器广播邮件响应
end

function LoginPanelModel:__delete( )
	-- body
end

---上报玩家IP
function LoginPanelModel:RePortIP()
	
end

---客户端根据VIP查询域名配置
---uiUserID 玩家ID
function LoginPanelModel:CQueryDomainCfgByVipReq(uiUserID)
    local send = {}
    send.m_unUIN = uiUserID
    if ConfigInfoMgr.mUnNewFlag ~= nil then
        send.m_unNewFlag = ConfigInfoMgr.mUnNewFlag
    else
        send.m_unNewFlag = 0
    end
    Net_SendHallData(NetworkDefine.CQueryDomainCfgByVipReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_DOMAIN_CFG_BY_VIP,20)
end
---客户端根据VIP查询域名配置返回
---buffer
function LoginPanelModel:CQueryDomainCfgByVipRsp(buffer)
    --print("iiiiiiiiiiiiiiiippppppppppppppppppppppppppppppppppp")
    local msg = self:ParseMsg(NetworkDefine.CQueryDomainCfgByVipRsp,buffer)
    if msg.m_sResultId == 0 then
        local data = 
        {
            {"m_iUseShieldFlag",msg.m_iUseShieldFlag},
            {"m_szDomain4Web",CommonUtil.LuaTableToStringNoEmpty(msg.m_szDomain4Web)},
            {"m_szDomain4Download",CommonUtil.LuaTableToStringNoEmpty(msg.m_szDomain4Download)},
            -- {"m_szDomain4Download","http://cloudupdate.ahsyggcm.com/app,http://clouddown.srdskj.com/app,http://app.daditzx.com/app"},
            {"m_szDomain4Activity",CommonUtil.LuaTableToStringNoEmpty(msg.m_szDomain4Activity)},
            {"m_szDomain4Broadcast",CommonUtil.LuaTableToStringNoEmpty(msg.m_szDomain4Broadcast)},
            {"m_szDomain4Login",CommonUtil.LuaTableToStringNoEmpty(msg.m_szDomain4Login)},
            --{"m_szDomain4Login","127.1.1.1"},
        }
        CommonUtil.DomainCfigByUserVIP(data)
    end
end


----- 自动登录部分

--- 获取自动登录类型
---@return loginType HallDefine.LOGIN_TYPE  
function LoginPanelModel:GetAutoLoginType()
    return PlayerPrefs.GetInt(self.mLoginTypeKey, 0)
end

--- 保存登录类型
function LoginPanelModel:SaveLoginType()
    PlayerPrefs.SetInt(self.mLoginTypeKey, self.mLogintype)
end

--- 自动登录
function LoginPanelModel:AutoLogin(loginType)
    if ConfigInfoMgr.LoginFailTips ~= "" then
        return 
    end
    local loginType = self:GetAutoLoginType()
    if loginType == HallDefine.LOGIN_TYPE.LOGINTYPE_GUEST then
        self:GuestLogin()
    elseif loginType == HallDefine.LOGIN_TYPE.LOGINTYPE_ACCOUNT then
        local account = PlayerPrefs.GetString(AppConst.Key_UserAccount,"") --用户账号
	    local password = PlayerPrefs.GetString(AppConst.Key_UserPassword,"")
        self:AcocountLogin(account,password)
    elseif loginType == HallDefine.LOGIN_TYPE.LOGINTYPE_WECHAT  then
        self:WechatLogin()
    end
end

--- Facebook登录
function LoginPanelModel:FacebookLogin()
    print("---------------------------------------  FacebookLogin")
    PhoneManager:FacebookLogin()
end

function LoginPanelModel:FacebookLoginCallBack(context)
    print("---------------------------------------  FacebookLoginCallBack")
    if context == nil then return end
    if context.m_data == nil then return end 
    local str = context.m_data[0]
    if str == nil then return end 
    
    if str then
        local data = Json.decode(str)
        pt(data)
        local resultCode = tonumber(data.resultCode)
        local accountName = data.accountName
        local nickName = data.nickName
        --0:成功  1：取消  2：错误
        if resultCode == 0 then
            self.mLogintype = HallDefine.LOGIN_TYPE.LOGINTYPE_WECHAT
            Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_THIRD_WEIXIN, accountName,nil, nickName)
        elseif resultCode == 1 then
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Cancel_Login"))
        else
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Login_Failed"))
        end
    end
end

--- 游客登录
function LoginPanelModel:GuestLogin()
    self.mLogintype = HallDefine.LOGIN_TYPE.LOGINTYPE_GUEST
    local accountName = PhoneManager:GetDeviceUniqueIdentifier()
    local nickName = GetRandomNickName()
    Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_AUTO, accountName,nil,nickName)
end

--- 微信登录
function LoginPanelModel:WechatLogin()
    self.mLogintype = HallDefine.LOGIN_TYPE.LOGINTYPE_WECHAT
    Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_THIRD_WEIXIN, "", "")
end

--- 账号登录
--- @param account 账号
--- @param password 密码
function LoginPanelModel:AcocountLogin(account,password)
    self.mLogintype = HallDefine.LOGIN_TYPE.LOGINTYPE_ACCOUNT
	Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL, account, password)
end

function LoginPanelModel:GetInstance()
	if LoginPanelModel.instance == nil then
		LoginPanelModel.instance = LoginPanelModel.New()
	end
	return LoginPanelModel.instance
end