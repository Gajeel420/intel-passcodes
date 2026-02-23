HallPhoneVerificationPanel = HallPhoneVerificationPanel or BaseClass(LuaPanel)

function HallPhoneVerificationPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPhoneVerification].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPhoneVerification].path
	self.mPanelID = UIPanelDefine.EWndID.HallPhoneVerification
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallPhoneVerificationPanel:InitUI()
    self.mFunction_VerificationSuccessCallBack=nil
    self.mString_Phone=nil
	self.countDown=60 --倒计时总长度
	local mTran = self.obj.transform
	self.updateName = "HallPhoneVerificationPanel_GetCode"
	self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
	self.mButton_Sure = mTran:Find("Content/Button_Sure").gameObject
	self.mCodeInput = mTran:Find("Content/Code/Input").gameObject:GetComponent(typeof(UIInput))
	self.mButton_Send =  mTran:Find("Content/Code/GetCode").gameObject
	self.mSprite_send = self.mButton_Send:GetComponent(typeof(UISprite))
	self.mBox_send = self.mButton_Send:GetComponent(typeof(BoxCollider))
	self.mLabel_CountDown =  mTran:Find("Content/Code/GetCode/Label"):GetComponent(typeof(UILabel))
	self.mLabel_CountDown.text="获取"
	UIEventListener.Get(self.mButton_Close).onClick = function() self:OnButton_Close() end
	UIEventListener.Get(self.mButton_Sure).onClick = function() self:OnButton_Sure() end
	UIEventListener.Get(self.mButton_Send).onClick = function() self:GetPhoneCode() end
	
	local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	self.mCode = nil
	self.restTime = 0
	LuaPanel.InitUI(self)
	
end


function HallPhoneVerificationPanel:OnButton_Close(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallPhoneVerificationPanel:GetPhoneCode( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	print("self.mString_Phoneself.mString_Phone:",self.mString_Phone)
	-- body
	local onComplete = function ( backCode )
		-- body
		self.mCode = backCode
		print("验证码：",self.mCode)
		self:StartCountDown()
	end
    if self.mString_Phone then
        HallRegistByPhoneModel:GetInstance():GetEmsCode(self.mString_Phone,onComplete,self)
    end

end

function HallPhoneVerificationPanel:OnButton_Sure( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- body
	local code = self.mCodeInput.value

	if self.mCode==nil then
		UIManager:GetInstance():ShowNoteMessage("get_code_first")
		return
	end


	if code == "" or self.mCode ~= code then
		UIManager:GetInstance():ShowNoteMessage("EmsCodeError")
		return
	end

    
	UIManager.GetInstance():HidePanel(self.mPanelID)
	self.mCode = nil
	if self.mFunction_VerificationSuccessCallBack then
		
        self.mFunction_VerificationSuccessCallBack()
    end

end




function HallPhoneVerificationPanel:SetCountDown()
	-- body
	self.restTime = self.restTime - Time.deltaTime
	if self.restTime > 0 then
		self.mLabel_CountDown.text = math.ceil(self.restTime) ..""
		self.mSprite_send.color = Color(0,1,1)
		self.mBox_send.enabled = false
	else
		self:ShopCountDown()
		self.mLabel_CountDown.text="获取"
		self.mSprite_send.color = Color(1,1,1)
		self.mBox_send.enabled = true
	end

end

function HallPhoneVerificationPanel:Update()
	-- body
	self:SetCountDown()
end



function HallPhoneVerificationPanel:StartCountDown()
	self.restTime=self.countDown
	RenderMgr.Add(function () self:Update() end,self.updateName)
end

function HallPhoneVerificationPanel:ShopCountDown()
	RenderMgr.Remove(self.updateName)
end



function HallPhoneVerificationPanel:SetVerificationData(phone,callBack)
    self.mString_Phone=phone
    self.mFunction_VerificationSuccessCallBack=callBack
end


function HallPhoneVerificationPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self.mCode =nil --清空验证码！
    self.mFunction_VerificationSuccessCallBack=nil 
    self.mCodeInput.value=""
    LuaPanel.ShowPanel(self,callBack)
	self.mTweenPlayer:ParallelPlay(false)
end

function HallPhoneVerificationPanel:HidePanel( callBack )
   LuaPanel.HidePanel(self,callBack)
end


















--设置子panel的深度
 function HallPhoneVerificationPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallPhoneVerificationPanel:__delete( ... )
	self:ShopCountDown()
	
end



