GameModel=BaseClass(LuaModel)

function GameModel:__init( ... )
	self.soundVolume=SystemSetting:GetInstance():GetIsSoundOn() and 1 or 0
	self.musicVolume=SystemSetting:GetInstance():GetIsBGMusicOn() and 1 or 0

	self.isSendBet = false

	self.m_MyBetIndex = 1       --下注筹码索引
	self.m_BetList = {}         --筹码列表
	self.m_MyBetMoney = 1       --下注的Money
	self.m_MyOdds = 1.01        --下注赔率
	self.m_MyWinMoney = 0       --赢分
	self.m_MyBalanceMoney = 0   --余额
	self.m_CountDown = 0        --倒计时
	self.m_MyDeskStation = 0

	self.IsAuto = false
	self.AutoCount = 1          --自动次数
	self.CurrentAutoCount = 0   --当前自动次数
	self.RemainAutoCount = 0    --剩余自动次数

	self.isFirstOpenPrize = false        --是否第一次进入开奖
	self.isFirstAccount = false        --是否第一次进入结算

	self.UIRealWidth = LuaUtils.GetUIRealWidth()
	self.m_GameState = GameLuaDefine.GameStateType.STATE_BET

end

function GameModel:GetInstance( ... )
	if not GameModel.instance then
		GameModel.instance=GameModel.New()
	end
	return GameModel.instance
end

function GameModel:__delete( ... )
	GameModel.instance=nil
end

--重置界面数据
function GameModel:ResetViewData()

end

--#region 下注

--设置筹码列表
function GameModel:SetBetListData(betIndex,betlist)
	if betlist == nil then
		self.m_BetList = {}
		return
	end
	self.m_BetList = betlist
	self.m_MyBetIndex = betIndex + 1
	self:SetMyBetMoney()
end

--获取当前筹码个数
function GameModel:GetBetListNum()
	if self.m_BetList == nil then
		self.m_BetList = {}
	end
	return #self.m_BetList
end

--添加下注
function GameModel:AddBetMoney()
	self.m_MyBetIndex = self.m_MyBetIndex + 1
	if self.m_MyBetIndex > self:GetBetListNum() then
		self.m_MyBetIndex = 1
	end
	self:SetMyBetMoney()
end

--减少下注
function GameModel:ReduceBetMoney()
	self.m_MyBetIndex = self.m_MyBetIndex - 1
	if self.m_MyBetIndex < 1 then
		self.m_MyBetIndex = self:GetBetListNum()
	end
	self:SetMyBetMoney()
end

--获得当前下注的筹码
function GameModel:GetMyBetMoney()
	return self.m_MyBetMoney
end

--设置当前下注的筹码
function GameModel:SetMyBetMoney()
	self.m_MyBetMoney = self:GetBetItemData(self.m_MyBetIndex)
end

--获取筹码个数
function GameModel:GetBetItemData(index)
	if self.m_BetList == nil then
		self.m_BetList = {}
	end

	if index  > #self.m_BetList or index  < 1 then
		return 
	end
	return self.m_BetList[index]
end
--#endregion 下注

--#region 游戏状态

--设置游戏状态
function GameModel:SetGameState(gameState)
	if gameState >= GameLuaDefine.GameStateType.STATE_MAX then
		print("状态错误")
		return
	end

	self.m_GameState = gameState
end

--获得游戏状态
function GameModel:GetGameState(gameState)
	return self.m_GameState
end
--#endregion 游戏状态
