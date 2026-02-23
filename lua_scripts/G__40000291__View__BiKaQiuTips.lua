BiKaQiuTips = BaseClass()
BiKaQiuTips.State={
	None=0,
	PlayBegin=1,
	Keep=2,
	End=3,
}

BiKaQiuTips.PaoFenStep = {
	OneStep = 1,
	TwoStep = 2,
	ThreeStep = 3,
	FourStep = 4,
	FiveStep =5,
	SixStep = 6,
	sever = 7,
}


function BiKaQiuTips:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self:Find(t)
end
function BiKaQiuTips:Find(t)
	self.ani=self.transform:GetComponent(typeof(Animator))
	self.spriteIcon = self.transform:Find("Ani/Icon"):GetComponent(typeof(UISprite))
	self.nameIcon = self.transform:Find("Ani/Iconname"):GetComponent(typeof(UISprite))
	self.userMoneyLabel = self.transform:Find("Ani/Score"):GetComponent(typeof(UILabel))
	self.vecInitPos=self.transform.localPosition
	self.state=BiKaQiuTips.State.None

	self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.OneStep
	self.paofengStep = BiKaQiuTips.PaoFenStep.OneStep

	self.keepTime=1

	self.currentMoney=0	
	self.changeBeforeMoney=0
	self.changeMoney=0
	self.averageTime =0
	self.changeTime= self.averageTime
	self.currentTime=0
	self.IsStartChangeGold= false
	self.animaTime = 0.5
	self.mulBeishu = 0
end
function BiKaQiuTips:Set(money,isMe,name,sprite,multiple)
	self:Open()
	self.mulBeishu = multiple
	self.transform.localPosition=self.vecInitPos
	self.transform.localScale=Vector3.one
	self.isFirstFrame=true
	self.ani:Play("Ani_Appear")
	self.state=BiKaQiuTips.State.PlayBegin
	if multiple>0 and multiple <= 149 then
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.OneStep
	elseif multiple>=150 and multiple<=199 then
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.TwoStep
	elseif multiple>=200 and multiple<=249 then
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.ThreeStep
	elseif multiple>=250 and multiple<=299 then
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.FourStep
	elseif multiple>=300 and multiple<=399 then	
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.FiveStep
	elseif multiple>=400 then
		self.targetPaoFengStep = BiKaQiuTips.PaoFenStep.SixStep
	end

	self.keepTime=3
	self.ani.speed=1

	self.IsStartChangeGold= false
	self.changeMoney = money/self.targetPaoFengStep
	self.paofengStep = FishKingTips.PaoFenStep.OneStep
	self.changeBeforeMoney=0
	self.currentMoney = money
	self.averageTime = 1.5
	self.changeTime= self.averageTime
	self:SetMoneyLabel(0,name,sprite)
end

function BiKaQiuTips:SetMoneyLabel(money,name,sprite)
	self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(money))

	self.nameIcon.spriteName = name
	self.spriteIcon.spriteName = sprite
end
function BiKaQiuTips:Open( ... )
	self.gameObject:SetActive(true)
end
function BiKaQiuTips:Close( ... )
	if self.gameObject.activeInHierarchy == false then
		return
	end
	self.gameObject:SetActive(false)

	if self.mulBeishu >= 200 then
		GameController:GetInstance().view:PlayLuckExplosive("LuckyWin",Vector3.zero,self.currentMoney)
	end
