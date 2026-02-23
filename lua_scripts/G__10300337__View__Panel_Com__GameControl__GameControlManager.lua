GameControlManager=BaseClass()


function GameControlManager:__init()
	self:InitData()
	self:InitView()

end

--初始化数据
function GameControlManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  --游戏数据
	self.stopTime=2										--旋转停止时间
	self.stopIntervalTime=1								--每列停止间隔时间
	self.maxLevel=15
	self.midLevel=15
	self.minLevel=10
	self.IsQuickStop=false
	self.beforeSubStation=0								--之前子的状态
	self.beforeStation=0								--之前的主状态
	self.IsStop=false				--是否停止游戏
	self.IsShowTipPanel=false
	self.IsChangeBet=false
end


--初始化界面
function GameControlManager:InitView()
	self:InitItemControl()
end




function GameControlManager:InitItemControl()
	for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
		local tempRowObj=self.gameData.ItemControl.New(self.gameData.GameIconParentList[i])
		tempRowObj:SetColIndex(i)
		tempRowObj:SetItemList(self.gameData.GameIconPosList[i])	
		tempRowObj:SetIconItemList(self.gameData.GameIconManager:GetGameIconInstanceRowList(i))
		table.insert(self.gameData.RowItemList,tempRowObj)
	end
	
end




function GameControlManager:ResetAllUIView()
	CommonHelp.StopAllAudio()
	self.gameData.IsFiveKindOnLineState=false
	self.IsStop=false
	self.IsChangeBet=false
	self.gameData.LineManager:HideAllLine()
	self.gameData.GameIconManager:StopAllIconAnimation()
	self.gameData.GameBetSet:IsEnableBetBtn(false)
	self.gameData.PlayerScorePanel:IsShowWinScorePanel(false)
	if self.gameData.bySubGameStation == GameDefine.SubGameState.FreeGame then
	else
		self.gameData.PlayerScorePanel:SetPlayerWinScore(0)
	end
	self.gameData.PlayerScorePanel:ShowTipTitleView()
	self.gameData.IsEnterStart=false
	self.IsQuickStop=false
	self.gameData.IsEnterStop=false
	self.gameData.IsReciveServerData=false
	if self.autoGameDelayTimer~=nil then
		self.autoGameDelayTimer:RemoveTimer()
		self.autoGameDelayTimer=nil
	end
	
	self.gameUIManager:RemoveStopRunTimmer()
	self.gameData.StartControlBtn:DisableStartBtn()
	self.gameData.GameIconManager:IsShowIconMask(false)
	self.gameUIManager:HideAllBetWin()
	self.gameUIManager:HideAllSpeedRunEffect()
	self.gameData.IsStartEffect=true
	self.gameData.IsAllStop = false
	self.gameData.IsSendGameStart=false
end




function GameControlManager:StartGame()
	StopAllCoroutines()
	self.StartRollIndex = math.random(1,4)
	self:ResetAllUIView()
	CommonHelp.PlayAudio(GameAudioPath.StartRoll[self.StartRollIndex])
	self:MonitoringStartGame()
	self:SetStartRunProcess()
	self.gameData.LastSendGameStartTime=os.time()
	self.gameData.ClientReqSeq=self.gameData.GameResultSeq
	GameUIManager.GetInstance():SendGameStart()
	self.gameData.StartControlBtn:SetStopBtnIsEnabled(true)
	self.gameData.StartControlBtn:SetStartAndStopBtnState(false)
	self.IsShowTipPanel=false
end

function GameControlManager:MonitoringStartGame()
	self:ResetAutoReciveTimer()
	self:IsStartAutoRecieveSeverRetrunData()
end


function GameControlManager:IsStartAutoRecieveSeverRetrunData()
	self.AutoRecieveReturnDataTimer=CommonHelp.SetTimeBackCall(self.gameData.IntervalTime,self.RecieveReturnDataCallBack,self)
end

function GameControlManager:ResetAutoReciveTimer()
	if self.AutoRecieveReturnDataTimer then
		self.AutoRecieveReturnDataTimer:RemoveTimer()
		self.AutoRecieveReturnDataTimer=nil
	end
