CardRoomView =CardRoomView or BaseClass()

function CardRoomView:__init( gameID,desk )
	print("房卡View")
	self.gameID=gameID
	self.desk=desk
	local luaPath = StringFormat("lua",gameID)
	LuaManager:AddLuaPath(gameID) --添加路径
	if  ConfigInfoMgr.useHotFunction == false then
	else
		LuaManager:AddLuaBundle(gameID,luaPath)
	end	
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
	self.model=RoomModel:GetInstance()
	self:AddEvent()
end

function CardRoomView:AddEvent(  )
	self.model:AddEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:AddEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
end

function CardRoomView:RemoveEvent(  )
	self.model:RemoveEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
	self.model:RemoveEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)

end
--实例化游戏资源完成，载入游戏lua入口
function CardRoomView:StartGameLua(gameId,obj)
	local requirePath = StringFormat("G/{0}/GameController",gameId)
	require(requirePath)
	GameController:GetInstance():Init(obj) --获取管理器
	--加载大厅的界面
		GameController:GetInstance():EnterGame(self.desk)
	UIKFCGameController:GetInstance():CreatePanel(obj,gameId,self.desk.usUserCount,self.desk,function ( )
	end)
end

function CardRoomView:QuitGame()
	if GameController:GetInstance()~=nil then
		GameController:GetInstance():Destroy()
	end
	local requirePath = StringFormat("G/{0}/GameController",self.gameID)
	GameController.instance=nil
	GameController=nil
	package.loaded[requirePath] = nil
	-- package.preload[requirePath]=nil
	if self.gameID~=nil then
		print("self.gameIDself.gameID",self.gameID)
		resMgr:UnLoadAssetBundle(self.gameID,"Phone/Prefab/Game/GameGroup.unity3d",true)
	end
	--销毁大厅通用界面
	UIKFCGameController:GetInstance():DestroyPanel()
	Resources:UnloadUnusedAssets()
	--resMgr:UnloadGameAssetBundle(self.gameID)
	SceneManager:GetInstance():GameToHallScene(self.gameID)
end

function CardRoomView:PlayerEnterRoom( context )
	local userInfo=context
	GameController:GetInstance():PlayerEnterRoom(userInfo)
end

function CardRoomView:PlayerLeaveRoom( context )
	local msg=context
	local deskStation=msg.m_usDeskStation
	GameController:GetInstance():PlayerLeaveRoom(deskStation)
end




function CardRoomView:__delete( ... )
	self:RemoveEvent()
	self.gameID=nil
	GameObjectDestroy(self.obj)
	self.obj=nil
	self.model=nil
end