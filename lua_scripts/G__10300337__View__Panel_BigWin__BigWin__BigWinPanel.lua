BigWinPanel=BaseClass()

function BigWinPanel:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
	CommonHelp.AddUpdate(self)
end


function BigWinPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.updateName="BigWinPanel.Update"
	self.EffectGroup={}
	self.EffectAnimGroup={}
	self.IsChangeScore=false
	self.currentTime=0
	self.totalTime=0
	self.totalScore=0
	self.currentScore=0
	self.totalShowTime=0
	self.showLable=nil
	self.showSlider=nil
	self.AudioIndex=1
	self.IsOnclickStop=false
	self.CurrentBigWinIndex=1
	self.IsCanShip=false
	
end


function BigWinPanel:InitView()
	self:FindView()
end

function BigWinPanel:FindView()
	local tf=self.gameObject.transform
	self.Win1=tf:Find("WIN1").gameObject
	self.Win2=tf:Find("WIN2").gameObject
end


function BigWinPanel:IsShowBigWinPanel(isdisplay)
	BigWinController.GetInstance():IsShowPanel(isdisplay)
end


function BigWinPanel:SetWinScoreLableVlaue(showLable,score)
	if showLable then
		showLable.text=CommonHelp.SetNumberThousandsFormatScore(score)--string.format("%.1f",CommonHelp.SetScore(score))
	else
		print("��ʾshowLableΪnil")
	end
	
end



function BigWinPanel:SetWinScoreEffect(index,score,times)
	self:IsShowBigWinPanel(true)
	CommonHelp.PlayAudio(GameAudioPath.BigWin[1])
	CommonHelp.PlayAudio(GameAudioPath.RollNumber)
	self.IsOnclickStop=false
	self.totalShowTime=times+0.5
	self.totalTime=times
	self.IsCanShip=true
	self.Win1:SetActive(index==1)
	self.Win2:SetActive(index==2)
	self.CurrentBigWinIndex=index
	self.AudioIndex=index
	self.currentTime=0
	self.totalScore=score
	self.StopMark=true
	self.IsChangeScore=true
	self.IsOnclickStop=true
end



function BigWinPanel:ChangeScore()
	if self.IsChangeScore then
		self.currentTime=self.currentTime+Time.deltaTime
		if self.currentTime>=self.totalTime and self.StopMark then
			self.StopMark=false
			CommonHelp.StopAllAudio()
		end
		if self.currentTime>=self.totalShowTime then
			self.currentTime=0
			self.IsChangeScore=false
			self:BigWinEndCallBack()
		end
	end
end


function BigWinPanel:BigWinEndCallBack()
	self:IsShowBigWinPanel(false)
	self.gameData.GameStateManager:EndStateCallBack()
	if not self.gameData.IsAuto and not self.IsOnclickStop then
		self.gameData.GameControlManager:StartGame()
	end
end


function BigWinPanel:Update()
	self:ChangeScore()
end

function BigWinPanel:ResetScore()
	self.IsOnclickStop=false
	self.currentTime=self.totalTime
end