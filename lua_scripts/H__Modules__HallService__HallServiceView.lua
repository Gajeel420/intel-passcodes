HallServiceView = HallServiceView or BaseClass()

function HallServiceView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallServiceView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallServicePanel.New(callBack)
	end
end

----必须实现
function HallServiceView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallServiceView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallServiceView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallServiceView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallServiceView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
