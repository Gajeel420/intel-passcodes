GameUIManager=BaseClass()


function GameUIManager:__init(obj)
	self.gameObject = obj
	self:Init(obj)

end

local instance={}
function GameUIManager:Init (gameObj)
	self.mTrans=gameObj.transform
	self.gameObject=gameObj
	instance=self
	self:InitData()
	self:InitView(gameObj)
end


function GameUIManager:InitData()
	self.GameData=nil 
end



function GameUIManager:InitView(gameObj)

	self:InitInstance(gameObj)
	self:InitUIVewData()
	self.Multiple={4,8,12,20,30,50,1000}
end


function GameUIManager:InitInstance(gameObj)
	
	self.GameData=GameData.New()
	self.GameData.GameStateManager=GameStateManager.New()
	self.GameData.GameIconManager=GameIconManager.New()
	self.GameData.GameIconPanel=GameIconPanel.New(gameObj)
	self.GameData.IconItem=IconItem
	self.GameData.ItemControl=ItemControl
	self.GameData.LoadModuleManager=LoadModuleManager.New()
	local OfflineObj=self.mTrans:Find("Panel_duanwang").gameObject 
	self.GameData.OfflineTipsPanel=OfflineTipsPanel.New(OfflineObj)
	
	self.SpeedRunEffectList={}
	for i=0,3 do
		local tempEffect=self.mTrans:Find("com/GunDong/SpeedRun/Effect_Sp_Rotato"..i).gameObject
		table.insert(self.SpeedRunEffectList,tempEffect)
	end

	self.OpenAnim=self.mTrans:Find("Panel_zhuanchang/Panel_TOP"):GetComponent(typeof(Animation))

	self.m_LineScoreList = {}
	for i = 1, 15 do
		if i < 10 then
			self.m_LineScoreList[i] = self.mTrans:Find("com/GunDong/Game_BG01/LineScore/0"..i):GetComponent(typeof(UILabel))
		else
			self.m_LineScoreList[i] = self.mTrans:Find("com/GunDong/Game_BG01/LineScore/"..i):GetComponent(typeof(UILabel))
		end
	end

	self.m_BgTexture_FreeGame =  self.mTrans:Find("com/GunDong/Game_FreeBG").gameObject
	self:ShowBgFreeGame(false)

	self.m_Go_AniFreeGame = self.mTrans:Find("Panel_zhuanchang/Ani_FreeGame").gameObject
	self:ShowmAniFreeGame(false)

	self.BetLabel = {}
	self.BetWin = {}
	self.BetWinLabel = {}
	local other = nil
	for i = 1, 7, 1 do
		other = self.mTrans:Find("com/GunDong/Bet/0"..i.."/bg/Label"):GetComponent(typeof(UILabel))
		table.insert(self.BetLabel,other)
		other = self.mTrans:Find("com/GunDong/Bet/0"..i.."/fg/Label"):GetComponent(typeof(UILabel))
		table.insert(self.BetWinLabel,other)
		other = self.mTrans:Find("com/GunDong/Bet/0"..i.."/fg").gameObject
		table.insert(self.BetWin,other)
	end
end


function GameUIManager:InitUIVewData()	
	self.GameData.GameIconManager:InitRandomAllGameIcon()
	self.GameData.LoadModuleManager:InitPrecedeLoadModule()
end

function GameUIManager:ShowBetLabel(value)
	if self.GameData.GameControlManager.IsChangeBet then
		self:HideAllBetWin()
		self.GameData.GameControlManager.IsChangeBet=false
	end
	for i = 1, #self.BetLabel, 1 do
		self.BetLabel[i].text = CommonHelp.SetNumberThousandsFormatScore(value*self.Multiple[i])
		self.BetWinLabel[i].text = CommonHelp.SetNumberThousandsFormatScore(value*self.Multiple[i])
	end
end

function GameUIManager:HideAllBetWin()
	for i = 1, #self.BetWin, 1 do
		self.BetWin[i]:SetActive(false)
	end
end

function GameUIManager:ShowBetWin(index)
	self.BetWin[index]:SetActive(true)
end

function GameUIManager:ShowmAniFreeGame(bol)
	if bol then
		if self.m_Go_AniFreeGame.activeSelf then
			self.m_Go_AniFreeGame:SetActive(false)
		end
		self.m_Go_AniFreeGame:SetActive(true)
	else
		self.m_Go_AniFreeGame:SetActive(false)
	end
