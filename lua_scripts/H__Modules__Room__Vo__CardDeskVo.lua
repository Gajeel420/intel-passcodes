CardDeskVo=CardDeskVo or BaseClass()

function CardDeskVo:__init( ... )
	self.DeskIndex=0 --桌子号
	self.mRoomCardsID = 0;--//进入的房间的card
	self.mRoomID = 0;--//房间id
	self.m_unUin=0
	self.m_usGameID=0
	self.m_usRoomID=0 --房间id
	self.m_usDeskIndex=0 --桌子索引
	self.m_usDeskStation=0--座位号
	self.usUserCount=0
	self.usGameNum = 0;		--// 已经结算过的次数  （当前游戏局数 - 1）
	self.usNumCount = 0;		--//游戏总局数
	-- self.uDeskPeople=0--每桌游戏人数 如4人桌之类
	self.unOwnerID=0 --桌主ID
	self.DeskUsers={} --桌子的玩家列表 --SUserBaseInfo
	self.isGameBegin=false
end

function CardDeskVo:InitVo( vo )
	if vo then 
		for k,v in pairs(vo) do
			self[k] = v
		end
	end
end

function CardDeskVo:UpdateVo( info )
	for k,v in pairs(info) do
		if type(v)~="function" and k~="_class_type" then
			if self[k] then
				self:SetValue(k,v,self[k])
			end
		end
	end
end

function CardDeskVo:RemovePlayer(uiUserID)
	local key=nil
	for k,playerVo in pairs(self.DeskUsers) do
		if playerVo~=nil then
			if playerVo.uiUserID == uiUserID then
				key=k
			end
		end
	end
	if key~=nil then
		self.DeskUsers[key]=nil
	end
end

function CardDeskVo:GetMyVo()
	for _,playerVo in pairs(self.DeskUsers) do
		if playerVo~=nil then
			if playerVo.uiUserID == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
				return playerVo
			end
		end
	end
	return nil
end

function CardDeskVo:SetValue(k,v,old)
	if self[k] ~=v then
		self[k]= v
	end
end

function CardDeskVo:__delete( ... )
	-- body
end