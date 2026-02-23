RoomController = RoomController or BaseClass(LuaController)

require"H/Modules/Room/RoomModel"
require"H/Modules/Room/RoomConst"
require"H/Modules/Room/GoldRoomView"
require"H/Modules/Room/GoldRoomViewCS"
require"H/Modules/Room/GoldRoomViewXLua"
require"H/Modules/Room/CardRoomView"
require"H/Modules/Room/Vo/GoldDeskVo"
require"H/Modules/Room/Vo/CardDeskVo"
require"H/Modules/Room/Vo/GoldRoomVo"
require"H/Modules/Room/Vo/CardRoomVo"
require"H/Modules/Room/Vo/DirectToGameVo"
require"H/Modules/Room/View/GoldDeskView"
require"H/Modules/Room/GoldNewRoomView"


function RoomController:__init( ... )
	self.model = RoomModel:GetInstance()
	self.view=nil
	self:RegistProto()
	self:AddEvent()
	self.mIsNeedShowNetMessage = false
	self.mLastRequeryEntergameTime = 0		-- 最后请求游戏房间列表的时间
	self.mBool_IsShowNetWorkMessage=false
	self.mBool_IsNeedDispatchEnterRoomEvent=false
	self.mFunction_InstallOrUpdateGameCallBack=nil
	self.mBool_EnterRoomSuccesss=false
	self.GameCallBack = nil     --供游戏内请求换桌成功后回调执行
	self.CanRequest = true
	
end

function RoomController:AddEvent( ... )
	-- LuaEvent:AddEventListener(EventName.NOTICE_DOWN,self.ShowMessageBox,self)
	-- LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	LuaEvent:AddEventListener(EventName.CSQuitGame,self.CSReqQuitGame,self)
	LuaEvent:AddEventListener(EventName.ReqUserCheckOutGameCoin,self.CSReqUserCheckOutGameCoin,self)
	LuaEvent:AddEventListener(EventName.SetGameStateCompeleted,self.GameStateCompeleted,self)
end

function RoomController:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.NOTICE_DOWN,self.ShowMessageBox,self)
	LuaEvent:RemoveEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self);
	LuaEvent:RemoveEventListener(EventName.CSQuitGame,self.CSReqQuitGame,self)
	LuaEvent:RemoveEventListener(EventName.ReqUserCheckOutGameCoin,self.CSReqUserCheckOutGameCoin,self)
	LuaEvent:RemoveEventListener(EventName.SetGameStateCompeleted,self.GameStateCompeleted,self)
end

--[[ 进游戏流程  --旧流程
1.检测是否存在选定游戏的房间列表,如果不存在则请求房间等级信息列表：ReqGetRoomLevel

2.请求房间等级信息列表返回，并缓存在本地，然后接着请求房间列表：RspHandlerGameLevel

3.请求房间列表返回，如果存在当前房间，则断线重连，如果不存在，则本地缓存房间列表，
	然后判断是否只有一个房间，如果只有一个房间则直接进入游戏，如果存在多个房间则打开RoomPnael,：RspHandlerRoomList

4.使用房间id，默认座位号0，请求自动搓桌，：RoomModel:OnEnterRoom

5.请求自动挫桌返回，返回玩家自己的桌子编号和座位标号，然后请求房间其他用户信息（此处只请求一个桌子的用户信息，房间可能存在多个桌子）：RspUserEnterGame

6.请求桌子用户信息（包括自己）返回，初始化桌子类并缓存于本地，使用桌子信息请求启动游戏：RsqDeskPlayerList

7.拉起游戏资源并使用桌子信息初始化游戏：EnterGame


进游戏流程--]]




--[[新进入游戏流程

1.检测是否存在选定游戏的房间列表,如果不存在则请求房间等级信息列表：ReqGetRoomLevel

2.请求房间等级信息列表返回，并缓存在本地，然后接着请求房间列表：RspHandlerGameLevel

3.请求房间列表返回，如果存在当前房间，则断线重连，如果不存在，则本地缓存房间列表，打开RoomPnael,：RspHandlerRoomList

4.在特定的RoomView中请求桌子用户信息，并监听桌子信息返回事件和用户进出房间事件

5.请求桌子用户信息（包括自己）返回，初始化桌子类并缓存于本地，并触发桌子信息返回事件：RsqDeskPlayerList

6.RoomView响应桌子返回事件并初始化桌子，响应用户进出房间事件并更新桌子

7.玩家点击座位，发送手动搓桌协议请求进入桌子坐下

8.拉起游戏资源并使用桌子信息初始化游戏：EnterGame

--]]


function RoomController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_CREATEROOM,"RspCreateRoom")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_ROOMCARD,"RspGetGameCard")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_CHECK_GAME_STATE,"RspCheckUserPlaying")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_RoomLevel,"RspHandlerGameLevel") --金币场的房间等级（房间列表）
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_GAME_INFO,"Test1RspUserEnterGame") --请求进入游戏 6号消息 二代，房卡
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGIN_ROOMList,"RspHandlerRoomList") --返回房间列表
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_DESKLIST,"RsqDeskPlayerList") --返回桌子的玩家列表
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_DESKLIST_RSP_EXT,"RsqDeskPlayerListNew") --返回桌子的玩家列表
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_RUB_TABLE,"Test2RspUserEnterGame")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_OTHERPLAYER_ENTERROOM,"RspPlayerEnterRoom")--玩家进入游戏通知--CRspOtherPlayerEnterRoom
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_OTHERPLAYER_LEAVEROOM,"RspPlayerLeaveRoom")--玩家离开游戏通知--CRspOtherPlayerLeaveRoom
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_SS_GAME_LOGOUT,"RspLeaveGameMsg")--退出游戏用 7号消息 二代，房卡
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_Dissolve_Card_Room,"RspDeleteGameCard")--解散房间房卡
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_BROCAST_DISSOLVE_CARD_ROOM,"ReceiveDissolveRoomBrocast")--解散房间广播
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_BROCAST_GAME_USER_AGARE_GAME,"ReceiveGameUserAgreeBrocast")--广播用户同意操作
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_BROCAST_GAME_USER_AGREE_GAME,"RspUserAgreeGame")--响应解散房间选择
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_USER_TOTAL_SCORE,"RspGetUserTotalScore")--房卡汇总结算
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_CHECKOUT_GAME_COIN,"SRspUserCheckOutGameCoin") ---上分返回
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGOUT_DESK_4_AUTO_JOIN,"RspChangeLogoutDesk") ---请求换桌
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_GPS,"RespGameLocationList")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_SS_GAME_BROD_USER_INFO,"RespBrodUserInfo")
end

----------------------------房卡
--请求创建房间
function RoomController:ReqCreateRoom2(msg)
	local send = {}
	send.m_usMsgLen = 0
	send.m_stCardInfo = msg
	Net_SendHallData(NetworkDefine.CReqCreateGameCard2,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_MNG_COIN_CREATECARD,0)
end

--请求创建房间返回
function RoomController:RspCreateRoom(buffer)
	print("创建房间返回")
	local msg = self:ParseMsg(NetworkDefine.CRspCreateGameCard,buffer)
	if msg.m_sResultID == 0 or msg.m_sResultID == -135 then
		print("创建房间 cardID ::",msg.m_unCardID," ::roomID:: ",msg.m_usRoomID)
		UIManager:GetInstance():ShowNetWorkMessage("Enter_Rooming","EnterRoomOverTime",8)
		local CReqGetGameCard = {}
		CReqGetGameCard.m_usMsgLen=0
		CReqGetGameCard.m_unUin =  PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
		CReqGetGameCard.m_unCardID = msg.m_unCardID
		self:ReqGetGameCard(CReqGetGameCard)
	else
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		end
		ServerBackPrompt(msg.m_sResultID)
	end
end

function RoomController:RspGetGameCard(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRspGetGameCard,buffer)
	print("查询房间返回msg.m_sResultID",msg.m_sResultID)
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.JoinRoom) then
		JoinRoomController:GetInstance():ReqJoinBack()
	end

	if msg.m_sResultID == 0 then
		local room=CardRoomVo.New()
		local vo={}
		vo.mRoomCardsID = msg.m_unCardID;--//进入的房卡号
		vo.mRoomType = msg.m_unType;--//房间类型
		vo.mClientGameID = gameID --客户端游戏id
		vo.mServerGameID = msg.m_stCardInfo.usGameID --服务器端游戏id
		vo.mRoomID = msg.m_stCardInfo.usGameRoomID --房间id
		vo.mDeskPeople = msg.m_stCardInfo.usUserCount --房间人数
		room:InitVo(vo)
		room:UpdateVo(msg.m_stCardInfo)
		PlayerInfoController:GetInstance().model.mainPlayer.uPlayerScore = msg.m_unScore
		local gameID = ConfigModuleModel:GetInstance():GameIDChange(msg.m_stCardInfo.usGameID)--//游戏ID
		-- //如果房间房主是自己的情况下处理，一般是在创建房间的时候执行 刷新自己的卡房号码
		if msg.m_stCardInfo.unOwnerID == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
			if msg.m_unCardID ~= PlayerInfoController:GetInstance().model.mainPlayer.iTransTax then
				PlayerInfoController:GetInstance().model.mainPlayer.iTransTax = msg.m_unCardID
			end
		end
		PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID=msg.m_stCardInfo.usGameRoomID--玩家请求的房间id
		self.model:AddCardRoom(msg.m_stCardInfo.usGameRoomID,room)
		if ConfigInfoMgr.useHotFunction == true then
			-- self:JoinRoomCheckGameInstall(gameID,function()  --检测游戏是否需要下载

				self:JoinRoomCheckGameInstallCB()
			-- end)
		else
			self:JoinRoomCheckGameInstallCB()
		end
	else
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		-- 加入自己创建的房间失败时候处理
		local b1=msg.m_stCardInfo.unOwnerID == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
		local b2=msg.m_unCardID == PlayerInfoController:GetInstance().model.mainPlayer.iTransTax
		if b1 or b2 then
			if msg.m_sResultID==-111 or msg.m_usResultID==-113 then--卡房不存在 或者 卡房已经过期
			 	PlayerInfoController:GetInstance().model.mainPlayer.iTransTax=0
			end
		end
		-- 游戏中断线流程
		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
			-- 系统房间不足 或者 房间位置已满 或者 房间已经过期
			if msg.m_sResultID == -111 or msg.m_sResultID == -112 or msg.m_sResultID == -113 then
				if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.GameResult) then
					print("已经显示游戏汇总结算，无需再提示去结算")
				else
					local showBoxData={}
					showBoxData.title = StringFormatByLanguage("Prompt")
	                showBoxData.message = StringFormatByLanguage("RoomNoExistIsResult")
	                showBoxData.buttonYesName = StringFormatByLanguage("ViewSummary")
	                showBoxData.buttonNoName = StringFormatByLanguage("Cancel")
	                showBoxData.isHideAllButton = false
	                showBoxData.isShowNo = false
	                showBoxData.isRotate = false
	                showBoxData.actionYes = function( )
	                	self:ResultRoomCard()
	                end
	                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
				end
			elseif msg.m_sResultID == -114 then--//获取积分失败
				local showBoxData={}
				showBoxData.title = StringFormatByLanguage("Prompt")
                showBoxData.message = StringFormatByLanguage("ReEnterGameFailIsTryEnter")
                showBoxData.buttonYesName = StringFormatByLanguage("Sure")
                showBoxData.buttonNoName = StringFormatByLanguage("ViewSummary")
                showBoxData.isHideAllButton = false
                showBoxData.isShowNo = true
                showBoxData.isRotate = false
                showBoxData.actionYes = function( )
                	error("断线重联进入游戏失败，重新查询房卡 ")
                	local CReqGetGameCard={}
                	CReqGetGameCard.m_unUin =  PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
					CReqGetGameCard.m_unCardID = self.model.mRoomCardInfo.mRoomCardsID
                	self:ReqGetGameCard(CReqGetGameCard)
                end
                showBoxData.actionNo = function( )
                	error("断线重联进入游戏失败，查看汇总成绩 ")
                	self:ResultRoomCard()
                end
                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
            elseif msg.m_sResultID == -137 then--//房间不存在
            	-- 等待结算或者结算中，不需要提示
            	error("断线重联查询房间，房间不存在 ")
            	-- self.model:ClearRoomModel()
			end
		else
			ServerBackPrompt(msg.m_sResultID)
		end
	end
