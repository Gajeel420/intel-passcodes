CMDSJackPotPLAYRESULT = {}


function CMDSJackPotPLAYRESULT.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.byResult=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	t.nTotalMinGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.nCurPlayMiniGameCnt=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	
	t.Game_JackPot_Prize_Item={}
	t.Game_JackPot_Prize_Item[1]={}  
	local info = t.Game_JackPot_Prize_Item[1]
	info.byItemIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	info.byPrizeIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	info.byPirziType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	info.n64PrizeVal=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+8
	return t
 end
return CMDSJackPotPLAYRESULT


--[[CMD_S_JackPot_Play_Result =
{
  {"nDeskStation","Int32",0},
  {"byResult","Byte",0},         --0 可以开奖   > 0 开奖错误编号
  {"nTotalMinGameCnt","Int32",0},            --小游戏总局数
  {"nCurPlayMiniGameCnt","Int32",0},          --当前游戏局数    nCurPlayMiniGameCnt >= nTotalMinGameCnt  游戏结束
  {"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item[]",1},  --开奖内容  
};--]]
