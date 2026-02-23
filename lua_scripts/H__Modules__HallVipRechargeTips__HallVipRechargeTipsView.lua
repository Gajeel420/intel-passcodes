HallVipRechargeTipsView = HallVipRechargeTipsView or BaseClass()

function HallVipRechargeTipsView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallVipRechargeTipsView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallVipRechargeTipsPanel.New(callBack)
	end
end

----必须实现
function HallVipRechargeTipsView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallVipRechargeTipsView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallVipRechargeTipsView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallVipRechargeTipsView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallVipRechargeTipsView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end