end

function GameUIManager:IsPlayOpenAnim()
	self.OpenAnim:Play("Ani_zhuanchang")
end

function GameUIManager:IsPlayOpenAnim1()
	self.OpenAnim:Play("Ani_zhuanchang_1")
end

function GameUIManager:HideAllSpeedRunEffect()
	CommonHelp.IsShowPanel(0,self.SpeedRunEffectList,true,true,false)
end

function GameUIManager:ShowSpeedRunEffect(effectIndex,isdisplay)
	CommonHelp.IsShowPanel(effectIndex,self.SpeedRunEffectList,isdisplay,true,false)
end

function GameUIManager:SetUserInfo(userInfo)
	if self.GameData.PlayerInfoPanel then
		self.GameData.PlayerInfoPanel:SetUserInfo(userInfo)
	end
	
end


function GameUIManager:SetPlayMoney(values)
	if self.GameData.PlayerInfoPanel then
		self.GameData.PlayerInfoPanel:SetPlayMoney(values)  
	end
	
end


function GameUIManager:SetPlayerWinMoneyByChange(values,showTime)
	if self.GameData.PlayerInfoPanel then
		self.GameData.PlayerInfoPanel:SetGoldChange(values,showTime)
	end
	
end


function GameUIManager:SetPlayScore(values,times)
	if self.GameData.PlayerScorePanel then
		self.GameData.PlayerScorePanel:SetWinScore(values,false,times)
	end
end


function GameUIManager:SetFreeGameScore(values,times)
	if self.GameData.PlayerScorePanel then
		self.GameData.PlayerScorePanel:SetWinScore(values,true,times)
	end
end


function GameUIManager:ResetFreeGameAddScore()
	if self.GameData.PlayerScorePanel then
		self.GameData.PlayerScorePanel:ResetFreeGameAddScore()
	end
end


function GameUIManager:InitXiaZhuaConfig(mainData)
	if self.GameData.GameBetSet then
		self.GameData.GameBetSet:InitXiaZhuaConfig(mainData)
	end
	
end


function GameUIManager:SetXiaZhuValue(score)
	if self.GameData.GameBetSet then
		self.GameData.GameBetSet:SetXiaZhuValue(score)
	end
end





function GameUIManager:SetWinScoreEffect(index,score,times,audioIndex)
	local isLoaded=self.GameData.LoadModuleManager.ModuleList[GameDefine.ModuleName.Panel_BigWin].IsLoad
	if isLoaded==false then
		self.GameData.WinScoreEffectData={index,score,times,audioIndex}
	--	pt("赢分特效数据",self.GameData.WinScoreEffectData)
		self.GameData.LoadModuleManager:LoadAllocateModule(GameDefine.ModuleName.Panel_BigWin)
	else
		print("Panel_BigWin已经加载")
		self.GameData.BigWinPanel:SetWinScoreEffect(index,score,times,audioIndex)
	end
end


function GameUIManager:SetJackpotScore(score)
	local isLoaded=self.GameData.LoadModuleManager.ModuleList[GameDefine.ModuleName.Panel_Jackpot].IsLoad
	if isLoaded==false then
		self.GameData.LoadModuleManager:LoadAllocateModule(GameDefine.ModuleName.Panel_Jackpot)
	else
		print("Panel_Jackpot已经加载")
		self.GameData.JackpotPanel:SetJackpotData(score,7,8)
	end
end



function GameUIManager:SetDisplayTips(index,isWin,lineCount)
	if self.GameData.PlayerScorePanel then
		self.GameData.PlayerScorePanel:SetShowTips(index,isWin,lineCount)
	end
	
end

--设置免费游戏次数
function GameUIManager:SetFreeGameCountLabel(isDisplay,count)
	self.GameData.StartControlBtn:SetFreeGameLabelDisplay(isDisplay)
	self.GameData.StartControlBtn:SetFreeGameCountLabel(count)
end



--设置游戏界面状态显示的数据
function GameUIManager:SetGameViewShowData(index,isdisplay)
	self.GameData.GameIconManager:SetGameViewShowData(index,isdisplay)
end



----------------------------------------------------------------发送消息协议--------------------------------------------------------

