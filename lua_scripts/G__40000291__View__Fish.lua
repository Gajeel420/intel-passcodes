Fish=BaseClass(FishBase)
function Fish:__init( )
	
end

function Fish:ReBuild(vo)
	FishBase.ReBuild(self,vo)
	local bone = self.transform:Find("Bone/Bone")
	self.animator=bone:GetComponent(typeof(Animation))
	--bone.localRotation=CS.UnityEngine.Quaternion.identity 
	local err=StringSplit(tostring(self.animator),":")[1]
	if  err~="null" and err~="nil" then
		self.animator:Play("Fish_swim")
	else
		self.animator = nil
	end

	local body = self.transform:Find("Bone/Bone/body")
	if body then
		self.skinnedMeshRender = body:GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
	end

	self._subFishList={}
    --self:SpwanFish(self.vo.FishKindGroup1, 1);
   -- self:SpwanFish(self.vo.FishKindGroup2, 2);
   -- self:SpwanFish(self.vo.FishKindGroup3, 3);
   -- self:SpwanFish(self.vo.FishKindGroup4, 4);
	--self:SpwanFish(self.vo.FishKindGroup5, 5);
	
	self._sps = self.transform:GetComponentsInChildren(typeof(SpriteRenderer),true);

	local w=Color.white
	local r=Color(1,0,0.89,1)

	if self._sps then
		for i=0,self._sps.Length-1 do
			if  self.vo.ishongBaoFish then
				self._sps[i].color=r
			else
				self._sps[i].color=w
			end
		end
	end

	if self._mainFishSp then 
		if self.vo.ishongBaoFish then
			self._mainFishSp.color = r
		else
			self._mainFishSp.color = Color(1,1,1,1)
		end
	end

	self.Dialogue01 = self.transform:Find("Dialogue01")
	self.Dialogue02 = self.transform:Find("Dialogue02")
	if self.Dialogue01  then
		self.Dialogue01.gameObject:SetActive(false)
	end

	if self.Dialogue02  then
		self.Dialogue02.gameObject:SetActive(false)
	end

	-- if self.vo.fishKind == 19 or self.vo.fishKind == 21 or self.vo.fishKind == 22 or self.vo.fishKind == 35 or self.vo.fishKind == 38 then
	-- 	local skeleton =self.transform:Find("Bone/SpineGameObject(KillerWhale)"):GetComponent(typeof(SkeletonAnimation))
	-- 	skeleton.skeleton.R= 1
	-- 	skeleton.skeleton.G= 1
	-- 	skeleton.skeleton.B= 1
	-- 	skeleton.skeleton.A= 1
	-- end

	if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end

	-- if self.vo.fishKind == 24 then
	-- 	local bg = self.transform:Find("BG");
	-- 	local tV = Vector3(GameLuaDefine.KingFishAttr[self.vo.FishKindGroup1].bgScale,GameLuaDefine.KingFishAttr[self.vo.FishKindGroup1].bgScale,1)
	-- 	bg.localScale = tV
	-- 	local uiwidget = self.gameObject:GetComponent(typeof(UIWidget))
	-- 	uiwidget.width = GameLuaDefine.KingFishAttr[self.vo.FishKindGroup1].BoxWidth
	-- 	uiwidget.height = GameLuaDefine.KingFishAttr[self.vo.FishKindGroup1].BoxHeight
	-- 	uiwidget:MakePixelPerfect();
	-- end 

	if self.vo.fishKind == 101 then
		GameController:GetInstance().asBg:Stop()
		GameController:GetInstance():PlayConinAudio(106)
		RenderMgr.Remove("HongBaoLaiLe")
		RenderMgr.AddInterval(function()
			RenderMgr.Remove("HongBaoLaiLe")
			GameController:GetInstance().asBg:Play()
			end,"HongBaoLaiLe",1.6,0)
	end
end
function Fish:Build( vo )
	if FishBase.Build(self,vo) then
		self:OnLoadObject(self.transform)
		return true
	else
		return false
	end