end

--查询房卡ID
function RoomController:ReqGetGameCard(CReqGetGameCard)
	local send = {}
	send.m_unUin = CReqGetGameCard.m_unUin
    send.m_unCardID = CReqGetGameCard.m_unCardID
    send.m_usMsgLen = 0
	Net_SendHallData(NetworkDefine.CReqGetGameCard,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_ROOMCARD,0)
end

function RoomController:JoinRoomCheckGameInstall(gameID,cb)
	self.downCB = cb
	-- LuaEvent:RemoveEventListener(EventName.NOTICE_DOWN,self.ShowMessageBox,self)
	-- LuaEvent:AddEventListener(EventName.NOTICE_DOWN,self.ShowMessageBox,self)
	-- LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	--DownLoadManager:StartCheckResourceUpdata(gameID)
end

--房卡
function RoomController:JoinRoomCheckGameInstallCB() --ReqChooseDeskEnterGame  房卡
	local roomID=PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID--玩家请求的房间id
	local room=self.model:GetCardRoom(roomID)
	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
	send.m_usGameID=room.usGameID or 0
	send.m_usRoomID=room.mRoomID  or 0
	send.m_usDeskIndex=Mathf.Floor(room.mRoomCardsID/65536) or 0
	send.m_bDeskStation=room.mRoomCardsID%65536 or 0
	send.m_iMoney=10000
	send.m_bFlag=0
	send.m_szNickName= {}
	--print("进入游戏 == ".." 积分 == "..send.m_iMoney.." deskIndex == "..send.m_usDeskIndex.." deskStation == "..send.m_bDeskStation);
	--保证长度，
	local tmp=CommonUtil.StringToByteArrayTable(PlayerInfoController:GetInstance().model.mainPlayer.szNickName or "")
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		send.m_szNickName[i] = tmp[i] or 0
	end
	if PlayerInfoController:GetInstance().model.mainPlayer.bBoy then
		send.m_usSex=0
	else
		send.m_usSex=1
	end
	-- 游戏中断线流程
	if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
	
	else
		UIManager:GetInstance():ShowNetWorkMessage("Enter_Rooming","EnterRoomOverTime",12)
	end
--	self:ReqChooseDeskEnterGame(send)
end

function RoomController:RspCheckUserPlaying( buffer )
	local msgpaa=self:ParseMsg(NetworkDefine.CRspCheckUserPlayingMsgPara,buffer)
	--print("查询游戏状态 : ",msgpaa.m_sResult,"   游戏状态:",msgpaa.m_usIsPlaying)
	--print("uin : ",msgpaa.m_unUin," gameid ",msgpaa.m_unGameID," roomid ",msgpaa.m_unRoomID," deskid ",msgpaa.m_unDeskIndex," deskstation ",msgpaa.m_usDeskStation)
	if msgpaa.m_sResult == 0 then
		LoginPanelController.GetInstance().NeedCheckGameSate = false
		if msgpaa.m_unUin==PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
			local clientGameID=ConfigModuleModel:GetInstance():GameIDChange(msgpaa.m_unGameID)
			if msgpaa.m_usIsPlaying == 1 or msgpaa.m_usIsPlaying == 2 then--//1 游戏中 2 在房间里面但没有在游戏
				if ConfigInfoMgr.Platform_Type~=4 then
					print("查询玩家状态 加入游戏 id",clientGameID)
					local mGoldGameConfig=ConfigModuleModel.GetInstance():GetGameConfigByCID(clientGameID)
					if mGoldGameConfig~=nil then
						local showBoxData ={}
						showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
						-- showBoxData.context = "上次有未完成的游戏，是否再次进入"--内容；
						showBoxData.context = "Last time there were unfinished games!"--内容；
						showBoxData.enterCB = function()
							self:CheckAndInstallOrUpdateGameByCGameID(clientGameID,function ()
								self.model.directToGameInfo=DirectToGameVo.New()
								self.model.directToGameInfo.mGameID=msgpaa.m_unGameID
								self.model.directToGameInfo.mRoomID=msgpaa.m_unRoomID
								self.model.directToGameInfo.mDeskIndex=msgpaa.m_unDeskIndex
								self.model.directToGameInfo.mDeskStation=msgpaa.m_usDeskStation
								self.model.cacheUserPlayingRoomID=msgpaa.m_unRoomID
								PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=clientGameID

								self.mBool_EnterRoomSuccesss=false
								StartCoroutine(function ()
									yield_return(WaitForSeconds(5))
									if self.mBool_EnterRoomSuccesss==false then
										self.model.directToGameInfo=nil
										-- UIManager:GetInstance():ShowNoteMessage("进入游戏失败！")
										UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("EnterGameFail"))
									end
								end)

								self:ReqGetRoomLevel(clientGameID)
							end)
						end--：点击确定返回；
						showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
						showBoxData.isHideAll = false--:隐藏所有按钮;
						showBoxData.isShowBtnClose = false--:界面的关闭按钮
						UIManager:GetInstance():ShowMessageBox(showBoxData)
						-- end
						UDebug.LogError("玩家上次强退的房间ID："..self.model.cacheUserPlayingRoomID)
						UDebug.LogError("玩家上次强退的游戏ID："..clientGameID)
					else
						error("查询游戏状态 进入金币游戏找不到游戏配置")
					end
				end
			else
				HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
			end

		end
	end
end

function RoomController:ReqGetRoomLevel( gameID )
	local mTime = os.time()
	if (mTime - self.mLastRequeryEntergameTime) < 1 then
		return 
	end
	print("@@@@ReqGetRoomLevel")
	gameID = ConfigModuleModel:GetInstance():GameIDChange(gameID)
	self.mLastRequeryEntergameTime = mTime
	-- self.mIsNeedShowNetMessage = true
	-- RenderMgr.AddInterval(function()
	-- 	RenderMgr.Remove("RoomController:ReqGetRoomLevel")
	-- 	if SceneManager.GetInstance():GetCurrentSceneState() ~= SceneManager.SceneType.Game and 
	-- 	SceneManager.GetInstance():GetCurrentSceneState() ~= SceneManager.SceneType.Room then
	-- 		if self.mIsNeedShowNetMessage then
	-- 			-- UIManager:GetInstance():ShowNetWorkMessage("Loading_tips","请稍后再试！")
	-- 			UIManager:GetInstance():ShowNetWorkMessage("Loading_tips",StringFormatByLanguage("NetWorkOrrer"))
	-- 		end
	-- 	end
	-- end,"RoomController:ReqGetRoomLevel",1,1.1)
	UIManager:GetInstance():ShowNetWorkMessage("Loading_tips",StringFormatByLanguage("NetWorkOrrer"))
	local send = {}
	send.m_uGameID = gameID  --
	Net_SendPlatformGameData(NetworkDefine.CReqGetGameLevelMsgPara, send, send.m_uGameID, NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_RoomLevel, 0, 0)
	
end

function RoomController:ShowMessageBox(context)
	LuaEvent:RemoveEventListener(EventName.NOTICE_DOWN,self.ShowMessageBox,self)
	--隐藏加载信息
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	end
	if context == nil or context.m_data == nil then return end
	local gameID = context.m_data[0]
	local down = context.m_data[1] == 0
	local showBoxData ={}
	showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
	local str = ""
	if down then
		showBoxData.context = "需要下载"--：内容；
		str = "Game_Downloading"--StringFormatByLanguage("Game_Downloading")
	else
		showBoxData.context = "需要更新"--：内容；
		str = "Game_Updateing"--StringFormatByLanguage("Game_Updateing")
	end
	showBoxData.enterCB = function() 
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.MessageBox)
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.GameDownLoad,function ()
			GameDownLoadController:GetInstance():SetPanelData(gameID,str)
			LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
			LuaEvent:DispatchEvent(EventName.START_UPDATE_RES,gameID) -- body
		end)
	end--：点击确定返回；
	showBoxData.cancelCB = function() UIManager:GetInstance().HidePanel(UIPanelDefine.EWndID.MessageBox) end--：点击取消返回，
	showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
	showBoxData.isHideAll = false--:隐藏所有按钮; 
	showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function RoomController:OnDownCompleted(context)
	LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	local gameID=0
	if context~=nil and context.m_data~=nil then
		gameID=context.m_data
	end
	if self.downCB ~= nil then
		pcall(self.downCB,gameID)
	end
end
	
function RoomController:ChangeDesk()
	local send={}
	local player=PlayerInfoController:GetInstance().model.mainPlayer
	send.m_unUin=player.uiUserID or 0
	send.m_usGameID=player.desk.m_usGameID or 0
	send.m_usRoomID=player.desk.m_usRoomID  or 0
	send.m_usDeskIndex=player.desk.m_usDeskIndex or 0
	send.m_bDeskStation=player.desk.m_usDeskStation or 0
	send.m_iMoney=player.iMoney
	send.m_bFlag=0
	send.m_szNickName= {}
	--print("进入游戏 == ".." 积分 == "..send.m_iMoney.." deskIndex == "..send.m_usDeskIndex.." deskStation == "..send.m_bDeskStation);
	--保证长度，
	local tmp=CommonUtil.StringToByteArrayTable(player.szNickName or "")
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		send.m_szNickName[i] = tmp[i] or 0
	end
	if player.bBoy then
		send.m_usSex=0
	else
		send.m_usSex=1
	end
	-- 游戏中断线流程
	if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
	
		UIManager:GetInstance():ShowNetWorkMessage("正在换桌中","换桌超时",5)
	else

	end
	self:ReqChooseDeskEnterGame(send)
