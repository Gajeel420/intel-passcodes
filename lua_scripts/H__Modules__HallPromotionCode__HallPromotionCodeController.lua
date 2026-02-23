HallPromotionCodeController = HallPromotionCodeController or BaseClass(LuaController)
require"H/Modules/HallPromotionCode/HallPromotionCodeView"
require"H/Modules/HallPromotionCode/View/HallPromotionCodePanel"

function HallPromotionCodeController:__init( ... )
	print("HallPromotionCodeController")
	self.view = HallPromotionCodeView.New()
end

function HallPromotionCodeController:GetInstance()
	if HallPromotionCodeController.instance == nil then
		HallPromotionCodeController.instance = HallPromotionCodeController.New()
	end
	return HallPromotionCodeController.instance
end

function HallPromotionCodeController:__delete( ... )
	HallPromotionCodeController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end