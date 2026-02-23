GameDefine={}


--主游戏状态
GameDefine.GameStation={
	Normal=1,
	FreeGame=2,
	JackpotGame=4,
	TriggerFreeGame=5,
	TreasureBox=9,		--宝盒转盘游戏
}

GameDefine.SHZ_CommonVar={

	ANI_COL = 3,                		--//列数
  	ANI_ROW = 3,               			 --//行数
	ItemCount=6,
	ItemMin=0,
	ItemMax=5,
}

--游戏运行状态
GameDefine.SubGameState={
	Normal=1,
	BigWin=2,
	JackPot=3,
	FreeGame=4,
	FreeGameResult=5,	--免费游戏结算
	TriggerFreeGame=6,	--触发免费游戏
	TreasureBox=7,
}

GameDefine.FreeGameType={
	Normal=0,
	Special=1,
}



GameDefine.ObjectPoolKeyName={

	LightningBoom="Effect_Boom",

}


GameDefine.NormalOrangutanAnim={
	IdleName="idle",
	TriggerLightning="chuixing_hou",
	TriggerFreeGame="jump_chuidi",
	FreeGame="change",
}


--panel资源配置
GameDefine.ModuleName={
	Panel_Com=1,
	Panel_Help=2,
	Panel_GameSet=3,
	Panel_Handsel=4,
	Panel_Jackpot=5,
	Panel_BigWin=6,
	Panel_TriggerFreeGame=7,
	Panel_TriggerFreeGameRun=8,
	Panel_FreeGame=9,
	Panel_SmallWin=10,
	Panel_DisplayKuang=11,
	Panel_Line=12,
	Panel_Tips=13,
	
}

GameDefine.ModulePath={
	
	[1]="Panel_Com",
	[2]="Panel_Help",
	[3]="Panel_GameSet",
	[4]="Panel_Handsel",
	[5]="Panel_Jackpot",
	[6]="Panel_BigWin",
	[7]="Panel_TriggerFreeGame",
	[8]="Panel_TriggerFreeGameRun",
	[9]="Panel_FreeGame",
	[10]="Panel_SmallWin",
	[11]="Panel_DisplayKuang",
	[12]="Panel_Line",
	[13]="Panel_Tips",
}


GameDefine.GameBGState={
	NormalGame=1,
	FreeGame=2,
}


GameDefine.MaskIconPos={
	[1]=Vector3(0,0,0),
	[2]=Vector3(168,0,0),
	[3]=Vector3(336,0,0),
	[4]=Vector3(504,0,0),
	[5]=Vector3(672,0,0),
}


GameDefine.GameIconPos={

[5]={[1]=Vector3(0,0,0),
	[2]=Vector3(168,0,0),
	[3]=Vector3(336,0,0),
	[4]=Vector3(504,0,0),
	[5]=Vector3(672,0,0),},

[4]={[1]=Vector3(0,0,0),
	[2]=Vector3(168,0,0),
	[3]=Vector3(336,0,0),
	[4]=Vector3(672,0,0),
	[5]=Vector3(504,0,0),},
	
[3]={[1]=Vector3(0,0,0),
	[2]=Vector3(168,0,0),
	[3]=Vector3(504,0,0),
	[4]=Vector3(672,0,0),
	[5]=Vector3(336,0,0),},
	
[2]={[1]=Vector3(0,0,0),
	[2]=Vector3(336,0,0),
	[3]=Vector3(504,0,0),
	[4]=Vector3(672,0,0),
	[5]=Vector3(168,0,0),},
	
[1]={[1]=Vector3(168,0,0),
	[2]=Vector3(336,0,0),
	[3]=Vector3(504,0,0),
	[4]=Vector3(672,0,0),
	[5]=Vector3(0,0,0),},
	
}





GameDefine.CoordinateChange={
	[0]={1,2},
	[1]={2,2},
	[2]={3,2},
	[3]={4,2},
	[4]={5,2},
	[5]={1,3},
	[6]={2,3},
	[7]={3,3},
	[8]={4,3},
	[9]={5,3},
	[10]={1,4},
	[11]={2,4},
	[12]={3,4},
	[13]={4,4},
	[14]={5,4},
}


