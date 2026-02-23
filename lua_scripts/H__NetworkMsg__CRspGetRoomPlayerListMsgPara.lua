CRspGetRoomPlayerListMsgPara={}

function CRspGetRoomPlayerListMsgPara.Decode(szBuffer)
	if szBuffer==nil then return end
	
	local iStartLength=0
	local t={}

	t.m_sResult=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_sRoomID=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_uDeskIndex=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_bDeskCount=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte

	t.m_DeskUserInfo={}
	if t.m_bDeskCount>0 then
		for i=1,t.m_bDeskCount do
			t.m_DeskUserInfo[i]={}
			t.m_DeskUserInfo[i].m_sDeskNo=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			t.m_DeskUserInfo[i].m_bMaxUser=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			t.m_DeskUserInfo[i].m_szPassword={}
			-- for n=1,64 do
			-- 	t.m_DeskUserInfo[i].m_szPassword[n]=
			-- end
			iStartLength=iStartLength+NetworkDefine.DataType.Byte*64

			t.m_DeskUserInfo[i].m_bUserCount=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte

			local userNum=t.m_DeskUserInfo[i].m_bUserCount
			t.m_DeskUserInfo[i].m_szUserInfoStruct={}
			for n=1,userNum do
				t.m_DeskUserInfo[i].m_szUserInfoStruct[n]={}
				local deskUerInfo=t.m_DeskUserInfo[i].m_szUserInfoStruct[n]
				deskUerInfo.m_bDeskStation=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte

				deskUerInfo.m_iUserID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int32

				deskUerInfo.m_iMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int64

				deskUerInfo.m_iVipLevel=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int32

				deskUerInfo.m_szNickName=DataParse.BytesToString(szBuffer,iStartLength,HallDefine.ConstDefine.MAX_NICK_LEN)
				iStartLength=iStartLength+NetworkDefine.DataType.Byte*HallDefine.ConstDefine.MAX_NICK_LEN
				
				deskUerInfo.m_szImageAddr = {}
				for i = 1, 128 do
					deskUerInfo.m_szImageAddr[i] = DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
					iStartLength=iStartLength+NetworkDefine.DataType.Byte
				end
				deskUerInfo.m_sSex=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
				iStartLength=iStartLength+NetworkDefine.DataType.Int16

			end
		end
	end
	return t
end

