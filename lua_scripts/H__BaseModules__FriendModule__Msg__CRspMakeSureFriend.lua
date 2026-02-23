CRspMakeSureFriend={}

function CRspMakeSureFriend.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//用户的UIN

    t.m_unExperience=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//经验值

    t.m_unWalletMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int64; --//身上钱

    t.m_ucSex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//性别, 1: 男, 0: 女

    t.m_ucImageNo=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte;-- //头像编号

    t.m_ucNickLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte;
    t.m_szNickName=DataParse.BytesToString2(szBuffer,iStartLength,t.m_ucNickLen)
	iStartLength=iStartLength+t.m_ucNickLen;--//昵称

    t.m_ucSignatureLen=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte;

    t.m_szSignature=DataParse.BytesToString2(szBuffer,iStartLength,t.m_ucSignatureLen)
	iStartLength=iStartLength+t.m_ucSignatureLen;--/

    t.m_unVIPLevel=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//VIP等级

    t.m_ucCertificateCellPhone=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证手机号码

    t.m_ucCertificate=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否已经认证身份证号

    t.m_ucOnlineStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte; --//是否在线, 1: 在线, 0:　离线
	return t
end
