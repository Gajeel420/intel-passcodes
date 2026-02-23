CNotifyEmailMsgPara={}
function CNotifyEmailMsgPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_unEmailId=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)--邮件ID
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_unTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)--邮件发送时间
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_ucEmailStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--邮件发送时间
	iStartLength=iStartLength+NetworkDefine.DataType.Byte

	t.m_usTitleLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--邮件标题长度
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_szTitle=DataParse.BytesToString2(szBuffer,iStartLength,t.m_usTitleLength)--邮件标题
	iStartLength=iStartLength+t.m_usTitleLength;--/

	t.m_usContentLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,t.m_usContentLength)--邮件标题
	iStartLength=iStartLength+t.m_usContentLength;--/
	return t
end