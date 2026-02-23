UIPlayerGroup=BaseClass()

function UIPlayerGroup:__init(obj)
	self.obj=obj
	self.gameObject=obj
	self.transform=obj.transform
	self.m_listBulletRemove={}
	self.m_dicBullet={}
	self.m_dicDirtyBullet={}
	self.m_listNet={}
	self.m_listDirtyNet={}
	self.m_listNetRemove={}
	self.m_listGoldTeamAdd={}
	self.m_listDirtyGoldTeamAdd={}
	self.m_listGoldTeamAddRemove={}
	self._isPress=false
	self:_ResetShootState()
	self._bulletCount=0
	self.isMe=false
	self.isReady=true
	self.lockFishUID=0
	self.direction=0
	self.lockFishs={}
	self.isOtherLockShoot = false 
	self.isShootBullet = true
	self.zuanTou = nil
	self.specialTime = 10
	self.isSpecialCountDown = false
	self.nengLiangPao = false
	self.leiYanBullet = 0
	self.LeiYanScore = 0
	self.isPoChanShow = false
	self.isHeiDongStatus = false
	self.heiDongUID = 0
	self.heidongClick = false

	self.paozuoAnimation = "Ani_PaoZuo01"

	self.isLieyanshenjianStatus = false
	self.LieyanshenjianUID = 0
	self.LieyanshenjianClick = false
	self.HuoYanShenJian = nil
	self.isMoveHuoYanShenJian = false
	self.LieYanShenJianNumber = 5

	self.fishTips = nil
	self.isShowTips = false
	self.ShowTipsTime = 0
	self.TipsGameObject = nil
end

function UIPlayerGroup:Find( ... )
	local transform=self.obj.transform
	-- self.m_lockTeamRoot = transform:Find("Lock").gameObject;
	-- self.m_lockTeamRoot:SetActive(false);
	self.m_lockPointPrefab = transform:Find("Lock/Lockpoint").gameObject;
	self.m_lockPointPrefab:SetActive(false);
	-- self.m_lockPointTeam = transform:Find("Lock/lockPointTeam").gameObject;

	-- self.m_myselfLockTeamRoot =  transform:Find("Lock_Myself").gameObject;
	-- self.m_myselfLockTeamRoot:SetActive(false)
	self.m_myselfLockPointPrefab = transform:Find("Lock_Myself/Lockpoint").gameObject;
	self.m_myselfLockPointPrefab:SetActive(false);
	-- self.m_myselfLockPointTeam = transform:Find("Lock_Myself/lockPointTeam").gameObject;

	-- self.m_lockHead = transform:Find("Lock/LockAni").gameObject;
	self.m_uilabelGunLevel = transform:Find("LevelTeam/levelbg/Label"):GetComponent(typeof(UILabel));
	self.objImHere=transform:Find("Ani_ImHere").gameObject
	self.objImHere:SetActive(false)
	-- self._lockPointList={}
	-- for i=1,50 do
	-- 	local go=GameObject.Instantiate(self.m_lockPointPrefab)
	-- 	go.transform.parent = self.m_lockPointTeam.transform;
	-- 	go.transform.localPosition = Vector3.zero;
	-- 	go.transform.localEulerAngles = Vector3.zero;
	-- 	go.transform.localScale = Vector3.one;
	-- 	go:SetActive(false);
	-- 	self._lockPointList[i]=go;
	-- end
	
	self.objReward1Root=transform:Find("Ani_Win1")
	if self.objReward1Root then
		--self.comReward01=FishKingTips.New(self.objReward1Root)
		self.objReward1Root.gameObject:SetActive(false)
	end

	-- self.objReward2Root=transform:Find("Ani_Win2")
	-- if self.objReward1Root then
	-- 	self.comReward02= BiKaQiuTips.New(self.objReward2Root)
	-- 	self.objReward2Root.gameObject:SetActive(false)
	-- end

	-- self.leiYanFengBaoRoot = transform:Find("Effect_Die_Fis56")
	-- self.leiYanFengBaoRoot.gameObject:SetActive(false)
	-- self.FengBao = LieYanFengBao.New(self.leiYanFengBaoRoot)

	-- self.FireStromBg = transform:Find("FireStromBg").gameObject
	-- self.FireStromPan= transform:Find("FireStromPan").gameObject
	-- self.fireLeiBulletLabel =self.FireStromPan.transform:Find("BG02/Bullet_Amount"):GetComponent(typeof(UILabel)) 
	-- self.fireLeiMoneyLabel =self.FireStromPan.transform:Find("BG01/Monny"):GetComponent(typeof(UILabel)) 
	-- self.FireStromPan:SetActive(false)
	-- self.FireStromBg:SetActive(false)

	-- self.objReward3Root=transform:Find("Ani_Win3")
	-- if self.objReward3Root then
	-- 	self.comReward03=MoTianLunTips.New(self.objReward3Root)
	-- 	self.objReward3Root.gameObject:SetActive(false)
	-- end

	-- self.objReward4Root=transform:Find("Ani_Win4")
	-- if self.objReward4Root then
	-- 	self.comReward04=ZhangYuTips.New(self.objReward4Root)
	-- 	self.objReward4Root.gameObject:SetActive(false)
	-- end

    -- self.changeGunEffect=self.transform:Find("Gun_Team/explosive1_pao").gameObject
    -- self.changeGunEffect:SetActive(false)
    -- self.objReward1Root=transform:Find("Ani_jisha")
    -- self.comReward01=JiShaTips.New(self.objReward1Root)
    -- self.objReward2Root=transform:Find("Ani_bingo")
    -- -- self.comReward02=RewardTips.New(self.objReward2Root)
    -- self.objReward3Root=transform:Find("Ani_bingoboss")
    -- -- self.comReward03=BossTips.New(self.objReward3Root)
    -- self.objReward1Root.gameObject:SetActive(false);
    -- self.objReward2Root.gameObject:SetActive(false);
    -- self.objReward3Root.gameObject:SetActive(false);
    -- self.thunderTipRoot=transform:Find("Ani_Light").gameObject;
	-- self.thunderTipRoot:SetActive(false);
	
	self.m_objAuto = transform:Find("Auto").gameObject;
	self.m_autoSpriAnimation = self.m_objAuto:GetComponent(typeof(UISpriteAnimation))
	self.m_objAuto:SetActive(false)

	self.poChanTips = transform:Find("Tip_PoChan").gameObject
	self.poChanTips:SetActive(false)
	self.aniMarkGo = transform:Find("Ani_Mark").gameObject
	self.aniTimerDownLabel = transform:Find("Ani_Mark/Label"):GetComponent(typeof(UILabel))
	self.aniTimerDownLabel.gameObject:SetActive(true)
	self.aniMarkGo:SetActive(false)

	self.m_objAddBtn = transform:Find("LevelTeam/add").gameObject;
	self.m_objSubBtn = transform:Find("LevelTeam/sub").gameObject;
	UIEventListener.Get(self.m_objAddBtn).onClick = function() self:OnClickAddBtn() end
	UIEventListener.Get(self.m_objSubBtn).onClick = function() self:OnClickSubBtn() end
	self.m_tranPlayerMoneyGroup=transform:Find("PlayerMoneyGroup")
	self.transPlayerGroupAnimator = self.m_tranPlayerMoneyGroup:GetComponent(typeof(Animator))
	self.m_uilabelPlayerMoney = self.m_tranPlayerMoneyGroup:Find("Label"):GetComponent(typeof(UILabel));
	self.m_uilabelPlayerName=self.m_tranPlayerMoneyGroup:Find("LabelName"):GetComponent(typeof(UILabel));
	self.m_tranGoldTeamAdd=self.m_tranPlayerMoneyGroup:Find("GoldTeamAdd")
	self.m_tranFloatMoneyEndPos=self.m_tranPlayerMoneyGroup:Find("FloatMoneyEndPos")
	self.m_tranGunTeam=self.transform:Find("Gun_Team")
	self.m_tranBulletPosition=transform:Find("Gun_Team/Bullets_Position")
	
	local goAs=GameObject("shootSound")
	goAs.transform.parent=self.transform
	self._asShoot=goAs:GetComponent(typeof(AudioSource))
	local err=(StringSplit(tostring(self._asShoot),":"))[1]
	if err=="null" or err=="nil" then
			self._asShoot=goAs:AddComponent(typeof(AudioSource))
	end
	goAs=GameObject("hitSound")
	goAs.transform.parent=self.transform
	self._asHit=goAs:GetComponent(typeof(AudioSource))
	err=(StringSplit(tostring(self._asHit),":"))[1]
	if err=="null" or err=="nil" then
			self._asHit=goAs:AddComponent(typeof(AudioSource))
	end
	goAs=GameObject("rewardSound")
	goAs.transform.parent=self.transform
	self._asReward=goAs:GetComponent(typeof(AudioSource))
	err=(StringSplit(tostring(self._asReward),":"))[1]
	if err=="null" or err=="nil" then
			self._asReward=goAs:AddComponent(typeof(AudioSource))
	end
	self.gunTypeList={}
	for i=1,20 do
		if i >= 4 then
			self.gunTypeList[i]=self.transform:Find("Gun_Team/GunType04")
		else
			self.gunTypeList[i]=self.transform:Find("Gun_Team/GunType0"..i)
		end
		self.gunTypeList[i].gameObject:SetActive(false)
	end
	
	--[[self.paoZuoList = {}
	for i= 1,7 do
		self.paoZuoList[i]=self.transform:Find("PaoZuo0"..i)
		self.paoZuoList[i].gameObject:SetActive(false)
	end--]]

	-- self.lieYanFengBao = self.transform:Find("Gun_Team/FireStromType")

	self.dropDatas = {}
	self.dropType = {}

	--self.DrillGunType = transform:Find("Gun_Team/Sanchaji")
	--self.DrillGunType.gameObject:SetActive(false)

