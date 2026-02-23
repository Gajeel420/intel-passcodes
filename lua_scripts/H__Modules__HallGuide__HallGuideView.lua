
HallGuideView = HallGuideView or BaseClass()

function HallGuideView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGuideView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGuidePanel.New(callBack)
	end
end

----必须实现
function HallGuideView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallGuideView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallGuideView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallGuideView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallGuideView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
