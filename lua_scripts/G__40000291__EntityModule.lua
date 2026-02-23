EntityModule=BaseClass()

function EntityModule:__init( ... )
	self.fishList={}
	self.removeFishs={}
	self.dirtyFishs={}
	self.fishMoneyList={}
	self.disableFishMoneyList={}
	self.removeFishMoneys={}
	self.fishMoneyUid=0
	self.thunderList={}
	self.disableThunderList={}
	self.removeThunders={}
	self.thunderUid=0
	self.floatNumList={}
	self.disableFloatNumList={}
	self.removeFloatNums={}
	self.floatNumUid=0
	
	self.dropObjUid = 0
	self.dropObjs = {}
	self.removeDropObjs= {}


	self.killLeiSheUid = 0
	self.killLeiSheList = {}
	self.removeKillLeiShe= {}
	-- self.quadTree=QuadTree.New(5000,5000,-5000,-5000)


	self.zuantouUid = 0
	self.zuantouList = {}
	self.removeZuantou= {}
end

function EntityModule:Update( ... )
	-- for i,fish in pairs(self.removeFishs) do
	-- 	self:RemoveFish(fish)
	-- end
	-- self.removeFishs={}

	--Profiler.BeginSample("22222222222222222222222222222222")
	for k,fish in pairs(self.fishList) do
		if fish.isCanDestroy then
			--table.insert(self.removeFishs,fish)
			self:RemoveFish(fish)
		else
    		fish:Update()
			-- self.quadTree.SetLeaf(fish)
		end
	end
	--Profiler.EndSample()

	-- for i,uid in pairs(self.removeFishMoneys) do
	-- 	self:RemoveFishMoney(uid)
	-- end
	-- self.removeFishMoneys={}

	for k,fishMoney in pairs(self.fishMoneyList) do
		if fishMoney.isCanDestroy then
			--table.insert(self.removeFishMoneys,fishMoney.uid)
			self:RemoveFishMoney(k)
		else
			fishMoney:Update()
		end
	end

	-- for i,uid in pairs(self.removeDropObjs) do
	-- 	self:RemoveDropObj(uid)
	-- end
	-- self.removeDropObjs={}
	-- for k,dropObj in pairs(self.dropObjs) do
	-- 	if dropObj.isCanDestroy then
	-- 		table.insert(self.removeDropObjs,dropObj.uid)
	-- 	else
	-- 		dropObj:Update()
	-- 	end
	-- end

	-- for i,uid in pairs(self.removeKillLeiShe) do
	-- 	self:RemoveLeiShe(uid)
	-- end
	-- self.removeKillLeiShe={}
	-- for k,leiShe in pairs(self.killLeiSheList) do
	-- 	if leiShe.isCanDestroy then
	-- 		table.insert(self.removeKillLeiShe,leiShe.uid)
	-- 	else
	-- 		leiShe:Update()
	-- 	end
	-- end

	-- for i,uid in pairs(self.removeThunders) do
	-- 	self:RemoveThunder(uid)
	-- end
	-- self.removeThunders={}
	for k,thunder in pairs(self.thunderList) do
		if thunder.isCanDestroy then
			--table.insert(self.removeThunders,thunder.uid)
			self:RemoveThunder(thunder.uid)
		else
			thunder:Update()
		end
	end
	-- for i,uid in pairs(self.removeFloatNums) do
	-- 	self:RemoveFloatNum(uid)
	-- end
	-- self.removeFloatNums={}
	for k,floatNum in pairs(self.floatNumList) do
		if floatNum.isCanDestroy then
			--table.insert(self.removeFloatNums,floatNum.uid)
			self:RemoveFloatNum(floatNum.uid)
		else
			floatNum:Update()
		end
	end

	-- for i,uid in pairs(self.removeZuantou) do
	-- 	self:RemoveZuanTou(uid)
	-- end
	-- self.removeZuantou={}
	-- for k,zuanTou in pairs(self.zuantouList) do
	-- 	if zuanTou.isCanDestroy then
	-- 		--table.insert(self.removeZuantou,zuanTou.uid)
	-- 		self:RemoveZuanTou(zuanTou.uid)
	-- 	else
	-- 		zuanTou:Update()
	-- 	end
	-- end
end

function EntityModule:CreateFish(fishVo)
	if self.fishList[fishVo.uid] then
		return self.fishList[fishVo.uid]
	end
	local fish=nil
	if self.dirtyFishs and self.dirtyFishs[fishVo.fishKind] and next(self.dirtyFishs[fishVo.fishKind]) then
		fish=table.remove(self.dirtyFishs[fishVo.fishKind],1)
		fish:ReBuild(fishVo)
	else
		-- if fishVo.fishKind==22 or fishVo.fishKind==35 or fishVo.fishKind==38 then  --
		-- 	fish=SpineFish.New()
		-- else
			fish=Fish.New()
		--end
		if not fish:Build(fishVo) then
			print("创建实体的鱼失败。。。。")
			return nil
		end
	end
	self.fishList[fishVo.uid]=fish
	return fish
