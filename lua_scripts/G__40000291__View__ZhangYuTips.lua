ZhangYuTips = BaseClass()
ZhangYuTips.State={
	None=0,
	PlayBegin=1,
	Keep=2,
	End=3,
}
function ZhangYuTips:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self:Find(t)
end
function ZhangYuTips:Find(t)
	self.ani=self.transform:Find("Ani"):GetComponent(typeof(Animator))
	--self.spriteIcon = self.transform:Find("Ani/bg/Fish/FishIcon"):GetComponent(typeof(UISprite))
	self.uiLabel = self.transform:Find("Ani/bg/Label"):GetComponent(typeof(UILabel))
	-- self.uiLabel=self.transform:Find("Ani/bg/Label"):GetComponent(typeof(UILabel))
	self.vecInitPos=self.transform.localPosition
	self.state=ZhangYuTips.State.None
	self.keepTime=1
end
function ZhangYuTips:Set(money,isMe)
	self:Open()
	self.transform.localPosition=self.vecInitPos
	self.transform.localScale=Vector3.one
	self.isFirstFrame=true
	self.ani:Play("Win1")
	self.state=ZhangYuTips.State.PlayBegin
	self.keepTime=1
	self.ani.speed=1
	self:SetMoneyLabel(money)
end

function ZhangYuTips:SetMoneyLabel(money)
	self.uiLabel.text=NumberThousandsFormat(HallGoldRateSToC(money))
end
function ZhangYuTips:Open( ... )
	self.gameObject:SetActive(true)
end
function ZhangYuTips:Close( ... )
	self.gameObject:SetActive(false)
end
function ZhangYuTips:Update()
	
	if self.state==ZhangYuTips.State.PlayBegin then
		if self.isFirstFrame then
			self.isFirstFrame=false
			if self.gameObject.activeInHierarchy == true then
				self.as=self.ani:GetCurrentAnimatorStateInfo(0)
			else
				self.state=ZhangYuTips.State.End
			end
		else
			if self.gameObject.activeInHierarchy == true then
				self.as=self.ani:GetCurrentAnimatorStateInfo(0)
				if self.as.normalizedTime>=1 then
					self.state=ZhangYuTips.State.Keep
					self.keepTime=2
				end
			else
				self.state=ZhangYuTips.State.End
			end
		end
	end
	if self.state==ZhangYuTips.State.Keep then
		if self.keepTime>0 then
			self.keepTime=self.keepTime-1
		else
			self.state=ZhangYuTips.State.End
			self.playEndTime=0.2
			self.tmpTime=0
		end
	end
	if self.state==ZhangYuTips.State.End then 
		self:Close()
	end
end
function ZhangYuTips:__delete()
	-- body
end