--	self.heiDong = transform:Find("Gun_Team/Heidong").gameObject
--	self.heiDong.gameObject:SetActive(false)
--	self.quan_heiDong = transform:Find("HeiDongQuan/Quan_Heidong").gameObject
--	self.quan_heiDong:SetActive(false)
	
--	self.Lieyanshenjian = transform:Find("Gun_Team/Lieyanshenjian").gameObject
--	self.Lieyanshenjian.gameObject:SetActive(false)
--	self.quan_Lieyanshenjian = transform:Find("LieyanshenjianQuan/Quan_Shenjianbaodao").gameObject
--	self.quan_Lieyanshenjian:SetActive(false)
--	self.HuoYanShenJian = transform:Find("LieyanshenjianQuan/Shenjianbaodao").gameObject
--	self.HuoYanShenJian:SetActive(false)
--	self.GunJianList = {}
--	for i = 1,5 do
--		local tempGo = transform:Find("Gun_Team/Lieyanshenjian/Animation/All/GunRose/Bullet0"..i).gameObject
--		table.insert(self.GunJianList,tempGo)
--	end
	
	-- self.LeiSheGunType = 	transform:Find("Gun_Team/LeiSheGunType")
	-- self.LeiSheGunType.gameObject:SetActive(false)

	-- self.drillGunFire = transform:Find("Fire/DrillGun_Fire")
	-- self.drill_Countdown_Label = self.drillGunFire:Find("Before/Time/Label"):GetComponent(typeof(UILabel))
	-- self.drillGunFire.gameObject:SetActive(false)

	-- self.leiSheGunFire = transform:Find("Fire/LeiShe_Fire")
	-- self.leiShe_Countdown_Label = self.leiSheGunFire:Find("Before/Time/Label"):GetComponent(typeof(UILabel))
	-- self.leiSheGunFire.gameObject:SetActive(false)

	--self.fmPSs=self.transform:Find("PlayerMoneyGroup/Coin/explosive2_coin"):GetComponentsInChildren(typeof(ParticleSystem))
	local tranLockFishRootTrans=transform:Find("LockTeam")
	self.lockFishRootSprite = tranLockFishRootTrans:Find("ALL/LockFlag"):GetComponent(typeof(UISprite))
	self.tranLockFishRoot = tranLockFishRootTrans.gameObject
	self.tranLockFishRoot:SetActive(false)



	local myselfTranLockFishRootTrans=transform:Find("LockTeam_Myself")
	self.myselfLockFishRootSprite = myselfTranLockFishRootTrans:Find("ALL/LockFlag"):GetComponent(typeof(UISprite))
	self.myselfTranLockFishRoot = myselfTranLockFishRootTrans.gameObject
	self.myselfTranLockFishRoot:SetActive(false)

	-- self.ani_Bited = transform:Find("Ani_Bited").gameObject
	-- self.playerAnimator  = transform:GetComponent(typeof(Animator))
	-- self.playerAnimator.enabled = false
	-- self.playerCollider =self.transform:Find("Box_Bited"):GetComponent(typeof(LuaBehaviour))
	-- if not self.playerCollider then
	-- 		self.playerCollider=self.gameObject:AddComponent(typeof(LuaBehaviour))
	-- end
	-- self.playerCollider.onTriggerCallBack=function(other) self:OnTriggerEnterAnimation(other) end
	-- self.ani_Bited:SetActive(false)

	--self.CaiShen_zhuanpanGameObject = transform:Find("MiniGame_CaiShen/CaiShen_zhuanpan").gameObject
	--self.CaiShen_zhuanpanGameObject:SetActive(false)
	--self.MinNiGameCaiShenManager = MinNiGame_CaiShenManager.New(self.CaiShen_zhuanpanGameObject.transform)

	--[[local cb = function(obj)
		self.XingYunJinNiuGameObject = GameObject.Instantiate(obj[0])
		self.XingYunJinNiuGameObject.transform.parent =self.transform.parent.parent
		self.XingYunJinNiuGameObject.transform.localPosition = Vector3.one
		self.XingYunJinNiuGameObject.transform.localScale = Vector3.one
		self.XingYunJinNiuGameObject:SetActive(false)
		self.MinNiGameXingYunJinNiuManager = MinNiGame_XingYunJinNiu.New(self.XingYunJinNiuGameObject.transform)
	end
	resMgr:LoadAssetImmediate(GameController:GetInstance().gameID,"Phone/Prefab/Effect/XingYunJinNiu.unity3d","XingYunJinNiu",typeof(GameObject),cb,false,false)--]]
	
	
	self.ZhunPanObj=transform:Find("Win_ZhuanPan").gameObject

	self.ZhunPanItemList={}
	
	for i=1,8 do
		local ula=transform:Find("Win_ZhuanPan/root/ZhuanPan/Panel_JinBi/JinBiGroup/ItemGroup0"..i.."/Label"):GetComponent(typeof(UILabel))
		table.insert(self.ZhunPanItemList,ula)
	end
	
	
end

function UIPlayerGroup:InitPlayerGroup()
	self._bulletCount=0
	self.isMe=false
	self.isReady=true
	self.m_dicBullet={}
	self.m_listBulletRemove={}
	self.m_listNet={}
	self.m_listNetRemove={}
	self._isPress=false
	self:_ResetShootState()
	self.lockFishUID=0
end

local playerTickId = 0
-- local playerTickTicks={}
function UIPlayerGroup:OnTriggerEnterAnimation(other)

	if other.name == "EY_abc" and GameController:GetInstance().view.eYuflag == true then
		self.playerAnimator.enabled = true
		self.playerAnimator:Play("Ani_FortShock")
		self.ani_Bited:SetActive(true)
		playerTickId=playerTickId+1
		local tickName="palyerAnimator"..playerTickId
		RenderMgr.AddInterval(function()
			--self.playerAnimator.enabled = false
			self.ani_Bited:SetActive(false)
			end,tickName,2,2.1)
		-- table.insert(playerTickTicks,tickName)
	end
end

function UIPlayerGroup:Update( ... )
	-- for k,key in pairs(self.m_listGoldTeamAddRemove) do
	-- 	self:RemoveGoldTeamAdd(key)
	-- end
	-- self.m_listGoldTeamAddRemove={}
	
	for k,com in pairs(self.m_listGoldTeamAdd) do
		if com.isCanDestroy then
			--table.insert(self.m_listGoldTeamAddRemove,k)
			self:RemoveGoldTeamAdd(k)
		else
			com:Update()
		end
	end
	
	-- for i,v in pairs(self.m_listBulletRemove) do
	-- 	self:RemoveBullet(v)
	-- 	self._bulletCount=self._bulletCount-1
	-- end
	-- self.m_listBulletRemove={}
	
	for k,bullet in pairs(self.m_dicBullet) do
		if bullet.isCanDestroy then
			--table.insert(self.m_listBulletRemove,k)
			self:RemoveBullet(k)			
		-- else
		-- 	bullet:Update()
		end	
	end
	-- self.m_listNetRemove={}
	-- for i,v in pairs(self.m_listNetRemove) do
	-- 	self:RemoveNet(v)
	-- end
	for k,net in pairs(self.m_listNet) do
		if net.isCanDestroy then
			--table.insert(self.m_listNetRemove,k)
			self:RemoveNet(k)
		else
			net:Update()
		end	
	end
	if self.isMe then
		if GameModel:GetInstance().m_isLockShoot == true then
			if self.m_targetFish == nil then
				self:GetLockFish()
			end
		else
			self:SetTarget(nil)
		end

		self:Tick()
		
		self:RotationGun()

		if self._isPress or GameModel:GetInstance().m_isAutoShoot then
			self:ShootGunP0()
		end

		if self.m_targetFish then
			if not self.m_targetFish:CheckBoundValid() or self.m_targetFish:IsDie() or self.m_targetFish.isCanDestroy or not self.m_targetFish:IsCanBeHit() then
				self:SetTarget(nil)
			-- else
			-- 	if GameModel:GetInstance().m_isAutoShoot then 
			-- 		self:ShootGunP0()
			-- 	end
			end
		-- else
		-- 	if GameModel:GetInstance().m_isAutoShoot then
		-- 		self:ShootGunP0()
		-- 	end
		end
	else
		if self.m_targetFish and not self.m_targetFish:IsDie() and not self.m_targetFish.isCanDestroy and self.m_targetFish:CheckBoundValid() then
			local upVector = Vector3.up
			local gunTeamVerctor3Position = self.m_tranGunTeam.position
	
			local v1=Vector3.Normalize(self.m_targetFish:GetPosition()-gunTeamVerctor3Position)
			-- self.m_tranGunTeam.eulerAngles=Quaternion.FromToRotation(Vector3.up,v1).eulerAngles
			FishComManager.FromToRotation(self.m_tranGunTeam,upVector.x,upVector.y,upVector.z,v1.x,v1.y,0)
		end
	end

	self:SetLockFish()
	
	if self.comReward01 then
		self.comReward01:Update()
	end
	
	if self.comReward02 then
		self.comReward02:Update()
	end

	-- if self.isSpecialCountDown then
	-- 	self:ShootSpecialCountdown()
	-- end

	if self.FengBao then
		self.FengBao:Update()
	end

	if self.MinNiGameCaiShenManager then
		self.MinNiGameCaiShenManager:Update()
	end

	if self.MinNiGameXingYunJinNiuManager then
		self.MinNiGameXingYunJinNiuManager:Update()
	end

	self:PoChanTips()

	self:HeiDongMove()

	self:LeiyanShenJianQuanMove()
	self:HuoYanShenJianMove()

	if self.isShowTips then 
		self.ShowTipsTime = self.ShowTipsTime + Time.deltaTime
		local bone =  self.fishTips.transform:Find("Bone")
		local tipPos = self.TipsGameObject.localPosition
		if math.abs((bone.localEulerAngles.y - 180))<=1 then
			self.TipsGameObject.localPosition = Vector3(tipPos.x,-math.abs(tipPos.y),tipPos.z)
		else
			self.TipsGameObject.localPosition = Vector3(tipPos.x,math.abs(tipPos.y),tipPos.z)
		end
		self.TipsGameObject.localEulerAngles =Vector3(0,-self.fishTips.transform.localEulerAngles.y,-self.fishTips.transform.localEulerAngles.z)
		if self.ShowTipsTime>= 6 then
			self.ShowTipsTime = 0
			self.isShowTips = false
			self.TipsGameObject = nil 
			self.fishTips  = nil
		end
	end
