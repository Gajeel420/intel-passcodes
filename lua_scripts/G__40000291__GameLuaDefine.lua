GameLuaDefine={}

GameLuaDefine.ASS_GAME_TYPE={
	SUB_S_GAME_SCENE = 2, --//场景消息
	SUB_S_CONFIG_INFO = 0x20000006, --//房间配置信息
	SUB_S_CHANGE_SCENE = 0x20000007, --//切换场景
	SUB_S_TRACE_POINT=0x20000008,	--鱼群轨迹
	SUB_S_TRACE_POINT_EX =  0x20000018, --特殊炸弹轨迹
	SUB_C_LOCK_FISH = 0x10000009,  --//锁定鱼群  客户端->服务端
	SUB_C_USER_SHOOT = 0x10000001,  --//发射炮弹 客户端->服务端
	SUB_S_USER_SHOOT = 0x20000001,  --//发射炮弹 服务端->客户端(其他玩家打炮通知客户端，自己打炮不会通知)
	SUB_C_HIT_FISH=0x10000002,--子弹击中鱼群 客户端->服务端
	SUB_S_HIT_FISH_EX=0x20000092, --捕获鱼群  服务端->客户端(通知所有玩家，包括自己)
	SUB_S_ROBOT_SHOOT = 0x20000013,--//机器人发炮处理
	SUB_S_LOCK_FISH_NOTIFY=0x20000009,--锁定鱼群  服务端->客户端
	SUB_S_MONEY_NOTIFY=0x20000005,--更新玩家游戏币信息
	SUB_C_ROBOT_HIT_FISH=0x10000014,--机器人子弹击中鱼群，玩家端帮机器人发送到服务端
	SUB_C_SEND_PARTBOMB_KILLED_LT = 0x1000000D,--//局部炸弹炸死鱼列表, 客户端->服务端
	SUB_S_SEND_PARTBOMB_KILLED_LT_EX = 0x2000001D,--//局部炸弹炸死鱼,服务端->客户端
	SUB_C_PLAYER_COME_BACK_REQUEST_SYNC_FISHES = 0x10000091, --//客户端切出去, 再切回来(没有断线), 请求同步鱼
	SUB_S_DHSZ_OVER =  0x20000027, --服务端通知客户端定海神针时间结束
	SUB_C_USERDATA = 0x1000000E, -- 客户端-服务端 发送自动攻击，锁定的按钮状态
	SUB_S_USERDATA = 0x2000000E, --服务端-客服端 发送自动攻击，锁定的按钮状态
	SUB_S_FISHSTATUS = 0x2000000F, --更新鱼状态, 通知所有玩家,服务端 -> 客户端
	SUB_C_FISHINFO  = 0x10000010, -- 屏幕内是否有鱼,客户端 -> 服务端
	SUB_S_FISHINFO  =  0x20000010,
	SUB_S_CREATBOMB = 0x20000011,  --下发产生无敌炸弹、电磁网、必杀雷射/电磁炮,服务端 -> 客户端

	SUB_C_SHOOTSUPERBOMB = 0x10000012, -- 客户端发射无敌炸弹、电磁网、必杀雷射/电磁炮  客户端 -> 服务端

	SUB_S_SHOOTSUPERBOMB  = 0x20000012, --通知客户端发射无敌炸弹、电磁网、必杀雷射/电磁炮 服务端 -> 客户端

	SUB_C_BOMB_HIT_FISH = 0x100000A2, --特殊子弹击中特殊鱼群

	SUB_S_REDPACKET_MONEY_NOTIFY = 0x20000015,
	SUB_S_REDPACKET_FISH = 0x20000028, -- 猪罐开关
	SUB_S_USER_SHOOT_EX = 0x20000020,
	SUB_S_NENGLIANGPAO_CTRL = 0x20000016,

	SUB_C_SEND_PARTBOMB_KILLED_LT_EX = 0x1000001D,
}




GameLuaDefine.MAIN_MSG_TYPE={
	MDM_GM_GAME_NOTIFY=180,
}
GameLuaDefine.CMD_S_GameScene={
	{"btCureSeaSceneKind","Byte",0},--当前场景
	{"btStatus","Byte",0},--游戏状态，具体参见  enum enGameState  
	{"byDHSZFlag","Byte",0}
}

