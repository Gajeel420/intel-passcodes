CardRoomVo=CardRoomVo or BaseClass()

function CardRoomVo:__init( ... )
	self.mRoomCardsID = 0;--//进入的房间的card
	self.mRoomType = 0;--//房间类型 //0: 普通房间, 1: 公会房间，2：表示为金币场
	self.mClientGameID = 0;--//游戏id 类似 10900500
	self.mServerGameID = 0;--//服务器端游戏id
	self.mRoomID = 0;--//房间id
	self.mDeskIndex = 0;			--// 桌子索引
	self.mDeskStation = 0;             --//座位号 
	self.mDeskPeople = 0;--//桌子人数 如 4 6 8
	self.mRoomLevel = 0;--//房间等级
	self.mRoomName = "";--//房间名称
	self.unOwnerID = 0;			--//房主id
    self.unCreateTime = 0;		--//创建时间
    self.unEndTime = 0;			--//到期时间
    self.usGameID = 0;			--//服务器游戏id（123） 金币玩法 房卡玩法
    self.usGameNum = 0;		--// 已经结算过的次数  （当前游戏局数 - 1）
    self.usNumCount = 0;		--//游戏总局数
    self.usCardNum = 0;			--//消耗的房卡数
    self.usUserCount = 0;		--//人数（最大值）
    self.usGameRoomID = 0;	--//gamedb分配的游戏房间id  金币玩法 房卡玩法
    self.unPlayStyle = 0;			--//玩法，按位bitmap
    self.unOpt1 = 0;				--//选项1，按位
    self.unOpt2 = 0;				--//选项2，按位bitmap
    self.unOpt3 = 0;				--//选项3，按位bitmap
    self.unOpt4 = 0;				--//选项4，按位bitmap
    self.szOpt = {};		--//附加选项，可以存储xml或者json，客户端和游戏自定义。
    self.deskLists={}  --桌子列表
end

function CardRoomVo:InitVo( vo )
	if vo then 
		for k,v in pairs(vo) do
			self[k] = v
		end
	end
end

function CardRoomVo:UpdateVo( info )
	for k,v in pairs(info) do
		if type(v)~="function" and k~="_class_type" then
			if self[k] then
				self:SetValue(k,v,self[k])
			end
		end
	end
end

function CardRoomVo:SetValue(k,v,old)
	if self[k] ~=v then
		self[k]= v
	end
end

function CardRoomVo:AddDesk(index,deskVo)
	self.deskLists[index]=deskVo
end

function CardRoomVo:GetDesk( index )
	if index==nil then return nil end
	return self.deskLists[index]
end

function CardRoomVo:__delete( ... )
	-- body
end