HallWealthListController = HallWealthListController or BaseClass(LuaController)

require"H/Modules/HallWealthList/HallWealthListView"
require"H/Modules/HallWealthList/HallWealthListModel"
require"H/Modules/HallWealthList/HallWealthListConst"
require"H/Modules/HallWealthList/View/HallWealthListPanel"
require"H/Modules/HallWealthList/View/HallWealthListGrid"
require"H/Modules/HallWealthList/Vo/HallWealthListVo"

require"H/Modules/HallWealthList/msg/CRspQueryRechargeListPara"
require"H/Modules/HallWealthList/msg/CRspQueryWinRankingListPara"
require"H/Modules/HallWealthList/msg//CRspQueryRechargeRankingListPara"

function HallWealthListController:__init( ... )
	self.model = HallWealthListModel:GetInstance()
	self.view = HallWealthListView.New()
end


function HallWealthListController:GetInstance()
	if HallWealthListController.instance == nil then
		HallWealthListController.instance = HallWealthListController.New()
	end
	return HallWealthListController.instance
end

function HallWealthListController:__delete( ... )
	self.view = nil
end