GameLuaDefine.CMD_S_NengLiangPao_Ctrl={
	{"byChairID","Byte",0},
	{"byOnOff","Byte",0},
}




GameLuaDefine.CMS_S_REDPACKET_FISH_ON={
	{"byRedPacketFishOn","Byte",0},
	{"byReserved","Byte",0},
}

GameLuaDefine.CMD_S_FishStatus ={
	{"dwFishID","UInt32",0},
	{"byStatus","Byte",0},  
	{"dwData","UInt32",0}
}

GameLuaDefine.CMD_C_SHOOTSUPERBOMB = 
{
	{"uBombId","UInt32",0},
	{"sCaptureNetX","Int16",0},
	{"sCaptureNetY","Int16",0},  
	{"sAngle","Int16",0},
	{"uData","UInt32",0},
}

GameLuaDefine.CMD_C_SpecialBulletHitFish =
{
	{"dwBulletID","UInt16",0},--//子弹标识
	{"dwFishID","UInt32",0},--鱼群标识   
	{"nCaptureNetX","Int16",0},--捕获鱼网的X坐标
	{"nCaptureNetY","Int16",0},--捕获
	{"dwBombId","UInt32",0}, --炸弹Id
};

GameLuaDefine.CMD_S_SHOOTSUPERBOMB =
{
	{"byChairId","Byte",0},
	{"uBombId","UInt32",0},  
	{"sCaptureNetX","Int16",0},
	{"sCaptureNetY","Int16",0},  
	{"sAngle","Int16",0},
	{"uData","UInt32",0},
}


GameLuaDefine.CMD_S_CreatBomb ={
	{"byChairId","Byte",0},
	{"byBombType","Byte",0},
	{"uBombId","UInt32",0},  
	{"dwKilledFishId","UInt32",0},
	{"dwData","UInt32",0},
}

GameLuaDefine.CMD_C_ScreenHasFish ={
	{"byType","Byte",0},
	{"dwData1","UInt32",0},  
	{"dwData2","UInt32",0}
}

GameLuaDefine.CMD_S_SpeicalData ={
	{"byType","Byte",0},
	{"dwData1","UInt32",0},  
	{"dwData2","UInt32",0}
}

GameLuaDefine.CMD_C_BackChangeToFontChairID = {
	{"byChairNo","Byte",0}
}

GameLuaDefine.CMD_S_DHSZOver = {
	{"reserved","Byte",0}
}

GameLuaDefine.CMD_C_UserBtnData={
	{"dwType","UInt32",0},
	{"dwData","UInt32",0}
}

GameLuaDefine.CMD_S_UserBtnData={
	{"byChairID","Byte",0},--玩家椅子
	{"dwType","UInt32",0},
	{"dwData","UInt32",0}
}

GameLuaDefine.CMD_C_LockFish={
	{"dwFishID","UInt32",0},--鱼群标识
	{"btLock","Byte",0},--是否锁定，0取消锁定，1锁定      
}
GameLuaDefine.CMD_S_LockFish={
	{"wChairID","Byte",0},--玩家椅子
	{"dwFishID","UInt32",0},--鱼群标识 
	{"btLock","Byte",0},--是否锁定，0取消锁定，1锁定    
}
GameLuaDefine.CMD_C_UserShoot={
	{"dwBulletID","UInt16",0},--子弹标识
	{"fAngle","Int16",0},--发射角度   
	{"byCannonLevelIndex","Byte",0},--炮弹等级序号，从0开始   
	-- {"btCurCannonType","Byte",0},--当前炮类型,参考enCannonType  v1.5   
}
GameLuaDefine.CMD_C_RobotHitFishFromUser={
	{"btRobotChairID","Byte",0},--机器人椅子
	{"dwBulletID","UInt16",0},--//子弹标识
	{"dwFishID","UInt32",0},--鱼群标识   
	{"nCaptureNetX","Int16",0},--捕获鱼网的X坐标
	{"nCaptureNetY","Int16",0},--捕获鱼网的Y坐标
}
GameLuaDefine.CMD_C_HitFish={
	{"dwBulletID","UInt16",0},--//子弹标识
	{"dwFishID","UInt32",0},--鱼群标识   
	{"nCaptureNetX","Int16",0},--捕获鱼网的X坐标
	{"nCaptureNetY","Int16",0},--捕获鱼网的Y坐标
}
GameLuaDefine.CMD_S_UserShoot={
	{"wChairID","Byte",0},--//子弹标识
	{"fAngle","Int16",0},--发射角度   
	{"byCannonLevelIndex","Byte",0},--炮弹等级序号，从0开始
	{"dwBulletID","UInt16",0},--子弹标识   v1.1
}

