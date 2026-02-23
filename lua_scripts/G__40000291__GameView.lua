GameView=BaseClass()

function GameView:__init( obj )
	self.obj=obj
	self.transform=obj.transform
	self.m_fishPrefabs={}
	self.m_haiWang3PackPrefabs ={}
	self.m_playerPackPrefabs ={}
	self.m_PlayerGroupPrefabs = {}
	self.m_bulletPrefabs={}
	self.m_netPrefabs={}
	self.m_explosivePrefabs={}
	self.m_fishMoneyPrefabs={}
	self.m_thunderPrefabs={}
	self.m_floatNumPrefabs={}
	self.m_goldTeamAddPrefabs={}
	self.m_dropObjPrefabs = {}
	self.m_killLeiShePrefabs = {}
	self.m_zuanTouPrefabs = {}
	self.m_poolBullets=nil
	self.m_poolNets=nil
	self.m_poolExplosive=nil
	self.m_poolFishMoney=nil
	self.m_poolThunder=nil
	self.m_poolFloatNum=nil
	self.m_poolFish=nil
	self.m_poolGoldTeamAdd=nil
	self.m_poolDrop = nil
	self.m_poolKillLeiShe = nil
	self.eYuflag = false
	self.IsOpen=false
	self.m_poolZuanTou = nil

	self.FishDieSoundCount = 0
	self.FishDieSoundTime = 1

	self.gameID = GameController.GetInstance().gameID
	self:Find()
	RenderMgr.Remove("HallGamePanel:OnUpdate")

	RenderMgr.Add(function()
	  	GameController:GetInstance():Update()
		end,"Game"..self.gameID.."Update")
end

function GameView:Find( ... )
	
	FishComManager.Init(GameModel:GetInstance().ResolutionWidth,GameModel:GetInstance().ResolutionHeight);
	self.m_tranParentPlayer=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group")
	self.waitPlayer = {}
	self.comePlayer = {}
	self.outPlayer = {}
	for i =1,4 do
		self.waitPlayer[i] = self.m_tranParentPlayer:Find("P"..i.."/WaitingPalyer").gameObject
		self.comePlayer[i] = self.m_tranParentPlayer:Find("P"..i.."/Tip_PlayerCome").gameObject
		self.outPlayer[i] = self.m_tranParentPlayer:Find("P"..i.."/Tip_PlayerOut").gameObject
		self.waitPlayer[i]:SetActive(true)
		self.comePlayer[i]:SetActive(false)
		self.outPlayer[i]:SetActive(false)
	end
	
	self.m_poolBullets=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Bullet"):GetComponent(typeof(SpawnPool))
	self.m_poolNets=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Net"):GetComponent(typeof(SpawnPool))
	self.m_poolFish=self.transform:Find("GameUI/PanelFirst/UIstretch/Group/Pool_Fish"):GetComponent(typeof(SpawnPool))
	self.m_poolExplosive=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Effect_Explosive"):GetComponent(typeof(SpawnPool))
	self.m_poolFishMoney=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_GoldNum"):GetComponent(typeof(SpawnPool))
	self.m_poolThunder=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Thunder"):GetComponent(typeof(SpawnPool))
	self.m_poolFloatNum=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Gold"):GetComponent(typeof(SpawnPool))
	self.m_poolGoldTeamAdd=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_GoldTeamAdd"):GetComponent(typeof(SpawnPool))
	self.m_poolDrop=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_Drop"):GetComponent(typeof(SpawnPool))
	self.m_poolKillLeiShe=self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_KillLeiShe"):GetComponent(typeof(SpawnPool))
	self.m_poolZuanTou =  self.transform:Find("GameUI/PanelSecond/UIstretch2/Group/Game_Group/Pool_ZuanTou"):GetComponent(typeof(SpawnPool))
	self.m_sliderBackground=self.transform:Find("GameUI/PanelFirst/UIstretch/Group/BG_Group/Progress Bar"):GetComponent(typeof(UISlider))
	self.m_sliderBackground.thumb.gameObject:SetActive(false);

	self.m_sliderBackground.value = 1;
	self.qiPaoEffect = self.transform:Find("GameUI/PanelFirst/UIstretch/Group/BG_Group/Progress Bar/Particle_QiPao").gameObject
	self.qiPaoEffect:SetActive(false)
	self.m_asWave=self.m_sliderBackground.gameObject:AddComponent(typeof(AudioSource))
	self.m_asWave.volume=GameModel:GetInstance().soundVolume
	self.m_tranParentFish=self.transform:Find("GameUI/PanelFirst/UIstretch/Group/FishParent")
	self.m_collider = self.transform:Find("GameUI/PanelFirst/UIstretch/Group/FishParent").gameObject
	local _lb=self.m_collider:GetComponent(typeof(LuaBehaviour))
	if not _lb then
		_lb=self.m_collider:AddComponent(typeof(LuaBehaviour))
	end
	_lb.onPressCallBack=function(press) self:UIPressMouse(press) end
	self.m_camUI=self.transform:Find("GameUI/Camera_UI"):GetComponent(typeof(Camera))
	self.m_camFish=self.transform:Find("GameUI/Camera_Fish"):GetComponent(typeof(Camera))
	self.leftPanelRoot=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel")
	self.objPlistBtn=self.leftPanelRoot:Find("Plist/Down").gameObject
	UIEventListener.Get(self.objPlistBtn).onClick=function() self:OnClickPlistBtn() end
	self.tranPlistRoot=self.leftPanelRoot:Find("Plist")
	self.tranPlistRootAnimator = self.tranPlistRoot:GetComponent(typeof(Animator))
	self.objOddBtn=self.tranPlistRoot:Find("Info").gameObject
	UIEventListener.Get(self.objOddBtn).onClick=function() self:OnClickOddBtn() end
	self.objSettingBtn=self.tranPlistRoot:Find("Chilun").gameObject
	UIEventListener.Get(self.objSettingBtn).onClick=function() self:OnClickSettingBtn() end
	self.objExitBtn=self.tranPlistRoot:Find("Exit").gameObject
	UIEventListener.Get(self.objExitBtn).onClick=function() self:OnClickExitBtn() end
	--self.tranPlistRoot.gameObject:SetActive(false)
	--self.objPlistBtn:GetComponent(typeof(UISprite)).spriteName="bt_down"
	--
	self.functionControlAnimator = self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1"):GetComponent(typeof(Animator))

	self.m_objLockBtn=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Lock/On").gameObject;
	self.closeLockBtn=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Lock/Off").gameObject
	self.closeLockBtn:SetActive(false)
	UIEventListener.Get(self.m_objLockBtn).onClick = function(go) self:OnClickLockBtn(go) end
	UIEventListener.Get(self.closeLockBtn).onClick = function(go) self:OnClickLockBtn(go) end
	self.m_objAutoShootBtn=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Auto/On").gameObject
	self.m_closeAutoShootBtn=self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Auto/Off").gameObject
	--self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Auto/Off").gameObject:SetActive(false)
	self.m_closeAutoShootBtn:SetActive(false)
	UIEventListener.Get(self.m_objAutoShootBtn).onClick = function(go) self:OnClickAutoShootBtn(go) end
 	UIEventListener.Get(self.m_closeAutoShootBtn).onClick = function(go) self:OnClickAutoShootBtn(go) end

	self.m_fastShootBtn = self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/On").gameObject
	self.m_colsefastShootBtn = self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/Off").gameObject
	self.m_colsefastShootBtn:SetActive(false)
	UIEventListener.Get(self.m_fastShootBtn).onClick = function(go) self:OnClickFastShootBtn(go) end
	UIEventListener.Get(self.m_colsefastShootBtn).onClick = function(go) self:OnClickFastShootBtn(go) end

	--self.m_camShake=self.transform:Find("GameUI/ShakeCam")
	--self.m_camShake=CameraShake.New(self.m_camShake)
	self.m_objTideTips=self.transform:Find("GameUI/PanelSecond/UIstretch3/PanelTop/YuzhenTips").gameObject;
	self.m_objTideLabel = self.m_objTideTips.transform:Find("Lable"):GetComponent(typeof(UILabel))
	self.m_objTideTips:SetActive(false);
	-- self.m_tranSettingPanel=self.transform:Find("GameUI/PanelSecond/UIstretch3/Hall_SettingPanel")
	-- self.m_uiSettingPanel=SettingPanel.New(self.m_tranSettingPanel)
	-- self.m_uiSettingPanel:Close()
	-- --
	-- self.objPanelOdd=self.transform:Find("GameUI/PanelSecond/UIstretch3/PanelOdds").gameObject
	-- self.objPanelOdd:SetActive(false)
	-- self.panelOdd=UIOddPanel.New(self.objPanelOdd.transform)
	self.m_centerPoint = self.transform:Find("GameUI/PanelSecond/CenterPoint").gameObject;
	--self.BeiKeXunBaoManager = BeiKeXunBaoManager.New(self.m_centerPoint.transform.parent,self.gameID)
	--uiroot
	self.uiRoot= self.transform:Find("GameUI"):GetComponent(typeof(UIRoot));
	self.ratio=1
	self:CalScreen()
	GameObject.Destroy(self.transform.gameObject:GetComponent("Rigidbody"))
  -- self.box_crocodile=self.transform:Find("GameUI/PanelSecond/Box_Crocodile"):GetComponent(typeof(LuaBehaviour))
	-- if not self.box_crocodile then
	-- 		self.box_crocodile=self.gameObject:AddComponent(typeof(LuaBehaviour))
	-- end
	-- self.box_crocodile.onTriggerCallBack=function(other) self:OnTriggerEnterEyu(other) end
	-- self.collider = self.box_crocodile:GetComponent(typeof(BoxCollider))
	-- if self.ratio <= 1.8 then 
	-- 	self.collider.size = Vector3(128,250,0)
	-- else
	-- 	self.collider.size = Vector3(280,250,0)
	-- end
	--self.collider.size = Vector3(128 ,250,0)
	