end
function Fish:OnLoadObject(t)
	FishBase.OnLoadObject(self,t)
	self:Find(o)
end
function Fish:Find(o)
	local t = self.transform:Find("Bone/Bone/Fish");
	if t then
		self._mainFishSp=t:GetComponent(typeof(SpriteRenderer))
		if self.vo.ishongBaoFish then
			self._mainFishSp.color =Color(1,0,0.89,1)
		else
			self._mainFishSp.color = Color(1,1,1,1)
		end
	end
	
	t= self.transform:Find("Bone/Shadow");
	if t then
		self._shadowFishSp=t:GetComponent(typeof(SpriteRenderer))
		self._shadowFishSp.color = Color(0,0,0,0.255)
	end
	
	local bone = self.transform:Find("Bone/Bone")
	--bone.localRotation=CS.UnityEngine.Quaternion.identity 
	self.animator=bone:GetComponent(typeof(Animation))
	local err=StringSplit(tostring(self.animator),":")[1]
	if  err~="null" and err~="nil" then
		self.animator:Play("Fish_swim")
	else
		self.animator = nil
	end


	local body = self.transform:Find("Bone/body")
	if body then
		self.skinnedMeshRender = body:GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
	end
	
	local boxerr=StringSplit(tostring(self.collider),":")[1]
	if  boxerr~="null" and boxerr~="nil" then 
		self.collider.enabled = true
	end

	--[[self._subFishList={}
	self:SpwanFish(self.vo.FishKindGroup1, 1);
    self:SpwanFish(self.vo.FishKindGroup2, 2);
    self:SpwanFish(self.vo.FishKindGroup3, 3);
    self:SpwanFish(self.vo.FishKindGroup4, 4);
	self:SpwanFish(self.vo.FishKindGroup5, 5);--]]

	local w=Color.white
	local r=Color(1,0,0.89,1)

	self.Dialogue01 = self.transform:Find("Dialogue01")
	self.Dialogue02 = self.transform:Find("Dialogue02")
	if self.Dialogue01  then
		self.Dialogue01.gameObject:SetActive(false)
	end

	if self.Dialogue02  then
		self.Dialogue02.gameObject:SetActive(false)
	end


	self._sps = self.transform:GetComponentsInChildren(typeof(SpriteRenderer),true);
	
	if self._sps then
		for i=0,self._sps.Length-1 do
			if  self.vo.ishongBaoFish then
				self._sps[i].color=r
			else
				self._sps[i].color=w
			end
		end
	end

	if self._mainFishSp then 
		if self.vo.ishongBaoFish then
			self._mainFishSp.color = r
		else
			self._mainFishSp.color = Color(1,1,1,1)
		end
	end

	if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end

	if self.vo.fishKind == 101 then
		GameController:GetInstance().asBg:Stop()
		GameController:GetInstance():PlayConinAudio(37)
		RenderMgr.Remove("HongBaoLaiLe")
		RenderMgr.AddInterval(function()
			RenderMgr.Remove("HongBaoLaiLe")
			GameController:GetInstance().asBg:Play()
			end,"HongBaoLaiLe",1.6,0)
	end
