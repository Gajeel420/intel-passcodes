PlayerInfoModel = PlayerInfoModel or BaseClass(LuaModel)

function PlayerInfoModel:__init( ... )
	self.mainPlayer = nil
	self.mFriendList = {}  --//好友列表   TUserInfo
	self.mTempFriendList = {} --//加好友列表 int
	self.mCRspEnterGameMsgPara = {}  --房卡项目保存信息
end

function PlayerInfoModel:__delete( ... )
	-- body
end