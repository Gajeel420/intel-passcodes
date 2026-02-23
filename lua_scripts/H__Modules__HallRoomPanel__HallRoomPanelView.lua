HallRoomPanelView = HallRoomPanelView or BaseClass()

function HallRoomPanelView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRoomPanelView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRoomPanelPanel.New(callBack)
	end
end

----必须实现
function HallRoomPanelView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRoomPanelView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallRoomPanelView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end


----必须实现
function HallRoomPanelView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallRoomPanelView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
