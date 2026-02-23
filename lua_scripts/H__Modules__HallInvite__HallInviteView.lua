
HallInviteView = HallInviteView or BaseClass()

function HallInviteView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallInviteView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallInvitePanel.New(callBack)
	end
end

----必须实现
function HallInviteView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallInviteView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallInviteView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallInviteView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallInviteView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
