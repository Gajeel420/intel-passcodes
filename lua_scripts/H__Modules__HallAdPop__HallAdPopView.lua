HallAdPopView = HallAdPopView or BaseClass()

function HallAdPopView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallAdPopView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallAdPopPanel.New(callBack)
	end
end

----必须实现
function HallAdPopView:ShowPanel(callBack)
	PrintLog(self.panel==nil)
	PrintLog(self.panel.isInited)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallAdPopView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallAdPopView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallAdPopView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end