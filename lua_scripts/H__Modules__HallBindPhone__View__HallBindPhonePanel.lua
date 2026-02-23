HallBindPhonePanel = HallBindPhonePanel or BaseClass(LuaPanel)

function HallBindPhonePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBindPhone].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBindPhone].path
	self.mPanelID = UIPanelDefine.EWndID.HallBindPhone
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
	self.mPanelType = UIPanelDefine.PanelType.FourLevel
end

--初始化ui界面  ----必须实现
function HallBindPhonePanel:InitUI()
	self.countDown=60 --倒计时总时长
	local mTran = self.obj.transform

	local sureBtn=mTran:Find("Content/Button_Sure").gameObject
	local closeBtn=mTran:Find("Content/Button_Close").gameObject

	self.mButton_Send =  mTran:Find("Content/Code/GetCode").gameObject
	self.mSprite_send = self.mButton_Send:GetComponent(typeof(UISprite))
	self.mBox_send = self.mButton_Send:GetComponent(typeof(BoxCollider))

	self.phoneInput=mTran:Find("Content/Account/Input"):GetComponent(typeof(UIInput))
	self.captchInput=mTran:Find("Content/Code/Input"):GetComponent(typeof(UIInput))
	self.pwInput=mTran:Find("Content/Password/Input"):GetComponent(typeof(UIInput))
	self.mInput_PwAgainInput=mTran:Find("Content/Sure/Input"):GetComponent(typeof(UIInput))

	--self.CDLabel=mTran:Find("Content/Code/GetCode/Label"):GetComponent(typeof(UILabel))
	--self.CDLabel.text="获取"
	self.CDLabel=mTran:Find("Content/Code/GetCode/Label"):GetComponent(typeof(Localize))
	self.CDLabel:SetTerm("CLIENT_TIPS_12")
	UIEventListener.Get(self.mButton_Send).onClick = function() self:OnButton_Send() end
	UIEventListener.Get(sureBtn).onClick = function() self:OnButton_Sure() end
	UIEventListener.Get(closeBtn).onClick = function() self:OnButton_Close() end

	local list_tweenList={}
	local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	self.updateName="HallBindPhonePanel:Update"
	self.restTime=0	--验证码剩余时间
	self.mCode=nil	--获取到的验证码
	self.mPhoneNo = nil
	LuaPanel.InitUI(self)
	self:AddEvent()
end

function HallBindPhonePanel:AddEvent()
	HallBindPhoneModel:GetInstance():AddEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
end

function HallBindPhonePanel:RemoveEvent()
	HallBindPhoneModel:GetInstance():RemoveEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
end




function HallBindPhonePanel:OnButton_Send( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	if self:CheckPhoneInput()==false then
		return
	end
	
	local onComplete = function ( backCode )
		self.mCode = backCode
		print(self.mCode)
		self:StartCountDown()
	end
	self.mPhoneNo = self.phoneInput.value
	HallRegistByPhoneModel:GetInstance():GetEmsCode(self.mPhoneNo,onComplete,self)
	
end


function HallBindPhonePanel:StartCountDown()
	self.restTime=self.countDown
	RenderMgr.Add(function () self:Update() end,self.updateName)
end

function HallBindPhonePanel:ShopCountDown()
	RenderMgr.Remove(self.updateName)
end





function HallBindPhonePanel:Update()
	-- body
	self:CountDown()
end

function HallBindPhonePanel:CountDown( ... )
	-- body
	if self.restTime > 0 then
		self.restTime = self.restTime - Time.deltaTime
		self:SetCountDown()
	end
end

function HallBindPhonePanel:SetCountDown()
	-- body
	if self.restTime > 0 then
		--self.CDLabel.text=math.ceil(self.restTime) ..""
		self.mSprite_send.color = Color(0,1,1)
		self.mBox_send.enabled = false
	else
		self:ShopCountDown()
		self.CDLabel.text="获取"
		self.mSprite_send.color = Color(1,1,1)
		self.mBox_send.enabled = true
	end
end


function HallBindPhonePanel:OnButton_Sure( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- body
	if self:CheckAllInput()==false then
		return
	end
	--new
	local phone = TrimStr(self.phoneInput.value)
	local password = TrimStr(self.pwInput.value)
	HallBindPhoneModel:GetInstance():BindPhone(phone,password)
	
end

function HallBindPhonePanel:OnBindPhoneSuccess(data)
	self.mCode=nil --清空验证码！
	self.mPhoneNo = nil
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallBindPhone)
	
end



function HallBindPhonePanel:OnButton_Close( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallBindPhone)
end

function HallBindPhonePanel:CheckPhoneInput( ... )
	-- body
	local phoneNo = self.phoneInput.value
	if phoneNo == ""  then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return false
	end

	return true
end

function HallBindPhonePanel:CheckAllInput( )
	local account = TrimStr(self.captchInput.value)
	local psd = TrimStr(self.pwInput.value)
	local padAgain=TrimStr(self.mInput_PwAgainInput.value)
	local phoneNo = self.phoneInput.value
	


	if self.mCode==nil then
		UIManager:GetInstance():ShowNoteMessage("get_code_first")
		return false
	end

	if account == "" then
		UIManager:GetInstance():ShowNoteMessage("enter_code")
		return false
	end
	if account~=self.mCode then --账号最大长度 (等一个GlobleConst 类)
		UIManager:GetInstance():ShowNoteMessage("code_wrong")
		return false
	end

	if psd == "" then
		UIManager:GetInstance():ShowNoteMessage("enter_password1")
		return false
	end
	local psdlen = string.len(psd) 
	if psdlen < 6 or psdlen > 20 then --密码的最大最小值 (等一个GlobleConst 类)
		UIManager:GetInstance():ShowNoteMessage("User_Psd_Len_Limit")
		return false
	end
	if phoneNo == "" or phoneNo ~= self.mPhoneNo then
		UIManager:GetInstance():ShowNoteMessage("correct_number")
		return false
	end
	if psd~= padAgain then
		UIManager:GetInstance():ShowNoteMessage("Twice_Psd_Different")
		return false
	end
	return true

end


--设置子panel的深度
 function HallBindPhonePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end


function HallBindPhonePanel:ShowPanel(callBack)
	-- body
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
	self.mTweenPlayer:ParallelPlay(false)
end
function HallBindPhonePanel:HidePanel( callBack )
	-- body
	LuaPanel.HidePanel(self)
end


function HallBindPhonePanel:__delete( ... )
	self:ShopCountDown()
	self:RemoveEvent()
end
