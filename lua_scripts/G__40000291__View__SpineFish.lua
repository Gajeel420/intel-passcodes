SpineFish=BaseClass(FishBase)

function SpineFish:__init( ... )
	
end
function SpineFish:ReBuild(vo)
	FishBase.ReBuild(self,vo)
	self.skeletonAnimator =self.transform:Find("Bone/Fish"):GetComponent(typeof(SkeletonAnimation))
	self.skeletonAnimator.loop=true
	self.skeletonAnimator.skeleton.R= 1
	self.skeletonAnimator.skeleton.G= 1
	self.skeletonAnimator.skeleton.B= 1
	self.skeletonAnimator.skeleton.A= 1
	
	if self.vo.fishKind == 22 then
		self.skeletonAnimator.state:SetAnimation(0,"Swim",true)
	elseif self.vo.fishKind == 38 then
		self.skeletonAnimator.state:SetAnimation(0,"SWIM",true)
	end
end
function SpineFish:Build( vo )
	if FishBase.Build(self,vo) then
		self:OnLoadObject(self.transform)
		return true
	else
		return false
	end
end
function SpineFish:OnLoadObject(t)
	FishBase.OnLoadObject(self,t)
	self:Find(o)
end
function SpineFish:Find(o)
	self.skeletonAnimator = self.transform:Find("Bone/Fish"):GetComponent(typeof(SkeletonAnimation))
	self.skeletonAnimator.loop=true
	self.skeletonAnimator.skeleton.R= 1
	self.skeletonAnimator.skeleton.G= 1
	self.skeletonAnimator.skeleton.B= 1
	self.skeletonAnimator.skeleton.A= 1
	if self.vo.fishKind == 22 then
		self.skeletonAnimator.state:SetAnimation(0,"Swim",true)
	elseif self.vo.fishKind == 35 then
		self.skeletonAnimator.state:SetAnimation(0,"animation",true)
	elseif self.vo.fishKind == 38 then
		self.skeletonAnimator.state:SetAnimation(0,"SWIM",true)
	end

end

function SpineFish:SetOrder()

end

function SpineFish:FishNormalDie( hitFishMsg,player,callBack )
	FishBase.FishBaseDie(self,hitFishMsg,player)
	self.callBack=callBack
	--播放粒子特效
	if self.vo.dieEffect~=nil then
		self.gameObject:SetActive(false)
		local explosiveName = self.vo.fishConfig.dieEffect
		GameController:GetInstance().view:PlayExplosive2(explosiveName, self.transform.position);
	end
end

function SpineFish:PlayDeadAni()
	-- local skeletonAnimator=self.transform:Find("Bone/Fish"):GetComponent(typeof(SkeletonAnimation))
	-- skeletonAnimator.loop=true
	-- skeletonAnimator.state:SetAnimation(0,"die",true)
end

function SpineFish:__delete( ... )
	-- body
end