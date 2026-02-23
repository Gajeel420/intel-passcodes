HallRegistByPhonePanel = HallRegistByPhonePanel or BaseClass(LuaPanel)

function HallRegistByPhonePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRegistByPhone].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRegistByPhone].path
	self.mPanelID = UIPanelDefine.EWndID.HallRegistByPhone
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallRegistByPhonePanel:InitUI()
	self.countDown=60 --倒计时总长度
	self.restTime = 0
	self.updateName = "registByPhone"
	local mTran = self.obj.transform
	self.closeBtn = mTran:Find("Content/Button_Close").gameObject
	self.reginstBtn = mTran:Find("Content/Button_Sure").gameObject
	self.randomBtn = mTran:Find("Content/Name/Radom").gameObject
	self.getCodeBtn = mTran:Find("Content/Code/GetCode").gameObject

	self.getCodeSprite = self.getCodeBtn:GetComponent(typeof(UISprite))
	self.getCodeDownLabel = mTran:Find("Content/Code/GetCode/LabelDown").gameObject:GetComponent(typeof(UILabel))
	self.objGetCodeLabel = mTran:Find("Content/Code/GetCode/Label").gameObject
	self.getCodeBoxC = self.getCodeBtn:GetComponent(typeof(BoxCollider))

	self.nameInput = mTran:Find("Content/Name/Input").gameObject:GetComponent(typeof(UIInput))
	self.accountInput = mTran:Find("Content/Account/Input").gameObject:GetComponent(typeof(UIInput))
	self.codeInput = mTran:Find("Content/Code/Input").gameObject:GetComponent(typeof(UIInput))
	self.passWordInput = mTran:Find("Content/Password/Input").gameObject:GetComponent(typeof(UIInput))

	local  name=ConfigModuleModel:GetInstance():GetRandomName()
	self.nameInput.value=name or ""
	self:AddEvent()
	UIEventListener.Get(self.closeBtn).onClick=function() self:OnClose() end
	UIEventListener.Get(self.randomBtn).onClick=function() self:OnRandomNameBtn() end
	UIEventListener.Get(self.getCodeBtn).onClick=function() self:OnGetCodeBtn() end
	UIEventListener.Get(self.reginstBtn).onClick=function() self:OnRegistBtn() end

	self.TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))

	self:SetCountDown()

	self.phoneNo = nil
	self.mCode = nil
	LuaPanel.InitUI(self)

end

function HallRegistByPhonePanel:AddEvent()
	HallRegistByPhoneModel:GetInstance():AddEventListener(HallRegistByPhoneModel.EventName_RegisterAccountSuccess,self.RegisterAccountSuccess,self)
end


function HallRegistByPhonePanel:RemoveEvent()
	HallRegistByPhoneModel:GetInstance():RemoveEventListener(HallRegistByPhoneModel.EventName_RegisterAccountSuccess,self.RegisterAccountSuccess,self)
end


function HallRegistByPhonePanel:RegisterAccountSuccess(context)
	self.mCode=nil --清空验证码!
	self.phoneNo = nil
	local account=context[1]
	local password=context[2]
	self:ResetInput()
	local addTabel={}
	addTabel.account=account
	addTabel.password=password
	SystemSetting.GetInstance():AddAccountAndPasswordTable(addTabel)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallRegistByPhone)
	local staticPassword = CommonUtil.GetMd5StaticLoginPasswd(account, password, CommonUtil.mLoginSalt)
	-- Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL, account, staticPassword)
	LoginPanelModel:GetInstance():AcocountLogin(account,staticPassword)
end


function HallRegistByPhonePanel:ResetInput()
	self.nameInput.value=""
	self.accountInput.value=""
	self.codeInput.value=""
	self.passWordInput.value=""
end

