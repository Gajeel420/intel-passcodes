HallAccountLoginPanel = HallAccountLoginPanel or BaseClass(LuaPanel)

function HallAccountLoginPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAccountLogin].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAccountLogin].path
	self.mPanelID = UIPanelDefine.EWndID.HallAccountLogin

	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self:CreatePanel(0)----必须实现
end


--初始化ui界面  ----必须实现
function HallAccountLoginPanel:InitUI()
	local mTran = self.obj.transform
    self.mInput_Login = mTran:Find("AccountLogin/Content/AccountInput/Input"):GetComponent(typeof(UIInput))
	--self.mInput_Login.label.text = StringFormatByLanguage("Account_Input")
	
    self.mInput_Password = mTran:Find("AccountLogin/Content/PasswordInput/Input"):GetComponent(typeof(UIInput))
	--self.mInput_Password.label.text = StringFormatByLanguage("Pls_Input_Psd")
    self.m_btnRegisterAccount=mTran:Find("AccountLogin/Content/Button_Register").gameObject
	UIEventListener.Get(self.m_btnRegisterAccount).onClick = function () self:OnRegisterAccount() end
	self.m_btnRegisterAccount:SetActive(ConfigModuleModel.GetInstance().IsEnableRegist)

    local mButton_Close = mTran:Find("AccountLogin/Content/Button_Close").gameObject
	UIEventListener.Get(mButton_Close).onClick = function () self:OnButton_Close() end
	
    local mButton_Login = mTran:Find("AccountLogin/Content/Button_Login").gameObject
	self.mButton_LoginBox = mButton_Login:GetComponent(typeof(BoxCollider))	
	UIEventListener.Get(mButton_Login).onClick = function () self:OnButton_Login() end
	
    local psdAction = self.mInput_Password.gameObject:GetComponent(typeof(UIInputSelectAction))
    psdAction.onSelectAction = function () self:OnSelect_Password() end
    psdAction.onDeSelectAction = function () self:OnDeSelect_Password() end
    self.mtempPsd = ""
	
	self.TweenAn = mTran:Find("AccountLogin/Content"):GetComponent(typeof(TweenScale))

	self.mObj_ForgetButton=mTran:Find("AccountLogin/Content/Button_Forget").gameObject
	UIEventListener.Get(self.mObj_ForgetButton).onClick = function () self:OnClickForgetButton() end

	self.m_Toggle_Remember=mTran:Find("AccountLogin/Content/Toogle_RememberMe"):GetComponent(typeof(UIToggle))
	self.m_Toggle_Remember.value = (PlayerPrefs.GetInt(GameConst.Key_UserAccount_Remember,1) == 1)
	UIEventListener.Get(self.m_Toggle_Remember.gameObject).onClick = function () self:OnClickRememberAccount() end


	self.m_Panel_Hall_NotePanel = mTran:Find("Hall_NotePanel").gameObject
	self.m_Btn_CloseNotePanel = mTran:Find("Hall_NotePanel/Content/Button_OK").gameObject
	UIEventListener.Get(self.m_Btn_CloseNotePanel).onClick = function ()
		self:OnClickCloseNotePanel()
	end

	self.m_Panel_Hall_ServiceTips = mTran:Find("Hall_ServiceTips").gameObject
	self.m_Btn_CloseServiceTipsPanel = mTran:Find("Hall_ServiceTips/Content/Button_OK/Button_OK").gameObject
	UIEventListener.Get(self.m_Btn_CloseServiceTipsPanel).onClick = function ()
		self:OnClickCloseServicePanel()
	end

	--Account Lock 弹窗
	self.updateName = "HallAccountLoginPanel:Update"
	self.lockTime = 0
	self.nowTime = 0
	self.m_Panel_Hall_AccountLockPanel = mTran:Find("Hall_AccountLockPanel").gameObject
	self.m_Btn_CloseAccountLockPanel = mTran:Find("Hall_AccountLockPanel/Content/Button_OK").gameObject
	self.m_Label_AccountLock = mTran:Find("Hall_AccountLockPanel/Content/Label_Time"):GetComponent(typeof(UILabel))
	UIEventListener.Get(self.m_Btn_CloseAccountLockPanel).onClick = function ()
		self:OnClickCloseAccountLockPanel()
	end
	
	self:AddEvent()
	LuaPanel.InitUI(self)
end

function HallAccountLoginPanel:AddEvent()
	LuaEvent:AddEventListener(EventName.AccountLockLimit,self.OnAccountLockLimit,self)
end

function HallAccountLoginPanel:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.AccountLockLimit,self.OnAccountLockLimit,self)
end

-- 刷新界面信息
function HallAccountLoginPanel:SetPanelData()
	local isRem = (PlayerPrefs.GetInt(GameConst.Key_UserAccount_Remember,1) == 1)
	if isRem then
		self.mInput_Login.value = PlayerPrefs.GetString(AppConst.Key_UserAccount,"") --用户账号
		self.mInput_Password.value = PlayerPrefs.GetString(AppConst.Key_UserPassword,"")
	else
		self.mInput_Login.value = ""
		self.mInput_Password.value = ""
	end

end

--按钮点击事件
--================================================================================================================================================================================

function HallAccountLoginPanel:OnClickCloseAccountLockPanel()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self:SetAccountLockPanel(false)
end

function HallAccountLoginPanel:SetAccountLockPanel(bol)
	self.m_Panel_Hall_AccountLockPanel:SetActive(bol)
end

function HallAccountLoginPanel:SetAccountLockTime(lockTime)
	self.m_Label_AccountLock.text = os.date("%M:%S",lockTime)
end

