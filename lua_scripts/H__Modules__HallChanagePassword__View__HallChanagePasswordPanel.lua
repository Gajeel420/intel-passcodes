HallChanagePasswordPanel = HallChanagePasswordPanel or BaseClass(LuaPanel)

function HallChanagePasswordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.ForgotPsd].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.ForgotPsd].path
	self.mPanelID = UIPanelDefine.EWndID.ForgotPsd
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallChanagePasswordPanel:InitUI()
	self.countDown=60 --倒计时总长度
	local mTran = self.obj.transform
	self.updateName = "HallChanagePasswordPanel_GetCode"
	self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
	self.mButton_Sure = mTran:Find("Content/Button_Sure").gameObject

	self.mPhoneNoInput = mTran:Find("Content/Account/Input").gameObject:GetComponent(typeof(UIInput))
	self.mCodeInput = mTran:Find("Content/Code/Input").gameObject:GetComponent(typeof(UIInput))
	self.mPsdInput = mTran:Find("Content/Password/Input").gameObject:GetComponent(typeof(UIInput))
	self.mPsdAgainInput = mTran:Find("Content/Sure/Input").gameObject:GetComponent(typeof(UIInput))

	self.mButton_Send =  mTran:Find("Content/Code/GetCode").gameObject
	self.mSprite_send = self.mButton_Send:GetComponent(typeof(UISprite))
	self.mBox_send = self.mButton_Send:GetComponent(typeof(BoxCollider))
	self.mLabel_CountDown =  mTran:Find("Content/Code/GetCode/LabelDown"):GetComponent(typeof(UILabel))
	self.mLabel_tips =  mTran:Find("Content/Code/GetCode/Label").gameObject
	self.mLabel_CountDown.gameObject:SetActive(false)
	self.mLabel_tips:SetActive(true)
	UIEventListener.Get(self.mButton_Close).onClick = function() self:OnButton_Close() end
	UIEventListener.Get(self.mButton_Sure).onClick = function() self:OnButton_Sure() end
	UIEventListener.Get(self.mButton_Send).onClick = function() self:GetPhoneCode() end
	

	self.PhoneNo = ""
	self.password = ""
	self.mCode =nil
	self.restTime = 0
	LuaPanel.InitUI(self)
	
end


function HallChanagePasswordPanel:OnButton_Close(obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	-- body
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallChanagePasswordPanel:GetPhoneCode( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	local onComplete = function ( backCode )
		-- body
		self.mCode = tostring(backCode)
		self:StartCountDown()
	end
	self.PhoneNo = TrimStr(self.mPhoneNoInput.value)
	if self.PhoneNo == nil  or self.PhoneNo == "" then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end
	HallRegistByPhoneModel:GetInstance():GetEmsCode(self.PhoneNo,onComplete,self)
	
end

function HallChanagePasswordPanel:OnButton_Sure( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	local PhoneNo = TrimStr(self.mPhoneNoInput.value)
	self.password = TrimStr(self.mPsdInput.value)
	local code = TrimStr(self.mCodeInput.value)
	if PhoneNo == nil  then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end
	if self.mCode==nil then
		UIManager:GetInstance():ShowNoteMessage("get_code_first")
		return
	end

	if code == "" or self.mCode ~= code then
		UIManager:GetInstance():ShowNoteMessage("EmsCodeError")
		return
	end

	if self.PhoneNo ~= PhoneNo then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end

	if self.password == "" then
		UIManager:GetInstance():ShowNoteMessage("password_blank")
		return
	end

	local psdlen = string.len(self.password) 
	if psdlen < 6 or psdlen > 20 then --密码的最大最小值 (等一个GlobleConst 类)
		UIManager:GetInstance():ShowNoteMessage("User_Psd_Len_Limit")
		return
	end

	if self.password~=self.mPsdAgainInput.value then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Twice_Psd_Different"))
		return
	end
	local onComplete = function (  )
		-- body
		self:FindPswSuccess()
	end
	HallChanagePasswordModel:GetInstance():FindPassword(self.PhoneNo,self.password,self.mCode,onComplete,self)
	
end

function HallChanagePasswordPanel:FindPswSuccess()
	self.mCode =nil --清空验证码！
	local account=self.PhoneNo
	local password=self.password
	UIManager:GetInstance():HidePanel(self.mPanelID)
	local staticPassword = CommonUtil.GetMd5StaticLoginPasswd(account, password, CommonUtil.mLoginSalt)
	-- UIManager.GetInstance():ShowNetWorkMessage("Logining","登录失败",8)
	Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL, account, staticPassword)
end



function HallChanagePasswordPanel:SetCountDown()
	-- body
	self.restTime = self.restTime - Time.deltaTime
	if self.restTime > 0 then
		self.mLabel_CountDown.gameObject:SetActive(true)
		self.mLabel_tips:SetActive(false)
		self.mLabel_CountDown.text = math.ceil(self.restTime) ..""
		self.mSprite_send.color = Color(0,1,1)
		self.mBox_send.enabled = false
	else
		self:ShopCountDown()
		self.mLabel_CountDown.gameObject:SetActive(false)
		self.mLabel_tips:SetActive(true)
		self.mSprite_send.color = Color(1,1,1)
		self.mBox_send.enabled = true
	end

end

function HallChanagePasswordPanel:Update()
	-- body
	self:SetCountDown()
end


function HallChanagePasswordPanel:StartCountDown()
	self.restTime=self.countDown
	RenderMgr.Add(function () self:Update() end,self.updateName)
end

function HallChanagePasswordPanel:ShopCountDown()
	RenderMgr.Remove(self.updateName)
end




--设置子panel的深度
 function HallChanagePasswordPanel:SetPanelDepth(depth)
 	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallChanagePasswordPanel:__delete( ... )
	self:ShopCountDown()
	
end
