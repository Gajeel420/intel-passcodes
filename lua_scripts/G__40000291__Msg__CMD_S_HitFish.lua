CMD_S_HitFish={}
function CMD_S_HitFish.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.wChairID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.dwBulletID=DataParse.NetworkToHostOrderToUInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2

	t.dwFishID=DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4

	t.btFishKind=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.FishKindGroup1=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.FishKindGroup2=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.FishKindGroup3=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.FishKindGroup4=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

	t.FishKindGroup5=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1

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