end

function RoomController:RspHandlerGameLevel(buffer)
	print("请求房间列表返回")
	local msg=self:ParseMsg(NetworkDefine.CRspGetGameLevelMsgPara,buffer)
	if msg.m_sResult == 0 then
		local t={}
		for i=1,msg.m_usLevelCount do
			local levelID = msg.m_szLevelCnf[i].m_nLevelID
			local vo={}
			vo.m_unMinMoney=msg.m_szLevelCnf[i].m_unMinMoney --最少带入金额
			vo.m_unMaxMoney=msg.m_szLevelCnf[i].m_unMaxMoney --最大带入金额
			vo.m_unStartCoins=msg.m_szLevelCnf[i].m_unStartCoins --体验场带入金币
			vo.m_nFlag=msg.m_szLevelCnf[i].m_nFlag --是体验场还是普通场 1是体验场 0是普通场币
			vo.m_usGameID=msg.m_usGameID
			t[levelID] = vo
		end
		self.model:AddGameRoomLevel(msg.m_usGameID,t)
		PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=ConfigModuleModel:GetInstance():GameIDChange(msg.m_usGameID)
		--发送请求房间列表 --请求房间列表，从游戏索引从0开始，请求前10个房间
		local send = {}
		send.m_usGameID = msg.m_usGameID  --
		send.m_usRoomCount = 10  --
		send.m_usRoomIndex = 0  --
		-- Net_SendPlatformGameData(templetTable, dataTable, m_bDstFE, enterGameMsgType, roomID, deskID)
		Net_SendPlatformGameData(NetworkDefine.CReqGetRoomListMsgPara,send,send.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGIN_ROOMList,0,0)
	else
		self.CanRequest = true
		 UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad);
		 ServerBackPrompt(msg.m_sResult);
	end
end

--这里才是真正的获取房间列表的详细信息
function RoomController:RspHandlerRoomList(buffer )
	print("@@@RspHandlerRoomList")
	self.mIsNeedShowNetMessage = false
	local msgpaa=self:ParseMsg(NetworkDefine.CRspGetRoomListMsgPara,buffer)
	local roomIndex = msgpaa.m_usRoomIndex;

	if msgpaa.m_sResult == 0 then
		if msgpaa.m_usRoomCount == 0 then
			if msgpaa.m_usRoomIndex == 0 then
				-- //游戏维护中
                UIManager:GetInstance():ShowNoteMessage("Game_Repairing");
			end
			self.CanRequest = true
			return
		end
		self.model.goldRooms={}
		--获取房间等级列表
		local tbRoomLevel=self.model:GetGameRoomLevel( msgpaa.m_usGameID )
	
		for i=1,msgpaa.m_usRoomCount do
			local sverRoomInfo = msgpaa.m_szRoomCnf[i]
			local vo = {}
			vo.uRoomID = sverRoomInfo.m_nRoomID--//房间ID
		    vo.iRoomType = sverRoomInfo.m_nRoomType--//房间类型
		    vo.iRoomLevel = sverRoomInfo.m_nLevel--//房间level
		    vo.uDeskCount = sverRoomInfo.m_nDeskCount--//房间桌子的数量
		    vo.uDeskPeople = sverRoomInfo.m_nSiteNum--//每张桌子的位置数量（6人桌之类）
		    vo.iBasePoint = sverRoomInfo.m_nBasePoint--//倍率
		    vo.iLessPoint =  sverRoomInfo.m_nLessPoint--// 底分
		    vo.iMoneyPoint = sverRoomInfo.m_nMoneyPoint
		    vo.szGameRoomName = CommonUtil.LuaTableToStringNoEmpty(sverRoomInfo.m_szName)--//游戏房间名称
		    vo.uNameID = ConfigModuleModel:GetInstance():GameIDChange(msgpaa.m_usGameID)--//游戏ID
		    vo.bDstFE = msgpaa.m_usGameID
		    vo.uRoomIndex = roomIndex + i -1
		   	--获取房间等级列表
			if tbRoomLevel then
		   		local levelInfo1=tbRoomLevel[vo.iRoomLevel]
	   			vo.m_unMinMoney=levelInfo1.m_unMinMoney
	   			vo.m_unMaxMoney=levelInfo1.m_unMaxMoney
		   		vo.m_nFlag=levelInfo1.m_nFlag--是体验场还是普通场 1是体验场 0是普通场币
		   	end
		    local room= GoldRoomVo.New()
		    room:InitVo(vo)
		    --取出等级信息
		    local levelInfo=self.model:GetGameRoomLevel(msgpaa.m_usGameID)[vo.iRoomLevel]
		    room:UpdateVo(levelInfo)
		    self.model:AddGlodRoom(vo.uRoomID,room)

		end
		self:RspCreateRoomList(self.model.goldRooms,msgpaa.m_usGameID,msgpaa.m_usRoomCount)
	else
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad);
		self.CanRequest = true
		ServerBackPrompt(msgpaa.m_sResult)
	end
end

function RoomController:RspCreateRoomList(roomLists,gameID,roomCount)
	self.mBool_IsShowNetWorkMessage=false
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	end
	--直接进入游戏
	if self.model.directToGameInfo~=nil then--直接进入游戏
		--获取房间信息
		local room=self.model:GetGlodRoom(self.model.directToGameInfo.mRoomID)
		if room then
			local iMoney = (PlayerInfoController:GetInstance().model.mainPlayer.iMoney);
			local minMoney = room.m_unMinMoney
			self.model.RoomMinMone = minMoney
			LuaToCSBridge.MinEnterGameMoney = minMoney
			if  not(self.model:IsDeBitGame(room.m_usGameID)) and iMoney<minMoney then
				RoomController.GetInstance().CanRequest = true
				--self:DispatchEvent(RoomModel.EventType.EnterRoom,false)
				local showBoxData ={}
				showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
				local str = "Amount_Is_Not_Sufficient"--StringFormat(StringFormatByLanguage("Whether_to_go_to_the_Short"),NumberFormat(HallGoldRateSToC(self.model.RoomMinMone)) )
				showBoxData.context = str
				showBoxData.enterCB = function() 
					-- LuaEvent:DispatchEvent(EventName.OPEN_RECHARGEPANEL,{1})
				end--：点击确定返回；
				showBoxData.cancelCB = nil
				showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
				showBoxData.isHideAll = false--:隐藏所有按钮; 
				showBoxData.isShowBtnClose = false--:界面的关闭按钮
				UIManager:GetInstance():ShowMessageBox(showBoxData)
				return
			end
			local send={}
			send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
			send.m_usGameID=room.m_usGameID or 0
			send.m_usRoomID=room.uRoomID  or 0
			send.m_usDeskIndex=self.model.directToGameInfo.mDeskIndex
			send.m_bDeskStation=self.model.directToGameInfo.mDeskStation
			send.m_iMoney=iMoney
			send.m_bFlag=0
			send.m_szNickName= {}
			--保证长度，
			local tmp=CommonUtil.StringToByteArrayTable(PlayerInfoController:GetInstance().model.mainPlayer.szNickName or "")
			for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
				send.m_szNickName[i] = tmp[i] or 0
			end
			if PlayerInfoController:GetInstance().model.mainPlayer.bBoy then
				send.m_usSex=0
			else
				send.m_usSex=1
			end
			self.model.CurrentRoomInfo = room

			RoomController:GetInstance():ReqChooseDeskEnterGame2(send)
		else
			self.model.directToGameInfo=nil
			print("直接进入游戏失败 房间不存在:",self.model.cacheUserPlayingRoomID)
			self.CanRequest = true
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad);
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("E_ERROR_GET_CARD_NOT_EXIST"));
		end
		
	else
		print("正常进入游戏：")
		self.model:ResetLastEnterGameRoomInfo()

		self.model:AddRoomList(gameID,roomLists)
		local tmpList = self.model:GetRoolList(gameID)
		if roomCount == 1 then
			local room_1=tmpList[1]
			local viewIndex=ConfigModuleModel.GetInstance():GetGameConfigByCID(room_1.uNameID).iRoomIndex
			if viewIndex==4 or viewIndex == 5 then --配置了房间桌子
				SceneManager.GetInstance():HallToRoom(tmpList)
			else
				self.model:OnEnterRoom(room_1)
			end
		else
			-- SceneManager.GetInstance():HallToRoom(tmpList)

			--处理进最少房间问题
			local room_1=tmpList[1]
			local viewIndex=ConfigModuleModel.GetInstance():GetGameConfigByCID(room_1.uNameID).iRoomIndex
			-- print(" --------  viewIndex == ",viewIndex)
			if viewIndex == 6 then --配置了进最少房间
				local Milliseconds = CS.System.DateTime.Now.TimeOfDay.TotalMilliseconds
				Milliseconds = math.floor(Milliseconds)
				local roomIndexRandom = Milliseconds % roomCount + 1
				room_1=tmpList[roomIndexRandom]
				if room_1 then
					self.model:SetLastEnterGameID(gameID)
					self.model:SetLastEnterGameRoomInfo(roomIndexRandom)
					self.model:OnEnterRoom(room_1)
				else
					print(" --------  进入房间错误 roomIndexRandom == ",roomIndexRandom, roomCount)
				end	
			else
				local iGameType=ConfigModuleModel.GetInstance():GetGameConfigByCID(room_1.uNameID).iGameType
				if iGameType == HallDefine.AllGameType.BuYu then
					---处理 捕鱼 是否关闭体验场
					local temp = ConfigModuleModel.GetInstance():GetGameConfigByCID(room_1.uNameID)
					if temp.TiYanRoom == 0 then
						room_1=tmpList[2]
						self.model:OnEnterRoom(room_1)
					else
						SceneManager.GetInstance():HallToRoom(tmpList)
					end
				else
					SceneManager.GetInstance():HallToRoom(tmpList)
				end
			end
		end		
	end
end