end

function GameControlManager:RecieveReturnDataCallBack()
	self.gameData.OfflineTipsPanel:IsShowOffLineTips(true)
	self.gameData.IsSendGameStart=true
	if self.gameData.IsNormalSever then
		print("发送1123消息------------------------------------")
		GameUIManager.GetInstance():SendGameCurrentResult()
	end
	self:MonitoringStartGame()
	self.IsShowTipPanel=true
end


function GameControlManager:SetStartRunProcess()
	local StartRunEffectFunc=function ()
		for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
			local tempRow= self.gameData.RowItemList[i]
			tempRow:ResetActiveIconIns()
		end
		self:StartAllRun(15)
		self.gameData.IsStartEffect=false
	end
	StartCoroutine(StartRunEffectFunc)
end



function GameControlManager:StartGameCallBack()
	self.gameData.StartControlBtn:DisableStartBtn()
	self:ResetTimer()
	self.gameData.IsReciveServerData=true	--收到服务端数据
	self.gameData.IsSendGameStart=false
	self.gameData.IsEnterStart=true		--启用开始
	self.gameData.StartOnclickCount=0
	self.gameData.OfflineTipsPanel:IsShowOffLineTips(false)
end




--延迟开始按钮的隐藏
function GameControlManager:DelayHideStartBtn()
	self.gameData.StartControlBtn:SetStartAndStopBtnState(false)
end

function GameControlManager:ResetTimer()

	if self.gameData.StartBtnOnclickTimer then
		self.gameData.StartBtnOnclickTimer:RemoveTimer()
		self.gameData.StartBtnOnclickTimer=nil
	end
	
	
	if self.gameData.StartBtnEnableTimer then
		self.gameData.StartBtnEnableTimer:RemoveTimer()
		self.gameData.StartBtnEnableTimer=nil
	end
	
	self:ResetAutoReciveTimer()
	
end



function GameControlManager:StopGame(IsQuickStop)

	if IsQuickStop==nil then
		IsQuickStop=false
	end

	if self.IsQuickStop==false then
		self.IsQuickStop=IsQuickStop
	end
	
    if IsQuickStop then
		self.gameUIManager:SetStopRunTime()
	else
		if self.IsQuickStop or self.gameData.isQuick then
			self:QuickStopGame()
		else
			self:NormalStopGame()
		end
	end	
end

--正常停止游戏
function GameControlManager:NormalStopGame()	
	self:StopGameEffect(0.1,0.3)
end

--快速停止游戏
function GameControlManager:QuickStopGame()
	self:StopGameEffect(0.1,0.1)
end


function GameControlManager:StopGameEffect(stopTime,stopIntervalTime)
	self.stopTime=stopTime
	self.stopIntervalTime=stopIntervalTime
	CommonHelp.SetTimeBackCall(self.stopTime,self.StopGameCallBack,self)
	
end


function GameControlManager:StopGameCallBack()
	
	local stopFunc=function ()
		for i=1,GameDefine.SHZ_CommonVar.ANI_COL do	
			local Result=self:GetRowResult(i)	
			self.gameUIManager:HideAllSpeedRunEffect()
			self:SetStop(i,Result,self.stopIntervalTime>0.1)
			if self.stopIntervalTime>0.1 then
				yield_return(WaitForSeconds(self.stopIntervalTime)) 
			end
		end
		if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
			GameController.GetInstance():ResetFreeGameRemainCount()
			self.gameData.FreeGamePanel:SetFreeGameRemainCount(true,self.gameData.FreeGameRemainCount)
		end
		if not self.gameData.IsAllStop then
			yield_return(WaitForSeconds(0.5))
		end
		self.gameUIManager:HideAllSpeedRunEffect()
		self:ResetItemInsList()
		self.IsStop=true
		self.IsChangeBet=true
		local isWildChangeState=false--self:SetFreeGameIconChangeEffect()
		if isWildChangeState==false then
			yield_return(WaitForSeconds(0.2))
			self.gameData.StartControlBtn:SetStopRunBtnStation()
			self:RunEndCallBackEvent()
		else
			print("wildchange状态等待")
		end
		
	end
	
	StartCoroutine(stopFunc)
