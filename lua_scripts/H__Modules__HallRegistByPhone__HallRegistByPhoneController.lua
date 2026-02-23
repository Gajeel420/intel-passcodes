HallRegistByPhoneController = HallRegistByPhoneController or BaseClass(LuaController)

require"H/Modules/HallRegistByPhone/HallRegistByPhoneView"
require"H/Modules/HallRegistByPhone/HallRegistByPhoneModel"
require"H/Modules/HallRegistByPhone/View/HallRegistByPhonePanel"

function HallRegistByPhoneController:__init( ... )
	self.model=HallRegistByPhoneModel:GetInstance()
	self.view = HallRegistByPhoneView.New()
end

function HallRegistByPhoneController:GetInstance()
	if HallRegistByPhoneController.instance == nil then
		HallRegistByPhoneController.instance = HallRegistByPhoneController.New()
	end
	return HallRegistByPhoneController.instance
end

function HallRegistByPhoneController:__delete( ... )
	self.view = nil
end