end


function UIPlayerGroup:PoChanTips()
	if self.isPoChanShow == false then
		if GameModel:GetInstance().UserInfos ~= nil and	GameModel:GetInstance().UserInfos[self.direction] ~= nil and  GameModel:GetInstance().m_gunLevelList ~= nil and  GameModel:GetInstance().UserInfos[self.direction].iMoney < GameModel:GetInstance().m_gunLevelList[1] then
			self.poChanTips.gameObject:SetActive(true)
			self.isPoChanShow = true
		end
	end

end

function UIPlayerGroup:ShowTimerDown(timer)

	if self.isMe then
		if timer > 0 then
			self.aniMarkGo:SetActive(true)
			self.aniTimerDownLabel.text = tostring(timer)
		else
			self.aniMarkGo:SetActive(false)
		end
	end

end


function UIPlayerGroup:HuoYanShenJianMove()
	if self.isMoveHuoYanShenJian == true then
		local v1 = (self.quan_Lieyanshenjian.transform.position - self.HuoYanShenJian.transform.position).normalized
		self.HuoYanShenJian.transform.rotation = Quaternion.FromToRotation(Vector3.up, v1)
			
		local m_direction = self.HuoYanShenJian.transform:TransformDirection(Vector3.up)
		m_direction = m_direction.normalized
		if (self.quan_Lieyanshenjian.transform.localPosition - self.HuoYanShenJian.transform.localPosition).magnitude <= (m_direction * Time.deltaTime * 1500).magnitude then 
			self.HuoYanShenJian:SetActive(false)
			self:SendHuoYanShenJianHitFish()
		else
			local pos = self.HuoYanShenJian.transform.localPosition + m_direction * Time.deltaTime * 1500
			self.HuoYanShenJian.transform.localPosition = pos
		end
	end
end


function UIPlayerGroup:SendHuoYanShenJianHitFish()

	local fishIDcankiil =FishConfig[37].dieFishkillFishId
	local radius = 200
	local dieFishs ={}
	local config = FishConfig[37]
	local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(self.quan_Lieyanshenjian.transform.position)
	local xScreenPoint = 0
	local yScreenPoint = 0

	xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);

	for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
		if fish1.vo.fishKind<=fishIDcankiil and fish1:CheckFishIsLive() and fish1.vo.uid ~= self.heiDongUID then
			print("4444444444444444444444444444444")
			local distance=Vector3.Distance(localPos,fish1.transform.localPosition)
			if distance<=radius then
				print("dddddddddddddddddddd :",fishIDcankiil)
				table.insert(dieFishs,fish1.vo.uid)
			end
		end
	end
	local send={}

	send.dwBombFishID=self.LieyanshenjianUID
	send.sCaptureNetX =math.floor(xScreenPoint)
	send.sCaptureNetY =math.floor(yScreenPoint)
	send.nListCount=#dieFishs
	send.dwKilledIDList=dieFishs
	pt(send)
	GameLuaDefine.CMD_C_PartBombKilledList_EX={
		{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
		{"sCaptureNetX","Int16",0},
		{"sCaptureNetY","Int16",0},
		{"nListCount","Int16",0},--列表大小
		{"dwKilledIDList","Int32[]",send.nListCount},--被炸死的鱼ID列表
	}
	local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
	local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_SEND_PARTBOMB_KILLED_LT_EX
	GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_PartBombKilledList_EX,send,mainId,msgID)

	self.isMoveHuoYanShenJian = false

end



function UIPlayerGroup:LeiyanShenJianQuanMove()
	if self.isMe then
		if self.isLieyanshenjianStatus == true then
			local cam=GameController:GetInstance().view.m_camUI
			local vecMouse=Input.mousePosition
			local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
			local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(vecMouseWorld)
			local xScreenPoint = 0
			local yScreenPoint = 0
			xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);
			self.quan_Lieyanshenjian.transform.position = vecMouseWorld
		end
	end
end


function UIPlayerGroup:ShotHuoYanShenJian()
	if self.isMe then
		self.HuoYanShenJian:SetActive(true)
		self.GunJianList[self.LieYanShenJianNumber]:SetActive(false)
		self.HuoYanShenJian.transform.localScale=Vector3.one
		local bulletVecPos = self.m_tranBulletPosition.position
		self.HuoYanShenJian.transform.position = Vector3(bulletVecPos.x,bulletVecPos.y,0)
		self.HuoYanShenJian.transform.eulerAngles = Vector3(self.m_tranBulletPosition.eulerAngles.x,self.m_tranBulletPosition.eulerAngles.y,self.m_tranBulletPosition.eulerAngles.z)
		self.isMoveHuoYanShenJian = true
		self.isLieyanshenjianStatus = false 
		self.LieyanshenjianClick = false
		self.quan_Lieyanshenjian:SetActive(false)
		GameController:GetInstance():PlayConinAudio(32)
	end
end

function UIPlayerGroup:BeginLieyanshenjian(UID)
	if self.isMe then
		self.LieyanshenjianUID =UID
		self.HuoYanShenJian:SetActive(false)
		self.Lieyanshenjian:SetActive(true)
		if self.isMe then
			self.quan_Lieyanshenjian:SetActive(true)
		end
		self.isLieyanshenjianStatus = true
		self.LieyanshenjianClick = false
		self.isShootBullet = false
		self.isMoveHuoYanShenJian = false
		for i= 1,#self.GunJianList do
			self.GunJianList[self.LieYanShenJianNumber]:SetActive(true)
		end

		for i,tGun in ipairs(self.gunTypeList) do
			tGun.gameObject:SetActive(false)
		end 

		--[[for i,tPaoZip in ipairs(self.paoZuoList) do
			tPaoZip.gameObject:SetActive(false)
		end
		local tempPaoZuo = self.paoZuoList[7]--]]
		--tempPaoZuo.gameObject:SetActive(true)
		self:SetGunLevelBtn(false)
		GameController:GetInstance():PlayConinAudio(31)
	end
end

function UIPlayerGroup:ResetLieyanshenjian()
	self.LieyanshenjianUID =0
	self.Lieyanshenjian:SetActive(false)
	self.quan_Lieyanshenjian:SetActive(false)
	self.HuoYanShenJian:SetActive(false)
	self.isLieyanshenjianStatus = false
	self.LieyanshenjianClick = false
	self.isShootBullet = true
	self.isMoveHuoYanShenJian = false
	self:SetGunTeamSp()
	self:SetGunLevelBtn(true)
end


function UIPlayerGroup:BeginHeiDong(UID)
	--[[self.heiDongUID = UID
	self.heiDong:SetActive(true)
	if self.isMe then
		self.quan_heiDong:SetActive(true)
	end
	self.isHeiDongStatus = true
	self.isShootBullet = false
	self.heidongClick = false

  for i,tGun in ipairs(self.gunTypeList) do
		tGun.gameObject:SetActive(false)
   end 

 --[[  for i,tPaoZip in ipairs(self.paoZuoList) do
	   tPaoZip.gameObject:SetActive(false)
   end
   local tempPaoZuo = self.paoZuoList[5]
   tempPaoZuo.gameObject:SetActive(true)--]]

	 self:SetGunLevelBtn(false)
	 GameController:GetInstance():PlayConinAudio(45)--]]
end

