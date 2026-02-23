HallRestBankPasswordView = HallRestBankPasswordView or BaseClass()

function HallRestBankPasswordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRestBankPasswordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRestBankPasswordPanel.New(callBack)
	end
end

----必须实现
function HallRestBankPasswordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRestBankPasswordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallRestBankPasswordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallRestBankPasswordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
