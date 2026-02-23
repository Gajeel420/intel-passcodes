DropSpecial=BaseClass()

function DropSpecial:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	self.transform.localEulerAngles=Vector3.zero
	self.transform.localScale=Vector3.one
	self._ani = self.transform:GetComponent(typeof(Animator));
	self.isCanDestroy=false	-- body
	self.isCanMove=false
	self.isPlaying=false
	self.player=nil
	self.delayTime = 0
	self.cb = nil
end

function DropSpecial:Set(beginPos,endPos,player,cb)
	self._endPos=endPos
	self._beginPos=beginPos
	
	self.transform.position=beginPos
	self._isMe=player.isMe
	self.cb = cb
	
	-- if self._isMe then
	-- 	self._ani=self._aniGold
	-- else
	-- 	self._ani=self._aniGold
	-- end
	if self._ani.gameObject.activeSelf then
		self._ani:Play("Fish_Move")
	end
	self.isCanMove=false
	self.isCanDestroy=false	-- body
	self.isPlaying=false
	self.isFisrtFrame=true
	self.player=player
	self.delayTime  = 1.0
	self.gameObject:SetActive(false)
end
function DropSpecial:Update( ... )

	if self.delayTime >= 0 then
		self.delayTime = self.delayTime - Time.deltaTime
		if self.delayTime < 0 then
			self.gameObject:SetActive(true)
			if self._ani.gameObject.activeSelf then
				self._ani:Play("Fish_Move")
			end
			self.isPlaying= true
		end
		return
	end

	if self.isPlaying then
		if self.isFisrtFrame then
			self.isFisrtFrame=false
		else
			self.as=self._ani:GetCurrentAnimatorStateInfo(0)
			if self.isPlaying and not self.isCanMove and self.as.normalizedTime>=1 then
				self.isPlaying=false
				self.isCanMove=true
			end
		end
	end
	
	
	if self.isCanMove and not self.isCanDestroy then
	
		self.transform.position=Vector3.MoveTowards(self.transform.position,self._endPos,Time.deltaTime/0.15)
		if (Vector3.Magnitude(self.transform.position-self._endPos))<0.01 then
			--self.player:SetFishMoneyEffect()
			self.isCanMove=false
			self.isCanDestroy=true
			if self.cb then
				self.cb()
				self.cb = nil
			end
		end
	end
end
function DropSpecial:__delete( ... )
	GameController:GetInstance().view.m_poolDrop:Despawn(self.transform);
	self.transform=nil
	self.gameObject=nil
	self._ani=nil
	self.isCanDestroy=nil	-- body
	self.isCanMove=nil
	self.isPlaying=nil
end