
HallModifyPasswordView = HallModifyPasswordView or BaseClass()

function HallModifyPasswordView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallModifyPasswordView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallModifyPasswordPanel.New(callBack)
	end
end

----必须实现
function HallModifyPasswordView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallModifyPasswordView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallModifyPasswordView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallModifyPasswordView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallModifyPasswordView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
