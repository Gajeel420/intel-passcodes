HallGroupModel=HallGroupModel or BaseClass(LuaModel)

function HallGroupModel:__init( ... )
	self.m_nFriendNewMessageNum=0 --接受到的通知数量，这个数量为0的时候表示不需要显示红点
end

function HallGroupModel:AddFriendNewMessagePrompt(num)
	self.m_nFriendNewMessageNum=self.m_nFriendNewMessageNum+num
	if self.m_nFriendNewMessageNum>0 then
		self:DispatchEvent(HallGroupConst.EventName_FriendNewMessagePrompt,{true})
	end
end

function HallGroupModel:SubFriendNewMessagePrompt(num)
	self.m_nFriendNewMessageNum=self.m_nFriendNewMessageNum-num
	if self.m_nFriendNewMessageNum<=0 then
		self:DispatchEvent(HallGroupConst.EventName_FriendNewMessagePrompt,{false})
	end
end

function HallGroupModel:AddMailNewMessagePrompt()
	-- body
end

function HallGroupModel:SubMailNewMessagePrompt()
	-- body
end

HallGroupModel.BuildSuccessType=
{
	Nomar = 1,
	ExchangeButton = 2,
	GiveButton = 3,
}

function HallGroupModel:GetInstance( ... )
	if not HallGroupModel.instance then
		HallGroupModel.instance=HallGroupModel.New()
	end
	return HallGroupModel.instance
end

function HallGroupModel:__delete( ... )
	-- body
end