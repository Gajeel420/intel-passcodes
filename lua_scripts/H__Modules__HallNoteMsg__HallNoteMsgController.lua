HallNoteMsgController = HallNoteMsgController or BaseClass(LuaController)

require"H/Modules/HallNoteMsg/HallNoteMsgView"
require"H/Modules/HallNoteMsg/View/HallNoteMsgPanel"

function HallNoteMsgController:__init( ... )
	self.view = HallNoteMsgView.New()

end

function HallNoteMsgController:AddEvent()
	-- LuaEvent:AddEventListener(EventName.CSTOLUA_NOTEMESSAGE,self.CSToLuaMessage,self)
end

function HallNoteMsgController:RemoveEvent( ... )
	-- LuaEvent:RemoveEventListener(EventName.CSTOLUA_NOTEMESSAGE,self.CSToLuaMessage,self)
end

function HallNoteMsgController:GetInstance()
	if HallNoteMsgController.instance == nil then
		HallNoteMsgController.instance = HallNoteMsgController.New()
	end
	return HallNoteMsgController.instance
end

function HallNoteMsgController:CSToLuaMessage( context )
	if context and context.m_data then
		local strContext=context.m_data[0]
		UIManager:GetInstance():ShowNoteMessage(strContext)
	end
end

-- 显示窗体 msg = 显示信息   showingTime = 显示时间 默认0.5秒   isCenter = 是否居中显示
function HallNoteMsgController:ShowNotMsg(msg, showingTime, isCenter,isForce)
	if self.view then 
		self.view.panel:ShowNotMsg(msg, showingTime, isCenter,isForce)
	end
end


function HallNoteMsgController:__delete( ... )
	self:RemoveEvent()
	self.view = nil
end