--断线重连进游戏
function RoomController:ReqChooseDeskEnterGame2(send)
	
	self.mBool_IsShowNetWorkMessage=true
	
	UIManager:GetInstance():ShowNetWorkMessage("Enter_Rooming","EnterRoomOverTime",8)
	PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=ConfigModuleModel:GetInstance():GameIDChange(send.m_usGameID)--玩家请求的房间id
	-- templetTable, dataTable, m_bDstFE, enterGameMsgType, roomID, deskID
	Net_SendPlatformGameData(NetworkDefine.CReqEnterGameMsgPara,send,send.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_GAME_INFO,send.m_usRoomID, send.m_usDeskIndex)
end

function RoomController:ReqChooseDeskEnterGame(send)
	
	PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=ConfigModuleModel:GetInstance():GameIDChange(send.m_usGameID)--玩家请求的房间id
	-- templetTable, dataTable, m_bDstFE, enterGameMsgType, roomID, deskID
	Net_SendPlatformGameData(NetworkDefine.CReqEnterGameMsgPara,send,send.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_RUB_TABLE,send.m_usRoomID, send.m_usDeskIndex)
end



function RoomController:Test1RspUserEnterGame(buffer)
	self:RspUserEnterGame(buffer)
end


function RoomController:Test2RspUserEnterGame(buffer)
	self:RspUserEnterGame(buffer)
end


function RoomController:RspUserEnterGame(buffer)
	self.mBool_IsShowNetWorkMessage=false
	-- if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
	-- 	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
	-- end
	
	self:PspGoldChooseDeskEnterGame(buffer)  --进入金币
end

--响应开放卡进入游戏
function RoomController:PspKFChooseDeskEnterGame(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRspEnterGameMsgPara,buffer)
	print("进入房卡返回msg.m_sResult:",msg.m_sResult)
	-- print("房卡  分配桌子 :",msg.m_sResult.."// msg.m_unUin = "..msg.m_unUin.."//msg.m_usGameID = "..msg.m_usGameID.." //msg.m_usRoomID == ",msg.m_usRoomID,"  // msg.m_usDeskIndex  == ",msg.m_usDeskIndex," // msg.m_usDeskStation",msg.m_usDeskStation);
	local room=self.model:GetCardRoom(msg.m_usRoomID)
	if msg.m_sResult == 0 then
		--创建桌子
		local desk=CardDeskVo.New()
		local vo={}
		vo.m_usDeskIndex=msg.m_usDeskIndex
		vo.m_usDeskStation=msg.m_usDeskStation
		vo.m_usGameID=msg.m_usGameID
		vo.m_usRoomID=msg.m_usRoomID
		desk:InitVo(vo)
		desk.unOwnerID=room.unOwnerID
		desk.usUserCount=room.usUserCount
		desk.mRoomCardsID=room.mRoomCardsID
		desk.usGameNum=room.usGameNum
		desk.usNumCount=room.usNumCount
		--获取房间
		room:AddDesk(msg.m_usDeskIndex,desk)
		--
		PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=ConfigModuleModel:GetInstance():GameIDChange(vo.m_usGameID)--玩家请求的房间id
		PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID=vo.m_usRoomID--玩家请求的房间id
		PlayerInfoController:GetInstance().model.mainPlayer.requestDeskIndex=vo.m_usDeskIndex--玩家请求的桌子索引
		--
		self:ReqDeskPlayerList(msg.m_usRoomID,msg.m_usDeskIndex,1,msg.m_usGameID)
	else
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		end
		if msg.m_sResult == -115 or msg.m_sResult == -116 or msg.m_sResult == -117 then--// 卡房已经到期了，踢出用户 或者 卡房局数已经用完，踢出用户 或者房间解散
			print("卡房失效,游戏汇总结算",msg.m_sResult)
			-- 保存房间失效原因
			self.model.mRoomCardDismissType=msg.m_sResult
			-- //强制退出的时候 1. 如果房主是自身的话重置房卡号 2. 退出的房卡号 和我的房卡号相同的情况下重置房卡号
			local isRoomOwer=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID==room.unOwnerID
			if isRoomOwer or PlayerInfoController:GetInstance().model.mainPlayer.iTransTax==room.mRoomCardsID then
				PlayerInfoController:GetInstance().model.mainPlayer.iTransTax=0
			end
			if msg.m_sResult==-117 then--房间解散
				if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.DissolveRoom) then
					UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.DissolveRoom)
				end
 				local resultKey = ResultID2Key(msg.m_sResult)
				local showBoxData={}
				showBoxData.title = StringFormatByLanguage("Prompt")
                showBoxData.message = StringFormatByLanguage(resultKey)
                showBoxData.buttonYesName = StringFormatByLanguage("Sure")
                showBoxData.buttonNoName = StringFormatByLanguage("Cancel")
                showBoxData.isHideAllButton = false
                showBoxData.isShowNo = false
                showBoxData.isRotate = false
                showBoxData.actionYes = function( )
                	self:ResultRoomCard()
                end
                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
            elseif msg.m_sResult == -116 then --//卡房局数已经用完，踢出用户
                local isHaveSmallResult = false;
                -- 如果没有小结算的直接结算，有小结算的在小结算中发起汇总
                isHaveSmallResult=room.isHaveSmallResult or false
                if not isHaveSmallResult then
                	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.PreResult)
                end
            elseif msg.m_sResult == -115 then --//卡房已经到期了，踢出用户
            	local promptStr=ResultID2Key(msg.m_sResult)
            	local showBoxData={}
				showBoxData.title = StringFormatByLanguage("Prompt")
                showBoxData.message = StringFormatByLanguage(promptStr)
                showBoxData.buttonYesName = StringFormatByLanguage("ViewSummary")
                showBoxData.buttonNoName = StringFormatByLanguage("Cancel")
                showBoxData.isHideAllButton = false
                showBoxData.isShowNo = false
                showBoxData.isRotate = false
                showBoxData.actionYes = function( )
                	self:ResultRoomCard()
                end
                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
            elseif msg.m_sResult == -113 then --//断线流程 房卡已经过期
            	if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
	            	local promptStr=ResultID2Key(msg.m_sResult)
	            	local showBoxData={}
					showBoxData.title = StringFormatByLanguage("Prompt")
	                showBoxData.message = StringFormatByLanguage(promptStr)
	                showBoxData.buttonYesName = StringFormatByLanguage("ViewSummary")
	                showBoxData.buttonNoName = StringFormatByLanguage("Cancel")
	                showBoxData.isHideAllButton = false
	                showBoxData.isShowNo = false
	                showBoxData.isRotate = false
	                showBoxData.actionYes = function( )
	                	self:ResultRoomCard()
	                end
	                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
	            end
            elseif msg.m_sResult == -89 then --//长时间未操作踢出
            	print("房卡项目 长时间不操作踢出")
        	elseif msg.m_sResult == -78 then --//用户已经不在游戏中
        		print("房卡项目 用户已经不在游戏中")
        		-- 已经显示汇总
        		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.GameResult) or UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.PreResult) then
        			print("房卡项目 用户已经不在游戏中 已经显示汇总或者 准备查看按钮出现");
        		else
					if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
						
						if not(UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.MessageBox)) then

							local showBoxData={}
							showBoxData.title = StringFormatByLanguage("Prompt")
							showBoxData.message = StringFormatByLanguage("E_ERROR_USER_HAD_LEAVE_DESK_CHAIR_Is_Result")
							showBoxData.buttonYesName = StringFormatByLanguage("ViewSummary")
							showBoxData.buttonNoName = StringFormatByLanguage("Cancel")
							showBoxData.isHideAllButton = false
							showBoxData.isShowNo = false
							showBoxData.isRotate = false
							showBoxData.actionYes = function( )
								self:ResultRoomCard()
							end
							UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
						end
					else
						self:ResultRoomCard()
        			end
        		end
        	else
        		-- 游戏中断线流程
        		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
        			ServerBackPrompt(msg.m_sResult);
        			local showBoxData={}
					showBoxData.title = StringFormatByLanguage("Prompt")
	                showBoxData.message = StringFormatByLanguage("ReEnterGameFailIsTryEnter")
	                showBoxData.buttonYesName = StringFormatByLanguage("Sure")
	                showBoxData.buttonNoName = StringFormatByLanguage("ViewSummary")
	                showBoxData.isHideAllButton = false
	                showBoxData.isShowNo = true
	                showBoxData.isRotate = false
	                showBoxData.actionYes = function( )
	                	error("断线重联  进入游戏失败 重新查询房卡 ");
	                	local CReqGetGameCard={}
	                	CReqGetGameCard.m_unUin =  PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
   						CReqGetGameCard.m_unCardID = room.mRoomCardsID
	                	self:ReqGetGameCard(CReqGetGameCard)
	                end
	                 showBoxData.actionNo = function( )
	                	error("断线重联进入游戏失败，查看汇总成绩");
	                	self:ResultRoomCard()
	                end
	                UIManager:GetInstance():ShowCommonPromptPanel(showBoxData)
        		end
			end
		end
	end
end