function HallAccountLoginPanel:OnAccountLockLimit(context)
	if context == nil then return end
	if context.m_data == nil then return end
	local lockTime = context.m_data[0]
	if lockTime > 0 then
		self:StartCountDown(lockTime)
		self:SetAccountLockPanel(true)
	end
end

function HallAccountLoginPanel:Update()
	if self.lockTime > 0 then
		self.nowTime = self.nowTime + Time.deltaTime
		if self.nowTime >= 1 then
			self.nowTime = 0
			self.lockTime = self.lockTime - 1
			self:SetAccountLockTime(self.lockTime)
			if self.lockTime <= 0 then
				self:StopCountDown()
			end
		end
	end
end

function HallAccountLoginPanel:StartCountDown(lockTime)
	self.nowTime = 0
	self.lockTime = lockTime
	self:SetAccountLockTime(self.lockTime)
	RenderMgr.Remove(self.updateName)
	RenderMgr.Add(function () self:Update() end, self.updateName)
end

function HallAccountLoginPanel:StopCountDown()
	RenderMgr.Remove(self.updateName)
	self:SetAccountLockPanel(false)
end

function HallAccountLoginPanel:OnClickRememberAccount()
	if self.m_Toggle_Remember.value then
		--记住
		PlayerPrefs.SetInt(GameConst.Key_UserAccount_Remember,1)
	else
		--不记住
		PlayerPrefs.SetInt(GameConst.Key_UserAccount_Remember,0)
	end
end


function HallAccountLoginPanel:OnClickForgetButton( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.ForgotPsd)
	self.m_Panel_Hall_NotePanel:SetActive(true)
end

function HallAccountLoginPanel:OnClickCloseNotePanel()
	self.m_Panel_Hall_NotePanel:SetActive(false)
end

function HallAccountLoginPanel:OpenServicePanel()
	self.m_Panel_Hall_ServiceTips:SetActive(true)
end

function HallAccountLoginPanel:OnClickCloseServicePanel()
	self.m_Panel_Hall_ServiceTips:SetActive(false)
end

function HallAccountLoginPanel:OnChange_RemberPsd( )
	PlayerPrefs.SetInt(AppConst.Key_RemberPassword, 1)
	PlayerPrefs.SetString(AppConst.Key_UserPassword, "")
end

function HallAccountLoginPanel:OnButton_Close( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallAccountLoginPanel:OnButton_Login( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)

	if self.lockTime > 0 then
		self:SetAccountLockPanel(true)
		return
	end

	StartCoroutine(function ()
		self.mButton_LoginBox.enabled=false
		yield_return(CS.UnityEngine.WaitForSeconds(3))
		self.mButton_LoginBox.enabled=true
	end)

	local account = TrimStr(self.mInput_Login.value)
	local password = TrimStr(self.mInput_Password.value)

    --不区分大小写
	account = string.lower(account)

	if account == "" then 
		UIManager:GetInstance():ShowNoteMessage("User_Account_Null")
		return
	end

	if password == "" then
		UIManager:GetInstance():ShowNoteMessage("password_not_blank")
		return
	end
	if password~=PlayerPrefs.GetString(AppConst.Key_UserPassword, "") then
		password = CommonUtil.GetMd5StaticLoginPasswd(account, password, CommonUtil.mLoginSalt)
	end

	local successFunc = function ()
		-- if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Login then
		-- 	HallAccountLoginController:GetInstance():Client_Popup_Notes(function (retcode)
		-- 		if retcode ~= 0 then
		-- 			LoginPanelModel:GetInstance():AcocountLogin(account,password)
		-- 		end
		-- 	end)
		-- end
		LoginPanelModel:GetInstance():AcocountLogin(account,password)
	end
	
	local failFunc = function ()
		self:OpenServicePanel()
	end

	HallAccountLoginController:GetInstance():Client_Popup_Notes(function ()
		HallAccountLoginController:GetInstance():SendCheckIPAndAgentID(account,successFunc,failFunc)
	end)

	--去请求IP限制接口
	
	--Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL, account, password)
end

function HallAccountLoginPanel:OnRegisterAccount()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local reCode=HallRegistByPhoneModel:GetInstance():GetRecommendCode() or 0
	if ConfigInfoMgr.IsRecommentLogin and reCode==0 then
		local cb=function()
			UIManager:GetInstance():HidePanel(self.mPanelID)
			
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRegistByPhone)
			
		end
		LuaEvent:DispatchEvent(EventName.LOGIN_SHOWRECOMMENDCODE,cb)
	else
		UIManager:GetInstance():HidePanel(self.mPanelID)
	
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRegistByPhone)
	
	end
end

function HallAccountLoginPanel:OnSelect_Password( )
	self.mtempPsd = self.mInput_Password.value
end

function HallAccountLoginPanel:OnDeSelect_Password( )
	local psd = self.mInput_Password.value
	if psd ~= self.mtempPsd then
		if self.mIsSavedPsd == true then
			self.mIsSavedPsd = false
		end
	end
end

--================================================================================================================================================================================
--end


function HallAccountLoginPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self, callBack)
	self:PlayOpenAni()
	self:SetPanelData()
	
end

function HallAccountLoginPanel:PlayOpenAni( ... )
	-- body
	self.TweenAn.enabled=true
	self.TweenAn:ResetToBeginning()
	self.TweenAn:PlayForward()
end


--设置子panel的深度
 function HallAccountLoginPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end



function HallAccountLoginPanel:__delete( ... )
	self:RemoveEvent()
	self.mLabel_CheckBoxName = nil
	self.mInput_Login = nil
	self.mInput_Password = nil
	self.mToggle_RemberPsd = nil
	self.mIsSavedPsd = nil
	self.mtempPsd = nil
end