end

-- function EntityModule: ScreenHasFish()
-- 	for k,fish in pairs(self.fishList) do
-- 		if fish:CheckBoundValid() and not fish:IsDie() then
-- 			return 1
-- 		end
-- 	end 
-- 	return 0 
-- end

function EntityModule:RemoveFish( fish )
	if self.fishList[fish.vo.uid] then
		local fish=self.fishList[fish.vo.uid]
		-- self.quadTree.RemoveLeaf(fish)
		if not self.dirtyFishs[fish.vo.fishKind] then
			self.dirtyFishs[fish.vo.fishKind]={}
		end
		table.insert(self.dirtyFishs[fish.vo.fishKind],fish)
		self.fishList[fish.vo.uid]=nil
		fish:Destroy()
	end
end
function EntityModule:RemoveAllFish( ... )
	for k,fish in pairs(self.fishList) do
		if not self.dirtyFishs[fish.vo.fishKind] then
			self.dirtyFishs[fish.vo.fishKind]={}
		end
		table.insert(self.dirtyFishs[fish.vo.fishKind],fish)
		fish:Destroy()
	end
	self.fishList={}
	self.removeFishs={}
end
function EntityModule:DestroyAllFish()
	self.dirtyFishs={}
	self.fishList={}
	self.removeFishs={}
end

function EntityModule:CreateDropObj( kind )
	local prefab=GameController:GetInstance().view.m_dropObjPrefabs[kind] --m_fishMoneyPrefabs[kind]
	local t=GameController:GetInstance().view.m_poolDrop:Spawn(prefab).transform
	t.gameObject:SetActive(true)
	local fm= DropSpecial.New(t)  --FishMoney.New(t)
	if self.dropObjUid>=1000000 then
		self.dropObjUid=1
	end
	self.dropObjUid=self.dropObjUid+1
	fm.uid=self.dropObjUid
	self.dropObjs[fm.uid]=fm
	return fm
end

function EntityModule:RemoveDropObj( uid )
	if self.dropObjs[uid] then
		local fm=self.dropObjs[uid]
		fm:Destroy()
		self.dropObjs[uid]=nil
	end
end


function EntityModule:CreateLeiShe( kind )
	local prefab=GameController:GetInstance().view.m_killLeiShePrefabs[kind] --m_fishMoneyPrefabs[kind]
	local t=GameController:GetInstance().view.m_poolKillLeiShe:Spawn(prefab).transform
	t.gameObject:SetActive(true)
	local fm= KillLeiShe.New(t)  --FishMoney.New(t)
	if self.killLeiSheUid>=1000000 then
		self.killLeiSheUid=1
	end
	self.killLeiSheUid=self.killLeiSheUid+1
	fm.uid=self.killLeiSheUid
	self.killLeiSheList[fm.uid]=fm
	return fm
end

function EntityModule:RemoveLeiShe( uid )

	if self.killLeiSheList[uid] then
		local fm=self.killLeiSheList[uid]
		fm:Destroy()
		self.killLeiSheList[uid]=nil
	end
end


function EntityModule:CreateZuanTou( kind )
	local prefab=GameController:GetInstance().view.m_zuanTouPrefabs[kind] --m_fishMoneyPrefabs[kind]
	local t=GameController:GetInstance().view.m_poolZuanTou:Spawn(prefab).transform
	t.gameObject:SetActive(true)
	local fm= ZuanTouBullet.New(t)  --FishMoney.New(t)
	if self.zuantouUid>=1000000 then
		self.zuantouUid=1
	end
	self.zuantouUid=self.zuantouUid+1
	fm.uid=self.zuantouUid
	self.zuantouList[fm.uid]=fm
	return fm
end

function EntityModule:RemoveZuanTou( uid )

	if self.zuantouList[uid] then
		local fm=self.zuantouList[uid]
		fm:Destroy()
		self.zuantouList[uid]=nil
	end
end




