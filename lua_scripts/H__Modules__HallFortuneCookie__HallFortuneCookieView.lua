
HallFortuneCookieView = HallFortuneCookieView or BaseClass()

function HallFortuneCookieView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallFortuneCookieView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallFortuneCookiePanel.New(callBack)
	end
end

----必须实现
function HallFortuneCookieView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallFortuneCookieView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallFortuneCookieView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallFortuneCookieView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallFortuneCookieView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
