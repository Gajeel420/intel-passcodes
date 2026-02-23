HallGiftSummaryController = HallGiftSummaryController or BaseClass(LuaController)
require"H/Modules/HallGiftSummary/HallGiftSummaryView"
require"H/Modules/HallGiftSummary/View/HallGiftSummaryPanel"
require"H/Modules/HallGiftSummary/HallGiftSummaryModel"
require"H/Modules/HallGiftSummary/View/UISummaryGrid"



function HallGiftSummaryController:__init( ... )
	self.view = HallGiftSummaryView.New()
	self.model = HallGiftSummaryModel.New()
end

function HallGiftSummaryController:GetInstance()
	if HallGiftSummaryController.instance == nil then
		HallGiftSummaryController.instance = HallGiftSummaryController.New()
	end
	return HallGiftSummaryController.instance
end

function HallGiftSummaryController:__delete( ... )
	HallGiftSummaryController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end