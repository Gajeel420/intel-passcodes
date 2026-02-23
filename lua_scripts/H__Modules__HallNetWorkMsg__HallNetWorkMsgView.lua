HallNetWorkMsgView = HallNetWorkMsgView or BaseClass()

function HallNetWorkMsgView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallNetWorkMsgView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallNetWorkMsgPanel.New(callBack)
	end
end

----必须实现
function HallNetWorkMsgView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallNetWorkMsgView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallNetWorkMsgView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallNetWorkMsgView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function HallNetWorkMsgView:ShowNotMsg(msg,noteMessage,showingTime,action) 
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowNotMsg(msg,noteMessage,showingTime,action) 
	end
end

function HallNetWorkMsgView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
