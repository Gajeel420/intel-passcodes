HallGiftView = HallGiftView or BaseClass()

function HallGiftView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGiftView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGiftPanel.New(callBack)
	end
end

----必须实现
function HallGiftView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallGiftView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallGiftView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallGiftView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallGiftView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end