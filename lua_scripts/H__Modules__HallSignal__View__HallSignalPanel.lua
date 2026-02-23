HallSignalPanel = HallSignalPanel or BaseClass(LuaPanel)

function HallSignalPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSignal].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSignal].path
	self.mPanelID = UIPanelDefine.EWndID.HallSignal
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallSignalPanel:InitUI()
	local mTran = self.obj.transform
	LuaPanel.InitUI(self)
	
end

function HallSignalPanel:ResetPanel( ... )
	-- body
end


--设置子panel的深度
 function HallSignalPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end
--创建排行榜列表


function HallSignalPanel:__delete( ... )
	
end
