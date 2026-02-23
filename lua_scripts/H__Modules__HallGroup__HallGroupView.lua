HallGroupView = HallGroupView or BaseClass()

function HallGroupView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGroupView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGroupPanel.New(callBack)
	end
end

----必须实现
function HallGroupView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end


----必须实现
function HallGroupView:HidePanel(callBack,...)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel(callBack,...)
	end
end


function HallGroupView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallGroupView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallGroupView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end