end

function GameView:PlayEnterSceneAnimator()
	--self.tranPlistRootAnimator:Play("Ani_LeftSliding",0,0)
	--self.functionControlAnimator:Play("Ani_RightSliding",0,0)
end

function GameView:PlayOutSceneAnimator()

	--self.tranPlistRootAnimator:Play("Ani_LeftSliding02",0,0)
	--self.functionControlAnimator:Play("Ani_RightSliding02",0,0)
end

function GameView:StartLoadGameRes()

	self:InitPreloadQueue()
	--print("--",#self.queue)
	self:ExcuteQueue()
	--print("==",#self.queue)
	--StartCoroutine(self.GameLoaderRes,self)
end
local eyuTickId = 0

local eyuTickTicks={}

local delayTickId = 0
local  DelayTicks ={}

-- function GameView:OnTriggerEnterEyu(other)
-- 	if other.name == "EY_abc" then
-- 		delayTickId = delayTickId+1
-- 		local tickDelayName ="eyu"..eyuTickId
-- 		local skeletonAnimator = other.transform.parent:Find("SpineGameObject(KillerWhale)"):GetComponent(typeof(SkeletonAnimation))
-- 		RenderMgr.AddInterval(function()
-- 			self.eYuflag = true
-- 			skeletonAnimator.state:SetAnimation(0,"BITE",false)
-- 			end,tickName,1,1.1)
-- 		table.insert(DelayTicks,tickDelayName)

-- 		-- local skeletonAnimator = other.transform.parent:Find("SpineGameObject(KillerWhale)"):GetComponent(typeof(SkeletonAnimation))
-- 		-- skeletonAnimator.state:SetAnimation(0,"BITE",false)
-- 		-- eyuTickId=eyuTickId+1
-- 		-- local tickName="eyu"..eyuTickId
-- 		-- self.eYuflag = true
-- 		RenderMgr.AddInterval(function()
-- 			self.eYuflag = false
-- 			skeletonAnimator.state:SetAnimation(0,"SWIM",true)
-- 			end,tickName,3,3.1)
-- 		table.insert(eyuTickTicks,tickName)
-- 	end
-- end

function GameView:ExcuteQueue()
	if next(self.queue) then
		local excute=table.remove(self.queue,1)
		StartCoroutine(excute,self)
	end
end

function GameView:InitPreloadQueue()
	self.queue = {}
	table.insert(self.queue, function() 
		self.m_playerPackPrefabs ={}
		local count = #GameLuaDefine.PlayerPackRes
		for i,v in ipairs(GameLuaDefine.PlayerPackRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_playerPackPrefabs[v.name]=obj[0].transform
				else
					print("游戏资源加载有问题: ",v.path)
				end
				if count<=0 then					
					self:ExcuteQueue()
				end
				
			end
			--print("1111111111111111111111111111111111111")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	table.insert(self.queue,function()
		self.m_playerGroups={}
		self.m_PlayerGroupPrefabs = {}
		local count = #GameLuaDefine.PlayerGroupRes
		for i,v in ipairs(GameLuaDefine.PlayerGroupRes) do
			local parentPrefab = self.m_playerPackPrefabs[v.ParentName]
			print(v.name)
			local prefab =  parentPrefab.transform:Find(v.name).gameObject
			self.m_PlayerGroupPrefabs[i] = prefab
			if 	self.m_PlayerGroupPrefabs[i] ~= nil then
				local go=GameObject.Instantiate(prefab)
				go.transform.parent = self.m_tranParentPlayer:Find("P"..(i));
				go.transform.localPosition = Vector3(0, 0, 0);
				go.transform.localScale = Vector3.one;
			--	go.name = "Player_"..i;
				self.m_playerGroups[i] = UIPlayerGroup.New(go);
				if i >= 3 then
					go.transform.localEulerAngles = Vector3(0,0,180);
					self.m_playerGroups[i].isUpPlayer = true;
				else
					go.transform.localEulerAngles = Vector3.zero;
					self.m_playerGroups[i].isUpPlayer = false;
				end
				self.m_playerGroups[i].direction = i;
				go:SetActive(false)
				self.m_playerGroups[i]:Find()
			else
				print("游戏资源实例化有问题: ",v.path)
			end
		end
		--print("2222222222222222222222222222222222222222222")
		GameController.GetInstance():CurLoadingResCount()
		self:ExcuteQueue()
	end)

	table.insert(self.queue,function() 
		self.m_haiWang3PackPrefabs ={}
		local count = #GameLuaDefine.YuRenPackRes
		for i,v in ipairs(GameLuaDefine.YuRenPackRes) do
			local cb = function(obj)
				count = count - 1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_haiWang3PackPrefabs[v.name]=obj[0].transform
				else
					print("游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
					
					self:ExcuteQueue()
				end
			end
			--print("33333333333333333333333333333333333333333333333333")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	table.insert(self.queue,function() 
		self.m_fishPrefabs = {}
		self.m_fishPrefabsPool={}
		for i,v in pairs(GameLuaDefine.FishsRes) do
			local parentPrefab = self.m_haiWang3PackPrefabs[v.ParentName]
			local prefab = parentPrefab.transform:Find(v.name)
			self.m_fishPrefabs[i] = prefab
			if prefab ~= nil then
				self.m_fishPrefabsPool[i]=prefab
				local prefabPool= PrefabPool (prefab)
				prefabPool._logMessages=false
				for j = 1,v.count do
					self:CreatePool(self.m_poolFish,prefabPool,(v.amout * j))
					
				end
			else
				print("游戏资源实例化有问题: ",v.name)	
			end	
		end
		--print("4444444444444444444444444444444444444444444444444444444444444")
		GameController.GetInstance():CurLoadingResCount()
		self:ExcuteQueue()
	end)

	table.insert(self.queue,function() 
		self.m_bulletPrefabs = {}
		for i,v in ipairs(GameLuaDefine.BulletRes) do
			local parentPrefab = self.m_haiWang3PackPrefabs[v.ParentName]
			local prefab = parentPrefab.transform:Find(v.name)
			if prefab ~= nil then
				self.m_bulletPrefabs[i]=prefab
				local prefabPool= PrefabPool (prefab)
				prefabPool._logMessages=false
				for j = 1,v.count do
					self:CreatePool(self.m_poolBullets,prefabPool,(v.amout * j))
				end
			else
				print("游戏资源实例化有问题: ",v.name)	
			end
		end	
		--print("555555555555555555555555555555555555555555555555555")
		GameController.GetInstance():CurLoadingResCount()
		self:ExcuteQueue()
	end)

	table.insert(self.queue,function()
		self.m_netPrefabs = {}
		local count = #GameLuaDefine.NetRes
		for i,v in ipairs(GameLuaDefine.NetRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_netPrefabs[i]=obj[0].transform
				else
					print("游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
					
					self:ExcuteQueue()
				end
			end
			--print("666666666666666666666666666666666666666666666666666666666666666")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	table.insert(self.queue,function()
		self.m_fishMoneyPrefabs = {}
		local count=#GameLuaDefine.FishMoneyRes
		
		for i,v in ipairs(GameLuaDefine.FishMoneyRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_fishMoneyPrefabs[i]=obj[0].transform
				else
					print("m_fishMoneyPrefabs1游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
					self:ExcuteQueue()
				end
			end
			--print("777777777777777777777777777777777777777777777777777777777")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)
	table.insert(self.queue,function()
		for i,v in ipairs(GameLuaDefine.FishMoneyRes) do
			if  self.m_fishMoneyPrefabs[i] ~= nil then
				local prefab = self.m_fishMoneyPrefabs[i]
				local prefabPool= PrefabPool (prefab)
				prefabPool._logMessages=false
				for j = 1,v.count do
					self:CreatePool(self.m_poolFishMoney,prefabPool,(v.amout * j))
					-- yield_return (0)
					GameController.GetInstance():CurLoadingResCount()
				end
			else
				print("m_fishMoneyPrefabs2游戏资源实例化有问题: ",v.path)
			end
		end
		self:ExcuteQueue()
	end)


	table.insert(self.queue,function()
		self.m_thunderPrefabs = {}
		local count = #GameLuaDefine.ThunderRes
		for i,v in ipairs(GameLuaDefine.ThunderRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_thunderPrefabs[i]=obj[0].transform
				else
					print("游戏资源加载有问题: ",v.path)
				end

				if count<=0 then
				
					self:ExcuteQueue()
				end
			end
			--print("888888888888888888888888888888888888888888888888888888888888")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	-- table.insert(self.queue,function()
	-- 	self.m_dropObjPrefabs = {}
	-- 	local count = #GameLuaDefine.DropObjRes
	-- 	for i,v in ipairs(GameLuaDefine.DropObjRes) do
	-- 		local cb = function(obj)
	-- 			count=count-1
	-- 			if obj~=nil and obj.Length>0 and obj[0] ~=nil then
	-- 				self.m_dropObjPrefabs[i]=obj[0].transform
	-- 			else
	-- 				print("游戏资源加载有问题: ",v.path)
	-- 			end

	-- 			if count<=0 then
	-- 				self:ExcuteQueue()
	-- 			end
	-- 		end
	-- 		resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
	-- 	end
	-- end)

	-- table.insert(self.queue,function() 
	-- 	self.m_killLeiShePrefabs = {}
	-- 	local count = #GameLuaDefine.KillLeiSheRes
	-- 	for i,v in ipairs(GameLuaDefine.KillLeiSheRes) do
	-- 		local cb = function(obj)
	-- 			count=count-1
	-- 			if obj~=nil and obj.Length>0 and obj[0] ~=nil then
	-- 				self.m_killLeiShePrefabs[i]=obj[0].transform
	-- 			else
	-- 				print("游戏资源加载有问题: ",v.path)
	-- 			end
	-- 			if count<=0 then
				
	-- 				self:ExcuteQueue()
	-- 			end
	-- 		end
	-- 		print("9999999999999999999999999999999999999999999999")
	-- 		resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
	-- 	end
	-- end)


	--[[table.insert(self.queue,function() 
		self.m_zuanTouPrefabs = {}
		local count = #GameLuaDefine.ZuanTouRes
		for i,v in ipairs(GameLuaDefine.ZuanTouRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_zuanTouPrefabs[i]=obj[0].transform
				else
					print("游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
				
					self:ExcuteQueue()
				end
			end
			--print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)--]]


	table.insert(self.queue,function()
		self.m_floatNumPrefabs = {}
		local count=#GameLuaDefine.FloatNumRes
		for i,v in ipairs(GameLuaDefine.FloatNumRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_floatNumPrefabs[i]=obj[0].transform
				else
					print("m_floatNumPrefabs1游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
					self:ExcuteQueue()
				end
			end
			--print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	table.insert(self.queue,function() 
		print("22222222222222222222222222222222222222222")
		self.m_explosivePrefabs = {}
		local count = #GameLuaDefine.ExplosiveRes
		for i,v in ipairs(GameLuaDefine.ExplosiveRes) do
			local cb = function(obj)
				count=count-1
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					self.m_explosivePrefabs[v.name]=obj[0].transform
					print(obj[0].transform)
				else
					print("游戏资源加载有问题: ",v.path)
				end
				if count<=0 then
					
					self:ExcuteQueue()
				end
			end
			--print("ccccccccccccccccccccccccccccccccccccccccccc")
			resMgr:LoadAssetEx(self.gameID,v.path,v.name,typeof(GameObject),cb,false,false)
		end
	end)

	GameLuaDefine.listTexRes={}

	GameLuaDefine.listAudioRes ={}

	table.insert(self.queue,function()
		self:SetLockBtnState(GameModel:GetInstance().m_isLockShoot)
    	self:SetAutoShootState(GameModel:GetInstance().m_isAutoShoot)
		LuaEvent:DispatchEvent(EventName.GameResLoadCompeleted)
		GameController.GetInstance():RemoveLoadingEvent()
	end)

end




function GameView:CalScreen()
	local tmp=(Screen.width/Screen.height)
	if self.ratio~=tmp then 
		self.ratio=tmp
		GameModel:GetInstance().ResolutionHeight=self.uiRoot.activeHeight
		GameModel:GetInstance().ResolutionHeightHalf=math.floor(GameModel:GetInstance().ResolutionHeight/2)
		GameModel:GetInstance().ResolutionWidth=math.floor(self.uiRoot.activeHeight*self.ratio)
		GameModel:GetInstance().ResolutionWidthHalf=math.floor(GameModel:GetInstance().ResolutionWidth/2)
		FishComManager.curResolutionWidth = GameModel:GetInstance().ResolutionWidth;
		FishComManager.curResolutionHeight = GameModel:GetInstance().ResolutionHeight;
	end
end

function GameView:CreatePool(pool,PrefabPool,count)
	PrefabPool.preloadAmount=count
	pool:CreatePrefabPool(PrefabPool)
end


function GameView:GetFishPrefab(kindId)
	kindId=kindId or 0
	return self.m_fishPrefabs[kindId]
end
function GameView:GetFishPrefabByPool(kindId)
	kindId=kindId or 0
	return self.m_fishPrefabsPool[kindId]
end
function GameView:Update( ... )
	self:CheckInputEvent()
	if GameModel:GetInstance().listFishVo and next(GameModel:GetInstance().listFishVo) then

		while(#GameModel:GetInstance().listFishVo>0) do
			local fishVo=table.remove(GameModel:GetInstance().listFishVo,1)
			self:CreateFish(fishVo):BeginMove()
		end
	end
	
	if self.m_playerGroups then
		for k,p in pairs(self.m_playerGroups) do
			if p then
				p:Update()
			end
		end
	end

	if self.FishDieSoundCount > 0 then
		if self.FishDieSoundTime > 0 then
			self.FishDieSoundTime = self.FishDieSoundTime - Time.deltaTime
		else 
			self.FishDieSoundCount = self.FishDieSoundCount - 1
			self.FishDieSoundTime = 1
		end
	end
--	self.m_camShake:Update()
end

function GameView:CreateFish(fishVo)
	local fish=GameController:GetInstance().entityModel:CreateFish(fishVo)
	if fish then
		fish:SetParent(self.m_tranParentFish)
		
		fish:SetOrder()
		
		fish:SetScale(Vector3.one)
	end
	return fish
	--生成路径点
end
function GameView:SetBg(index)
	local name=GameLuaDefine.BGTextureIndex[index]
	name=name or "t_bg_1"
	local bgInfo = GameLuaDefine.BGTextureRes[name]
	if GameLuaDefine.listTexRes[name] then
		self.m_sliderBackground.foregroundWidget.mainTexture=GameLuaDefine.listTexRes[name]
		self.m_sliderBackground.backgroundWidget.mainTexture=GameLuaDefine.listTexRes[name]
	else
		local cb=function(obj,texName)
			if obj~=nil and obj[0]~=nil then
			  local texture=obj[0]
			  GameLuaDefine.listTexRes[texName] = texture
			  self.m_sliderBackground.foregroundWidget.mainTexture=GameLuaDefine.listTexRes[texName]
			  self.m_sliderBackground.backgroundWidget.mainTexture=GameLuaDefine.listTexRes[texName]
			else
			  print("游戏资源加载有问题: ",bgInfo.path)
			end
		  end
		  resMgr:LoadAssetImmediate( self.gameID,bgInfo.path,bgInfo.name,typeof(Texture2D),cb,false,false) 
	end
end

function GameView:CheckInputEvent()
	if Application.isMobilePlatform  then
		if Input.touchCount <= 0 then
			self:CancelOnPress()
		end
		if  Input.touchCount > 0 and Input.GetTouch(0).phase == CS.UnityEngine.TouchPhase.Began and (self.panelOdd==nil or not self.panelOdd.gameObject.activeInHierarchy) then
			local cam=GameController:GetInstance().view.m_camUI
			local vecMouse = Input.GetTouch(0).position
			local vecMouseWorld=cam:ScreenToWorldPoint(Vector3(vecMouse.x,vecMouse.y,0))
		--	local localPos = GameController:GetInstance().view.m_poolExplosive.transform:InverseTransformPoint(vecMouseWorld)
			self:PlayExplosive("Fngertips",vecMouseWorld)


			local myRay = GameController:GetInstance().view.m_camFish:ScreenPointToRay(Vector3(vecMouse.x,vecMouse.y,0))
			local isHit,hitInfo = FishComManager.RayFunction(myRay,999,"Fish")
			if(isHit) then
				--print("子弹击中的物体:",hitInfo.transform.name," self.Name:",self.gameObject.name)
				--self:OnTriggerEnter( hitInfo.transform )
				local lb = hitInfo.transform.gameObject:GetComponent(typeof(LuaBehaviour))
				if(lb~=nil) then
					local clickFish = lb.m_luaTable
					if clickFish and not clickFish:IsDie() and not clickFish.isCanDestroy  then
						local me=GameController:GetInstance().view.m_playerGroups[GameModel:GetInstance().m_myClientDesk]
						if me then
							me:OnPressMouseFish(clickFish,true) 
						end
					end
				end
			end

		end
	
	else
		if Input.GetMouseButton(0) == false then
			self:CancelOnPress()
		end

		if Input.GetMouseButtonDown(0) == true and (self.panelOdd==nil or not self.panelOdd.gameObject.activeInHierarchy) then
			local cam=GameController:GetInstance().view.m_camUI
			local vecMouse=Input.mousePosition
			local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
		--	local localPos = GameController:GetInstance().view.m_poolExplosive.transform:InverseTransformPoint(vecMouseWorld)
			self:PlayExplosive("Fngertips",vecMouseWorld)

			local myRay = GameController:GetInstance().view.m_camFish:ScreenPointToRay(Input.mousePosition)
			local isHit,hitInfo = FishComManager.RayFunction(myRay,999,"Fish")
			if(isHit) then
				--print("子弹击中的物体:",hitInfo.transform.name," self.Name:",self.gameObject.name)
				--self:OnTriggerEnter( hitInfo.transform )
				local lb = hitInfo.transform.gameObject:GetComponent(typeof(LuaBehaviour))
				if(lb~=nil) then
					local clickFish = lb.m_luaTable
					if clickFish and not clickFish:IsDie() and not clickFish.isCanDestroy  then
						local me=GameController:GetInstance().view.m_playerGroups[GameModel:GetInstance().m_myClientDesk]
						if me then
							me:OnPressMouseFish(clickFish,true) 
						end
					end
				end
			end
		end
	end


end

function GameView:CancelOnPress()
	if self.m_playerGroups then 
		local me=self.m_playerGroups[GameModel:GetInstance().m_myClientDesk]
		if not me then
			return 
		end
		me._isPress=false
	end
end

function GameView:UIPressMouse( press )
	-- if press == false then return end
	if self.m_playerGroups then 

		local me=self.m_playerGroups[GameModel:GetInstance().m_myClientDesk]
		if not me then
			return 
		end
		me:OnPressMouse(press)
	end
end
function GameView:ChangeScene(sceneIndex)
	sceneIndex=sceneIndex or 1
	if sceneIndex>#GameLuaDefine.BGTextureIndex then
		sceneIndex=1
	end
	local tips={"正在切换场景，无法发射炮弹。","Switching scenes, unable to fire shells"}
	local language=""
	if GameModel:GetInstance().LanguageType==1 then
		language=tips[1]
	else
		language=tips[2]
	end
	GameController:GetInstance().view:SetObjTideTipsStatus(true,language)
	local texName=GameLuaDefine.BGTextureIndex[sceneIndex]
	if texName then
		local texRes=GameLuaDefine.listTexRes[texName]
		if texRes then
			self.m_sliderBackground.backgroundWidget.mainTexture = texRes
		else
			local bgInfo = GameLuaDefine.BGTextureRes[texName]
			local cb=function(obj,texName)
				if obj~=nil and obj[0]~=nil then
				  local texture=obj[0]
				  GameLuaDefine.listTexRes[texName] = texture
				  self.m_sliderBackground.backgroundWidget.mainTexture = texture
				else
				  print("游戏资源加载有问题: ",bgInfo.path)
				end
			  end
			  resMgr:LoadAssetImmediate( self.gameID,bgInfo.path,bgInfo.name,typeof(Texture2D),cb,false,false) 
		end
	end
	self.m_sliderBackground.thumb:GetComponent(typeof(TweenPosition)).enabled = false;
	
	self.ChangeSceneTime = GameModel:GetInstance().ChangeSceneTime;
	local thumbGameObj = self.m_sliderBackground.thumb.gameObject

	local bg3 =  thumbGameObj.transform:Find("BG3")
	local bg3Alpha = bg3:GetComponent(typeof(TweenAlpha))

	local spriteLogo = thumbGameObj.transform:Find("BG3/Sprite_Logo")

	local thumbSpriteAnimation = spriteLogo:GetComponent(typeof(UISpriteAnimation))
	local thumbSpriteAlpha = spriteLogo:GetComponent(typeof(TweenAlpha))
	
	self.qiPaoEffect.gameObject:SetActive(true)

	if self.m_playerGroups then
		for k,p in pairs(self.m_playerGroups) do
			if p then
				p:SetTarget(nil)
				for f,bullet in pairs(p.m_dicBullet) do
					if not bullet.isCanDestroy then	
						bullet._lb.m_targetTrans = nil
						bullet._targetFish=nil
					end	
				end
			end
		end
	end

	local config=SoundConfig[44]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.m_asWave.clip= soundRes
        self.m_asWave:Play()
      else
        local cb=function(obj,audioName)
            if obj~=nil and obj[0]~=nil then
              local audioClip=obj[0]
              GameLuaDefine.listAudioRes[audioName] = audioClip
              self.m_asWave.clip= audioClip
              self.m_asWave:Play()
            else
              print("游戏资源加载有问题: ",config.soundPath)
            end
          end
        	resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true)
      end
    end
  end

		
		GameController:GetInstance().asBg:Stop()

    RenderMgr.Add(function()
		if self.ChangeSceneTime<=0 then
			RenderMgr.Remove("ChangeSceneBegin")
			--[[self.m_sliderBackground.thumb.gameObject:SetActive(true);
    		 self.m_sliderBackground.thumb:GetComponent(typeof(TweenPosition)).enabled = true;
             self.m_sliderBackground.thumb:GetComponent(typeof(TweenPosition)):ResetToBeginning();
             self.m_sliderBackground.thumb:GetComponent(typeof(TweenPosition)):PlayForward();
             self.m_objTideTips:SetActive(false);--]]
            self.m_asWave:Stop()
            -- //进入鱼阵状态
            if self.m_sliderBackground.backgroundWidget.mainTexture then
            	self.m_sliderBackground.foregroundWidget.mainTexture = self.m_sliderBackground.backgroundWidget.mainTexture;
            end
        
			self.m_sliderBackground.value = 1;
			thumbGameObj:SetActive(false);
        	-- 清掉所有的鱼实体
			GameController:GetInstance().entityModel:RemoveAllFish()
			
			--GameController:GetInstance():PlayBgAudio(math.random(2,8))
			local soundIDGroup = {2,95,96,97}
			GameController:GetInstance():PlayBgAudio(soundIDGroup[math.random(1,4)])
			GameController:GetInstance():PlayGameAudio(44)
			GameController:GetInstance().view:SetObjTideTipsStatus(false,"")
			self.qiPaoEffect.gameObject:SetActive(false)
			
		else
			self.ChangeSceneTime=self.ChangeSceneTime-Time.deltaTime
			if self.ChangeSceneTime<= (GameModel:GetInstance().ChangeSceneTime -GameModel:GetInstance().FishGoAwayTime) then
				if thumbGameObj.activeInHierarchy == false then 
					thumbGameObj:SetActive(true);
					thumbSpriteAnimation:ResetToBeginning()
				
					thumbSpriteAlpha:ResetToBeginning()
					thumbSpriteAlpha:Play()

					bg3Alpha:ResetToBeginning()
					bg3Alpha:Play()
					self.m_sliderBackground.value = 0
				end
				GameController:GetInstance().entityModel:RemoveAllFish()
				--self.m_sliderBackground.value=self.m_sliderBackground.value-Time.deltaTime/(GameModel:GetInstance().ChangeSceneTime -GameModel:GetInstance().FishGoAwayTime)
			end
    	end
    	end,"ChangeSceneBegin")
end

function GameView:SetObjTideTipsStatus(active,txt)
	self.m_objTideLabel.text = txt;
	self.m_objTideTips:SetActive(active)
end

function GameView:OnClickLockBtn( go )
	GameController:GetInstance():PlayUIBottomAudio(113)
	GameModel:GetInstance().m_isLockShoot=not GameModel:GetInstance().m_isLockShoot
	FishComManager.isLockShoot = GameModel:GetInstance().m_isLockShoot
	if FishComManager.isLockShoot == true then
		GameController:GetInstance():PlayUIBottomAudio(113)
	end
	self:SetLockBtnState(GameModel:GetInstance().m_isLockShoot)
end

function GameView:SetLockBtnState(state)
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Lock/Off").gameObject:SetActive(state)
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Lock/On").gameObject:SetActive(not state)
end

function GameView:OnClickFastShootBtn(go)
	GameController:GetInstance():PlayUIBottomAudio(113)

	if GameModel:GetInstance().isFastSpeed == true then
		GameModel:GetInstance().isFastSpeed = false
		GameModel:GetInstance().fShootInterval=0.2
		--GameModel:GetInstance().bulletSpeed = 850
	--	self.m_fastShootBtn = self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/Off").gameObject:SetActive(false)
	else
		GameModel:GetInstance().isFastSpeed = true
		GameModel:GetInstance().fShootInterval=0.1
		--GameModel:GetInstance().bulletSpeed = 1200
		--self.m_fastShootBtn = self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/Off").gameObject:SetActive(true)
	end
	self:SetFastShootState(GameModel:GetInstance().isFastSpeed)
end

function GameView:SetFastShootState(state)
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/Off").gameObject:SetActive(state)
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Fast/On").gameObject:SetActive(not state)
end

function GameView:OnClickAutoShootBtn( go )
	GameController:GetInstance():PlayUIBottomAudio(113)
	GameModel:GetInstance().m_isAutoShoot=not GameModel:GetInstance().m_isAutoShoot
	self:SetAutoShootState(GameModel:GetInstance().m_isAutoShoot)
end
function GameView:SetAutoShootState( state )
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Auto/Off").gameObject:SetActive(state)
	self.transform:Find("GameUI/PanelSecond/UIstretch/Group/Button_Colliders/Game_Group/ControllerPanel1/Auto/On").gameObject:SetActive(not state)
end

function GameView:OnClickExitBtn()
	GameController:GetInstance():PlayUIBottomAudio(112)
	-- self:PlayOutSceneAnimator()
	RenderMgr.Remove("OnClickExitBtn")
  RenderMgr.AddInterval(function()
		RoomController:GetInstance():ReqQuitGame(GameController:GetInstance().desk)
		end,"OnClickExitBtn",0.5,0.55)
		
	-- local showBoxData={}
	-- showBoxData.title = "提示"--:标签，
 --    showBoxData.context = "确定要退出游戏吗"--内容；
 --    showBoxData.enterCB = function() 
 --    end--：点击确定返回；
 --    showBoxData.cancelCB = function() UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.MessageBox) end--：点击取消返回，
 --    showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
 --    showBoxData.isHideAll = false--:隐藏所有按钮; 
 --    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	-- UIManager:GetInstance():ShowMessageBox(showBoxData)
       
end
function GameView:OnClickPlistBtn()
	--print("1111111111111111111111")
	--print(self.tranPlistRootAnimator)
	--self.tranPlistRootAnimator:Play("Shouhui")
	GameController:GetInstance():PlayUIBottomAudio(113)
	 self.IsOpen=not self.IsOpen
	if  self.IsOpen then
		self.tranPlistRootAnimator:Play("Shouhui")
	else
		self.tranPlistRootAnimator:Play("Lachu")
	end
	
	
	
end
function GameView:OnClickOddBtn()
	GameController:GetInstance():PlayUIBottomAudio(112)
	-- self.panelOdd:Open()

	if self.panelOdd then
		self.panelOdd:Open()
	else
		local cb = function(obj)
			self.isOpenHelpIng=false
			if obj~=nil and obj.Length>0 and obj[0] ~=nil then
				local prefab=obj[0].transform
				local tran=GameObject.Instantiate(prefab).transform
				tran.parent=self.transform:Find("GameUI/PanelSecond/UIstretch3")
				tran.localPosition=Vector3.zero
				tran.localEulerAngles=Vector3.zero
				tran.localScale=Vector3.one
				self.panelOdd=UIOddPanel.New(tran)
				self.panelOdd:Open()
			else
				print("游戏资源加载有问题: ",v.path)
			end
		end
		self.isOpenHelpIng=true
		resMgr:LoadAssetEx(self.gameID,"Phone/Prefab/Functions/PanelOdds.unity3d","PanelOdds",typeof(GameObject),cb,false,false)
	end
end
function GameView:OnClickSettingBtn()
	GameController:GetInstance():PlayUIBottomAudio(112)
	--self.m_uiSettingPanel:Open()
	self.isOpenSettingIng=self.isOpenSettingIng or false
	if self.isOpenSettingIng then return end
	if self.m_uiSettingPanel then
		self.m_uiSettingPanel:Open()
	else
		local cb = function(obj)
			self.isOpenSettingIng=false
			if obj~=nil and obj.Length>0 and obj[0] ~=nil then
				local prefab=obj[0].transform
				local tran=GameObject.Instantiate(prefab).transform
				tran.parent=self.transform:Find("GameUI/PanelSecond/UIstretch3")
				tran.localPosition=Vector3.zero
				tran.localEulerAngles=Vector3.zero
				tran.localScale=Vector3.one
				self.m_uiSettingPanel=SettingPanel.New(tran)
				self.m_uiSettingPanel:Open()
			else
				print("游戏资源加载有问题: ",v.path)
			end
		end
		self.isOpenSettingIng=true
		resMgr:LoadAssetEx(self.gameID,"Phone/Prefab/Functions/Hall_SettingPanel.unity3d","Hall_SettingPanel",typeof(GameObject),cb,false,false)
	end
end
local function CreateFishMoneyParam(fish,p)

	local info={}
	--print("sssssssssssssssssssssss :",fish.vo.fishConfig.id)
	if(fish.vo) then
	local count= fish.vo.fishConfig.coinCount 
	local coinsPosList = GameLuaDefine.CoinPos1[1]

	local localp=nil
	local worldp=nil
	for i=1,count do
		localp=fish.transform.localPosition+Vector3(coinsPosList[i].x1,coinsPosList[i].y1,0)  -- Vector3(offsetX*i,0,0)
		worldp=fish.transform.parent:TransformPoint(localp)
		table.insert(info,{beginPos=worldp,endPos=p.m_tranFloatMoneyEndPos.position,player=p})
	end
	return info

	end
end
local DingTickID=0
function GameView:HandleHitFish(msg)
	local fishUID=msg.dwFishID
	local fishKind=msg.btFishKind
	local fish=nil	

	fish=GameController:GetInstance().entityModel:GetFishByFishUID(fishUID)
	if not fish then
		print("本地没有这个鱼的UID"..fishUID)
		GameModel:GetInstance():ClearFishVo(fishUID)
		return 
	end
	
	--print("fish.vo.fishConfig.fishType    ============   ",fish.vo.fishConfig.fishType)
	local d=GameController:GetInstance():GetFishPlayerDirection(msg.wChairID)
	local p=self.m_playerGroups[d]
	self.FishPOS=fish.gameObject.transform.localPosition
	if fish.vo.fishConfig.fishType == 0 or fish.vo.fishConfig.fishType==21 then

		-- if fish.vo.fishKind ~= 100 then 
		self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
		self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul)
		if fish.vo.fishConfig.id == 26 or fish.vo.fishConfig.id == 27 then
			GameController:GetInstance():PlayFishDieSound(20)
		end
		-- end
		if fish then fish:FishNormalDie(msg,p) end
	elseif fish.vo.fishConfig.fishType == 3 then 
		--开启一个定时器
		--pt("捕捉冰冻鱼数据  ",msg)
		self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
		self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.sBaseMul)
		if fish then fish:FishNormalDie(msg,p) end
		GameModel:GetInstance().ding=true
		GameController:GetInstance().entityModel:PauseAllFish()
	elseif fish.vo.fishConfig.fishType == 4 then
		local fishIDcankiil = fish.vo.fishConfig.dieFishkillFishId
		local radius = fish.vo.fishConfig.dieFishDamageRadius
		local dieFishs ={}
		for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
			if fish1.vo.fishKind<=fishIDcankiil and fish1:CheckFishIsLive() and fish1.vo.uid ~= fish.vo.uid  then
				distance=Vector3.Distance(fish.transform.localPosition,fish1.transform.localPosition)
				if distance<=radius then
					table.insert(dieFishs,fish1.vo.uid)
				end
			end
		end
		local send={}
		self.FishPOS=fish.gameObject.transform.localPosition
		send.dwBombFishID=fish.vo.uid
		send.dwKilledIDList=dieFishs
		send.nListCount=#dieFishs
	
		GameLuaDefine.CMD_C_PartBombKilledList={
			{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
			{"nListCount","Int16",0},--列表大小
			{"dwKilledIDList","Int32[]",send.nListCount},--被炸死的鱼ID列表
		}
		local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
		local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_SEND_PARTBOMB_KILLED_LT
		GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_PartBombKilledList,send,mainId,msgID)

		fish:FishBombDie(msg,p)
		
		if fish.vo.fishConfig.id==24 then
			--local pos1 = FishComManager.ScreenPointToRealPoint(msg.nCaptureNetX,msg.nCaptureNetY)
			self.IsStopMark=true
		end
		
	elseif fish.vo.fishConfig.fishType == 6 then
		if fish.vo.fishConfig.id == 23 then
			GameController:GetInstance():PlayFishDieSound(116)
		elseif fish.vo.fishConfig.id == 30 then
			GameController:GetInstance():PlayFishDieSound(29)
		end
		local fishIDcankiil = fish.vo.fishConfig.dieFishkillFishId
		local radius = fish.vo.fishConfig.dieFishDamageRadius
		local bombFishs ={}
		for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
			
			if(fish.vo.fishConfig.id==30) then
				if fish1.vo.fishKind==fishIDcankiil and fish1:CheckFishIsLive()   then --and fish1.vo.uid ~= fish.vo.uid
					distance=Vector3.Distance(fish.transform.localPosition,fish1.transform.localPosition)
					if distance<=radius then
						table.insert(bombFishs,fish1.vo.uid)
					end
				end
			else
				if fish1.vo.fishKind<=fishIDcankiil and fish1:CheckFishIsLive()   then --and fish1.vo.uid ~= fish.vo.uid
					distance=Vector3.Distance(fish.transform.localPosition,fish1.transform.localPosition)
					if distance<=radius then
						table.insert(bombFishs,fish1.vo.uid)
					end
				end
			
			end
		end

		local send={}
		send.dwBombFishID=fish.vo.uid
		send.dwKilledIDList=bombFishs
		send.nListCount=#bombFishs
		pt(send)
		GameLuaDefine.CMD_C_PartBombKilledList={
			{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
			{"nListCount","Int16",0},--列表大小
			{"dwKilledIDList","UInt32[]",send.nListCount},--被炸死的鱼ID列表
		}
		local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
		local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_SEND_PARTBOMB_KILLED_LT
		GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_PartBombKilledList,send,mainId,msgID)
		fish:FishBombDie(msg,p)
	elseif fish.vo.fishConfig.fishType == 26 then
			if fish then
				local cb = function()
					self.IsStopMark=false
					fish:FishBaseImmediatelyDie(msg,p)
					self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul)
				end
				if p.isMe then
					self.IsStopMark=true
					fish:FishBombDie(msg,p) 
					p:BeginJinNiu(msg.iFishScore,cb)
					GameController:GetInstance():PlayFishDieSound("fish_chaishen")
				else
					fish:FishBaseImmediatelyDie(msg,p)
				end
			end
	end
end

function GameView:HandleHitFishBoom( msg )
		--被打死的鱼的id  ---如果鱼类型是99的话，是特殊鱼，不用在本地找
	local fishUID=msg.dwFishID
	local fishKind=msg.btFishKind
	local fish=nil
	
	fish=GameController:GetInstance().entityModel:GetFishByFishUID(fishUID)

	local d=GameController:GetInstance():GetFishPlayerDirection(msg.wChairID)
	local p=self.m_playerGroups[d]
	local fishPos=Vector3.zero
	
	if  fish.vo.fishConfig.fishType == 4 then
		
		
		if fish.vo.fishConfig.id==24 then
			--local pos1 = FishComManager.ScreenPointToRealPoint(msg.nCaptureNetX,msg.nCaptureNetY)
			--self.IsStopMark=true
			local pos = GameController:GetInstance().view.m_poolFish.transform:TransformPoint(self.FishPOS)
			fish.gameObject.transform.position =pos --p.quan_heiDong.transform.position
			--local effectH=self:PlayExplosive3("Effect_HDY",pos)
			local effectH=self:PlayHDYExplosive(pos)
			effectH.gameObject.layer =9
			effectH:Find("root").gameObject.layer =9
			effectH:Find("root/HD_heidong01_b").gameObject.layer =9
			effectH:Find("root/smoke_02").gameObject.layer =9
			effectH:Find("root/heidian_glow_004").gameObject.layer =9
			effectH:Find("root/sd_shandian043").gameObject.layer =9
			effectH:Find("root/shuiwen_wenli_001").gameObject.layer =9
			
			local parent1 = effectH:Find("Fish_Group")
			local parent2 = fish.transform.parent
			fish.transform.parent = parent1
			GameController:GetInstance():PlayConinAudio(47)
			StartCoroutine(function ()
				local dieFishs={}
				for k,fish_Kill in pairs(msg.hitFishItemList) do
					local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
					if fish1 then
						if fish1:CheckBoundValid() then
							fish1._lb.isMoving = false
							table.insert(dieFishs,fish1)
							fish1.transform.parent = parent1
							fish1:FishBombDie(msg,p)
							fish1._dieTime = -100
						else
							GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
							fish1:FishBaseImmediatelyDie(msg,p)
						end
					else
						print("本地没有这个鱼的UID"..fish_Kill.dwFishID)
					end
				end
				print("黑洞鱼执行特效  #dieFishs",#dieFishs)
				if next(dieFishs) then
					local begin= fish--p.quan_heiDong--fish --主鱼
					local end1=nil
				
					--yield_return (WaitForSeconds(1))
					for i,v in ipairs(dieFishs) do
						end1=v
						if begin and end1 then
							end1._lb:BeginDieMov(begin.gameObject,1.2)
						end
					end
					
					yield_return (WaitForSeconds(1))
					GameController:GetInstance():PlayConinAudio(48)
					yield_return (WaitForSeconds(1))
					GameController:GetInstance():PlayConinAudio(46)

					-- self:GeneralGenMoneyEffect(msg.iFishScore,begin,p,msg.wChairID)
					yield_return(WaitForSeconds(4))
					
					for i,v in ipairs(dieFishs) do
						v.gameObject.transform.parent = parent2
						self:GeneralGenMoneyEffect(msg.hitFishItemList[i].iFishScore,v,p,msg.wChairID,msg.hitFishItemList[i].iLuckMul,msg.hitFishItemList[i].n64FishIntegral)
						v:FishBaseImmediatelyDie(msg,p)
						if v.vo~=nil then
							GameModel:GetInstance():ClearFishVo(v.vo.uid)
						end
					end
					
					begin.transform.parent = parent2
					--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul,true)
					begin:FishBaseImmediatelyDie(msg,p)
					--p.moneyTeamView:CreateMoneyData(msg)
					
					if not fish then
						GameModel:GetInstance():ClearFishVo(begin.vo.uid)
					end
				else
					
					yield_return (WaitForSeconds(2.5))
					self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul,msg.iFishIntegral)
					fish:FishBaseImmediatelyDie(msg,p)
					
					--p.moneyTeamView:CreateMoneyData(msg)
					if not fish then
						GameModel:GetInstance():ClearFishVo(fish.vo.uid)
					end
				end
				self.m_poolExplosive:Despawn(effectH)
				print("黑洞鱼执行特效 结束")
				self.IsStopMark=false
				GameController.GetInstance():PlayConinAudio(1)
				--GameController:GetInstance():PlayConinAudio(47)
				GameController:GetInstance():StopConinAudio(47)
			end)	
		
		else
			local bombFishs={}
			for _,fish_Kill in pairs(msg.hitFishItemList) do
				if fish_Kill.dwIsKilled == 1 then
					GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
					local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
					if fish1  then
						if fish1:CheckBoundValid() then
							table.insert(bombFishs,fish1)
							if fish1.vo.fishKind<=21 or fish1.vo.fishKind ==26 or fish1.vo.fishKind ==24  then
								self:GeneralGenMoneyEffect(fish_Kill.iFishScore,fish1,p,msg.wChairID,fish_Kill.iLuckMul)
							end
							fish1:FishNormalDie(msg,p)
						else
							fish1:FishBaseImmediatelyDie(msg,p)
						end
					else
						print("本地没有这个鱼的UID:"..fish_Kill.dwFishID)
					end
				else
					local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
					fish1:ResetNormal()
				end
			end

			-- local fn=GameController:GetInstance().entityModel:CreateFloatNum()
			-- fn:SetPosition(fish:GetPosition())
			-- fn:SetMoneyUILabel(msg.iFishScore,msg.wChairID,nil)
			self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
			--	self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.baseMul)
			fish:FishNormalDie(msg,p)
			if not fish then
				GameModel:GetInstance():ClearFishVo(fishUID)
				return 
			end
		
		end
	elseif fish.vo.fishConfig.fishType == 27 then
		--p:ResetHeiDong()
		local pos1 = FishComManager.ScreenPointToRealPoint(msg.nCaptureNetX,msg.nCaptureNetY)
	
		local pos = GameController:GetInstance().view.m_poolFish.transform:TransformPoint(pos1)
		fish.gameObject.transform.position =pos --p.quan_heiDong.transform.position
		local parent1 = self:PlayExplosive3("Effect_HDY",pos):Find("Fish_Group")
		local parent2 = fish.transform.parent
		fish.transform.parent = parent1
		GameController:GetInstance():PlayConinAudio(47)
		StartCoroutine(function ()

			-- fish:FishNormalDie(msg,p)
			-- self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
			-- fish._dieTime = -10

			local dieFishs={}
			for k,fish_Kill in pairs(msg.hitFishItemList) do
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				if fish1 then
					if fish1:CheckBoundValid() then
						fish1._lb.isMoving = false
						table.insert(dieFishs,fish1)
						fish1.transform.parent = parent1
						fish1:FishBombDie(msg,p)
						fish1._dieTime = -100
					else
						GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
						fish1:FishBaseImmediatelyDie(msg,p)
					end
				else
					print("本地没有这个鱼的UID"..fish_Kill.dwFishID)
				end
			end
		
			if next(dieFishs) then
				local begin= fish--p.quan_heiDong--fish --主鱼
				local end1=nil
			
				--yield_return (WaitForSeconds(1))
				for i,v in ipairs(dieFishs) do
					end1=v
					if begin and end1 then
						end1._lb:BeginDieMov(begin.gameObject,1.2)
					end
				end
			
				-- self:GeneralGenMoneyEffect(msg.iFishScore,begin,p,msg.wChairID)
				yield_return (WaitForSeconds(4))
				
				for i,v in ipairs(dieFishs) do
					v.gameObject.transform.parent = parent2
					self:GeneralGenMoneyEffect(msg.hitFishItemList[i].iFishScore,v,p,msg.wChairID,msg.hitFishItemList[i].iLuckMul,true)
					v:FishBaseImmediatelyDie(msg,p)
					if v.vo~=nil then
						GameModel:GetInstance():ClearFishVo(v.vo.uid)
					end
				end
				
				begin.transform.parent = parent2
				--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul,true)
				begin:FishBaseImmediatelyDie(msg,p)
				
				--p.moneyTeamView:CreateMoneyData(msg)
				
				if not fish then
					GameModel:GetInstance():ClearFishVo(begin.vo.uid)
				end
			else
				
				yield_return (WaitForSeconds(2.5))
				self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul,true)
				fish:FishBaseImmediatelyDie(msg,p)
				
				--p.moneyTeamView:CreateMoneyData(msg)
				
				if not fish then
					GameModel:GetInstance():ClearFishVo(fish.vo.uid)
				end
			end

		end)	
	elseif  fish.vo.fishConfig.fishType == 28 then
		p.LieYanShenJianNumber = 	p.LieYanShenJianNumber -1
		self:PlayExplosive3("Effect_huoyanshenjian",p.quan_Lieyanshenjian.transform.position)
		if p.LieYanShenJianNumber > 0 then
			p:BeginLieyanshenjian(fish.vo.uid)
		else
			p:ResetLieyanshenjian()
		end
		local bombFishs={}
		for _,fish_Kill in pairs(msg.hitFishItemList) do
			if fish_Kill.dwIsKilled == 1 then
				GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				if fish1  then
					if fish1:CheckBoundValid() then
						table.insert(bombFishs,fish1)						
						self:GeneralGenMoneyEffect(fish_Kill.iFishScore,fish1,p,msg.wChairID,fish_Kill.iLuckMul)
						fish1:FishNormalDie(msg,p)
					else
						fish1:FishBaseImmediatelyDie(msg,p)
					end
				else
					print("本地没有这个鱼的UID:"..fish_Kill.dwFishID)
				end
			else
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				fish1:ResetNormal()
			end
		end

		--self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
		if p.LieYanShenJianNumber == 0 then
			fish:FishNormalDie(msg,p)
			if not fish then
				GameModel:GetInstance():ClearFishVo(fishUID)
				return 
			end
		end
	elseif  fish.vo.fishConfig.fishType == 11 then
		local bombFishs={}
		for _,fish_Kill in pairs(msg.hitFishItemList) do
			if fish_Kill.dwIsKilled == 1 then
				GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				if fish1 then
					if fish1:CheckBoundValid() then
						table.insert(bombFishs,fish1)
						if fish1.vo.fishKind<=21 or fish1.vo.fishKind ==26 or fish1.vo.fishKind ==24  then
							self:GeneralGenMoneyEffect(fish_Kill.iFishScore,fish1,p,msg.wChairID,fish_Kill.iLuckMul)
						end
						fish1:FishNormalDie(msg,p)
					else
						fish1:FishBaseImmediatelyDie(msg,p)
					end
						
				else
					print("本地没有这个鱼的UID:"..fish_Kill.dwFishID)
				end
			else
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				fish1:ResetNormal()
			end
		end

		-- local fn=GameController:GetInstance().entityModel:CreateFloatNum()
		-- fn:SetPosition(fish:GetPosition())
		-- fn:SetMoneyUILabel(msg.iFishScore,msg.wChairID,nil)
		-- self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
		--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID)
	--	self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.baseMul)
		fish:FishNormalDie(msg,p)
		if not fish then
			GameModel:GetInstance():ClearFishVo(fishUID)
			return 
		end
		
	elseif  fish.vo.fishConfig.fishType == 9 then
		local bombFishs={}
		for _,fish_Kill in pairs(msg.hitFishItemList) do
			if fish_Kill.dwIsKilled == 1 then
				GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				if fish1 then
					if fish1:CheckBoundValid() then
						table.insert(bombFishs,fish1)
						if fish1.vo.fishKind<=21 or fish1.vo.fishKind ==26 or fish1.vo.fishKind ==24  then
							self:GeneralGenMoneyEffect(fish_Kill.iFishScore,fish1,p,msg.wChairID,fish_Kill.iLuckMul)
						end
						fish1:FishNormalDie(msg,p)
					else
					
						fish1:FishBaseImmediatelyDie(msg,p)
					end
						
				else
					print("本地没有这个鱼的UID:"..fish_Kill.dwFishID)
				end
			else
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				fish1:ResetNormal()
			end
		end

		-- local fn=GameController:GetInstance().entityModel:CreateFloatNum()
		-- fn:SetPosition(fish:GetPosition())
		-- fn:SetMoneyUILabel(msg.iFishScore,msg.wChairID,nil)
		-- self:PlayerGroupFloatNum(msg.iFishScore,msg.wChairID)
		--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID)
		if fish.fishStatus == 1 then
			--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.baseMul)
			fish:FishNormalDie(msg,p)
		else
			if fish.vo.fishKind == 28 then
				GameController:GetInstance():PlayFishDieSound("38")
			end
			--self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.baseMul)
			fish:FishBaseImmediatelyDie(msg,p)
		end
		if not fish then
			GameModel:GetInstance():ClearFishVo(fishUID)
			return 
		end
	elseif fish.vo.fishConfig.fishType == 6 then
		
		--从主鱼向子鱼发射特效线
		StartCoroutine(function ()
			local dieFishs={}
			for k,fish_Kill in pairs(msg.hitFishItemList) do
				local fish1=GameController:GetInstance().entityModel:GetFishByFishUID(fish_Kill.dwFishID)
				if fish1 then
					if fish1:CheckBoundValid() then
						fish1._lb.isMoving = false
						table.insert(dieFishs,fish1)
						fish1:FishBombDie(msg,p)

						-- fish1:FishNormalDie(msg,p)
					else
						GameModel:GetInstance():ClearFishVo(fish_Kill.dwFishID)
						fish1:FishBaseImmediatelyDie(msg,p)
					end
				else
					print("本地没有这个鱼的UID"..fish_Kill.dwFishID)
				end
			end
			self:GeneralGenMoneyEffect(msg.iFishScore,fish,p,msg.wChairID,msg.iLuckMul)
			fish:FishNormalDie(msg,p)
			
			local thunderId = fish.vo.fishConfig.dieFishOtherChidFishEffect
			if next(dieFishs) then
				local begin = fish
				local end1 = nil
			--	GameController:GetInstance():PlayFishDieSound("SND_30_CHANELEC")
				for i,v in ipairs(dieFishs) do
					if v ~= nil then
						end1 = v
						end1:FishNormalDie(msg,p)
						local score = msg.hitFishItemList[i].iFishScore
						self:GeneralGenMoneyEffect(msg.hitFishItemList[i].iFishScore,end1,p,msg.wChairID,msg.hitFishItemList[i].iLuckMul)
						GameController:GetInstance():PlayFishDieSound("SND_30_CHANELEC")
						if begin and end1 then
							local et=GameController:GetInstance().entityModel:CreateThunder(thunderId)
							if et then
								et.gameObject:SetActive(true)
								et:StartEffect(begin:GetPosition(),end1:GetPosition(),Vector3.Distance(begin:GetLocalPosition(),end1:GetLocalPosition()))
							end
						end
					else 
						print("鱼王爆鱼   有对象为nil--------------------")
					end
				end
			end
		end)
	end
end

function GameView:GeneralGenMoneyEffect(iFishScore,fish,p,cID,baseMul)
	--local info={}
	if p.isMe then
		if baseMul ~= nil then
			-- StartCoroutine(function()
			-- 	-- body
				if baseMul < 50 then
					GameController.GetInstance():PlayConinAudio(34)
				else
					GameController.GetInstance():PlayConinAudio(35)
				end
			-- 	yield_return (WaitForSeconds(1.1))
			-- 	if baseMul > 50 then
			-- 		GameController.GetInstance():PlayConinAudio(1)
			-- 	end
			-- end)
		else 
			print("baseMul    为nil ")
		end 
	end
	
	local info=CreateFishMoneyParam(fish,p)
	if info==nil then
		return
	end
	-- local aa=function()
	-- 	self:CreateFishMoney(info)
	-- 	local ddd=GameController:GetInstance():GetFishPlayerDirection(cID)
	-- 	local ppp = self.m_playerGroups[ddd];
	-- end
	--生成金币
	self:CreateFishMoney(info)
	local fn=GameController:GetInstance().entityModel:CreateFloatNum()
	fn.gameObject:SetActive(true)
	fn:SetPosition(fish:GetPosition())
	fn:SetMoneyUILabel(iFishScore,cID,nil)
end

function GameView:PlayerGroupFloatNum(iFishScore,cID)
	-- local ddd=GameController:GetInstance():GetFishPlayerDirection(cID)
	-- local ppp = self.m_playerGroups[ddd];
	-- local gta,isMe=ppp:CreateGoldTeamAdd()
	-- local pos=ppp.m_tranGoldTeamAdd.position
	-- gta:Set(iFishScore,pos,isMe)
	-- gta:Play()
end
function GameView:CreateFishMoney(info)
	--判断需要创建多少个
	for i,v in ipairs(info) do
		local fm=GameController:GetInstance().entityModel:CreateFishMoney(1)
		fm:Set(v.beginPos, v.endPos,v.player)
		fm.gameObject:SetActive(true)
	end
end
function GameView:Shake()
--	self.m_camShake:Shake()
end

function GameView:ShakeAnimator(index)
--	self.m_camShake:ShakeAnimator(index)
end

function GameView:PlayExplosive(name,pos )
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    ParticleManager:GetInstance():AddParticleObj(exTrans.gameObject)
    return exTrans
end

--local particleTicks={}
local particleTickID=1
function GameView:PlayExplosive4(name,pos)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    if exTrans then
		-- local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		-- dieAni.loop=false
		-- dieAni.state:SetAnimation(0,"die",false)
		local tickName="Particle"..particleTickID
		particleTickID=particleTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,1.1,1.2)
		--table.insert(particleTicks,tickName)
	end
    return exTrans
end

function GameView:PlayHDYExplosive(pos)
	local prefab=self.m_explosivePrefabs["Effect_HDY"]
	local exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    return exTrans
end


--local animatorTicks={}
local animatorTickID=1
function GameView:PlayExplosive3(name,pos)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    if exTrans then
		-- local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		-- dieAni.loop=false
		-- dieAni.state:SetAnimation(0,"die",false)
		local tickName="Animator"..animatorTickID
		animatorTickID=animatorTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,6,6.1)
		--table.insert(animatorTicks,tickName)
	end
    return exTrans
end


--local animatorTicks={}
local animatorTickID=1
function GameView:PlayExplosive5(name,times)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = Vector3.zero
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    if exTrans then
		-- local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		-- dieAni.loop=false
		-- dieAni.state:SetAnimation(0,"die",false)
		local tickName="Animator"..animatorTickID
		animatorTickID=animatorTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,times,times+0.1)
		--table.insert(animatorTicks,tickName)
	end
    return exTrans
end


--local luckWinTicks={}
local luckWinTickID=1
function GameView:PlayLuckExplosive(name,pos,score)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
--	GameController.GetInstance():PlayConinAudio(59)
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
	exTrans.localScale = Vector3.one
	local label = exTrans:Find("TOP/UI_Bigwinner_panel_01/Label"):GetComponent(typeof(UILabel))
	label.text = NumberThousandsFormat(HallGoldRateSToC(score or 0)) 
    if exTrans then
		-- local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		-- dieAni.loop=false
		-- dieAni.state:SetAnimation(0,"die",false)
		local tickName="luck"..luckWinTickID
		luckWinTickID=luckWinTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,3,3.1)
		--table.insert(luckWinTicks,tickName)
	end
		return exTrans
		
	
end

--local SkeletonTicks={}
local SkeletonTickID=1
function GameView:PlayExplosive2(name,pos)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
	
    exTrans.localScale = Vector3.one*100
    if exTrans then
		local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		dieAni.loop=false
		dieAni.state:SetAnimation(0,"die",false)
		local tickName="SkeletonAnimation"..SkeletonTickID
		SkeletonTickID=SkeletonTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,6,6.1)
		--table.insert(SkeletonTicks,tickName)
	end
    return exTrans
