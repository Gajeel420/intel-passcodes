MSG_GameStationDataRes={}


 function MSG_GameStationDataRes.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}

    t.byGameState = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)       --当前游戏状态
    iStartLength = iStartLength + NetworkDefine.DataType.Byte

    t.byChipCnt = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)    --筹码个数
    iStartLength = iStartLength + NetworkDefine.DataType.Byte
    t.vecChipAmounts = {}                                                           --筹码金额
    for i = 1, t.byChipCnt do
        t.vecChipAmounts[i] = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)       
        iStartLength = iStartLength + NetworkDefine.DataType.Int64
    end

    t.byChipIndex = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)         --默认记忆筹码索引
    iStartLength = iStartLength + NetworkDefine.DataType.Byte

    t.n64BalanceCoin = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)        --用户余额金币 （开奖状态时，等开奖结束才刷新该余额，开奖前金额（n64BalanceCoin-n64WinLoseMoney））
    iStartLength = iStartLength + NetworkDefine.DataType.Int64

    t.unPrizeOdds = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)    --开奖赔率 放大100倍（即保留两位数）101=赔率1.01
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

	return t
 end