function UIPlayerGroup:ShowFishTips(fish)
	if self.isShowTips == true then
		return
	end
	self.ShowTipsTime = 0

	self.fishTips = fish
	self.Dialogue01 = fish.gameObject.transform:Find("Dialogue01")
	self.Dialogue02 = fish.gameObject.transform:Find("Dialogue02")
	if self.Dialogue01 or self.Dialogue02 then
		self.isShowTips = true
	else
		return
	end

	if self.Dialogue02 ~= nil then
		local rand = math.random(1,2)
		if rand == 1 then
			self.Dialogue01.gameObject:SetActive(true)
			self.Dialogue02.gameObject:SetActive(false)
			self.TipsGameObject = self.Dialogue01
		else
			self.Dialogue01.gameObject:SetActive(false)
			self.Dialogue02.gameObject:SetActive(true)
			self.TipsGameObject = self.Dialogue02
		end
	else
		self.Dialogue01.gameObject:SetActive(true)
		self.TipsGameObject = self.Dialogue01
	end
end

function UIPlayerGroup:ResetHeiDong()
	
	--self.heiDong:SetActive(false)
	--self.quan_heiDong:SetActive(false)
	self.isHeiDongStatus = false
	self.isShootBullet = true
	self.heidongClick = false
	self:SetGunTeamSp()
	self:SetGunLevelBtn(true)
end

function UIPlayerGroup : ResetNotZuanTouView()
	self.isShootBullet = true	
--	self.DrillGunType.gameObject:SetActive(false)
	self:SetGunTeamSp()
	if self.isMe then
		self:SetGunLevelBtn(true)
	end
	--self.drillGunFire.gameObject:SetActive(false)
end

function UIPlayerGroup : ResetLeiSheView()
	self.isShootBullet = true	
	self.LeiSheGunType.gameObject:SetActive(false)
	--self.leiSheGunFire.gameObject:SetActive(false)
end

function UIPlayerGroup:CreateDropObj(msg)
	self.dropDatas[1] = msg.uBombId
	self.dropType[1] = msg.byBombType

	if msg.byBombType == 1 then
		
	elseif msg.byBombType == 2 then
		
	elseif msg.byBombType == 3 then
		self.isShootBullet = false	
		self.LeiSheGunType.gameObject:SetActive(true)
		self.leiSheGunFire.gameObject:SetActive(true)
		self.isSpecialCountDown = true
		self.specialTime = 10
	elseif msg.byBombType == 7 then
		self.isShootBullet = false
--		self.DrillGunType.gameObject:SetActive(true)
		--self.drillGunFire.gameObject:SetActive(true)
		self.isSpecialCountDown = true
		self.specialTime = 10 
		for i,tGun in ipairs(self.gunTypeList) do
			tGun.gameObject:SetActive(false)
	   end 
	
	  --[[ for i,tPaoZip in ipairs(self.paoZuoList) do
		   tPaoZip.gameObject:SetActive(false)
	   end
	   local tempPaoZuo = self.paoZuoList[6]
	   tempPaoZuo.gameObject:SetActive(true)--]]
	   self:SetGunLevelBtn(false)
		GameController:GetInstance():PlayConinAudio(65)
	end
end

function UIPlayerGroup:RemoveDropObj(msg)

	if msg.uBombId ~= self.dropDatas[1] then
		print("data is error")
	end
 
	self.zuanTou = nil

	if self.dropType[1] == 1 then
		
	elseif self.dropType[1] == 2 then
		
	elseif self.dropType[1] == 3 then
	--	self.isShootBullet = true	
		local leiShe = GameController:GetInstance().entityModel:CreateLeiShe(1)
		leiShe.uBombId =  self.dropDatas[1]
		leiShe.gameObject:SetActive(true)
		local zRotation = msg.sAngle/10
		FishComManager.SetLocalEulerAngles(self.m_tranGunTeam,0,0,zRotation)
		
		local pos = self.m_tranBulletPosition.position
		FishComManager.SetPosition(leiShe.transform,pos.x,pos.y,pos.z)
		
		local euler = self.m_tranBulletPosition.eulerAngles
		FishComManager.SetEulerAngles(leiShe.transform,euler.x,euler.y,euler.z)
		
		FishComManager.SetLocalScale(leiShe.transform,1,1,1)
		local chairId = GameController:GetInstance():GetFishPlayerDirection(msg.byChairId)
		leiShe.byCharid =chairId
		leiShe.player = self
		-- self.LeiSheGunType.gameObject:SetActive(false)
		self.leiSheGunFire.gameObject:SetActive(false)
		self.isSpecialCountDown = false
		GameController.GetInstance():PlayConinAudio(81)
	elseif self.dropType[1] == 7 then
	--	self.isShootBullet = true	
		self.zuanTou = GameController:GetInstance().entityModel:CreateZuanTou(1)
		self.zuanTou.uBombId = self.dropDatas[1]
		local chairId = GameController:GetInstance():GetFishPlayerDirection(msg.byChairId)
		self.zuanTou.byCharid = chairId
		self.zuanTou.gameObject:SetActive(true)
		self.zuanTou.transform.localScale=Vector3.one
		local bulletVecPos = self.m_tranBulletPosition.position
		self.zuanTou.transform.position = Vector3(bulletVecPos.x,bulletVecPos.y,0)
		self.zuanTou.transform.eulerAngles = Vector3(self.m_tranBulletPosition.eulerAngles.x,self.m_tranBulletPosition.eulerAngles.y,self.m_tranBulletPosition.eulerAngles.z)
		self.zuanTou:BeginMoving(self)
		-- self.DrillGunType.gameObject:SetActive(false)
	--	self.drillGunFire.gameObject:SetActive(false)
		self.isSpecialCountDown = false
		self:ResetNotZuanTouView()
	end
	self.dropDatas[1] = nil
	self.dropType[1] = nil
end

function UIPlayerGroup:SetLockFish()
	if self.m_targetFish and not self.m_targetFish:IsDie() and not self.m_targetFish.isCanDestroy and self.m_targetFish:CheckBoundValid() then
		
		local targetFishPostion = nil
		-- self.m_lockTeamRoot.gameObject:SetActive(true)
		-- if self.m_targetFish.vo.fishKind == 37 then
		-- 	targetFishPostion = self.m_targetFish.transform:Find("Bone/FixedPoint").position
		-- else
			targetFishPostion = self.m_targetFish.transform.position
		-- end
	
		if self.isMe then
			--local tranBulletPosition = self.m_tranBulletPosition.position
			-- FishComManager.SetPosition(self.m_lockHead,targetFishPostion.x,targetFishPostion.y,targetFishPostion.z)

			-- local l=Vector3.Distance(self.m_tranBulletPosition.parent:InverseTransformPoint(targetFishPostion),self.m_tranBulletPosition.localPosition)
			-- local vFish = self.m_myselfLockPointTeam.transform:InverseTransformPoint(targetFishPostion);
			-- local vBullet = self.m_myselfLockPointTeam.transform:InverseTransformPoint(tranBulletPosition);
			-- local direction = (vFish - vBullet).normalized;

			-- local interval=50
			-- local pointCount=math.floor(l/interval) + 1

			-- local beginPos=self.m_myselfLockPointTeam.transform:InverseTransformPoint(tranBulletPosition)
			-- local euler = self.m_tranBulletPosition.eulerAngles
			--  FishComManager.SetLocalPosition(self.m_myselfLockPointPrefab.gameObject,vFish.x,vFish.y,vFish.z)

			-- FishComManager.SetEulerAngles(self.m_myselfLockPointPrefab.gameObject,euler.x,euler.y,euler.z)
			--self.m_myselfLockPointPrefab.gameObject.transform.position=self.m_targetFish.transform.position
			--self.m_myselfLockPointPrefab.gameObject.transform.position.z=0
			
			
			--local fishPos=self.m_targetFish.transform.parent:TransformPoint(self.m_targetFish.transform.localPosition)

			local fishPos=GameController:GetInstance().view.m_camFish:WorldToScreenPoint(self.m_targetFish.transform.position)

			local tttt = GameController:GetInstance().view.m_camUI:ScreenToWorldPoint(fishPos)

			self.m_myselfLockPointPrefab.transform.position =Vector3(tttt.x,tttt.y,0)
			
			if(not self.m_myselfLockPointPrefab.activeInHierarchy) then
				self.m_myselfLockPointPrefab:SetActive(true)
			end
		else
		-- 	local tranBulletPosition = self.m_tranBulletPosition.position
		-- 	-- FishComManager.SetPosition(self.m_lockHead,targetFishPostion.x,targetFishPostion.y,targetFishPostion.z)
		-- 	local l=Vector3.Distance(self.m_tranBulletPosition.parent:InverseTransformPoint(targetFishPostion),self.m_tranBulletPosition.localPosition)
		-- 	local vFish = self.m_lockPointTeam.transform:InverseTransformPoint(targetFishPostion);
		-- 	local vBullet = self.m_lockPointTeam.transform:InverseTransformPoint(tranBulletPosition);
		-- 	local direction = (vFish - vBullet).normalized;
		-- 	local interval=50
		-- 	local pointCount=math.floor(l/interval) + 1

		-- 	local beginPos=self.m_lockPointTeam.transform:InverseTransformPoint(tranBulletPosition)
		-- 	local euler = self.m_tranBulletPosition.eulerAngles
		-- 	FishComManager.SetLocalPosition(self.m_lockPointPrefab.gameObject,vFish.x,vFish.y,vFish.z)
		-- --	FishComManager.SetEulerAngles(self.m_lockPointPrefab.gameObject,euler.x,euler.y,euler.z)
		--     local fishPos=self.m_targetFish.transform.parent:TransformPoint(self.m_targetFish.transform.localPosition)

			local fishPos=GameController:GetInstance().view.m_camFish:WorldToScreenPoint(self.m_targetFish.transform.position)
			local tttt = GameController:GetInstance().view.m_camUI:ScreenToWorldPoint(fishPos)
			self.m_lockPointPrefab.transform.position =Vector3(tttt.x,tttt.y,0)

			if(not self.m_lockPointPrefab.activeInHierarchy) then
				self.m_lockPointPrefab:SetActive(true)
			end
		end

		if self.isMe then
			if self.lockFishUID~=self.m_targetFish.vo.uid then
				GameController:GetInstance():SendLockFishMsg(true,self.m_targetFish.vo.uid)
				self.lockFishUID=self.m_targetFish.vo.uid
			end
			-- self.myselfLockFishRootSprite.spriteName = self.m_targetFish.vo.fishConfig.lockIcon
			-- self.myselfTranLockFishRoot:SetActive(true)
			
		else
			-- self.lockFishRootSprite.spriteName = self.m_targetFish.vo.fishConfig.lockIcon
			-- self.tranLockFishRoot:SetActive(true)
		end
	
	else
    	if self.isMe then
    		if self.lockFishUID~=0 then
    			GameController:GetInstance():SendLockFishMsg(false,0)
    			self.lockFishUID=0
    		end
    	end

		if(self.m_lockPointPrefab.activeInHierarchy) then
			self.m_lockPointPrefab:SetActive(false)
		end

		if(self.m_myselfLockPointPrefab.activeInHierarchy) then
			self.m_myselfLockPointPrefab:SetActive(false)
		end
    	-- self.tranLockFishRoot:SetActive(false)
		-- 	self.m_lockTeamRoot:SetActive(false)
			
		-- 	self.myselfTranLockFishRoot:SetActive(false)
    	-- self.m_myselfLockTeamRoot:SetActive(false)
	end
