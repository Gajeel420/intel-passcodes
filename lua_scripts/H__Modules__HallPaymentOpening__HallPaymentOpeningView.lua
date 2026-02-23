HallPaymentOpeningView = HallPaymentOpeningView or BaseClass()

function HallPaymentOpeningView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallPaymentOpeningView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallPaymentOpeningPanel.New(callBack)
	end
end

----必须实现
function HallPaymentOpeningView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallPaymentOpeningView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallPaymentOpeningView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallPaymentOpeningView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallPaymentOpeningView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end