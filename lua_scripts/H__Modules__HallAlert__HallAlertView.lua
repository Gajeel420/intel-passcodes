HallAlertView = HallAlertView or BaseClass()

function HallAlertView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallAlertView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallAlertPanel.New(callBack)
	end
end

----必须实现
function HallAlertView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallAlertView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallAlertView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallAlertView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end

function HallAlertView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
