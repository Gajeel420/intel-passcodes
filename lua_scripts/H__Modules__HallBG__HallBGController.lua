HallBGController = HallBGController or BaseClass(LuaController)
require"H/Modules/HallBG/HallBGView"
require"H/Modules/HallBG/View/HallBGPanel"

function HallBGController:__init( ... )
	print("HallBGController")
	self.view = HallBGView.New()
end

function HallBGController:GetInstance()
	if HallBGController.instance == nil then
		HallBGController.instance = HallBGController.New()
	end
	return HallBGController.instance
end

function HallBGController:__delete( ... )
	HallBGController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end