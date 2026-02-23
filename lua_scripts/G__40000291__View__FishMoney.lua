FishMoney=BaseClass()

function FishMoney:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	self.transform.localEulerAngles=Vector3.zero
	self.transform.localScale=Vector3.one
	self._aniGold = self.transform:Find("Coins_gold"):GetComponent(typeof(Animator));
	--self._aniSilver = self.transform:Find("Coins_silver"):GetComponent(typeof(Animator));
	self.tweenScale =  self.transform:GetComponent(typeof(TweenScale))
	--self._ani=nil
	
end

function FishMoney:Set(beginPos,endPos,player)
	self._endPos=endPos
	self._beginPos=beginPos
	self.transform.position=beginPos
	self.transform.localScale = Vector3.one
	self.transform.localEulerAngles = Vector3.zero
	self.tweenScale.from = Vector3.one
	self.tweenScale.to = Vector3(1.5,1.5,1.5)
	self.distanceToTarget = Vector3.Distance(beginPos,endPos)
	self.shotSpeed = 1.5
	self.dTime = 0
	self.g = -2	
	local time = self.distanceToTarget/self.shotSpeed
	self.totalTime = time
	self.tweenScale.duration = 0.5 * time
	self.speed = Vector3((self._endPos.x - self._beginPos.x) / time,(self._endPos.y - self._beginPos.y) / time - 0.5 * self.g * time, (self._endPos.z - self._beginPos.z) / time)
	self.Gravity = Vector3.zero
	
	self.tweenScale.enabled = false
	self._isMe=player.isMe
	--self.as=

	self.isCanMove=false
	self.isCanDestroy=false	-- body
	self.isPlaying=true
	self.isFisrtFrame=true
	self.player=player
end
function FishMoney:Update( ... )
	if self.isPlaying then
		if self.isFisrtFrame then
			self.isFisrtFrame=false
			self._aniGold:Play("Coin_Jump_Animation",0,0)
		else
			if self.isPlaying and not self.isCanMove and self._aniGold:GetCurrentAnimatorStateInfo(0).normalizedTime>=1 then
				self.isPlaying=false
				self.isCanMove=true
				self.tweenScale.enabled = true
				self.tweenScale:ResetToBeginning()
				self.tweenScale:PlayForward()
			end
		end
	end
	
	
	if self.isCanMove and not self.isCanDestroy then
		if self.dTime > self.totalTime then
			self.player:SetFishMoneyEffect()
			self.isCanMove=false
			self.isCanDestroy=true
			self.transform.localScale = Vector3.one
			self.tweenScale.enabled = false
			--GameController:GetInstance():PlayGameAudio(59)
			return
		end
		self.dTime = self.dTime + Time.deltaTime
		self.Gravity.y = self.g * self.dTime
		self.transform.position = self.transform.position + (self.speed + self.Gravity) * Time.deltaTime
	end
end
-- function FishMoney:__delete( ... )
-- 	-- GameController:GetInstance().view.m_poolFishMoney:Despawn(self.transform);
-- 	self.transform=nil
-- 	self.gameObject=nil
-- 	self._ani=nil
-- 	self.isCanDestroy=nil	-- body
-- 	self.isCanMove=nil
-- 	self.isPlaying=nil
-- end