HallSettingView = HallSettingView or BaseClass()

function HallSettingView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallSettingView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallSettingPanel.New(callBack)
	end
end

----必须实现
function HallSettingView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallSettingView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallSettingView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallSettingView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallSettingView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
