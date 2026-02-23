HallGameController = HallGameController or BaseClass(LuaController)

require"H/Modules/HallGame/HallGameView"
require"H/Modules/HallGame/HallGameModel"
require"H/Modules/HallGame/View/HallGamePanel"
require"H/Modules/HallGame/View/HallGameGrid"
require"H/Modules/HallGame/View/HallGameBaseGrid"
require"H/Modules/HallGame/View/HallQmtgView"
require"H/Modules/HallGame/Vo/HallGameVo"
require"H/Modules/HallGame/View/HallSecondarGameView"
require"H/Modules/HallGame/View/EffectPoint"

function HallGameController:__init( ... )
	self.view = HallGameView.New()
	self.model=HallGameModel:GetInstance()
	self:RegistProto()
end

function HallGameController:RegistProto( ... )
	--广播奖池信息
	-- self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SVR_BROADCAST_LOTTERY_POOL,"ResponseLotteryPoolHandler")
end

function HallGameController:AddEvent()
	-- LuaEvent:AddEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

function HallGameController:RemoveEvent()
	--LuaEvent:RemoveEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

function HallGameController:InitPlayerCompeleted(context)
	-- self:RequestAllCaiJin()
end

function HallGameController:GetInstance()
	if HallGameController.instance == nil then
		HallGameController.instance = HallGameController.New()
	end
	return HallGameController.instance
end





function HallGameController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end
