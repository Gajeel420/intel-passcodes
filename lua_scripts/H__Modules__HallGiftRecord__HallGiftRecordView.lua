HallGiftRecordView = HallGiftRecordView or BaseClass()

function HallGiftRecordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGiftRecordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGiftRecordPanel.New(callBack)
	end
end

----必须实现
function HallGiftRecordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallGiftRecordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallGiftRecordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallGiftRecordView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallGiftRecordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end