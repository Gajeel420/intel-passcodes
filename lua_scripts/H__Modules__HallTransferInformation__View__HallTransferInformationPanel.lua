HallTransferInformationPanel = HallTransferInformationPanel or BaseClass(LuaPanel)

function HallTransferInformationPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTransferInformation].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTransferInformation].path
	self.mPanelID = UIPanelDefine.EWndID.HallTransferInformation
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.FourLevel --页面层级
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallTransferInformationPanel:InitUI()
	local mTran = self.obj.transform
	self.mBtn_Close = mTran:Find("Content/Common/Button_Close").gameObject
	UIEventListener.Get(self.mBtn_Close).onClick = function (go) self:OnBtnCloseClick(go) end

	local mObj_CollectBank = mTran:Find("Content/CollectBank").gameObject
	self.mCollectBankView = CollectBankView.New(mObj_CollectBank)

	local mObj_RechargeInfo = mTran:Find("Content/RechageInfo").gameObject
	self.mRechargeInfoView = RechangeInfoView.New(mObj_RechargeInfo)
	self.mList_Tween={}
	local mTweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
	table.insert(self.mList_Tween,mTweenScale )
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(self.mList_Tween)
	LuaPanel.InitUI(self)
end

function HallTransferInformationPanel:SetRechargeMoney(data,TypeID)
	self.mRechargeInfoView:RefreshMoney(data,TypeID)
	self.mRechargeInfoView:RefreshTime()
	HallTransferInformationController.GetInstance().model:GetBankInfo(TypeID,function(data) self.mCollectBankView:SetData(data) end)
end


function HallTransferInformationPanel:ShowPanel(back)
	LuaPanel.ShowPanel(self,back)
	LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)					--后台切换到前台
	
	self.mTweenPlayer:ParallelPlay(false)
end



--后台切换到前台
function HallTransferInformationPanel:OnApplicationFocus()
	self.mRechargeInfoView:RefreshTime()
end


function HallTransferInformationPanel:HidePanel()
	LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)					--后台切换到前台
	self.mRechargeInfoView:CleanInptValue()
	LuaPanel.HidePanel(self)
end

---关闭按钮点击事件
function HallTransferInformationPanel:OnBtnCloseClick(go)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallTransferInformationPanel:__delete( ... )
	LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)					--后台切换到前台
end
