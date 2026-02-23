HallFortunaMissionView = HallFortunaMissionView or BaseClass()

function HallFortunaMissionView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallFortunaMissionView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallFortunaMissionPanel.New(callBack)
	end
end

----必须实现
function HallFortunaMissionView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallFortunaMissionView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallFortunaMissionView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallFortunaMissionView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallFortunaMissionView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end