HallTurntablePanel =  BaseClass(LuaPanel)

function HallTurntablePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTurntable].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTurntable].path
	self.mPanelID = UIPanelDefine.EWndID.HallTurntable
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallTurntablePanel:InitUI()
	self:InitData()
	local mTran = self.obj.transform
	local mTranUI = mTran:Find("Content/Turntable_Back/Checked")
	if mTranUI ~= nil then
		self.mGameObjectCheced = mTranUI.gameObject
	end
	mTranUI = mTran:Find("Content/Turntable_Back/Turn_Table")
	if mTranUI ~= nil then
		self.mTurnTweenRotation = mTranUI:GetComponent(typeof(TweenRotation))
	end
	for i = 1, self.mItemCount do
		
		if i < 10 then
			mTranUI = mTran:Find("Content/Turntable_Back/Turn_Table/Label_0"..i)
		else
			mTranUI = mTran:Find("Content/Turntable_Back/Turn_Table/Label_"..i)
		end
		if mTranUI ~= nil then
			self.mTurnLabelList[i] = mTranUI:GetComponent(typeof(UILabel))
			self.mTurnLabelList[i].text = ""
		else
			self.mTurnLabelList[i] = 1
		end
	end
	
	mTranUI = mTran:Find("Content")
	if mTranUI ~= nil then
		self.mSpriteContent = mTranUI:GetComponent(typeof(UISprite))
		-- self.mAnimator = mTranUI:GetComponent(typeof(Animator))
		self.mTweenAlphaContent = mTranUI:GetComponent(typeof(TweenAlpha))
	end


	mTranUI = mTran:Find("Content/Effect")
	if mTranUI ~= nil then
		self.mGameObjectEffect = mTranUI.gameObject
	end

	mTranUI = mTran:Find("Content/Effect_Coin")
	if mTranUI ~= nil then
		self.mGameObjectCoinEffect = mTranUI.gameObject
	end

	mTranUI = mTran:Find("Content/Effect_Coin__Fly")
	if mTranUI ~= nil then
		self.mGameObjectCoinFlyEffect = mTranUI.gameObject
		self.mTweenCoinFly = mTranUI:GetComponent(typeof(TweenPosition))
	end

	mTranUI = mTran:Find("Content/Win")
	if mTranUI ~= nil then
		self.mGameObjectWin = mTranUI.gameObject
		self.mTweenWin = mTranUI:GetComponent(typeof(TweenScale))
	end

	mTranUI = mTran:Find("Content/Win/Win_BG/Label")
	if mTranUI ~= nil then
		self.mLabelWin = mTranUI:GetComponent(typeof(UILabel))
	end
	mTranUI = mTran:Find("Content/Win/Win_BG/Btn_Activity")
	if mTranUI ~= nil then
		self.mButtonActivityBox = mTranUI:GetComponent(typeof(BoxCollider))
		UIEventListener.Get(mTranUI.gameObject).onClick = function (gameObject)
			self:OnButonCollectCoins(gameObject)
		end
	end

	mTranUI = mTran:Find("Content/Turntable_Back/Btn_Activity")
	if mTranUI ~= nil then
		self.mButtonSpinBox = mTranUI:GetComponent(typeof(BoxCollider))
		self.mButtonSpinBox.enabled = false
		self.mButtonSprite = mTranUI:GetComponent(typeof(UISprite))
		UIEventListener.Get(mTranUI.gameObject).onClick = function (gameObject)
			self:OnButtonSpin(gameObject)
		end
	end

	mTranUI = mTran:Find("Content/Turntable_Back")
	if mTranUI ~= nil then
		self.mPanelTurnBack = mTranUI.gameObject
	end

	mTranUI = mTran:Find("Content/Btn_Close")
	if mTranUI ~= nil then
		UIEventListener.Get(mTranUI.gameObject).onClick = function (gameObject)
			self:OnButtonCloseClick(gameObject)
		end
	end
	mTranUI = mTran:Find("Content/Coin_Point")
	if mTranUI ~= nil then
		self.mCoinFlyTag = mTranUI
	end

	self.m_Ani = mTran:Find("Content"):GetComponent(typeof(Animator))
	self.m_Go_Claimnow = mTran:Find("Content/Turntable_Back/Btn_Claimnow").gameObject
	self.mButtonClaimnowBox = self.m_Go_Claimnow:GetComponent(typeof(BoxCollider))
	UIEventListener.Get(self.m_Go_Claimnow).onClick = function (gameObject)
		self:OnButonClaimnow(gameObject)
	end

	mTranUI = nil
	mTran = nil
	self:InitView()
	self:AddEvent()
	LuaPanel.InitUI(self)