--主消息定义
MAIN_MSG_TYPE=
{
    MDM_GM_GAME_FRAME = 150,            ---- 框架消息
    MDM_GM_GAME_NOTIFY = 180,           ---- 游戏消息
}
--辅助协议
ASS_MSG_TYPE = 
{
    ASS_GM_GAME_INFO = 1,            -- 游戏信息
}



GAME_MSG_TYPE = 
{
  --S_C
	ASS_GM_GAME_STATION = 2,                     --GameStation_Normal {GameStation_Base}
	CMD_GM_S_GAME_STATION_GAME_CONFIG = 100,     --CMD_S_Game_Station_Game_Config {MsgPrizeLine}


	CMD_S_PLAYGAME_RESULT = 1101,                --CMD_S_PlayGame_Result         下注结果
	CMD_S_OPEN_PRIZE_RESULT = 1102,              --CMD_S_Open_Prize_Result { Win_Prize_Line_info}  开奖结果


	CMD_S_GAMESCORE_RESULT = 1103,               --CMD_S_GameScore_Result        玩家得分结果


	CMD_S_FREE_GAME_PLAY_RET = 1201,             --CMD_S_Free_Game_Play_ret
	CMD_S_FREE_GAME_OPEN_PRIZE_RESULT = 1202,    --CMD_S_Open_Prize_Result {MsgPrizeLine}
	CMD_C_FRUIT_GAME_RESULT = 1278,              --CMD_C_FruitGameResult   返回结果
	CMD_C_FRUIT_GAME_Parameter = 1279,           --CMD_S_FruitGameParameter --水果机配置
	CMD_S_UPDATE_JACKPOT_INFO=1107,              --彩池更新
	CMD_S_JACKPOT_SEND_TO_PRIZE=1108,            --彩池中奖
	CDM_C_ChoiceReward_Play_Result=1321, 			--选龙返回
	CMD_S_JackPot_PLAY_RESULT=1281,
	CMD_S_JackPot_FINISH= 1282,
	CMD_S_CHANGE_GAME_SENCE =1105,
	CMD_S_GAMEINFO_SPECIAL_ITEM_CNT=1113,		--中奖碎片结果

	CMD_S_INTO_GAMBLE=1501,						 --//进入转盘
	CMD_S_GAMBLE_RESULT = 1502,					 --//转盘结果
    CMD_S_GAMBLE_FINISH = 1503,					 --//转盘结束

	--C_S
	CMD_C_PLAYER_PLAYGAME = 101,                 --CMD_C_Player_PlayGame         玩家点击开始玩按钮
	CMD_C_PLAYGAME_GETSCORE = 103,               --玩家得分    空结构体 NULL，只有包头
	CMD_C_EXIT_GAME = 104,                       --CMD_C_Exit_Game               游戏强退  玩家手动退出
	CMD_C_FREE_GAME_PLAY = 201,                  --请求一次发一次结果  CMD_C_Player_PlayGame
	
	CMD_C_FRUIT_GAME = 278,                      --玩家点击摇杆
	CMD_C_FRUIT_GAME_START = 279,                --进入游戏界面
	CDM_C_ChoiceReward_Play=321,  				--选龙
	CMD_C_JackPot_Play = 281 ,   					--选金币
	
	CMD_C_INTO_GAMBLE = 501,			--//玩家转盘
    CMD_C_PLAY_GAMBLE = 502,			--//开始转盘
	CMD_REQ_CURRENT_GAME_RET = 1116,     --获取当前游戏场景 和 一些信息

  --弱网环境加强版
  CMD_REQ_CURRENT_MSG_SEQ = 1120,  --获取当前的消息ID号 
  CMD_PLAYER_PLAYGAME_WITH_SEQ = 1121,  --原 101, 玩家点击开始(下注)(C->S)
  CMD_S_OPEN_PRIZE_RESULT_WITH_SEQ = 1122,  --原 1102, 有效下注后的开奖结果（S->C）
  CMD_REQ_CURRENT_GAME_RET_WITH_SEQ = 1123,  --原 1116, 获取当前游戏场景 和 一些信息 

  CMD_FREE_PLAYER_PLAYGAME_WITH_SEQ = 100101, --原 201, 玩家点击开始(下注)(C->S)  免费游戏
  CMD_FREE_S_OPEN_PRIZE_RESULT_WITH_SEQ = 100102, --原 1202, 有效下注后的开奖结果（S->C） 免费游戏
}