end
function BiKaQiuTips:Update()
	
	if self.state == BiKaQiuTips.State.PlayBegin then
		self.as=self.ani:GetCurrentAnimatorStateInfo(0)
		if self.as.normalizedTime>=1 then
			self.state=FishKingTips.State.Keep
			self:SetGoldChange()
			GameController:GetInstance():PlayPaoFenAudio(50,0.75) 
		end
	end

	if self.state==FishKingTips.State.End then 
		self.as=self.ani:GetCurrentAnimatorStateInfo(0)
		if self.as.normalizedTime>=1 then
			self:Close()
			GameController:GetInstance().GunFen:Stop()
			self.state=FishKingTips.State.None
		end
	end
	self:ChangeGlod()

	-- if self.state==BiKaQiuTips.State.PlayBegin then
	-- 	if self.isFirstFrame then
	-- 		self.isFirstFrame=false
	-- 		if self.gameObject.activeInHierarchy == true then
	-- 			self.as=self.ani:GetCurrentAnimatorStateInfo(0)
	-- 		else
	-- 			self.state=BiKaQiuTips.State.End
	-- 		end
	-- 	else
	-- 		if self.gameObject.activeInHierarchy == true then
	-- 			self.as=self.ani:GetCurrentAnimatorStateInfo(0)
	-- 			if self.as.normalizedTime>=1 then
	-- 				self.state=BiKaQiuTips.State.Keep
	-- 				self.keepTime=3
	-- 			end
	-- 		else
	-- 			self.state=BiKaQiuTips.State.End
	-- 		end
	-- 	end
	-- end
	-- if self.state==BiKaQiuTips.State.Keep then
	-- 	if self.keepTime>0 then
	-- 		self.keepTime=self.keepTime-Time.deltaTime
	-- 	else
	-- 		self.state=BiKaQiuTips.State.End
	-- 		self.playEndTime=0.2
	-- 		self.tmpTime=0
	-- 	end
	-- end
	-- if self.state==BiKaQiuTips.State.End then 
	-- 	self:Close()
	-- end
end


function BiKaQiuTips:SetGoldChange()
	-- if changeTime==nil then
	-- 	self.changeTime=1
	-- end
	-- self.currentMoney=money	
	-- self.changeBeforeMoney=self.gameData.BeforePlayerMoney
	-- self.changeMoney=self.currentMoney-self.changeBeforeMoney
	if self.changeMoney>0 then
		self.IsStartChangeGold=true
	end
end

