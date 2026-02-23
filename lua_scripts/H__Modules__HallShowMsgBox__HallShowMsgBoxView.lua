HallShowMsgBoxView = HallShowMsgBoxView or BaseClass()

function HallShowMsgBoxView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallShowMsgBoxView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallShowMsgBoxPanel.New(callBack)
	end
end

----必须实现
function HallShowMsgBoxView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function HallShowMsgBoxView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end
function HallShowMsgBoxView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end
----必须实现
function HallShowMsgBoxView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

-- title:标签，
-- context：内容；
-- enterCB：点击确定返回；
-- cancelCB：点击取消返回，
-- isShowCancel：true显示两个，fasle显示一个确定按钮；
-- isHideAll:隐藏所有按钮; 
-- isShowBtnClose:界面的关闭按钮
--btnEnterName 确定按钮名字
--btnCancelName 取消按钮名字
function HallShowMsgBoxView:ShowMessage(showBoxData)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowMessage(showBoxData)
	end
end
function HallShowMsgBoxView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end