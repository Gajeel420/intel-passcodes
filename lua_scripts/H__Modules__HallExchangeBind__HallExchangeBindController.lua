HallExchangeBindController = HallExchangeBindController or BaseClass(LuaController)

require"H/Modules/HallExchangeBind/HallExchangeBindView"
require"H/Modules/HallExchangeBind/HallExchangeBindModel"
require"H/Modules/HallExchangeBind/View/HallExchangeBindPanel"
require"H/Modules/HallExchangeBind/View/PopupWindowItem"
require"H/Modules/HallExchangeBind/View/PopupWindow"

function HallExchangeBindController:__init( ... )
	self.model=HallExchangeBindModel:GetInstance()
	self.view = HallExchangeBindView.New()
end

function HallExchangeBindController:GetInstance()
	if HallExchangeBindController.instance == nil then
		HallExchangeBindController.instance = HallExchangeBindController.New()
	end
	return HallExchangeBindController.instance
end



function HallExchangeBindController:__delete( ... )
	self.view = nil
end
