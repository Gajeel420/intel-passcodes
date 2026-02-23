CRspQueryJackMsgPara = {}

function CRspQueryJackMsgPara.Decode( buffer )
	-- body
	if buffer == nil then return end

	local iStartLength = 0 
	local t = {}
	t.m_unTotal = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength)
	iStartLength = iStartLength + NetworkDefine.DataType.Int32
	t.JackPotList = {}
	if t.m_unTotal > 0 then
		for i = 1,t.m_unTotal do
			t.JackPotList[i] = {}
			local temp = t.JackPotList[i]
			temp.m_unUIN = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength) --玩家id
			iStartLength = iStartLength + NetworkDefine.DataType.Int32
			temp.m_szNickName = DataParse.BytesToString2(buffer,iStartLength,64)--昵称
			iStartLength = iStartLength + 64
			temp.m_usGameId = DataParse.NetworkToHostOrderToInt16(buffer,iStartLength) --游戏id
			iStartLength=iStartLength+NetworkDefine.DataType.Int16
			temp.m_iLotteryType = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength) --彩金类型
			iStartLength = iStartLength + NetworkDefine.DataType.Int32
			temp.m_un64Profit= DataParse.NetworkToHostOrderToInt64(buffer,iStartLength) --彩金收益
			iStartLength = iStartLength + NetworkDefine.DataType.Int64
			temp.iImageNo = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength) --玩家id
			iStartLength = iStartLength + NetworkDefine.DataType.Int32
		end
	end
	return t
end