GameJackPotNotyVo = GameJackPotNotyVo or BaseClass(LuaModel)

function GameJackPotNotyVo:__init( ... )
	-- body
	self.m_unUIN = ""
	self.m_szNickName = ""
	self.m_usGameName = ""
	self.m_iLotteryType = ""
	self.m_un64Profit = ""
end

function GameJackPotNotyVo:InitData(m_unUIN,m_szNickName,m_usGameName,m_iLotteryType,m_un64Profit)
	-- body
	self.m_unUIN = m_unUIN
	self.m_szNickName = m_szNickName
	self.m_usGameName = m_usGameName
	self.m_iLotteryType = m_iLotteryType
	self.m_un64Profit = m_un64Profit
end

function GameJackPotNotyVo:__delete( ... )
	-- body
	self.m_unUIN = nil
	self.m_szNickName = nil
	self.m_usGameName = nil
	self.m_iLotteryType = nil
	self.m_un64Profit = nil
end