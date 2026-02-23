CMDSJackPotFINISH = {}


function CMDSJackPotFINISH.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.nPlayerMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int64
	t.nTotalWinMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int64
	t.byTotalWinOpenCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byTotalWinFreeGameCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byUnOpenItemCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	
	t.Game_JackPot_Prize_Item={}	  
	if t.byUnOpenItemCnt>0 then
		for i=1,t.byUnOpenItemCnt do
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
	return t
 end

return CMDSJackPotFINISH
--[[CMD_S_JackPot_Finish =
{
  {"nDeskStation","Int32",0},   
  {"nPlayerMoney","Int64",0},
  {"nTotalWinMoney","Int64",0},         --总共赢取金币    
  {"byTotalWinOpenCnt","Byte",0},     --总共赢取开奖次数
  {"byTotalWinFreeGameCnt","Byte",0}, --总共赢取 免费游戏次数
  {"byUnOpenItemCnt","Byte",0},             --未开奖的项个数 
  {"Game_JackPot_Prize_Item","Game_JackPot_Prize_Item",10} ,    --  未开奖的项
};--]]