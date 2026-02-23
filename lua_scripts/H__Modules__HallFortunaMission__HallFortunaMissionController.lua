HallFortunaMissionController = HallFortunaMissionController or BaseClass(LuaController)
require"H/Modules/HallFortunaMission/HallFortunaMissionView"
require"H/Modules/HallFortunaMission/View/HallFortunaMissionPanel"
require"H/Modules/HallFortunaMission/HallFortunaMissionModel"
require"H/Modules/HallFortunaMission/View/HallFortunaMissionTitleItem"
require"H/Modules/HallFortunaMission/View/HallFortunaMissionTaskItem"



function HallFortunaMissionController:__init( ... )
	self.view = HallFortunaMissionView.New()
end

function HallFortunaMissionController:GetInstance()
	if HallFortunaMissionController.instance == nil then
		HallFortunaMissionController.instance = HallFortunaMissionController.New()
	end
	return HallFortunaMissionController.instance
end

function HallFortunaMissionController:__delete( ... )
	HallFortunaMissionController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end