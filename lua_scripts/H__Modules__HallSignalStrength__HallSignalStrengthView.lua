HallSignalStrengthView = HallSignalStrengthView or BaseClass()

function HallSignalStrengthView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallSignalStrengthView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallSignalStrengthPanel.New(callBack)
	end
end

----必须实现
function HallSignalStrengthView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallSignalStrengthView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallSignalStrengthView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallSignalStrengthView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallSignalStrengthView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end