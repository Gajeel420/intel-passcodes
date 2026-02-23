EffectThunder=BaseClass()
EffectThunder.Status={
	None=0,
	Begin=1,
	Add=2,
	Keep=3,
	Sub=4,
	End=5,
}
function EffectThunder:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self.transform.localScale=Vector3.one
	self.thunderSp = self.transform:GetComponentInChildren (typeof(UISprite));
    self.iOldWidth = self.thunderSp.width
    self._status=EffectThunder.Status.None
    self.keepTime = 1.2
	self.countTime = 0
    self.isCanDestroy = false
end
function EffectThunder:Update( ... )

	if self._status==EffectThunder.Status.Begin then
		self.thunderSp.width=self.iOldWidth
		self._status=EffectThunder.Status.Add
	end
	if self._status==EffectThunder.Status.Add then
		self._status=EffectThunder.Status.Keep
	end
	if self._status==EffectThunder.Status.Keep then
		self.countTime=self.countTime+Time.deltaTime/self.keepTime
		if self.countTime>=1 then
			self._status=EffectThunder.Status.Sub
			self.countTime=1
		end
	end
	if self._status==EffectThunder.Status.Sub then
		self._status=EffectThunder.Status.End
	end
	if self._status==EffectThunder.Status.End then
		self.isCanDestroy=true
	end
end

function EffectThunder:StartEffect(beginPos,endPos,distance)
	self.thunderSp.width=self.iOldWidth
	self.isCanDestroy=false
	self.transform.localScale=Vector3.one
	self.transform.position=beginPos
	self.transform.rotation=Quaternion.FromToRotation(Vector3.up,endPos-beginPos)
	self.thunderSp.height=math.floor(distance)
	self._status=EffectThunder.Status.Begin
	self.countTime = 0
end

-- function EffectThunder:__delete( ... )
-- 	self.targeFish = nil
-- 	self.beginFish = nil
-- 	GameController:GetInstance().view.m_poolThunder:Despawn(self.transform);
-- end