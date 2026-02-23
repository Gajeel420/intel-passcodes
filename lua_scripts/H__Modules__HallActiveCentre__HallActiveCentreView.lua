HallActiveCentreView = HallActiveCentreView or BaseClass()

function HallActiveCentreView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallActiveCentreView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallActiveCentrePanel.New(callBack)
	end
end

----必须实现
function HallActiveCentreView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallActiveCentreView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallActiveCentreView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallActiveCentreView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end

function HallActiveCentreView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
