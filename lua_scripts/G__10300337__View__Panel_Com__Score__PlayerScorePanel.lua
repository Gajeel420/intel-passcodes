PlayerScorePanel=BaseClass()

function PlayerScorePanel:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
	CommonHelp.AddUpdate(self)
end


function PlayerScorePanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  	
	self.updateName="PlayerScorePanel.Update"
	self.currentWinScore=0								--当前赢分
	self.IsStartWinScore=false	
	self.currentWinScoreTime=0
	self.CurrentFreeGameTotalScore=0				--当前免费游戏累积分
	self.IsFreeGame=false							--是否是免费游戏累加
	self.totalTimes=0
	self.TipsInfo={}
	self.WinLineTipsGroup={}
	self.m_NowTime=0
	self.m_IntervalTime=5
end


function PlayerScorePanel:InitView()

	self:FindView()
	self:InitUIViewData()
	
	
end

function PlayerScorePanel:FindView()
	local tf=self.gameObject.transform
	self.ScoreLabel=tf:Find("Bottom/Score/Label_DeFen"):GetComponent(typeof(UILabel))
	self.WinLineTipsObj=tf:Find("Bottom/Score/Reward_Tips").gameObject
	self.ScoreLabelAnim=tf:Find("Bottom/Score"):GetComponent(typeof(Animation))
	self.ScoreLabelTips=tf:Find("Bottom/Score/Back/Sprite_Label"):GetComponent(typeof(UISprite))
	--self.TipsObj=tf:Find("Bottom/Score/Label_Tips").gameObject
	for i=1,2 do
		local tempTips=tf:Find("Bottom/Score/Reward_Tips/Label_Tips"..i):GetComponent(typeof(UILabel))
		table.insert(self.WinLineTipsGroup,tempTips)
		--tempTips=tf:Find("Bottom/Score/Label_Tips/Tip0"..i).gameObject
		--table.insert(self.TipsInfo,tempTips)
	end
	self.m_TopTipLabel = tf:Find("Bottom/Score/Label_Wanning"):GetComponent(typeof(UILabel))

	self.m_Effect_Win = tf:Find("Bottom/Score/Effect_Win").gameObject
	self.m_Effect_Win:SetActive(false)

	self.m_TopTipList = {}
	for i = 1, 4 do
		self.m_TopTipList[i] = tf:Find("Title/Tip/0"..i).gameObject
	end
	self.m_IndexTitle = 1
end


function PlayerScorePanel:InitUIViewData()
	self:IsShowWinScorePanel(false)
	self:IsShowTipsPanel(true)
	self:SetTipsVaule(1)
	self:SetPlayerWinScore(0)
	self:SetWinTipsPanel()
	self:ShowGoodLuck()
end

function PlayerScorePanel:IsShowWinScorePanel(isdisplay)
	CommonHelp.SetActive(self.WinLineTipsObj,isdisplay)
end

function PlayerScorePanel:IsShowWinScore(isdisplay)
	CommonHelp.SetActive(self.ScoreLabel.gameObject,isdisplay)
end

function PlayerScorePanel:SetPlayerWinScore(score)
	if score==0 then
		self.ScoreLabel.text="0.00"
	else
		self.ScoreLabel.text=CommonHelp.SetNumberThousandsFormatScore(score)
	end
	
end


function PlayerScorePanel:SetWinScoreNull()
	if self.gameData.GameControlManager.beforeSubStation~=GameDefine.SubGameState.FreeGame then
		self.ScoreLabel.text=""
	end
end

function PlayerScorePanel:IsShowTipsPanel(isdisplay)
	--CommonHelp.SetActive(self.TipsObj,isdisplay)
end

function PlayerScorePanel:SetTipsVaule(index)
	--CommonHelp.IsShowPanel(index,self.TipsInfo,true,true,false)
end


function PlayerScorePanel:SetTipsPanel(index)
	self:IsShowWinScorePanel(false)
	self:SetTipsInfo(index)
end


function PlayerScorePanel:SetTipsInfo(index)
	self:IsShowTipsPanel(true)
	self:SetTipsVaule(index)
end


function PlayerScorePanel:SetAllShowTips(lineCount,multiples)
	self:IsShowTipsPanel(false)
	self:IsShowWinScorePanel(true)
	local tips="中"..lineCount.."线"
	local allTips={}
	table.insert(allTips,tips)
	tips="共"..multiples.."倍"
	table.insert(allTips,tips)
	for i=1,#self.WinLineTipsGroup do
		self.WinLineTipsGroup[i].text=allTips[i]
	end