CMD_C_REQ_CURRENT_MSG_SEQ=
{
  {"nClientReqSeq","Int32",0},  --客户端请求游戏消息时的 seq   Add 20241219
}

CMD_S_REP_CURRENT_MSG_SEQ=
{
  {"nClientReqSeq","Int32",0},  --客户端请求游戏消息时的 seq   Add 20241219
  {"nSrvCurMsgSeq","Int32",0} , --服务端当前
}

-- 玩家点击开始游戏(下注)（C->S）
CMD_C_Player_PlayGame_With_Seq=
{
  {"nDeskStation","Int32",0},
  {"nBetPrizeLineCount","Int32",0},  --下注押中奖线得数量
  {"nBetMoneyIndex","Int32",0},  --押分金额索引
  {"byAutoPlay","Byte",0},  -- 是否在自动玩游戏
  {"nClientReqSeq","Int32",0}, --客户端请求游戏消息时的seq
}

--下注返回结果
CMD_S_PlayGame_Result_With_Seq=
{
  {"nDeskStation","Int32",0},
  {"nBetPrizeLineCount","Int32",0},  --下注押中奖线得数量
  {"nPlayerBet","Int32",0},  --押分金额索引
  {"byRetErrorCod","Byte",0},  -- 结果错误码
  {"nClientReqSeq","Int32",0}, --客户端请求游戏消息时的seq
  {"nSrvCurMsgSeq","Int32",0}, --未出结果之前，服务端当前的msg seq
}

ByRetResult =
{
  NOTE_ERROR_NONE = 0,              --无错误
  NOTE_ERROR_KIND = 1,              --下注筹码类型不对
  NOTE_ERROR_DESKSTATION =2,        --座位号不对
  NOTE_ERROR_ACTIVE =3,             --对应座位上没有玩家
  NOTE_ERROR_NOTENOUNGH_MONEY =4,   --钱不足
  NOTE_ERROR_NOTELIMIT =5,          --下注限红
  NOTE_ERROR_UNKNOWN =6,            --未知错误
  NOTE_ERROR_WRONG_GAME_STATE =7,   --状态不对
}


CMD_S_UPDATE_JACKPOT_INFO=--更新奖池
{
  {"nType","Int32",0},
  {"nTime","Int32",0},
  {"nJackpotPreTotal","Int64",0},
  {"nJackpotIncrea","Int64",0},
  

}
CMD_S_JACKPOT_SEND_TO_PRIZE=
{
  {"nUSerID","Int32",0},
  {"szNickName","Byte[]",64},
  {"nProfit","Int64",0},
  
  {"nType","Int32",0},
  {"nTime","Int32",0},
  {"nJackpotPreTotal","Int64",0},
  {"nJackpotIncrea","Int64",0},

}



--S->C

--//进入猜大小
GameDefine.CMD_S_Into_Gamble={
	{"nDeskStation","Int32",0};			--// 位置号
	{"byGambleType","Byte",0};			
	{"arrSelPoint","Int64[]",10};		--转盘抽奖元素
}

--//猜大小结果
GameDefine.CMD_S_Gamble_Result={
	{"nDeskStation","Int32",4};			--// 位置号
	{"nCurTotalCnt","Int32",4};			--//当前比倍的总数
	{"nMiniGameCnt","Int32",4};				--//小游戏的次数
	{"nProfit","Int64",8};				--//收益
	{"n64PlayerMoney","Int64",4};		--//玩家身上的钱
	{"byBetItemID","Byte",1};			--//压得选项值								    
	{"byOpenItemID","Byte",1};			--//开奖项的ID号			
	{"byCardPoint","Byte[]",10};			--//筛子大小数
}

--//猜大小结束
GameDefine.CMD_S_Gamble_Finish={
	{"nDeskStation","Int32",4};			--// 位置号
	{"byMiniGameState","Byte",0};		--//下一个小游戏的状态
	{"nMiniGameCnt","Int32",4};			
	{"n64Profit","Int64",8};				--//收益	
	{"n64PlayerMoney","Int64",8};			--//Money										
}



--C->S

--//进入猜大小
GameDefine.CMD_C_Into_Gamble={
	{"nDeskStation","Int32",0};			--// 位置号
	{"byBetItemID","Byte",0};			--//猜大小类型 1双比倍，2单比倍 3半比倍
}

