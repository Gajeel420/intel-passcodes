HallWithdrawView = HallWithdrawView or BaseClass()

function HallWithdrawView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallWithdrawView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallWithdrawPanel.New(callBack)
	end
end

----必须实现
function HallWithdrawView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallWithdrawView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function HallWithdrawView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallWithdrawView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end


function HallWithdrawView:ResetPanel( )
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ResetPanel()
	end
end

function HallWithdrawView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
