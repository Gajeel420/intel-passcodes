ZuanTouBullet=BaseClass()

ZuanTouBullet.State={
	None=0,
	Play_Animator01=1,
	Play_Animator02=2,
	Keep = 3,
	End=4,
}

function ZuanTouBullet:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	--self.zuan_tou_go = self.transform:Find("Ani")
	self.collider = self.transform:GetComponent(typeof(BoxCollider))
	self.behavior = self.transform:GetComponent(typeof(LuaBehaviour))
	--self.animator = self.zuan_tou_go:GetComponent(typeof(Animator))
	self.behavior.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end	

	self.isPlay = false

	self.timeLife = 30

	self.timeCancel = 0.5

	self.timeInterval = 0
	
	self.isCanDestroy = false
	
	self.ResolutionWidthHalf = 0

	self.ResolutionHeightHalf =0

	self.isMoving = false

	self.uBombId = 0

	self.byCharid = 0

	self.state=ZuanTouBullet.State.None
	self.palyer = nil
end

function ZuanTouBullet:OnTriggerEnter( other )
	local beHitFish=nil

	if other.gameObject:CompareTag("Fish") then
        local fish=other.gameObject:GetComponent(typeof(CS.TX_LuaBehaviour)).m_luaTable
        if  self._targetFish and self._targetFish:IsCanBeHit() and not self._targetFish:IsDie() and not self._targetFish.isCanDestroy and self._targetFish:CheckBoundValid() then
            if self._targetFish==fish then
                beHitFish=fish
            end
        else
            if  fish and fish:IsCanBeHit() and not fish:IsDie() and not fish.isCanDestroy and fish:CheckBoundValid() then
                beHitFish=fish
            end
        end
	
		if not beHitFish  then
            beHitFish = nil
            return;
        end
	
		local fishIDcankiil =FishConfig[34].dieFishkillFishId
		if beHitFish and beHitFish.vo.fishKind<=fishIDcankiil then
			beHitFish:BeHit(0.2)
			GameController:GetInstance():SendClickZhaDan(60011,beHitFish.vo.uid,self.uBombId,self.byCharid)
			GameController:GetInstance():PlayConinAudio(71)
		end
	end
end



function ZuanTouBullet:BeginMoving(uiPlayer)

	self.ResolutionWidthHalf = GameModel:GetInstance().ResolutionWidthHalf

	self.ResolutionHeightHalf = GameModel:GetInstance().ResolutionHeightHalf

	--self.animator:Play("Ani_DrillFly01")
	
	self.isPlay = true

	self.isMoving = true

	self.palyer = uiPlayer

	--GameController:GetInstance():PlayConinAudio(85)

	self.state=ZuanTouBullet.State.Play_Animator01
end

function ZuanTouBullet:Update( ... )

	if self.isPlay == false then return end

	if self.isMoving then
		self:ZuanTouMoving()
	end

	if self.state == ZuanTouBullet.State.Play_Animator01 then
		self.timeInterval = self.timeInterval + Time.deltaTime
		if 	self.timeInterval >= 8 then
			self.timeInterval = 0
			-- self.animator:Play("Ani_DrillFly02")
			self.state = ZuanTouBullet.State.End
		end
	end
	
	-- if self.state==ZuanTouBullet.State.Play_Animator02 then
	-- 	self.timeInterval = self.timeInterval + Time.deltaTime
	-- 	if 	self.timeInterval >= 2 then
	-- 		self.timeInterval = 0
	-- 		self.isMoving = false
	-- 		self.animator:Play("Ani_DrillBoom")
	-- 		self.state = ZuanTouBullet.State.Keep
	-- 		GameController:GetInstance():PlayConinAudio(82)
	-- 	end
	-- end

	-- if self.state==ZuanTouBullet.State.Keep then
	-- 	self.timeInterval = self.timeInterval + Time.deltaTime
	-- 	if 	self.timeInterval >= 1 then
	-- 		self.timeInterval = 0
	-- 		self.state = ZuanTouBullet.State.End
	-- 	end
	-- end

	if self.state==ZuanTouBullet.State.End then
		self.isPlay = false
		self.isCanDestroy = true

		-- local radius = 150
		-- for _,fish1 in pairs(GameController:GetInstance().entityModel.fishList) do
		-- 	if fish1.vo.fishKind<=14 and fish1:CheckFishIsLive() then
		-- 		local distance=Vector3.Distance(self.transform.localPosition,fish1.transform.localPosition)
		-- 		if distance<=radius then
		-- 			GameController:GetInstance():SendClickZhaDan(60011,fish1.vo.uid,self.uBombId,self.byCharid)
		-- 		end
		-- 	end
		-- end

		-- if self.palyer then
		-- 	self.palyer:ResetNotZuanTouView()
		-- end
	end
