NotifyModuleController=NotifyModuleController or BaseClass(LuaController)

require"H/BaseModules/NotifyModule/NotifyModuleModel"
require"H/BaseModules/NotifyModule/NotifyModuleConst"
require"H/BaseModules/NotifyModule/Msg/CNotifyNotificationMsg"

function NotifyModuleController:__init( ... )
	self.model=NotifyModuleModel:GetInstance()
	-- self:AddEvent()
	self:RegistProto()
end

function NotifyModuleController:RegistProto()
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_NOTIFICATION,"NotifyNotificationMsg")
end

function NotifyModuleController:RemoveProto( ... )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_NOTIFICATION,"NotifyNotificationMsg")
end

function NotifyModuleController:NotifyNotificationMsg(buffer )
	local msg=CNotifyNotificationMsg.Decode(buffer)
	self.model:AddNotifyList(msg)
end

function NotifyModuleController:GetInstance()
	if NotifyModuleController.instance==nil then
		NotifyModuleController.instance=NotifyModuleController.New()
	end
	return NotifyModuleController.instance
end

function NotifyModuleController:__delete( ... )
	self:RemoveProto()
	self:RemoveEvent()
	self.model:Destroy()
	self.model=nil
	NotifyModuleController.instance=nil
end