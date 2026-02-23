StartControlBtn=BaseClass()


function StartControlBtn:__init(gameObj)
	self.gameObject=gameObj
	
	self:InitData()
	self:InitView()
	self:AddBtnEventListener()
end

--初始化数据
function StartControlBtn:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  --游戏数据
	self.StartOnclicIntervalTime=0.5					--点击开始按钮点击时间间隔
	self.currentTimer=nil
end


--初始化界面
function StartControlBtn:InitView()
	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
end

--初始化UI数据
function StartControlBtn:InitUIViewData()
	self.FreeGameBtn=nil                                 --免费游戏计数面板
	self.FreeGameLabel=nil								--免费游戏计数
	self.StartBtn=nil									--开始按钮
	self.StartBtnIsEnable=nil							--开始按钮开关
	self.StopBtn=nil									--停止按钮
	self.StopBtnIsEnable=nil							--停止按钮开关

	self.StartBtn_Free=nil									--开始按钮
	self.StartBtnIsEnable_Free=nil							--开始按钮开关
	self.StopBtn_One=nil									--停止按钮
	self.StopBtnIsEnable_One=nil							--停止按钮开关
	
end

function StartControlBtn:FindView()
	local tf=self.gameObject.transform
	self.AutoEffect=tf:Find("Bottom/Panel_Tips/Effect_changanzidong").gameObject
	self.AutoEffectEnd=tf:Find("Bottom/Panel_Tips/Effect_Botton_fang").gameObject
	
	self.StartBtn=tf:Find("Bottom/Btn_Start").gameObject   
	self.StartBtnIsEnable=self.StartBtn:GetComponent(typeof(UIButton)) 
	self.StopBtn=tf:Find("Bottom/Btn_Stop").gameObject   
	self.StopBtnIsEnable=self.StopBtn:GetComponent(typeof(UIButton)) 
	
	self.StartBtn_Free=tf:Find("Bottom/Btn_Start_Free").gameObject   
	self.StartBtnIsEnable_Free=self.StartBtn_Free:GetComponent(typeof(UIButton)) 
	self.StopBtn_One=tf:Find("Bottom/Btn_Stop_Quick").gameObject   
	self.StopBtnIsEnable_One=self.StopBtn_One:GetComponent(typeof(UIButton)) 
	
	self.StopBtnSprite=tf:Find("Bottom/Btn_Stop/STOP"):GetComponent(typeof(UISprite)) 
	self.RemainCountLabel=tf:Find("Bottom/Btn_Stop/Label"):GetComponent(typeof(UILabel)) 
	self.RemainCountSprite=tf:Find("Bottom/Btn_Stop/Sprite"):GetComponent(typeof(UISprite)) 
	self.RemainCountTween=tf:Find("Bottom/Btn_Stop/Label"):GetComponent(typeof(TweenScale)) 
	self.StartAnim=tf:Find("Bottom/Btn_Start"):GetComponent(typeof(Animation)) 

	self.m_Btn_Take=tf:Find("Bottom/Btn_Take").gameObject   
	
end

--初始化UI界面
function StartControlBtn:InitUIView()
	CommonHelp.SetActive(self.StartBtn,true)
	CommonHelp.SetActive(self.StopBtn,false)
	self:IsShowAutoEffect(false)
	self:IsShowAutoEffectEnd(false)
end




function StartControlBtn:SetRemainCountTeween(times)
	self.RemainCountTween.duration=times
	self.RemainCountTween.enabled = true
	self.RemainCountTween:ResetToBeginning()
	self.RemainCountTween:PlayForward()
end



function StartControlBtn:SetAutoCountLabel(count)
	self.RemainCountLabel.text=count
	if self.gameData.RemainAutoCount<1000 then
		self:SetRemainCountTeween(0.6)
	end
	
end

function StartControlBtn:AddBtnEventListener()
	UIEventListener.Get(self.StartBtn).onPress=function (go,press) self:StartBtnOnclick(go,press) end
	UIEventListener.Get(self.StartBtn_Free).onPress=function (go,press) self:StartFreeBtnOnclick(go,press) end
	UIEventListener.Get(self.StopBtn).onClick=function () self:StopBtnOnclick() end
	UIEventListener.Get(self.StopBtn_One).onClick=function () self:StopBtnOnclick() end
	UIEventListener.Get(self.m_Btn_Take).onClick=function () self:OnClickTake() end
end