end
function UIPlayerGroup:Tick( ... )
	if self.fShootIntervalTmp<0 then
		self.isReady=true
	else
		self.isReady=false
		self.fShootIntervalTmp=self.fShootIntervalTmp-Time.deltaTime
	end
end
function UIPlayerGroup:_ResetShootState()
	self.fShootIntervalTmp = GameModel:GetInstance().fShootInterval;
    self.isReady = false;
end
function UIPlayerGroup:ShootGunP0()

	--[[if self.isMe then
		if(GameController:GetInstance().view.IsStopMark) then return  end
	end--]]
	
	if self.isShootBullet == false then
		return
	end
	

	self._bulletId = GameModel:GetInstance():GetBulletID();
	-- print("@@@@@@@@   _bulletId:",self._bulletId)
	if self.isMe then
		local ret=self:_IsCanShoot()
		if ret~=0 then
			if ret==3 then --金币不够
				--取消自动
				--取消锁定
				GameModel:GetInstance().m_isAutoShoot=false
				GameModel:GetInstance().m_isLockShoot=false
				GameController:GetInstance().view:SetAutoShootState(GameModel:GetInstance().m_isAutoShoot)
				GameController:GetInstance().view:SetLockBtnState(GameModel:GetInstance().m_isLockShoot)
			end
			
			if ret==2 then
				local tips={"你发射的炮弹够多了,歇歇吧","You sent too many Bullets , please rest "}
				local language=""
				if GameModel:GetInstance().LanguageType==1 then
					language=tips[1]
				else
					language=tips[2]
				end
				GameController:GetInstance().view:SetObjTideTipsStatus(true,language)--"你发射的炮弹够多了,歇歇吧")
			end
			return 
		end
		GameController:GetInstance():SendUserShoot(self._bulletId,math.floor(self.m_tranGunTeam.localEulerAngles.z*10),self._curLevelIndex-1)
		self:_ResetShootState()
		GameController:GetInstance().view:SetObjTideTipsStatus(false,"")
	end
	if self.nengLiangPao == false then
		self:ChangeMoney(-GameModel:GetInstance().m_gunLevelList[self._curLevelIndex])
	else
		self.leiYanBullet = self.leiYanBullet - 1
		self.fireLeiBulletLabel.text = self.leiYanBullet 
	end
	LuaEvent:DispatchEvent("Game_Came",GameModel:GetInstance().m_gunLevelList[self._curLevelIndex])
	self._bulletCount=self._bulletCount+1
	self:PlaySpAnimation()
	self:PlayGunAnimation()
	local bullet=self:CreateBullet()
	local bulletVecPos = self.m_tranBulletPosition.position
	bullet._lb:SetPosition(bulletVecPos.x,bulletVecPos.y,0)
	-- bullet.transform.eulerAngles=self.m_tranBulletPosition.eulerAngles;
	bullet._lb:SetLocalScale(1,1,1)
	bullet:SetEulerAngles(self.m_tranBulletPosition.eulerAngles)
	bullet:SetBulletID(self._bulletId);
	bullet:SetSpawnPlayer(self);
	bullet:SetRobot(false)
	bullet:SetTarget(self.m_targetFish)

	local gunConfig = nil
	if self.nengLiangPao == true then
		gunConfig=GameLuaDefine.LieYanFengbaoLevelConfig[self._curLevelIndex]
	else 
		gunConfig=GameLuaDefine.GunLevelConfig[self._curLevelIndex]
	end

	bullet:SetSpAndSnap(gunConfig.bulletSpName)
	self.m_dicBullet[self._bulletId]=bullet;
	self:PlayShootSound()
	bullet._lb:Bullet3DBeginMove(bullet.m_bulletSpeed,GameController:GetInstance().view.m_camUI, GameController:GetInstance().view.m_camFish)
	--bullet:BeginMove()
end
function UIPlayerGroup:ShootGun( bulletID,zRotation,JiQiRen,ChairID )

	--[[if self.isMe then
		if(GameController:GetInstance().view.IsStopMark) then return  end
	end--]]
	
	
	if self._bulletCount>=GameModel:GetInstance().m_maxBulletCount then return end
	--本地没有这个子弹才创建，要不然会泄露
	if not self.m_dicBullet[bulletID] then
		if self.m_targetFish and not self.m_targetFish:IsDie() and not self.m_targetFish.isCanDestroy then
	    	local v1=Vector3.Normalize(self.m_targetFish:GetPosition()-self.m_tranGunTeam.position)
			-- self.m_tranGunTeam.eulerAngles=Quaternion.FromToRotation(Vector3.up,v1).eulerAngles
			local upVector = Vector3.up
			FishComManager.FromToRotation(self.m_tranGunTeam,upVector.x,upVector.y,upVector.z,v1.x,v1.y,v1.z)
	    else
			--self.m_tranGunTeam.localEulerAngles=Vector3(0,0,zRotation)
			FishComManager.SetLocalEulerAngles(self.m_tranGunTeam,0,0,zRotation)
	    end
	    self._bulletCount=self._bulletCount+1
		bullet=self:CreateBullet()
		local bulletVecPos = self.m_tranBulletPosition.position
		bullet._lb:SetPosition(bulletVecPos.x,bulletVecPos.y,0)
		-- bullet.transform.eulerAngles=self.m_tranBulletPosition.eulerAngles;
		bullet._lb:SetLocalScale(1,1,1)
		bullet:SetEulerAngles(self.m_tranBulletPosition.eulerAngles)
		bullet:SetBulletID(bulletID);
		bullet:SetSpawnPlayer(self);
		bullet:SetRobot(JiQiRen);
		bullet:SetTarget(self.m_targetFish)

		bullet:SetRobotChairID(ChairID)
		local gunConfig=GameLuaDefine.GunLevelConfig[self._curLevelIndex]
		bullet:SetSpAndSnap(gunConfig.bulletSpName)
		self:ChangeMoney(-GameModel:GetInstance().m_gunLevelList[self._curLevelIndex])
		self.m_dicBullet[bulletID]=bullet;
		
		self:PlaySpAnimation()
	--	self:PlayGunSubAni()
		self:PlayGunAnimation()
		--self:PlayShootSound()
		bullet._lb:Bullet3DBeginMove(bullet.m_bulletSpeed,GameController:GetInstance().view.m_camUI, GameController:GetInstance().view.m_camFish)
		--bullet:BeginMove()
	end
    --子弹超过最大值，删除最后一个子弹
