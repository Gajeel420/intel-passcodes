CRspQueryWinRankingListPara={}


 function CRspQueryWinRankingListPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResult=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_usRspUserCount=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.m_RspUserList={}
	if t.m_usRspUserCount>0 then
		for i=1,t.m_usRspUserCount do
			t.m_RspUserList[i]={}
			t.m_RspUserList[i].m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//用户的UIN

		    -- t.m_RspUserList[i].m_unExperience=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//经验值

		    -- t.m_RspUserList[i].m_unWalletMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Int64; --//身上钱

		    -- t.m_RspUserList[i].m_ucSex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//性别, 1: 男, 0: 女

		    -- t.m_RspUserList[i].m_ucImageNo=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte;-- //头像编号

		    -- t.m_RspUserList[i].m_ucNickLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte;
		    t.m_RspUserList[i].m_szNickName=DataParse.BytesToString2(szBuffer,iStartLength,64)
			iStartLength=iStartLength+64--//昵称

		    -- t.m_RspUserList[i].m_ucSignatureLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte;

		    -- t.m_RspUserList[i].m_szSignature=DataParse.BytesToString2(szBuffer,iStartLength,t.m_RspUserList[i].m_ucSignatureLen)
			-- iStartLength=iStartLength+t.m_RspUserList[i].m_ucSignatureLen;--/

		    -- t.m_RspUserList[i].m_unVIPLevel=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//VIP等级

		    -- t.m_RspUserList[i].m_ucCertificateCellPhone=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证手机号码

		    -- t.m_RspUserList[i].m_ucCertificate=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证身份证号

		    -- t.m_RspUserList[i].m_ucOnlineStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			-- iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否在线, 1: 在线, 0:　离线

			t.m_RspUserList[i].m_un64Coins = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64; --// 赢钱数
		end
	end
	return t
 end