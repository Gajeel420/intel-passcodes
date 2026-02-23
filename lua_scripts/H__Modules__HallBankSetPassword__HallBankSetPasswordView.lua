HallBankSetPasswordView = HallBankSetPasswordView or BaseClass()

function HallBankSetPasswordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallBankSetPasswordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallBankSetPasswordPanel.New(callBack)
	end
end

----必须实现
function HallBankSetPasswordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallBankSetPasswordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallBankSetPasswordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallBankSetPasswordView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallBankSetPasswordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