GameLuaDefine.CMD_S_UserShootEx={
	{"wChairID","Byte",0},--//子弹标识
	{"fAngle","Int16",0},--发射角度   
	{"byCannonLevelIndex","Byte",0},--炮弹等级序号，从0开始
	{"dwBulletID","UInt16",0},--子弹标识   v1.1
	{"imoney","Int64",0}
}
GameLuaDefine.CMD_S_RobotShoot={
	{"btRobotChairID","Byte",0},--//机器人椅子
	{"fAngle","Int16",0},--发射角度   
	{"btCannonLevelIndex","Byte",0},--炮弹等级序号，从0开始
	{"dwBulletID","UInt16",0},--子弹标识   v1.1
	{"btProcUserChairID","Byte",0},--帮机器人判断捕获的玩家座位号
	-- {"btCurCannonType","Byte",0},--帮机器人判断捕获的玩家座位号
}
GameLuaDefine.CMD_S_ChangeScene={--切换场景
	{"CureSeaSceneKind","Byte",0},--//当前场景
	{"bLToR","Byte",0},--改变方向   
	{"szTraceFile","Byte[]",30},--规则鱼阵文件名
	{"szFileVersion","Int32",0},--文件版本   v1.1
	{"byPrepareTime","Byte",0},
	{"byFishGoAwayTime","Byte",0},--切换场景时鱼移出屏幕的时间
}
GameLuaDefine.CMD_S_MONEY_NOTIFY={--切换场景
	{"wChairID","Byte",0},--//玩家椅子
	{"iMoney","Int64",0},--玩家富贵豆数   v1.1
}
GameLuaDefine.CMD_S_FishTrace={
	{"btFishKind","Byte",0},--//玩家椅子
	{"iMoney","Int64",0},--玩家富贵豆数   v1.1
}


GameLuaDefine.CMD_S_REDPACKET_MONEY_NOTIFY = {
	{"byChairID","Byte",0},
	{"u32Packets","Int64",0},
	{"u32Reserved","UInt32",0},
}

