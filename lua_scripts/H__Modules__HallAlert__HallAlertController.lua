HallAlertController = HallAlertController or BaseClass(LuaController)

require"H/Modules/HallAlert/HallAlertView"
require"H/Modules/HallAlert/View/HallAlertPanel"


function HallAlertController:__init( ... )
	self.view = HallAlertView.New()
end

function HallAlertController:GetInstance()
	if HallAlertController.instance == nil then
		HallAlertController.instance = HallAlertController.New()
	end
	return HallAlertController.instance
end

function HallAlertController:__delete( ... )
	self.view = nil
end