end
function UIPlayerGroup:PlayShootSound( ... )
	if self.isMe then
		self._asShoot.volume= GameModel:GetInstance().soundVolume
		
		local config = nil
	
		config=SoundConfig[111]
		

		if config then
		  local soundName=config.sound
			if soundName then
				local soundRes=GameLuaDefine.listAudioRes[soundName]
				if soundRes then
					self._asShoot:PlayOneShot(soundRes)
				else
					local cb=function(obj,audioName)
					if obj~=nil and obj[0]~=nil then
						local audioClip=obj[0]
						GameLuaDefine.listAudioRes[audioName] = audioClip
						self._asShoot:PlayOneShot(audioClip)
					else
						print("游戏资源加载有问题: ",config.soundPath)
					end
				end
					resMgr:LoadAssetImmediate( GameController:GetInstance().gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
				end
			end
		end
		-- self._asShoot.volume= GameModel:GetInstance().soundVolume
	    -- self._asShoot:PlayOneShot(GameLuaDefine.listAudioRes["SND_11_NORMFIRE"])
	end
	-- 	self._asShoot.clip=(GameLuaDefine.listAudioRes["fish-fire"])
	-- 	if self._asShoot.isPlaying == false then
	-- 	self._asShoot:Play()
	-- 	end
end
function UIPlayerGroup:CreateBullet()
	local bullet=nil
	if self.m_dicDirtyBullet and next(self.m_dicDirtyBullet) then
		bullet=table.remove(self.m_dicDirtyBullet,1)
		bullet:ReBuild()
	else
		local bulletTrans=GameController:GetInstance().view.m_poolBullets:Spawn(GameController:GetInstance().view.m_bulletPrefabs[1]) 
		bullet=Bullet.New(bulletTrans)
	end
	return bullet
end
function UIPlayerGroup:RemoveBullet(bulletId)
	local bullet=self.m_dicBullet[bulletId]
	if bullet then
		self:CreateNet(0,bullet.transform.position)
		
		bullet:Destroy()
		table.insert(self.m_dicDirtyBullet,bullet)
		self.m_dicBullet[bulletId]=nil

		self._bulletCount=self._bulletCount-1
	end
end

function UIPlayerGroup:RemoveNet(id)
	local net=self.m_listNet[id]
	-- GameController:GetInstance().view.m_poolNets:Despawn(net.transform)
	net:Destroy()
	table.insert(self.m_listDirtyNet,net)
	self.m_listNet[id]=nil
end
function UIPlayerGroup:CreateGoldTeamAdd()
	local gold=nil
	--self.transPlayerGroupAnimator:Play("FishDie_Down_Animation",0,0)
	if self.m_listDirtyGoldTeamAdd and next(self.m_listDirtyGoldTeamAdd) then
		gold=table.remove(self.m_listDirtyGoldTeamAdd,1)
	else
		local prefabName=self.isUpPlayer and "GoldTeamAddUp" or "GoldTeamAddDown"
		local kind = self.isUpPlayer and 1 or 2 
		if GameController:GetInstance().view.m_goldTeamAddPrefabs[kind] == nil then
			local goldTeam = GameLuaDefine.GoldTeamAddRes[kind]
			local cb = function(obj)
				if obj~=nil and obj.Length>0 and obj[0] ~=nil then
					GameController:GetInstance().view.m_goldTeamAddPrefabs[kind]=obj[0].transform
				else
					print("游戏资源加载有问题: ",goldTeam.path)
				end
			end
			resMgr:LoadAssetImmediate(GameController:GetInstance().gameID,goldTeam.path,goldTeam.name,typeof(GameObject),cb,false,false)
		end

		local goldTrans=GameController:GetInstance().view.m_poolGoldTeamAdd:Spawn(GameController:GetInstance().view.m_goldTeamAddPrefabs[kind]) 
		goldTrans.localScale=Vector3.one
		gold=GoldTeamAdd.New(goldTrans)
	end
	gold:SetPos(self.isUpPlayer)
	table.insert(self.m_listGoldTeamAdd,gold)
	return gold,self.isMe
end
function UIPlayerGroup:RemoveGoldTeamAdd(k)
	local goldTeamAdd=self.m_listGoldTeamAdd[k]
	--goldTeamAdd:Destroy()
	goldTeamAdd.gameObject:SetActive(false)
	table.insert(self.m_listDirtyGoldTeamAdd,goldTeamAdd)
	self.m_listGoldTeamAdd[k]=nil
end
function UIPlayerGroup:ShowImHereTips()
	self.objImHere:SetActive(true)
	local Ani_ImHere=self.objImHere.transform:Find("Ani"):GetComponent(typeof(Animator))
	Ani_ImHere:Play("ImHere",0,0)
	RenderMgr.AddInterval(function()
		RenderMgr.Remove("UIPlayerGroup:ShowImHereTips")
		self.objImHere:SetActive(false)
		end,"UIPlayerGroup:ShowImHereTips",5,0)
end

function UIPlayerGroup:SetAutoObjStaus(status)
	self.m_objAuto:SetActive(status)
end


function UIPlayerGroup:SetGunLevel(levelIndex,odd)
	local level=GameModel:GetInstance().m_gunLevelList[levelIndex]
	if self._curLevelIndex ~= levelIndex then
		self._curLevelIndex = levelIndex;
		self.m_uilabelGunLevel.text = NumberThousandsFormat(HallGoldRateSToC(level))
		self:SetGunTeamSp()
	else
		local  flag = false
		--[[for i,tPaoZip in ipairs(self.paoZuoList) do
			if tPaoZip.gameObject.activeSelf == true then
				flag = true
			end
		end--]]
		if flag == false then
			self._curLevelIndex = levelIndex;
			self.m_uilabelGunLevel.text = NumberThousandsFormat(HallGoldRateSToC(level))
			self:SetGunTeamSp()
		end
	end
end


function UIPlayerGroup:SetMoneyUILabel(money)
	if self.nengLiangPao == true then
		-- self.LeiYanScore = self.LeiYanScore + money
		-- self.fireLeiMoneyLabel.text = NumberThousandsFormat(HallGoldRateSToC(self.LeiYanScore or 0))
	else
		self.m_uilabelPlayerMoney.text= NumberThousandsFormat(HallGoldRateSToC(money or 0))
	end
end

function UIPlayerGroup: LieYanFengBaoUIMoney(money)
	if self.nengLiangPao == true then
		self.LeiYanScore = self.LeiYanScore + money
		self.fireLeiMoneyLabel.text = NumberThousandsFormat(HallGoldRateSToC(self.LeiYanScore or 0))
	end
end

function UIPlayerGroup:SetPlayerName(name)
	self.m_uilabelPlayerName.text=name or ""
end

function UIPlayerGroup:ChangeMoney(money)
	GameModel:GetInstance().UserInfos[self.direction].iMoney=GameModel:GetInstance().UserInfos[self.direction].iMoney+money
	if GameModel:GetInstance().UserInfos[self.direction].iMoney<0 then
		GameModel:GetInstance().UserInfos[self.direction].iMoney=0
	end
	self:SetMoneyUILabel(GameModel:GetInstance().UserInfos[self.direction].iMoney)
end
function UIPlayerGroup:IsVisible(isVisible)
	self.gameObject:SetActive(isVisible)
end
function UIPlayerGroup:SetGunLevelBtn(isVisible)
	self.m_objAddBtn:SetActive(isVisible);
    self.m_objSubBtn:SetActive(isVisible);
end
function UIPlayerGroup:OnPressMouse(press)
	if press and not self.isShootBullet then
		if self.dropDatas[1] ~= nil  then
			self:SetTarget(nil)
			self:RotationGun()
			local angle = math.floor(self.m_tranGunTeam.localEulerAngles.z*10)

			local cam=GameController:GetInstance().view.m_camUI
			local vecMouse=Input.mousePosition
			local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
			local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(vecMouseWorld)
			local xScreenPoint = 0
			local yScreenPoint = 0
			xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);
			GameController:GetInstance():SendShootSuperBomb(self.dropDatas[1],xScreenPoint,yScreenPoint,angle)
		end

		if self.isHeiDongStatus == true then
			self.heidongClick = true
		end

		if self.isLieyanshenjianStatus == true then
			self.LieyanshenjianClick = true
		end
	else
		self._isPress=press
		--self:RotationGun()
		if self.isHeiDongStatus == true and self.heidongClick == true then
			self:SendHitFish()
		end

		if self.isLieyanshenjianStatus == true and self.LieyanshenjianClick == true then
			self:ShotHuoYanShenJian()
		end
	end
	
end

function UIPlayerGroup:HeiDongMove()
	if self.isHeiDongStatus == true then
		local cam=GameController:GetInstance().view.m_camUI
		local vecMouse=Input.mousePosition
		local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
		local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(vecMouseWorld)
		local xScreenPoint = 0
		local yScreenPoint = 0
		xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);
		self.quan_heiDong.transform.position = vecMouseWorld
	end
end

function UIPlayerGroup:SendHitFish()

	local fishIDcankiil =FishConfig[33].dieFishkillFishId
	local radius = 500
	local dieFishs ={}

	local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(self.quan_heiDong.transform.position)
	local tempPos = self.quan_heiDong.transform.position
	local xScreenPoint = 0
	local yScreenPoint = 0
--	print("oooooooooooooooooooooooooooo :",localPos.x,"  ",localPos.y)
	 xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);

	for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
		if fish1.vo.fishKind<=fishIDcankiil and fish1:CheckFishIsLive() and fish1.vo.uid ~= self.heiDongUID then
			local distance=Vector3.Distance(localPos,fish1.transform.localPosition)
			if distance<=radius then
				table.insert(dieFishs,fish1.vo.uid)
			end
		end
	end
	local send={}

	send.dwBombFishID=self.heiDongUID
	send.sCaptureNetX =math.floor(xScreenPoint)
	send.sCaptureNetY =math.floor(yScreenPoint)
