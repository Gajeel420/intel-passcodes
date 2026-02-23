HallSignalStrengthController = HallSignalStrengthController or BaseClass(LuaController)
require"H/Modules/HallSignalStrength/HallSignalStrengthView"
require"H/Modules/HallSignalStrength/View/HallSignalStrengthPanel"

function HallSignalStrengthController:__init( ... )
	self.view = HallSignalStrengthView.New()
end

function HallSignalStrengthController:GetInstance()
	if HallSignalStrengthController.instance == nil then
		HallSignalStrengthController.instance = HallSignalStrengthController.New()
	end
	return HallSignalStrengthController.instance
end

function HallSignalStrengthController:__delete( ... )
	HallSignalStrengthController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end