HallPromotionCodeView = HallPromotionCodeView or BaseClass()

function HallPromotionCodeView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallPromotionCodeView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallPromotionCodePanel.New(callBack)
	end
end

----必须实现
function HallPromotionCodeView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallPromotionCodeView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallPromotionCodeView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallPromotionCodeView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallPromotionCodeView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end