end

--local hongBaoTicks={}
local hongBaoTickID=1
function GameView:PlayHongBaoEffect(name,pos)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolExplosive:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
	exTrans.localScale = Vector3.one
	
	local label = exTrans:Find("Bone/Label"):GetComponent(typeof(UILabel))
	label.text = SetTwoPoint(GameController:GetInstance().model.hongBaoMoney * 0.0001)
    if exTrans then
		-- local dieAni=exTrans:GetComponent(typeof(SkeletonAnimation))
		-- dieAni.loop=false
		-- dieAni.state:SetAnimation(0,"die",false)
		local tickName="hongBao"..hongBaoTickID
		hongBaoTickID=hongBaoTickID+1
		RenderMgr.AddInterval(function()
			self.m_poolExplosive:Despawn(exTrans)
			end,tickName,4,4.1)
		--table.insert(hongBaoTicks,tickName)
	end
    return exTrans
end

function GameView:PlayGoldTeamAdd(name,pos)
	local exTrans=nil
	local prefab=self.m_explosivePrefabs[name]
	if not prefab then
		return nil
	end
	exTrans=self.m_poolGoldTeamAdd:Spawn(prefab.transform)
	exTrans.gameObject:SetActive(true)
	exTrans.position = pos
	exTrans.eulerAngles = Vector3.zero
    exTrans.localScale = Vector3.one
    return exTrans
end
function GameView:RecycleGoldTeamAdd(t)
	-- body
end
function GameView:RecycleExplosive( t )
	self.m_poolExplosive:Despawn(t)
end
function GameView:__delete( ... )
	RenderMgr.Remove("ChangeSceneBeginEnd")
	RenderMgr.Remove("ChangeSceneBegin")
	RenderMgr.Remove("BossTips")
	self:PlayOutSceneAnimator()
	for i,player in ipairs(self.m_playerGroups) do
		player:Destroy()
	end
	
--	self.BeiKeXunBaoManager:Destroy()
	self.m_playerGroups=nil
	GameLuaDefine.listTexRes= nil
	self.m_fishPrefabs=nil
	self.m_fishPrefabsPool = nil
	self.m_PlayerGroupPrefabs = nil
	self.m_bulletPrefabs=nil
	self.m_netPrefabs=nil
	self.m_explosivePrefabs=nil
	self.m_fishMoneyPrefabs=nil
	self.m_thunderPrefabs=nil
	self.m_floatNumPrefabs=nil
	self.m_goldTeamAddPrefabs=nil

	self.obj= nil
	self.transform = nil
	self.m_sliderBackground = nil
	self.m_asWave = nil
end