function BiKaQiuTips:ChangeGlod()
	if self.IsStartChangeGold then
		if self.paofengStep <= self.targetPaoFengStep then
			if self.paofengStep == BiKaQiuTips.PaoFenStep.OneStep then
				self.currentTime=self.currentTime+Time.deltaTime
				self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*(self.currentTime/self.changeTime))))
				if self.currentTime >= self.averageTime then
					self.currentTime=0
					self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
					 self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))
					 self.ani:Play("Ani_ScoreJump01",0,0)
					 RenderMgr.Remove("StepOne")
					 RenderMgr.AddInterval(function()
						GameController:GetInstance():PlayPaoFenAudio(51,0.75) 
						   end,"StepOne",0.5,0.55)
					 GameController:GetInstance():PlayPaoFenAudio(92,1) 
					 self.paofengStep = BiKaQiuTips.PaoFenStep.TwoStep
				end
			elseif self.paofengStep == BiKaQiuTips.PaoFenStep.TwoStep then
				self.currentTime=self.currentTime+Time.deltaTime
				if self.currentTime >= self.animaTime then
					self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*((self.currentTime - self.animaTime)/self.changeTime))))
				
					if self.currentTime >= (self.averageTime + self.animaTime) then
						self.currentTime=0
						self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
						self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))	
						self.ani:Play("Ani_ScoreJump02",0,0)
						self.paofengStep = BiKaQiuTips.PaoFenStep.ThreeStep
						RenderMgr.Remove("TwoStep")
						RenderMgr.AddInterval(function()
						   GameController:GetInstance():PlayPaoFenAudio(52,0.75) 
							  end,"TwoStep",0.5,0.55)
						GameController:GetInstance():PlayPaoFenAudio(93,1) 
					end
				end
			elseif self.paofengStep == BiKaQiuTips.PaoFenStep.ThreeStep then
				self.currentTime=self.currentTime+Time.deltaTime
				if self.currentTime >= self.animaTime then
					self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*((self.currentTime - self.animaTime)/self.changeTime))))
					if self.currentTime >= (self.averageTime + self.animaTime) then
						self.currentTime=0
						self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
						self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))	
						self.ani:Play("Ani_ScoreJump03",0,0)
						self.paofengStep = BiKaQiuTips.PaoFenStep.FourStep
						RenderMgr.Remove("ThreeStep")
						RenderMgr.AddInterval(function()
						   GameController:GetInstance():PlayPaoFenAudio(53,0.75) 
							  end,"ThreeStep",0.5,0.55)
						GameController:GetInstance():PlayPaoFenAudio(94,1)
					end
				end
			elseif self.paofengStep == BiKaQiuTips.PaoFenStep.FourStep then
				self.currentTime=self.currentTime+Time.deltaTime
				if self.currentTime >= self.animaTime then
					self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*((self.currentTime - self.animaTime)/self.changeTime))))
					if self.currentTime >= (self.averageTime + self.animaTime) then
						self.currentTime=0
						self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
						self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))		
						self.ani:Play("Ani_ScoreJump04",0,0)
						self.paofengStep = BiKaQiuTips.PaoFenStep.FiveStep
						RenderMgr.Remove("FourStep")
						RenderMgr.AddInterval(function()
						   GameController:GetInstance():PlayPaoFenAudio(54,0.75) 
							  end,"FourStep",0.5,0.55)
						GameController:GetInstance():PlayPaoFenAudio(95,1)
					end
				end
			elseif self.paofengStep == BiKaQiuTips.PaoFenStep.FiveStep then
				self.currentTime=self.currentTime+Time.deltaTime
				if self.currentMoney >= self.animaTime then
					self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*((self.currentTime - self.animaTime)/self.changeTime))))
					if self.currentTime >= (self.averageTime + self.animaTime) then
						self.currentTime=0
						self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
						self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))		
						self.ani:Play("Ani_ScoreJump05",0,0)
						self.paofengStep = BiKaQiuTips.PaoFenStep.SixStep
						RenderMgr.Remove("FiveStep")
						RenderMgr.AddInterval(function()
						   GameController:GetInstance():PlayPaoFenAudio(55,0.75) 
							  end,"FiveStep",0.5,0.55)
						GameController:GetInstance():PlayPaoFenAudio(96,1)
					end
				end
			elseif self.paofengStep == BiKaQiuTips.PaoFenStep.SixStep then
				self.currentTime=self.currentTime+Time.deltaTime
				if self.currentTime >= self.animaTime then
					self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(math.ceil(self.changeBeforeMoney+self.changeMoney*((self.currentTime - self.animaTime)/self.changeTime))))
					--GameController:GetInstance():PlayPaoFenAudio(55) 	
					if self.currentTime >= (self.averageTime + self.animaTime) then
						self.currentTime=0
						self.changeBeforeMoney = self.changeBeforeMoney + self.changeMoney
						self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.changeBeforeMoney))		
						self.paofengStep = FishKingTips.PaoFenStep.sever
						GameController:GetInstance():PlayPaoFenAudio(97,1)	
					end
				end
			end
		else
			
			self.IsStartChangeGold = false
			self.state=BiKaQiuTips.State.End
			self.userMoneyLabel.text=NumberThousandsFormat(HallGoldRateSToC(self.currentMoney))
			if self.targetPaoFengStep == 1 then
				RenderMgr.Remove("StepOne")
				self.ani:Play("Ani_Disappear01",0,0)
			elseif  self.targetPaoFengStep == 2 then
				RenderMgr.Remove("TwoStep")
				self.ani:Play("Ani_Disappear02",0,0)
			elseif  self.targetPaoFengStep == 3 then
				RenderMgr.Remove("ThreeStep")
				self.ani:Play("Ani_Disappear03",0,0)
			elseif  self.targetPaoFengStep == 4 then
				RenderMgr.Remove("FourStep")
				self.ani:Play("Ani_Disappear04",0,0)
			elseif  self.targetPaoFengStep == 5 then
				RenderMgr.Remove("FiveStep")
				self.ani:Play("Ani_Disappear05",0,0)
			elseif  self.targetPaoFengStep == 6 then
				self.ani:Play("Ani_Disappear06",0,0)
			end
		
		end
		-- self.currentTime=self.currentTime+Time.deltaTime
		-- self.userMoneyLabel.text=CommonHelp.SetNumberFormatScore(math.ceil(self.changeBeforeMoney+self.changeMoney*(self.currentTime/self.changeTime)))
		-- if self.currentTime>=self.changeTime then
		-- 	self.IsStartChangeGold=false
		-- 	self.currentTime=0
		-- 	self.userMoneyLabel.text=CommonHelp.SetNumberFormatScore(self.currentMoney)
		-- end
	end
	
end


function BiKaQiuTips:__delete()
	-- body
end