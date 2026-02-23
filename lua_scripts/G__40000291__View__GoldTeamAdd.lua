GoldTeamAdd=BaseClass()

function GoldTeamAdd:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	self:Find(t)
end
function GoldTeamAdd:Find(t)
	self.isCanDestroy=false
	self.ani=self.transform:GetComponent(typeof(Animator))
	self.uiGoldLabelMoney=self.transform:Find("Ani/Money/GoldMoney"):GetComponent(typeof(UILabel))
	self.uiSilverLabelMoney=self.transform:Find("Ani/Money/SilverMoney"):GetComponent(typeof(UILabel))
	self.isUp=false
end
function GoldTeamAdd:SetPos(isUp)
	self.isUp=isUp
end
function GoldTeamAdd:Set(money,pos,isMe)
	local uiLabel=isMe and self.uiGoldLabelMoney or self.uiSilverLabelMoney
	uiLabel.text="+"..NumberThousandsFormat(HallGoldRateSToC(money or 0))
	self.transform.position=pos
	self.uiGoldLabelMoney.gameObject:SetActive(isMe)
	self.uiSilverLabelMoney.gameObject:SetActive(not isMe)
end
function GoldTeamAdd:Play()
	self.isFisrtFrame=true
	self.isCanDestroy=false
	self.gameObject:SetActive(true)
	--local clipName=self.isUp and "Coin_Fly_Animation01" or "Coin_Fly_Animation"
	--self.ani:Play(clipName)
	self.ani:Play("Coin_Fly_Animation")
end
function GoldTeamAdd:Update( ... )
	if self.isCanDestroy then return end
	if self.isFisrtFrame then
		self.isFisrtFrame=false
	else
		if self.ani:GetCurrentAnimatorStateInfo(0).normalizedTime>=1 then
			self.isCanDestroy=true
		end
	end
end
-- function GoldTeamAdd:__delete( ... )
-- 	self.gameObject:SetActive(false)
-- end