--// 猜大小
GameDefine.CMD_C_Play_Gamble={
	{"nDeskStation","Int32",0};			--// 位置号
	{"byPlayerChoose","Byte",0};			--//1大 2和 3小 5结算	 
	{"bySelBaseIndex","Byte",0}				--选择的倍数索引   如果不选填 255
}







--状态协议
GameStation_Base =
{
  {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},          --座位号
}
--ASS_GM_GAME_STATION = 2
GameStation_Normal = 
{
  {"GameStation_Base","GameStation_Base[]",1}, --基础消息    BYTE  bStation;游戏状态    
  {"byGameResult","Byte[]",100},               --游戏结果，在2,3,4状态有效 根据 列数，行数 做解析  x,y 坐标轴体系
  {"nBetLineCount","Int32",0},                   --压中奖线数量
  {"nPlayerBet","Int32",0},                      --玩家押注倍数
  {"n64PlayerMoney","Int64",0},                  --玩家身上的钱
  {"nWinScore","Int64",0},                       --赢分
}

--#define ASS_GM_GAME_STATION       2     //游戏状态  服务端 -》客户端
GameStation_Free_Game =   --免费游戏状态
{
   {"GameStation_Base","GameStation_Base[]",1}, --基础消息    BYTE  bStation;游戏状态    
  --{"byGameResult","Byte[]",100},               --游戏结果，在2,3,4状态有效 根据 列数，行数 做解析  x,y 坐标轴体系
  {"nTotalMiniGameCnt","Int32",0},                   --总局数
  {"nCurPlayMiniGameCnt","Int32",0},                      --当前多少局
  {"nTotalWinScore","Int64",0},                  --总赢分
  --{"nWinScore","Int32"},                       --赢分
  {"nSelectLineCount","Int32",0},
  {"nPlayerBet","Int32",0},
}


--游戏协议
MsgPrizeLine =
{
  {"nPrizLineID","Int32",0},
  {"nYPos","Int32[]",10},  --行坐标，列坐标 一直为   0，1，2，3，4，5     为了节省资源，不发送Y 坐标下去


}

CMD_S_Game_Station_MsgPrizeLine =
{
  {"MsgPrizeLine","MsgPrizeLine[]",nPrizeLineCnt}
}  

--CMD_GM_S_GAME_STATION_GAME_CONFIG = 100             此消息 在ASS_GM_GAME_STATION 消息发完之后 发送


-- CMD_S_Game_Station_Game_Config = 
-- {
-- 	{"iLineCnt","Int32",0},                     --界面行数
-- 	{"iColCnt","Int32",0},                      --界面列数
-- 	{"nBetNum","Int32[]",20},                 --可下注筹码金额
-- 	{"nDefaultSelPrizeLineCnt","Int32",0},      --默认选中的中奖线数量
-- 	{"betindex","Int32",0},
-- 	{"byAutoPlay","Byte",0},
-- 	{"byGameResult","Byte[]",100},				--之前的开奖结果
-- 	{"byExtResult","Byte[]",100},			--
-- 	{"nCurremoveCnt","Int32",0},			--当前消除次数
-- }

CMD_S_Game_Station_Game_Config = 
{
	{"iLineCnt","Int32",0},                     --界面行数
	{"iColCnt","Int32",0},                      --界面列数
	{"nBetNum","Int32[]",20},                 --可下注筹码金额
	{"nDefaultSelPrizeLineCnt","Int32",0},      --默认选中的中奖线数量
	{"betindex","Int32",0},
	{"byAutoPlay","Byte",0},
}

CMD_S_Game_Station_Game_Config_Version3 = 
{
	{"iLineCnt","Int32",0},                     --界面行数
	{"iColCnt","Int32",0},                      --界面列数
	{"nBetNum","Int32[]",20},                 --可下注筹码金额
	{"nDefaultSelPrizeLineCnt","Int32",0},      --默认选中的中奖线数量
	{"betindex","Int32",0},
	{"byAutoPlay","Byte",0},
  {"byTotalJackpotCnt","Byte",0},     --总奖池的数量，如果选择的押注筹码 index 超过 奖池数量，则用最大奖池
	{"bySumWildCnt","Byte[]",10},				--历史中奖信息
	{"nSumMoney","Int64[]",10},
}

