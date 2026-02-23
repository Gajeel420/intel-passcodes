HallBindPhoneController = HallBindPhoneController or BaseClass(LuaController)

require"H/Modules/HallBindPhone/HallBindPhoneView"
require"H/Modules/HallBindPhone/HallBindPhoneModel"
require"H/Modules/HallBindPhone/View/HallBindPhonePanel"

function HallBindPhoneController:__init( ... )
	self.model=HallBindPhoneModel:GetInstance()
	
	self.view = HallBindPhoneView.New()

end


function HallBindPhoneController:GetInstance()
	if HallBindPhoneController.instance == nil then
		HallBindPhoneController.instance = HallBindPhoneController.New()
	end
	return HallBindPhoneController.instance
end

function HallBindPhoneController:__delete( ... )
	self.view = nil
end
