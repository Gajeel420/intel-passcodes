HallRankView = HallRankView or BaseClass()

function HallRankView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallRankView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallRankPanel.New(callBack)
	end
end

----必须实现
function HallRankView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallRankView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallRankView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallRankView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end

function HallRankView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