end
--组合鱼
function Fish:SpwanFish( kind,index )
	print(kind)
	print(index)
	local go=nil
	if self._subFishList and self._subFishList[index] and self._subFishList[index][kind] then
		go=self._subFishList[index][kind]
	else
		local instance =GameController:GetInstance().view:GetFishPrefab(kind);
		if instance then
			local trans=GameController:GetInstance().view.m_poolFish:Spawn(instance).transform; --GameObject.Instantiate(instance)
			go = trans.gameObject
			go:SetActive(true)
			local s=StringFormat("Fish{0}",index)
			trans.parent=self.transform:Find(s)
			FishComManager.SetLocalEulerAngles(trans,0,0,0)
			FishComManager.SetLocalPosition(trans,0,0,0)
			FishComManager.SetLocalScale(trans,1,1,1)
			if not self._subFishList[index] then
	    		self._subFishList[index]={}
	    	end
	    	self._subFishList[index][kind]=go
	    end
	end
	if go then
		--  go.transform:Find("Bone/Shadow").gameObject:SetActive(false);
    	--go:GetComponent(typeof(BoxCollider)).enabled=false
		print(go)
		local _ani=go.transform:GetComponent(typeof(Animation))
		local err=StringSplit(tostring(_ani),":")[1]
		if err~="null" and err~="nil" then
			_ani.enabled = true
			_ani:Play("Fish_swim")
		end

		local t = go.transform:Find("Bone/Fish")
		if t then  t:GetComponent(typeof(SpriteRenderer)).color=Color(1,1,1,1) end
		
		local shadowSp = go.transform:Find("Bone/Shadow")
		if shadowSp then  
			shadowSp.gameObject:SetActive(false)
			shadowSp:GetComponent(typeof(SpriteRenderer)).color=Color(0,0,0,0)
		 end

		
	end
end

function Fish:ChangeFishStatus( status)
	self.fishStatus = status
	if status == 0 then
		self.animator:Play("Fish_Move")
		if self.vo.fishKind == 28 then
			if self.collider then
				self.collider.size = Vector3(68,95,0)
			end
		elseif self.vo.fishKind == 26 then
			if self.collider then
				self.collider.size = Vector3(76,48,0)
			end
		end
	elseif status == 1 then
		self.animator:Play("Fish_Move1")
		if self.vo.fishKind == 28 then
			if self.collider then
				self.collider.size = Vector3(110,160,0)
			end
		elseif self.vo.fishKind == 26 then
			if self.collider then
				self.collider.size = Vector3(100,90,0)
			end
		end
	end
end