end

function GameControlManager:ResetItemInsList()
	for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
		local tempRow= self.gameData.RowItemList[i]
		self.gameData.IconItemInstanceList[i]=tempRow:GetIconItemList()	
	end
end

function GameControlManager:ResetIconItemInstanceList(num)
	for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
		if i==num then
			local tempRow= self.gameData.RowItemList[i]
			self.gameData.IconItemInstanceList[i]=tempRow:GetIconItemList()	
			return
		end
		
	end
end



function GameControlManager:SingleRunEndCallBack(index)
	if self.currentAutoRunIndex then
		if self.currentAutoRunIndex==index then
			self.gameData.RowItemList[index].IsReciveCallBack=false
			self:ResetItemInsList()
			self:SetStateCallBack()
		end
	end
end

--设置单列自动滚动
function GameControlManager:SingleRun(index,speed,Result)
	self.currentAutoRunIndex=index
	self.gameData.GameIconManager:IsShowAllocateItemAnim(index,false,self.gameData.IconItemInstanceList)
	self.gameData.RowItemList[index].IsReciveCallBack=true
	self:SetRun(index,speed)
	local DelayStopRunFunc=function ()
		self:SetStop(index,Result)
	end
	CommonHelp.SetTimeBackCall(0.5,DelayStopRunFunc)
end


function GameControlManager:SetStateCallBack()
	if self.FreeGameRun then
		print("刚进入免费游戏的初始化滚动结束回调")
		self.FreeGameRun=false
		self:InitFreeGameEnterColunmEffect(self.currentAutoRunIndex)
	elseif self.IsFourth then
		self.IsFourth=false
		print("第四列自动滚动后回调")
		self:FourthColmunAutoRunCallBack()
	end
end


function GameControlManager:FourthColmunAutoRunCallBack()
	local ContinueStopProcessFunc=function ()
		self:RunEndCallBackEvent()
	end
	StartCoroutine(ContinueStopProcessFunc)
end




function GameControlManager:StartAllRun(speed)
	--local WaitStartRunFunc=function ()
		for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
			self:SetRun(i,speed)
			--yield_return(WaitForSeconds(0.5))
		end	
	--end
	
	--StartCoroutine(WaitStartRunFunc)
		
end


function GameControlManager:SetSingleRunSpeed(index,speed)
	local tempRow= self.gameData.RowItemList[index]
	tempRow.Speed=speed	
end


function GameControlManager:SetRun(num,speed)
	local tempRow= self.gameData.RowItemList[num]
	tempRow:SetIconItemList(self.gameData.GameIconManager:GetGameIconInstanceRowList(num))	
	local isHasRun=tempRow:GetIsHasRun()
	if isHasRun==false then
		print("当前列不能滚动")
		return
	end
	tempRow.Run=true
	tempRow.Stop=false
	tempRow.Speed=speed				
	return

end



--设置某一列能否滚动
function GameControlManager:SetSingleColmunmRunState(index,isRun)
	local tempRow= self.gameData.RowItemList[index]
	tempRow:SetHasRun(isRun)
end

function GameControlManager:ResetAllColmunRunState(isRun)
	for i=1,#self.gameData.RowItemList do
		self:SetSingleColmunmRunState(i,isRun)
	end
end


--设置某一列是否显示
function GameControlManager:SetAllocateColmunShowState(index,isdisplay)
	local tempRow= self.gameData.RowItemList[index]
	tempRow:IsShowColmunPanel(isdisplay)
end

--设置某些列是否显示
function GameControlManager:SetColmunShowState(colmunState)
	if colmunState then
		local isShow=false
		for i=1,#colmunState do
			if colmunState[i] then
				isShow=true
			else
				isShow=false
			end
			self.gameData.RowItemList[i]:IsShowColmunPanel(isShow)
		end
	end
end




function GameControlManager:SetStop(num,ResultList,IsQuickStop)
	for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
		if i==num then
			local tempRow= self.gameData.RowItemList[i]
			tempRow.Result=ResultList	
			if IsQuickStop then
				tempRow.Stop=true
			else	
				tempRow:QuickStop()
			end
			return
		end
		
	end
