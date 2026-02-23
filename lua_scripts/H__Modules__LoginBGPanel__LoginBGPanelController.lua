LoginBGPanelController = LoginBGPanelController or BaseClass(LuaController)

require"H/Modules/LoginBGPanel/LoginBGPanelView"
require"H/Modules/LoginBGPanel/View/LoginBGPanel"

function LoginBGPanelController:__init( )
	self.view = LoginBGPanelView.New()
end

function LoginBGPanelController:GetInstance()
	if LoginBGPanelController.instance == nil then
		LoginBGPanelController.instance = LoginBGPanelController.New()
	end
	return LoginBGPanelController.instance
end

function LoginBGPanelController:__delete( ... )
	LoginBGPanelController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end