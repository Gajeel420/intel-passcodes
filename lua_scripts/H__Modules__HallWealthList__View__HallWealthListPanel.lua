HallWealthListPanel = HallWealthListPanel or BaseClass(LuaPanel)

function HallWealthListPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWealthList].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWealthList].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallWealthList
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallWealthListPanel:InitUI()
	local mTran = self.obj.transform
	self.mRankGridList={}
	self.mBtnNormalList = {}
	self.mBtnSelectList = {}
    self.model=HallWealthListModel:GetInstance()
	self.mObjItem = mTran:Find("Content/Rank/UI_RankGrid").gameObject
	self.listObjItem={}
	self.itemSize=110
	self.mObjItem:SetActive(false)
    self.mPanelGrid = mTran:Find("Content/Rank/RankPanel"):GetComponent(typeof(UIPanel))
    self.mRichPanelGrid = mTran:Find("Content/Rank/RankPanel/Grid"):GetComponent(typeof(UIGrid))
    self.mButtonColse = mTran:Find("Content/Btn_Back/Background").gameObject
    self.svRanklist = mTran:Find("Content/Rank/RankPanel"):GetComponent(typeof(UIScrollView))
	UIEventListener.Get(self.mButtonColse).onClick = function() self:OnButtonColse() end
	

	self.mButton_WinRank = mTran:Find("Content/Bank_Title/Toggle_Win").gameObject
	self.mButton_WinRank:SetActive(ConfigModuleModel.GetInstance().RankListType.GameblingList)
	local mSelectBtn =  mTran:Find("Content/Bank_Title/Toggle_Win/Checkmark").gameObject
	mSelectBtn:SetActive(false)
	table.insert(self.mBtnSelectList,mSelectBtn )
	local mNormalBtn =  mTran:Find("Content/Bank_Title/Toggle_Win/Label").gameObject
	table.insert(self.mBtnNormalList,mNormalBtn )
	UIEventListener.Get(self.mButton_WinRank).onClick = function() self:onRankTitleButton(HallWealthListPanel.RankeListType.WinRankingList) end
	self.mButton_RechargeRank = mTran:Find("Content/Bank_Title/Toggle_Recharge").gameObject
	self.mButton_RechargeRank:SetActive(ConfigModuleModel.GetInstance().RankListType.RichList)
	mSelectBtn =  mTran:Find("Content/Bank_Title/Toggle_Recharge/Checkmark").gameObject
	mSelectBtn:SetActive(false)
	table.insert(self.mBtnSelectList,mSelectBtn )
	mNormalBtn =  mTran:Find("Content/Bank_Title/Toggle_Recharge/Label").gameObject
	table.insert(self.mBtnNormalList,mNormalBtn )
	UIEventListener.Get(self.mButton_RechargeRank).onClick = function() self:onRankTitleButton(HallWealthListPanel.RankeListType.RechargeRankingList) end
	self.mButton_SupremeRank = mTran:Find("Content/Bank_Title/Toggle_Supreme").gameObject
	self.mButton_SupremeRank:SetActive(ConfigModuleModel.GetInstance().RankListType.ExtremeList)
	mSelectBtn =  mTran:Find("Content/Bank_Title/Toggle_Supreme/Checkmark").gameObject
	mSelectBtn:SetActive(false)
	table.insert(self.mBtnSelectList,mSelectBtn )
	mNormalBtn =  mTran:Find("Content/Bank_Title/Toggle_Supreme/Label").gameObject
	table.insert(self.mBtnNormalList,mNormalBtn )
	UIEventListener.Get(self.mButton_SupremeRank).onClick = function() self:onRankTitleButton(HallWealthListPanel.RankeListType.SupremeRankingList) end

	self.mButton_commission = mTran:Find("Content/Bank_Title/Toggle_Commission").gameObject
	self.mButton_commission:SetActive(false)
	--self.mButton_commission:SetActive(ConfigModuleModel.GetInstance().RankListType.commissionList)
	mSelectBtn =  mTran:Find("Content/Bank_Title/Toggle_Commission/Checkmark").gameObject
	mSelectBtn:SetActive(false)
	table.insert(self.mBtnSelectList,mSelectBtn )
	mNormalBtn =  mTran:Find("Content/Bank_Title/Toggle_Commission/Label").gameObject
	table.insert(self.mBtnNormalList,mNormalBtn )
	UIEventListener.Get(self.mButton_commission).onClick = function() self:onRankTitleButton(HallWealthListPanel.RankeListType.CommissionList) end

    self.TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
	self:AddEvent()
	self.CurrentRankingListType = HallWealthListPanel.RankeListType.WinRankingList
	LuaPanel.InitUI(self)