end


function GameControlManager:GetRowResult(num)
	for i=1,#self.gameData.GameResult do
		if i==num then
			return  self.gameData.GameResult[i]
		end
	end
	return false
end

function GameControlManager:GetRowItemList(num)
	for i=1,#self.gameData.RowItemList do
		if i==num then
			return  self.gameData.RowItemList[i]
		end
	end
	return false
end


function GameControlManager:SetBeforeSubStation()
	print("之前的子状态为：",self.gameData.bySubGameStation)
	print("之前的主状态为：",self.gameData.GameStation)
	self.beforeSubStation=self.gameData.bySubGameStation
	self.beforeStation=self.gameData.GameStation
end



function GameControlManager:RunEndCallBackEvent()
	self:SetBeforeSubStation()

	self:IsEnableStartBtn()

	self.gameData.IsEnterStart=false
	
	self:IsEnableBetState()
	
	--self:SetPlayerWinScore()

	self:SetWinScoreResult(1.5)
	
	if self.gameData.WinLineCount>0 then
		self:SetWinStationProcess()	
	else
		self.gameData.PlayerScorePanel:SetWinTipsPanel(false)
		self:AnimCallBack()
	end
	
	
end




function GameControlManager:IsEnableStartBtn()
	if self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame and self.gameData.GameStation~=GameDefine.GameStation.FreeGame  then
		self.gameData.StartControlBtn:EnableStartBtn()
	end
end



function GameControlManager:SetWinScoreResult(times)
	if self.gameData.GameTotalWinScore>0 then
		if self.gameData.ResultBetMultiple<self.minLevel then
			times = self:PlayWinAudio(true)
		end
		self.gameData.PlayerScorePanel:SetWinTipsPanel(true)
		if self.beforeSubStation==GameDefine.SubGameState.FreeGame then
			-- if self.gameData.ResultBetMultiple<self.minLevel then
				self.gameUIManager:SetFreeGameScore(self.gameData.GameTotalWinScore,times)
				self:SetPlayerWinScore(times)
				-- CommonHelp.PlayAudio(GameAudioPath.GetScore)	
				self.gameData.PlayerScorePanel:PlaySocreAnim()
			-- end
		else
			-- if self.gameData.ResultBetMultiple<self.minLevel then
				self.gameUIManager:SetPlayScore(self.gameData.GameTotalWinScore,times)
				self:SetPlayerWinScore(times)
				-- CommonHelp.PlayAudio(GameAudioPath.GetScore)	
				self.gameData.PlayerScorePanel:PlaySocreAnim()
			-- end
		end
	end
end

function GameControlManager:PlayWinAudio(isdisplay)
	local ResultBetMultiple = {0,2,6,8,10}
	local time = {0.45,0.55,1,1.45}
	for i = 1, 10, 1 do
		if self.gameData.ResultBetMultiple>=ResultBetMultiple[i] and self.gameData.ResultBetMultiple<ResultBetMultiple[i+1] then
			if isdisplay then
				CommonHelp.PlayAudio(GameAudioPath.Win[i])
			else
				CommonHelp.StopAudio(GameAudioPath.Win[i])
			end
			return time[i]
		end
	end
end

function GameControlManager:SetWinScoreResult1(showTime)
	if self.gameData.GameTotalWinScore>0 then
		if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
			self.gameUIManager:SetFreeGameScore(self.gameData.GameTotalWinScore,showTime)
		else
			self.gameUIManager:SetPlayScore(self.gameData.GameTotalWinScore,showTime)
		end
		self:SetPlayerWinScore(0.3)
	end
	
end





function GameControlManager:SetPlayerWinScore(showTime)
	print("设置玩家玩家赢钱：",self.gameData.PlayerMoney)
	--self.gameUIManager:SetPlayMoney(self.gameData.PlayerMoney)
	self.gameUIManager:SetPlayerWinMoneyByChange(self.gameData.PlayerMoney,showTime)
end


