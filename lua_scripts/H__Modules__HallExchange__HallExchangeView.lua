HallExchangeView = HallExchangeView or BaseClass()

function HallExchangeView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallExchangeView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallExchangePanel.New(callBack)
	end
end

----必须实现
function HallExchangeView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallExchangeView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallExchangeView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallExchangeView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