-- 金币进入游戏(选择一个桌子进入游戏)
function RoomController:PspGoldChooseDeskEnterGame(buffer)
	
	local msg=self:ParseMsg(NetworkDefine.CRspEnterGameMsgPara,buffer)
	UDebug.Log("msg.m_sResult---:"..msg.m_sResult)
	if msg.m_sResult==0  then

		local vo={}
		vo.m_sFlag=msg.m_sFlag
		vo.m_unUin=msg.m_unUin
		vo.m_usGameID=msg.m_usGameID
		vo.m_usRoomID=msg.m_usRoomID --房间id
		vo.m_usDeskIndex=msg.m_usDeskIndex --桌子索引
		vo.m_usDeskStation=msg.m_usDeskStation--座位号

		UDebug.Log("msg.m_unUin:"..msg.m_unUin.."  msg.m_usGameID:"..msg.m_usGameID.."  msg.m_usRoomID:"..msg.m_usRoomID.."  msg.m_usDeskIndex:"..msg.m_usDeskIndex.."  msg.m_usDeskStation:"..msg.m_usDeskStation)
		--存到对应的房间里面去
		local room=RoomModel:GetInstance():GetGlodRoom(vo.m_usRoomID)
		if room then
			local desk=room:GetDesk(vo.m_usDeskIndex)
			if desk==nil then
				desk=GoldDeskVo.New()
				room:AddDesk(vo.m_usDeskIndex,desk)
			end
			desk:InitVo(vo)
			desk.uDeskPeople=room.uDeskPeople

		else
			error("@房间不存在，请校核房间数据")
			return 
		end
		PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=ConfigModuleModel:GetInstance():GameIDChange(vo.m_usGameID)--玩家请求的房间id
		PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID=vo.m_usRoomID--玩家请求的房间id
		PlayerInfoController:GetInstance().model.mainPlayer.requestDeskIndex=vo.m_usDeskIndex--玩家请求的桌子索引
		RoomModel.GetInstance():RemoveEventListener(RoomModel.EventType.RspRoomAllDeskData,self.RspRoomDeskData,self)
		RoomModel.GetInstance():AddEventListener(RoomModel.EventType.RspRoomAllDeskData,self.RspRoomDeskData,self)
	
		self:ReqDeskPlayerList(vo.m_usRoomID,vo.m_usDeskIndex,1,vo.m_usGameID) --请求桌子的用户信息
		


	elseif msg.m_sResult== -236 then
		local clientGameID=ConfigModuleModel:GetInstance():GameIDChange(msg.m_usGameID)
		self.CanRequest = true
		self:CheckAndInstallOrUpdateGameByCGameID(clientGameID,function ()
			self.model.directToGameInfo=DirectToGameVo.New()
			self.model.directToGameInfo.mGameID=msg.m_usGameID
			self.model.directToGameInfo.mRoomID=msg.m_usRoomID
			self.model.directToGameInfo.mDeskIndex=msg.m_usDeskIndex
			self.model.directToGameInfo.mDeskStation=msg.m_usDeskStation
			self.model.cacheUserPlayingRoomID=msg.m_unRoomID
			PlayerInfoController:GetInstance().model.mainPlayer.requestGameID=clientGameID
			self.mBool_EnterRoomSuccesss=false
			StartCoroutine(function ()
				yield_return(WaitForSeconds(5))
				if self.mBool_EnterRoomSuccesss==false then
					self.model.directToGameInfo=nil
					-- UIManager:GetInstance():ShowNoteMessage("进入游戏失败！")
					UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("EnterGameFail"))
				end
			end)
			self:ReqGetRoomLevel(clientGameID)
		end)
	elseif msg.m_sResult== -211 then                            --体验时间超时
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		
		local showBoxData ={}
		showBoxData.title = StringFormatByLanguage("WarmPrompt")
		showBoxData.context ="Experience_time_timeout"
		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
			showBoxData.enterCB = function() 
				self:QuitGame()
			end--：点击确定返回；
		else
			showBoxData.enterCB = nil
		end
		showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
		showBoxData.isHideAll = false--:隐藏所有按钮; 
		showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
	elseif msg.m_sResult== -105 then
		print("------------  座位已满")
		local temp = self.model:GetLastEnterGameRoomInfo()
		if temp ~= nil then
			local roomIndex = self.model:GetNextCanEnterGameRoomIndex()
			if roomIndex ~= nil then
				local gameID = self.model:GetLastEnterGameID()
				local roomList = self.model:GetRoolList(gameID)
				local room_1 = roomList[roomIndex]
				if room_1 then
					self.model:SetLastEnterGameRoomInfo(roomIndex)
					self.model:OnEnterRoom(room_1)
				else
					ServerBackPrompt(msg.m_sResult)
				end
			else
				ServerBackPrompt(msg.m_sResult)
			end
		else
			ServerBackPrompt(msg.m_sResult)
		end
	else
		self.CanRequest = true
		self.mBool_IsNeedDispatchEnterRoomEvent=false
		--RoomModel.GetInstance():DispatchEvent(RoomModel.EventType.EnterRoom,false)
		if  msg.m_sResult == -76 then
			self.model.directToGameInfo = nil
		end
		--如果在游戏场景中，因为长时间未操作，踢掉
		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
			if msg.m_sResult == -78 then
				if not (UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.MessageBox)) then
					local showBoxData ={}
					showBoxData.title = StringFormatByLanguage("WarmPrompt")
					showBoxData.context = StringFormatByLanguage("Network_Connection_Failed")
					showBoxData.enterCB = function() 
						self:QuitGame()
					end--：点击确定返回；
					showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
					showBoxData.isHideAll = false--:隐藏所有按钮; 
					showBoxData.isShowBtnClose = false--:界面的关闭按钮
					UIManager:GetInstance():ShowMessageBox(showBoxData)
				end
			elseif  msg.m_sResult == -87 then
				if not (UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.MessageBox)) then
					local showBoxData ={}
					showBoxData.title = StringFormatByLanguage("WarmPrompt")
					showBoxData.context =StringFormatByLanguage("Player_no_money")
					showBoxData.enterCB = function() 
						self:QuitGame()
					end--：点击确定返回；
					showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
					showBoxData.isHideAll = false--:隐藏所有按钮; 
					showBoxData.isShowBtnClose = false--:界面的关闭按钮
					UIManager:GetInstance():ShowMessageBox(showBoxData)
				end
			else
				self:QuitGame()
			end
		else
			if msg.m_sResult == -87 then
				UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Player_no_money"))
			end
			self:QuitGame()
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
		end
		if msg.m_sResult ~= -78 and msg.m_sResult ~= -79 and msg.m_sResult ~= -87 then
			ServerBackPrompt(msg.m_sResult)
		end
	end
	

end





--检测并且安装或者更新指定游戏,CGameID:游戏本地ID
function RoomController:CheckAndInstallOrUpdateGameByCGameID(gameId,callBack)
	
	if ConfigInfoMgr.useHotFunction == true then
		
		GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_ERROR, self.OnUpdateError,self)
		self.mFunction_InstallOrUpdateGameCallBack=callBack
		if not self:CheckGameInstall(gameId) then
			
			GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
			GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_GAMEDOWNLOAD,{gameId}) --申请下载
			-- UIManager:GetInstance():ShowNetWorkMessage("正在下载游戏资源...","游戏下载失败！",8)
			UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Game_Downloading"),StringFormatByLanguage("Game_Download_Failed"),8)
		else
			GameDownloadModel:GetInstance():AddEventListener(EventName.APPLY_CHECKGAME_RES_CB,self.CheckGameResCallBack,self)
			GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_CHECKGAME_RES,{gameId}) --检测
			-- UIManager:GetInstance():ShowNetWorkMessage("正在更新游戏资源...","游戏更新失败！",8)
			UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("First_Load_Wait"),StringFormatByLanguage("Game_Update_Failed"),8)
		end
	else
		if callBack then
			callBack()
		end
	end
end


function RoomController:OnDownCompleted(context)
	
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	end
	if self.mFunction_InstallOrUpdateGameCallBack then
		
		self.mFunction_InstallOrUpdateGameCallBack()
		self.mFunction_InstallOrUpdateGameCallBack=nil
	end
end



function RoomController:CheckGameResCallBack(context)
	
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.APPLY_CHECKGAME_RES_CB,self.CheckGameResCallBack,self)
	if context then
		
		local nGameID=context[1]
		local nSate=context[2]
		if nSate==0 or nSate==1 then--下载
		
			--这里可以加入是否需要弹出窗口提示
			GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_GAMEDOWNLOAD,{nGameID}) --申请下载
		elseif nSate==2 then--不用更新
			
			if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
				UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
			end
			if self.mFunction_InstallOrUpdateGameCallBack then
				
				self.mFunction_InstallOrUpdateGameCallBack()
				self.mFunction_InstallOrUpdateGameCallBack=nil
			end
		elseif nSate==102 then  --检测失败
			
			print("检测版本文件version失败")
			UIManager:GetInstance():ShowNoteMessage(nGameID..StringFormatByLanguage("Game_Download_Failed"))
		end
	end
end

function RoomController:OnUpdateError()
	UDebug.Log("RoomController:CheckAndInstallOrUpdateGameByCGameID:15")
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.UPDATE_ERROR, self.OnUpdateError,self)
	self.mFunction_InstallOrUpdateGameCallBack=nil
	self.model.directToGameInfo=nil
end



--检查游戏是否安装
function RoomController:CheckGameInstall( gameID )
	local fileName = StringFormat("{0}{1}/version.xml",PathDefine.AssetBundlePath(),gameID)
	local isExits = false
	isExits = LuaHelperUtil.FileExits(fileName)
	-- self.mGo_NoInstallSign:SetActive(not isExits)
	-- self.m_goNoInstallSpriteSign:SetActive(not isExits)
	return isExits
end




function RoomController:RspRoomDeskData()
		RoomModel.GetInstance():RemoveEventListener(RoomModel.EventType.RspRoomAllDeskData,self.RspRoomDeskData,self)

			--[
		--把房间信息取出来
		local m_usRoomID=PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID--玩家请求的房间id
		local room2=RoomModel:GetInstance():GetGlodRoom(m_usRoomID)

		if room2== nil then 
			error("取出的房间为空RoomController:RspGoldPlayerList")
			self.CanRequest = true 
			return 
		end
		local m_usDeskIndex=PlayerInfoController:GetInstance().model.mainPlayer.requestDeskIndex--玩家请求的桌子索引
		--取出桌子
		local desk2=room2:GetDesk(m_usDeskIndex)
		
		if desk2==nil then
			error("取出的桌子为空RoomController:RspGoldPlayerList")
			self.CanRequest = true 
			return
		end
		if desk2:GetMyVo() == nil then
			error("自己不再当前游戏中RoomController:RspGoldPlayerList")
			self.CanRequest = true
			return 
		end

		self.mBool_IsNeedDispatchEnterRoomEvent=false
		RoomModel.GetInstance():DispatchEvent(RoomModel.EventType.EnterRoom,true)
		desk2.m_sFlag = room2.m_nFlag
		self:EnterGame(desk2) 
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
		end
end





function RoomController:ReqDeskPlayerList(roomID,deskIndex,deskCount,gameID)
	local send={}
	send.RoomID=roomID
	send.DeskIndex=deskIndex
	send.DeskCount=deskCount
	self.mBool_IsShowNetWorkMessage=true
	

	-- UIManager:GetInstance():ShowNetWorkMessage("Loading_tips","加载信息失败！",5);
	UIManager:GetInstance():ShowNetWorkMessage("Loading_tips",StringFormatByLanguage("Loading_Failure"),5);
	
	Net_SendPlatformGameData(NetworkDefine.CReqGetRoomPlayerListMsgPara, send, gameID, NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_DESKLIST, roomID, deskIndex)

end

function RoomController:RsqDeskPlayerList( buffer )
	self.mBool_IsShowNetWorkMessage=false
	if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
	end
	--金币场
	self:RspGoldPlayerList(buffer)
end

function RoomController:ReqDeskPlayerListNew(roomID,deskIndex,deskCount,gameID)
	local send={}
	send.RoomID=roomID + HallDefine.NewDeskOffsetRoomID
	send.DeskIndex=deskIndex
	send.DeskCount=deskCount
	self.mBool_IsShowNetWorkMessage=true
	

	-- UIManager:GetInstance():ShowNetWorkMessage("Loading_tips","加载信息失败！",5);
	-- UIManager:GetInstance():ShowNetWorkMessage("Loading_tips",StringFormatByLanguage("Loading_Failure"),5);
	
	Net_SendPlatformGameData(NetworkDefine.CReqGetRoomPlayerListMsgPara, send, gameID, NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_GET_DESKLIST, roomID, deskIndex)
end

function RoomController:RsqDeskPlayerListNew( buffer )
	self.mBool_IsShowNetWorkMessage=false
	-- if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
	-- 	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
	-- end
	
	local msg = CRspGetRoomUserListPara_V2.Decode(buffer)
	if msg.m_sResult == 0 then
		RoomModel.GetInstance():DispatchEvent(RoomModel.EventType.RsqDeskPlayerListNewData,msg)
	-- else
		-- UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage(""))
	end
