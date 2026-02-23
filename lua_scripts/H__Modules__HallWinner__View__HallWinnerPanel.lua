HallWinnerPanel = HallWinnerPanel or BaseClass(LuaPanel)

function HallWinnerPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWinner].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWinner].path
	self.mPanelID = UIPanelDefine.EWndID.HallWinner
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallWinnerPanel:InitUI()
	local mTran = self.obj.transform

	self.mBtnClose = mTran:Find("Content/Button_Closse").gameObject
	UIEventListener.Get(self.mBtnClose).onClick = function() self:OnButtonClose() end
	LuaPanel.InitUI(self)
end


---点击关闭按钮
function HallWinnerPanel:OnButtonClose()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallWinnerPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)	
end

function HallWinnerPanel:ShowPanel(back)
	LuaPanel.ShowPanel(self,back)
end


function HallWinnerPanel:HidePanel()
	LuaPanel.HidePanel(self)
	HallWinnerController:GetInstance().model:SetWinnerKeyValue()
	ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallWinnerPanel:__delete( ... )
	
end
