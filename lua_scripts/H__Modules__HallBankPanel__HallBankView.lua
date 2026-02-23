HallBankView = HallBankView or BaseClass()

function HallBankView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallBankView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = BankPanel.New(callBack)
	end
end

----必须实现
function HallBankView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallBankView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallBankView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallBankView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallBankView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end