function GameControlManager:SetWinStationProcess()
	self:PlayAllLineAnim(true)
	self:IsPlayWinLineAnim(1)
	if not self.gameData.IsAuto then
		self:AnimCallBack()
	end
end




function GameControlManager:IsEnableBetState()
	if not self.gameData.IsAuto and self.gameData.GameStation~=GameDefine.GameStation.FreeGame  then
		self.gameData.GameBetSet:IsEnableBetBtn(true)
	end
	
end


function GameControlManager:IsPlayWinLineAnim(WiatTimes)
	local PlayWinLineAnimThead=function ()
		if self.gameData.WinLineCount>0 then
			self.gameData.GameIconManager:IsShowIconMask(true)
			self.IsPlayAudio = {}
			yield_return(WaitForSeconds(1))
			self.gameData.LineManager:HideAllLine()
			self:PlayAllLineAnim(false)
			while self.IsStop do
				for i=1,#self.gameData.WinLinDataList do

					if self.gameData.IsAuto then
						self:AnimCallBack()
						self.IsStop = false
					end
					if self.IsStop==false then
						return
					end
					local winLineData=self.gameData.WinLinDataList[i]
					if winLineData==nil then
						-- pt(winLineData)
					end
					if winLineData then
						local gameIconData= self.gameData.GameIconManager:GetGameIconInstanceByLineData(winLineData,false)
						yield_return(WaitForSeconds(0.5))
						self.gameData.GameIconManager:PlayAssignAnim(gameIconData,winLineData,self.IsChangeBet)
						yield_return(WaitForSeconds(WiatTimes))
						self.gameUIManager:HideAllBetWin()
						self.gameData.GameIconManager:StopPlayAssignAnim(gameIconData)
						self.gameData.LineManager:HideAllLine()
					end
				end
			end
		end
	end
	StartCoroutine(PlayWinLineAnimThead)
	--yield_return(WaitForSeconds(WiatTimes))
end


function GameControlManager:PlayAllLineAnim(isPlay)
	if self.gameData.WinLineCount>0 then
		for i=1,#self.gameData.WinLinDataList do
			local winLineData=self.gameData.WinLinDataList[i]
			local gameIconInstance= self.gameData.GameIconManager:GetGameIconInstanceByLineData(winLineData)
			if isPlay then
				self.gameData.GameIconManager:PlayAssignAnim(gameIconInstance,winLineData,self.IsChangeBet)
			else
				self.gameUIManager:HideAllBetWin()
				self.gameData.GameIconManager:StopPlayAssignAnim(gameIconInstance)
			end
		end
	end
end



function GameControlManager:PlayScatterAnim(isPlay)
	self.ScatterResult={}
	if self.gameData.WinLineCount>0 then
		for i=1,#self.gameData.WinLinDataList do
			local winLineData=self.gameData.WinLinDataList[i]
			if winLineData.nGameItemID==11 then
				table.insert(self.ScatterResult,winLineData)
				local gameIconInstance= self.gameData.GameIconManager:GetGameIconInstanceByLineData(winLineData)
				if isPlay then
					self.gameData.GameIconManager:PlayAssignAnim(gameIconInstance,winLineData.nPrizeLineID)
				else	
					self.gameData.GameIconManager:StopAnim(gameIconInstance)	
				end
			end
			
		end
	end
end



function GameControlManager:SetAllWinLineProcess(winLineList,waitTime)
	local WinLineTotalMultiple=0
	for i=1,#winLineList do
		WinLineTotalMultiple=WinLineTotalMultiple+winLineList[i].nWinLineBase
		if winLineList[i].nPrizeLineID<50 then
			self.gameData.LineManager:ShowAllocateLine(winLineList[i].nPrizeLineID,true)
		end
		
	end
	self.gameData.PlayerScorePanel:SetAllShowTips(self.gameData.WinLineCount,WinLineTotalMultiple)
	yield_return(WaitForSeconds(waitTime))
	self.gameData.LineManager:HideAllLine()
	self.gameData.GameIconManager:StopAllIconAnimation()
end



