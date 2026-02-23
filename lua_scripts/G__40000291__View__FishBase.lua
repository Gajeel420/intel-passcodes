FishBase=BaseClass()
local Vector3Dot=Vector3.Dot
local Vector3Angle=Vector3.Angle
local Vector3Cross=Vector3.Cross
local Vector3Lerp=Vector3.Lerp
function FishBase:__init(...)
	self._tag="Fish"
	self.transform=nil
	self.gameObject=nil
	self.animator = nil
	self._moveSpeed=0
	self.endPos=Vector3.zero
	self.beginPos=Vector3.zero
	self._isBeHit=false
	self.m_redTime=0
	self._dieTime=0
	self._aniDie=nil
	self.isCanSeen=false
	self.attackInterval = 2.5
	self.attackTime = 2.5

	self.tieQiuTime = 6.0
	self.tieQiuInterval = 6.0
end
function FishBase:Build( vo )
	self.vo = vo;
	self.endPos=Vector3.zero
	self.beginPos=Vector3.zero
	self._dieTime=0
	self.m_redTime=0
	self.callBack=nil
    self._isCanBeHit = true;
    self.isCanMove=false
    self._tweenAlphaTime = 0.5;
    self._tempTweenAlphaTime = self._tweenAlphaTime;
    self.isAlphaSetting = false;
	self._subFishList = {}
	local instance =GameController:GetInstance().view:GetFishPrefabByPool(self.vo.fishKind);
    if instance==nil then  print("获取FishInstance失败==>",self.vo.fishKind)  return false end
    local t=GameController:GetInstance().view.m_poolFish:Spawn(instance).transform
    t.gameObject:SetActive(true)
    self.gameObject=t.gameObject
    self.gameObject.name= "fish_".. self.vo.fishKind .."_"..self.vo.uid
	self.transform=t
	-- if self.vo.fishKind == 33 then
	-- 	self.gameObject.tag = "Game_UI"
	-- else
	self.gameObject.tag=self._tag
	--end
	-- self.localPosition=self.transform.localPosition
	-- self.position=self.transform.position
	-- self.transform.eulerAngles=self.vo.eulerAngles

    return true
end
function FishBase:ReBuild(vo)
	self.gameObject:SetActive(true)
	self.vo = vo;
	self.endPos=Vector3.zero
	self.beginPos=Vector3.zero
	self.callBack=nil
	self._dieTime=0
	self.m_redTime=0
    self._isCanBeHit = true;
    self._tweenAlphaTime = 0.5;
    self._tempTweenAlphaTime = self._tweenAlphaTime;
    self.isAlphaSetting = false;
    self._isBeHit=false
    self.isCanDestroy=false
    self.isDie=false
    self.isCanSeen=false
    self.isMovePause=false
	self.isMoveStop=false
	
	
    -- self.gameObject:GetComponent(typeof(BoxCollider)).enabled=true
    --self.transform:GetComponent(typeof(UIWidget)).alpha=1
	self._subFishList = {}
	self.gameObject.name= "fish"..self.vo.uid
end


function FishBase:OnLoadObject(t)
	-- self.gameObject.name="fish_id"..":"..self.vo.fishKind.."_"..self.vo.uid
	self._lb=self.gameObject:GetComponent(typeof(LuaBehaviour))
	if not self._lb then
		self._lb=self.gameObject:AddComponent(typeof(LuaBehaviour))
		self._lb.m_luaTable=self

		--self._lb.onPressCallBack=function(press) self:OnPress(press) end
		
		-- if self.vo.fishKind == 33 or self.vo.fishKind == 23 then
		-- 	self._lb.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end	
		-- end
	end
	self.collider = self.gameObject:GetComponent(typeof(CS.UnityEngine.SphereCollider))
end
function FishBase:OnPress(press)
	if press == false then return end

	local me=GameController:GetInstance().view.m_playerGroups[GameModel:GetInstance().m_myClientDesk]
	if not me then
		return 
	end

	me:OnPressMouseFish(self,press)
end

