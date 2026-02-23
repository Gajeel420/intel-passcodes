CRspQueryGlodEmailMsgPara={}

function CRspQueryGlodEmailMsgPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_unTotal=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_usThisReturnNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_UserEmailList={}
	if t.m_usThisReturnNum>0 then
		for i=1,t.m_usThisReturnNum do
			t.m_UserEmailList[i]={}
			local tmp=t.m_UserEmailList[i]
			tmp.m_unEmailId=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)--邮件ID
			iStartLength=iStartLength+NetworkDefine.DataType.Int32

			tmp.m_unTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)--邮件发送时间
			iStartLength=iStartLength+NetworkDefine.DataType.Int32

			tmp.m_ucEmailStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--邮件发送时间
			iStartLength=iStartLength+NetworkDefine.DataType.Byte

			tmp.m_usTitleLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--邮件标题长度
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			tmp.m_szTitle=DataParse.BytesToString2(szBuffer,iStartLength,tmp.m_usTitleLength)--邮件标题
			iStartLength=iStartLength+tmp.m_usTitleLength;--/

			tmp.m_usContentLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			tmp.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,tmp.m_usContentLength)--邮件标题
			iStartLength=iStartLength+tmp.m_usContentLength;--/
		end
	end
	return t
end