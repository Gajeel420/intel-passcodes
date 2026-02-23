HallGameJackPotNotyController = HallGameJackPotNotyController or BaseClass(LuaController)

require"H/Modules/HallGameJackPotNoty/HallGameJackPotNotyView"
require"H/Modules/HallGameJackPotNoty/View/HallGameJackPotNotyPanel"

function HallGameJackPotNotyController:__init( ... )
	-- body
	self.view = HallGameJackPotNotyView.New()
end


function HallGameJackPotNotyController:GetInstance()
	if HallGameJackPotNotyController.instance == nil then
		HallGameJackPotNotyController.instance = HallGameJackPotNotyController.New()
	end
	return HallGameJackPotNotyController.instance
end

function HallGameJackPotNotyController:__delete( ... )
	HallGameJackPotNotyController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end