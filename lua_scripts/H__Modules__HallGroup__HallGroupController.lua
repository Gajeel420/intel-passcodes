HallGroupController = HallGroupController or BaseClass(LuaController)

require"H/Modules/HallGroup/HallGroupView"
require"H/Modules/HallGroup/HallGroupConst"
require"H/Modules/HallGroup/HallGroupModel"
require"H/Modules/HallGroup/View/HallGroupPanel"

function HallGroupController:__init( ... )
	self.model=HallGroupModel:GetInstance()
	self.view = HallGroupView.New()
	self:AddEvent()

end




function HallGroupController:AddEvent( ... )
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_OtherPlayerReqToMe,self.AddFriendNewMessagePrompt,self)
    LuaEvent:AddEventListener(EventName.CHAT_AddUserNewMessage,self.AddFriendNewMessagePrompt,self)
    LuaEvent:AddEventListener(EventName.CHAT_ReduceUserNewMessage,self.SubFriendNewMessagePrompt,self)
    LuaEvent:AddEventListener(EventName.FRIEND_OperationRequestToMeResult,self.SubFriendNewMessagePrompt,self)
    
end

function HallGroupController:RemoveEvent( ... )
	FriendModuleModel:GetInstance():RemoveEventListener(FriendModuleConst.EventName_OtherPlayerReqToMe,self.AddFriendNewMessagePrompt,self)
    LuaEvent:RemoveEventListener(EventName.CHAT_AddUserNewMessage,self.AddFriendNewMessagePrompt,self)
    LuaEvent:RemoveEventListener(EventName.FRIEND_OperationRequestToMeResult,self.SubFriendNewMessagePrompt,self)
    LuaEvent:RemoveEventListener(EventName.CHAT_ReduceUserNewMessage,self.SubFriendNewMessagePrompt,self)
    
end

function HallGroupController:AddFriendNewMessagePrompt( context )
	self.model:AddFriendNewMessagePrompt(1)
end

function HallGroupController:SubFriendNewMessagePrompt( context )
	self.model:SubFriendNewMessagePrompt(1)
end

function HallGroupController:GetInstance()
	if HallGroupController.instance == nil then
		HallGroupController.instance = HallGroupController.New()
	end
	return HallGroupController.instance
end

function HallGroupController:UpdataMailRedDot( context )
	-- body
	if not context then return end
	local num=context[1]
	--self.model:DispatchEvent(HallGroupConst.EventName_MailUnreadPrompt,{num>0})
	self.view.panel:SetMailRedPoint(num > 0)
end



function HallGroupController:__delete( ... )
	self:RemoveEvent()
	HallGroupController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end