HallRedEnvelopesView = HallRedEnvelopesView or BaseClass()

function HallRedEnvelopesView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRedEnvelopesView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRedEnvelopesPanel.New(callBack)
	end
end

----必须实现
function HallRedEnvelopesView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRedEnvelopesView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallRedEnvelopesView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallRedEnvelopesView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallRedEnvelopesView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end