HallNotifyView = HallNotifyView or BaseClass()

function HallNotifyView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallNotifyView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallNotifyPanel.New(callBack)
	end
end

----必须实现
function HallNotifyView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallNotifyView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallNotifyView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallNotifyView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallNotifyView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
