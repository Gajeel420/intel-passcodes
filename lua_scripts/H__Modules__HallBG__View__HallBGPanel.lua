HallBGPanel = HallBGPanel or BaseClass(LuaPanel)

function HallBGPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBg].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBg].path
	self.mPanelID = UIPanelDefine.EWndID.HallBg
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallBGPanel:InitUI()
	LuaPanel.InitUI(self)
end

function HallBGPanel:__delete( ... )
	
end
