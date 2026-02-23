HallBGView = HallBGView or BaseClass()

function HallBGView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallBGView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallBGPanel.New(callBack)
	end
end

----必须实现
function HallBGView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallBGView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallBGView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallBGView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallBGView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end