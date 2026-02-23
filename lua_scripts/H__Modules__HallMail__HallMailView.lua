HallMailView = HallMailView or BaseClass()

function HallMailView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallMailView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallMailPanel.New(callBack)
	end
end

----必须实现
function HallMailView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallMailView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallMailView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallMailView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallMailView:ResetPanel( )
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ResetPanel()
	end
end

function HallMailView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
