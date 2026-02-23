PlayerInfoPanel=BaseClass()

function PlayerInfoPanel:__init(gameObj)
	print("创建PlayerInfoPanel")
	self.gameObject=gameObj
	self:InitData()
	self:InitView()
	CommonHelp.AddUpdate(self)
end

function PlayerInfoPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  	
	self.updateName="PlayerInfoPanel.Update"
	self.currentMoney=0
	self.changeBeforeMoney=0
	self.changeMoney=0
	self.IsStartChangeGold=false		--是否开始改变金币
	self.changeTime=0
	self.currentTime=0					--当前时间
end



function PlayerInfoPanel:InitView()
	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
end


function PlayerInfoPanel:InitUIViewData()
		
end

function PlayerInfoPanel:FindView()
	local tf=self.gameObject.transform
	self:InitPlayerView(tf)
end



function PlayerInfoPanel:InitPlayerView(tf)
	self.userNameLabel=tf:Find("Bottom/Planer_Info/Name/Label_NickName"):GetComponent(typeof(UILabel))  --名字
	self.userHeadTexture=tf:Find("Bottom/Planer_Info/Name/HeadBox/Head"):GetComponent(typeof(UITexture))  --头像
	self.userMoneyLabel=tf:Find("Bottom/Planer_Info/Money/Label_MyMoney"):GetComponent(typeof(UILabel))  --金币
	self.m_AniWinEffect=tf:Find("Bottom/Planer_Info/Money/Effect_Win").gameObject
	self.m_AnimationWinEffect=self.m_AniWinEffect:GetComponent(typeof(Animation))
	self.m_AnimationWinEffect.enabled = false
end

function PlayerInfoPanel:InitUIView()

end



function PlayerInfoPanel:SetUserInfo(myUserInfo)
	local tmpUserInfo = {}
	tmpUserInfo.iMoney = myUserInfo.iMoney
	tmpUserInfo.szNickName = myUserInfo.szNickName
	tmpUserInfo.uiUserID=myUserInfo.uiUserID
	tmpUserInfo.imgNo=PlayerInfoController:GetInstance().model.mainPlayer.iImageNO
	self:SetPlayerData(tmpUserInfo)
	self.gameData.PlayerMoney=tmpUserInfo.iMoney
end



function PlayerInfoPanel:SetPlayerData(info)
	self.userNameLabel.text=GetUserNickNameUnique(info.szNickName)
	--PlayerHeadPortainMgr:GetInstance():BindHeadUserID(self.userHeadTexture.gameObject, info.uiUserID,1)
	PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.userHeadTexture.gameObject,ConfigInfoMgr.ThirdPlatformHeadURL,1,info.imgNo)
	--self.userMoneyLabel.text=CommonHelp.SetNumberFormatScore(info.iMoney)
	self:SetPlayMoney(info.iMoney)
end


function PlayerInfoPanel:SetGoldChange(money,changeTime)
	if changeTime==nil then
		self.changeTime=1.5
	else
		self.changeTime=changeTime
	end
	self.currentMoney=money	
	self.changeBeforeMoney=self.gameData.BeforePlayerMoney
	self.changeMoney=self.currentMoney-self.changeBeforeMoney
	if self.changeMoney>0 then
		self.IsStartChangeGold=true
	end
	
	
end

function PlayerInfoPanel:ChangeGlod()
	if self.IsStartChangeGold then
		self.currentTime=self.currentTime+Time.deltaTime
		self.userMoneyLabel.text=CommonHelp.SetNumberThousandsFormatScore(math.ceil(self.changeBeforeMoney+self.changeMoney*(self.currentTime/self.changeTime)))
		if self.currentTime>=self.changeTime then
			self.IsStartChangeGold=false
			self.currentTime=0
			self:SetPlayMoney(self.currentMoney)
			self:ShowEffectWinMoney()
		end
	end
	
end

function PlayerInfoPanel:ShowEffectWinMoney()
	self.m_AniWinEffect:SetActive(false)
	self.m_AnimationWinEffect.enabled = true
	self.m_AniWinEffect:SetActive(true)
end


function PlayerInfoPanel:SetPlayMoney(money)
	self.gameData.BeforePlayerMoney=money
	self.IsStartChangeGold=false
	self.userMoneyLabel.text=CommonHelp.SetNumberThousandsFormatScore(money)
end

function PlayerInfoPanel:Update()
	self:ChangeGlod()
end

function PlayerInfoPanel:ResetScore()
	self.currentTime=self.changeTime
end

return PlayerInfoPanel