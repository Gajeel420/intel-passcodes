GoldRoomView=GoldRoomView or BaseClass()

function GoldRoomView:__init( gameID,desk )
	print("金币View",gameID)
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
	--实例化游戏的资源
	local name = "GameGroup.prefab"
	local path = "Phone/Prefab/Game/GameGroup.unity3d"
	local cb = function ( obj )
		if obj~=nil and obj.Length>0 and obj[0] ~=nil then
			local prefab = obj[0]
			self.obj = GameObject.Instantiate(prefab)
			self.obj.transform.parent = nil
			self.obj.transform.localScale = Vector3.one
			self.obj.transform.localPosition = Vector3.zero
			self.obj:SetActive(true)
			prefab = nil
			Resources:UnloadUnusedAssets()
			self:StartGameLua(gameID,self.obj)
		else
			print("游戏资源加载有问题")
		end
		-- resMgr:UnLoadAssetBundle(self.gameID,"Phone/Prefab/Game/GameGroup.unity3d",false)
		--载入游戏入口
	end
	
	resMgr:LoadResourcePackerInfoSet(gameID,nil,nil)
	resMgr:LoadPrefabEx(gameID,path,name,cb)
end

function GoldRoomView:AddEvent(  )
	LuaEvent:AddEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:AddEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

function GoldRoomView:RemoveEvent(  )
	self.model:RemoveEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:RemoveEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	LuaEvent:RemoveEventListener(EventName.RSRspUserCheckOutGameCoin,self.RSRspUserCheckOutGameCoin,self)
	LuaEvent:RemoveEventListener(EventName.GameResLoadCompeleted,self.GameResLoadCompeleted,self)
	LuaEvent:RemoveEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.ReLoginSuccessCompleted,self)
end

--实例化游戏资源完成，载入游戏lua入口
function GoldRoomView:StartGameLua(gameId,obj)


	local requirePath = StringFormat("G/{0}/GameController",gameId)
	--print(gameId,"gameID")
	require(requirePath)
	--print("requirePath",requirePath,obj,GameController:GetInstance())
	
	GameController:GetInstance():Init(obj) --获取管理器

	-- self.model:FillPlayerList() --填充房间内玩家数据
	-- GameController:GetInstance():EnterGame(self.desk)
	-- UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
end

function GoldRoomView:GameResLoadCompeleted()
	self.model:AddEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:AddEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
	LuaEvent:AddEventListener(EventName.RSRspUserCheckOutGameCoin,self.RSRspUserCheckOutGameCoin,self)
	-- SceneManager:GetInstance():HallToGameScene()
	SoundManager:GetInstance():StopBGMusic()
	print("GameResLoadCompeletedGameResLoadCompeleted")
	pt(self.desk)

	GameController:GetInstance():EnterGame(self.desk)

	--开始监听断线重连问题
end

function GoldRoomView:RSRspUserCheckOutGameCoin( context )
	-- body
	local data = context.m_data[0]
	if GameController:GetInstance().SRspUserCheckOutGameCoin  then
		GameController:GetInstance():SRspUserCheckOutGameCoin(data)
	end
end

function GoldRoomView:ReLoginSuccessCompleted()
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

function GoldRoomView:ReEnterGame(gameID,desk)
	if self.gameID~=gameID then error("重新进入的游戏id与目前的房间group不一致") return end
	self.desk=desk
	pt(desk.DeskUsers[desk.m_usDeskIndex])
	GameController:GetInstance():EnterGame(self.desk)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameLoad)
end

function GoldRoomView:QuitGame()
	if GameController:GetInstance()~=nil then
		GameController:GetInstance():Destroy()
	end
	local requirePath = StringFormat("G/{0}/GameController",self.gameID)
	-- local path=LuaManager:ReadFileOnDestroy(requirePath)
	GameController.instance=nil
	GameController=nil
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
	-- CS_SceneManager.UnloadSceneAsync("Game")
	-- CS_SceneManager.LoadSceneAsync("Hall")
	SoundManager:GetInstance():ResumeBGMusic(true)
end

function GoldRoomView:DestroyGameRes()
	if GameController:GetInstance()~=nil then
		GameController:GetInstance():Destroy()
	end
	local requirePath = StringFormat("G/{0}/GameController",self.gameID)
	-- local path=LuaManager:ReadFileOnDestroy(requirePath)
	GameController.instance=nil
	GameController=nil
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
	SoundManager:GetInstance():ResumeBGMusic(true)
end

function GoldRoomView:GameBackToHallUI()
	SceneManager:GetInstance():GameToHallScene(self.gameID)
end



function GoldRoomView:PlayerEnterRoom( context )
	local userInfo=context

    if userInfo and tonumber(userInfo.iGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.iRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.iDeskNO)==tonumber(self.desk.m_usDeskIndex)  then
		if GameController:GetInstance().PlayerEnterRoom then
			GameController:GetInstance():PlayerEnterRoom(userInfo)
		end
    end

end




function GoldRoomView:PlayerLeaveRoom( context )
	local userInfo=context

    if userInfo and tonumber(userInfo.m_usGameID) ==tonumber(self.desk.m_usGameID) and  tonumber(userInfo.m_usRoomID) ==tonumber(self.desk.m_usRoomID) 
	and tonumber(userInfo.m_usDeskIndex)==tonumber(self.desk.m_usDeskIndex)  then
		local deskStation=userInfo.m_usDeskStation
		if GameController:GetInstance().PlayerLeaveRoom then
			GameController:GetInstance():PlayerLeaveRoom(deskStation)
		end
    end

end




function GoldRoomView:__delete( ... )
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