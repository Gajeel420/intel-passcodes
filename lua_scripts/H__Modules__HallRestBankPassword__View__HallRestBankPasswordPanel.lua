HallRestBankPasswordPanel = HallRestBankPasswordPanel or BaseClass(LuaPanel)

function HallRestBankPasswordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallResetBankPassword].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallResetBankPassword].path
	self.mPanelID = UIPanelDefine.EWndID.HallResetBankPassword
	self.mPanelType = UIPanelDefine.PanelType.FourLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallRestBankPasswordPanel:InitUI()
	local mTran = self.obj.transform
	self.updateName = "HallRestBankPasswordPanel_GetCode"
	self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
	self.mButton_Sure = mTran:Find("Content/Button_Sure").gameObject
	self.mPhoneNoInput = mTran:Find("Content/Account/Input").gameObject:GetComponent(typeof(UIInput))
	self.mCodeInput = mTran:Find("Content/Code/Input").gameObject:GetComponent(typeof(UIInput))
	self.mPsdInput = mTran:Find("Content/Password/Input").gameObject:GetComponent(typeof(UIInput))
	self.mPsdAgainInput = mTran:Find("Content/Sure/Input").gameObject:GetComponent(typeof(UIInput))
	self.mButton_Send =  mTran:Find("Content/Code/GetCode").gameObject
	self.mSprite_send = self.mButton_Send:GetComponent(typeof(UISprite))
	self.mBox_send = self.mButton_Send:GetComponent(typeof(BoxCollider))
	self.mLabel_CountDown =  mTran:Find("Content/Code/GetCode/Label"):GetComponent(typeof(Localize))--:GetComponent(typeof(UILabel))
	self.mLabel_CountDown:SetTerm("CLIENT_TIPS_12")
	UIEventListener.Get(self.mButton_Close).onClick = function() self:OnButton_Close() end

	UIEventListener.Get(self.mButton_Sure).onClick = function() self:OnButton_Sure() end
	UIEventListener.Get(self.mButton_Send).onClick = function() self:GetPhoneCode() end
	self.PhoneNo = ""
	self.password = ""
	self.mCode = ""
	self.restTime = 0
	--self.mLabel_CountDown.text="获取"
	LuaPanel.InitUI(self)
end


function HallRestBankPasswordPanel:ShowPanel( callBack )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
end	

function HallRestBankPasswordPanel:OnButton_Close(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    --SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallRestBankPasswordPanel:GetPhoneCode( ... )
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	local onComplete = function ( backCode )
		-- body
		print("code=",backCode)
		self.mCode = backCode
		self.restTime = 60
		self:AddUpdate()
		
	end
	self.PhoneNo = self.mPhoneNoInput.value
	if self.PhoneNo == "" then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end
	HallRegistByPhoneModel:GetInstance():GetEmsCode(self.PhoneNo,onComplete,self)
end



function HallRestBankPasswordPanel:OnButton_Sure( obj )
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- body
	local PhoneNo = self.mPhoneNoInput.value
	self.password = self.mPsdInput.value
	local code = self.mCodeInput.value
	if PhoneNo == nil  then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end

	if self.PhoneNo ~= PhoneNo then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return
	end

	if code == "" or self.mCode ~= code then
		UIManager:GetInstance():ShowNoteMessage("EmsCodeError")
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
		UIManager:GetInstance():ShowNoteMessage("两次输入密码不一致！")
		return
	end

	local onComplete = function ( )
		-- body
		self:RestPswSuccess()
	end

	HallRestBankPasswordModel.GetInstance():RestBankPassword(self.PhoneNo,self.password,onComplete)
end

function HallRestBankPasswordPanel:RestPswSuccess()
	UIManager:GetInstance():ShowNoteMessage("修改银行密码成功！");
	self.mPhoneNoInput.value = "" 
	self.mCodeInput.value="" 
	self.mPsdInput.value =""
	self.mPsdAgainInput.value=""
	self.mCode = ""
	self.PhoneNo = ""
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallRestBankPasswordPanel:SetCountDown()
	-- body
	self.restTime = self.restTime - Time.deltaTime
	if self.restTime > 0 then
		--self.mLabel_CountDown.text = math.ceil(self.restTime) ..""
		self.mSprite_send.color = Color(0,1,1)
		self.mBox_send.enabled = false
	else
		--self.mLabel_CountDown.text="获取"
		self.mLabel_CountDown:SetTerm("CLIENT_TIPS_12")
		self.mSprite_send.color = Color(1,1,1)
		self.mBox_send.enabled = true
		self:RemoveUpdate()
	end

end

function HallRestBankPasswordPanel:Update()
	-- body
	self:SetCountDown()
end

function HallRestBankPasswordPanel:AddUpdate( ... )
	-- body
	RenderMgr.Add(function () self:Update() end,self.updateName)

end

function HallRestBankPasswordPanel:RemoveUpdate( ... )
	-- body
	RenderMgr.Remove(self.updateName)
end

--设置子panel的深度
 function HallRestBankPasswordPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallRestBankPasswordPanel:__delete( ... )
	
end
