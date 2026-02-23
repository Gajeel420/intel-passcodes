GoldRoomVo=GoldRoomVo or BaseClass()

function GoldRoomVo:__init( ... )
	self.uRoomID=0 --游戏房间 ID 号码
	self.iRoomType=0 --房间类型
	self.iRoomLevel=0-- 房间等级 sean.yang
	self.uDeskCount=0 --游戏大厅桌子数目
	self.uDeskPeople=0--每桌游戏人数 如4人桌之类
	self.iBasePoint=0 --倍率
	self.iLessPoint=0 --底分	
	self.iMoneyPoint=0--
	self.szGameRoomName="" --游戏房间名称
	self.uNameID=0  --游戏名称 ID 号码  客户端游戏id（10306600）
	self.bDstFE=0  --目标服务器 //游戏id 服务器id 如123
	self.uRoomIndex=0 
	-- self.m_nLevelID=0; --//等级ID
	self.m_unMinMoney=0;--//最少带入金额
	self.m_unMaxMoney=0;--//最大带入金额
	self.m_unStartCoins=0; --//体验场带入金币
	self.m_nFlag=0;--//标志，是体验场还是普通场 1是体验场 0是普通场
	self.m_usGameID=0

	self.deskLists={}  --桌子列表
end

function GoldRoomVo:InitVo( vo )
	if vo then 
		for k,v in pairs(vo) do
			self[k] = v
		end
	end
end

function GoldRoomVo:UpdateVo( info )
	for k,v in pairs(info) do
		if type(v)~="function" and k~="_class_type" then
			if self[k] then
				self:SetValue(k,v,self[k])
			end
		end
	end
end

function GoldRoomVo:SetValue(k,v,old)
	if self[k] ~=v then
		self[k]= v
	end
end

function GoldRoomVo:AddDesk(index,deskVo)
	self.deskLists[index]=deskVo
end

function GoldRoomVo:GetDesk( index )
	if index==nil then return nil end
	return self.deskLists[index]
end

function GoldRoomVo:__delete( ... )
	-- body
end