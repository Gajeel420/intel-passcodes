LevelStruct = LevelStruct or BaseClass()

function LevelStruct:__init( ... )
	self.m_nLevelID=0; --//等级ID
	self.m_unMinMoney=0;--//最少带入金额
	self.m_unMaxMoney=0;--//最大带入金额
	self.m_unStartCoins=0; --//体验场带入金币
	self.m_nFlag=0;--//标志，是体验场还是普通场 1是体验场 0是普通场
	-- self.m_szName=""
	self.m_usGameID=0
end

function LevelStruct:InitVo(vo)
	if vo then
		for k,v in pairs(vo) do
			if type(v)~="function" then
				self[k] = v
			end
		end
	end
end

function LevelStruct:__delete( ... )
	self.m_nLevelID=0; --//等级ID
	self.m_unMinMoney=0;--//最少带入金额
	self.m_unMaxMoney=0;--//最大带入金额
	self.m_unStartCoins=0; --//体验场带入金币
	self.m_nFlag=0;--//标志，是体验场还是普通场 1是体验场 0是普通场
	self.m_usGameID=0
end