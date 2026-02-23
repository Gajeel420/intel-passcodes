FriendModuleModel=FriendModuleModel or BaseClass(LuaModel)

function FriendModuleModel:__init( ... )
	self.m_listMyFriends={}--原始数据，用户id做key
	self.m_listReqFriends={}--请求好友列表,等待对方相应
	self.m_listReqToMeFriends={}--向我请求好友的用户列表
	-- self.m_listMyFriendsSort={} --排序好的 1开始
	self.m_nReqFriendCount=0
	self.m_nReqFriendListIndex=0
	self.m_nReqCounter=0--向服务器
end
--登陆时候获取的好友列表
function FriendModuleModel:InitFirendList(friendList)
	if friendList then
		for k,user in pairs(friendList) do
			vo=FriendVo.New()
			vo:InitVo(user)
			self.m_listMyFriends[user.m_unUIN]=vo
		end
	end
end

--添加一个好友，暂时没有删除好友功能
function FriendModuleModel:AddFriend(user)
	if not user then return end
	vo=FriendVo.New()
	vo:InitVo(user)
	self.m_listMyFriends[user.m_unUIN]=vo
	self:DispatchEvent(FriendModuleConst.EventName_AddFriend,vo)
end

function FriendModuleModel:AddReqToMePlayer(user)
	if not user then return end
	if not self.m_listReqToMeFriends then
		self.m_listReqToMeFriends={}
	end
	local vo=self.m_listReqToMeFriends[user.m_unUIN]
	if vo then
		-- vo:UpdateVo(user)
	else
		vo=FriendVo.New()
		vo:InitVo(user)
		self.m_listReqToMeFriends[user.m_unUIN]=vo
		self:DispatchEvent(FriendModuleConst.EventName_OtherPlayerReqToMe,vo)
	end
end

function FriendModuleModel:RemoveReqToMePlayer(uid)
	if uid then
		if self.m_listReqToMeFriends[uid] then
			self.m_listReqToMeFriends[uid]=nil 
			self:DispatchEvent(FriendModuleConst.EventName_RemovePlayerReqToMe,uid)
		end
	end
end

function FriendModuleModel:AddReqFriendList(uid )
	if uid then
		self.m_listReqFriends[uid]=uid
		self:DispatchEvent(FriendModuleConst.EventName_ReqFriendsCallBack,uid)
	end
end

function FriendModuleModel:RemoveReqFriendList(uid )
	if uid then
		if self.m_listReqFriends[uid] then
			self.m_listReqFriends[uid]=nil
			self:DispatchEvent(FriendModuleConst.EventName_RemoveReqFriendList,uid)
		end
	end
end

function FriendModuleModel:GetFriendTotalNum()
	local nNum=0
	if self.m_listMyFriends then
		for k,v in pairs(self.m_listMyFriends) do
			nNum=nNum+1
		end
	end
	return nNum
end

function FriendModuleModel:GetFriendById(userID)
	local vo=nil
	if self.m_listMyFriends then
		vo=self.m_listMyFriends[userID or 0]
	end

	return vo
end

function FriendModuleModel:GetPlayerInfoByUID(uid)
	uid=uid or 0
	if self.m_listMyFriends[uid] then
		return self.m_listMyFriends[uid]
	end
	return nil
end

-- function FriendModuleModel:SortFriendList()
-- 	self.m_listMyFriendsSort={}
-- 	if self.m_listMyFriends then
-- 		for k,v in pairs(self.m_listMyFriends) do
-- 			table.insert(self.m_listMyFriendsSort,v)
-- 		end
-- 		TableTool.SortTableByKey(self.m_listMyFriendsSort,"m_ucOnlineStatus",false)
-- 	end
-- end

function FriendModuleModel:GetUserRelationType(uid)
	local me=PlayerInfoController:GetInstance().model.mainPlayer 
	if me.uiUserID==uid then
		return HallDefine.UserRelationType.Self
	end
	if self.m_listMyFriends[uid] then
		return HallDefine.UserRelationType.Friend
	end
	if self.m_listReqFriends[uid] then
		return HallDefine.UserRelationType.TempToFriend
	end
	return HallDefine.UserRelationType.Stranger
end

function FriendModuleModel:ClearData()
	if self.m_listMyFriends then
		for k,v in pairs(self.m_listMyFriends) do
			v:Destroy()
		end
	end
	self.m_listMyFriends={}--原始数据，用户id做key
	if self.m_listReqFriends then
		for k,v in pairs(self.m_listReqFriends) do
			v=nil
		end
	end
	self.m_listReqFriends={}--请求好友列表,等待对方相应
	if self.m_listReqToMeFriends then
		for k,v in pairs(self.m_listReqToMeFriends) do
			v:Destroy()
		end
	end
	self.m_listReqToMeFriends={}--向我请求好友的用户列表
	self.m_nReqFriendCount=0
	self.m_nReqFriendListIndex=0
	self.m_nReqCounter=0--向服务器
	self:DispatchEvent(FriendModuleConst.EventName_OnDestroyFriendModel)
end

function FriendModuleModel:GetInstance( ... )
	if FriendModuleModel.instance==nil then
		FriendModuleModel.instance=FriendModuleModel.New()
	end
	return FriendModuleModel.instance
end

function FriendModuleModel:__delete( ... )
	--广播好友数据被销毁
	self:DispatchEvent(FriendModuleConst.EventName_OnDestroyFriendModel)
	if self.m_listMyFriends then
		for k,v in pairs(self.m_listMyFriends) do
			v:Destroy()
		end
	end
	self.m_listMyFriends=nil--原始数据，用户id做key
	if self.m_listReqFriends then
		for k,v in pairs(self.m_listReqFriends) do
			v=nil
		end
	end
	self.m_listReqFriends=nil--请求好友列表,等待对方相应
	if self.m_listReqToMeFriends then
		for k,v in pairs(self.m_listReqToMeFriends) do
			v:Destroy()
		end
	end
	self.m_listReqToMeFriends=nil--向我请求好友的用户列表
	self.m_nReqFriendCount=nil
	self.m_nReqFriendListIndex=nil
	self.m_nReqCounter=nil--向服务器
	FriendModuleModel.instance=nil
end