function EntityModule:CreateFishMoney( kind )
	if self.fishMoneyUid>=50000 then
		self.fishMoneyUid=1
	end
	self.fishMoneyUid=self.fishMoneyUid+1

	if(self.disableFishMoneyList and #self.disableFishMoneyList>0) then
		local money=table.remove(self.disableFishMoneyList,1)
		money.uid=self.fishMoneyUid
		self.fishMoneyList[money.uid]=money
		return money
	else
		local prefab=GameController:GetInstance().view.m_fishMoneyPrefabs[kind]
		local t=GameController:GetInstance().view.m_poolFishMoney:Spawn(prefab).transform
		--t.gameObject:SetActive(true)
		local fm=FishMoney.New(t)
		
		fm.uid=self.fishMoneyUid
		self.fishMoneyList[fm.uid]=fm
		return fm
	end
end
function EntityModule:RemoveFishMoney( uid )
	if self.fishMoneyList[uid] then
		local fm=self.fishMoneyList[uid]
		fm.gameObject:SetActive(false)
		table.insert(self.disableFishMoneyList,fm)
		--fm:Destroy()
		self.fishMoneyList[uid]=nil
	end
end
function EntityModule:RemoveAllFishMoney( ... )
	for k,fishMoney in pairs(self.fishMoneyList) do
		--fishMoney:Destroy()
		self:RemoveFishMoney(k)
	end
	--self.fishMoneyList={}
	--self.removeFishMoneys={}
end
function EntityModule:CreateThunder( kind )
	if self.thunderUid>=10000 then
		self.thunderUid=1
	end
	self.thunderUid=self.thunderUid+1

	if(self.disableThunderList and #self.disableThunderList>0) then
		local thunder=table.remove(self.disableThunderList,1)
		thunder.uid=self.thunderUid
		self.thunderList[thunder.uid]=thunder
		return thunder
	else
		local prefab=GameController:GetInstance().view.m_thunderPrefabs[kind]
		if prefab ~= nil then
			local t=GameController:GetInstance().view.m_poolThunder:Spawn(prefab).transform
			--t.gameObject:SetActive(true)
			local et=EffectThunder.New(t)	
			et.uid=self.thunderUid
			self.thunderList[et.uid]=et
			return et
		else
			print("对象为 nil     ",kind)
			return nil
		end
	end
end

function EntityModule:RemoveThunder( uid )
	if self.thunderList[uid] then
		local t=self.thunderList[uid]
		t.gameObject:SetActive(false)
		table.insert(self.disableThunderList,t)
		-- t:Destroy()
		self.thunderList[uid]=nil
	end
end
function EntityModule:RemoveAllThunder( ... )
	for k,thunder in pairs(self.thunderList) do
		--thunder:Destroy()
		self:RemoveThunder(k)
	end
	-- self.thunderList={}
	-- self.removeThunders={}
end
function EntityModule:CreateFloatNum( ... )
	if self.floatNumUid>=50000 then
		self.floatNumUid=1
	end
	self.floatNumUid=self.floatNumUid+1
	
	if(self.disableFloatNumList and #self.disableFloatNumList>0) then
		local num=table.remove(self.disableFloatNumList,1)
		num.uid=self.floatNumUid
		self.floatNumList[num.uid]=num
		return num
	else
		local prefab=GameController:GetInstance().view.m_floatNumPrefabs[1]
		local t=GameController:GetInstance().view.m_poolFloatNum:Spawn(prefab).transform		
		local fn=FloatNum.New(t)		
		fn.uid=self.floatNumUid
		self.floatNumList[fn.uid]=fn
		return fn
	end
end
function EntityModule:RemoveFloatNum( uid )
	if self.floatNumList[uid] then
		local fn=self.floatNumList[uid]
		fn.gameObject:SetActive(false)
		table.insert(self.disableFloatNumList,fn)
		--fn:Destroy()
		self.floatNumList[uid]=nil
	end
end
function EntityModule:RemoveAllFloatNum( ... )
	for k,floatNum in pairs(self.floatNumList) do
		--floatNum:Destroy()
		self:RemoveFloatNum(k)
	end
	-- self.floatNumList={}
	-- self.removeFloatNums={}
end
function EntityModule:GetFishByFishUID( uid )
	return self.fishList[uid]
end
function EntityModule:GetFishByFishInfo(info)
	for _,fish in pairs(self.fishList) do
		if fish.vo.fishKind==info.kind and info.uid~=fish.vo.uid then
			if fish:CheckBoundValid() and not fish:IsDie() and not fish.isCanDestroy and fish:IsCanBeHit() then
				return fish
			end
		end
	end
	return nil
end
function EntityModule:PauseAllFish()
	for k,fish in pairs(self.fishList) do
		if not fish.isCanDestroy then
			fish.isCanMove=false
			fish._lb.isMoving = false
		end
	end
end
function EntityModule:ResumeAllFish()
	for k,fish in pairs(self.fishList) do
		if not fish.isCanDestroy and not fish:IsDie() then
			fish.isCanMove=true
			fish._lb.isMoving = true
		end
	end
end
function EntityModule:__delete( ... )
	self:RemoveAllFloatNum()
	self:RemoveAllFishMoney()
	self:DestroyAllFish()
	self:RemoveAllThunder()
end