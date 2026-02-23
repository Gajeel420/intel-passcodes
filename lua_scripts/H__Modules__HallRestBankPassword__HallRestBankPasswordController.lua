HallRestBankPasswordController = HallRestBankPasswordController or BaseClass(LuaController)

require"H/Modules/HallRestBankPassword/HallRestBankPasswordView"
require"H/Modules/HallRestBankPassword/HallRestBankPasswordModel"
require"H/Modules/HallRestBankPassword/View/HallRestBankPasswordPanel"

function HallRestBankPasswordController:__init( ... )
	self.model=HallRestBankPasswordModel:GetInstance()
	self.view = HallRestBankPasswordView.New()
end

function HallRestBankPasswordController:GetInstance()
	if HallRestBankPasswordController.instance == nil then
		HallRestBankPasswordController.instance = HallRestBankPasswordController.New()
	end
	return HallRestBankPasswordController.instance
end

function HallRestBankPasswordController:__delete( ... )
	self.view = nil
end
