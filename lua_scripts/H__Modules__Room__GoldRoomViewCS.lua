GoldRoomViewCS = GoldRoomViewCS or BaseClass()

function GoldRoomViewCS:__init(gameID,desk)
	print("金币View_c#")
	--加载新场景
	-- LuaEvent:DispatchEvent(EventName.GameLoadAddTotal2)
	self.gameID=gameID
	self.desk=desk
	LuaToCSBridge.g_iGameID=gameID
	LuaToCSBridge.g_iDeskPeople=self.desk.uDeskPeople
	LuaToCSBridge.g_iDeskIndex=self.desk.m_usDeskIndex
	LuaToCSBridge.g_iGameRoomID=self.desk.m_usRoomID
	--实例化游戏的资源
	self.model=RoomModel:GetInstance()
	self:AddEvent()
	local name = "GameGroup.prefab"
	local path = "Phone/Prefab/Game/GameGroup.unity3d"
	local cb = function ( obj )
		local prefab = obj[0]
		if prefab ~=nil then
			self.obj = GameObject.Instantiate(prefab)
			self.obj.transform.parent = nil
			self.obj.transform.localScale = Vector3.one
			self.obj.transform.localPosition = Vector3.zero
			self.obj:SetActive(true)
			self.m_GameManager=self.obj:GetComponent(typeof(CS.GameBase))
			--如果是捕鱼，载入通用界面
		end
		prefab = nil
		-- resMgr:UnLoadAssetBundle(gameID,"Phone/Prefab/Game/GameGroup.unity3d",false)
		Resources:UnloadUnusedAssets()
		--载入游戏入口
	end
	resMgr:LoadResourcePackerInfoSet(gameID,nil,nil)
	resMgr:LoadPrefabEx(gameID,path,name,cb)
end

function GoldRoomViewCS:AddEvent(  )
	LuaEvent:AddEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:AddEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

function GoldRoomViewCS:RemoveEvent()
	self.model:RemoveEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:RemoveEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	self.model:RemoveEventListener(RoomConst.RSRspUserCheckOutGameCoin,self.RspUserCheckOutGameCoin,self)
	LuaEvent:RemoveEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:RemoveEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

function GoldRoomViewCS:ReLoginSuccessCompleted()
	local iMoney = (PlayerInfoController:GetInstance().model.mainPlayer.iMoney);
	local send={}
	send.m_unUin=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID or 0
	send.m_usGameID=self.desk.m_usGameID or 0
	send.m_usRoomID=self.desk.m_usRoomID  or 0
	send.m_usDeskIndex=self.desk.m_usDeskIndex
	send.m_bDeskStation=self.desk.m_usDeskStation
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
	RoomController:GetInstance():ReqChooseDeskEnterGame2(send)
end

