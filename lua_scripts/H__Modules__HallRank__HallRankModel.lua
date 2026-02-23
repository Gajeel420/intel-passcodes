HallRankModel = HallRankModel or BaseClass(LuaModel)

function HallRankModel:__init( ... )
	self.mWinCoinRankList = {}
end

function HallRankModel:GetInstance()
	if HallRankModel.instance == nil then
		HallRankModel.instance = HallRankModel.New()
	end
	return HallRankModel.instance
end

function HallRankModel:GetWinCoinRankList()
    return self.mWinCoinRankList
end

function HallRankModel:__delete( ... )

end