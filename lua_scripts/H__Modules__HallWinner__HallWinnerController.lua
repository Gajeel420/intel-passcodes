HallWinnerController = HallWinnerController or BaseClass(LuaController)
require"H/Modules/HallWinner/HallWinnerView"
require"H/Modules/HallWinner/View/HallWinnerPanel"
require"H/Modules/HallWinner/HallWinnerModel"


function HallWinnerController:__init( ... )
	self.view = HallWinnerView.New()
	self.model = HallWinnerModel:GetInstance()
end

function HallWinnerController:GetInstance()
	if HallWinnerController.instance == nil then
		HallWinnerController.instance = HallWinnerController.New()
	end
	return HallWinnerController.instance
end

function HallWinnerController:__delete( ... )
	HallWinnerController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end