function StartControlBtn:StartFreeBtnOnclick(go,press)
	
	if self.gameData.IsEnterStart then
		print("已经开始，不能再次开始")
		return 
	end
	if   self.gameData.GameStation==GameDefine.GameStation.JackpotGame 
	or self.gameData.bySubGameStation==GameDefine.SubGameState.BigWin 
	or self.gameData.GameStation==GameDefine.GameStation.TriggerFreeGame  or self.gameData.GameStation==GameDefine.GameStation.TreasureBox	then
		
		print("状态设置中不能点击开始",self.gameData.GameStation)
		return 
	end
	
	if self.gameData.PlayerMoney<self.gameData.BetGroups[self.gameData.CurrentIndex]*self.gameData.LineCount then
		if self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame  then
			-- UIManager:GetInstance():ShowNoteMessage("当前下注金额不足,请充值",10)
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CurrentBetMoneyInsufficient"),3)
			return 
		end
	end
	
	
	-- --长按开始显示自动
	-- if press == true then
	-- 	--CommonHelp.PlayAudio(GameAudioPath.StartRun)
	-- 	self.currentTimer=CommonHelp.SetTimeBackCall(1,self.StartAutoEffect,self)
	-- 	self.startTimer=CommonHelp.SetTimeBackCall(2.2,self.StartAutoGame,self)
	-- end
	
	if press==false then
		self:DisableStartBtn()
		--self.gameData.StartBtnOnclickTimer=CommonHelp.SetTimeBackCall(0.5,self.StartBtnOnclickStateCallBack,self)
		--开始游戏
		self.gameData.GameControlManager:StartGame()
		self.gameData.IsAuto = true
  end
	
end

--开始按钮点击
function StartControlBtn:StartBtnOnclick(go,press)

	if self.gameData.PlayerScorePanel:GetShowScoreState() then
		self.gameData.PlayerScorePanel:ResetScore()
		self.gameData.PlayerInfoPanel:ResetScore()
		self.gameData.BigWinPanel:ResetScore()
		self:DisableStartBtn()
		if self.gameData.bySubGameStation~=GameDefine.SubGameState.BigWin then
			self.gameData.GameControlManager:PlayWinAudio(false)
			CommonHelp.SetTimeBackCall(0.3,function ()
				self.gameData.GameControlManager:StartGame()
			end)
		end
		return
	end

	if self.gameData.IsEnterStart then
		print("已经开始，不能再次开始")
		return
	end

	--self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame or self.gameData.GameStation==GameDefine.GameStation.FreeGame
	if  self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame or 
		self.gameData.GameStation==GameDefine.GameStation.FreeGame or 
		self.gameData.GameStation==GameDefine.GameStation.JackpotGame 
		 or self.gameData.bySubGameStation==GameDefine.SubGameState.BigWin 
		or self.gameData.GameStation==GameDefine.GameStation.TriggerFreeGame  or self.gameData.GameStation==GameDefine.GameStation.TreasureBox	then

		print("状态设置中不能点击开始",self.gameData.GameStation)
		return 
	end

	if self.gameData.PlayerMoney<self.gameData.BetGroups[self.gameData.CurrentIndex]*self.gameData.LineCount then
		-- UIManager:GetInstance():ShowNoteMessage("当前下注金额不足,请充值",10)
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CurrentBetMoneyInsufficient"),10)
		return
	end

	--长按开始显示自动
	if press == true then
		--CommonHelp.PlayAudio(GameAudioPath.StartRun)
		-- self.currentTimer=CommonHelp.SetTimeBackCall(0.5,self.StartAutoEffect,self)
		self.startTimer=CommonHelp.SetTimeBackCall(1.5,self.StartAutoGame,self)
	end

	if press==false then
		if self.currentTimer then
			self.currentTimer:RemoveTimer()
			self.currentTimer=nil
		end

		if self.startTimer then
			if self.startTimer.time<0.5 then
				self.startTimer:RemoveTimer()
				self:DisableStartBtn()
				--开始游戏
				self.gameData.GameControlManager:StartGame()
			end
			self.startTimer=nil
		end
  end
end


function StartControlBtn:StartBtnOnclickStateCallBack()
	if self.gameData.IsEnterStart then
		
	else
		self:EnableStartBtn()	
	end
end




function StartControlBtn:StartAutoGame()

	if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame  or self.gameData.GameStation==GameDefine.GameStation.JackpotGame 
		or self.gameData.GameStation==GameDefine.GameStation.FreeGame or self.gameData.bySubGameStation==GameDefine.SubGameState.BigWin 
		or self.gameData.GameStation==GameDefine.GameStation.TriggerFreeGame  or self.gameData.GameStation==GameDefine.GameStation.TreasureBox	then
		
		print("状态设置中不能自动开始",self.gameData.GameStation)
		return 
	end
	self.gameData.AutoControlBtn:MaxAutoBtnOnclick()
end


function StartControlBtn:SetCallBackStartEffectDelay()
	if self.gameData.GameControlPanel.currentTimer then
		self.gameData.GameControlPanel.currentTimer:RemoveTimer()
		self.gameData.GameControlPanel.currentTimer=nil
	end
end


function StartControlBtn:StartBtnOnclickInterval()
	self:SetStartBtnIsEnabled(true)
