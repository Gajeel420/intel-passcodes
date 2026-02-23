FriendModuleController=FriendModuleController or BaseClass(LuaController)

require"H/BaseModules/FriendModule/FriendModuleModel"
require"H/BaseModules/FriendModule/FriendModuleConst"
require"H/BaseModules/FriendModule/Vo/FriendVo"
require"H/BaseModules/FriendModule/Msg/CRspFriendListMsgPara"
require"H/BaseModules/FriendModule/Msg/CRspFuzzyQueryUserInfo"
require"H/BaseModules/FriendModule/Msg/CRspMakeSureFriend"
require"H/BaseModules/FriendModule/Msg/CRspNotifyMakeFriendResult"

function FriendModuleController:__init( ... )
	self.model=FriendModuleModel:GetInstance()
	self:AddEvent()
	self:RegistProto()
	self.listFriendTmp={} --临时装入所有好友的
end

function FriendModuleController:RegistProto()
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_FRIEND_OFFLINE,"NotifyFriendOffLine")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_FRIEND_ONLINE,"NotifyFriendOnLine")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_FUZZY_QUERY_USER_INFO,"RspSearchFriend")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_FRIEND,"ResFriendOperation")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_FRIEND,"ResFriendList")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_SURE_FRIEND,"ResMakeSureFriend")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_FRIEND_NOTIFY,"ResNotifyMakeFriendResult")
end

function FriendModuleController:RemoveProto( ... )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_FRIEND_OFFLINE,"NotifyFriendOffLine")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_CLIENT_FRIEND_ONLINE,"NotifyFriendOnLine")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_FUZZY_QUERY_USER_INFO,"RspSearchFriend")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_FRIEND,"ResFriendOperation")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_FRIEND,"ResFriendList")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_SURE_FRIEND,"ResMakeSureFriend")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_FRIEND_NOTIFY,"ResNotifyMakeFriendResult")
end

function FriendModuleController:AddEvent( ... )
	-- LuaEvent:AddEventListener(EventName.INITMAINPLAYERCOMPELED,self.BeginReqContact,self)
end

function FriendModuleController:RemoveEvent( ... )
	-- LuaEvent:RemoveEventListener(EventName.INITMAINPLAYERCOMPELED,self.BeginReqContact,self)
end

--好友下线
function FriendModuleController:NotifyFriendOffLine(buffer)
	local msg=self:ParseMsg(NetworkDefine.CReqNotifyFriendOffline,buffer)
	local vo={}
	user=self.model:GetPlayerInfoByUID(msg.m_unOfflineFriendUIN)
	vo.m_ucOnlineStatus=0
	if user then
		user:UpdateVo(vo)
	end
end

--好友上线
function FriendModuleController:NotifyFriendOnLine(buffer)
	local msg=self:ParseMsg(NetworkDefine.CReqNotifyFriendOffline,buffer)
	local vo={}
	user=self.model:GetPlayerInfoByUID(msg.m_unOfflineFriendUIN)
	vo.m_ucOnlineStatus=1
	if user then
		user:UpdateVo(vo)
	end
end

 -- 开始请求通讯录
function FriendModuleController:BeginReqContact()
	self.model.m_nReqFriendListIndex = 1
	self.model.m_nReqFriendCount=0
	local nPlayerID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	local nIndex=self.model.m_nReqFriendListIndex
	local nCount=HallDefine.ConstDefine.MAX_UIN_LIST_NUM
	self:ReqFriendList(nPlayerID,nIndex,nCount)
end

function FriendModuleController:ReqFriendList(playerID,index,count)
	local send={}
	send.m_unUIN=playerID or 0
	send.m_usIndex=index or 0
	send.m_usCount=count or 0
	Net_SendHallData(NetworkDefine.CReqFriendListMsgPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_FRIEND,0)
end
-- m_unQueryType;                      //模糊查询类型
-- m_szQueryCondition = new byte[ComDef.E_MAX_NICK_LEN]; //模拟查询条件
-- m_unPageIndex;                      //第几页, 从第1页开始
-- m_unPageSize;                       //页大小
function FriendModuleController:ReqSearchFriend(unQueryType,searchKey,unPageIndex,unPageSize)
	local send={}
	send.m_unQueryType=unQueryType or 0
	local tmpBytes=CommonUtil.StringToByteArrayTable(searchKey or " ")
	send.m_szQueryCondition={}
	--补齐长度
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		send.m_szQueryCondition[i]=tmpBytes[i] or 0
	end
	send.m_unPageIndex=unPageIndex or 0
	send.m_unPageSize=unPageSize or 0
	Net_SendHallData(NetworkDefine.CReqFuzzyQueryUserInfo,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_FUZZY_QUERY_USER_INFO,13)
end

