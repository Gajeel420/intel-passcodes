HallRoomPanelModel = HallRoomPanelModel or BaseClass(LuaModel)

function HallRoomPanelModel:__init( ... )
	self.mGoldGameRoomInfoDic = {} --缓存房间信息
	self.m_GameLevelInfo = {}--保存房间等级信息(用作显示)
	self.IsCanClickSeat = true   --是否可以选择座位
end


function HallRoomPanelModel:GetInstance()
	if HallRoomPanelModel.instance == nil then
		HallRoomPanelModel.instance = HallRoomPanelModel.New()
	end
	return HallRoomPanelModel.instance
end





function HallRoomPanelModel:IsContrainRoomList(gameid)
	if self.mGoldGameRoomInfoDic~=nil then 
		local info = self.mGoldGameRoomInfoDic[gameid]
		if info~=nil then return true end
	end
	return false
end

function HallRoomPanelModel:AddGameRoomLevel( gameid,levelInfo )
	if gameid==nil then return end
	self.mGoldGameRoomInfoDic[gameid]=levelInfo
end



function HallRoomPanelModel:StartMonitorProtocal( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MGR_GAME_END,"RspNewWin") 

end

function HallRoomPanelModel:RemoveMonitorProtocal(  )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MGR_GAME_END,"RspNewWin") 
end

--[[
NetworkDefine.CRspGameEndStatePara = 
{
    {"m_unUIN","Int32",0},              --用户id
    {"m_usGameId","Int16",0},           --游戏ID
    {"m_ullBetsMoney","Int64",0},       --押注的钱
    {"m_ullGetMoney","Int64",0},        --获得的钱
    {"m_unType","Int32",0},             --操作类型
    {"m_unMoney","Int64",0},            --身上的钱
}

--]]


function HallRoomPanelModel:RspNewWin( buffer )

	local msg=self:ParseMsg(NetworkDefine.CRspGameEndStatePara,buffer)
	local data={
		UID=msg.m_unUIN,
		GID=msg.m_usGameId, 
		WinType=msg.m_unType, ---m_unType 1 /赢钱 3/BigWin 4/MAGEWIn 5/SupeWin 6/JackPot 7/freeGAme
	}
	self:DispatchEvent(HallRoomPanelModel.EventType.NewWin,data)

end


function HallRoomPanelModel:__delete( ... )
	self.mGoldGameRoomInfoDic = {}
end


HallRoomPanelModel.EventType={
	NewWin="HallRoomPanelModel.EventType.NewWin",
}