CMD_S_Game_Station_Game_Config_Version5 = 
{
  {"iLineCnt","Int32",4},                     --界面行数
  {"iColCnt","Int32",4},                      --界面列数
  {"nBetNum","Int32[]",10},                 --可下注筹码金额
  {"nDefaultSelPrizeLineCnt","Int32",4},      --默认选中的中奖线数量
  {"betindex","Int32",4},
  {"byAutoPlay","Byte",1},
  {"nAddBet","Int32",4},
  {"nAddBetID","Int32",4},
  {"nAddExBet","Int32",4},
  {"nAddExBetID","Int32",4}
}


--中奖碎片信息
CMD_S_GAMEINFO_SPECIAL_ITEM_CNT={
	{"nSumMoney","Int64[]",10},
}



--CMD_C_PLAYER_PLAYGAME = 101
CMD_C_Player_PlayGame = 
{
  {"nDeskStation","Int32",0},                 --座位号
  {"nBetPrizeLineCount","Int32",0},           --下注押中奖线得数量
  {"nBetMoneyIndex","Int32",0},               --押分金额索引
  {"byAutoPlay","Byte",0},                    --是否在自动玩游戏
}
--CMD_S_PLAYGAME_RESULT     1101  //下注结果
CMD_S_PlayGame_Result = 
{
  {"nDeskStation","Int32",0},  --
  {"nBetPrizeLineCount","Int32",0},         --下注押中奖线得数量
  {"nPlayerBet","Int32",0},                 --单线押分值
  {"byRet","Byte",0},                       --结果
}
Win_Prize_Line_info =
{
  {"nPrizeLineID","Int32",0},                --中奖线ID
  {"nXPos","Int32[]",10},                  --中奖的横坐标   列
  {"nYPos","Int32[]",10},                  --中奖的书坐标   行
  {"nWinLineBase","Int32",0},                --本条线中间的倍数
  {"nWinLineScore","Int64",0},               --赢分
  {"nGameItemID","Int32",0},                 --游戏项ID  100
}

Win_Prize_Line_info_V2 =
{
  {"nPrizeLineID","Int32",0},                --中奖线ID
  {"byLineType","Byte",0},
  {"nYPos","Byte[]",10},                  --中奖的书坐标   行
  {"nWinLineBase","Int32",0},                --本条线中间的倍数
  {"nWinLineScore","Int64",0},               --赢分
  {"nGameItemID","Byte",0},                 --游戏项ID
}