end


function ZuanTouBullet :AngleAroundAxis(dirA, dirB, axis)

	if Vector3.Dot(axis, Vector3.Cross(dirA, dirB)) < 0 then
		return Vector3.Angle(dirA, dirB) * -1
	else
		return Vector3.Angle(dirA, dirB) * 1
	end
end

function ZuanTouBullet:ZuanTouMoving()
		local m_direction = self.transform:TransformDirection(Vector3.up);
		m_direction = m_direction.normalized;

		local pos = self.transform.localPosition + m_direction * Time.deltaTime * 1500
		if pos.x>self.ResolutionWidthHalf then
			local re = Vector3.Reflect(m_direction, -Vector3.right);
			self.transform.localEulerAngles = Vector3(0, 0, self:AngleAroundAxis(Vector3.up, re, Vector3.forward));
			pos = Vector3(self.ResolutionWidthHalf,self.transform.localPosition.y,self.transform.localPosition.z);
			m_direction = self.transform:TransformDirection(Vector3.up)
			GameController:GetInstance():PlayConinAudio(29)
			GameController:GetInstance().view:ShakeAnimator(3)
		end

		if pos.x<-self.ResolutionWidthHalf then
			local re = Vector3.Reflect(m_direction, Vector3.right);
			self.transform.localEulerAngles = Vector3(0, 0, self:AngleAroundAxis(Vector3.up, re, Vector3.forward));
			pos = Vector3(-self.ResolutionWidthHalf,self.transform.localPosition.y,self.transform.localPosition.z);
			m_direction = self.transform:TransformDirection(Vector3.up);
			GameController:GetInstance():PlayConinAudio(29)
			GameController:GetInstance().view:ShakeAnimator(1)
		end

		if pos.y>self.ResolutionHeightHalf then
			local re = Vector3.Reflect(m_direction, -Vector3.up);
			self.transform.localEulerAngles = Vector3(0, 0, self:AngleAroundAxis(Vector3.up, re, Vector3.forward));
			pos = Vector3(self.transform.localPosition.x, self.ResolutionHeightHalf,self.transform.localPosition.z);
			m_direction = self.transform:TransformDirection(Vector3.up);
			GameController:GetInstance():PlayConinAudio(29)
			GameController:GetInstance().view:ShakeAnimator(2)
		end

		if pos.y<-self.ResolutionHeightHalf then
			local re = Vector3.Reflect(m_direction, Vector3.up);
			self.transform.localEulerAngles = Vector3(0, 0, self:AngleAroundAxis(Vector3.up, re, Vector3.forward));
			pos = Vector3(self.transform.localPosition.x, -self.ResolutionHeightHalf, self.transform.localPosition.z);
			m_direction = self.transform:TransformDirection(Vector3.up);
			GameController:GetInstance():PlayConinAudio(29)
			GameController:GetInstance().view:ShakeAnimator(4)
		end
		
		self.transform.localPosition = pos
end

function ZuanTouBullet:__delete( ... )
	GameController:GetInstance().view.m_poolZuanTou:Despawn(self.transform);
	self.transform=nil
	self.gameObject=nil
	self.timeInterval = 0
	self.isCanDestroy=false	-- body
	self.behavior = nil
	self.animator = nil
end