end


function PlayerScorePanel:SetShowTips(itemCount,multiple)
	local tips=itemCount.."连="..multiple.."倍"
	self.WinLineTipsGroup[1].text=tips
end





function PlayerScorePanel:SetWinScore(values,isFreeGame,times)
	if isFreeGame==nil then
		isFreeGame=false
		self.CurrentFreeGameTotalScore=0
	end
	self.IsFreeGame=isFreeGame
	if times==nil then
		self.totalTimes=1.5
	else
		self.totalTimes=times
	end
	self.currentWinScore=values
	if values==0 then
		self.IsStartWinScore=false
		self:SetPlayerWinScore(values)
	else
		self.IsStartWinScore=true

	end
end

function PlayerScorePanel:GetShowScoreState()
	return self.IsStartWinScore
end

function PlayerScorePanel:ResetScore()
	self.currentWinScoreTime=self.totalTimes
end


function PlayerScorePanel:ChangeWinScore()
	if self.IsStartWinScore then
		self.currentWinScoreTime=self.currentWinScoreTime+Time.deltaTime
		local result=math.ceil(self.CurrentFreeGameTotalScore+self.currentWinScore*(self.currentWinScoreTime/self.totalTimes))
		self:SetPlayerWinScore(result)
		if self.currentWinScoreTime >=self.totalTimes then
			self.IsStartWinScore=false
			self.currentWinScoreTime=0

			self:SetPlayerWinScore(self.CurrentFreeGameTotalScore+self.currentWinScore)
			self:IsFreeGameAdd(self.IsFreeGame)
		end
	end
end


function PlayerScorePanel:IsFreeGameAdd(isFreeGame)
	if isFreeGame then
		self.CurrentFreeGameTotalScore=self.CurrentFreeGameTotalScore+self.currentWinScore
	else
		self.CurrentFreeGameTotalScore=0
	end
end

function PlayerScorePanel:ResetFreeGameAddScore()
	self.CurrentFreeGameTotalScore=0
end



function PlayerScorePanel:Update()
	self:ChangeWinScore()
	self:UpdateTips()
end


function PlayerScorePanel:SetWinTipsPanel(isWin)
	-- local spriteName=""
	-- if isWin then
	-- 	if self.gameData.LanguageType==1 then
	-- 		spriteName="Game_UI_Label_Get01_CH"
	-- 	else
	-- 		spriteName="Game_UI_Label_Get01_EN"
	-- 	end
		
	-- else
	-- 	if self.gameData.LanguageType==1 then
	-- 		spriteName="Game_UI_Label_Get_CH"
	-- 	else
	-- 		spriteName="Game_UI_Label_Get_EN"
	-- 	end
	-- end
	-- self.ScoreLabelTips.spriteName=spriteName
end

function PlayerScorePanel:ShowGoodLuck()
	self.m_TopTipLabel.text = "GOOD LUCK"
end

function PlayerScorePanel:ShowWinMoney_NormalGame(value)
	value = CommonHelp.SetNumberThousandsFormatScore(value)
	self.m_TopTipLabel.text =  string.format("%.2f", value).." Credits Won"
end

function PlayerScorePanel:PlaySocreAnim()
	-- self.ScoreLabelAnim:Play("Score_Ani")
end

function PlayerScorePanel:ShowEffect_Win()
	self.m_Effect_Win:SetActive(false)
	self.m_Effect_Win:SetActive(true)
end

function PlayerScorePanel:UpdateTips()
	self.m_NowTime = self.m_NowTime+Time.deltaTime
	if self.m_NowTime>=self.m_IntervalTime then
		self.m_NowTime=0
		self:ShowTipTitleView()
	end
end

function PlayerScorePanel:ShowTipTitleView()
	for i = 1, #self.m_TopTipList do
		if i == self.m_IndexTitle then
			self.m_TopTipList[i]:SetActive(true)
		else
			self.m_TopTipList[i]:SetActive(false)
		end
	end
	self.m_IndexTitle = self.m_IndexTitle + 1
	if self.m_IndexTitle > #self.m_TopTipList then
		self.m_IndexTitle = 1
	end
end