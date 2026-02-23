ASSGMGameStation = {}

-- 状态, 数据包 NetworkToHostOrderToInt64  NetworkToHostOrderToInt32  NetworkToHostOrderToInt16 NetworkToHostOrderToByte
function ASSGMGameStation.Decode(state, szBuffer)
	if szBuffer == nil then return end
	local iStartLength = 0
	local t = {}
	local MAX_COL_CNT = 10
	local MAX_LINE_CNT = 10
	local BONUS_ITEM_NUM = 10
	t.bStation = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏状态    
	iStartLength = iStartLength + NetworkDefine.DataType.Byte
	t.iVersion = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏版本号
	iStartLength = iStartLength + NetworkDefine.DataType.Byte
	t.iVersion2 = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏版本号
	iStartLength = iStartLength + NetworkDefine.DataType.Byte
	t.bDeskStation = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --座位号
	iStartLength = iStartLength + NetworkDefine.DataType.Byte
    if state == 0 then --正常游戏
		t.byGameResult = {}
		for i=1, 100 do
			t.byGameResult[i]= DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏结果
			iStartLength = iStartLength + NetworkDefine.DataType.Byte
		end
		t.nBetLineCount = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength)  --玩家押注倍数
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		t.nPlayerBet = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength)  --玩家押注倍数
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		t.n64PlayerMoney = DataParse.NetworkToHostOrderToInt64(szBuffer, iStartLength)  --玩家身上的钱
		iStartLength = iStartLength + NetworkDefine.DataType.Int64
		t.nWinScore = DataParse.NetworkToHostOrderToInt64(szBuffer, iStartLength)  --赢分
		iStartLength = iStartLength + NetworkDefine.DataType.Int64
    elseif state == 1 then --免费游戏
        t.nTotalMiniGameCnt = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength)  --总局数
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		t.nCurPlayMiniGameCnt = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength)  --当前多少局
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		t.nTotalWinScore = DataParse.NetworkToHostOrderToInt64(szBuffer, iStartLength)  --总赢分
		iStartLength = iStartLength + NetworkDefine.DataType.Int64
		t.nSelectLineCount = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength)  --选中奖线数量
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		t.nPlayerBet = DataParse.NetworkToHostOrderToInt32(szBuffer, iStartLength) -- 玩家下注倍数
		iStartLength = iStartLength + NetworkDefine.DataType.Int32
		
		t.byGameResult={}		--新加上一把结果
		for i=1,100 do
			t.byGameResult[i]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+1
		end
	
	elseif state == 4 then --选龙
	    t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.nTotalMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.nCurPlayMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.nAcumulateCount=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.byItemCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Byte
		t.objPrizeInfo = {}
			for i=1, 10 do
				t.objPrizeInfo[i] = {}
				t.objPrizeInfo[i].byResult = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏结果
				iStartLength = iStartLength + NetworkDefine.DataType.Byte
				t.objPrizeInfo[i].byPrizeIndex = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength = iStartLength + NetworkDefine.DataType.Byte
				t.objPrizeInfo[i].byPirziType = DataParse.NetworkToHostOrderToByte(szBuffer, iStartLength)  --游戏结果
				iStartLength = iStartLength + NetworkDefine.DataType.Byte
				t.objPrizeInfo[i].n64PrizeVal = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int64
			end
	elseif state == 3 then --Jackpot
		t.nTotalMinGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.nCurPlayMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int32
	    t.nTotalWinScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Int64
	    t.byTotalWinOpenCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Byte
	    t.byTotalWinFreeGameCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	    iStartLength=iStartLength+NetworkDefine.DataType.Byte
	    t.byCurOpenPrizeCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+NetworkDefine.DataType.Byte
		t.Game_JackPot_Prize_Item={}
  
		if t.byCurOpenPrizeCnt>0 then
			for i=1,t.byCurOpenPrizeCnt do
				t.Game_JackPot_Prize_Item[i]={}
				local info=t.Game_JackPot_Prize_Item[i]
				info.byItemIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
				info.byPrizeIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
				info.byPirziType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
				info.n64PrizeVal=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int64
			end
		end
	end
	return t
  end

return  ASSGMGameStation

--状态协议
--[[GameStation_Base =
{
  {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},          --座位号
}
--ASS_GM_GAME_STATION = 2
GameStation_Normal = 
{
 {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},    
  {"byGameResult","Byte[]",100},               --游戏结果，在2,3,4状态有效 根据 列数，行数 做解析  x,y 坐标轴体系


  {"nBetLineCount","Int32",0},                   --压中奖线数量
  {"nPlayerBet","Int32",0},                      --玩家押注倍数
  {"n64PlayerMoney","Int64",0},                  --玩家身上的钱
  {"nWinScore","Int64",0},                       --赢分
}

--#define ASS_GM_GAME_STATION       2     //游戏状态  服务端 -》客户端
GameStation_Free_Game =   --免费游戏状态
{
 {"bStation", "Byte",0},              --游戏状态      0 正常 1 免费  2 水果机   
  {"iVersion", "Byte",0},              --游戏版本号
  {"iVersion2", "Byte",0},             --游戏版本号
  {"bDeskStation", "Byte",0},    
  --{"byGameResult","Byte[]",100},               --游戏结果，在2,3,4状态有效 根据 列数，行数 做解析  x,y 坐标轴体系


  {"nTotalMiniGameCnt","Int32",0},                   --总局数
  {"nCurPlayMiniGameCnt","Int32",0},                      --当前多少局
  {"nTotalWinScore","Int64",0},                  --总赢分
  --{"nWinScore","Int32"},                       --赢分
  {"nSelectLineCount","Int32",0},
  {"nPlayerBet","Int32",0},
}--]]
--[[GameStation_Bouns_JackPot=
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
  --{"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item[]",10} ,   
};--]]
--[[GameStation_ChoiceReward_Game={
   {"GameStation_Base","GameStation_Base[]",1}, --基础消息    BYTE  bStation;游戏状态    
  {"nDeskStation","Int32",0},
  {"nTotalMiniGameCnt","Int32",0},
  {"nCurPlayMiniGameCnt","Int32",0},
  {"nAcumulateCount","Int32",0},
  {"byItemCnt","Byte",0},
  {"objPrizeInfo","Game_ChoiceReward_Item[]",10}
}--]]