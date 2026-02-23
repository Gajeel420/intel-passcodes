HallBankPasswordView = HallBankPasswordView or BaseClass()

function HallBankPasswordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallBankPasswordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallBankPasswordPanel.New(callBack)
	end
end

----必须实现
function HallBankPasswordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallBankPasswordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallBankPasswordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallBankPasswordView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallBankPasswordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
