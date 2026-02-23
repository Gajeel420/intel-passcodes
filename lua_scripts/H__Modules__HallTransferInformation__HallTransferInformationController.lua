HallTransferInformationController = HallTransferInformationController or BaseClass(LuaController)
require"H/Modules/HallTransferInformation/HallTransferInformationView"
require"H/Modules/HallTransferInformation/View/HallTransferInformationPanel"
require"H/Modules/HallTransferInformation/View/CollectBankView"
require"H/Modules/HallTransferInformation/View/RechangeInfoView"
require"H/Modules/HallTransferInformation/HallTransferInformationMode"



function HallTransferInformationController:__init( ... )
	self.view = HallTransferInformationView.New()
	self.model = HallTransferInformationMode.New()
end

function HallTransferInformationController:GetInstance()
	if HallTransferInformationController.instance == nil then
		HallTransferInformationController.instance = HallTransferInformationController.New()
	end
	return HallTransferInformationController.instance
end

function HallTransferInformationController:__delete( ... )
	HallTransferInformationController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end