HallNoteMsgView = HallNoteMsgView or BaseClass()

function HallNoteMsgView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallNoteMsgView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallNoteMsgPanel.New(callBack)
	end
end

----必须实现
function HallNoteMsgView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallNoteMsgView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallNoteMsgView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallNoteMsgView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallNoteMsgView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