function Fish:SetOrder()
	if GameModel:GetInstance().fishOrders[self.vo.fishKind] == nil then 
		GameModel:GetInstance().fishOrders[self.vo.fishKind] = self.vo.fishConfig.MinOrder
	end
	
	-- if self.vo.fishKind == 31 then
	-- 	if (GameModel:GetInstance().fishOrders[self.vo.fishKind] + 4) > self.vo.fishConfig.MaxOrder then
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = self.vo.fishConfig.MaxOrder
	-- 	else 
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = GameModel:GetInstance().fishOrders[self.vo.fishKind] + 4
	-- 	end
	-- 	local fishDepth = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- 	local depthBGBaseSub=fishDepth-2--四周小鱼的起始深度
	-- 	local depthBGBaseMain=fishDepth-1 --主鱼的起始深度
	
	-- 	self.transform:Find("Bone/Fish1/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseMain
	-- 	self.transform:Find("Bone/Fish1/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish2/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseSub
	-- 	self.transform:Find("Bone/Fish2/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish3/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseSub
	-- 	self.transform:Find("Bone/Fish3/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish4/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseSub
	-- 	self.transform:Find("Bone/Fish4/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish5/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseSub
	-- 	self.transform:Find("Bone/Fish5/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- elseif  self.vo.fishKind==32 or self.vo.fishKind==33 then

	-- 	if (GameModel:GetInstance().fishOrders[self.vo.fishKind] + 3) > self.vo.fishConfig.MaxOrder then
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = self.vo.fishConfig.MaxOrder
	-- 	else 
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = GameModel:GetInstance().fishOrders[self.vo.fishKind] + 3
	-- 	end
	-- 	local fishDepth = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- 	local depthBGBaseMain=fishDepth-1 --主鱼的起始深度
	
	-- 	self.transform:Find("Bone/Fish1/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseMain
	-- 	self.transform:Find("Bone/Fish1/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish2/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseMain
	-- 	self.transform:Find("Bone/Fish2/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- 	self.transform:Find("Bone/Fish3/Bg"):GetComponent(typeof(SpriteRenderer)).sortingOrder=depthBGBaseMain
	-- 	self.transform:Find("Bone/Fish3/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder=fishDepth

	-- elseif self.vo.fishKind == 26 then
	-- 	if (GameModel:GetInstance().fishOrders[self.vo.fishKind] + 2) > self.vo.fishConfig.MaxOrder then
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = self.vo.fishConfig.MaxOrder
	-- 	else 
	-- 		GameModel:GetInstance().fishOrders[self.vo.fishKind] = GameModel:GetInstance().fishOrders[self.vo.fishKind] + 2
	-- 	end
	-- 	if self._mainFishSp then  self._mainFishSp.sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]-1 end 
	-- 	if self._shadowFishSp then self._shadowFishSp.sortingOrder = (GameModel:GetInstance().fishOrders[self.vo.fishKind] -2) end
	-- 	for index,subIndex in pairs(self._subFishList) do
	-- 		for _,go in pairs(subIndex) do
	-- 			go.transform:Find("Bone/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	--         	--go.transform:Find("Bone/shadow"):GetComponent(typeof(SpriteRenderer)).sortingOrder = depthBaseSub+1;
	--         end
	-- 	end
	-- 	-- self.transform.Find("Fish1"):GetComponent(typeof(SpriteRenderer)).sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- 	-- self.transform.Find("Fish2"):GetComponent(typeof(SpriteRenderer)).sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- 	-- self.transform.Find("Fish3"):GetComponent(typeof(SpriteRenderer)).sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- 	-- self.transform.Find("Fish4"):GetComponent(typeof(SpriteRenderer)).sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind]
	-- else
	if (GameModel:GetInstance().fishOrders[self.vo.fishKind] + 1) > self.vo.fishConfig.MaxOrder then
		GameModel:GetInstance().fishOrders[self.vo.fishKind] = self.vo.fishConfig.MaxOrder
	else 
		GameModel:GetInstance().fishOrders[self.vo.fishKind] = GameModel:GetInstance().fishOrders[self.vo.fishKind] + 1
	end 
 	if self.skinnedMeshRender then self.skinnedMeshRender.sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind] end
	-- if self._mainFishSp then  self._mainFishSp.sortingOrder = GameModel:GetInstance().fishOrders[self.vo.fishKind] end 
	-- if self._shadowFishSp then self._shadowFishSp.sortingOrder = (GameModel:GetInstance().fishOrders[self.vo.fishKind] -1) end
	-- end

end

function Fish:FishNormalDie(hitFishMsg,player,callBack)	

	FishBase.FishBaseDie(self,hitFishMsg,player)
	self.callBack=callBack
	local playsound = math.random(1,10)
	if playsound > 6 and GameController:GetInstance().view.FishDieSoundCount < 4 then
		local soundName = {"effect2311","effect2312","effect2313","effect2314","effect2315","effect2316","effect2317","effect2318","effect2319","effect2320"}
		local name = soundName[math.random(1,10)]
		GameController:GetInstance():PlayFishDieSound(name)
		GameController:GetInstance().view.FishDieSoundCount = GameController:GetInstance().view.FishDieSoundCount + 1
	end
	print("-------------------------------------")
	if self.vo.fishConfig.dieEffect~=nil then
		--[[if self.vo.fishKind ~= 25 and self.vo.fishKind ~= 39 and self.vo.fishKind ~= 38 and self.vo.fishKind ~= 35 and  self.vo.fishKind ~= 34 then
			self.gameObject:SetActive(false)
		end--]]

		local explosiveName = self.vo.fishConfig.dieEffect
		--print(explosiveName)
		-- if self.vo.fishKind == 28 then
		-- 	if self.fishStatus == 0 then
		-- 		explosiveName = nil
		-- 		GameController:GetInstance():PlayFishDieSound("38")
		-- 	else
		-- 		GameController:GetInstance():PlayFishDieSound("31")
		-- 	end
		-- end

		-- if self.vo.fishKind == 26 then
		-- 	if self.fishStatus == 1 then
		-- 		GameController:GetInstance():PlayFishDieSound("45")
		-- 	end
		-- end
		
		print("self.vo.fishConfig.isSpineEffect   ===================  ",self.vo.fishConfig.isSpineEffect)
		if self.vo.fishConfig.isSpineEffect == 1 then
			--GameController:GetInstance().view:PlayExplosive(explosiveName, self.transform.position);
			--print("冰冻鱼特效播放----------------------")
			GameController:GetInstance():PlayFishDieSound(115)
			StartCoroutine(function ()
				-- body
				yield_return(WaitForSeconds(10))
				GameController:GetInstance():StopFishDieSound(115)
			end)
			GameController:GetInstance().view:PlayExplosive5(explosiveName, 10);
		elseif self.vo.fishConfig.isSpineEffect == 2 then
			local effectPos = self.transform.position
			local fishKind = self.vo.fishKind 
			GameController:GetInstance().view:PlayExplosive2(explosiveName, effectPos);
		elseif self.vo.fishConfig.isSpineEffect == 3 then
			GameController:GetInstance().view:PlayExplosive3(explosiveName, self.transform.position);
			GameController:GetInstance():PlayFishDieSound(26)
		elseif self.vo.fishConfig.isSpineEffect == 5 then
			GameController:GetInstance().view:PlayExplosive5(explosiveName,10)
		end
		
		if self.vo.ishongBaoFish and player.isMe then
			GameController:GetInstance().view:PlayHongBaoEffect(explosiveName,Vector3.zero);
		end
	end

	if self._sps then
    	for i=0,self._sps.Length-1 do
    		self._sps[i].color = Color(1,1,1,1)
    	end
    end

	if self._mainFishSp then self._mainFishSp.color=Color.white end
	
	if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end

	if self.vo.fishConfig.isDieAnimation==1 and self.animator then  
		self.animator:Play("Fish_die")
	 end
	
	for _,subIndex in pairs(self._subFishList) do
		for _,go in pairs(subIndex) do
			if self.vo.fishKind ~= 24 then
				local _ani=go.transform:GetComponent(typeof(Animation))
				local err=StringSplit(tostring(_ani),":")[1]
				if err~="null" and err~="nil" then
					_ani:Play("Fish_die")
				end
			end
			local f=go.transform:Find("Bone/Fish")
			if f then f:GetComponent(typeof(SpriteRenderer)).color=Color.white end
			local shadowSp = go.transform:Find("Bone/Shadow")
			if shadowSp then  shadowSp:GetComponent(typeof(SpriteRenderer)).color=Color(0,0,0,0) end
		end
	end
end

function Fish:FishBombDie(hitFishMsg,player,callBack)
	self._dieTime=0
	self.isPause=true
	self.isStop=true
	self._isCanBeHit = false
	self._lb.isMoving = false
	self.callBack=callBack
	if self._sps then
    	for i=0,self._sps.Length-1 do
    		self._sps[i].color = Color(1,1,1,1)
    	end
    end

	if self._mainFishSp then self._mainFishSp.color=Color.white end
	
	if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end
end

function Fish:ResetNormal()
	self._dieTime=0
	self.isPause= false
	self.isStop= false
	self._isCanBeHit = true
	self._lb.isMoving = true
	--[[local localCollider = self.gameObject:GetComponents(typeof(CS.UnityEngine.SphereCollider))
	local err=StringSplit(tostring(localCollider),":")[1]
	if  err~="null" and err~="nil" then 
		for i=0,localCollider.Length-1  do
			localCollider[i].enabled = true
		end
		
	end--]]

	if self._sps then
    	for i=0,self._sps.Length-1 do
    		self._sps[i].color = Color(1,1,1,1)
    	end
    end

	if self._mainFishSp then self._mainFishSp.color=Color.white end
	
	if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end
end

function Fish:PlayDeadAni()
	if self.vo.fishConfig.playDieAni then
		
	end
end

function Fish:__delete( ... )
	
end