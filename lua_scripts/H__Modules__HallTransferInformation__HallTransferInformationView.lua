HallTransferInformationView = HallTransferInformationView or BaseClass()

function HallTransferInformationView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallTransferInformationView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallTransferInformationPanel.New(callBack)
	end
end

----必须实现
function HallTransferInformationView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallTransferInformationView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallTransferInformationView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallTransferInformationView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallTransferInformationView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end