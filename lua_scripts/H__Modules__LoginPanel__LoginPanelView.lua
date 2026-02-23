LoginPanelView = LoginPanelView or BaseClass()

function LoginPanelView:__init()
	self.model = nil
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

function LoginPanelView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = LoginPanel.New(callBack)
	end
end

function LoginPanelView:ShowPanel(callBack)
	self.panel:ShowPanel(callBack)
end

----必须实现
function LoginPanelView:HidePanel()
	self.panel:HidePanel()
end

function LoginPanelView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function LoginPanelView:OnDestroyPanel()
	-- self.panel:Destroy()
	-- self.panel=nil
	self.model = nil
	self.resPath = ""
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
function LoginPanelView:__delete()
	self.model = nil
	self.resPath = ""
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end