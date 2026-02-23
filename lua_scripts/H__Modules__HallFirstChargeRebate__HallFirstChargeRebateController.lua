HallFirstChargeRebateController = HallFirstChargeRebateController or BaseClass(LuaController)
require"H/Modules/HallFirstChargeRebate/HallFirstChargeRebateView"
require"H/Modules/HallFirstChargeRebate/View/HallFirstChargeRebatePanel"
require"H/Modules/HallFirstChargeRebate/HallFirstChargeRebateModel"


function HallFirstChargeRebateController:__init( ... )
	self.view = HallFirstChargeRebateView.New()
end

function HallFirstChargeRebateController:GetInstance()
	if HallFirstChargeRebateController.instance == nil then
		HallFirstChargeRebateController.instance = HallFirstChargeRebateController.New()
	end
	return HallFirstChargeRebateController.instance
end

function HallFirstChargeRebateController:__delete( ... )
	HallFirstChargeRebateController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end