TUserInfo = TUserInfo or BaseClass()

function TUserInfo:__init( ... )
	self.m_unUIN=0; --//用户的UIN
    self.m_unExperience=0; --//经验值
    self.m_unWalletMoney=0; --//身上钱
    self.m_ucSex=0; --//性别, 1: 男, 0: 女
    self.m_ucImageNo=0; --//头像编号
    self.m_ucNickLen=0;
    self.m_szNickName = "";--//昵称
    self.m_ucSignatureLen=0;
    self.m_szSignature = "";--//个性签名
    self.m_unVIPLevel=0; --//VIP等级
    self.m_ucCertificateCellPhone=0; --//是否已经认证手机号码
    self.m_ucCertificate=0; --//是否已经认证身份证号
    self.m_ucOnlineStatus=0; --/--/是否在线, 1: 在线, 0:　离线
end

function TUserInfo:InitVo(vo)
	if vo then 
		for k,v in pairs(vo) do
			self[k] = v
		end
	end
end


function TUserInfo:__delete( ... )
	-- body
end