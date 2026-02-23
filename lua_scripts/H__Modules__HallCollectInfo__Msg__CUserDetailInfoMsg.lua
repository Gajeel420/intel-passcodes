CUserDetailInfoMsg={}

 function CUserDetailInfoMsg.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_unUin = DataParse.NetworkToHostOrderToUInt32(szBuffer,iStartLength)--用户id
	iStartLength = iStartLength + NetworkDefine.DataType.UInt32
    
    t.m_byOperateType = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--0=查询, 1=设置
	iStartLength = iStartLength + NetworkDefine.DataType.Byte
    
    t.m_sLen = DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength = iStartLength + NetworkDefine.DataType.Int16

    t.m_szDetailInfo = {}   --用户详细信息 real_name:Bai deng;phone:18688889999;email:bai_deng@gmail.com
    for i = 1, t.m_sLen do
        t.m_szDetailInfo[i] = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--
        iStartLength = iStartLength + NetworkDefine.DataType.Byte
    end

	return t
 end