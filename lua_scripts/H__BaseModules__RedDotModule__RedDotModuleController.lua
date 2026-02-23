RedDotModuleController=RedDotModuleController or BaseClass(LuaController)

require"H/BaseModules/RedDotModule/RedDotModuleModel"
require"H/BaseModules/RedDotModule/RedDotModuleConst"

function RedDotModuleController:__init( ... )
	self.model = RedDotModuleModel.New()
end

function RedDotModuleController:GetInstance()
	if RedDotModuleController.instance==nil then
		RedDotModuleController.instance=RedDotModuleController.New()
	end
	return RedDotModuleController.instance
end

--- 添加红点事件
function RedDotModuleController:AddRedDotEvent(eventName, obj, targetType)
    self.model:AddRedDotEvent(eventName, obj, targetType)
end

--- 移除红点事件
function RedDotModuleController:RemoveRedDotEvent(eventName, obj)
    self.model:RemoveRedDotEvent(eventName, obj)
end

--- 通知处理红点事件
function RedDotModuleController:DispatchRedDotEvent(eventName, redDotState, num)
    self.model:DispatchRedDotEvent(eventName, redDotState, num)
end


function RedDotModuleController:__delete( ... )
	self.model:Destroy()
	self.model=nil
	RedDotModuleController.instance=nil
end