end

-- 响应开放卡项目桌子列表的请求
function RoomController:RspKFDeskList(buffer)
	local msg=CRspGetRoomPlayerListMsgPara.Decode(buffer)
	if msg.m_sResult == 0 then
		print("房卡 桌子列表返回 ： 桌子数量 "..msg.m_bDeskCount.." deskIndex "..msg.m_uDeskIndex)
		if msg.m_bDeskCount==0 then
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("NO_Exist_Desk"))
			return
		end
		--取出房间
		local room=RoomModel:GetInstance():GetCardRoom(msg.m_sRoomID)
		if room==nil then 
			error("@房间不存在，请校核房间数据RoomController:RspGoldPlayerList") 
			return 
		end
		local people = room.mDeskPeople
		if people <= 0 then
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RoomPersion"))
			return 
		end
		local mdeskIndex = msg.m_uDeskIndex;
		for i=1, msg.m_bDeskCount do
			local DeskIndex = mdeskIndex + i-1;
 			local desk=room:GetDesk(DeskIndex)
			if desk==nil then
				desk=GoldDeskVo.New()
			end
            desk.DeskUsers = {}
            for n=1,people do
            	local mDeskUser = SUserDetailInfo.New()
            	mDeskUser.iDeskNO = msg.m_DeskUserInfo[i].m_sDeskNo
            	local t = msg.m_DeskUserInfo[i].m_szUserInfoStruct[n];
            	if t ~=nil then
            		mDeskUser.iDeskStation = t.m_bDeskStation
            		mDeskUser.uiUserID = t.m_iUserID
            		mDeskUser.iMoney = t.m_iMoney
            		mDeskUser.iVipLevel = t.m_iVipLevel
            		mDeskUser.szNickName = CommonUtil.LuaTableToStringNoEmpty(t.m_szNickName)
            		mDeskUser.bBoy = false
            		local mSex = t.m_sSex
            		mDeskUser.bBoy =  (mSex == 1)
            		if mDeskUser.iDeskStation < people then
            			desk.DeskUsers[mDeskUser.iDeskStation] = mDeskUser;
            		else
            			error("座位号错误 座位号超过桌子容纳人数 : 桌子容纳人数")
            		end
            		desk.DeskUsers[mDeskUser.iDeskStation]=mDeskUser
            	end
            end
		end
		--把房间信息取出来
		local m_usRoomID=PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID--玩家请求的房间id
		local room2=RoomModel:GetInstance():GetCardRoom(m_usRoomID)
		if room2== nil then 
			error("取出的房间为空RoomController:RspGoldPlayerList") 
			return 
		end
		local m_usDeskIndex=PlayerInfoController:GetInstance().model.mainPlayer.requestDeskIndex--玩家请求的桌子索引
		--取出桌子
		local desk2=room2:GetDesk(m_usDeskIndex)
		if desk2==nil then
			error("取出的桌子为空RoomController:RspGoldPlayerList") 
			return
		end
		self:EnterGame(desk2)
	else
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
		end
		self.model.mCRequserDissolveGameBrocard=nil
		error("获取不到桌子玩家列表 Error :")
		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
			self:QuitGame()
		else
			ServerBackPrompt(msgpaa.m_sResult);
		end
	end
end

--选择桌子后，申请桌子里面的玩家列表
function RoomController:RspGoldPlayerList(buffer)
	
	local msg=CRspGetRoomPlayerListMsgPara.Decode(buffer)
	if msg.m_sResult == 0 then
		
		if msg.m_bDeskCount == 0 then --服务器逻辑混乱，到这里了还请求桌子列表，返回应该就是唯一的一个桌子和桌子里面的玩家信息
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("NO_Exist_Desk"))
			return
		end
		--取出房间
		local room=RoomModel:GetInstance():GetGlodRoom(msg.m_sRoomID)
		if room==nil then 
			error("@房间不存在，请校核房间数据RoomController:RspGoldPlayerList")
			self.CanRequest = true 
			return 
		end

		local people=room.uDeskPeople --桌子人数
		
		if people<0 or people==0 then 
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RoomPersion"))
			return
		end
		local mdeskIndex = msg.m_uDeskIndex;
		
		for i=1, msg.m_bDeskCount do--这个服务器发来的必然是1
			--取出桌子，填充桌子的用户列表信息
			local DeskIndex = mdeskIndex + i-1;
			local desk=room:GetDesk(DeskIndex)
			
			if desk==nil then
				desk=GoldDeskVo.New()
				room:AddDesk(DeskIndex,desk)
			end
            desk.DeskUsers = {}
            local deskNo=msg.m_DeskUserInfo[i].m_sDeskNo
			for n=1,people do
            	local t = msg.m_DeskUserInfo[i].m_szUserInfoStruct[n];
				if t ~=nil then
	            	local mDeskUser = SUserDetailInfo.New()
					mDeskUser.iDeskNO = deskNo
            		mDeskUser.iDeskStation = t.m_bDeskStation
            		mDeskUser.uiUserID = t.m_iUserID
            		mDeskUser.iMoney = (t.m_iMoney)
            		mDeskUser.iVipLevel = t.m_iVipLevel
            		mDeskUser.szNickName = t.m_szNickName
            		mDeskUser.bBoy = false
            		local mSex = t.m_sSex
					mDeskUser.bBoy =  (mSex == 1)
					mDeskUser.iUserType = t.m_szImageAddr[1]
					mDeskUser.iImageNO = t.m_szImageAddr[2]
            		if mDeskUser.iDeskStation < people then
            			 desk.DeskUsers[mDeskUser.iDeskStation] = mDeskUser;
            		else
            			error("座位号错误 座位号超过桌子容纳人数 : 桌子容纳人数")
            			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Desk_Full"))
            			
            		end
            		desk.DeskUsers[mDeskUser.iDeskStation]=mDeskUser
            	end
            end
		end

		local data={
			RoomId=msg.m_sRoomID,
			DeskCount=msg.m_bDeskCount,
			DeskStartIndex=msg.m_uDeskIndex,
			DeskPeople=room.uDeskPeople,

		}
		UDebug.Log("msg.m_sRoomID:"..msg.m_sRoomID)
		
		RoomModel:GetInstance():DispatchEvent(RoomModel.EventType.RspRoomAllDeskData,data)
		
	else
		self.CanRequest = true
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg) 
		end
	end
end

function RoomController:EnterGame( desk )
	
	self.mBool_EnterRoomSuccesss=true
	self.model.directToGameInfo=nil
	PlayerInfoController:GetInstance().model.mainPlayer.desk=desk
	local gameID=PlayerInfoController:GetInstance().model.mainPlayer.requestGameID--玩家请求的房间id
	self:GoldEnterGame(desk)
end

--其他玩家进入游戏
function RoomController:RspPlayerEnterRoom(buffer)
	--如果是金币场
	local msg=self:ParseMsg(NetworkDefine.CRspOtherPlayerEnterRoom2,buffer)
	--如果是房卡
	-- local msg=self:ParseMsg(NetworkDefine.CRspOtherPlayerEnterRoom,buffer)
	
	self.model:PlayerEnterRoom(msg)
end

--其他玩家离开游戏
function RoomController:RspPlayerLeaveRoom(buffer)
	local msg=self:ParseMsg(NetworkDefine.CRspOtherPlayerLeaveRoom,buffer)
	self.model:PlayerLeaveRoom(msg)
end

function RoomController:GoldEnterGame(desk)

	local gameID = ConfigModuleModel:GetInstance():GameIDChange(desk.m_usGameID)  --
	print("拉起游戏资源",gameID)
	if self.view==nil then
		local gameConfig=ConfigModuleModel.GetInstance():GetGameConfigByCID(gameID)
		local screenOrientatione=gameConfig.iScreenOrientatione
		if screenOrientatione==nil then
			screenOrientatione=3
		end

		if screenOrientatione==1 then
			SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.Protrait)
		elseif screenOrientatione==2 then
			SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.AutoProtrait)
		elseif screenOrientatione==3 then
			SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.Landscape)
		elseif screenOrientatione==4 then
			SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.AutoLandscape)
		end

		
		SceneManager:GetInstance():HallToGameScene()
		self.model:SetTopScoreDisplay(gameID)
		if screenOrientatione == 1 then
			StartCoroutine(function() 
				yield_return(WaitForSeconds(0.25))
				if self:IsCSGame(gameID) then
					self.view=GoldRoomViewCS.New(gameID,desk)
				elseif self:IsNewXluaGame(gameID) then
					self.view=GoldNewRoomView.New(gameID,desk)
				elseif self:IsXLuaGame(gameID) then
					self.view=GoldRoomViewXLua.New(gameID,desk)
				else
					self.view=GoldRoomView.New(gameID,desk)
				end
			end)
		else
			if self:IsCSGame(gameID) then
				self.view=GoldRoomViewCS.New(gameID,desk)
			elseif self:IsNewXluaGame(gameID) then
				self.view=GoldNewRoomView.New(gameID,desk)
			elseif self:IsXLuaGame(gameID) then
				self.view=GoldRoomViewXLua.New(gameID,desk)
			else
				self.view=GoldRoomView.New(gameID,desk)
			end
		end
	else
		
		self:ReEnterGame(gameID,desk)
	end
end

function RoomController:CardEnterGame(desk)
	local gameID = ConfigModuleModel:GetInstance():GameIDChange(desk.m_usGameID)  --
	if self.view==nil then

		self.view=CardRoomView.New(gameID,desk)
	else
		self:ReEnterGame(gameID,desk)
	end
end

function RoomController:ReEnterGame(gameID,desk)
	self.view:ReEnterGame(gameID,desk)
end


