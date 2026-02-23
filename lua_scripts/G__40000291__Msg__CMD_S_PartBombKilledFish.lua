CMD_S_PartBombKilledFish={}

function CMD_S_PartBombKilledFish.Decode(szBuffer)  --解码

 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.wChairID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.dwBulletID=DataParse.NetworkToHostOrderToUInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2

	 
	t.btFishKind=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.dwFishID=DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4

	t.FishKindGroup1=0

	t.FishKindGroup2=0 

	t.FishKindGroup3=0

	t.FishKindGroup4=0

	t.FishKindGroup5=0

	t.iFishScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+8

	t.nCaptureNetX=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2

	t.nCaptureNetY=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2

	t.byCannonLevelIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.sBaseMul = DataParse.NetworkToHostOrderToUInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2

	t.uTotalScore = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+8

	t.iLuckMul = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4

	-- t.btPropMark=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	-- iStartLength=iStartLength+1
	-- t.btCurCannonType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	-- iStartLength=iStartLength+1
	t.nFloatFishCount=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.hitFishItemList={}
	if t.nFloatFishCount>0 then
		for i=1,t.nFloatFishCount do
			t.hitFishItemList[i]={}
			t.hitFishItemList[i].dwFishID=DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
			t.hitFishItemList[i].btFishKind=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+1
			t.hitFishItemList[i].iFishScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+8
			t.hitFishItemList[i].sBaseMul = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
			t.hitFishItemList[i].iLuckMul = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
			t.hitFishItemList[i].dwIsKilled = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+4
		end
	end
	return t
end