function GameUIManager:SendGameStart()
	
	local sendData = {}
	sendData.nDeskStation = 0
	sendData.nBetPrizeLineCount = self.GameData.LineCount
	sendData.nBetMoneyIndex = self.GameData.CurrentIndex-1 
    sendData.byAutoPlay=0
    sendData.nClientReqSeq=self.GameData.ClientReqSeq

	local mainId=MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY  
	local msgID=0
	if self.GameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
		msgID=GAME_MSG_TYPE.CMD_FREE_PLAYER_PLAYGAME_WITH_SEQ
	else
		msgID=GAME_MSG_TYPE.CMD_PLAYER_PLAYGAME_WITH_SEQ
	end

    GameController:GetInstance():SendGameData(CMD_C_Player_PlayGame_With_Seq,sendData,mainId,msgID)
	
end

--获取游戏结果和其他消息
function GameUIManager:SendGameCurrentResult()
	local sendData = {}
	sendData.nClientReqSeq=self.GameData.ClientReqSeq
	GameController.GetInstance():SendGameData(CMD_C_REQ_CURRENT_MSG_SEQ,sendData,MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY,GAME_MSG_TYPE.CMD_REQ_CURRENT_GAME_RET_WITH_SEQ)
end

--进入转盘
function GameUIManager:SetGambleStart(values)
	GameController.GetInstance():SendGameData({},{},MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY,GAME_MSG_TYPE.CMD_C_INTO_GAMBLE)
end


--开始转盘
function GameUIManager:SetSelecetBetMutiple()
	local sendData={}
	sendData.nDeskStation=0
	sendData.byBetItemID=1
	sendData.bySelBaseIndex=1
	GameController.GetInstance():SendGameData(GameDefine.CMD_C_Into_Gamble,sendData,MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY,GAME_MSG_TYPE.CMD_C_PLAY_GAMBLE)
end




function GameUIManager:SendSelectDragon(index)
	local sendData = {}
	sendData.nDeskStation = 0
	sendData.nSelectItemIndex = index

	local mainId=MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY  
	local msgID=GAME_MSG_TYPE.CDM_C_ChoiceReward_Play

    GameController:GetInstance():SendGameData(CDM_C_ChoiceReward_Play,sendData,mainId,msgID)
end






------------------------------------------------------------------服务器结果解析----------------------------------------------------------


function GameUIManager:ASS_GM_GAME_STATION(state,buffer)
	--self.GameData.IsAuto=false
	print("状态为：",state)
	if state == GameDefine.GameStation.Normal-1 then
		local tmp = ASSGMGameStation.Decode(state,buffer)
		self.GameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.Normal)	
		self:SetPlayMoney(tmp.n64PlayerMoney)
		self.GameData.PlayerMoney=tmp.n64PlayerMoney	
	elseif state == GameDefine.GameStation.FreeGame-1 then
		local tmp = ASSGMGameStation.Decode( state,buffer)
		--pt(tmp)
		if GameController.GetInstance().EnterGameCount==1 then
			print("第一次进入免费游戏")
			self.GameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.FreeGame)
			self.GameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.FreeGame)	--走触发免费游戏结束流程
			self.GameData.FreeGameRemainCount=tmp.nTotalMiniGameCnt-tmp.nCurPlayMiniGameCnt
			self.GameData.FreeGameTotalCount = tmp.nTotalMiniGameCnt
			self.GameData.nCurPlayMiniGameCnt = tmp.nCurPlayMiniGameCnt
			print("状态设置-免费游戏剩余次数：",self.GameData.FreeGameRemainCount)
			self.GameData.FreeGameTotalScore=tmp.nTotalWinScore
			
			--设置免费游戏玩法类型todo	
			if tmp.byGameResult[100]~=255 then
				if tmp.byGameResult[100]==1 then
					print("玩法一")
					self.GameData.FreeGameState=GameDefine.FreeGameType.Special
				else
					print("玩法二")
					self.GameData.FreeGameState=GameDefine.FreeGameType.Normal
				end
			end
			
			--self.GameData.IsFreeGameReConnect=true		--开启免费游戏断线标志
			self.GameData.GameControlManager:IsDisplayEnterFreeGame()
		end
	elseif state== GameDefine.GameStation.TriggerFreeGame-1 then
		local tmp = ASSGMGameStation.Decode( state,buffer)
		self.GameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.TriggerFreeGame)
		self.GameData.GameControlManager:IsDisplaySelectDragon()
		
	elseif state== GameDefine.GameStation.TreasureBox-1 then
		self.GameData.GameStateManager:SetGameNextStation(GameDefine.GameStation.TreasureBox)
		self.GameData.GameStateManager:SetSubGameStation(GameDefine.SubGameState.TreasureBox)
		self.GameData.IsEnabledZhuanPanGameState=true
		self.GameData.GameControlManager:SetZhuanPanPanel()
	else
   		print("@@@ nil状态")
  end
