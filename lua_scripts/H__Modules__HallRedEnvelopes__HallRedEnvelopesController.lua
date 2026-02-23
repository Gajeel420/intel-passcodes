HallRedEnvelopesController = HallRedEnvelopesController or BaseClass(LuaController)
require"H/Modules/HallRedEnvelopes/HallRedEnvelopesView"
require"H/Modules/HallRedEnvelopes/View/HallRedEnvelopesPanel"
require"H/Modules/HallRedEnvelopes/HallRedEnvelopesModel"

function HallRedEnvelopesController:__init( ... )
	self.view = HallRedEnvelopesView.New()
	self.model = HallRedEnvelopesModel.New()
	print("HallRedEnvelopesControllerHallRedEnvelopesController")
	
end

function HallRedEnvelopesController:GetInstance()
	if HallRedEnvelopesController.instance == nil then
		HallRedEnvelopesController.instance = HallRedEnvelopesController.New()
	end
	return HallRedEnvelopesController.instance
end

function HallRedEnvelopesController:__delete( ... )
	HallRedEnvelopesController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end