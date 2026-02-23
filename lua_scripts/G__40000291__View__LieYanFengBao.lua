LieYanFengBao=BaseClass()

LieYanFengBao.State={
	Effect_Fish56=1,
	Effect02_Fish56=2,
	Effect03_Fish56 = 3,
}

function LieYanFengBao:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	self.transform.localEulerAngles=Vector3.zero
	self.transform.localScale=Vector3.one
	self.tweenPosition = self.transform:GetComponent(typeof(TweenPosition))
	self._ani = self.transform:Find("Ani"):GetComponent(typeof(Animator))
	self.tweenPosition.worldSpace = true
	self.isPlaying=false
	self.player=nil
	self.timeInterval = 0
	self.tweenPosition.enabled = false
end

function LieYanFengBao:Set(beginTrans,player)
	self.transform.position=beginTrans.position
	self.transform.localEulerAngles = Vector3.zero
	self.tweenPosition.from = beginTrans.position
	self.tweenPosition.to = player.lieYanFengBao.position
	self.gameObject:SetActive(true)
	self.isPlaying=true
	self.player=player
	self.timeInterval = 0
	self.state = LieYanFengBao.State.Effect_Fish56

	
end
function LieYanFengBao:Update( ... )

	if self.isPlaying == false then return end
	
	if self.state == LieYanFengBao.State.Effect_Fish56 then
		self.timeInterval = self.timeInterval + Time.deltaTime
		if 	self.timeInterval >= 3 then
			self.timeInterval = 0
			self._ani:Play("Effect02_Fish56",0,0)
			self.state = LieYanFengBao.State.Effect02_Fish56
			self.tweenPosition.enabled = true
			self.tweenPosition.duration = 1
			self.tweenPosition:ResetToBeginning()
			self.tweenPosition:PlayForward()
		
		end
	end
	
	if self.state==LieYanFengBao.State.Effect02_Fish56 then
		self.timeInterval = self.timeInterval + Time.deltaTime
		if 	self.timeInterval >= 1 then
			self.timeInterval = 0
			self._ani:Play("Effect03_Fish56",0,0)
			self.state = LieYanFengBao.State.Effect03_Fish56
		end
	end

	if self.state==LieYanFengBao.State.Effect03_Fish56 then
		self.timeInterval = self.timeInterval + Time.deltaTime
		if 	self.timeInterval >= 0.2 then
			self.timeInterval = 0
			self:AnimationOver()
		end
	end
end

function LieYanFengBao:AnimationOver()
	self.isPlaying = false
	self.player:PlayFengBaoAnimator()
	self.tweenPosition.enabled = false
	self.gameObject:SetActive(false)
end

function LieYanFengBao:__delete( ... )
	self.transform=nil
	self.gameObject=nil
	self._ani=nil
	self.isCanDestroy=nil	-- body
	self.isCanMove=nil
	self.isPlaying=nil
end