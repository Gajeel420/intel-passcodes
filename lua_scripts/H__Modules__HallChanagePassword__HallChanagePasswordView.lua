HallChanagePasswordView = HallChanagePasswordView or BaseClass()

function HallChanagePasswordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallChanagePasswordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallChanagePasswordPanel.New(callBack)
	end
end

----必须实现
function HallChanagePasswordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallChanagePasswordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallChanagePasswordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallChanagePasswordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
