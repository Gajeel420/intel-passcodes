HallExchangeController = HallExchangeController or BaseClass(LuaController)

require"H/Modules/HallExchange/HallExchangeView"
require"H/Modules/HallExchange/HallExchangeModel"
require"H/Modules/HallExchange/View/HallExchangePanel"
require"H/Modules/HallExchange/View/ExchangeView"
require"H/Modules/HallExchange/View/RecordView"
require"H/Modules/HallExchange/View/RecordItem"

function HallExchangeController:__init( ... )
	self.model=HallExchangeModel:GetInstance()
	self.view = HallExchangeView.New()
end

function HallExchangeController:GetInstance()
	if HallExchangeController.instance == nil then
		HallExchangeController.instance = HallExchangeController.New()
	end
	return HallExchangeController.instance
end

function HallExchangeController:__delete( ... )
	self.view = nil
end
