CNotifyNotificationMsg={}

function CNotifyNotificationMsg.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_unId=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)  --公告ID
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.m_unTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)   --公告发布时间
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.m_ucType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength) --公告类型
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	t.m_usLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--公告长度
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,t.m_usLength)--公告内容
	return t
end