end

function HallWealthListPanel:AddEvent()
	self.model:AddEventListener(HallWealthListConst.EventName_RefreshRankList,self.RefreshRankList,self)
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
end

function HallWealthListPanel:RefreshRankList(context)
	if context then
		self:SetPanelData(context)
	end
end


function HallWealthListPanel:onRankTitleButton(rankType)
	self.CurrentRankingListType = rankType

	for i = 1, #self.mBtnNormalList do
		self.mBtnSelectList[i]:SetActive(i == rankType)
		self.mBtnNormalList[i]:SetActive(i ~= rankType)
	end

	self:ClearObjItemList()
	if rankType == HallWealthListPanel.RankeListType.WinRankingList then
		HallWealthListModel.GetInstance():ReqWinRankingList()
	elseif rankType == HallWealthListPanel.RankeListType.SupremeRankingList then
		HallWealthListModel:GetInstance():ReqUserRank(1,2,100)
	elseif rankType == HallWealthListPanel.RankeListType.RechargeRankingList then
		HallWealthListModel:GetInstance():ReqRechargeRankingList()
	elseif rankType == HallWealthListPanel.RankeListType.CommissionList then
		HallWealthListModel:GetInstance():ReqCommssionRankingList()
	end
end


function HallWealthListPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self:ReqRank()
	LuaPanel.ShowPanel(self,callBack)
    self:PlayOpenAni()
end

function HallWealthListPanel:ReqRank()
	--没有数据就要请求
	self:onRankTitleButton(self.CurrentRankingListType)
end

function HallWealthListPanel:ClearObjItemList( ... )
	if self.mRankGridList== nil then return end
	for k,v in pairs(self.mRankGridList) do
		v:OnVisible(false)
	end
end

function HallWealthListPanel:ResetPanel( context )
	self:ClearObjItemList()
end

function HallWealthListPanel:SetPanelData( list )
	if not list or not next(list) then return end
	for i,v in ipairs(list) do
		if #self.mRankGridList>i then
			local rankGrid=self.mRankGridList[i]
			rankGrid:SetGridData(v, i,self.CurrentRankingListType)
			rankGrid:OnVisible(true)
		else
			local go=GameObject.Instantiate(self.mObjItem)
			go.transform.parent = self.mRichPanelGrid.transform;
            go.transform.localEulerAngles = Vector3.zero;
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            local rankGrid=HallWealthListGrid.New(go)
            rankGrid:SetGridData(v, i,self.CurrentRankingListType)
			rankGrid:OnVisible(true)
			table.insert(self.mRankGridList,rankGrid)
		end
	end
	self.mRichPanelGrid:Reposition()
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.svRanklist:ResetPosition()
	end)
	
end

function HallWealthListPanel:OnButtonColse( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID);
end

--设置子panel的深度
 function HallWealthListPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
 	self.mPanelGrid.depth = self.obj:GetComponent(typeof(UIPanel)).depth + 1;
end

function HallWealthListPanel:PlayOpenAni( ... )
    -- body
    self.TweenAn.enabled=true
    self.TweenAn:ResetToBeginning()
    self.TweenAn:PlayForward()
end

HallWealthListPanel.RankeListType = {
	WinRankingList = 1,				--赌神榜
	RechargeRankingList=2,			--充钱榜
	SupremeRankingList=3,			--至尊榜
	CommissionList = 4,				--佣金榜
}


function HallWealthListPanel:__delete( ... )
	self.model:RemoveEventListener(HallWealthListConst.EventName_RefreshRankList,self.RefreshRankList,self)
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	self.mRankGridList= nil
	self.mBtnNormalList = nil
	self.mBtnSelectList = nil
	self.model.m_listRankWealth = nil
	self.model = nil
	self.mObjItem = nil
	self.listObjItem= nil
	self.itemSize= nil
    self.mPanelGrid = nil
    self.mRichPanelGrid = nil
    self.mButtonColse = nil
    self.svRanklist = nil
	self.mButton_WinRank = nil
	self.mButton_RechargeRank = nil
	self.mButton_SupremeRank = nil
	self.mButton_commission = nil
    self.TweenAn = nil
	self.CurrentRankingListType = nil
	
	
end
