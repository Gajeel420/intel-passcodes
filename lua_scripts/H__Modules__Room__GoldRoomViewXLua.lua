GoldRoomViewXLua=GoldRoomViewXLua or BaseClass()
function GoldRoomViewXLua:__init( gameID,desk )
	LuaEvent:DispatchEvent(EventName.GameLoadAddTotal2)
	self.gameID=gameID
	self.desk=desk
	local luaPath = StringFormat("lua",gameID)
	LuaManager:AddLuaPath(gameID) --添加路径
	if ConfigInfoMgr.useHotFunction == false then
	else
		LuaManager:AddLuaBundle(gameID,luaPath)
	end	
	self.model=RoomModel:GetInstance()
	self:AddEvent()
	print("GoldRoomViewXLua",gameID)
	--实例化游戏的资源
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
		end
		prefab = nil
		-- Resources:UnloadUnusedAssets()
		--载入游戏入口
		self:StartGameLua(gameID,self.obj)

	end
	resMgr:LoadPrefabEx(gameID,path,name,cb)
end

function GoldRoomViewXLua:AddEvent()
	LuaEvent:AddEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:AddEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

function GoldRoomViewXLua:RemoveEvent()
	self.model:RemoveEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:RemoveEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	LuaEvent:RemoveEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:RemoveEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

--实例化游戏资源完成，载入游戏lua入口
function GoldRoomViewXLua:StartGameLua(gameId,obj)
	local requirePath = StringFormat("G/{0}/GameManager",gameId)
	require(requirePath)
	GameManager:GetInstance():_Init(obj) --获取管理器
	-- self.model:FillPlayerList() --填充房间内玩家数据
	-- GameController:GetInstance():EnterGame(self.desk)
	-- UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
end

function GoldRoomViewXLua:GameResLoadCompeleted()
	self.model:AddEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:AddEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	GameManager:GetInstance():EnterGame(self.desk)
end

function GoldRoomViewXLua:ReLoginSuccessCompleted()
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

function GoldRoomViewXLua:ReEnterGame(gameID,desk)
	if self.gameID~=gameID then error("重新进入的游戏id与目前的房间group不一致") return end
	self.desk=desk
	GameManager.GetInstance():EnterGame(self.desk)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
end

function GoldRoomViewXLua:QuitGame()
	if GameManager:GetInstance()~=nil then
		GameManager:GetInstance():Destroy()
	end
	local requirePath = StringFormat("G/{0}/GameManager",self.gameID)
	-- local path=LuaManager:ReadFileOnDestroy(requirePath)
	GameManager.instance=nil
	GameManager=nil
	-- requirePath = StringFormat("GameController",self.gameID)
	-- print(">>>>>>>>>>>>>>>>>>>",path)
	-- print(">>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<",package.loaded[requirePath])
	package.loaded[requirePath] = nil
	-- package.preload[requirePath]=nil
	if self.gameID~=nil then
		resMgr:UnLoadAssetBundle(self.gameID,"Phone/Prefab/Game/GameGroup.unity3d",true)
	end
	--销毁大厅通用界面
	Resources:UnloadUnusedAssets()
	--resMgr:UnloadGameAssetBundle(self.gameID)
	self:GameBackToHallUI()
	SoundManager:GetInstance():ResumeBGMusic(true)
	
end

function GoldRoomViewXLua:GameBackToHallUI()
	SceneManager:GetInstance():GameToHallScene(self.gameID)
end



function GoldRoomViewXLua:PlayerEnterRoom( context )
	local userInfo=context

    if userInfo and tonumber(userInfo.iGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.iRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.iDeskNO)==tonumber(self.desk.m_usDeskIndex)  then
		if GameController:GetInstance().PlayerEnterRoom then
			GameController:GetInstance():PlayerEnterRoom(userInfo)
		end

    end




end

--[[
--其他玩家离开游戏返回
NetworkDefine.CRspOtherPlayerLeaveRoom={
	{"m_unUin", "Int32", 0},--
	{"m_usGameID", "UInt16", 0},--
	{"m_usRoomID", "UInt16", 0},--房间id
	{"m_usDeskIndex", "UInt16", 0},--桌子索引,从0开始
	{"m_usDeskStation", "UInt16", 0},--座位号
	{"m_unMoney", "Int64", 0},--身上的钱
	{"m_unFlag", "Int32", 0},--坐下游戏的标志
	{"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--坐下游戏的标志
	{"m_usSex", "UInt16", 0},--性别
}
--]]


function GoldRoomViewXLua:PlayerLeaveRoom( context )
	local userInfo=context

    if userInfo and tonumber(userInfo.m_usGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.m_usRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.m_usDeskIndex)==tonumber(self.desk.m_usDeskIndex)  then
		local deskStation=userInfo.m_usDeskStation
		if GameController:GetInstance().PlayerLeaveRoom then
			GameController:GetInstance():PlayerLeaveRoom(deskStation)
		end
    end

end




function GoldRoomViewXLua:__delete( ... )
	self:RemoveEvent()
	GameObjectDestroy(self.obj)
	if ConfigInfoMgr.useHotFunction == false then
	else
		LuaManager:RemoveLuaBundle(self.gameID)
	end
	self.gameID=nil
	self.obj=nil
	self.model=nil
end