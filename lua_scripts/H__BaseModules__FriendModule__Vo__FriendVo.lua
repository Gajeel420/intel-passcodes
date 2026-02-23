FriendVo = FriendVo or BaseClass(LuaModel)
function FriendVo:__init()
	self.m_unUIN = 0 --用户的Uin
	self.m_unExperience = 0--用户的经验值
	self.m_unWalletMoney = 0 --身上的钱
    self.m_ucSex = 0--性别, 1: 男, 0: 女
    self.m_ucImageNo = 0 --头像编号
    self.m_szNickName = "" --昵称
    self.m_szSignature= "" --个性签名
    self.m_unVIPLevel = 0 --VIP等级
    self.m_ucCertificateCellPhone = 0 --是否已经认证手机号码
    self.m_ucCertificate = 0 --是否已经认证身份证号
    self.m_ucOnlineStatus = 0 --是否在线, 1: 在线, 0:　离线
end

function FriendVo:InitVo(vo)
	if vo then
		for k,v in pairs(vo) do
			self[k]=v
		end
	end
end

function FriendVo:UpdateVo(data)
	for k,v in pairs(data) do
		if type(v)~="function" and k~="_class_type" then
			if self[k] then
				self:SetValue(k,v,self[k])
			end
		end
	end
end

function FriendVo:SetValue(k,v,old)
	if self[k] ~=v then
		self[k]= v

		self:DispatchEvent(FriendModuleConst.EventName_UpdateFriendVo,{k,v,old})
		if k=="m_ucOnlineStatus" then
			local online=(v==1)
			LuaEvent:DispatchEvent(EventName.FRIEND_ONLINE,self.m_unUIN,online)
		end
	end
end

function FriendVo:__delete()
	self.m_unUIN = nil --用户的Uin
	self.m_unExperience = nil--用户的经验值
	self.m_unWalletMoney = nil --身上的钱
    self.m_ucSex = nil--性别, 1: 男, 0: 女
    self.m_ucImageNo = nil --头像编号
    self.m_szNickName = nil --昵称
    self.m_szSignature= nil --个性签名
    self.m_unVIPLevel = nil --VIP等级
    self.m_ucCertificateCellPhone = nil --是否已经认证手机号码
    self.m_ucCertificate = nil --是否已经认证身份证号
    self.m_ucOnlineStatus = nil --是否在线, 1: 在线, 0:　离线
end