CMD_S_Open_Prize_Full_Line_Result =   --此协议制定目的主要是为了 应对 1024 线，消息长度不固定
{
  {"nDeskStation","Int32",0},               --座位号
  {"byGameResult","Byte[]",100},          --15个位置的结果
  {"n64PlayerMoney","Int64",0},             --Credit
  {"nTotalWinScore","Int64",0},
  {"arTigMiniGameID","Byte",0},             --下一个游戏状态  0 正常结算 minigameID 表示要进入小游戏。 再冰球突破中，如果为2 则表示冰球突破成功
  {"byCurRemoveCnt","Byte",0},                             --当前消除的次数
  {"nTotalMiniGameCnt","Int32",0},                          --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},                       --当前多少局
  {"nOhtereResultIndex","Int32",0},                         --冰球突破结果   0 代表没有冰球突破， 其他代表需要  
  {"byResultPrizeLine","Byte[]",100},  --中奖位置结果   1 代表要量的位置  
  {"byHaveBigPrize","Byte",0},                               --是否中大奖
  {"nMsgSeq","Int32",0},                                    --消息序列号
  {"nWinPrizeLineCnt","Int32",0},                       --中奖的中奖线个数243 28  271 299
};
--CMD_S_OPEN_PRIZE_RESULT = 1102
--CMD_S_FREE_GAME_OPEN_PRIZE_RESULT  1202
CMD_S_Open_Prize_Result = 
{
  --//后面跟nWinPrizeLineCnt  Win_Prize_Line_info 结构体
  --//Win_Prize_Line_info info[];    //
  {"nDeskStation","Int32",0},               --座位号
  {"byGameResult","Byte[]",100},          --15个位置的结果
  {"n64PlayerMoney","Int64",0},             --Credit
  {"nTotalWinScore","Int64",0},             --总赢分
  {"arTigMiniGameID","Byte",0},         --下一个游戏状态  0 正常结算 1 免费  2 水果机  minigameID 表示要进入小游戏 
  {"nTotalMiniGameCnt","Int32",0},          --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},        --当前多少局
  {"byHaveBigPrize","Byte",0},              --大奖
  {"nMsgSeq","Int32",0},                    --分包标示   9999后面没有包
  {"nWinPrizeLineCnt","Int32",0},           --中奖的中奖线个数  138
  --{"Win_Prize_Line_info","Win_Prize_Line_info[]",nWinPrizeLineCnt}
}
CMD_S_Open_Prize_Result_Ret = 
{
  --//后面跟nWinPrizeLineCnt  Win_Prize_Line_info 结构体
  --//Win_Prize_Line_info info[];    //
  {"nDeskStation","Int32",0},               --座位号
  {"byGameResult","Byte[]",100},          --15个位置的结果
  {"n64PlayerMoney","Int64",0},             --Credit
  {"nTotalWinScore","Int64",0},             --总赢分
  {"arTigMiniGameID","Byte",0},         --下一个游戏状态  0 正常结算 1 免费  2 水果机  minigameID 表示要进入小游戏 


  --{"nTotalMiniGameCnt","Int32"},          --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},        --当前多少局
  {"byHaveBigPrize","Byte",0},
  {"nMsgSeq","Int32",0},                    --分包标示   9999后面没有包
  {"nWinPrizeLineCnt","Int32",0},           --中奖的中奖线个数
  --{"Win_Prize_Line_info","Win_Prize_Line_info[]",nWinPrizeLineCnt}
}
--CMD_S_GAMESCORE_RESULT = 1103
CMD_S_GameScore_Result =
{
  {"nDeskStation","Int32",0},            --座位号
  {"nProfit","Int32",0},                 --玩家利润（赢分-下注数）
  {"nGameScore","Int32"},              --玩家游戏赢分
  {"n64PlayerMoney","Int64",0},          --玩家结算后金钱
  {"nBetLimitMin","Int32",0},            --下注下限
  {"nBetLimitMax","Int32",0},            --下注上限
}
--CMD_C_EXIT_GAME = 104
CMD_C_Exit_Game =
{
  --int nUSerID;              //UserID
  --int nDeskStation;           //ChairID
  {"nUSerID","Int32",0},                 --UserID
  {"nDeskStation","Int32",0},            --ChairID
}
--CMD_S_FREE_GAME_PLAY_RET   1201
CMD_S_Free_Game_Play_ret =
{
  {"nBetPrizeLineCount","Int32",0},      --下注押中奖线得数量
  {"nPlayerBet","Int32",0},              --单线押分值
  {"nFreeGamePlayCnt","Int32",0},        --免费游戏 总共多少次
  {"byRet","Byte",0},                    --结果
}


CMD_S_GameStationPlaying =
{
  --FruitGameParameter pamram;
  --FruitGameResult result;
  {"FruitScore","Int32[]",10},         -- 
  {"FruitID","Byte",0},                  --中奖项目ID 
  {"RemainedTimes","Byte",0},            --剩余次数 
  {"Score","Int32",0},                   --分数 
}


CDM_C_ChoiceReward_Play={
  {"nDeskStation","Int32",0},
  {"nSelectItemIndex","Int32",0},
}

--// 点击游戏选择开奖结果
CMD_S_ChoiceReward_Play_Result=
{
	{"nDeskStation","Int32",0},
	{"byItemCnt","Byte",0},				--// Item个数
	{"byOpenResult","Byte",0},				--// 大于0 开奖失败
	{"Game_ChoiceReward_Item","Game_ChoiceReward_Item[]",10},		
}

Game_ChoiceReward_Item=
{
	{"byItemType","Byte",0},			--    // 牌型  0 代表增加次数 1 代表金币 2 代表免费游戏 3 代表奖池奖励
	{"byOpenItenFlag","Byte",0},--		            // 开奖标志 0.BJJ 1.ZX
	{"bySelectIndex","Byte",0},						--            // 用户选择的索引
	 {"nItemVal","Int32",0}, 					      --          // 该Item的数值
};




GameStation_ChoiceReward_Game={
  {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},          --座位号
  {"nDeskStation","Int32",0},
  {"nTotalMiniGameCnt","Int32",0},
  {"nCurPlayMiniGameCnt","Int32",0},
  {"nAcumulateCount","Int32",0},
  {"byItemCnt","Byte",0},
  {"objPrizeInfo","Game_ChoiceReward_Item[]",10}
}