function GameControlManager:AnimCallBack()

	local IsBigWin=false
	local IsJackpot = false
	IsBigWin=self:IsDisplayBigWin()				--是否显示bigwin
	-- IsJackpot=self:IsDisplayJackPot()
	if IsBigWin or IsJackpot then
		print("正在bigwin状态中")
	else
		if self.gameData.WinLineCount>0 then
			yield_return(WaitForSeconds(1.8))
		end
		self:IsContinueStateProcess()
	end
end




function GameControlManager:IsContinueStateProcess()
	
	self:IsDisplayFreeGameEnd()
	if not self.gameData.IsFreeGameing then
		self:IsDisplayEnterFreeGame()		--是否触发免费游戏
	end
	self:AutoGame()
end




function GameControlManager:AutoGame()
	
	if self.gameData.GameStation==GameDefine.GameStation.Bounus or self.gameData.GameStation==GameDefine.GameStation.JackpotGame 
		or self.gameData.GameStation==GameDefine.GameStation.TriggerFreeGame or self.gameData.GameStation==GameDefine.GameStation.TreasureBox  
		or self.gameData.GameStation==GameDefine.GameStation.BigWin	then
		return
	end
	
	if self.gameData.IsAuto then	
		if self.gameData.PlayerMoney<self.gameData.BetGroups[self.gameData.CurrentIndex]*self.gameData.LineCount  and self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame then
			if self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame  then
				-- UIManager:GetInstance():ShowNoteMessage("当前下注金额不足,请充值",10)
				UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CurrentBetMoneyInsufficient"),10)
				self.gameData.IsAuto=false
				self.gameData.StartControlBtn:SetStopRunBtnStation()
				self:IsEnableBetState()
				return 
			end
			
		end
		
		local isStateEnd=self.gameData.GameStateManager:GetState()
		if not isStateEnd and self.gameData.IsStone==false and self.gameData.IsLightning==false then
			local StartFun = function()
				if self.gameData.WinLineCount==0 then
					yield_return(WaitForSeconds(1))
				end
				self.gameData.AutoControlBtn:AutoStartGame()
			end
			StartCoroutine(StartFun)
		else
			print("当前是State动画状态，等待动画结束回调")
		end
	else		
		self.gameData.StartControlBtn:SetStopRunBtnStation()
	end
	
end




function GameControlManager:GetAutoStateConfig()
	if self.gameData.IsAuto then
		self.gameData.BeforeIsAuto=true
	else
		self.gameData.BeforeIsAuto=false
	end
end





----------------------------------------------状态控制----------------------------------------------

function GameControlManager:StateCallBack()
	print("StateCallBack回调",self.gameData.bySubGameStation)
	if self.gameData.bySubGameStation==GameDefine.SubGameState.BigWin then
		self.gameData.GameStateManager:SetSubGameStation(self.beforeSubStation)
		self.gameData.GameStateManager:SetGameNextStation(self.beforeStation)
		self:IsContinueStateProcess()
		return
	elseif self.gameData.bySubGameStation==GameDefine.SubGameState.TreasureBox then
		self.gameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.Normal)
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.Normal)
	elseif self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
		self.gameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.FreeGame)
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.FreeGame)
		self:GetAutoStateConfig()
		-- self.gameData.IsAuto=true
		self.gameData.IsAuto=false
		self.gameData.StartControlBtn:SetStopRunBtnStation()	--重新设置按钮状态
		self.gameUIManager:SetPlayScore(0)
		self.gameUIManager:SetFreeGameScore(self.gameData.FreeGameTotalScore)
	elseif self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGameResult then	
		self.gameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.Normal)
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.Normal)
		self.gameData.GameIconManager:StopAllIconAnimation()
		self.gameData.StartControlBtn:SetStopBtnIsEnabled(true)
		self.gameUIManager:ResetFreeGameAddScore()		--清除免费游戏累加分
		self.gameUIManager:SetPlayScore(0)
		self.gameData.PlayerScorePanel:ShowGoodLuck()
		self.gameData.FreeGameTotalScore=0
		self.gameData.GameIconManager:IsShowIconMask(false)
		--self.gameUIManager:SetFreeGameCountLabel(false,0)
		if not self.gameData.BeforeIsAuto then
			self.gameData.IsAuto=false
		end
		self:IsEnableBetState()
		self:IsEnableStartBtn()
		CommonHelp.PlayBGAudio(GameAudioPath.BGM1)
	end
	
	self:AutoGame()

	if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
		self.gameData.StartControlBtn:SetStartFreePanelDisplay(true)	--重新设置按钮状态
		self.gameData.StartControlBtn:EnableStartBtn()
	end
