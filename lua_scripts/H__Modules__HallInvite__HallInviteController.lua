HallInviteController = HallInviteController or BaseClass(LuaController)

require"H/Modules/HallInvite/HallInviteView"
require"H/Modules/HallInvite/View/HallInvitePanel"

function HallInviteController:__init( ... )
	self.view = HallInviteView.New()
end

function HallInviteController:GetInstance()
	if HallInviteController.instance == nil then
		HallInviteController.instance = HallInviteController.New()
	end
	return HallInviteController.instance
end

function HallInviteController:__delete( ... )
	self.view = nil
end