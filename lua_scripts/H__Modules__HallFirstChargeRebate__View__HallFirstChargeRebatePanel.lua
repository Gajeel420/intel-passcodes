HallFirstChargeRebatePanel = HallFirstChargeRebatePanel or BaseClass(LuaPanel)

function HallFirstChargeRebatePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFirstChargeRebate].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFirstChargeRebate].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallFirstChargeRebate
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallFirstChargeRebatePanel:InitUI()
	local mTran = self.obj.transform
	self.CurrentProgressType = 0
	local mTranUI = mTran:Find("Content/Button_Close")
	if mTranUI ~= nil then
		self.mButton_Close = mTranUI.gameObject
		UIEventListener.Get(self.mButton_Close).onClick = function(go) self:OnButtonClose(go) end
	end

	mTranUI = mTran:Find("Content/Button_Participate")
	if mTranUI ~= nil then
		self.mButton_Participate = mTranUI.gameObject
		self.mButton_Participate:SetActive(false)
		UIEventListener.Get(self.mButton_Participate).onClick = function(go) self:OnButtonParticipate(go) end
	end

	mTranUI = mTran:Find("Content/Button_Recharge")
	if mTranUI ~= nil then
		self.mButton_Recharge = mTranUI.gameObject
		self.mButton_Recharge:SetActive(false)
		-- self.mBox_recharge = self.mButton_Recharge:GetComponent(typeof(BoxCollider))
		-- self.mSprite_recharge = self.mButton_Recharge:GetComponent(typeof(UISprite))
		UIEventListener.Get(self.mButton_Recharge).onClick = function(go) self:OnButtonRecharge(go) end
	end

	mTranUI = mTran:Find("Content/Button_Reeive")
	if mTranUI ~= nil then
		self.mButton_Reeive = mTranUI.gameObject
		self.mButton_Reeive:SetActive(false)
		self.mSprite_Reeive = self.mButton_Reeive:GetComponent(typeof(UISprite))
		UIEventListener.Get(self.mButton_Reeive).onClick = function(go) self:OnButtonReeive(go) end
	end

	

	mTranUI = mTran:Find("Content/Ani")
	if mTranUI ~= nil then
		self.mSlider_progress = mTranUI.gameObject:GetComponent(typeof(UISlider))
		self.mSlider_progress.value = 0
	end

	mTranUI = mTran:Find("Content/Sprite_Box")
	if mTranUI ~= nil then
		self.mObj_AllBox = mTranUI.gameObject
		self.mObj_AllBox:SetActive(false)
	end

	mTranUI = mTran:Find("Content/Sprite_Box/SpriteBox_01")
	if mTranUI ~= nil then
		self.mObj_BoxOne = mTranUI.gameObject
		self.mObj_BoxOne:SetActive(false)
	end

	mTranUI = mTran:Find("Content/Sprite_Box/SpriteBox_02")
	if mTranUI ~= nil then
		self.mObj_BoxTow = mTranUI.gameObject
		self.mObj_BoxTow:SetActive(false)
	end

	mTranUI = mTran:Find("Content/Sprite_Box/SpriteBox_03")
	if mTranUI ~= nil then
		self.mObj_BoxThree = mTranUI.gameObject
		self.mObj_BoxThree:SetActive(false)
	end

	mTranUI = mTran:Find("Content/Sprite_Box/Lable_BG/Label")
	if mTranUI ~= nil then
		self.mLabel_Money = mTranUI.gameObject:GetComponent(typeof(UILabel))
		self.mLabel_Money.text = 0
	end

	mTranUI = mTran:Find("Content/Sprite_Box/Lable_BG")
	if mTranUI ~= nil then
		self.mLabel_BG = mTranUI.gameObject
		self.mLabel_BG:SetActive(false)
	end


	mTranUI = mTran:Find("Content/Sprite_Lable/Label")
	if mTranUI ~= nil then
		self.mLabel_progress = mTranUI.gameObject:GetComponent(typeof(UILabel))
		self.mLabel_progress.text = "0/0"
	end

	mTranUI = mTran:Find("Content/Tex/Spine_Gril")
	if mTranUI ~= nil then
		self.mRenderQueue = SZUIRenderQueue.New(mTranUI.gameObject)
	end
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	LuaPanel.InitUI(self)
end

function HallFirstChargeRebatePanel:ResetPanel()
	-- body
	
	self.mButton_Participate:SetActive(false)
	self.mButton_Recharge:SetActive(false)
	self.mButton_Reeive:SetActive(false)
	self.mSlider_progress.value = 0
	self.mObj_BoxOne:SetActive(false)
	self.mObj_BoxTow:SetActive(false)
	self.mObj_BoxThree:SetActive(false)
	self.mLabel_Money.text = 0
	self.mLabel_BG:SetActive(false)
	self.mLabel_progress.text= "0/0"
end


function HallFirstChargeRebatePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	if self.mRenderQueue ~= nil then
		self.mRenderQueue:SetShaderRenderQueue(depth + 5)
	end
end