end


function GameUIManager:SetStateViewData(state)
	local index=1
	if state==GameDefine.GameStation.Normal then
		index=GameDefine.GameBGState.NormalGame
	else
		index=GameDefine.GameBGState.FreeGame
	end
	
	self:SetGameViewShowData(index,true)
	
end





function GameUIManager:CMD_S_PLAYGAME_RESULT(tmp) 

	local strResult = ""
	if tmp.byRetErrorCod == 0 then
		-- strResult = "无错误"
		strResult = "Bet_Result_0"
	elseif tmp.byRetErrorCod == 1 then
		-- strResult = "下注筹码类型不对"
		strResult = "Bet_Result_1"
	elseif tmp.byRetErrorCod == 2 then
		-- strResult = "座位号不对"
		strResult = "Bet_Result_2"
	elseif tmp.byRetErrorCod == 3 then
		-- strResult = "对应座位上没有玩家"
		strResult = "Bet_Result_3"
	elseif tmp.byRetErrorCod == 4 then
		-- strResult = "钱不足"
		strResult = "Bet_Result_4"
	elseif tmp.byRetErrorCod == 5 then
		-- strResult = "下注限红"
		strResult = "Bet_Result_5"
	elseif tmp.byRetErrorCod == 6 then
		-- strResult = "未知错误"
		strResult = "Bet_Result_6"
	elseif tmp.byRetErrorCod == 7 then

		-- strResult = "状态不对"
		strResult = "Bet_Result_7"
	end

	if tmp.byRetErrorCod ~= 0 then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage(strResult))  
	else
		self:SetPlayMoney(self.GameData.PlayerMoney - tmp.nBetPrizeLineCount * tmp.nPlayerBet)
		self:SetXiaZhuValue(tmp.nPlayerBet)  
		LuaEvent:DispatchEvent("Game_Came",tmp.nBetPrizeLineCount * tmp.nPlayerBet)
	end
  
end




function GameUIManager:SetGameResult(tempData)


	self:GameResultCallBack()
	
end





function GameUIManager:GameResultCallBack(tmp)
	self:AutoStopGameRun()
	
end


function GameUIManager:AutoStopGameRun()
	self.GameData.GameControlManager:StartGameCallBack()
	if self.GameData.IsAllStop then
		self:GameResultCallBackStopRun()
	else
		self:IsAutoStop()
	end
end




function GameUIManager:IsAutoStop()
	if self.GameData.isQuick then
		self.GameData.CurrentStopRunTimmer=CommonHelp.SetTimeBackCall(0.1,self.GameResultCallBackStopRun,self)
	else
		self.GameData.CurrentStopRunTimmer=CommonHelp.SetTimeBackCall(0.3,self.GameResultCallBackStopRun,self)
	end
	
end



function GameUIManager:RemoveStopRunTimmer()
	if self.GameData.CurrentStopRunTimmer~=nil  then	
		self.GameData.CurrentStopRunTimmer:RemoveTimer()
		self.GameData.CurrentStopRunTimmer=nil
	end
end

function GameUIManager:SetStopRunTime()
	if self.GameData.CurrentStopRunTimmer~=nil then
		if self.GameData.CurrentStopRunTimmer.delayTime>0.1 then
			self.GameData.CurrentStopRunTimmer.delayTime=0
		end
	end
end

function GameUIManager:GameResultCallBackStopRun()
	self.GameData.IsEnterStop=true	--已经开始执行停止旋转游戏，不能再点击游戏结束按钮
	self.GameData.GameControlManager:StopGame()
end



function GameUIManager:ShowLineScoreValue(value)
	for i = 1, #self.m_LineScoreList do
		self.m_LineScoreList[i].text = value
	end
end

function GameUIManager:ShowBgFreeGame(bol)
	self.m_BgTexture_FreeGame:SetActive(bol)
end


function GameUIManager.GetInstance()
	return instance
end

return  GameUIManager