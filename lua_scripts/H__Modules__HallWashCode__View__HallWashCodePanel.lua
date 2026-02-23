HallWashCodePanel = HallWashCodePanel or BaseClass(LuaPanel)

function HallWashCodePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWashCode].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWashCode].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallWashCode
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallWashCodePanel:InitUI()
	local mTran = self.obj.transform
	self.mLabel_week = mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give01/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_month = mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give02/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_yesterday = mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give03/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_week.text = 0
	self.mLabel_month.text = 0
	self.mLabel_yesterday.text = 0
	self.mObj_Close = mTran:Find("Content/Content_WashCode/WashCodeView/Button_Close").gameObject

	self.mObj_weekReceive =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give01/Button_1").gameObject
	self.mObj_weekLabel =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give01/Button_1").gameObject:GetComponent(typeof(UISprite))
	self.mBox_week = self.mObj_weekReceive:GetComponent(typeof(BoxCollider))
	
	local mTran_Ani = mTran:Find("Content/Content_WashCode/WashCodeView/Spine_Girl")
	if mTran_Ani ~= nil then
		self.mRenderQueue = SZUIRenderQueue.New(mTran_Ani.gameObject)
	end

	self.mObj_weekChart =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give01/Button_2").gameObject
	UIEventListener.Get(self.mObj_weekChart).onClick = function (obj) self:OnWeekButtonClick(obj) end
	UIEventListener.Get(self.mObj_weekReceive).onClick = function (obj) self:OnGetButtonClick(obj) end
	self.mObj_monthReceive =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give02/Button_1").gameObject
	self.mObj_monthLabel =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give02/Button_1").gameObject:GetComponent(typeof(UISprite))
	self.mBox_month = self.mObj_monthReceive:GetComponent(typeof(BoxCollider))

	

	self.mObj_monthChart =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give02/Button_2").gameObject
	UIEventListener.Get(self.mObj_monthChart).onClick = function (obj) self:OnWeekButtonClick(obj) end
	UIEventListener.Get(self.mObj_monthReceive).onClick = function (obj) self:OnGetButtonClick(obj) end
	self.mObj_yesterdayReceive =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give03/Button_1").gameObject
	self.mObj_yesterdayLabel =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give03/Button_1").gameObject:GetComponent(typeof(UISprite))
	self.mBox_yesterday = self.mObj_yesterdayReceive:GetComponent(typeof(BoxCollider))

	self.mObj_yesterdayChart =  mTran:Find("Content/Content_WashCode/WashCodeView/All_Give/Give03/Button_2").gameObject
	UIEventListener.Get(self.mObj_yesterdayReceive).onClick = function (obj) self:OnGetButtonClick(obj) end
	UIEventListener.Get(self.mObj_yesterdayChart).onClick = function (obj) self:OnCodeButtonClick(obj) end
	local mObj_giftComparison = mTran:Find("Content_2").gameObject
	self.GiftComparisonView = GiftComparisonTableView.New(mObj_giftComparison)
	self.GiftComparisonView:SetViewDisplay(false)
	local mObj_CodeComparison = mTran:Find("Content_1").gameObject
	self.CodeComparisionView = CodeComparisonTableView.New(mObj_CodeComparison)
	self.CodeComparisionView:SetViewDisplay(false)
	UIEventListener.Get(self.mObj_Close).onClick = function (obj) self:OnCloseBtn(obj) end

	self.mObj_AllGive = mTran:Find("Content/Content_WashCode/WashCodeView/All_Give").gameObject

	local list_tweenList={}
    local TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, TweenAn)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	LuaPanel.InitUI(self)
end





function HallWashCodePanel:ShowPanel(callBack)
	LuaPanel.ShowPanel(self,callBack)
	self:SetButtonState(self.mObj_weekLabel,self.mBox_week,0,0)
	self:SetButtonState(self.mObj_monthLabel,self.mBox_month,0,0)
	self:SetButtonState(self.mObj_yesterdayLabel,self.mBox_yesterday,0,0)
	HallWashCodeController.GetInstance().model:GetGiftInfo(function(data)
		if data.retcode==0 then
			self:RefrushData(data)
		else
			self:SetButtonState(self.mObj_weekLabel,self.mBox_week,0,0)
			self:SetButtonState(self.mObj_monthLabel,self.mBox_month,0,0)
			self:SetButtonState(self.mObj_yesterdayLabel,self.mBox_yesterday,0,0)
		end
		
	end)
	self.mTweenPlayer:ParallelPlay(false)
end

