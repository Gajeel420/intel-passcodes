ConfigModuleController=ConfigModuleController or BaseClass(LuaController)
require"H/BaseModules/ConfigModule/ConfigModuleModel"
function ConfigModuleController:__init()
	self.model=ConfigModuleModel:GetInstance()
end

function ConfigModuleController:GetInstance()
	if ConfigModuleController.instance==nil then 
		ConfigModuleController.instance=ConfigModuleController.New()
	end
	return ConfigModuleController.instance
end

function ConfigModuleController:__delete()
	
end