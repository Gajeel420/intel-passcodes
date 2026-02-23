HallGiftController = HallGiftController or BaseClass(LuaController)
require"H/Modules/HallGift/HallGiftView"
require"H/Modules/HallGift/View/HallGiftPanel"
require"H/Modules/HallGift/HallGiftModel"
require"H/Modules/HallGift/View/GiveSuccess"



function HallGiftController:__init( ... )
	self.view = HallGiftView.New()
	self.model = HallGiftModel.New()
end

function HallGiftController:GetInstance()
	if HallGiftController.instance == nil then
		HallGiftController.instance = HallGiftController.New()
	end
	return HallGiftController.instance
end

function HallGiftController:__delete( ... )
	HallGiftController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end