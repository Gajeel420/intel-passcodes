CMDSOpenPrizeFullLineResult={}

 function CMDSOpenPrizeFullLineResult.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.byGameResult={}
	for n=1,100 do
		t.byGameResult[n]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
	end
	t.n64PlayerMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+8
	t.nTotalWinScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+8
	t.arTigMiniGameID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	t.nTotalMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.nCurPlayMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.byHaveBigPrize=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	t.nMsgSeq=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.nWinPrizeLineCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.winPrizeLineinfo={}
	if t.nWinPrizeLineCnt>0 then
		for i=1,t.nWinPrizeLineCnt do
			t.winPrizeLineinfo[i]={}
			local info=t.winPrizeLineinfo[i]
			info.nPrizeLineID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
			info.nXPos={}
			for j=1,10 do
				info.nXPos[j]=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+4
			end
			info.nYPos={}
			for k=1,10 do
				info.nYPos[k]=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+4
			end
			info.nWinLineBase=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
			info.nWinLineScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+8
			info.nGameItemID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
		end
	end
	return t
	
 end

return  CMDSOpenPrizeFullLineResult


-- GameLuaDefine.Win_Prize_Line_info =
-- {
--   {"nPrizeLineID","Int32",0},                --中奖线ID
--   {"nXPos","Int32[]",10},                  --中奖的横坐标   列
--   {"nYPos","Int32[]",10},                  --中奖的书坐标   行
--   {"nWinLineBase","Int32",0},                --本条线中间的倍数
--   {"nWinLineScore","Int64",0},               --赢分
--   {"nGameItemID","Int32",0},                 --游戏项ID
-- }
-- GameLuaDefine.CMD_S_Open_Prize_Result = 
-- {
--   {"nDeskStation","Int32",0},               --座位号
--   {"byGameResult","Byte[]",100},          --15个位置的结果
--   {"n64PlayerMoney","Int64",0},             --Credit
--   {"nTotalWinScore","Int64",0},             --总赢分
--   {"arTigMiniGameID","Byte",0},         --下一个游戏状态  0 正常结算 1 免费  2 水果机  minigameID 表示要进入小游戏 
--   {"nTotalMiniGameCnt","Int32",0},          --小游戏总局数
--   {"nCurPlayMiniGameCnt","Int32",0},        --当前多少局
--   {"byHaveBigPrize","Byte",0},              --大奖
--   {"nMsgSeq","Int32",0},                    --分包标示   9999后面没有包
--   {"nWinPrizeLineCnt","Int32",0},           --中奖的中奖线个数
-- }