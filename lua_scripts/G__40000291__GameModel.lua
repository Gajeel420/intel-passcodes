GameModel=BaseClass(LuaModel)

function GameModel:__init( ... )
	self.fishRawData={}
	self.fShootInterval=0.2
	self.bulletSpeed = 760
	self.isFastSpeed = false
	self.listFishVo={}
	self.ResolutionWidth=1560
	self.ResolutionWidthHalf=1560/2
	self.ResolutionHeight=960
	self.ResolutionHeightHalf=960/2
	self.localFishAutoIDList={}

	self.hongBaoMoney = 0

	self.fishOrders ={}
	self._bulletId=0
	self.byFixTimes =0
	self.m_maxBulletCount=6
	self.m_isLockShoot=false
	self.m_isAutoShoot=false
	self.ChangeSceneTime= 2.5
	self.FishGoAwayTime = 1 --切换场景时鱼移出屏幕的时间
	self.m_myServerDesk=-1
	self.gameState=GameLuaDefine.GameState.None
	self.listFishXml={}
	self.soundVolume=SystemSetting:GetInstance():GetIsSoundOn() and 1 or 0
	self.musicVolume=SystemSetting:GetInstance():GetIsBGMusicOn() and 1 or 0
	self.fishVos={}
	self.ding=false
	-- local insert=table.insert
	-- for i=1,300 do--一次生成100只鱼
	-- 	insert(self.fishVos,FishVo.New())
	-- end
	self.LanguageType=1
	local LanguageType=""
	self.LocalizationManager = CS.I2.Loc.LocalizationManager
	if SystemSetting:GetInstance() then
		LanguageType=SystemSetting:GetInstance():GetLanguage()
		if LanguageType and LanguageType=="English" then
			self.LanguageType=2
			--self.LocalizationManager.CurrentLanguage="English"
		else
			--self.LocalizationManager.CurrentLanguage="Chinese"
		end
	end
end

-- function GameModel:SpawnFishVo()
-- 	if self.fishVos and next(self.fishVos) then
-- 		return table.remove(self.fishVos,1)
-- 	else
-- 		local fishVo=FishVo.New()
-- 		return fishVo
-- 	end
-- end

function GameModel:RecycleFishVo(fishVo)
	-- table.insert(self.fishVos,fishVo)
end
-- function GameModel:RecycleLocalFishID(id)
-- 	self.localFishAutoIDList[id]=nil
-- end
function GameModel:AddFishVo( fishVo )
	table.insert(self.listFishVo,fishVo)
end
function GameModel:ClearFishVo(uid)
	-- local clearKey=0
	-- for key,vo in pairs(self.listFishVo) do
	-- 	if vo.uid==uid then
	-- 		clearKey=key
	-- 		self:RecycleFishVo(vo)
	-- 		break
	-- 	end
	-- end
	-- if clearKey>0 then
	-- 	self.listFishVo[clearKey]=nil
	-- end
end

function GameModel:GetLocalFishAutoID()
	while(true)
	do
		local id=math.random(1,50)-400
		local isHas=false
		for k,idd in pairs(self.localFishAutoIDList) do
			if idd==id then
				isHas=true
			end
		end
		if not isHas then
			table.insert(self.localFishAutoIDList,id)
			return id
		end
	end
	return 0
end

function GameModel.GetFishRotateAngle( moveDirection)
	local angle = Vector3.Angle(moveDirection, (Vector3.right));
	local diectAngle = Vector3.Angle(moveDirection, (Vector3.up));
	if diectAngle>90 then
		angle=-angle
	end
	return angle
end

function GameModel:GetBulletID( ... )
	if self._bulletId>60000 then
		self._bulletId=0
	end
	self._bulletId=self._bulletId+1
	return self._bulletId
end

function GameModel:GetInstance( ... )
	if not GameModel.instance then
		GameModel.instance=GameModel.New()
	end
	return GameModel.instance
end

function GameModel:__delete( ... )
	GameModel.instance=nil
end