end



function HallTurntablePanel:AddEvent()
	
end

function HallTurntablePanel:RemoveEvent()
	
end


function HallTurntablePanel:InitData()
	self.mTurnLabelList = {}
	self.mTempVector3 = Vector3.zero
	self.mItemCount = 20
	self.CicleAngle = 360
	self.mItemAngle = self.CicleAngle / self.mItemCount
	self.mWinIndex = 0
	self.mSpinCount = 5
	self.CanClose = true
	self.mIsCanClickStart = false
end

function HallTurntablePanel:InitView()
	self.mGameObjectCheced:SetActive(false)
	self.mTurnTweenRotation.enabled = false
	-- self.mAnimator.enabled = false
	self.mLabelWin.text = "0"
	self.mTweenWin.enabled = false
	self.mGameObjectWin:SetActive(false)
	self.mTweenCoinFly.enabled = false
	self.mGameObjectCoinFlyEffect:SetActive(false)
	self.mGameObjectCoinEffect:SetActive(false)
	self.mTweenAlphaContent.enabled = false
	self.mGameObjectCoinEffect.transform.localPosition = Vector3.zero
	self.mSpriteContent.alpha = 1
	self.mButtonSpinBox.enabled = false
	self.mButtonClaimnowBox.enabled = true
	self.mButtonActivityBox.enabled = true
	self.mButtonSprite.color = Color(1,1,1)
end

function HallTurntablePanel:OnButonClaimnow(gameObject)
	-- 先播放动画再转动
	self.mButtonClaimnowBox.enabled = false
	self.m_Ani:Play("Ani_StartSpin", 0, 0)
	RenderMgr.AddInterval(function ()
		self:OnButtonSpin()
	end,"HallTurntablePanel:OnButonClaimnow", 1, 1.8)
end

function HallTurntablePanel:OnButonCollectCoins(gameObject)
	self.mButtonActivityBox.enabled = false
	self.mGameObjectCoinEffect:SetActive(true)
	HallGroupController:GetInstance().view.panel:RequestLuckyWhell()
	StartCoroutine(function ()
		yield_return(WaitForSeconds(1))
		self.mGameObjectCoinFlyEffect:SetActive(true)
		self.mGameObjectEffect:SetActive(false)
		self.mTweenCoinFly.from = Vector3.zero
		self.mTweenCoinFly.to = self.mCoinFlyTag.localPosition
		self:PlayTween(self.mTweenCoinFly,self.OnCoinFlyFinish,self)
		self.mTweenAlphaContent.duration= 3
		self:PlayTween(self.mTweenAlphaContent,self.ContentTweenAlphaFinish,self)
	end)
end

function HallTurntablePanel:OnCoinFlyFinish()
	PlayerInfoController:GetInstance():RequestGetUserMoney()
	self.mGameObjectCoinEffect:SetActive(false)
	self.mGameObjectCoinEffect.transform.localPosition = self.mCoinFlyTag.localPosition
	self.mGameObjectCoinEffect:SetActive(true)
end

function HallTurntablePanel:ContentTweenAlphaFinish()
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallTurntablePanel:OnButtonSpin(gameObject)
	self.mButtonSpinBox.enabled = false
	self.mIsCanClickStart = true
	StartCoroutine(function ()
		yield_return(WaitForSeconds(2))
		if self.mIsCanClickStart then
			self.mButtonSpinBox.enabled = true
		end
	end)
	HallTurntableController:GetInstance():ReqestLuckyWhellResult()
