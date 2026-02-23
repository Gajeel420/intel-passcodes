
HallCashBackView = HallCashBackView or BaseClass()

function HallCashBackView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallCashBackView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallCashBackPanel.New(callBack)
	end
end

----必须实现
function HallCashBackView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallCashBackView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallCashBackView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallCashBackView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallCashBackView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
