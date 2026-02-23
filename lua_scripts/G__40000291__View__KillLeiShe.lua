KillLeiShe=BaseClass()

function KillLeiShe:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	self.transform.localEulerAngles=Vector3.zero
	self.transform.localScale=Vector3.one
	self.lb = self.gameObject:GetComponent(typeof(LuaBehaviour))

	self.lb.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end	
	
	local ob = self.transform:Find("BG/Fish")
	self.spriteAnimation = ob:GetComponent((typeof(UISpriteAnimation)))

	self.timeLife = 2

	self.timeInterval = 0
	
	self.isCanDestroy = false

	self.spriteAnimation:ResetToBeginning()
	self.spriteAnimation:Play()
	self.uBombId = 0
	self.byCharid = 0
	self.player = nil
end

function KillLeiShe:OnTriggerEnter( other )
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
	
		if not beHitFish or beHitFish.vo.fishKind >= 23 then
            beHitFish = nil
            return;
        end

		if beHitFish then
			beHitFish:BeHit(0.2)
			--beHitFish._isCanBeHit = false
			GameController:GetInstance():SendClickZhaDan(60009,beHitFish.vo.uid,self.uBombId,self.byCharid)
		end
    end
end

function KillLeiShe:Update( ... )
	if not self.isCanDestroy then
		self.timeInterval = self.timeInterval + Time.deltaTime
		if self.timeInterval >= self.timeLife then
			self.isCanDestroy = true

			if self.player then
			   self.player:ResetLeiSheView()
			end
		end
	end
end

function KillLeiShe:__delete( ... )
	GameController:GetInstance().view.m_poolKillLeiShe:Despawn(self.transform);
	self.transform=nil
	self.gameObject=nil
	self.timeInterval = 0
	self.isCanDestroy=false	-- body
	self.lb.onTriggerCallBack = nil
	self.lb = nil
	self.player = nil
end