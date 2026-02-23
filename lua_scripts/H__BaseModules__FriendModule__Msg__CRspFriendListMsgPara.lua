CRspFriendListMsgPara={}

function CRspFriendListMsgPara.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_usTotalFriendNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_usThisReturnNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_FriendInfoList={}
	if t.m_usThisReturnNum>0 then
		for i=1,t.m_usThisReturnNum do
			t.m_FriendInfoList[i]={}
			t.m_FriendInfoList[i].m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//用户的UIN

		    t.m_FriendInfoList[i].m_unExperience=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//经验值

		    t.m_FriendInfoList[i].m_unWalletMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64; --//身上钱

		    t.m_FriendInfoList[i].m_ucSex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//性别, 1: 男, 0: 女

		    t.m_FriendInfoList[i].m_ucImageNo=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte;-- //头像编号

		    t.m_FriendInfoList[i].m_ucNickLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte;
		    t.m_FriendInfoList[i].m_szNickName=DataParse.BytesToString2(szBuffer,iStartLength,t.m_FriendInfoList[i].m_ucNickLen)
			iStartLength=iStartLength+t.m_FriendInfoList[i].m_ucNickLen;--//昵称

		    t.m_FriendInfoList[i].m_ucSignatureLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte;

		    t.m_FriendInfoList[i].m_szSignature=DataParse.BytesToString2(szBuffer,iStartLength,t.m_FriendInfoList[i].m_ucSignatureLen)
			iStartLength=iStartLength+t.m_FriendInfoList[i].m_ucSignatureLen;--/

		    t.m_FriendInfoList[i].m_unVIPLevel=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//VIP等级

		    t.m_FriendInfoList[i].m_ucCertificateCellPhone=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证手机号码

		    t.m_FriendInfoList[i].m_ucCertificate=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证身份证号

		    t.m_FriendInfoList[i].m_ucOnlineStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否在线, 1: 在线, 0:　离线
		end
	end
	return t
 end