function HallWashCodePanel:RefrushData(data)
	self.data = data
	self:SetLabelValue(self.mLabel_week,data.weekgift)
	self:SetLabelValue(self.mLabel_month,data.mongift)
	self:SetLabelValue(self.mLabel_yesterday,data.ywash_money)
	self:SetButtonState(self.mObj_weekLabel,self.mBox_week,data.weekgift_status,data.weekgift)
	self:SetButtonState(self.mObj_monthLabel,self.mBox_month,data.mongift_status,data.mongift)
	self:SetButtonState(self.mObj_yesterdayLabel,self.mBox_yesterday,data.ywash_money_status,data.ywash_money)
end

function HallWashCodePanel:OnCloseBtn(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallWashCodePanel:OnWeekButtonClick(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.GiftComparisonView:SetViewDisplay(true)
end

function HallWashCodePanel:OnCodeButtonClick(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.CodeComparisionView:SetViewDisplay(true)
end


function HallWashCodePanel:OnGetButtonClick(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local type = 0
	local money = 0
	if obj == self.mObj_weekReceive then
		type = HallWashCodeModel.GetGiftType.week
		money = self.data.weekgift
	elseif obj == self.mObj_monthReceive then
		type = HallWashCodeModel.GetGiftType.month
		money = self.data.mongift
	elseif obj == self.mObj_yesterdayReceive then
		money = self.data.ywash_money
		type = HallWashCodeModel.GetGiftType.washCode
	end
	if money > 1 then
		HallWashCodeController.GetInstance().model:AddGift(type,function(type)
			self:OnGetGiftBack(type)
		end)
	else
		UIManager:GetInstance():ShowNoteMessage("没有可领取的数据")
	end

end

function HallWashCodePanel:OnGetGiftBack(type)
	if type == HallWashCodeModel.GetGiftType.week then
		self:SetButtonState(self.mObj_weekLabel,self.mBox_week,1,0)
	elseif type == HallWashCodeModel.GetGiftType.month then
		self:SetButtonState(self.mObj_monthLabel,self.mBox_month,1,0)
	elseif type == HallWashCodeModel.GetGiftType.washCode then
		self:SetButtonState(self.mObj_yesterdayLabel,self.mBox_yesterday,1,0)
	end
end



---设置value的值
function HallWashCodePanel:SetLabelValue(mLabel,value)
	if not mLabel then return end
	value=value or 0
	value=HallGoldRateSToC(value)
	mLabel.text=string.gsub(NumberThousandsFormat(value),"元","")
end

--设置按钮的状态
function HallWashCodePanel:SetButtonState(btnLabel,btnBox,state,money)
	if state == 0 then
		if money >0 then
			btnLabel.color = Color(1,1,1)
			btnBox.enabled = true
		else
			btnLabel.color = Color(0,1,1)
			state = 2
			btnBox.enabled = false
		end
	else
		btnLabel.color = Color(0,1,1)
		btnBox.enabled = state == 0
	end
	btnLabel.spriteName = HallWashCodeModel.ButtonType[state]
end

function HallWashCodePanel:SetPanelDepth(depth)
	self.GiftComparisonView:SetPanelDepth(depth)
	self.CodeComparisionView:SetPanelDepth(depth)
	if self.mRenderQueue~= nil then
		self.mRenderQueue:SetShaderRenderQueue(depth+5)
	end 
	SetPanelstartingRenderQueue(self.mObj_AllGive,depth + 7)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallWashCodePanel:HidePanel()
	LuaPanel.HidePanel(self)
	--UIManager.GetInstance():DestroyPanelByID(self.mPanelID)
end


function HallWashCodePanel:__delete( ... )

	self.mLabel_week = nil
	self.mLabel_month = nil
	self.mLabel_yesterday = nil
	
	self.mObj_Close = nil

	self.mObj_weekReceive =  nil
	self.mObj_weekLabel =  nil
	self.mBox_week = nil
	self.mRenderQueue = nil
	self.mObj_weekChart =  nil
	
	self.mObj_monthReceive =  nil
	self.mObj_monthLabel =  nil
	self.mBox_month = nil

	self.mObj_monthChart =  nil
	self.mObj_yesterdayReceive =  nil
	self.mObj_yesterdayLabel =  nil
	self.mBox_yesterday = nil

	self.mObj_yesterdayChart =  nil
	
	self.GiftComparisonView = nil
	self.CodeComparisionView = nil
	
	self.mObj_AllGive = nil


	self.mTweenPlayer= nil
	GameObject.Destroy(self.obj)
	
end
