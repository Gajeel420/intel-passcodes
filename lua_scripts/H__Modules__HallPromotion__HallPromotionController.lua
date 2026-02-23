HallPromotionController = HallPromotionController or BaseClass(LuaController)

require"H/Modules/HallPromotion/View/BonusNote/BonusNoteItem"
require"H/Modules/HallPromotion/View/BonusNote/BonusNoteView"
require"H/Modules/HallPromotion/View/BonusNote/BonusNoteMapView"
require"H/Modules/HallPromotion/View/CashWithdrawal/CashWithdrawalItem"
require"H/Modules/HallPromotion/View/CashWithdrawal/CashWithdrawalView"
require"H/Modules/HallPromotion/View/DevelopmentOffline/DevelopmentOfflineView"
require"H/Modules/HallPromotion/View/PerformanceEnquiry/DayPerformance/DayPerformanceItem"
require"H/Modules/HallPromotion/View/PerformanceEnquiry/DayPerformance/DayPerformanceView"
require"H/Modules/HallPromotion/View/PerformanceEnquiry/PerformanceEnquiryItem"
require"H/Modules/HallPromotion/View/PerformanceEnquiry/PerformanceEnquiryView"
require"H/Modules/HallPromotion/View/Recommend/RecommendView"
require"H/Modules/HallPromotion/View/TeamManagement/TeamManagementItem"
require"H/Modules/HallPromotion/View/TeamManagement/TeamManagementView"
require"H/Modules/HallPromotion/View/HallPromotionPanel"
require"H/Modules/HallPromotion/HallPromotionView"
require"H/Modules/HallPromotion/HallPromotionModel"
require"H/Modules/HallPromotion/View/PromotionBindView"






function HallPromotionController:__init( ... )
	self.view = HallPromotionView.New()
	self.model = HallPromotionModel:GetInstance()
	self:AddEvent()
end

function HallPromotionController:GetInstance()
	if HallPromotionController.instance == nil then
		HallPromotionController.instance = HallPromotionController.New()
	end
	return HallPromotionController.instance
end

--事件添加
function HallPromotionController:AddEvent( )
	
end

function HallPromotionController:RemoveEvent( )
	
end



function HallPromotionController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end
