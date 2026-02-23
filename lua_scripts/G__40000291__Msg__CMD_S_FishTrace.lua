CMD_S_FishTrace={}
 function CMD_S_FishTrace.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.fishTraceCount=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.fishList={}
	for i=1,t.fishTraceCount do
		t.fishList[i]={}
		local fish=t.fishList[i]
		fish.btFishKind=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.FishKindGroup1=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.FishKindGroup2=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.FishKindGroup3=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.FishKindGroup4=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.FishKindGroup5=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		iStartLength=iStartLength+1
		fish.dwFishID=DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)
		iStartLength=iStartLength+4
		fish.iBaseMul=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
		iStartLength=iStartLength+4
		fish.usTraceId = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
		iStartLength=iStartLength+4
		fish.usStartPointIndex = DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
		iStartLength=iStartLength+2
		fish.usOffsetIndex = DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
		iStartLength=iStartLength+2
		--print("??????????????????????????? :",fish.dwFishID,"  ",fish.btFishKind,"  ",	fish.FishKindGroup1,"   ",	fish.FishKindGroup2,"  ",fish.FishKindGroup3,"   ",fish.FishKindGroup4,"  ",fish.usTraceId)
	end
	return t
end