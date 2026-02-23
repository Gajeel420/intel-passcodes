HallRegistByPhoneView = HallRegistByPhoneView or BaseClass()

function HallRegistByPhoneView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRegistByPhoneView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRegistByPhonePanel.New(callBack)
	end
end

----必须实现
function HallRegistByPhoneView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRegistByPhoneView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallRegistByPhoneView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallRegistByPhoneView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