function FishBase:OnTriggerEnter( other )
    local beHitFish=nil
    if other.gameObject:CompareTag("Fish") then
        local fish=other.gameObject:GetComponent(typeof(LuaBehaviour)).m_luaTable
        if  self._targetFish and self._targetFish:IsCanBeHit() and not self._targetFish:IsDie() and not self._targetFish.isCanDestroy and self._targetFish:CheckBoundValid() then
            if self._targetFish==fish then
                beHitFish=fish
            end
        else
            if  fish and fish:IsCanBeHit() and not fish:IsDie() and not fish.isCanDestroy and fish:CheckBoundValid() then
                beHitFish=fish
            end
        end
	
		if not beHitFish or beHitFish.vo.fishKind == 23 or beHitFish.vo.fishKind == 29 or beHitFish.vo.fishKind == 30 or beHitFish.vo.fishKind == 31 or beHitFish.vo.fishKind == 32  or beHitFish.vo.fishKind == 33 then
            beHitFish = nil
            return;
        end
		
		if self.vo.fishKind == 33 then
			beHitFish:BeHit(0.2)
			--beHitFish._isCanBeHit = false
			GameController:GetInstance():SendClickZhaDan(60006,beHitFish.vo.uid,self.vo.uid,self.vo.byChairId)
		end
    end
end

function FishBase:SetBorn(fbBorn)
	self.transform.localPosition = fbBorn.pos;
end
function FishBase:SetParent( parent)
	if self.transform then
		self.transform.parent = parent
	else
		print("当前Fish的Transform为nil")
		self.gameObject.transform.parent=parent
	end
    
end
function FishBase:SetScale( scale)
	self._lb:SetLocalScale(scale.x,scale.y,scale.z)
end
function FishBase:SetEulerAngles( angles)
    -- self.transform.localEulerAngles = angles;
end
function FishBase:SetMoveSpeed( speed)
    self._moveSpeed = speed;
end
function FishBase:GetObject()
    return self.gameObject;
end
function FishBase:GetPosition()
	return self.transform.position
end
function FishBase:GetLocalPosition()
    return self.transform.localPosition;
end
function FishBase:IsDie( ... )
	return self.isDie
end
function FishBase:BeHit(redTime)
	self._isBeHit = true;
	self.m_redTime = redTime;
    return self._isBeHit;
end
function FishBase:IsCanBeHit(  )
	-- if self.vo ~= nil then
	-- 	return true
	-- else
	return self._isCanBeHit
	-- end
end
function FishBase:HallFishSize( ... )
	if self.vo and self.vo.fishConfig then
		return self.vo.fishConfig.fishWidth/2
	end
	
	return 0
end
function FishBase:Update( ... )

	if self.isCanDestroy then return end
	
	if self:IsDie() and not self.isCanDestroy then
		if self._dieTime>= self.vo.fishConfig.dieTime then 
			self.isCanDestroy=true
			return
		else 
			if self._dieTime >= (self.vo.fishConfig.dieTime * 0.63) then
				self:FishAlphaChange()
			end
			self._dieTime=self._dieTime+Time.deltaTime
		end
	end

	-- if self.vo.fishKind== 44 then
	-- 	self.attackTime = self.attackTime + Time.deltaTime
	-- 	if self.attackTime >= self.attackInterval then 
	-- 		for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
	-- 			if fish1.vo.fishKind ~= self.vo.fishKind and fish1.vo.fishKind <=14 and fish1:CheckFishIsLive()  then
	-- 				local distance=Vector3.Distance(self.transform.localPosition,fish1.transform.localPosition)
	-- 				if distance<= 180 then
	-- 					fish1:BeHit(0.2)
	-- 					GameController:GetInstance():SendClickZhaDan(60006,fish1.vo.uid,self.vo.uid,self.vo.byChairId)
	-- 				end
	-- 			end
	-- 		end
	-- 		GameController:GetInstance():PlayFishDieSound("SND_14_ENETLOOP")
	-- 		self.attackTime  = 0
	-- 	end
	-- end

	if self._isBeHit and not self.isCanDestroy   then --and not self:IsDie()
		if self.m_redTime>0 then 
			self.m_redTime=self.m_redTime-Time.deltaTime
			if self._sps then
				for i=0,self._sps.Length-1 do
					self._sps[i].color = Color.red 
				end
			end

			if self.skeletonAnimator then
				self.skeletonAnimator.skeleton.R = 1 --0.823
				self.skeletonAnimator.skeleton.G = 0 --0.823
				self.skeletonAnimator.skeleton.B = 0 --0.823
				self.skeletonAnimator.skeleton.A = 1
			end

			if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end
		else
			self.m_redTime=self.m_redTime-Time.deltaTime
			if not self.vo.ishongBaoFish then
				if self._sps then
					for i=0,self._sps.Length-1 do
						self._sps[i].color = Color.white 
					end
				end
			else
				if self._sps then
					for i=0,self._sps.Length-1 do
						self._sps[i].color = Color(1,0,0.89,1)
					end
				end
			end

			if self.skeletonAnimator then
				self.skeletonAnimator.skeleton.R= 1
				self.skeletonAnimator.skeleton.G= 1
				self.skeletonAnimator.skeleton.B= 1
				self.skeletonAnimator.skeleton.A= 1
			end

			if self._shadowFishSp then 	self._shadowFishSp.color = Color(0,0,0,0.255) end
			self._isBeHit=false
		end
	end

	if GameModel:GetInstance().gameState==GameLuaDefine.GameState.JieSuan then 
		self._lb:ChangeFishScene() 
		self._isCanBeHit=false 
	end
	--波浪
	if GameModel:GetInstance().gameState==GameLuaDefine.GameState.JieSuan  then  --and self.transform.localPosition.x>=GameController:GetInstance().view.m_sliderBackground.thumb.localPosition.x
		self.isAlphaSetting = true;
		self._isCanBeHit = false;
	end

	if self.isAlphaSetting then
		self:FishAlphaChange()
	end
	
	if self.vo.fishKind == 40 or self.vo.fishKind == 41 or self.vo.fishKind == 42 or self.vo.fishKind == 43 or
	   self.vo.fishKind == 44 or self.vo.fishKind == 45 or self.vo.fishKind == 46 or
	   self.vo.fishKind == 48 or self.vo.fishKind == 49 or self.vo.fishKind == 50 or self.vo.fishKind == 51 or  
	   self.vo.fishKind == 52 or self.vo.fishKind == 53 or self.vo.fishKind == 54 or self.vo.fishKind == 55 then
	 	self.transform.localEulerAngles =  Vector3(0,0,0)
 	end
