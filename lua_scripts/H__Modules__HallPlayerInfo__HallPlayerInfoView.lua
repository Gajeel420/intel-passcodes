HallPlayerInfoView = HallPlayerInfoView or BaseClass()

function HallPlayerInfoView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallPlayerInfoView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallPlayerInfoPanel.New(callBack)
	end
end

----必须实现
function HallPlayerInfoView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallPlayerInfoView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallPlayerInfoView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallPlayerInfoView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallPlayerInfoView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
