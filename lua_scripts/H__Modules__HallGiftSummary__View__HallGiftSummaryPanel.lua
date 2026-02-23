HallGiftSummaryPanel = HallGiftSummaryPanel or BaseClass(LuaPanel)

function HallGiftSummaryPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGiftSummary].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGiftSummary].path
	self.mPanelID = UIPanelDefine.EWndID.HallGiftSummary
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGiftSummaryPanel:InitUI()
	self.mInt_PageSize=30
	local mTran = self.obj.transform
	self.mBtnClose = mTran:Find("Common/Btn_Back/Background").gameObject
	UIEventListener.Get(self.mBtnClose).onClick = function(obj) self:OnButtonClose(obj) end
	self.mButton_ThisMonth = mTran:Find("Content/Left/ToggleThisMonth").gameObject
	self.mButton_ThisMonthNormal =  mTran:Find("Content/Left/ToggleThisMonth/Normal").gameObject
	self.mButton_ThisMonthUp = mTran:Find("Content/Left/ToggleThisMonth/Up").gameObject
	UIEventListener.Get(self.mButton_ThisMonth).onClick = function(obj) self:OnButtonThisMonthClick(obj) end
	self.mButton_LastMonth = mTran:Find("Content/Left/ToggleLastMonth").gameObject
	self.mButton_LastMonthNormal =  mTran:Find("Content/Left/ToggleLastMonth/Normal").gameObject
	self.mButton_LastMonthUp = mTran:Find("Content/Left/ToggleLastMonth/Up").gameObject
	UIEventListener.Get(self.mButton_LastMonth).onClick = function(obj) self:OnButtonLastMothClick(obj) end
	self.mPanelScroll = mTran:Find("Content/Right/ScrollView").gameObject:GetComponent(typeof(UIPanel))
	self.mGridParent = mTran:Find("Content/Right/ScrollView/Grid")
	self.mObjItem = mTran:Find("Content/Right/ScrollView/Item").gameObject
	self.mObjItem:SetActive(false)

	self.mLabel_SummaryTitle = mTran:Find("Content/Right/Summary/Label").gameObject:GetComponent(typeof(UISprite))
	self.mLabel_SummaryReceive = mTran:Find("Content/Right/Summary/ReceiveLabel").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_SummarySend = mTran:Find("Content/Right/Summary/SebdLabel").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_SummaryReceive.text = 0
	self.mLabel_SummarySend.text = 0
	self.mItemList = {}
	LuaPanel.InitUI(self)
end


---点击关闭按钮
function HallGiftSummaryPanel:OnButtonClose(obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallGiftSummaryPanel:OnButtonThisMonthClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:CloseAllItem()
	self.mButton_ThisMonthNormal:SetActive(false)
	self.mButton_ThisMonthUp:SetActive(true)
	self.mButton_LastMonthNormal:SetActive(true)
	self.mButton_LastMonthUp:SetActive(false)
	self.mLabel_SummaryTitle.spriteName = HallGiftSummaryModel.SpriteNames[1]
	HallGiftSummaryController.GetInstance().model:RequestSummaryData(1)
end

function HallGiftSummaryPanel:OnButtonLastMothClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:CloseAllItem()
	self.mButton_ThisMonthNormal:SetActive(true)
	self.mButton_ThisMonthUp:SetActive(false)
	self.mButton_LastMonthNormal:SetActive(false)
	self.mButton_LastMonthUp:SetActive(true)
	self.mLabel_SummaryTitle.spriteName = HallGiftSummaryModel.SpriteNames[2]
	HallGiftSummaryController.GetInstance().model:RequestSummaryData(2)
end


function HallGiftSummaryPanel:OnUpdateSendData(data)
	local list = data.m_DaySummaryArray
	local allGive = 0
	local allRecive = 0
	local count = #list
	for i = 1, count do
		if self.mItemList[i]  == nil then
			local obj=GameObject.Instantiate(self.mObjItem,self.mGridParent)
			obj.name=tostring(i)
			obj.transform.localPosition = Vector3.zero
			obj.transform.localScale = Vector3.one
			obj.transform.localEulerAngles = Vector3.zero
			self.mItemList[i]=UISummaryGrid.New(obj)
		end
		local item = self.mItemList[i]
		item:SetData(list[i])
		item:SetGridDisplay(true)

		allGive=allGive+list[i].m_un64TotalSend
		allRecive=allRecive+list[i].m_un64TotalRecv
	end
	self.mGridParent.gameObject:GetComponent(typeof(UIGrid)):Reposition()
	SetNumberLabel(self.mLabel_SummarySend,allGive) 
	SetNumberLabel(self.mLabel_SummaryReceive,allRecive) 
end


function HallGiftSummaryPanel:CloseAllItem()
	self.mLabel_SummaryReceive.text = 0
	self.mLabel_SummarySend.text = 0
	local count = #self.mItemList
	for i = 1, count do
		self.mItemList[i]:SetGridDisplay(false)
	end
end



function HallGiftSummaryPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.mPanelScroll.depth = depth + 2
	
end

function HallGiftSummaryPanel:ShowPanel(back)
	self:OnButtonThisMonthClick(self.mButton_ThisMonth)
	LuaPanel.ShowPanel(self,back)
end


function HallGiftSummaryPanel:HidePanel()
	
	LuaPanel.HidePanel(self)
end

function HallGiftSummaryPanel:__delete( ... )
	
end