end

function FishBase:FishAlphaChange()
	self._tempTweenAlphaTime =self._tempTweenAlphaTime-Time.deltaTime;
	if self._sps then
		local valueAlpha = self._tempTweenAlphaTime / self._tweenAlphaTime
		if valueAlpha >0 then
			for i=0,self._sps.Length-1 do
				local spColor  = self._sps[i].color
				if self._sps[i].color.a > valueAlpha then
					spColor.a = valueAlpha
					self._sps[i].color = spColor
				end
			end
		else
			for i=0,self._sps.Length-1 do
				local spColor  = self._sps[i].color
				spColor.a = 0
				self._sps[i].color = spColor
			end
		end
	end
	
	if self.skeletonAnimator then
		local valueAlpha = self._tempTweenAlphaTime / self._tweenAlphaTime
		if valueAlpha >0 then
			self.skeletonAnimator.skeleton.A= valueAlpha
		else
			self.skeletonAnimator.skeleton.A = 0
		end
	end
end

function FishBase:BeginMove()
	self.isCanSeen=false
	self.isCanMove=true
	local fishWidth = 0
	local fishHeight = 0
	if self.collider then 
		-- local size = self.collider.radius
		-- fishWidth =  size * 0.5 + 8;
		-- fishHeight = size * 0.5 + 8;
		-- if self.vo.fishKind == 36 then
		-- 	fishWidth =  1490 * 0.5
		-- 	fishHeight = 750 * 0.5
		-- end
	end


	local curPointIndex = self.vo.StartPointIndex + self.vo.OffsetIndex

	self._lb:FishBeginMove(self.vo.TraceId,fishWidth,fishHeight,curPointIndex);

	if  GameModel:GetInstance().ding== true then
		self._lb.isMoving = false
	else
		self._lb.isMoving = true
	end
end


	--检测鱼是否可被炸死
function FishBase:CheckFishIsLive()
	return not self.isCanDestroy and not self:IsDie() and self:CheckBoundValid() and self:IsCanBeHit() 
end
--边界检测
function FishBase:CheckBoundValid()
	local screenPos=GameController:GetInstance().view.m_camFish:WorldToScreenPoint(self.transform.position)
	if(screenPos.x<0 or screenPos.x>Screen.width) then
		return false
	end
	if(screenPos.y<0 or screenPos.y>Screen.height) then
		return false
	end

	return true
	--return self.isCanSeen;
end

