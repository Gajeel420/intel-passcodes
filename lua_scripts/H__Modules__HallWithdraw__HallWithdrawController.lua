HallWithdrawController = HallWithdrawController or BaseClass(LuaController)

require"H/Modules/HallWithdraw/HallWithdrawView"
require"H/Modules/HallWithdraw/HallWithdrawModel"
require"H/Modules/HallWithdraw/View/HallWithdrawPanel"

function HallWithdrawController:__init( ... )
	self.view = HallWithdrawView.New()
    self.model = HallWithdrawModel:GetInstance()
end

function HallWithdrawController:GetInstance()
	if HallWithdrawController.instance == nil then
		HallWithdrawController.instance = HallWithdrawController.New()
	end
	return HallWithdrawController.instance
end

function HallWithdrawController:__delete( ... )
	self.view = nil
end


---获取绑定的信息
---callBack
function HallWithdrawController:GetBindingAccount( callBack )
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local code2 = GetRequestCode({ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime},"1")
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
	param:Add("code",code)
	param:Add("code2",code2)
    local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_timeout"))
	end
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
            print("-----------------------------  HallWithdrawController：GetBindingAccount ")
            pt(jsonData)
			
			 if jsonData.data ~= nil and jsonData.data.Bank then
                self.model.m_BankCard_UserName = jsonData.data.Bank.Name
                self.model.m_BankCard_Num = jsonData.data.Bank.Account
                self.model.m_BankCard_BankName = jsonData.data.Bank.Bank_Bankname
                self.model.m_BankCard_BankBranchName = jsonData.data.Bank.Bank_Bankbranch
            else
                self.model.m_BankCard_UserName = nil
                self.model.m_BankCard_Num = nil
                self.model.m_BankCard_BankName = nil
                self.model.m_BankCard_BankBranchName = nil
            end
			callBack()
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTXBindingInfo,param,sucFunc,failFunc,nil,false)
end

---绑定账号
---  Account
---realName
---Bank_Bankname
---Bank_Bankbranch
---type
---callBack
function HallWithdrawController:BindingAccount(Account,realName,phoneNum,emailAdress,callBack )
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local szTemp = StringFormat("{0}1{1}1{2}1{3}",uiUserID,uiUserID,uTime,ConfigModuleModel:GetInstance().ClientKey)
	local code = GetRequestCode({uiUserID,uiUserID,uTime},"1")
	local code2 =  GetRequestCodeOther({ConfigModuleModel.GetInstance().mLoginState,uTime,ConfigModuleModel:GetInstance().ClientKey,uiUserID},"1")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"Type","Bank"},     --默认 Bank
		{"time",uTime},
		{"logintype",loginType},
		{"Account",Account}, --卡号
		{"Name",realName},
		{"Bank_Bankname","Bank_Bankname"},
		{"Bank_Bankbranch","Bank_Bankbranch"},  --支行 跟银行同
		{"code",code},
		{"code2",code2},
		{"phone",phoneNum},
		{"email",emailAdress},
	}
	local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_timeout"))
	end

	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
            print("-----------------------------    HallWithdrawController:BindingAccount ")
            pt(jsonData)
            if jsonData.data ~= nil then
                self.model.m_BankCard_UserName = jsonData.data.Name
                self.model.m_BankCard_Num = jsonData.data.Account
                self.model.m_BankCard_BankName = jsonData.data.Bank_Bankname
                self.model.m_BankCard_BankBranchName = jsonData.data.Bank_Bankbranch
            else
                self.model.m_BankCard_UserName = nil
                self.model.m_BankCard_Num = nil
                self.model.m_BankCard_BankName = nil
                self.model.m_BankCard_BankBranchName = nil
            end
			callBack()
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.PostTXBindingInfo,postTable,sucFunc,failFunc,nil,false)
end

function HallWithdrawController:Exchange(amount,callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local code = GetRequestCode({uiUserID,uiUserID,uTime},"1")
	local code2 =  GetRequestCodeOther({ConfigModuleModel.GetInstance().mLoginState,uTime,ConfigModuleModel:GetInstance().ClientKey,uiUserID},"1")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"Type","Bank"},
		{"time",uTime},
		{"logintype",loginType},
		{"code",code},
		{"code2",code2},
		{"amount",amount},
	}
	local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("TiXianTip_Failed"))
	end
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			callBack()
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.PostTxCashWithdraw,postTable,sucFunc,failFunc,nil,false)
end