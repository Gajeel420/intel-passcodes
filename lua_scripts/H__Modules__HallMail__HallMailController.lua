HallMailController = HallMailController or BaseClass(LuaController)

require"H/Modules/HallMail/HallMailView"
require"H/Modules/HallMail/HallMailModel"
require"H/Modules/HallMail/HallMailConst"
require"H/Modules/HallMail/View/HallMailPanel"
require"H/Modules/HallMail/View/HallMailGrid"

require"H/Modules/HallMail/Msg/CNotifyEmailMsgPara"
require"H/Modules/HallMail/Msg/CRspQueryGlodEmailMsgPara"

function HallMailController:__init( ... )
	self.model=HallMailModel:GetInstance()
	self.view = HallMailView.New()
end



function HallMailController:GetInstance()
	if HallMailController.instance == nil then
		HallMailController.instance = HallMailController.New()
	end
	return HallMailController.instance
end

function HallMailController:__delete( ... )

	self.view = nil
end
