CRequserDissolveGameBrocard = {}

-- NetworkDefine.CRequserDissolveGameBrocard2={
-- 	    {"m_usResultID","Int16",0},--结果
-- 	    {"m_unOprUIn","Int32",0},--申请者id    
-- 	    {"m_unCardID","Int32",0},--房间id    
-- 	    {"m_unSeconds","Int32",0},--时间  
-- 	    {"m_usNumber","Int16",0},--/数量 
-- 	    {"	","NetworkDefine.DissolveRoomUserInfo",msg1.m_usNumber},--/数量 
-- 	}
-- NetworkDefine.DissolveRoomUserInfo={
--     {"m_unUin", "Int32", 0},           --
--     {"m_usAgreeFlag", "Int16", 0},           --
--     {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--
-- }


function CRequserDissolveGameBrocard.Decode(szBuffer)
	if szBuffer==nil then return end
	local iStartLength=0
	local t={}

	t.m_usResultID=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_unOprUIn=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_unCardID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_unSeconds=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_usNumber=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_szDissolveUserInfo={}
	if t.m_usNumber>1 then
		for i=1,t.m_usNumber do
			t.m_szDissolveUserInfo[i]={}
			t.m_szDissolveUserInfo[i].m_unUin=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32

			t.m_szDissolveUserInfo[i].m_usAgreeFlag=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			t.m_szDissolveUserInfo[i].m_szNickName=DataParse.BytesToString(szBuffer,iStartLength,HallDefine.ConstDefine.MAX_NICK_LEN)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte*HallDefine.ConstDefine.MAX_NICK_LEN
		end
	end
	return t
end
