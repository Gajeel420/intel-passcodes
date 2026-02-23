HallNoticeView = HallNoticeView or BaseClass()

function HallNoticeView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallNoticeView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallNoticePanel.New(callBack)
	end
end

----必须实现
function HallNoticeView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallNoticeView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallNoticeView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallNoticeView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallNoticeView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
