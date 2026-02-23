
HallMidnightPartyView = HallMidnightPartyView or BaseClass()

function HallMidnightPartyView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallMidnightPartyView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallMidnightPartyPanel.New(callBack)
	end
end

----必须实现
function HallMidnightPartyView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallMidnightPartyView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallMidnightPartyView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallMidnightPartyView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallMidnightPartyView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