--	print("UUUUUUUUUUUU :",send.sCaptureNetX,"  ",send.sCaptureNetY)
	send.nListCount=#dieFishs
	send.dwKilledIDList=dieFishs
	pt(send)
	GameLuaDefine.CMD_C_PartBombKilledList_EX={
		{"dwBombFishID","UInt32",0},--炸弹ID 鱼的id
		{"sCaptureNetX","Int16",0},
		{"sCaptureNetY","Int16",0},
		{"nListCount","Int16",0},--列表大小
		{"dwKilledIDList","Int32[]",send.nListCount},--被炸死的鱼ID列表
	}
	local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
	local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_SEND_PARTBOMB_KILLED_LT_EX
	GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_PartBombKilledList_EX,send,mainId,msgID)
	GameController:GetInstance():PlayConinAudio(46)
	self:ResetHeiDong()
end

function UIPlayerGroup:OnPressMouseFish( target,press )
	if press and not self.isShootBullet then
		if self.dropDatas[1] ~= nil  then
			self:SetTarget(nil)
			self:RotationGun()

			local angle = math.floor(self.m_tranGunTeam.localEulerAngles.z*10)

			local cam=GameController:GetInstance().view.m_camUI
			local vecMouse=Input.mousePosition
			local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
			local localPos = GameController:GetInstance().view.m_poolFish.transform:InverseTransformPoint(vecMouseWorld)
			local xScreenPoint = 0
			local yScreenPoint = 0
			xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(localPos.x, localPos.y);
			GameController:GetInstance():SendShootSuperBomb(self.dropDatas[1],xScreenPoint,yScreenPoint,angle)
		end

		if self.isHeiDongStatus == true then
			self.heidongClick = true
		end

		if self.isLieyanshenjianStatus == true then
			self.LieyanshenjianClick = true
		end
	else
		self._isPress=press
		-- and target._isBeHit == false 
		if GameModel:GetInstance().m_isLockShoot then
			self:SetTarget(target)
		-- else 
		-- 	self:RotationGun()
		end

		if self.isHeiDongStatus == true and self.heidongClick == true then
			self:SendHitFish()
		end

		if self.isLieyanshenjianStatus == true and self.LieyanshenjianClick == true then
			self:ShotHuoYanShenJian()
		end
	end
end
function UIPlayerGroup:RotationGun()
	local upVector = Vector3.up
	local gunTeamVerctor3Position = self.m_tranGunTeam.position

	if self.m_targetFish and not self.m_targetFish:IsDie() and not self.m_targetFish.isCanDestroy and self.m_targetFish:CheckBoundValid() then
		local v1=Vector3.Normalize(self.m_targetFish:GetPosition()-gunTeamVerctor3Position)
		--self.m_tranGunTeam.eulerAngles=Quaternion.FromToRotation(Vector3.up,v1).eulerAngles
		FishComManager.FromToRotation(self.m_tranGunTeam,upVector.x,upVector.y,upVector.z,v1.x,v1.y,0)
	else
		if(self._isPress) then
			local cam=GameController:GetInstance().view.m_camUI
			if FishComManager.ShootPhysicsRay("paozuo") == true then return end
			local vecMouse=Input.mousePosition
			local vecMouseWorld=cam:ScreenToWorldPoint(vecMouse)
			if vecMouse.x>=0 and vecMouse.x<=Screen.width and vecMouse.y>=0 and vecMouse.y<=Screen.height then
				local vec1=Vector3(vecMouseWorld.x,vecMouseWorld.y,0)
				local vec2=Vector3(self.m_tranGunTeam.position.x,self.m_tranGunTeam.position.y,0)
				local v1=Vector3.Normalize(vec1-vec2)
				FishComManager.FromToRotation(self.m_tranGunTeam,upVector.x,upVector.y,upVector.z,v1.x,v1.y,v1.z)
			end
		end
	end
end

function UIPlayerGroup:_IsCanShoot()
	if GameModel:GetInstance().gameState==GameLuaDefine.GameState.JieSuan then
		return 1
	end
	if not self.isReady then 
		return 1
	end
	if not (GameModel:GetInstance().m_maxBulletCount>self._bulletCount) then
		return 2
	end
	if not (GameModel:GetInstance().UserInfos[self.direction].iMoney>=GameModel:GetInstance().m_gunLevelList[self._curLevelIndex]) then
		-- UIManager:GetInstance():ShowNoteMessage("玩家金币不足")
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Player_no_money"))
		return 3
	end
	return 0
end
function UIPlayerGroup:CreateNet( id,pos )
	local net=nil
	local netTrans=nil
	if self.m_listDirtyNet and next(self.m_listDirtyNet) then
		net=table.remove(self.m_listDirtyNet,1)
		net:ReBuild()
		netTrans =net.transform
	else
		netTrans=GameController:GetInstance().view.m_poolNets:Spawn(GameController:GetInstance().view.m_netPrefabs[1].transform)
		netTrans.gameObject:SetActive(true)
		net=Net.New(netTrans)
	end
	local gunConfig = nil
	if self.nengLiangPao == true then
		gunConfig=GameLuaDefine.LieYanFengbaoLevelConfig[self._curLevelIndex]
	else
		gunConfig=GameLuaDefine.GunLevelConfig[self._curLevelIndex]
	end

	FishComManager.SetPosition(netTrans,pos.x,pos.y,pos.z)
	FishComManager.SetEulerAngles(netTrans,0,0,0)
	FishComManager.SetLocalScale(netTrans,1,1,1)
	net:SetSpAndSnap(gunConfig.netSpName)
	table.insert(self.m_listNet,net)
	-- if self.isMe then
	-- 	GameController:GetInstance():PlayConinAudio(37)
	-- end
end

function UIPlayerGroup:PlayGunAnimation()
	if self.nengLiangPao then	
		self._aniGun:Play("FireStrom_Shoot0"..self._curLevelIndex,0,0)
	else
		if self._curLevelIndex < 5 then
			self._aniGun:Play("PaoTai_Animation0"..self._curLevelIndex,0,0)
		else 
			self._aniGun:Play("PaoTai_Animation04",0,0)
		end
	end
end

function UIPlayerGroup:PlaySpAnimation()
	if self._taGunBoom ~= nil then
		RenderMgr.AddInterval(function()
			RenderMgr.Remove(self.gameObject.name)
			self._taGunBoom.gameObject:SetActive(false)
			end,self.gameObject.name,0.2,0)

		if not self._taGunBoom.gameObject.activeSelf then
			self._taGunBoom.gameObject:SetActive(true)
		end
		self._taGunBoom.enabled=true
		self._taGunBoom:ResetToBeginning()
	end
end

function UIPlayerGroup:SetRewardFishName( fishName )
	-- self.m_rewardFishName.spriteName=fishName
end

function UIPlayerGroup:ShowLieYanFengBao(beginTrans)
	self.FengBao:Set(beginTrans,self)
end

