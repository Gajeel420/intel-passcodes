HallShowMsgBoxController = HallShowMsgBoxController or BaseClass(LuaController)
require"H/Modules/HallShowMsgBox/HallShowMsgBoxView"
require"H/Modules/HallShowMsgBox/View/HallShowMsgBoxPanel"

function HallShowMsgBoxController:__init( ... )
	self.view = HallShowMsgBoxView.New()
	-- self:AddEvent()
end

function HallShowMsgBoxController:AddEvent()
	-- LuaEvent:AddEventListener(EventName.CSTOLUA_SURENOTE,self.CSToLuaMassage,self)
	-- LuaEvent:AddEventListener(EventName.NOTICE_DOWN,self.ShowMessageOfDown,self)
end

function HallShowMsgBoxController:RemoveEvent()
	-- LuaEvent:RemoveEventListener(EventName.CSTOLUA_SURENOTE,self.CSToLuaMassage,self)
	-- LuaEvent:RemoveEventListener(EventName.NOTICE_DOWN,self.ShowMessageOfDown,self)
end


function HallShowMsgBoxController:ShowMessageOfDown(showBoxData)
	self.view.panel:ShowMessage(showBoxData)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.MessageBox)
end

function HallShowMsgBoxController:ShowMessageOfUpdate(context)
	
end

function HallShowMsgBoxController:ShowMessage(showBoxData)
	if self.view~=nil and self.view.isInited then 
		self.view:ShowMessage(showBoxData)
	end
end

function HallShowMsgBoxController:GetInstance()
	if HallShowMsgBoxController.instance == nil then
		HallShowMsgBoxController.instance = HallShowMsgBoxController.New()
	end
	return HallShowMsgBoxController.instance
end

function HallShowMsgBoxController:__delete( ... )
	self:RemoveEvent()
	HallShowMsgBoxController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end