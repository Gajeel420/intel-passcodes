CRspUpdatePlayerInfoMsgPara={}

 function CRspUpdatePlayerInfoMsgPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResultID=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--获取结果错误码
	iStartLength=iStartLength+2
	t.m_unFieldTypeBits=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)--要修改的字段位掩码
	iStartLength=iStartLength+8
	t.m_usInfoLen=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--获取结果错误码
	iStartLength=iStartLength+2
	t.m_szInfo={}--更新的内容, ","分隔各信息内容, 各信息内容以字符串的形式存入缓冲区
	for i=1,t.m_usInfoLen do
		t.m_szInfo[i]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--
		iStartLength=iStartLength+1
	end
	return t
 end