function RoomController:ChangeLogoutDesk(desk,callback)
	if callback ~= nil then
		self.GameCallBack = callback
	end
	print("大厅请求换桌方法")
	local mainPlayer = PlayerInfoController:GetInstance().model.mainPlayer
	local CReqEnterGameMsgPara={}
	CReqEnterGameMsgPara.m_unUin=0
	CReqEnterGameMsgPara.m_szNickName={}
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		CReqEnterGameMsgPara.m_szNickName[i]=0
	end
	CReqEnterGameMsgPara.m_usSex=0
	CReqEnterGameMsgPara.m_usGameID = desk.m_usGameID;
    CReqEnterGameMsgPara.m_usRoomID = desk.m_usRoomID;
    CReqEnterGameMsgPara.m_usDeskIndex = desk.m_usDeskIndex
    CReqEnterGameMsgPara.m_bDeskStation = desk.m_usDeskStation
    CReqEnterGameMsgPara.m_iMoney = mainPlayer.iMoney
	CReqEnterGameMsgPara.m_bFlag = 0
	self:ReqChangeLogoutDesk(CReqEnterGameMsgPara)
end

--退出游戏
function RoomController:ReqQuitGame(desk)
	self.QuitGameID = ConfigModuleModel:GetInstance():GameIDChange(desk.m_usGameID)  --
	local mainPlayer = PlayerInfoController:GetInstance().model.mainPlayer
	local CReqEnterGameMsgPara={}
	CReqEnterGameMsgPara.m_unUin=0
	CReqEnterGameMsgPara.m_szNickName={}
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		CReqEnterGameMsgPara.m_szNickName[i]=0
	end
	CReqEnterGameMsgPara.m_usSex=0
	CReqEnterGameMsgPara.m_usGameID = desk.m_usGameID;
    CReqEnterGameMsgPara.m_usRoomID = desk.m_usRoomID;
    CReqEnterGameMsgPara.m_usDeskIndex = desk.m_usDeskIndex
    CReqEnterGameMsgPara.m_bDeskStation = desk.m_usDeskStation
    CReqEnterGameMsgPara.m_iMoney = mainPlayer.iMoney
    CReqEnterGameMsgPara.m_bFlag = 0
    self:ReqLogoutGame(CReqEnterGameMsgPara)
end

--退出游戏
function RoomController:CSReqQuitGame()
	desk=self.view.desk
	self.QuitGameID = ConfigModuleModel:GetInstance():GameIDChange(desk.m_usGameID)  --
	local mainPlayer = PlayerInfoController:GetInstance().model.mainPlayer
	local CReqEnterGameMsgPara={}
	CReqEnterGameMsgPara.m_unUin=0
	CReqEnterGameMsgPara.m_szNickName={}
	for i=1,HallDefine.ConstDefine.MAX_NICK_LEN do
		CReqEnterGameMsgPara.m_szNickName[i]=0
	end
	CReqEnterGameMsgPara.m_usSex=0
	CReqEnterGameMsgPara.m_usGameID = desk.m_usGameID;
    CReqEnterGameMsgPara.m_usRoomID = desk.m_usRoomID;
    CReqEnterGameMsgPara.m_usDeskIndex = desk.m_usDeskIndex
    CReqEnterGameMsgPara.m_bDeskStation = desk.m_usDeskStation
    CReqEnterGameMsgPara.m_iMoney = mainPlayer.iMoney
    CReqEnterGameMsgPara.m_bFlag = 0
    self:ReqLogoutGame(CReqEnterGameMsgPara)
end

--请求退出游戏
function RoomController:ReqLogoutGame(msg)
	-- Net_SendPlatformGameData(templetTable, dataTable, m_bDstFE, enterGameMsgType, roomID, deskID)
	UIManager:GetInstance():ShowNetWorkMessage("CLIENT_TIPS_3",StringFormatByLanguage("LeaveGameRoom_Errom"),8)
	Net_SendPlatformGameData(NetworkDefine.CReqEnterGameMsgPara,msg,msg.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_SS_GAME_LOGOUT,msg.m_usRoomID,msg.m_usDeskIndex)
end


function RoomController:ReqChangeLogoutDesk(msg)
	--UIManager:GetInstance():ShowNetWorkMessage("正在匹配","匹配失败",8)
	Net_SendPlatformGameData(NetworkDefine.CReqEnterGameMsgPara,msg,msg.m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_LOGOUT_DESK_4_AUTO_JOIN,msg.m_usRoomID,msg.m_usDeskIndex)
end


function RoomController:RspChangeLogoutDesk(buffer)
	--UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	
	--退出游戏时候请求一次玩家金币
	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_iSize=0
	Net_SendHallData(NetworkDefine.CReqGetUserMoneyDataMsgPara,send,NetworkDefine.E_MSG_ID.MSG_ID_MONEY_REQUEST_CHANGE,0)
	local msg = self:ParseMsg(NetworkDefine.OnlyResult,buffer)
	print("请求离桌但不退出房间" , msg.m_sResultID);
	if self.GameCallBack ~= nil then
		print("回调执行！！！")
		self.GameCallBack(msg.m_sResultID)
		self.GameCallBack = nil
	end
	if msg.m_sResultID ~= 0 then
		
	else
		print("离桌成功------------")
		
		self:ChangeDesk()
	end
end



function RoomController:RspLeaveGameMsg(buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	print("请求退出游戏返回")
	--退出游戏时候请求一次玩家金币
	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_iSize=0
	Net_SendHallData(NetworkDefine.CReqGetUserMoneyDataMsgPara,send,NetworkDefine.E_MSG_ID.MSG_ID_MONEY_REQUEST_CHANGE,0)
	local msg = self:ParseMsg(NetworkDefine.OnlyResult,buffer)
	if msg.m_sResultID~=0 then
		if msg.m_sResultID == -78 then
			self:QuitGame()
		else
			ServerBackPrompt(msg.m_sResultID)
		end
	else
		self:QuitGame()
	end
	
end

function RoomController:QuitGame()
	--请求刷新用户金币信息
	self.model.IsEnterGame = false
	ConfigModuleModel.GetInstance().GameSceneDisplayHallNotify = true
	HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
	PlayerInfoController:GetInstance():RequestGetUserMoney()
	if self.view~=nil then
		self.view:QuitGame()
		--销毁房间实例
		self.view:Destroy()
	end
	self.view=nil 
	--
	-- UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.CreateRoom)
end

function RoomController:DestroyGameRes()
	if self.view~=nil then
		self.view:DestroyGameRes()
		--销毁房间实例
		self.view:Destroy()
	end
	self.view=nil 
end

--解散房间CReqDelGameCard
function RoomController:ReqDeleteGameCard(msg)
	local send={}
	send.m_usMsgLen=0
	send.m_usOwnerID=msg.uiUserID
	send.m_usCardID=msg.mRoomCardsID
	send.m_usTime=msg.m_usTime
	local roomID= PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID
	local room=self.model:GetCardRoom(roomID)
	Net_SendPlatformGameData(NetworkDefine.CReqDelGameCard, send, room.usGameID, NetworkDefine.E_MSG_ID.MSG_ID_Dissolve_Card_Room, room.mRoomID, room.mDeskIndex)
end

--正式解散房间
function RoomController:RspDeleteGameCard( buffer )
	local msg=CRequserDissolveGameBrocard.Decode(buffer)
	--print("响应解散房间",msg.m_unOprUIn)
	if msg.m_usResultID==0 then 
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.GameSetting) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameSetting)
		end
		--游戏已经开始
		local roomID= PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID
		local room=self.model:GetCardRoom(roomID)
		local deskIndex=PlayerInfoController:GetInstance().model.mainPlayer.requestDeskIndex
		local desk=room:GetDesk(deskIndex)

		if desk.isGameBegin then
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.DissolveRoom,function(panel )
				panel:SetPanelData(msg.m_unOprUIn,msg.m_szDissolveUserInfo,msg.m_unSeconds)
			end)

			if msg.m_usNumber==1 then
				if msg.m_szDissolveUserInfo[1].m_unUin~= PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
					error("解散房间相应服务器返回UIN不正确")
				end
			end
		else
			---没有开始，直接销毁数据
			-- RoomInfoModel:GetInstance():ClearRoomModel()
		end
	else
		ServerBackPrompt(msg.m_usResultID)
	end
end

--获取结算信息
function RoomController:ResultRoomCard(callBack)
	GameResultController:GetInstance():SetBackAction(callBack)
	local roomID= PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID
	local room=self.model:GetCardRoom(roomID)
	local msg={}
	msg.m_usMsgLen=0
	msg.m_unCardID=room.mRoomCardsID
	msg.m_unCreateTime=room.unCreateTime
	msg.m_unReqType=1
	self:ReqGetUserTotalScore(msg)
end

function RoomController:ReqGetUserTotalScore(msg)
	local send={}
	send.m_usMsgLen=0
	send.m_unCardID=msg.m_unCardID
	send.m_unCreateTime=msg.m_unCreateTime
	send.m_unReqType=msg.m_unReqType
	Net_SendHallData(NetworkDefine.CReqGetUserTotalScore,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_USER_TOTAL_SCORE,0)
end

function RoomController:RspGetUserTotalScore( buffer )
	local msg=CRspGetUserTotalScore.Decode(buffer)
	local resultKey = ResultID2Key(msg.m_sResultID)
	print("响应房卡结算 ",msg.m_sResultID,"  : ",StringFormatByLanguage(resultKey));
	if msg.m_sResultID==0 then
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.GameSetting) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameSetting)
		end
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.PreResult) then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.PreResult)
		end
		local data={}
		data.mRoomCardsID = msg.m_unCardID
        data.unCreateTime = msg.m_unCreateTime
        data.m_usUsedNum = msg.m_usUsedNum
        data.m_usTotalNum = msg.m_usTotalNum
        data.mGameDataList=msg.mGameDataList
        PlayerRecordController:GetInstance().model:AddRoomCardResult(data)

        if msg.m_unReqType==1 then
        	local isShowCreateButton=false
        	local typeTmp=self.model.mRoomCardDismissType
        	-- 房间结算原因，如果房间失效就显示创建房间按钮
        	if typeTmp==-115 or typeTmp==-116 or typeTmp==-117 then--卡房已经到期了，踢出用户 或者 卡房局数已经用完，踢出用户 或者房间解散
        		self.model.mRoomCardDismissType=0
        		isShowCreateButton=true
        	end
        	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.GameResult,function(panel )
        		panel:SetPanelData(msg.m_usUsedNum,msg.m_usTotalNum,isShowCreateButton)
        		panel:CreateResultList(msg.mGameDataList)
        		--暂时先在这里销毁数据
        		-- RoomInfoModel:GetInstance():ClearRoomModel()
        		--销毁房间

        	end)
    	elseif msg.m_unReqType==2 then -- 战绩请求
    		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.PlayerRecord) then
    			PlayerRecordController:GetInstance():AddUIRecord(data.mRoomCardsID,data.unCreateTime,data)
    		end
        end
	else
		if msg.m_unReqType~=2 then
			if msg.m_sResultID == -120 or msg.m_sResultID == -121 or msg.m_sResultID == -122 then
			else
				ServerBackPrompt(msg.m_sResultID);
			end
		end
		if msg.m_unReqType==1 then
			self:QuitGame()
		elseif msg.m_unReqType==2 then
			PlayerRecordController:GetInstance().model:DeleteRoomCard(msg.m_unCardID,msg.m_unCreateTime)
			if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.PlayerRecord) then
				PlayerRecordController:GetInstance():DeleteUIRecord(msg.m_unCardID,msg.m_unCreateTime)
			end
		end
		-- RoomInfoModel:GetInstance():ClearRoomModel()
	end
