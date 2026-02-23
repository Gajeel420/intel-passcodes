HallPhoneVerificationView = HallPhoneVerificationView or BaseClass()

function HallPhoneVerificationView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallPhoneVerificationView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallPhoneVerificationPanel.New(callBack)
	end
end

----必须实现
function HallPhoneVerificationView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallPhoneVerificationView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallPhoneVerificationView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallPhoneVerificationView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
