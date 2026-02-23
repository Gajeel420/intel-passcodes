HallPaymentOpeningController = HallPaymentOpeningController or BaseClass(LuaController)
require"H/Modules/HallPaymentOpening/HallPaymentOpeningView"
require"H/Modules/HallPaymentOpening/View/HallPaymentOpeningPanel"

function HallPaymentOpeningController:__init( ... )
	self.view = HallPaymentOpeningView.New()
end

function HallPaymentOpeningController:GetInstance()
	if HallPaymentOpeningController.instance == nil then
		HallPaymentOpeningController.instance = HallPaymentOpeningController.New()
	end
	return HallPaymentOpeningController.instance
end

function HallPaymentOpeningController:__delete( ... )
	HallPaymentOpeningController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end