BeiKeXunBaoManager = BeiKeXunBaoManager or BaseClass(GameLuaController)

local Instance=nil
function BeiKeXunBaoManager:__init(gameObject,clientID)
	--  Instance=self
	--  self.panel = nil
	-- self.IsFirst=true
	-- self.parent	= gameObject
	-- self.clientID = clientID
	-- self.beiKeObj = nil
	-- self:BuildScripts()
	-- self:AddEvent()
	-- self:PrfabLoadRes()
end

-- function BeiKeXunBaoManager.GetInstance()
-- 	if Instance then
-- 		return Instance
-- 	else

-- 		print("GamePlayerListManager单利不存在")
-- 	end
-- end

-- function BeiKeXunBaoManager:AddEvent()
-- 	LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)
-- end

-- function BeiKeXunBaoManager:RemoveEvent()
-- 	LuaEvent:RemoveEventListener(EventName.GameNetDispatchData,self.HandleData,self)
-- end


-- function BeiKeXunBaoManager:HandleData(context)
-- 	if context == nil or context.m_data == nil then return end
-- 	local clientID = context.m_data[0]
-- 	local headStruct = context.m_data[1]
-- 	local buffer = context.m_data[2]
-- 	local state = context.m_data[3]
-- 	--print("----LuckFootBallManager--------",headStruct.dwAssistantID)

-- 	if headStruct.dwAssistantID==BeiKeXunBaoLuaDefine.LUCK_GAME_TYPE.GAMESHELLSEARCH_MSG_START then
-- 		local msg=self:ParseMsg(BeiKeXunBaoLuaDefine.ShellSearchStart,buffer)
-- 		local direction=GameController:GetInstance():GetFishPlayerDirection(msg.uReserved)
-- 		local name =GameController:GetInstance().view.m_playerGroups[direction].m_uilabelPlayerName.text
-- 		self:ShowGamePanel(name)
-- 	elseif headStruct.dwAssistantID==BeiKeXunBaoLuaDefine.LUCK_GAME_TYPE.GAMESHELLSEARCH_MSG_OPENSHELL_RESULT then
-- 		local msg=self:ParseMsg(BeiKeXunBaoLuaDefine.OpenShellResult,buffer)
-- 		self.panel:ResponseOpenBeikeData(msg)
-- 	elseif headStruct.dwAssistantID==BeiKeXunBaoLuaDefine.LUCK_GAME_TYPE.GAMESHELLSEARCH_MSG_CLICKBIGSHELL_RESULT then
-- 		local msg=self:ParseMsg(BeiKeXunBaoLuaDefine.ClickBigShellResult,buffer)
-- 		self.panel:ResponseHitBigBeiKeData(msg)
-- 	elseif headStruct.dwAssistantID==BeiKeXunBaoLuaDefine.LUCK_GAME_TYPE.GAMESHELLSEARCH_MSG_BEIKEGAME_RESULT then
-- 		local msg=self:ParseMsg(BeiKeXunBaoLuaDefine.S_Result_BEIKE,buffer)
-- 		self.panel:ShowMiniGame_JieSuan_defen(msg)
-- 	end
-- end

-- function BeiKeXunBaoManager:SendGame()
	
-- end

-- function BeiKeXunBaoManager:BuildScripts( ... )
-- 	-- body
-- 	local control=GameController.GetInstance()
-- 	table.insert(control.RequireList,"G/"..self.clientID.."/View/MinGame/BeiKeXunBao/BeiKeXunBaoLuaDefine")
-- 	--table.insert(control.RequireList,"G/"..self.clientID.."/View/MinGame/BeiKeXunBao/BeiKeGameTimeManager" )
-- 	table.insert(control.RequireList,"G/"..self.clientID.."/View/MinGame/BeiKeXunBao/BeiKeXunBaoPanel" )
-- 	self:RequireLuaScript()
-- end



-- function BeiKeXunBaoManager:PrfabLoadRes()
-- 	self:LoadPrefab(self.clientID)
-- end


-- function BeiKeXunBaoManager:ShowGamePanel( name )
-- 	-- body
-- 	if self.panel then
	
-- 		self.panel:ShowPanel(name,self.beiKeObj)
-- 	else
-- 		--self:LoadPrefab(self.clientID)
-- 	end
-- end

-- function BeiKeXunBaoManager:LoadPrefab( gameId )

--   	local name = "BeiKe_XunBao.prefab"
--   	local path = "Phone/Prefab/MinNi_Game/beikexunbao/BeiKe_XunBao.unity3d"
-- 		local cb = function ( obj )
--         if obj~=nil and obj.Length>0 and obj[0] ~=nil then
--             local prefab= obj[0]
--            	local go = GameObject.Instantiate(prefab)
--             go.transform.parent = self.parent.transform
--             go.transform.localScale = Vector3.one
--             go.transform.localPosition = Vector3.zero
--             go:SetActive(false)
--             prefab = nil
--             obj[0] = nil
-- 						Resources:UnloadUnusedAssets()
-- 						self.beiKeObj = go
-- 						self.panel=BeiKeXunBaoPanel.New(go)
--           --  self:ShowEnterGamePanel(self.FootBallData)
--         else
-- 				print("游戏资源加载有问题111111111111111111")
--         end
-- 		end
-- 		resMgr:LoadAssetImmediate(gameId,path,name,typeof(GameObject),cb)
-- end



-- function BeiKeXunBaoManager:RequireLuaScript()
-- 	for i=1,#GameController.GetInstance().RequireList do
-- 		--print("加载脚本：",GameController.GetInstance().RequireList[i])
-- 		require(GameController.GetInstance().RequireList[i])
-- 	end
-- 	--print("LuckFootBallManager")
-- end



-- function BeiKeXunBaoManager:__delete( ... )
-- 	self:RemoveEvent()
-- 	self.panel = nil
-- 	-- if self.panel then
-- 	-- 	self.panel:Destroy()
-- 	-- end
-- 	-- if self.tips then
-- 	-- 	self.tips:Destroy()
-- 	-- end
-- end