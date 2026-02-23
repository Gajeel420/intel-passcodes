HallSaveGameController = HallSaveGameController or BaseClass(LuaController)
require"H/Modules/HallSaveGame/HallSaveGameView"
require"H/Modules/HallSaveGame/View/HallSaveGamePanel"

function HallSaveGameController:__init( ... )
	self.view = HallSaveGameView.New()
end

function HallSaveGameController:GetInstance()
	if HallSaveGameController.instance == nil then
		HallSaveGameController.instance = HallSaveGameController.New()
	end
	return HallSaveGameController.instance
end

function HallSaveGameController:__delete( ... )
	HallSaveGameController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end