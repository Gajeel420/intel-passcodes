HallRegisteredGiftGoldView = HallRegisteredGiftGoldView or BaseClass()

function HallRegisteredGiftGoldView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRegisteredGiftGoldView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRegisteredGiftGoldPanel.New(callBack)
	end
end

----必须实现
function HallRegisteredGiftGoldView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRegisteredGiftGoldView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallRegisteredGiftGoldView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallRegisteredGiftGoldView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallRegisteredGiftGoldView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
