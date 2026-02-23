HallSignalController = HallSignalController or BaseClass(LuaController)

require"H/Modules/HallSignal/HallSignalView"
require"H/Modules/HallSignal/HallSignalModel"
require"H/Modules/HallSignal/View/HallSignalPanel"

function HallSignalController:__init( ... )
	self.model=HallSignalModel:GetInstance()
	self.view = HallSignalView.New()
end

function HallSignalController:GetInstance()
	if HallSignalController.instance == nil then
		HallSignalController.instance = HallSignalController.New()
	end
	return HallSignalController.instance
end

function HallSignalController:__delete( ... )
	self.view = nil
end
