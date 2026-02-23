HallWealthListView = HallWealthListView or BaseClass()

function HallWealthListView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallWealthListView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallWealthListPanel.New(callBack)
	end
end

----必须实现
function HallWealthListView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end
function HallWealthListView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallWealthListView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallWealthListView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallWealthListView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
