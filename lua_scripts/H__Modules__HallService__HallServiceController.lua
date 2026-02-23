HallServiceController = HallServiceController or BaseClass(LuaController)

require"H/Modules/HallService/HallServiceView"
require"H/Modules/HallService/HallServiceModel"
require"H/Modules/HallService/HallServiceConst"
require"H/Modules/HallService/View/HallServicePanel"
require"H/Modules/HallService/View/HallQQServiceGrid"
require"H/Modules/HallService/View/HallWechatServiceGrid"
require"H/Modules/HallService/View/HallServiceGrid"
require"H/Modules/HallService/Vo/HallServiceVo"

function HallServiceController:__init( ... )
	self.view = HallServiceView.New()
	self.model = HallServiceModel:GetInstance()
	self:AddEvent()
end

function HallServiceController:GetInstance()
	if HallServiceController.instance == nil then
		HallServiceController.instance = HallServiceController.New()
	end
	return HallServiceController.instance
end

--事件添加
function HallServiceController:AddEvent( )
	
end

function HallServiceController:RemoveEvent( )
	
end


function HallServiceController:ClearData()
	self.model.listData={}
end

function HallServiceController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end
