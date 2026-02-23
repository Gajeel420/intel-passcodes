CMDOpenPrizeResultWithSeq={}

 function CMDOpenPrizeResultWithSeq.Decode(szBuffer)  --解码
    if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.byCurMiniGameID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.nClientReqSeq=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.nSrvCurMsgSeq=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.strGameCode=DataParse.BytesToString2(szBuffer,iStartLength,20)
	iStartLength=iStartLength+20
	-- for n=1,20 do
	-- 	t.strGameCode[n]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	-- 	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	-- end
	t.byGameResult={}
	for n=1,100 do
		t.byGameResult[n]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+NetworkDefine.DataType.Byte
	end
	t.n64PlayerMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int64
	t.nTotalWinScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int64
	t.byNewTriMiniGameID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byNewTriMiniGameCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byCurMiniGameCurPlayCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byCurMiniGameTotalPlayCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byRmCurCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byTmTotalCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.nMsgStateFlag=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.nWinPrizeLineCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.winPrizeLineinfo={}
	if t.nWinPrizeLineCnt>0 then
		for i=1,t.nWinPrizeLineCnt do
			t.winPrizeLineinfo[i]={}
			local info=t.winPrizeLineinfo[i]
			info.nPrizeLineID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32
			info.nXPos={}
			for j=1,10 do
				info.nXPos[j]=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int32
			end
			info.nYPos={}
			for k=1,10 do
				info.nYPos[k]=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int32
			end
			info.nWinLineBase=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32
			info.nWinLineScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64
			info.nGameItemID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32
		end
	end
	return t
	
 end

return  CMDOpenPrizeResultWithSeq


-- GameLuaDefine.Win_Prize_Line_info =
-- {
--   {"nPrizeLineID","Int32",0},                --中奖线ID
--   {"nXPos","Int32[]",10},                  --中奖的横坐标   列
--   {"nYPos","Int32[]",10},                  --中奖的书坐标   行
--   {"nWinLineBase","Int32",0},                --本条线中间的倍数
--   {"nWinLineScore","Int64",0},               --赢分
--   {"nGameItemID","Int32",0},                 --游戏项ID
-- }
-- CMD_S_Open_Prize_Result_With_Seq   //合并 满线 中奖协议 和  不满线中奖协议
-- {
-- 	int nDeskStation;                                       // 座位号
-- 	byte byCurMiniGameID;                                   // 当前的小游戏ID 号                   Add 20241219
-- 	int nClientReqSeq;                                      // 客户端请求游戏消息时的 seq          Add 20241219
-- 	int nSrvCurMsgSeq;                                      // 未出结果之前，服务端当前的msg seq   Add 20241219
-- 	char strGameCode[_MAX_GAME_CODE_LEN];                                   // 游戏编号                            Add 20241219
-- 	// 15个位置的结果    pGameResult->byResult[pGameConfig->iColCount][1] = pGameResult->nFreeGameSpecialRewardBase / 4;
-- 	//byResult[pGameConfig->iColCount][1-4] = pGameResult->nFreeGameSpecialRewardBase / 4;  288 由于奖励背书月结，用四个字段转义为 额外倍数
-- 	//byResult[iColCount+1][0]   296 中表示是否有全盘奖励   
-- 	byte byGameResult[MAX_COL_CNT][MAX_LINE_CNT];           //游戏结果
-- 	INT64 n64PlayerMoney;					                // Credit
-- 	__int64 nTotalWinScore;						            // 总赢分
-- 	byte byNewTriMiniGameID;                                // 下一个游戏状态  0 正常结算 minigameID 表示要进入小游戏。 再冰球突破中，如果为2 则表示冰球突破成功
-- 	byte byNewTriMiniGameCnt;                               // 新触发小游戏局数
-- 	byte byCurMiniGameCurPlayCnt;                           // 当前小游戏玩的局数
-- 	byte byCurMiniGameTotalPlayCnt;                         // 当前小游戏总局数
-- 	byte byRmCurCnt;                                        // 当前消除的次数
-- 	byte byTmTotalCnt;                                      // 本次总的消除次数	
-- 	int  nMsgStateFlag;                                     // 消息序列号   9999 表示多次传输  中奖线 结束
-- 	int nWinPrizeLineCnt;                                   // 中奖的中奖线个数
-- 	//Win_Prize_Line_info info[]                            // 中奖线信息
-- };