function GoldRoomViewCS:ReEnterGame(gameID,desk)
	if self.gameID~=gameID then error("重新进入的游戏id与目前的房间group不一致") return end
	self.desk=desk
	local msgpaa=CRspEnterGameMsgPara() --安装C#的数据
	msgpaa.m_sResult=0
	msgpaa.m_unUin=self.desk.m_unUin
	msgpaa.m_usDeskIndex=self.desk.m_usDeskIndex
	msgpaa.m_usDeskStation=self.desk.m_usDeskStation
	msgpaa.m_usRoomID=self.desk.m_usRoomID
	--安装C#的用户列表数据
	local toCSTable={}
	for _,u in pairs(self.desk.DeskUsers) do
		local t=SUserBaseInfo()
		t.uiUserID=u.uiUserID
		t.iDeskNO=u.iDeskNO
		t.iDeskStation=u.iDeskStation
		t.iRoomID=u.iRoomID
		t.iMoney=u.iMoney
		t.szNickName=u.szNickName
		t.bBoy=u.bBoy
		table.insert(toCSTable,t)
	end
	local DeskUsers=LuaToCSBridge.DeskUserLuaToCS(toCSTable,#toCSTable)
	self.m_GameManager:EnterGame(msgpaa,DeskUsers)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
end

function GoldRoomViewCS:GameResLoadCompeleted()
	self.model:AddEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:AddEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	self.model:AddEventListener(RoomConst.RSRspUserCheckOutGameCoin,self.RspUserCheckOutGameCoin,self)
	local msgpaa=CRspEnterGameMsgPara() --安装C#的数据
	msgpaa.m_sResult=0
	msgpaa.m_unUin=self.desk.m_unUin
	msgpaa.m_usDeskIndex=self.desk.m_usDeskIndex
	msgpaa.m_usDeskStation=self.desk.m_usDeskStation
	msgpaa.m_usRoomID=self.desk.m_usRoomID
	--安装C#的用户列表数据
	local toCSTable={}
	for _,u in pairs(self.desk.DeskUsers) do
		local t=SUserBaseInfo()
		t.uiUserID=u.uiUserID
		t.iDeskNO=u.iDeskNO
		t.iDeskStation=u.iDeskStation
		t.iRoomID=u.iRoomID
		t.iMoney=u.iMoney
		t.szNickName=u.szNickName
		t.bBoy=u.bBoy
		table.insert(toCSTable,t)
	end
	local DeskUsers=LuaToCSBridge.DeskUserLuaToCS(toCSTable,#toCSTable)
	SoundManager:GetInstance():StopBGMusic()
	self.m_GameManager:EnterGame(msgpaa,DeskUsers)
end


--[[
mDeskUser.uiUserID=userInfoSvr.m_unUin
mDeskUser.iGameID=userInfoSvr.m_usGameID
mDeskUser.iRoomID=userInfoSvr.m_usRoomID
mDeskUser.iDeskNO=userInfoSvr.m_usDeskIndex
mDeskUser.iDeskStation=userInfoSvr.m_usDeskStation
mDeskUser.iMoney=userInfoSvr.m_unMoney
mDeskUser.szNickName=CommonUtil.LuaTableToStringNoEmpty(userInfoSvr.m_szNickName)
mDeskUser.bBoy= userInfoSvr.m_usSex==1
--]]

function GoldRoomViewCS:PlayerEnterRoom( context )
	local userInfo=context

    if userInfo and tonumber(userInfo.iGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.iRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.iDeskNO)==tonumber(self.desk.m_usDeskIndex)  then
		local t=CRspOtherPlayerEnterRoom()
		t.m_unUin=userInfo.uiUserID
		t.m_usDeskIndex=userInfo.iDeskNO
		t.m_usDeskStation=userInfo.iDeskStation
		t.m_usRoomID=userInfo.iRoomID
		t.m_unMoney=userInfo.iMoney
		t.m_szNickName=CommonUtil.ByteArrayToString(userInfo.szNickName)
		if userInfo.bBoy then
			t.m_usSex=1
		else
			t.m_usSex=0
		end
		self.m_GameManager:PlayerEnterRoom(t)
    end


end





function GoldRoomViewCS:PlayerLeaveRoom( context )
	local userInfo=context
    if userInfo and tonumber(userInfo.m_usGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.m_usRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.m_usDeskIndex)==tonumber(self.desk.m_usDeskIndex)  then
		local t=CRspOtherPlayerLeaveRoom()
		t.m_unUin=userInfo.m_unUin
		t.m_usGameID=userInfo.m_usGameID
		t.m_usRoomID=userInfo.m_usRoomID
		t.m_usDeskIndex=userInfo.m_usDeskIndex
		t.m_usDeskStation=userInfo.m_usDeskStation
		t.m_unMoney=userInfo.m_unMoney
		t.m_unFlag=userInfo.m_unFlag
		t.m_ussex=userInfo.m_ussex
		self.m_GameManager:PlayerLeaveRoom(t)
    end
	
end


--上分协议返回
function GoldRoomViewCS:RspUserCheckOutGameCoin( context )
	-- body

	local msg = context
	local data = RSRspUserCheckOutGameCoin()
	data.m_usResultID = msg.m_usResultID
	data.m_unUin = msg.m_unUin
	data.m_un64CheckoutGameCoin = msg.m_un64CheckoutGameCoin
	data.m_byCheckFlag = msg.m_byCheckFlag
	self.m_GameManager:RspUserCheckOutGameCoin(data)
end

function GoldRoomViewCS:QuitGame()
	-- GameObjectDestroy(self.obj)
	if self.gameID~=nil then
		resMgr:UnLoadAssetBundle(self.gameID,"Phone/Prefab/Game/GameGroup.unity3d",true)
	end

	--销毁大厅通用界面
	Resources:UnloadUnusedAssets()
	self:GameBackToHallUI()
	-- CS_SceneManager.LoadSceneAsync("Hall")
	--播放大厅的音乐
	SoundManager:GetInstance():ResumeBGMusic(true)
end

function GoldRoomViewCS:DestroyGameRes()
	GameObjectDestroy(self.obj)
	if self.gameID~=nil then
		resMgr:UnLoadAssetBundle(self.gameID,"Phone/Prefab/Game/GameGroup.unity3d",true)
	end
	--销毁大厅通用界面
	Resources:UnloadUnusedAssets()
	--resMgr:UnloadGameAssetBundle(self.gameID)
	--播放大厅的音乐
	SoundManager:GetInstance():ResumeBGMusic(true)
end

function GoldRoomViewCS:GameBackToHallUI()
	SceneManager:GetInstance():GameToHallScene(self.gameID)
end

function GoldRoomViewCS:__delete( ... )
	self:RemoveEvent()
	self.gameID=nil
	GameObjectDestroy(self.obj)
	self.obj=nil
	self.model=nil
	LuaToCSBridge.g_iGameID=0
	LuaToCSBridge.g_iDeskPeople=0
	LuaToCSBridge.g_iDeskIndex=0
	LuaToCSBridge.g_iGameRoomID=0
	self.m_GameManager=nil
end