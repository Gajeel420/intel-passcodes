CRspNotificationListMsgPara={}

function CRspNotificationListMsgPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_unTotal=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_usThisReturnNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_UserNoticeInfoList={}

	if t.m_usThisReturnNum>0 then
		for i=1,t.m_usThisReturnNum do
			t.m_UserNoticeInfoList[i]={}
			t.m_UserNoticeInfoList[i].m_unNotificationId=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32

			t.m_UserNoticeInfoList[i].m_ucType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte

			t.m_UserNoticeInfoList[i].m_usTitleLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			local tmp={}
			for n=1,t.m_UserNoticeInfoList[i].m_usTitleLength do
				tmp[n]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
			end
			t.m_UserNoticeInfoList[i].m_szTitle=CommonUtil.LuaTableToStringNoEmpty(tmp)
			tmp={}

			t.m_UserNoticeInfoList[i].m_usContentLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16
			for j=1,t.m_UserNoticeInfoList[i].m_usContentLength do
				tmp[j]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
			end
			t.m_UserNoticeInfoList[i].m_szContent=CommonUtil.LuaTableToStringNoEmpty(tmp)
			tmp={}

			t.m_UserNoticeInfoList[i].m_usOuterLinkAddressLength=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			for k=1,t.m_UserNoticeInfoList[i].m_usOuterLinkAddressLength do
				tmp[k]=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte
			end
			t.m_UserNoticeInfoList[i].m_szOuterLinkAddress=CommonUtil.LuaTableToStringNoEmpty(tmp)
			tmp={}
		end
	end
	return t
end

-- public struct TNoticeInfoDetails
-- {
--     public int m_unNotificationId; //公告ID
--     public byte m_ucType; //公告类型, 文本, 图片 0, 1
--     public short m_usTitleLength; //公告标题长度
--     public string m_szTitle;//公告标题内容
--     public short m_usContentLength;//公告内容长度
--     public string m_szContent;//公告内容
--     public short m_usOuterLinkAddressLength;//外链URL地址长度 
--     public string m_szOuterLinkAddress;//外链URL地址
-- }