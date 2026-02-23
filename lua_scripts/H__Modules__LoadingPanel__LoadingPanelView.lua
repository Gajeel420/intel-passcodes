LoadingPanelView = LoadingPanelView or BaseClass()

function LoadingPanelView:__init()
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function LoadingPanelView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = LoadingPanel.New(callBack)
	end
end

----必须实现
function LoadingPanelView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function LoadingPanelView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function LoadingPanelView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function LoadingPanelView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function LoadingPanelView:__delete()
	self.prefab = nil 
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end