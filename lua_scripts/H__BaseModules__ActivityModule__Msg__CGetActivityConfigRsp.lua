CGetActivityConfigRsp = {}
function CGetActivityConfigRsp.Decode(szBuffer)  --解码
 	if szBuffer == nil then return end
	local iStartLength = 0
	local t={}

    t.resCode = DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)  -- 返回码 0=成功，1=失败
    iStartLength = iStartLength + NetworkDefine.DataType.Int16

    t.activeId = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.isActive = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength = iStartLength+NetworkDefine.DataType.Byte

    t.currentTimestamp = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)     -- 当前时间 时间戳
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.startTimestamp = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)  -- 开始时间 时间戳
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.endTimestamp = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)    -- 结束时间 时间戳
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.activityName = DataParse.BytesToString(szBuffer,iStartLength,NetworkDefine.ACTIVITY_LEN.E_ACTIVITY_LEN_activity_name) --活动名称
    iStartLength= iStartLength + NetworkDefine.DataType.Byte * NetworkDefine.ACTIVITY_LEN.E_ACTIVITY_LEN_activity_name

    t.timeZone = DataParse.BytesToString2(szBuffer,iStartLength,NetworkDefine.ACTIVITY_LEN.E_ACTIVITY_LEN_timeZone)  -- 服务器时区
    iStartLength = iStartLength + NetworkDefine.DataType.Byte * NetworkDefine.ACTIVITY_LEN.E_ACTIVITY_LEN_timeZone

    t.len = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --活动方案总长度
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.activitySchedule = Json.decode(DataParse.BytesToString2(szBuffer, iStartLength, t.len))  --活动方案
    iStartLength= iStartLength + NetworkDefine.DataType.Byte * t.len

    return t
end
