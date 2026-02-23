HallPaymentOpeningPanel = HallPaymentOpeningPanel or BaseClass(LuaPanel)

function HallPaymentOpeningPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPaymentOpening].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPaymentOpening].path
	self.mPanelID = UIPanelDefine.EWndID.HallPaymentOpening
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType= UIPanelDefine.PanelType.Prompt;
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallPaymentOpeningPanel:InitUI()
	local mTran = self.obj.transform
	-- self.mAniObj = mTran:Find("Content/Btn_CZ/Label_CZ")
	-- if self.mAniObj ~= nil then
    --     self.mUIRenderQueue = SZUIRenderQueue.New(self.mAniObj.gameObject)
    -- end
	LuaPanel.InitUI(self)
end


function HallPaymentOpeningPanel:SetPanelDepth(depth)
	-- if self.mUIRenderQueue ~= nil then
    --     self.mUIRenderQueue:SetShaderRenderQueue(depth + 12)
    -- end
	
	LuaPanel.SetPanelDepth(self,depth)
end

function HallPaymentOpeningPanel:__delete( ... )
	
end