GameLuaDefine.CMD_C_PartBombKilledList_EX={
		{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
		{"sCaptureNetX","UInt16",0},
		{"sCaptureNetY","UInt16",0},
		{"nListCount","Int16",0},--列表大小
		{"dwKilledIDList","Int32[]",0},--被炸死的鱼ID列表
	}

GameLuaDefine.CMD_C_PartBombKilledList={
	{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
	{"nListCount","Int16",0},--列表大小
	{"dwKilledIDList","UInt32[]",0},--被炸死的鱼ID列表
}
GameLuaDefine.CMD_S_FishSpecialTrace1={
	{"btFishKind","Byte",0},--鱼群种类
	{"dwStartFishID","UInt32",0},--鱼开始标识
	{"nFishCount","UInt16",0},--个数
	{"nFishDistance","UInt16",0},--//鱼距离
	{"nInitCount","UInt16",0},--//坐标数目
}
GameLuaDefine.FishTracePoint={
	{"nInitX","UInt16",0},--关键坐标
	{"nInitY","UInt16",0},--//关键坐标
	{"nSpead","UInt16",0},--//每个关键点开始的速度(像素/ms)  
}


GameLuaDefine.GameState={
	None=0,
	JieSuan=1,
	SanYu=2,
}
GameLuaDefine.BGTextureIndex={
"t_bg_1",
"t_bg_2",
"t_bg_3",
"t_bg_4",
"t_bg_5",
}

GameLuaDefine.GunLevelConfig= {
 	[1]={gunPrefabID=1,gunType="GunType01",bulletSpName="bullet_sty_01_01",netSpName="sty_01_net1",PaoZuo = "PaoZuo01"},
	[2]={gunPrefabID=2,gunType="GunType02",bulletSpName="bullet_sty_01_02",netSpName="sty_01_net2",PaoZuo = "PaoZuo02"},
	[3]={gunPrefabID=3,gunType="GunType03",bulletSpName="bullet_sty_01_03",netSpName="sty_01_net3",PaoZuo = "PaoZuo03"},
	[4]={gunPrefabID=4,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[5]={gunPrefabID=5,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[6]={gunPrefabID=6,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[7]={gunPrefabID=7,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[8]={gunPrefabID=8,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[9]={gunPrefabID=9,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[10]={gunPrefabID=10,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[11]={gunPrefabID=11,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[12]={gunPrefabID=12,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[13]={gunPrefabID=13,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[14]={gunPrefabID=14,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[15]={gunPrefabID=15,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[16]={gunPrefabID=16,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[17]={gunPrefabID=17,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[18]={gunPrefabID=18,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[19]={gunPrefabID=19,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
	[20]={gunPrefabID=20,gunType="GunType04",bulletSpName="bullet_sty_01_04",netSpName="sty_01_net4",PaoZuo = "PaoZuo04"},
}

GameLuaDefine.LieYanFengbaoLevelConfig= {
	[1]={gunPrefabID=1,gunType="FireStromType",bulletSpName="bullet_sty_01_05",netSpName="sty_01_net5"},
	[2]={gunPrefabID=2,gunType="FireStromType",bulletSpName="bullet_sty_01_05",netSpName="sty_01_net5"},
	[3]={gunPrefabID=3,gunType="FireStromType",bulletSpName="bullet_sty_01_05",netSpName="sty_01_net5"},
	[4]={gunPrefabID=4,gunType="FireStromType",bulletSpName="bullet_sty_01_05",netSpName="sty_01_net5"},
	[5]={gunPrefabID=5,gunType="FireStromType",bulletSpName="bullet_sty_01_05",netSpName="sty_01_net5"},
}

GameLuaDefine.GameGroup = {
	[1] = {name = "GameGroup",path = "Phone/Prefab/Game/GameGroup.unity3d",count = 1},
}

GameLuaDefine.PlayerPackRes = {
	[1] = {name = "Player_Pack",path = "Phone/Prefab/PlayerPack/Player_Pack.unity3d"},	
}


GameLuaDefine.PlayerGroupRes = {
	[1] = {name = "PlayerGroupDown1",ParentName = "Player_Pack",amout= 1,count = 1},
	[2] = {name = "PlayerGroupDown2",ParentName = "Player_Pack",amout= 1,count = 1},
	[3] = {name = "PlayerGroupUp3",ParentName = "Player_Pack",amout = 1,count = 1},
	[4] = {name = "PlayerGroupUp4",ParentName = "Player_Pack",amout = 1,count = 1},
}

GameLuaDefine.YuRenPackRes = {
	[1] = {name = "TXFish_Pack_01",path = "Phone/Prefab/TXFishPack/TXFish_Pack_01.unity3d"},
	[2] = {name = "TXFish_Pack_02",path = "Phone/Prefab/TXFishPack/TXFish_Pack_02.unity3d"},
	[3] = {name = "TXFish_Pack_03",path = "Phone/Prefab/TXFishPack/TXFish_Pack_03.unity3d"},
--	[4] = {name = "TXFish_Pack_04",path = "Phone/Prefab/TXFishPack/TXFish_Pack_04.unity3d"},
--	[5] = {name = "TXFish_Pack_05",path = "Phone/Prefab/TXFishPack/TXFish_Pack_05.unity3d"},
}

GameLuaDefine.FishsRes ={
	[1] = {name = "Fish_01",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[2] = {name = "Fish_02",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[3] = {name = "Fish_03",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[4] = {name = "Fish_04",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[5] = {name = "Fish_05",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[6] = {name = "Fish_06",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[7] = {name = "Fish_07",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[8] = {name = "Fish_08",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[9] = {name = "Fish_09",ParentName = "TXFish_Pack_01",amout = 5, count = 1},
	[10] = {name = "Fish_010",ParentName = "TXFish_Pack_01",amout = 1, count = 1},
	[11] = {name = "Fish_011",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[12] = {name = "Fish_012",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[13] = {name = "Fish_013",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[14] = {name = "Fish_014",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[15] = {name = "Fish_015",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[16] = {name = "Fish_016",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[17] = {name = "Fish_017",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[18] = {name = "Fish_018",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[19] = {name = "Fish_019",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[20] = {name = "Fish_020",ParentName = "TXFish_Pack_02",amout = 1, count = 1},
	[21] = {name = "Fish_021",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[22] = {name = "Fish_022",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[23] = {name = "Fish_023",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[24] = {name = "Fish_024",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[25] = {name = "Fish_025",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[26] = {name = "Fish_026",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[27] = {name = "Fish_027",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[28] = {name = "Fish_028",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[29] = {name = "Fish_029",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[30] = {name = "Fish_030",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	--[[[31] = {name = "Fish_31",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[32] = {name = "Fish_32",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[33] = {name = "Fish_33",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[34] = {name = "Fish_34",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[35] = {name = "Fish_35",ParentName = "TXFish_Pack_03",amout = 1, count = 1},	
	[36] = {name = "Fish_36",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[37] = {name = "Fish_37",ParentName = "TXFish_Pack_03",amout = 1, count = 1},
	[38] = {name = "Fish_38",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[39] = {name = "Fish_39",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[40] = {name = "Fish_40",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[41] = {name = "Fish_41",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[42] = {name = "Fish_42",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[43] = {name = "Fish_43",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[44] = {name = "Fish_44",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[45] = {name = "Fish_45",ParentName = "TXFish_Pack_04",amout = 1, count = 1},
	[46] = {name = "Fish_46",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[47] = {name = "Fish_47",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[48] = {name = "Fish_48",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[49] = {name = "Fish_49",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[50] = {name = "Fish_50",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[51] = {name = "Fish_51",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[52] = {name = "Fish_52",ParentName = "TXFish_Pack_05",amout = 1, count = 1},
	[53] = {name = "Fish_53",ParentName = "TXFish_Pack_05",amout = 1, count = 1},--]]
	
}

GameLuaDefine.BulletRes={
	[1] = {name = "bullet_1",ParentName = "TXFish_Pack_01",amout = 45, count = 1},
}

GameLuaDefine.NetRes = {
	[1] = {name = "Net_1",path = "Phone/Prefab/Net/Net_1.unity3d",amout = 45, count = 1},
}

GameLuaDefine.FishMoneyRes = {
	[1] = {name = "Coin_1",path ="Phone/Prefab/Moneys/Coin_1.unity3d",amout = 45,count = 1},
}

GameLuaDefine.FloatNumRes = {
		[1] = {name = "FloatNum_1",path ="Phone/Prefab/FloatNum/FloatNum_1.unity3d",amout = 1,count = 1},
}

GameLuaDefine.ThunderRes = {
	[1] = {name = "Thunder01",path ="Phone/Prefab/Thunder/Thunder01.unity3d",amout = 15,count = 1},
}


GameLuaDefine.ExplosiveRes={
	[1] = {name = "Effect_BDY_Pingmu",path ="Phone/Prefab/Effect/Effect_BDY_Pingmu.unity3d",amout = 2,count = 1},
	[2] = {name = "Effect_ZDY",path ="Phone/Prefab/Effect/Effect_ZDY.unity3d",amout = 2,count = 1},
	[3] = {name = "Effect_HDY",path ="Phone/Prefab/Effect/Effect_HDY.unity3d",amout = 2,count = 1},
	--[[[2] = {name = "Effect_Big_Winner",path ="Phone/Prefab/Effect/Effect_Big_Winner.unity3d",amout = 2,count = 1},
	[3] = {name = "Effect_minigame_Tips",path ="Phone/Prefab/Effect/Effect_minigame_Tips.unity3d",amout = 2,count = 1},
	[4] = {name = "Effect_minigame_Tips_2",path ="Phone/Prefab/Effect/Effect_minigame_Tips_2.unity3d",amout = 2,count = 1},
	[5] = {name = "zhadan_haima",path ="Phone/Prefab/Effect/zhadan_haima.unity3d",amout = 2,count = 1},
	[6] = {name = "Effect_heidong_pangxie_BIG",path ="Phone/Prefab/Effect/Effect_heidong_pangxie_BIG.unity3d",amout = 2,count = 1},
	[7] = {name = "Effect_huoyanshenjian",path ="Phone/Prefab/Effect/Effect_huoyanshenjian.unity3d",amout = 2,count = 1},--]]

}


GameLuaDefine.KillLeiSheRes ={
	--[1] = {name = "KillLeiShe",path ="Phone/Prefab/KillLeiShe/KillLeiShe.unity3d",amout = 3,count = 1},	
}

GameLuaDefine.ZuanTouRes ={
	--[1] = {name = "ZuanTou_Bullet",path ="Phone/Prefab/ZuanTou/ZuanTou_Bullet.unity3d",amout = 1,count = 1},	
}

GameLuaDefine.GoldTeamAddRes={
	[1] = {name = "GoldTeamAddUp",path ="Phone/Prefab/GoldTeamAdd/GoldTeamAddUp.unity3d",amout = 20,count = 1},
	[2] = {name = "GoldTeamAddDown",path ="Phone/Prefab/GoldTeamAdd/GoldTeamAddDown.unity3d",amout = 20,count = 1},
}

GameLuaDefine.KingFishAttr ={
	[1] ={bgScale = 0.6,BoxWidth = 95,BoxHeight = 95},
	[2] ={bgScale = 0.6,BoxWidth = 95,BoxHeight = 95},
	[3] ={bgScale = 0.6,BoxWidth = 95,BoxHeight = 95},
	[4] ={bgScale = 0.75,BoxWidth =115,BoxHeight = 115},
	[5] ={bgScale = 0.75,BoxWidth =115,BoxHeight = 115},
	[6] ={bgScale = 0.9,BoxWidth =140,BoxHeight = 140},
	[7] ={bgScale = 1,BoxWidth =150,BoxHeight = 150},
	[8] ={bgScale = 1,BoxWidth =150,BoxHeight = 150},
	[9] ={bgScale = 1.2,BoxWidth =180,BoxHeight = 180},
	[10] ={bgScale = 1.2,BoxWidth =180,BoxHeight = 180},
	[11] ={bgScale = 0.9,BoxWidth =140,BoxHeight = 140},
	[12] ={bgScale = 1.2,BoxWidth =180,BoxHeight = 180},
	[13] ={bgScale = 1.2,BoxWidth =180,BoxHeight = 180},
	[14] ={bgScale = 1.2,BoxWidth =180,BoxHeight = 180},
}



GameLuaDefine.BGTextureRes={
	t_bg_1={name="t_bg_1",path="Common/Texture/bg/t_bg_1.unity3d"},
	t_bg_2={name="t_bg_2",path="Common/Texture/bg/t_bg_2.unity3d"},
	t_bg_3={name="t_bg_3",path="Common/Texture/bg/t_bg_3.unity3d"},
	t_bg_4={name="t_bg_4",path="Common/Texture/bg/t_bg_4.unity3d"},
	t_bg_5={name="t_bg_5",path="Common/Texture/bg/t_bg_5.unity3d"},
}

GameLuaDefine.CoinPos1 ={[1] = {[1] = {x1 = 0, y1 = 0 },
								[2] = {x1 = -43, y1 = 38},
								[3] = {x1 = 28,  y1 = 41 },
								[4] = {x1 = 66,  y1 = 4},
								[5] = {x1 = 32,  y1 = -35},
								[6] = {x1 = -60,  y1 = 12},
								[7] = {x1 = -34,  y1 = -48},
								[8] = {x1 = 75,  y1 = -51},
								[9] = {x1 = 7,  y1 = -76},
								[10] = {x1 = -83,  y1 = -57},
								-- [11] = {x1 = 49,  y1 = -98},
								-- [12] = {x1 = -94,  y1 = -62},
								-- [13] = {x1 = 29,  y1 = -162},
								-- [14] = {x1 = -156,  y1 = 42},
								-- [15] = {x1 = -30,  y1 = 166},
								-- [16] = {x1 = 95,  y1 = 149},
								-- [17] = {x1 = -46,  y1 = -189},
								-- [18] = {x1 = -31,  y1 = -127},
								-- [19] = {x1 = 166,  y1 = 41},
								-- [20] = {x1 = -71,  y1 = -170},
								},
						--   [2]=  {[1] = {x1 = -71, y1 = 19},
						-- 		 [2] = {x1 = -3,  y1 = -87},
						-- 		 [3] = {x1 = 53,  y1 = 76},
						-- 		 [4] = {x1 = 70,  y1 = -16},},
						}

GameLuaDefine.CanLockFish={
20,
21,
24,
23,
25,
26,
27,
28,
29,
30,
 1,
 2,
 3,
 4,
 5,
 6,
 7,
 8,
 9,
 10,
 11,
 12,
 13,
 14,
 15,
 16,
 17,
18,
19,


}


