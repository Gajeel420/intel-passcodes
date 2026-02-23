HallPhoneVerificationController = HallPhoneVerificationController or BaseClass(LuaController)

require"H/Modules/HallPhoneVerification/View/HallPhoneVerificationPanel"
require"H/Modules/HallPhoneVerification/HallPhoneVerificationView"

function HallPhoneVerificationController:__init( ... )
	self.view = HallPhoneVerificationView.New()
end

function HallPhoneVerificationController:GetInstance()
	if HallPhoneVerificationController.instance == nil then
		HallPhoneVerificationController.instance = HallPhoneVerificationController.New()
	end
	return HallPhoneVerificationController.instance
end

function HallPhoneVerificationController:__delete( ... )
	self.view = nil
end