---关闭按钮点击事件
function HallFirstChargeRebatePanel:OnButtonClose(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

---立即参与按钮点击事件
function HallFirstChargeRebatePanel:OnButtonParticipate(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end

---充值任意金额领取
function HallFirstChargeRebatePanel:OnButtonRecharge(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end

---领取按钮点击事件
function HallFirstChargeRebatePanel:OnButtonReeive(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	if self.CurrentProgressType == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_IN_PROGRESS then
		local value = self.mLabel_Money.text
		if tonumber(value) > 0 then 
			UIManager.GetInstance():ShowNoteMessage("次日充值任意金额领取",2)
		end
	elseif self.CurrentProgressType == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_WAIT_RECHARGE_TO_TRIGGER then
		UIManager.GetInstance():ShowNoteMessage("充值任意金额领取",2)
		UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
		UIManager.GetInstance():HidePanel(self.mPanelID)
	elseif self.CurrentProgressType == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_CAN_DRAW_PRIZE then
		HallFirstChargeRebateModel.GetInstance():CDrawDayFirstRechargeDaMaSendActivityPrizeReq()
	end	
end




function HallFirstChargeRebatePanel:QueryDayFirstRechargeDaBack(data)
	
	local progress = data.m_un64CurrentDaMa / data.m_un64Grade3NeedDaMa		--计算百分比
	self.mSlider_progress.value = progress
	self.mLabel_progress.text = StringFormat("{0}/{1}",HallGoldRateSToC(data.m_un64CurrentDaMa),HallGoldRateSToC(data.m_un64Grade3NeedDaMa))
	self.CurrentProgressType = data.m_ucStatus
	if data.m_ucStatus == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NO_RECHARGE then 	--当天还没有充值 then	-
		self.mButton_Participate:SetActive(true)
		self.mButton_Recharge:SetActive(false)
		self.mButton_Reeive:SetActive(false)
		self.mObj_AllBox:SetActive(true)
		self.mObj_BoxOne:SetActive(true)
		self.mObj_BoxTow:SetActive(false)
		self.mObj_BoxThree:SetActive(false)
		self.mLabel_BG:SetActive(false)
		self.mLabel_Money.text = 0
	elseif data.m_ucStatus == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_IN_PROGRESS  then --/已经到了次日, 昨天的打码量不够领取最低档
		self.mButton_Participate:SetActive(false)
		self.mButton_Recharge:SetActive(false)
		-- self.mBox_recharge.enabled = false
		-- self.mSprite_recharge.color = Color(0,1,1)
		self.mButton_Reeive:SetActive(true)
		self.mSprite_Reeive.color = Color(0,1,1)
		self.mObj_AllBox:SetActive(true)
		self.mObj_BoxOne:SetActive(true)
		self.mObj_BoxTow:SetActive(false)
		self.mObj_BoxThree:SetActive(false)
		--self.mLabel_BG:SetActive(false)
		self:SetLabelMoney(data)
	elseif data.m_ucStatus == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_WAIT_RECHARGE_TO_TRIGGER  then --/已经到了次日, 等待充值任意金额领取奖励
		self.mButton_Participate:SetActive(false)
		self.mButton_Recharge:SetActive(false)
		-- self.mBox_recharge.enabled = true
		-- self.mSprite_recharge.color = Color(1,1,1)
		self.mButton_Reeive:SetActive(true)
		self.mSprite_Reeive.color = Color(0,1,1)
		self.mObj_AllBox:SetActive(true)
		self.mObj_BoxOne:SetActive(false)
		self.mObj_BoxTow:SetActive(true)
		self.mObj_BoxThree:SetActive(false)
		--self.mLabel_BG:SetActive(true)
		self:SetLabelMoney(data)
	elseif data.m_ucStatus == HallFirstChargeRebateModel.ProgressType.E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_CAN_DRAW_PRIZE   then --/可以领取奖励
		self.mButton_Participate:SetActive(false)
		self.mButton_Recharge:SetActive(false)
		self.mButton_Reeive:SetActive(true)
		self.mSprite_Reeive.color = Color(1,1,1)
		self.mObj_AllBox:SetActive(true)
		self.mObj_BoxOne:SetActive(false)
		self.mObj_BoxTow:SetActive(false)
		self.mObj_BoxThree:SetActive(true)
		--self.mLabel_BG:SetActive(true)
		self:SetLabelMoney(data)
	end
end

----设置宝箱可领取的值
function HallFirstChargeRebatePanel:SetLabelMoney(data)
	
	if data.m_un64CurrentDaMa < data.m_un64Grade1NeedDaMa then
		--SetNumberLabel(self.mLabel_Money,data.m_un64Grade1SendCount)
		self.mLabel_BG:SetActive(false)
	elseif  data.m_un64CurrentDaMa > data.m_un64Grade1NeedDaMa and data.m_un64CurrentDaMa < data.m_un64Grade2NeedDaMa then
		self.mLabel_BG:SetActive(true)
		SetNumberLabel(self.mLabel_Money,data.m_un64Grade1SendCount)
	elseif  data.m_un64CurrentDaMa > data.m_un64Grade2NeedDaMa and data.m_un64CurrentDaMa < data.m_un64Grade3NeedDaMa then
		
		self.mLabel_BG:SetActive(true)
		local value = data.m_un64Grade1SendCount + data.m_un64Grade2SendCount
		SetNumberLabel(self.mLabel_Money,value)
	else
		self.mLabel_BG:SetActive(true)
		local value = data.m_un64Grade1SendCount + data.m_un64Grade2SendCount + data. m_un64Grade3SendCount
		SetNumberLabel(self.mLabel_Money,value)
	end
end

function HallFirstChargeRebatePanel:ShowPanel(back)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,back)
	HallFirstChargeRebateModel.GetInstance():CQueryDayFirstRechargeDaMaSendActivityProgressReq()
end


function HallFirstChargeRebatePanel:__delete( ... )
	self.CurrentProgressType = 0
	self.mButton_Close = nil
	self.mButton_Participate = nil
	self.mButton_Recharge = nil
	self.mButton_Reeive =nil
	self.mSprite_Reeive = nil
	self.mSlider_progress = nil
	self.mObj_AllBox = nil
	self.mObj_BoxOne = nil
	self.mObj_BoxTow = nil
	self.mObj_BoxThree = nil
	self.mLabel_Money = nil
	self.mLabel_BG = nil
	self.mLabel_progress = nil
	self.mRenderQueue = nil
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	GameObject.Destroy(self.obj)
end
