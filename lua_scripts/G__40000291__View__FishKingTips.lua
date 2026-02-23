FishKingTips = BaseClass()
FishKingTips.State={
	None=0,
	PlayBegin=1,
	Keep=2,
	End=3,
}

function FishKingTips:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self:Find(t)
end
function FishKingTips:Find(t)
	self.isPlay = false
	self.ani=self.transform:GetComponent(typeof(Animator))
	self.userMoneyLabel = self.transform:Find("Ani/Turntable_Floor/Score"):GetComponent(typeof(UILabel))
end

function FishKingTips:Set(money,isMe,multiple)
	self:Open()

	self.ani:Play("Ani_NormalReward",0,0)
	self.state=FishKingTips.State.PlayBegin

	self.currentTime=0
	self.KeepTime = 1.5
	self.isPlay = true
	
	if multiple >= 150 then
		GameController:GetInstance():PlayConinAudio(9)
		GameController:GetInstance().view:PlayLuckExplosive("Effect_Big_Winner",Vector3.zero,money)
	end

	self:SetMoneyLabel(money)
	
end

function FishKingTips:SetMoneyLabel(m)
	self.userMoneyLabel.text= NumberThousandsFormat(HallGoldRateSToC(m or 0))
end

function FishKingTips:Open( ... )
	self.gameObject:SetActive(true)
end
function FishKingTips:Close( ... )
	self.gameObject:SetActive(false)
end

function FishKingTips:Update()
	if self.isPlay == false then return end

	if self.state == FishKingTips.State.PlayBegin then
		self.as=self.ani:GetCurrentAnimatorStateInfo(0)
		if self.as.normalizedTime>=1 then
			self.state=FishKingTips.State.Keep
			self.currentTime = 0
			-- GameController:GetInstance():PlayPaoFenAudio(50,0.75) 
		end
	end

	if self.state == FishKingTips.State.Keep then
		self.currentTime = self.currentTime + Time.deltaTime
		if self.currentTime >= self.KeepTime then
			self.state=FishKingTips.State.End
		end
	end

	if self.state==FishKingTips.State.End then 
		self.isPlay = false
		self:Close()	
	end	
end


function FishKingTips:__delete()
	-- body
end