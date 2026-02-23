HallNoticeController = HallNoticeController or BaseClass(LuaController)

require"H/Modules/HallNotice/HallNoticeView"
require"H/Modules/HallNotice/Msg/CRspNotificationListMsgPara"
require"H/Modules/HallNotice/HallNoticeModel"
require"H/Modules/HallNotice/View/HallNoticePanel"

function HallNoticeController:__init( ... )
	self.view = HallNoticeView.New()
	self.model = HallNoticeModel.New()
	
end


function HallNoticeController:ShowNoticePanel()
	if ConfigModuleModel.GetInstance().NoticeMsg ~= "" then
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Notice)
	end
end

function HallNoticeController:GetInstance()
	if HallNoticeController.instance == nil then
		HallNoticeController.instance = HallNoticeController.New()
	end
	return HallNoticeController.instance
end

function HallNoticeController:__delete( ... )
	self.view = nil
end
