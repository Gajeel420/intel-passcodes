GameLuaDefine={}

GameLuaDefine.ASS_GAME_TYPE={
    ASS_GM_GAME_STATION = 2,                         --游戏状态                 MSG_GameStationDataRes
    ASS_GAME_BET_APPLY = 50,		                 --下注请求                 MSG_BetDataApply
    ASS_GAME_BET_RES = 150,		                     --下注返回                 MSG_BetDataRes
    ASS_GAME_OPEN_PRIZE_RES = 151,		             --开奖返回                 MSG_OpenPrizeDataRes
    ASS_GAME_CHANGE_STATE_RES = 152,	             --游戏状态通知返回          MSG_GameStateDataRes  
    ASS_GAME_DEPLANE_REQ = 153,	                     --下飞机请求               MSG_DeplaneApply  
    ASS_GAME_DEPLANE_RES = 154,	                     --下飞机返回               MSG_DeplaneRes  
    ASS_GAME_GET_FLYING_ODDS_APLY = 155,             --获取当前飞行赔率          NULL
    ASS_GAME_GET_FLYING_ODDS_RES = 156,             --获取当前飞行赔率返回      MSG_GetFlyingOddsRes
}

GameLuaDefine.MAIN_MSG_TYPE={
    MDM_GM_GAME_FRAME = 150,          --状态主消息
	MDM_GM_GAME_NOTIFY=180,           --游戏逻辑主消息    
}

GameLuaDefine.GameGroup = {
	[1] = {name = "GameGroup",path = "Phone/Prefab/Game/GameGroup.unity3d",count = 1},
}

GameLuaDefine.SoundID = 
{
    --对应SoundConfig 的id
    BGM = 1,
    Rotation = 2,
    Stop = 3,
    Win = 4,
}

--#region 消息数据结构

GameLuaDefine.GameStateType = 
{
    STATE_BET = 1,          --下注状态
    STATE_OPEN_PRIZE = 2,   --开奖状态
    STATE_ACCOUNT = 3,          --结算状态
    STATE_MAX = 4
}

--游戏状态通知
GameLuaDefine.MSG_ChangeStateDataRes = 
{
    {"byState","Byte",0},              -- 当前游戏状态
}

--客户端选球下注
GameLuaDefine.MSG_BetDataApply = 
{
    {"byChipIndex","Byte",0},       -- 筹码索引（从0开始）
    {"byBetFaceIndex","Byte",0},       -- 筹码索引（从0开始）
}

--客户端选球下注返回
GameLuaDefine.MSG_BetDataRes = 
{  
	{ "byErrorCode","Byte",0 },     -- 0=成功，非0失败
	{ "byChipIndex","Byte",0 },     -- 筹码索引（从0开始）
	{ "byPrizeFaceIndex","Byte",0 },      -- 开奖结果 0=未中奖，1中奖
	{ "n64WinCoin","Int64",0 },     -- 赢分金额
	{ "n64BalanceCoin","Int64",0 }  -- 余额金币
}

--客户端选球下飞机请求
GameLuaDefine.MSG_DeplaneApply = 
{  
	{ "unPrizeOdds","Int32",0 },   -- 结束开奖赔率 放大100倍（即保留两位数）101=赔率1.01
}

--客户端获取当前飞行结果返回
GameLuaDefine.MSG_GetFlyingOddsRes = 
{  
	{ "unFlyingTime","Int32",0 },   -- 结束开奖赔率 放大100倍（即保留两位数）101=赔率1.01
}

--客户端选球下飞机返回
GameLuaDefine.MSG_DeplaneRes = 
{  
	{ "byErrorCode","Byte",0 },     -- 0=成功，1=当前不能下飞机
	{ "unFlyingOdds","Int32",0 },   -- 当前飞行的赔率值
	{ "byDeskStation","Byte",0 },     -- 下飞机座位
	{ "unPrizeOdds","Int32",0 },   -- 下飞机结算开奖赔率 放大100倍（即保留两位数）101=赔率1.01
	{ "n64WinLoseMoney","Int64",0 },  -- 输赢金额
	{ "n64BalanceCoin","Int64",0 }  -- 余额金币
}

-- GameLuaDefine.All = 
-- {
--     --游戏状态通知
--     -- {"GameLuaDefine.MSG_GameStateDataRes",GameLuaDefine.MSG_GameStateDataRes},

-- }

-- function GameLuaDefine.AddStruct( )
-- 	for k,v in pairs(GameLuaDefine.All) do
-- 		local name = v[1]
-- 		local tb = v[2]
-- 		NetworkMgr:AddMsgStruct(name,tb)
-- 	end
-- end
-- GameLuaDefine.AddStruct()
--#endregion 消息数据结构