function FriendModuleController:RspSearchFriend( buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg=CRspFuzzyQueryUserInfo.Decode(buffer)
	if msg.m_sResultId == 0 then
		if not next(msg.m_UserList) then 
			UIManager:GetInstance():ShowNoteMessage("查无此人");
			self.model:DispatchEvent(FriendModuleConst.EventName_QueryPlayerCallBack,nil)
		else
			if msg.m_UserList[1].m_unUIN==PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
			UIManager:GetInstance():ShowNoteMessage("Can_Not_Add_Friend_Self");
			else
				self.model:DispatchEvent(FriendModuleConst.EventName_QueryPlayerCallBack,msg.m_UserList[1])
			end
		end 
	else
		ServerBackPrompt(msg.m_sResultId);
	end
end

function FriendModuleController:ResFriendList(buffer)
	local msg=CRspFriendListMsgPara.Decode(buffer)
	if msg.m_sResultId==0 then
		self.model.m_nReqFriendCount=msg.m_usThisReturnNum+self.model.m_nReqFriendCount
		local isFinish=false
		if self.model.m_nReqFriendCount<msg.m_usTotalFriendNum then
			local nPlayerID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
			self.model.m_nReqFriendListIndex=self.model.m_nReqFriendListIndex+1
			local nIndex=self.model.m_nReqFriendListIndex
			local nCount=HallDefine.ConstDefine.MAX_UIN_LIST_NUM
			self:ReqFriendList(nPlayerID,nIndex,nCount)
		else
			isFinish=true
		end
		for i,v in ipairs(msg.m_FriendInfoList) do
			table.insert(self.listFriendTmp,v)
		end
		if isFinish then
			self.model:InitFirendList(self.listFriendTmp)
			-- self.model:SortFriendList()
			--刷新一下排行榜的好友关系
			LuaEvent:DispatchEvent(EventName.FRIEND_FriendListReceiveCompleted,{self.model.m_listMyFriends})
			self.model:DispatchEvent(FriendModuleConst.EventName_InitFriendList,self.model.m_listMyFriends)
		end
	else
		ServerBackPrompt(msg.m_sResultId)
	end
end
-- 请求添加删除好友
function FriendModuleController:ReqFriendOperation(srcUIN,dstUIN,opType)
	local send={}
	send.m_unSrcUIN=srcUIN or 0
	send.m_unDstUIN=dstUIN or 0
	send.m_unTime=os.time()
	send.m_ucType=opType or 0
	Net_SendHallData(NetworkDefine.CReqAddFriendMsgPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_FRIEND,13)
end

function FriendModuleController:ResFriendOperation(buffer )
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
	local msg=self:ParseMsg(NetworkDefine.CRspAddFriendMsgPara,buffer)
	if msg.m_sResultId==0 then
	elseif msg.m_sResultId==1 then
		-- 添加好友等待对方确认中
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("HavaAddFriends"))
		self.model:AddReqFriendList(msg.m_unDstUIN)
	elseif msg.m_sResultId==3 then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("System_Error"))
	elseif msg.m_sResultId==4 then
		UIManager:GetInstance():ShowNoteMessage("Can_Not_Add_Friend_Self")
	elseif msg.m_sResultId==5 then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Have_Be_Friend"))
	end
end

function FriendModuleController:ReqMakeSureFriend(unRequestUIN,unResponseUIN,ucReply)
	local send={}
	send.m_unRequestUIN=unRequestUIN
	send.m_unResponseUIN=unResponseUIN
	send.m_ucReply=ucReply
	Net_SendHallData(NetworkDefine.CReqMakeSureFriend,send,1,NetworkDefine.E_MSG_ID.MSG_ID_CS_MAKE_SURE_FRIEND,13)
end
--有人向我请求添加好友
function FriendModuleController:ResMakeSureFriend( buffer )
	local msg=CRspMakeSureFriend.Decode(buffer)
	if msg then
		self.model:AddReqToMePlayer(msg)
	end
end

--好友添加结果返回
function FriendModuleController:ResNotifyMakeFriendResult( buffer )
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
	local msg=CRspNotifyMakeFriendResult.Decode(buffer)
	if msg.m_sResultId==0 then
		self.model:AddFriend(msg.m_stOppositeUserInfo)--添加一个好友
		if msg.m_ucYourRole==1 then

		elseif msg.m_ucYourRole==2 then--1: 你是主动发起方 //2: 你是被添加方
			self.model:RemoveReqToMePlayer(msg.m_stOppositeUserInfo.m_unUIN )--从申请列表删除
			print("添加成功")
		end
	elseif msg.m_sResultId==2 then
		-- 对方拒绝被添加
		if msg.m_ucYourRole==1 then --1: 你是主动发起方 //2: 你是被添加方
			self.model:RemoveReqFriendList(msg.m_stOppositeUserInfo.m_unUIN)
		elseif msg.m_ucYourRole==2 then
			self.model:RemoveReqToMePlayer(msg.m_stOppositeUserInfo.m_unUIN )
		end
	end
end

function FriendModuleController:ClearData()
	self.listFriendTmp={}
	self.model:ClearData()
end

function FriendModuleController:GetInstance()
	if FriendModuleController.instance==nil then
		FriendModuleController.instance=FriendModuleController.New()
	end
	return FriendModuleController.instance
end

function FriendModuleController:__delete( ... )
	self:RemoveProto()
	self:RemoveEvent()
	self.model:Destroy()
	self.model=nil
	self.listFriendTmp={} --临时装入所有好友的
	FriendModuleController.instance=nil
end