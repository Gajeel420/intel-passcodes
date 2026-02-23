CMDSSelectReward={}

function CMDSSelectReward.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.byItemCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.byOpenResult=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	
	t.Game_ChoiceReward_Item={}	  
	if t.byOpenResult==0 then
		for i=1,10 do
			t.Game_ChoiceReward_Item[i]={}
			local info=t.Game_ChoiceReward_Item[i]
			info.byItemType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte
			info.byOpenItenFlag=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte
			info.bySelectIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte
			info.nItemVal=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64
		end
	end
	return t
 end

return CMDSSelectReward