Game_ChoiceReward_Item=
{

  {"byResult","Byte",0},         --0 可以开奖   > 0 开奖错误编号
  {"byPrizeIndex","Byte",0}, --开奖索引好
  {"byPirziType","Byte",0},--开奖类型    0 开奖机会    1 免费游戏    2 彩金
  {"n64PrizeVal","Int64",0}, --中奖数值    如 3次 机会     n次免费游戏    n彩金  等等
 
}





GameStation_Bouns_JackPot=
{

  {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},          --座位号
  {"nTotalMinGameCnt","Int32",0},       --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},      --当前游戏局数
  {"nTotalWinScore","Int64",0},       --总赢分
  {"byTotalWinOpenCnt","Byte",0},           --总共赢取开奖次数
  {"byTotalWinFreeGameCnt","Byte",0},       --总共赢取 免费游戏次数
  {"byCurOpenPrizeCnt","Byte",0},             --已开奖的个数
  {"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item[]",10} ,   
};

CMD_C_JackPot_Play=
{
  {"nDeskStation","Int32",0},      --座位号
  {"nSelectItemIndex","Int32",0},
};


CMD_S_JackPot_Play_Result =
{
  {"nDeskStation","Int32",0},
  {"byResult","Byte",0},         --0 可以开奖   > 0 开奖错误编号
  {"nTotalMinGameCnt","Int32",0},            --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},          --当前游戏局数    nCurPlayMiniGameCnt >= nTotalMinGameCnt  游戏结束
  {"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item[]",0},  --开奖内容  
};


 
CMD_S_JackPot_Finish =
{
  {"nDeskStation","Int32",0},   
  {"nPlayerMoney","Int64",0},
  {"nTotalWinMoney","Int64",0},         --总共赢取金币    
  {"byTotalWinOpenCnt","Byte",0},     --总共赢取开奖次数
  {"byTotalWinFreeGameCnt","Byte",0}, --总共赢取 免费游戏次数
  {"byUnOpenItemCnt","Byte",0},             --未开奖的项个数 
  {"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item",10} ,    --  未开奖的项
};

Game_JackPot_Prize_Item =
{
  {"byItemIndex","Byte",0},  --再界面上显示的索引   客户端自己定，但是服务端会检测 和 和保留
  {"byPrizeIndex","Byte",0}, --开奖索引好
  {"byPirziType","Byte",0},--开奖类型    0 开奖机会    1 免费游戏    2 彩金
  {"n64PrizeVal","Int64",0}, --中奖数值    如 3次 机会     n次免费游戏    n彩金  等等
};



CMD_S_Change_Game_Sence = 
{
  {"nMiniGameID","Int32",0},    --要进入的场景    //下一个游戏状态  0 正常结算 minigameID 表示要进入小游戏。
  {"nTotalMiniGameCnt","Int32",0},                --//小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},              --//当前多少局
};





GameAudioPath= --声音路径
{
	BGM1={name="background",path="Common/Audio/BGM/background"},

  	EnterGame={name="bcakground intro",path="Common/Audio/Sound/bcakground intro"},
  	BtnCommon={name="button",path="Common/Audio/Sound/button"},
    RollNumber = {name="coin up",path="Common/Audio/Sound/coin up"},
    RollNumberEnd = {name="win",path="Common/Audio/Sound/win"},
    StartRoll = {
      {name="wheel spin",path="Common/Audio/Sound/wheel spin"},
      {name="wheel spin1",path="Common/Audio/Sound/wheel spin1"},
      {name="wheel spin2",path="Common/Audio/Sound/wheel spin2"},
      {name="wheel spin3",path="Common/Audio/Sound/wheel spin3"},
    },
    SymbolFallDown = {name="wheel stop",path="Common/Audio/Sound/wheel stop"},
    BigWin = {
      {name="big win",path="Common/Audio/Sound/big win"},
      {name="MEGA WIN",path="Common/Audio/Sound/MEGA WIN"},
    },
    Win = {
      {name="xsmall",path="Common/Audio/Sound/xsmall"},
      {name="small",path="Common/Audio/Sound/small"},
      {name="large",path="Common/Audio/Sound/large"},
      {name="Medium",path="Common/Audio/Sound/Medium"},
    },
  }


return GameDefine