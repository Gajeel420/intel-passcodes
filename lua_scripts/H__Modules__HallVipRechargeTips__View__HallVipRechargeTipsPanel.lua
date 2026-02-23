HallVipRechargeTipsPanel = HallVipRechargeTipsPanel or BaseClass(LuaPanel)

function HallVipRechargeTipsPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallVipRechargeTips].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallVipRechargeTips].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallVipRechargeTips
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallVipRechargeTipsPanel:InitUI()
	local mTran = self.obj.transform
	self.mLabel_Roate = mTran:Find("Content/VIPRechargeView/Tex/Label").gameObject:GetComponent(typeof(UILabel))
	self.mObj_Check = mTran:Find("Content/VIPRechargeView/ChecklistAll/Checklist").gameObject
	self.mLabel_Tips = mTran:Find("Content/VIPRechargeView/Tex/Label_Des").gameObject:GetComponent(typeof(UILabel))
	self.mObj_ChecklistAll = mTran:Find("Content/VIPRechargeView/ChecklistAll").gameObject
	UIEventListener.Get(self.mObj_ChecklistAll).onClick = function(obj) self:OnClickChecklistAll(obj) end
	self.mObj_Close = mTran:Find("Content/Button_Close").gameObject
	UIEventListener.Get(self.mObj_Close).onClick = function(obj) self:OnClickClose(obj) end
	self.mObj_Confirm = mTran:Find("Content/Button_Participate").gameObject
	UIEventListener.Get(self.mObj_Confirm).onClick = function(obj) self:OnClickOpenVipView(obj) end

	local mAni =  mTran:Find("Content/VIPRechargeView/Tex/Spine_Girl")
	if mAni ~= nil then
		self.mUIRenderQueue = SZUIRenderQueue.New(mAni.gameObject)
	end

	LuaPanel.InitUI(self)
end


function HallVipRechargeTipsPanel:ShowPanel(back)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,back);
	self.result = HallVipRechargeTipsModel.GetInstance():GetIsShowVipRechargeTips()
	self.mObj_Check:SetActive(self.result == 0)
	local mRebate = tonumber(StoreModuleModel:GetInstance().Corner["61"])
	self.mLabel_Roate.text = StringFormat("{0}%",mRebate)
	local resultfMone = math.ceil( 1000*mRebate/100) 
	local totalMone = 1000+ resultfMone
	--self.mLabel_Tips.text = StringFormat("例如：官方充值1000元赠{0},实际获得{1}元",resultfMone,totalMone)
end


function HallVipRechargeTipsPanel:OnClickChecklistAll(obj) 
	self.result = self.result == 0 and 1 or 0
	self.mObj_Check:SetActive(self.result == 0)
	
end

function HallVipRechargeTipsPanel:OnClickOpenVipView(obj)
	HallVipRechargeTipsModel.GetInstance():SaveIsShowVipRechargeTips(self.result)
	UIManager.GetInstance():HidePanel(self.mPanelID)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge,function(panel)
		panel:OpenAgentView()
	end)
end

function HallVipRechargeTipsPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	if self.mUIRenderQueue ~= nil then
		self.mUIRenderQueue:SetShaderRenderQueue(depth+5)
	end
end


function HallVipRechargeTipsPanel:OnClickClose(obj)
	HallVipRechargeTipsModel.GetInstance():SaveIsShowVipRechargeTips(self.result)
	UIManager.GetInstance():HidePanel(self.mPanelID)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end



function HallVipRechargeTipsPanel:__delete( ... )
	self.mLabel_Roate = nil
	self.mObj_Check = nil
	self.mLabel_Tips = nil
	self.mObj_ChecklistAll = nil
	self.mObj_Close = nil
	self.mObj_Confirm = nil
	self.mUIRenderQueue = nil
	GameObject.Destroy(self.obj)

end