end


function HallTurntablePanel:RequestLuckyWhelBack()
	if HallTurnTableModel:GetInstance().mLuckyWhellResult.m_sResult == -301 then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Device_Get_Limit"))
		return
	elseif HallTurnTableModel:GetInstance().mLuckyWhellResult.m_sResult == -302 then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Device_Get_Limit_2"))
		return
	end
	
	self.mIsCanClickStart = false
	self.CanClose = false
	self.mWinIndex = HallTurnTableModel:GetInstance().mLuckyWhellResult.m_ucPrizeIndex
	self.mLabelWin.text = NumberFormat(HallGoldRateSToC(HallTurnTableModel:GetInstance().mLuckyWhellResult.m_n64PrizeMoney))
	self.mButtonSpinBox.enabled = false
	self.mButtonSprite.color = Color(0.7,0.7,0.7)
	self.mTempVector3 = Vector3.zero
	self.mTempVector3.z = self.CicleAngle * self.mSpinCount + self.mItemAngle * self.mWinIndex
	self.mTurnTweenRotation.enabled = true
	self.mTurnTweenRotation.from = Vector3.zero
	self.mTurnTweenRotation.to = self.mTempVector3
	self.mTurnTweenRotation.duration = 9
	-- self.mAnimator.enabled = true
	self.mGameObjectEffect:SetActive(true)
	-- self.mAnimator:Play("Turntable_Spin",0,0)
	self:PlayTween(self.mTurnTweenRotation,self.SpinFinish,self)
end



function HallTurntablePanel:SpinFinish()
	if HallTurnTableModel:GetInstance().mLuckyWhellResult.m_n64PrizeMoney > 0 then
		StartCoroutine(function ()
			self.mGameObjectCheced:SetActive(true)
			yield_return(WaitForSeconds(1))
			self.mGameObjectWin:SetActive(true)
			self:PlayTween(self.mTweenWin)
		end)
	else
		self.CanClose = true
	end
end



--- 播放Tween动画
function HallTurntablePanel:PlayTween(Tween,back,context)
	Tween:ResetToBeginning()
	Tween.enabled = true
	Tween:PlayForward()
	Tween:SetOnFinished(function ()
		if back ~= nil then
			back(context)
		end
	end)
end

function HallTurntablePanel:OnButtonCloseClick(gameObject)
	if self.CanClose  then
		HallGroupController:GetInstance().view.panel:RequestLuckyWhell()
		PlayerInfoController:GetInstance():RequestGetUserMoney()
		UIManager:GetInstance():HidePanel(self.mPanelID)
	end
end


function HallTurntablePanel:SetPanelDepth(depth)
    LuaPanel.SetPanelDepth(self,depth)
	SetPanelstartingRenderQueue(self.mPanelTurnBack,depth+5)
	SetPanelstartingRenderQueue(self.mGameObjectWin,depth+10)
end

function HallTurntablePanel:ShowPanel()
	--self:SetTurnTablePanelData()
	LuaPanel.ShowPanel(self)	
end

function HallTurntablePanel:SetTurnTablePanelData()
	if HallTurnTableModel:GetInstance().mLuckyWhellResult ~= nil then
		for i = 1, self.mItemCount do
			-- body
			if self.mTurnLabelList[i] ~= 1 then
				if  HallTurnTableModel:GetInstance().mLuckyWhellResult.mLuckyWhell[i] ~= 0 then
					self.mTurnLabelList[i].text = NumberFormat(HallGoldRateSToC(HallTurnTableModel:GetInstance().mLuckyWhellResult.mLuckyWhell[i]))
				end
			end
		end
	end
end

function HallTurntablePanel:HidePanel()
	LuaPanel.HidePanel(self)
	PlayerInfoController:GetInstance():RequestGetUserMoney()
	--self:InitData()
	self.mTurnTweenRotation.transform.localEulerAngles = Vector3.zero
	self.CanClose = true
	self:InitView()
	self:RemoveEvent()
end


function HallTurntablePanel:__delete( ... )
	
end