function UIPlayerGroup:ShowRewardByType( money,rType,name,sprite,mul)
	


	if rType==1 then --击杀
		if self.comReward01 then
			self.comReward01:Set(money,self.isMe,mul)
		end
		-- if self.isMe then
		-- 	self._asReward.volume=GameModel:GetInstance().soundVolume
		-- 	if self._asReward.isPlaying == false then
		-- 		local config=SoundConfig[67]
		-- 		if config then
		-- 			local soundName=config.sound
		-- 			if soundName then
		-- 			local soundRes=GameLuaDefine.listAudioRes[soundName]
		-- 			if soundRes then
		-- 				self._asReward:PlayOneShot(soundRes)
		-- 			else
		-- 				local cb=function(obj,audioName)
		-- 				if obj~=nil and obj[0]~=nil then
		-- 					local audioClip=obj[0]
		-- 					GameLuaDefine.listAudioRes[audioName] = audioClip
		-- 					self._asReward:PlayOneShot(audioClip)
		-- 				else
		-- 					print("游戏资源加载有问题: ",config.soundPath)
		-- 				end
		-- 				end
		-- 				resMgr:LoadAssetImmediate( GameController:GetInstance().gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
		-- 			end
		-- 			end
		-- 		end			
		-- 		--self._asReward:PlayOneShot(GameLuaDefine.listAudioRes["SND_22_SPECCNT"])
		-- 	end
		-- end
	end
	if rType==2 then --击杀
		if self.comReward02 then
			self.comReward02:Set(money,self.isMe,name,sprite,mul)
		end

		if self.isMe then
			self._asReward.volume=GameModel:GetInstance().soundVolume
			if self._asReward.isPlaying == false then
				local config=SoundConfig[59]
				if config then
					local soundName=config.sound
					if soundName then
					local soundRes=GameLuaDefine.listAudioRes[soundName]
					if soundRes then
						self._asReward:PlayOneShot(soundRes)
					else
						local cb=function(obj,audioName)
						if obj~=nil and obj[0]~=nil then
							local audioClip=obj[0]
							GameLuaDefine.listAudioRes[audioName] = audioClip
							self._asReward:PlayOneShot(audioClip)
						else
							print("游戏资源加载有问题: ",config.soundPath)
						end
						end
						resMgr:LoadAssetImmediate( GameController:GetInstance().gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
					end
					end
				end			
				--self._asReward:PlayOneShot(GameLuaDefine.listAudioRes["SND_22_SPECCNT"])
			end
		end

	end

	

end

function UIPlayerGroup:GetLockFish()
	local fish=nil
	local info={}
	info.uid=0
	for i,kind in ipairs(GameLuaDefine.CanLockFish) do
		info.kind=kind
		fish=GameController:GetInstance().entityModel:GetFishByFishInfo(info)
		if fish then break end
	end
	self:SetTarget(fish)
end

function UIPlayerGroup:OnClickAddBtn()
	GameController:GetInstance():PlayUIBottomAudio(108)
	local odd=self._curLevelIndex
	-- self._curLevelIndex=self._curLevelIndex+1
	-- if self._curLevelIndex>#GameModel:GetInstance().m_gunLevelList then
	-- 	self._curLevelIndex=1
	-- end
	-- self:SetGunLevel(self._curLevelIndex,odd)
	-- -- self:SetGunTeamSp()

	local levelIndex = self._curLevelIndex+1
	if levelIndex>#GameModel:GetInstance().m_gunLevelList then
		levelIndex=1
	end
	self:SetGunLevel(levelIndex,odd)

end
function UIPlayerGroup:OnClickSubBtn()
	local odd=self._curLevelIndex
	GameController:GetInstance():PlayUIBottomAudio(108)
	-- self._curLevelIndex=self._curLevelIndex-1
	local levelIndex = self._curLevelIndex-1
	if levelIndex<1 then
		levelIndex=#GameModel:GetInstance().m_gunLevelList
	end
	self:SetGunLevel(levelIndex,odd)
	-- self:SetGunTeamSp()
end

function UIPlayerGroup:EnterLieYanFengbao(kaiguan)
	if kaiguan == 1 then
		self.nengLiangPao = true
		--self:SetLieYanFengBaoGunTeamSp()
	else
		GameController:GetInstance():PlayPaoFenAudio(89) 
		self.nengLiangPao = false
		self:SetGunTeamSp()
		self.lieYanFengBao.gameObject:SetActive(false)
		self.FireStromPan:SetActive(false)
		self.FireStromBg:SetActive(false)
		local mul = math.random( 1,150 )
		self:ShowRewardByType(self.LeiYanScore,2,"Iconname_56","Icon_Fish_56",mul)
	end
end

function UIPlayerGroup:PlayFengBaoAnimator()
	self.FireStromPan:SetActive(true)
	self.FireStromBg:SetActive(true)
	self.LeiYanScore = 0
	self.fireLeiMoneyLabel.text = tostring(self.LeiYanScore)
	self.leiYanBullet = 150
	self.fireLeiBulletLabel.text = self.leiYanBullet

	GameController:GetInstance():PlayConinAudio(90)
	RenderMgr.Remove("LieYanFengBao-01")
	RenderMgr.AddInterval(function()
	 GameController:GetInstance():PlayPaoFenAudio(87) 
			end,"LieYanFengBao-01",2,2.2)

		RenderMgr.Remove("LieYanFengBao-02")
		RenderMgr.AddInterval(function()
			GameController:GetInstance():PlayPaoFenAudio(88) 
				end,"LieYanFengBao-02",3.6,3.7)

	self:SetLieYanFengBaoGunTeamSp()
end

function UIPlayerGroup:SetLieYanFengBaoGunTeamSp()
	local gunConfig=GameLuaDefine.LieYanFengbaoLevelConfig[self._curLevelIndex]
	if gunConfig then
		for i,tGun in ipairs(self.gunTypeList) do
		 	tGun.gameObject:SetActive(false)
		 end 
		 local tranGun=self.lieYanFengBao --self.LieYanFengbaoLevelConfig[gunConfig.gunPrefabID]
		 tranGun.gameObject:SetActive(true)
		 self.gunRoot=tranGun
		 self._aniGun=tranGun:Find("Animation"):GetComponent(typeof(Animator))
		 self._taGunBoom = nil
		-- self._tpGunSub=tranGun:Find("Animation/All/GunRose/Gun/01"):GetComponent(typeof(TweenPosition))
		--  self._taGunBoom=tranGun:Find("Animation/All/Boom"):GetComponent(typeof(TweenAlpha))
		--  self._taGunBoom.gameObject:SetActive(false)
	end
end



function UIPlayerGroup:SetGunTeamSp()
	local gunConfig=GameLuaDefine.GunLevelConfig[self._curLevelIndex]
	if gunConfig then
		for i,tGun in ipairs(self.gunTypeList) do
		 	tGun.gameObject:SetActive(false)
		end 

		--[[for i,tPaoZip in ipairs(self.paoZuoList) do
			tPaoZip.gameObject:SetActive(false)
		end

		local curPaoZuo =self.paoZuoList[gunConfig.gunPrefabID]
		curPaoZuo.gameObject:SetActive(true)--]]
		
		

		 local tranGun=self.gunTypeList[gunConfig.gunPrefabID]
		 tranGun.gameObject:SetActive(true)
		 self.gunRoot=tranGun
		 self._aniGun=tranGun:Find("Animation"):GetComponent(typeof(Animator))
		 self._taGunBoom = nil
		--  self._taGunBoom=tranGun:Find("Animation/All/Boom"):GetComponent(typeof(UISpriteAnimation))
		--  self._taGunBoom.gameObject:SetActive(false)
	end
end
function UIPlayerGroup:SetSpAndSnap(sp,spName)
	if sp then
		sp.spriteName=spName or ""
		sp:MakePixelPerfect()
	end
end
function UIPlayerGroup:SetTarget( fish )
	
	-- if fish then
	-- 	if self.m_targetFish~=fish then
	-- 		if self.isMe then
	-- 			self.m_myselfLockTeamRoot:SetActive(false)
	-- 			self.m_myselfLockTeamRoot:SetActive(true)
	-- 		else
	-- 			self.m_lockTeamRoot:SetActive(false)
	-- 			self.m_lockTeamRoot:SetActive(true)
	-- 		end

	-- 		-- local ani=self.m_lockHead:GetComponent(typeof(Animator))
	-- 		-- ani:Play("Lock_fish")
	-- 	else
	-- 		if self.isMe then
	-- 			self.m_myselfLockTeamRoot:SetActive(true)
	-- 		else
	-- 			self.m_lockTeamRoot:SetActive(true)
	-- 		end
	-- 	end
	-- 	local vector3Pos = fish.transform.position
	-- 	--FishComManager.SetPosition(self.m_lockHead,vector3Pos.x,vector3Pos.y,vector3Pos.z)
	-- else
	-- 	if self.isMe then
	-- 		self.m_myselfLockTeamRoot:SetActive(false)
	-- 	else
	-- 		self.m_lockTeamRoot:SetActive(false)
	-- 	end
	-- end
	if(self.m_targetFish~=fish) then

		if(fish==nil) then
			for k,bullet in pairs(self.m_dicBullet) do
				if(bullet._targetFish==self.m_targetFish) then
					bullet:SetTarget(nil)
				end				
			end
		end

		self.m_targetFish=fish

		-- for k,bullet in pairs(self.m_dicBullet) do
		-- 	bullet:SetTarget(fish)
		-- end
	end
	

	-- if self.m_targetFish then
	-- 	--显示锁定的鱼
	-- 	self.tranLockFishRoot.gameObject:SetActive(true)
	-- else
	-- 	self.tranLockFishRoot.gameObject:SetActive(false)
	-- end
	
end
--金币飞向玩家特效 粒子
function UIPlayerGroup:SetFishMoneyEffect( ... )
	-- self.fmPSs=self.transform:Find("PlayerMoneyGroup/Coin/explosive2_coin"):GetComponentsInChildren(typeof(ParticleSystem))
	-- if self.fmPSs then
	-- 	for i=0,self.fmPSs.Length-1 do
	-- 		self.fmPSs[i]:Play()
	-- 	end
	-- end
end

function UIPlayerGroup:RemoveAllBulletAndNet( ... )
	-- self.m_listBulletRemove={}
	for k,v in pairs(self.m_dicBullet) do
		-- v:Destroy()
		-- table.insert(self.m_dicDirtyBullet,v)
		self:RemoveBullet(k)
	end
	-- self.m_dicBullet={}
	-- self.m_listNetRemove={}
	for k,v in pairs(self.m_listNet) do
		-- v:Destroy()
		-- table.insert(self.m_listDirtyNet,v)
		self:RemoveNet(k)
	end
	-- self.m_listNet={}
	--self.m_targetFish=nil
	self:SetTarget(nil)
end

function UIPlayerGroup:BeginJinNiu(score,cb)
	if self.isMe then
		for i=1,8 do
			self.ZhunPanItemList[i].text=NumberThousandsFormat(HallGoldRateSToC(GameModel:GetInstance().m_gunLevelList[self._curLevelIndex]*50*i))
		end
		self.ZhunPanObj:SetActive(true)
		local ZhuanPanFunc=function ()
			yield_return(WaitForSeconds(4))
			self.ZhunPanItemList[1].text=NumberThousandsFormat(HallGoldRateSToC(score))
			yield_return(WaitForSeconds(2))
			
			cb()
			self.ZhunPanObj:SetActive(false)
		end
		
		StartCoroutine(ZhuanPanFunc)
	end
end


function UIPlayerGroup:BeginCaiShen(score)
	self.MinNiGameCaiShenManager:SetScoreItemProcess(score)
end

function UIPlayerGroup:DestroyPlayer( ... )

	self:RemoveAllBulletAndNet()
	RenderMgr.Remove(self.gameObject.name)
end
function UIPlayerGroup:LockEffectVisible(isVisible)
end
function UIPlayerGroup:__delete( ... )
	RenderMgr.Remove("UIPlayerGroup:ShowImHereTips")
	RenderMgr.Remove(self.gameObject.name)
	self:DestroyPlayer()
end