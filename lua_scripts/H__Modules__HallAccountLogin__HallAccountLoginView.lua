HallAccountLoginView = HallAccountLoginView or BaseClass()

function HallAccountLoginView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallAccountLoginView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallAccountLoginPanel.New(callBack)
	end
end

----必须实现
function HallAccountLoginView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallAccountLoginView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallAccountLoginView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallAccountLoginView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end

function HallAccountLoginView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