end


function StartControlBtn:SetStartBtnIsEnabled(isOnclick)
	self.StartBtnIsEnable.isEnabled=isOnclick
	self.StartBtnIsEnable_Free.isEnabled = isOnclick
end

function StartControlBtn:SetStopBtnIsEnabled(isOnclick)
	self.StopBtnIsEnable.isEnabled=isOnclick
	self.StopBtnIsEnable_One.isEnabled = isOnclick
end


function StartControlBtn:StopBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	
	
	if self.gameData.IsStartEffect then
		return
	end
	
	
	if self.gameData.IsAuto and self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame  then
		self.gameData.IsAuto=false
		self.gameData.GameControlManager:IsEnableBetState()
		self:SetStopRunBtnStation()		--需要注意流程
	end
	
	
	if self.gameData.IsLightning or self.gameData.IsStone then
		print("闪电或滚石状态无法快速停止")
		return
	end
	
	if self.gameData.GameStateManager:GetState() then
		print("当前是State动画状态")
		return 
	end
	

	if self.gameData.IsEnterStop==false and self.gameData.IsEnterStart then	
		print("点击开始执行停止游戏~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
		self.gameData.GameControlManager:StopGame(true)
		self.gameData.IsAllStop = true
	else
		--滚动时的快速停止
		self.gameData.IsAllStop = true	
		self.gameData.GameControlManager.IsQuickStop=true
		self.gameData.GameControlManager.stopIntervalTime=0.01
	end
	self:SetStopBtnIsEnabled(false)
end

function StartControlBtn:OnClickTake()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self.gameData.FreeGamePanel:HandleTakeOnclick()
end

function StartControlBtn:IsShowAutoEffect(isDisplay)
	CommonHelp.SetActive(self.AutoEffect,isDisplay)
end


function StartControlBtn:IsShowAutoEffectEnd(isDisplay)
	CommonHelp.SetActive(self.AutoEffectEnd,isDisplay)
end


function StartControlBtn:StartCallBackEffect()
	
end

function StartControlBtn:SetTakeBtnlDisplay(isFirst)
	CommonHelp.SetActive(self.m_Btn_Take, isFirst)
end

function StartControlBtn:SetStartFreePanelDisplay(isFirst)
	CommonHelp.SetActive(self.StartBtn,not isFirst)
	CommonHelp.SetActive(self.StartBtn_Free,isFirst)
end

function StartControlBtn:SetStartPanelDisplay(isDisplay)
	CommonHelp.SetActive(self.StartBtn,isDisplay)
	if not isDisplay then
		CommonHelp.SetActive(self.StartBtn_Free,isDisplay)
	end
end


function StartControlBtn:SetStopPanelDisplay(isDisplay)
	if isDisplay then
		if self.gameData.IsAuto and self.gameData.bySubGameStation ~= GameDefine.SubGameState.FreeGame then
			CommonHelp.SetActive(self.StopBtn,isDisplay)
		else
			CommonHelp.SetActive(self.StopBtn_One,isDisplay)
		end
	else
		CommonHelp.SetActive(self.StopBtn,isDisplay)
		CommonHelp.SetActive(self.StopBtn_One,isDisplay)
	end
end

function StartControlBtn:SetMaxLevelStateDisplay(isDisplay)
	CommonHelp.SetActive(self.RemainCountLabel.gameObject,(not isDisplay))
	CommonHelp.SetActive(self.RemainCountSprite.gameObject,isDisplay)
end

function StartControlBtn:SetFreeGameLabelDisplay(isDisplay)
	CommonHelp.SetActive(self.FreeGameBtn,isDisplay)
end

function StartControlBtn:SetFreeGameCountLabel(num)
	self.FreeGameLabel.text=num
end





function StartControlBtn:SetStopRunBtnStation()
	if self.gameData.IsAuto  and self.gameData.bySubGameStation ~= GameDefine.SubGameState.FreeGame then
		self:SetStopPanelDisplay(true)
		self:SetStartPanelDisplay(false)
	else
		self:SetStopPanelDisplay(false)
		self:SetStartPanelDisplay(true)
		
	end
end


function StartControlBtn:DisableStartBtn()
	self:SetStartBtnIsEnabled(false)
end


function StartControlBtn:EnableStartBtn()
	--print("启用开始按钮~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	self:SetStartBtnIsEnabled(true)
end



function StartControlBtn:SetStartAndStopBtnState(isStart)
	self:SetStartPanelDisplay(isStart)
	self:SetStopPanelDisplay(not isStart)
end



function StartControlBtn:StartAutoEffect()
	-- CommonHelp.PlayAudio(GameAudioPath.ZD1)
	self:IsShowAutoEffectEnd(false)
	self:IsShowAutoEffect(false)
	self:IsShowAutoEffect(true)
end





return StartControlBtn