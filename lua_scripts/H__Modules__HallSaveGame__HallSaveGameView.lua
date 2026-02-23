HallSaveGameView = HallSaveGameView or BaseClass()

function HallSaveGameView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallSaveGameView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallSaveGamePanel.New(callBack)
	end
end

----必须实现
function HallSaveGameView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallSaveGameView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallSaveGameView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallSaveGameView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
function HallSaveGameView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end