HallGameView = HallGameView or BaseClass()

function HallGameView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallGameView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallGamePanel.New(callBack)
	end
end

----必须实现
function HallGameView:ShowPanel(callBack,...)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack,...)
	end
end

----必须实现
function HallGameView:HidePanel(callBack,...)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel(callBack,...)
	end
end
function HallGameView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallGameView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end




function HallGameView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
