HallVipRechargeTipsController = HallVipRechargeTipsController or BaseClass(LuaController)
require"H/Modules/HallVipRechargeTips/HallVipRechargeTipsView"
require"H/Modules/HallVipRechargeTips/View/HallVipRechargeTipsPanel"
require"H/Modules/HallVipRechargeTips/HallVipRechargeTipsModel"


function HallVipRechargeTipsController:__init( ... )
	self.view = HallVipRechargeTipsView.New()
end

function HallVipRechargeTipsController:GetInstance()
	if HallVipRechargeTipsController.instance == nil then
		HallVipRechargeTipsController.instance = HallVipRechargeTipsController.New()
	end
	return HallVipRechargeTipsController.instance
end

function HallVipRechargeTipsController:__delete( ... )
	HallVipRechargeTipsController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end