---获取短信验证码
function HallRegistByPhonePanel:OnGetCodeBtn( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	local onComplete = function ( backCode )
		-- body
		print("获取验证码返回",backCode)
		self.mCode = tostring(backCode)
		self:StartCountDown()
	end
	self.phoneNo = TrimStr(self.accountInput.value)
	if self.phoneNo == nil or self.phoneNo == "" then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end
	HallRegistByPhoneModel:GetInstance():GetEmsCode(self.phoneNo,onComplete,self)
	
end

--随机生成用户昵称
function HallRegistByPhonePanel:OnRandomNameBtn()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	local  name=ConfigModuleModel:GetInstance():GetRandomName()
	self.nameInput.value=name or ""
end

-- 关闭panel
function HallRegistByPhonePanel:OnClose( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	-- body
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallRegistByPhonePanel:OnRegistBtn( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	local account = TrimStr(self.accountInput.value)
	local psd = TrimStr(self.passWordInput.value)
	-- local nickName = TrimStr(self.nameInput.value)	
	local nickName = account
	local emsCode = TrimStr(self.codeInput.value)

	if account == "" then
		UIManager:GetInstance():ShowNoteMessage("User_Account_Null")
		return
	end

	if nickName == "" then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("NickName_Null"))
		return
	end
	if psd == "" then
		UIManager:GetInstance():ShowNoteMessage("password_blank")
		return
	end

	if ConTainsSpecial(nickName) then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("UserName_SpecialChar"))
		return
	end

	if ConTainsSpecial(account) then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("UserAccount_SpecialChar"))
		return
	end

	if self.mCode==nil then
		UIManager:GetInstance():ShowNoteMessage("CheckCodeNoNull")
		return
	end

	if emsCode == "" then
		UIManager:GetInstance():ShowNoteMessage("EmsCode_Null")
		return
	end
	if emsCode ~= self.mCode then
		UIManager:GetInstance():ShowNoteMessage("EmsCodeError")
		return
	end

	if account ~= self.phoneNo then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return 
	end

	if GetStringLen(nickName)>HallDefine.ConstDefine.NickNameLen then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("NickName_Len_Out_Limit"))
		return
	end
	if string.len(account) > 14 then --账号最大长度 (等一个GlobleConst 类)
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Account_Len_Limit"))
		return
	end

	local psdlen = string.len(psd) 
	if psdlen < 6 or psdlen > 20 then --密码的最大最小值 (等一个GlobleConst 类)
		UIManager:GetInstance():ShowNoteMessage("User_Psd_Len_Limit")
		return
	end
	HallRegistByPhoneModel:GetInstance():ReqDataRequestRegister(account,psd,nickName,emsCode)
	
end

--设置子panel的深度
 function HallRegistByPhonePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallRegistByPhonePanel:ShowPanel( callBack )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self)
	self:PlayOpenAni()
end


function HallRegistByPhonePanel:PlayOpenAni( ... )
	-- body
	self.TweenAn.enabled=true
	self.TweenAn:ResetToBeginning()
	self.TweenAn:PlayForward()
end
function HallRegistByPhonePanel:HidePanel( callBack )
	-- body
	LuaPanel.HidePanel(self)
end


function HallRegistByPhonePanel:CountDown( ... )
	-- body
	if self.restTime > 0 then
		self.restTime = self.restTime - Time.deltaTime
		self:SetCountDown()
	end
end

function HallRegistByPhonePanel:SetCountDown()
	-- body

	if self.restTime > 0 then
		self.getCodeDownLabel.text = math.ceil(self.restTime)
		self.getCodeDownLabel.gameObject:SetActive(true)
		self.objGetCodeLabel:SetActive(false)
		self.getCodeSprite.color = Color(0,1,1)
		self.getCodeBoxC.enabled = false
	else
		self:ShopCountDown()
		self.getCodeDownLabel.gameObject:SetActive(false)
		self.objGetCodeLabel:SetActive(true)
		self.getCodeSprite.color = Color(1,1,1)
		self.getCodeBoxC.enabled = true
	end

end

function HallRegistByPhonePanel:Update()
	-- body
	self:CountDown()
end


function HallRegistByPhonePanel:StartCountDown()
	self.restTime=self.countDown
	RenderMgr.Add(function () self:Update() end,self.updateName)
end

function HallRegistByPhonePanel:ShopCountDown()
	RenderMgr.Remove(self.updateName)
end



function HallRegistByPhonePanel:__delete( ... )
	self:ShopCountDown()
	self:RemoveEvent()
end
