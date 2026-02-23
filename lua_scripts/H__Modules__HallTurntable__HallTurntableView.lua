HallTurntableView =  BaseClass()

function HallTurntableView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallTurntableView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallTurntablePanel.New(callBack)
	end
end

----必须实现
function HallTurntableView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallTurntableView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallTurntableView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallTurntableView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallTurntableView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end