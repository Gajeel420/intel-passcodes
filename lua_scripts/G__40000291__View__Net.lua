Net=BaseClass()

function Net:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self._lifeTime=0.5
	self.isCanDestroy=false
	self.animtor = t:GetComponent(typeof(Animator))
	-- self.tweenScale = t:GetComponent(typeof(TweenScale))
	-- self.NetList = {}
	-- for i=1,4 do
	-- 	local go = self.gameObject.transform:Find("sty_01_net"..i).gameObject
	-- 	self.NetList["sty_01_net"..i] = go
	-- 	go:SetActive(false)
	-- end
	--self.sp0=t:Find("Net0"):GetComponent(typeof(UISprite))
	-- self.sp1=t:Find("Net1"):GetComponent(typeof(UISprite))
	self.gameObject:SetActive(true)
end
function Net:ReBuild()
	self.gameObject:SetActive(true)
	self.isCanDestroy=false
	self._lifeTime=0.5
	if self.tweenScale then
		self.tweenScale.enabled = true
	end
	-- for i,v in pairs (self.NetList) do
	-- 	v:SetActive(false)
	-- end
end
function Net:SetSpAndSnap(spName)
	--self.animtor:Play(spName,0,0)

	--self.NetList[spName]:SetActive(true) 
    -- self.sp1.spriteName=spName or ""
    -- self.sp1:MakePixelPerfect()
    -- self.sp0.spriteName=spName or ""
    -- self.sp0:MakePixelPerfect()
end
function Net:Update( ... )
	if not self.isCanDestroy then
		self._lifeTime=self._lifeTime-Time.deltaTime
		self.isCanDestroy=self._lifeTime<=0
	end
end

function Net:__delete( ... )
	-- GameController:GetInstance().view.m_poolNets:Despawn(self.transform);
	self.transform.localPosition=Vector3(50000,50000,0)

	if self.tweenScale then
		self.tweenScale.enabled = false
	end
	 self.gameObject:SetActive(false)
end