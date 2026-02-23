HallSignalView = HallSignalView or BaseClass()

function HallSignalView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallSignalView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallSignalPanel.New(callBack)
	end
end

----必须实现
function HallSignalView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallSignalView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallSignalView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallSignalView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end


function HallSignalView:ResetPanel( )
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ResetPanel()
	end
end

function HallSignalView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
