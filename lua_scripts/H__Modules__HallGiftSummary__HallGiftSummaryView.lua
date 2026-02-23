HallGiftSummaryView = HallGiftSummaryView or BaseClass()

function HallGiftSummaryView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGiftSummaryView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGiftSummaryPanel.New(callBack)
	end
end

----必须实现
function HallGiftSummaryView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallGiftSummaryView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallGiftSummaryView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallGiftSummaryView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallGiftSummaryView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end