HallChanagePasswordController = HallChanagePasswordController or BaseClass(LuaController)

require"H/Modules/HallChanagePassword/HallChanagePasswordView"
require"H/Modules/HallChanagePassword/HallChanagePasswordModel"
require"H/Modules/HallChanagePassword/View/HallChanagePasswordPanel"

function HallChanagePasswordController:__init( ... )
	self.model=HallChanagePasswordModel:GetInstance()
	self.view = HallChanagePasswordView.New()
end

function HallChanagePasswordController:GetInstance()
	if HallChanagePasswordController.instance == nil then
		HallChanagePasswordController.instance = HallChanagePasswordController.New()
	end
	return HallChanagePasswordController.instance
end

function HallChanagePasswordController:__delete( ... )
	self.view = nil
end
