LoginBGPanelView = LoginBGPanelView or BaseClass()

function LoginBGPanelView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function LoginBGPanelView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = LoginBGPanel.New(callBack)
	end
end

----必须实现
function LoginBGPanelView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function LoginBGPanelView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function LoginBGPanelView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function LoginBGPanelView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function LoginBGPanelView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end