function FishBase:FishBaseDie(hitFishMsg,player)
	self.isCanMove=false
	self.isDie=true
	self._lb.isMoving = false
	self._dieTime=0
	self.isPause=true
	self.isStop=true
	self._isCanBeHit=false 

	self:Shake()
	-- if self.vo.uid == hitFishMsg.dwFishID and GameModel.GetInstance().m_myServerDesk == hitFishMsg.wChairID and self.vo.fishKind<33 then
	-- 	self:PlayDeadSound()
	-- elseif self.vo.uid == hitFishMsg.dwFishID and self.vo.fishKind>=33 then
	-- 	self:PlayDeadSound()
	-- end
	if  self.vo.uid == hitFishMsg.dwFishID then
		if  GameModel.GetInstance().m_myServerDesk == hitFishMsg.wChairID then
			self:PlayDeadSound()
			-- if hitFishMsg.sBaseMul >= 200 then
			-- 	GameController:GetInstance().view:PlayLuckExplosive("LuckyWin",Vector3.zero,hitFishMsg.uTotalScore);
			-- end
		end

		if self.vo.fishKind == 25 then
			GameController:GetInstance():PlayFishDieSound("bombcrab_explode")
		end
	end 
	
	if self.vo.fishKind == 56 then
		player:ShowLieYanFengBao(self.transform,player)
	end
	self:PlayReward(hitFishMsg.uTotalScore,player,hitFishMsg.sBaseMul)
end

function FishBase:FishBaseImmediatelyDie()
	self.isCanMove=false
	self.isDie=true
	self._lb.isMoving = false
	self._dieTime=0
	self.isPause=true
	self.isStop=true
	self.isCanDestroy = true
	--self.gameObject:GetComponent(typeof(BoxCollider)).enabled=false
end

function FishBase:Shake( ... )
	--是否震屏
	if  self.vo.fishConfig.cameraShake == 1 then
		GameController:GetInstance().view:Shake();
	end
end
function FishBase:PlayReward(iFishScore,player,mul)
	if player and self.vo.fishConfig.isShowReward == 1 then
		-- if self.vo.fishConfig.showRewardType==2 then
		-- 	local language=""
		-- 	if GameModel:GetInstance().LanguageType==1 then
		-- 		language=self.vo.fishConfig.lockName[1]
		-- 	else
		-- 		language=self.vo.fishConfig.lockName[2]
		-- 	end
		-- 	player:ShowRewardByType(iFishScore,self.vo.fishConfig.showRewardType,language,self.vo.fishConfig.lockIcon,mul);
		-- else

			 player:ShowRewardByType(iFishScore,self.vo.fishConfig.showRewardType,self.vo.fishConfig.lockName,self.vo.fishConfig.lockIcon,mul);
		--end
       
		player:LieYanFengBaoUIMoney(iFishScore)
	end
end
function FishBase:PlayDeadSound()
	-- 播放死亡声音
	if self.vo.fishConfig.dieSound~=nil then
		local count=#self.vo.fishConfig.dieSound
		local ret = 1
		if count > 1 then 
			 ret=math.random(count)
		end
		if self.vo.fishConfig.dieSound[ret] then
			GameController:GetInstance():PlayFishDieSound(self.vo.fishConfig.dieSound[ret])
		end
	end
end
function FishBase:SetDepth( depth )
	if self._mainFishSp then self._mainFishSp.sortingOrder=depth+1 end
	if self._shadowFishSp then self._shadowFishSp.sortingOrder=depth end
	for _,subIndex in pairs(self._subFishList) do
		for _,go in pairs(subIndex) do
			go.transform:Find("Bone/Fish"):GetComponent(typeof(SpriteRenderer)).sortingOrder = depth + 2;
        	--go.transform:Find("Bone/shadow"):GetComponent(typeof(SpriteRenderer)).sortingOrder = depth + 1;
        end
    end
end
function FishBase:__delete()

	if self.hitFishMsg then
		self.hitFishMsg.localPosition=self:GetLocalPosition()
	end
	
	if self.callBack then self.callBack(self.hitFishMsg) end

	-- if self.vo.fishKind == 45 or self.vo.fishKind == 46 or self.vo.fishKind == 47 then
	-- 	GameController:GetInstance():PlayBgAudio(math.random(5,9))
	-- end

	self.gameObject:SetActive(false)
	self.isCanSeen=false
	self._lb.isMoving = false
	self.transform.localPosition=Vector3(100000,100000,0)
	--self.vo:Destroy()
	--回收vo
	GameModel:GetInstance():RecycleFishVo(self.vo)
	self.vo=nil
	if self._subFishList and next(self._subFishList) then
		for _,subIndex in pairs(self._subFishList) do
			for _,go in pairs(subIndex) do
				GameController:GetInstance().view.m_poolFish:Despawn(go.transform)
				go.transform.parent = GameController:GetInstance().view.m_poolFish.transform;
			end
		end
	end
	self._subFishList = nil
end