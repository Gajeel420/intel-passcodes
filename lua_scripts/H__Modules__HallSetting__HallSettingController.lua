HallSettingController = HallSettingController or BaseClass(LuaController)

require"H/Modules/HallSetting/HallSettingView"
require"H/Modules/HallSetting/View/HallSettingPanel"

function HallSettingController:__init( ... )
	self.view = HallSettingView.New()

end

function HallSettingController:GetInstance()
	if HallSettingController.instance == nil then
		HallSettingController.instance = HallSettingController.New()
	end
	return HallSettingController.instance
end

function HallSettingController:__delete( ... )
	self.view = nil
end