end

--广播解散房间
function RoomController:ReceiveDissolveRoomBrocast( buffer )
	local msg=CRequserDissolveGameBrocard.Decode(buffer)
	print("广播：：：解散房间",msg.m_unOprUIn)
	if SceneManager:GetInstance():GetCurrentSceneState()== SceneManager.SceneType.Game then
		self:DissolveRoomBrocast(msg)
	else
		--保存解散房间的缓存
		self.mCRequserDissolveGameBrocard = msg  --房间的广播缓存
	end

end

function RoomController:DissolveRoomBrocast(msg)
	local roomID= PlayerInfoController:GetInstance().model.mainPlayer.requestRoomID
	local room=self.model:GetCardRoom(roomID)
	if room.mRoomCardsID == msg.m_unCardID then
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.DissolveRoom,function(panel)
			panel:SetPanelData(msg.m_unOprUIn,msg.m_szDissolveUserInfo,msg.m_unSeconds)
		end)
	else
		print("解散房间房卡号不正确 client ",room.mRoomCardsID," serever ",msg.m_unCardID)
	end
end

function RoomController:ReceiveGameUserAgreeBrocast(buffer )
  	local msg=self:ParseMsg(NetworkDefine.CReqUserAgreeGame,buffer)
  	print("广播 ： 用户解散房间选择 同意或者拒绝 :  类型 ：",msg.m_usType," 操作 ： ",msg.m_usAgreeFlag)
  	if msg.m_unUin~=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
  		if msg.m_usType==2 then
  			-- 表示 解散房间
			if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.DissolveRoom) then
				DissolveRoomController:GetInstance():NotifyPlayerAgreeResult(msg.m_unUin, msg.m_usAgreeFlag)
			end
			-- if 如果有人不同意就直接隐藏
			if msg.m_usAgreeFlag==2 then
				UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.DissolveRoom)
			end
  		end
  	end
end 

function RoomController:RspUserAgreeGame( buffer )
	--body
	local msg=self:ParseMsg(NetworkDefine.CRspUserAgreeGame,buffer)
	print(" 响应解散房间选择 同意或者拒绝 : Result "..msg.m_sResultID.." 用户 ："..msg.m_unUin.." 类型 ："..msg.m_usType.." 操作 ： "..msg.m_usAgreeFlag)
	if msg.m_sResultID==0 then
		if msg.m_unUin==PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
			--自己
			if msg.m_usType== 2 then--表示 解散房间
				if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.DissolveRoom) then
					DissolveRoomController:GetInstance():NotifyPlayerAgreeResult(msg.m_unUin, msg.m_usAgreeFlag)
				end
				-- if 如果有人不同意就直接隐藏
				if msg.m_usAgreeFlag==2 then
					UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.DissolveRoom)
				end
			end

		end
	else
		ServerBackPrompt(msg.m_sResultID)
	end
end

function RoomController:IsCSGame(gameID)
	for _,v in pairs(HallDefine.CSGame) do
		if v==gameID then
			return true
		end
	end
	return false
end

function RoomController:IsNewXluaGame(gameID)
	for _,v in pairs(HallDefine.NewXluaGame) do
		if v==gameID then
			return true
		end
	end
	return false
end

function RoomController:IsXLuaGame(gameID)
	for _,v in pairs(HallDefine.XLuaGame) do
		if v==gameID then
			return true
		end
	end
	return false
end

function RoomController:SendGameData( templetTable, dataTable, mainId,assistantID )
	local m_usGameID=self.model.mCRspEnterGameMsgPara.m_usGameID
	local m_usRoomID=self.model.mCRspEnterGameMsgPara.m_usRoomID
	local m_usDeskIndex=self.model.mCRspEnterGameMsgPara.m_usDeskIndex
	Net_SendGameData(templetTable, dataTable, mainId,assistantID, m_usGameID,m_usRoomID, m_usDeskIndex)
end

---上分过程byCheckFlag 0: 上分 1: 下分	
function RoomController:CReqUserCheckOutGameCoin( goldNum,byCheckFlag )
	-- body
	local roomInfo = self.model.CurrentRoomInfo
	if roomInfo.m_nFlag == 2 then
		local send = {}
		send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID 
		send.m_un64CheckoutGameCoin = goldNum
		send.m_byCheckFlag = byCheckFlag
		
		local gameID = roomInfo.m_usGameID or 0
		local m_usRoomID = roomInfo.uRoomID  or 0
		Net_SendPlatformGameData(NetworkDefine.ReqUserCheckOutGameCoinPara,send,gameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_CHECKOUT_GAME_COIN,m_usRoomID,roomInfo.DeskIndex)
	end
end

--上分返回
function RoomController:SRspUserCheckOutGameCoin( buffer )
	-- body
	if self.model.CurrentRoomInfo.m_nFlag == 2 then
		local msgpaa = self:ParseMsg(NetworkDefine.CRspUserCheckOutGameCoinPara,buffer)
		self.model:RspUserCheckOutGameCoin(msgpaa)
	end
end

---CS弹出上分界面请求
function RoomController:CSReqUserCheckOutGameCoin( context )
	-- body
	if context and context.m_data then
		local b_CheckFlag = context.m_data[0]
		--self:OpenUserCheckOutGameCoinPanel(b_CheckFlag)
	end
end

--弹出上分界面
function RoomController:OpenUserCheckOutGameCoinPanel( b_CheckFlag )
	-- body
	local roomInfo = self.model.CurrentRoomInfo
	if roomInfo then
		if roomInfo.m_nFlag == 2 then
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGetAndSavMarkPanel,function ( panel )
				-- body
				panel:SetOpenType(b_CheckFlag,self.model.CurrentRoomInfo)
			end)
		end
	end
end

--请求刷新游戏内分
function RoomController:AccountChangeNotify()
	-- body
	local roomInfo = self.model.CurrentRoomInfo
	local gameID = roomInfo.m_usGameID or 0
	local m_usRoomID = roomInfo.uRoomID  or 0
	Net_SendPlatformGameData(NetworkDefine.ReqUserCheckOutGameCoinPara,send,gameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_CHECKOUT_GAME_COIN,m_usRoomID,0)
end


---请求玩家定位列表
---playerCount 玩家个数
---playerIDList 玩家Uin列表
function RoomController:RequireGameLocationList( playerCount,playerIDList)
	local CReqQueryPLayerLocalAddress = {
		{"m_unUINCount","UInt32",0},  -- 查询用户个数
    	{"m_unUINList","Int32[]",playerCount}, --用户ID
	}
	local roomInfo = self.model.CurrentRoomInfo
	local gameID = roomInfo.m_usGameID or 0
	local m_usRoomID = roomInfo.uRoomID  or 0
	--print("+++++++++++++++++++++++++++",gameID,m_usRoomID)
	local sendData = {}
	sendData.m_unUINCount = playerCount
	sendData.m_unUINList = playerIDList
	Net_SendPlatformGameData(CReqQueryPLayerLocalAddress,sendData,gameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_GPS,m_usRoomID,roomInfo.DeskIndex)
end

---请求玩家定位列表 返回
---buffer
function RoomController:RespGameLocationList(buffer)
	--print("请求GPRs返回")
	local data = self:DecodeGameLocationList(buffer)
	RoomModel.GetInstance():DispatchEvent(EventName.GetGameLocalBack,data)
end

---解析请求玩家定位列表
function RoomController:DecodeGameLocationList(buffer)
	local t = {}
	local iStartLength = 0
	t.m_sResultId = DataParse.NetworkToHostOrderToInt16(buffer,iStartLength) --结果
	iStartLength = iStartLength + NetworkDefine.DataType.Int16
	t.m_unUinCount = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength) --玩家个数
	iStartLength = iStartLength + NetworkDefine.DataType.Int32
	if t.m_unUinCount > 0 then
		t.locationAddresslist = {}
		for i=1,t.m_unUinCount do
			t.locationAddresslist[i] = {}
			local temp = t.locationAddresslist[i]
			temp.m_unUIN = DataParse.NetworkToHostOrderToInt32(buffer,iStartLength) -- 用户id
			iStartLength = iStartLength + NetworkDefine.DataType.Int32
			temp.m_szCountry = DataParse.BytesToString2(buffer,iStartLength,16)--国家
			iStartLength = iStartLength + 16
			temp.m_szCity = DataParse.BytesToString2(buffer,iStartLength,16)--城市
			iStartLength = iStartLength + 16
		end
	end
	return t 
end


--- 服务器下发进入游戏玩家头像信息
--- @param buffer byte[]
function RoomController:RespBrodUserInfo(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRespBrodGameUserInfo,buffer)
	-- print( "玩家ID：",msg.m_unUIN)
	-- print("玩家头像ID：",msg.m_byUserImgID)
	-- print("玩家机器人标识：",msg.m_byRobotFlag)
	local data = {}
	data.uiUserID = msg.m_unUIN
	data.iUserType = msg.m_byRobotFlag
	data.iImageNO = msg.m_byUserImgID
	RoomModel.GetInstance():DispatchEvent(EventName.CRespBrodGameUserInfo,data)
end

function RoomController:GameStateCompeleted()
	self:ShowTiYanChangTip2()
end

function RoomController:ShowTiYanChangTip2()
	local room =self.model.CurrentRoomInfo
    if room ~= nil then
      if(room.m_nFlag == 1) then
        --体验场
		local showBoxData ={}
		showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
		showBoxData.context = "CLIENT_TIP_100" --内容；
		showBoxData.enterCB = nil--：点击确定返回；

		showBoxData.cancelCB = function()
			--退出游戏
			self:ReqQuitGame(GameController:GetInstance().desk)
		end--：点击取消返回，
		showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
		showBoxData.isHideAll = false--:隐藏所有按钮;
		showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
      end
    end
end

function RoomController:ShowTiYanChangTip()
	--旧方法，游戏未及时更新，先不删除
end

function RoomController:GetInstance( ... )
	if RoomController.instance==nil then
		RoomController.instance=RoomController.New()
	end
	return RoomController.instance
end

function RoomController:__delete( ... )
	self:RemoveEvent()
end