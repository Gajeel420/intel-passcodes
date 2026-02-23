CMD_S_CONFIG_INFO={}

 function CMD_S_CONFIG_INFO.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nCannonLevelValSize=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.nCannonLevelValList={}--炮弹等级值列表
	for i=1,t.nCannonLevelValSize do
		t.nCannonLevelValList[i]=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
		iStartLength=iStartLength+8
	end
	t.nCannonShowNumList={}--炮弹等级对应的炮管数
	for i=1,t.nCannonLevelValSize do
		t.nCannonShowNumList[i]=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
		iStartLength=iStartLength+2
	end
	t.nBulletCountInSereen=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	
	t.btFixTimes=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	t.iClientNotOperateTipTimes=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.iClientExitTimes=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.iClientLessMoneyTip=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	return t
 end