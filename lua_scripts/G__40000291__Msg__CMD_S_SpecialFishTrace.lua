CMD_S_SpecialFishTrace={}

function CMD_S_SpecialFishTrace.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.btFishKind=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+1
	t.dwStartFishID=DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.nFishCount=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.nFishDistance=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.nInitCount=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+2
	t.fishPointList={}
	for i=1,t.nInitCount do
		t.fishPointList[i]={}
		t.fishPointList[i].nInitX=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--关键坐标
		iStartLength=iStartLength+2
		t.fishPointList[i].nInitY=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--关键坐标
		iStartLength=iStartLength+2
		t.fishPointList[i].nSpead=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--每个关键点开始的速度(像素/ms)  
		iStartLength=iStartLength+2
	end
	return t
end

--[[GameLuaDefine.CMD_S_FishSpecialTrace1={
	{"btFishKind","Byte",0},--鱼群种类
	{"dwStartFishID","UInt32",0},--鱼开始标识
	{"nFishCount","UInt16",0},--个数
	{"nFishDistance","UInt16",0},--//鱼距离
	{"nInitCount","UInt16",0},--//坐标数目
}
GameLuaDefine.FishTracePoint={
	{"nInitX","UInt16",0},--关键坐标
	{"nInitY","UInt16",0},--//关键坐标
	{"nSpead","UInt16",0},--//每个关键点开始的速度(像素/ms)  
}--]]