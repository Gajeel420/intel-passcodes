HallAdPopController = HallAdPopController or BaseClass(LuaController)

require"H/Modules/HallAdPop/HallAdPopView"
require"H/Modules/HallAdPop/HallAdPopModel"
require"H/Modules/HallAdPop/View/HallAdPopPanel"

function HallAdPopController:__init( ... )
	self.model=HallAdPopModel:GetInstance()
	self.view = HallAdPopView.New()
end

function HallAdPopController:GetInstance()
	if HallAdPopController.instance == nil then
		HallAdPopController.instance = HallAdPopController.New()
	end
	return HallAdPopController.instance
end

function HallAdPopController:__delete( ... )
	self.view = nil
end