end







--是否显示bigwin
function GameControlManager:IsDisplayBigWin()
	
	local isEnableBigWin=false
	local index=0
	local delayTimes=0
	if self.gameData.ResultBetMultiple>=self.midLevel then
		isEnableBigWin=true
		index=2
		delayTimes=4
	elseif self.gameData.ResultBetMultiple>=self.minLevel and self.gameData.ResultBetMultiple<self.midLevel then
		isEnableBigWin=true
		index=1
		delayTimes=3.5
	end

	if isEnableBigWin and self.gameData.IsJackpot==false then
		self.gameData.GameStateManager:EnableState()
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.BigWin)
		self:SetWinScoreResult(delayTimes)
		self.gameUIManager:SetWinScoreEffect(index,self.gameData.GameTotalWinScore,delayTimes)
	else
		isEnableBigWin=false
	end
	return isEnableBigWin,delayTimes
end


function GameControlManager:IsDisplayJackPot()
	if self.gameData.IsJackpot then
		self.gameData.IsJackpot=false
		self.gameData.GameStateManager:EnableState()
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.JackPot)
		self.gameUIManager:SetJackpotScore(self.gameData.JackpotScore)
		return true
	end
	return false
end


function GameControlManager:IsDisplayEnterFreeGame()
	if self.gameData.GameStation==GameDefine.GameStation.FreeGame then
		self.gameData.StartControlBtn:SetStartFreePanelDisplay(true)
		self.gameData.StartControlBtn:DisableStartBtn()
		self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.FreeGame)
		self.gameData.GameStateManager:EnableState()
		local EnterFreeGameFunc=function ()
				-- yield_return(WaitForSeconds(0.5))
				
				-- self:PlayScatterAnim(true)
				-- yield_return(WaitForSeconds(1.5))
				-- self:PlayScatterAnim(false)
				yield_return(WaitForSeconds(0.5))
				self:SetEnterFreeGameState()
		end
			
		StartCoroutine(EnterFreeGameFunc)
		
	end
end




--免费游戏结算
function GameControlManager:IsDisplayFreeGameEnd()
	if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
		if self.gameData.FreeGameRemainCount==0 then
			self.gameData.GameStateManager:EnableState()
			self.gameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.FreeGameResult)
			self.gameData.FreeGamePanel:SetFreeGameEnd(self.gameData.FreeGameTotalScore)	
		end
	end
end






function GameControlManager:SetEnterFreeGameState()
	-- self.gameData.StartControlBtn:SetStopBtnIsEnabled(false)
	self.gameData.PlayerScorePanel:SetTipsPanel(1)
	self:SetFreeGamePanel()
end



function GameControlManager:SetFreeGamePanel()
	local isLoaded=self.gameData.LoadModuleManager.ModuleList[GameDefine.ModuleName.Panel_FreeGame].IsLoad
	if isLoaded==false then
		self.gameData.LoadModuleManager:LoadAllocateModule(GameDefine.ModuleName.Panel_FreeGame)
	else
		print("Panel_FreeGame已经加载")
		self.gameData.FreeGamePanel:SetEnterFreeGame()
	end
end




function GameControlManager:SetSmallWinPanel(score)
	local isLoaded=self.gameData.LoadModuleManager.ModuleList[GameDefine.ModuleName.Panel_SmallWin].IsLoad
	if isLoaded==false then
		self.gameData.LoadModuleManager:LoadAllocateModule(GameDefine.ModuleName.Panel_SmallWin)
	else
		print("Panel_SmallWin已经加载")
		self.gameData.SmallWinPanel:SetSmallWinData(score,3)
	end
end








return GameControlManager