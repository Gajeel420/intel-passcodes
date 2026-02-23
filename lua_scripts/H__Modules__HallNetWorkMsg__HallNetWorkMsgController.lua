HallNetWorkMsgController = HallNetWorkMsgController or BaseClass(LuaController)

require"H/Modules/HallNetWorkMsg/HallNetWorkMsgView"
require"H/Modules/HallNetWorkMsg/View/HallNetWorkMsgPanel"

function HallNetWorkMsgController:__init( ... )
	self.view = HallNetWorkMsgView.New()
	self:AddEvent()

end

function HallNetWorkMsgController:GetInstance()
	if HallNetWorkMsgController.instance == nil then
		HallNetWorkMsgController.instance = HallNetWorkMsgController.New()
	end
	return HallNetWorkMsgController.instance
end

function HallNetWorkMsgController:ShowNotMsg(msg,noteMessage,showingTime,action) 
	if self.view~=nil then
		self.view:ShowNotMsg(msg,noteMessage,showingTime,action) 
	end
end

function HallNetWorkMsgController:AddEvent( )
	LuaEvent:AddEventListener(EventName.NETWORKMSG_OUTAGE,self.OUTAGE,self)
	LuaEvent:AddEventListener(EventName.NETWORKMSG_ONLINE,self.ONLINE,self)
end

function HallNetWorkMsgController:RemoveEvent( )
	LuaEvent:RemoveEventListener(EventName.NETWORKMSG_OUTAGE,self.OUTAGE,self)
	LuaEvent:RemoveEventListener(EventName.NETWORKMSG_ONLINE,self.ONLINE,self)
end


function HallNetWorkMsgController:OUTAGE()
	if self.view and self.view.panel ~=nil and self.view.panel.isInited then
		self.view.panel:OUTAGE()
	end
end


function HallNetWorkMsgController:ONLINE()
	if self.view and self.view.panel ~=nil and self.view.panel.isInited then
		self.view.panel:ONLINE()
	end
end

function HallNetWorkMsgController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end