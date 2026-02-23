FloatNum=BaseClass()

function FloatNum:__init(t)
	self.transform=t
	self.gameObject=t.gameObject
	
	--self.isCanDestroy=false
	--self._isCanCd=false
	--self.isPlaying=false
	self.m_tranGoldFishMoneyParent = self.transform:Find("Gold");
    self.m_uilabelGoldFishMoney = self.transform:Find("Gold/Coin01/Label"):GetComponent(typeof(UILabel));
    self._aniGold = self.transform:Find("Gold"):GetComponent(typeof(Animator));
	--self._asGold=
    self.m_tranSilverFishMoneyParent = self.transform:Find("Silver");
    self.m_uilabelSilverFishMoney = self.transform:Find("Silver/Coin01/Label"):GetComponent(typeof(UILabel));
    self._aniSilver = self.transform:Find("Silver"):GetComponent(typeof(Animator))
	--self._asSilver=self._aniSilver:GetCurrentAnimatorStateInfo(0)
end
function FloatNum:Update( ... )
	if self.isPlaying then
		if self._isMe then
			if self._aniGold:GetCurrentAnimatorStateInfo(0).normalizedTime>=1 then
				--self._isCanCd=false
				self.isPlaying=false
				self.isCanDestroy=true
				-- if self._callBack then
				-- 	self._callBack()
				-- 	self._callBack=nil
				-- end
				-- self._asGold.normalizedTime=0
				-- self._aniGold:Sample()
			end
		else
			if self._aniSilver:GetCurrentAnimatorStateInfo(0).normalizedTime>=1 then
				--self._isCanCd=false
				self.isCanDestroy=true
				self.isPlaying=false
				-- if self._callBack then
				-- 	self._callBack()
				-- 	self._callBack=nil
				-- end
				-- self._asSilver.normalizedTime=0
				-- self._aniSilver:Sample()
			end
		end
	end
end
function FloatNum:SetPosition(pos)
	self.transform.position=pos
	-- body
end
function FloatNum:SetMoneyUILabel(money,chariID,callBack)
	self._isMe=chariID==GameModel:GetInstance().m_myServerDesk
	--self.chariID=chariID
	local valueMoney= NumberThousandsFormat(HallGoldRateSToC(money or 0))
	self.m_tranGoldFishMoneyParent.gameObject:SetActive(self._isMe)
	self.m_tranSilverFishMoneyParent.gameObject:SetActive(not self._isMe)
	if self._isMe then
		self._aniGold:Play("Ani_FloatNum")
		self.m_uilabelGoldFishMoney.text=valueMoney
	else
		self._aniSilver:Play("Ani_FloatNum")
		self.m_uilabelSilverFishMoney.text=valueMoney
	end

	self.transform.localEulerAngles=Vector3.zero
	self.transform.localScale=Vector3.one

	self.isCanDestroy=false
	--self._isCanCd=true
	self.isPlaying=true
	--self._callBack=callBack
end
-- function FloatNum:__delete( ... )
-- 	GameController:GetInstance().view.m_poolFloatNum:Despawn(self.transform);
-- 	self.transform=nil
-- 	self.gameObject=nil
-- 	self.isCanDestroy=nil
-- 	self._isCanCd=nil
-- 	self.isPlaying=nil
-- 	self.m_tranGoldFishMoneyParent = nil
--     self.m_tranSilverFishMoneyParent =nil
--     self.m_uilabelGoldFishMoney = nil
--     self.m_uilabelSilverFishMoney = nil
--     self._aniGold = nil
--     self._asGold=nil
--     self._aniSilver = nil
--     self._asSilver=nil
-- end