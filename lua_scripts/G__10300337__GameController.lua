GameController = GameController or BaseClass(GameLuaController)


function GameController:__init()

	self.gameID = 10300337
	self:AddGameScripts("/Common/TimerManager")
	self:AddGameScripts("/Common/GameDefine")
	self:AddGameScripts("/Common/CommonHelp")
	self:AddGameScripts("/Common/GameObjectPool")
	self:AddGameScripts("/Audio/AudioManager")
	self:AddGameScripts("/Msg/CMDSGuessSizeResult")
	self:AddGameScripts("/Msg/ASSGMGameStation")
	self:AddGameScripts("/Msg/CMDSJackPotFINISH")
	self:AddGameScripts("/Msg/CMDSJackPotPLAYRESULT")
	self:AddGameScripts("/Msg/CMDSOpenPrizeFullLineResult")
	self:AddGameScripts("/Msg/CMDOpenPrizeResultWithSeq")
	self:AddGameScripts("/Msg/CMDSSelectReward")
	self:AddGameScripts("/Model/GameData")
	
	
	self:AddGameScripts("/View//Item/GameIconManager")
	self:AddGameScripts("/View//Item/IconItemPanel/GameIconPanel")
	self:AddGameScripts("/View//Item/IconItem/IconItem")
	self:AddGameScripts("/View//Item/ItemControl/ItemControl")

	self:AddGameScripts("/View/GameUIManager")
	self:AddGameScripts("/View/LoadModuler/LoadModuleManager")
	self:AddGameScripts("/View/GameState/GameStateManager")
	self:AddGameScripts("/View/OffLineTips/OfflineTipsPanel")
end



function GameController:Init( obj )
	self.gameObj=obj
	GameLuaController.Init(self,obj)
	CommonHelp.ConfigLog(false)
	
	self:InitData()
	self:InitUIGUIManager()

	
end



function GameController:InitData()
	self.GUIManager=nil         
	self.DeleteList={}			
	self.EnterGameCount=0
end


function GameController:InitUIGUIManager()
	
	local gameUIObj = self.gameObj.transform:Find("UIStretch/Group/Game_UI").gameObject
	GameObjectPool.New()
	AudioManager.New(self.gameObj)		
	self.GUIManager = GameUIManager.New(gameUIObj)
	self.GameData=self.GUIManager.GameData
	self:InitUIData()
end



function GameController:InitUIData()
	
end


function GameController:SendLoadResourceComplete()
	LuaEvent:DispatchEvent(EventName.GameResLoadCompeleted)
	local gameObj=self.gameObj.transform:Find("UIStretch/Group/Game_UI/com/GunDong").gameObject
	HandselController.GetInstance():SetParent(gameObj)
end


function GameController:AddEvent()
  LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)
  LuaEvent:AddEventListener(EventName.GameSignalStrength,self.SetSignalStrength,self)
end

function GameController:RemoveEvent()
  LuaEvent:RemoveEventListener(EventName.GameNetDispatchData,self.HandleData,self)
  LuaEvent:RemoveEventListener(EventName.GameSignalStrength,self.SetSignalStrength,self)
end


function GameController:AddGameScripts(scriptPath)
	scriptPath="G/"..self.gameID..scriptPath
	table.insert(self.RequireList,scriptPath)
	return scriptPath
end


function GameController:InitScripts()
	for i=1,#self.RequireList do
		require(self.RequireList[i])
	end
end


function GameController:AddDeleteUpdateList(updateName)
	table.insert(self.DeleteList,updateName)
end


function GameController:DeleteUpdate()
	StopAllCoroutines()
	for i=1,#self.DeleteList do
		CommonHelp.RemoveUpdate(self.DeleteList[i])
	end
	
end




function GameController:EnterGame (desk)
	self.desk=desk
	--local str="服务器ID为："..desk.m_usGameID
	--UIManager:GetInstance():ShowNoteMessage(str,2)
	local playerVo=desk.DeskUsers[0]
	self.MyDeskStation = playerVo.iDeskStation    
	self.MyUserID = playerVo.uiUserID             
	self.GUIManager:SetUserInfo(playerVo)		--断线重连时刷新信息
	self:AddEvent()
	self:SendGameData({},{}, 150,1)
	self:SendGameData({},{},MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY,GAME_MSG_TYPE.CMD_REQ_CURRENT_MSG_SEQ)
end

function GameController:SetSignalStrength(content)
	self.GameData.SignalState = content.m_data[0]
	self.GameData.IsNormalSever = self.GameData.SignalState<self.GameData.SignalStateTime
end

--处理协议
function GameController:HandleData (context)
	--print("游戏消息返回")
	if context == nil or context.m_data == nil then return end
	local clientID = context.m_data[0]
	local headStruct = context.m_data[1]
	local buffer = context.m_data[2]
	local state = context.m_data[3]
	local dwAssistantID=headStruct.dwAssistantID

	if dwAssistantID == GAME_MSG_TYPE.ASS_GM_GAME_STATION then   --GameStation_Normal {GameStation_Base}
		print("@@ 游戏状态！",#buffer)
		
		self.EnterGameCount=self.EnterGameCount+1
		if self.EnterGameCount==1 then
			CommonHelp.PlayAudio(GameAudioPath.EnterGame)
			CommonHelp.PlayBGAudio(GameAudioPath.BGM1)
		end
		LuaEvent:DispatchEvent(EventName.SetGameStateCompeleted)
		self.GUIManager:ASS_GM_GAME_STATION(state,buffer)
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_GM_S_GAME_STATION_GAME_CONFIG then   --CMD_S_Game_Station_Game_Config {MsgPrizeLine}
		print("@@ 游戏配置！",#buffer)
		local tmp = self:ParseMsg(CMD_S_Game_Station_Game_Config,buffer)
		pt(tmp)
		self.GUIManager:InitXiaZhuaConfig(tmp)
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_PLAYER_PLAYGAME_WITH_SEQ then    --CMD_S_PlayGame_Result         下注结果
		print("@@ 下注结果！")
		local tmp = self:ParseMsg(CMD_S_PlayGame_Result_With_Seq,buffer)
		self.GUIManager:CMD_S_PLAYGAME_RESULT(tmp)
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_OPEN_PRIZE_RESULT_WITH_SEQ or dwAssistantID == GAME_MSG_TYPE.CMD_FREE_S_OPEN_PRIZE_RESULT_WITH_SEQ then
		print("开奖结果")  
		local tmp = CMDOpenPrizeResultWithSeq.Decode(buffer)  --解码
		if self.GameData.IsSendGameStart then
			return
		end
		pt(tmp)
		if not self.GameData.IsReciveServerData then
			self.GameData.GameResultSeq=tmp.nSrvCurMsgSeq
			self:ParseGameResult(tmp)
			self:ParseWinLineResult(tmp)
			self:SetGameResultData(tmp)
		end
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_REQ_CURRENT_GAME_RET_WITH_SEQ then
		print("@@获取结果返回")
		local tmp = CMDOpenPrizeResultWithSeq.Decode(buffer)  --解码
		pt(tmp)
		---tmp.byGameResult[100] == 255,是否消除游戏判断
		if os.time()-self.GameData.LastReciveResultTime<2 and tmp.byGameResult[100] == 255 then
			return
		end
		self.GameData.LastReciveResultTime=os.time()

		if os.time()-self.GameData.LastSendGameStartTime<self.GameData.IntervalTime then
			return
		end
		if not self.GameData.IsNormalSever then
			return
		end
		if tmp.nClientReqSeq<self.GameData.ClientReqSeq then
			return
		end
		if self.EnterGameCount>1 and tmp.nWinPrizeLineCnt==-100 then
            LuaEvent:DispatchEvent(EventName.GameDataError_ForcedLoginReturn, nil, nil)
            return
        end
		if self.GameData.IsSendGameStart then
			if self.GameData.GameResultSeq==tmp.nSrvCurMsgSeq then
				if self.GameData.GameResultSeq ~= self.GameData.ClientReqSeq then
					return
				end
				self.GUIManager:SendGameStart()
			else
				self.GameData.GameResultSeq = tmp.nSrvCurMsgSeq
				self:ParseGameResult(tmp)
				self:ParseWinLineResult(tmp)
				self:SetGameResultData(tmp)
			end
		end
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_REQ_CURRENT_MSG_SEQ then --当前的消息ID号
		local tmp = self:ParseMsg(CMD_S_REP_CURRENT_MSG_SEQ,buffer)
		pt(tmp)
		if self.EnterGameCount==1 then
			print("-----------------当前的消息ID号",tmp.nClientReqSeq,tmp.nSrvCurMsgSeq)
			self.GameData.ClientReqSeq=tmp.nSrvCurMsgSeq
			self.GameData.GameResultSeq=tmp.nSrvCurMsgSeq
			print("--------------------self.GameData.ClientReqSeq",self.GameData.ClientReqSeq)
		end
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_GAMEINFO_SPECIAL_ITEM_CNT then 
		print("中奖碎片信息")
		--self:ParseFragmentInfo(buffer)
		
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_GAMESCORE_RESULT then   --CMD_S_GameScore_Result        玩家得分结果
		print("@@ 玩家得分结果！")
		
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_FREE_GAME_PLAY_RET then  --CMD_S_Free_Game_Play_ret  免费游戏结果
		print("@@ 免费游戏结果!")  --游戏总局数
		
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_UPDATE_JACKPOT_INFO then
		-- print("@@ 刷新jackpot！")
		local tmp = self:ParseMsg(CMD_S_UPDATE_JACKPOT_INFO,buffer) 
		-- pt(tmp)
		self:ParseUpdateJackpotInfo(tmp)
		
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_JACKPOT_SEND_TO_PRIZE then
		print("中Jackpot")
		local tmp = self:ParseMsg(CMD_S_JACKPOT_SEND_TO_PRIZE,buffer)
		self:ConfigJackpot(tmp.nProfit)
	elseif dwAssistantID==GAME_MSG_TYPE.CMD_S_JackPot_PLAY_RESULT then
		print("@@ 奖池开奖")
		--local tmp = CMDSJackPotPLAYRESULT.Decode(buffer)  --解码
		--self:OpenJackpotResultCongig(tmp)
	elseif dwAssistantID==GAME_MSG_TYPE.CMD_S_CHANGE_GAME_SENCE then 
		print("@@ 状态改变")
		local tmp = self:ParseMsg( CMD_S_Change_Game_Sence,buffer)
		print("state-----------------" .. tmp.nMiniGameID)
	elseif dwAssistantID==GAME_MSG_TYPE.CMD_S_JackPot_FINISH then
		print("@@ 奖池游戏结束")
		--local tmp = CMDSJackPotFINISH.Decode(buffer)
		--self.GUIManager:SetPlayMoney(tmp.nPlayerMoney)

	elseif dwAssistantID==GAME_MSG_TYPE.CDM_C_ChoiceReward_Play_Result then
		print("选择金刚返回")
		--self:ParseSelectDragonState(buffer)
		
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_INTO_GAMBLE then   --//进入猜大小	53
		print("@@进入猜大小")
		--self:SetEnterGamble(buffer)
	elseif dwAssistantID == GAME_MSG_TYPE.CMD_S_GAMBLE_RESULT then   --//猜大小结果	54
		print("@@猜大小结果")
		--self:GetGambleResult(buffer)	
	end
end


function GameController:ConfigJackpot(tempData)
	self.GameData.IsJackpot=true
	self.GameData.JackpotScore=tempData
end


function GameController:ParseGameResult(tempData)
	self.GameData.GameResult={}
	self.GameData.FreeIconPosGroup={}
	for i=0,GameDefine.SHZ_CommonVar.ANI_COL-1 do
		self.GameData.GameResult[i+1]={}
		local tempTable={}
		local IsFree=false
		for j=1,GameDefine.SHZ_CommonVar.ANI_ROW do
			local temp=tempData.byGameResult[i*10+GameDefine.SHZ_CommonVar.ANI_ROW -(j-1)]
			table.insert(tempTable,temp)
			if temp==11 or temp == 0 then --硬币
				IsFree=true
			end
		end
		self.GameData.FreeIconPosGroup[i+1]=IsFree
		self.GameData.GameResult[i+1]=CommonHelp.SwapIndex(tempTable)
	end
	--pt(self.GameData.GameResult)
	--self:CaculateTriggerWildState()
end


function GameController:CaculateTriggerWildState()
	local isFirst=CommonHelp.IsHaveValueForDic(8,self.GameData.GameResult[1])
	local isThree=CommonHelp.IsHaveValueForDic(8,self.GameData.GameResult[3])
	if isFirst and isThree then
		self.GameData.FreeGameIconCount=true
	else
		self.GameData.FreeGameIconCount=false
	end
end





function GameController:ParseWinLineResult(data)
	self.GameData.WinLinDataList={}
	--self.GameData.WinLineTotalMultiple=0
	self.GameData.WinLineCount=data.nWinPrizeLineCnt
	if self.GameData.WinLineCount>0 then
		local LineData=data.winPrizeLineinfo
		self.GameData.WinLineDataResult=LineData
		for i=1,self.GameData.WinLineCount do
			self.GameData.WinLinDataList[i]={}
			self.GameData.WinLinDataList[i].Column={}	
			self.GameData.WinLinDataList[i].Row={}		
			local Ypos=LineData[i].nYPos
			local Xpos=LineData[i].nXPos

			for k=1,#Ypos do
				if Ypos[k]~=255 then
					table.insert(self.GameData.WinLinDataList[i].Row,Ypos[k]+1)		
				end
			end
			
			--self.GameData.WinLineTotalMultiple=self.GameData.WinLineTotalMultiple+LineData[i].nWinLineBase
			self.GameData.WinLinDataList[i].nWinLineBase=LineData[i].nWinLineBase  
			self.GameData.WinLinDataList[i].nWinLineScore=LineData[i].nWinLineScore
			self.GameData.WinLinDataList[i].nGameItemID=LineData[i].nGameItemID
			self.GameData.WinLinDataList[i].nPrizeLineID=LineData[i].nPrizeLineID
			
			for j=1,#Xpos do
				if Xpos[j]~=255 and Xpos[j]~=-1  then
					table.insert(self.GameData.WinLinDataList[i].Column,Xpos[j]+1)
				end 
			end
			local isLeft=false
			if self.GameData.WinLinDataList[i].Column[1]==1 then
				isLeft=true
			end
			self.GameData.WinLinDataList[i].IsLeftLine=isLeft
			
			if #(self.GameData.WinLinDataList[i].Column)==5 then
				self.GameData.IsFiveKindOnLineState=true
			end
		end
		
		--pt(self.GameData.WinLinDataList)
	else
		print("没有中奖___________________________________________________")
	end

end

function GameController:GetCurrentZuanShiCount()
	local count = 0
	if self.GameData.GameResult then
		local dataTemp = nil
		for i = 1, #self.GameData.GameResult do
			dataTemp = self.GameData.GameResult[i]
			for j = 1, #dataTemp do
				if dataTemp[j] == 12 then
					count = count + 1
				end
			end
		end
	end
	return count
end

function GameController:ResetFreeGameRemainCount()
	self.GameData.FreeGameRemainCount =  self.GameData.FreeGameTotalCount-self.GameData.nCurPlayMiniGameCnt
end

function GameController:ParseFreeGame(data)

	if self.GameData.GameStation==GameDefine.GameStation.FreeGame or self.GameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
		self.GameData.FreeGameTotalCount=data.byCurMiniGameTotalPlayCnt
		self.GameData.nCurPlayMiniGameCnt = data.byCurMiniGameCurPlayCnt
		print("免费游戏总次数为：",self.GameData.FreeGameTotalCount)
		print("免费游戏当前数为",self.GameData.nCurPlayMiniGameCnt)
		if data.byCurMiniGameCurPlayCnt == 0 then
			self.GameData.FreeGameRemainCount = self.GameData.FreeGameTotalCount-data.byCurMiniGameCurPlayCnt
		else
			self.GameData.FreeGameRemainCount = self.GameData.FreeGameRemainCount - 1
		end
		print("免费游戏剩余次数为：",self.GameData.FreeGameRemainCount)
		if self.GameData.bySubGameStation==GameDefine.SubGameState.FreeGame then
			self.GameData.FreeGamePanel:SetFreeGameRemainCount(true,self.GameData.FreeGameRemainCount)
			self.GameData.FreeGameTotalScore=self.GameData.FreeGameTotalScore+self.GameData.GameTotalWinScore
		end	

	end
	
end



function GameController:SetGameResultData(data)
	self.GameData.GameTotalWinScore=data.nTotalWinScore
	print("当前赢分：",self.GameData.GameTotalWinScore)
	print("赢分为：",data.nTotalWinScore)
	self.GameData.ResultBetMultiple=self.GameData.GameTotalWinScore/self.GameData.currentXiaZhuaValue
	print("当前倍率为：",self.GameData.ResultBetMultiple)
	self.GameData.GameStateManager:SetGameNextStation(data.byNewTriMiniGameID+1)
	print("当前主游戏状态为：",data.byNewTriMiniGameID+1)
	self:ParseFreeGame(data)
	self.GameData.PlayerMoney=data.n64PlayerMoney
	print("玩家金钱为：",data.n64PlayerMoney)
	self.GUIManager:SetGameResult()
end



function GameController:ParseUpdateJackpotInfo(data)
	local index=1
	if data.nType==0 then
		index=1
	elseif data.nType==1 then
		index=2
	elseif data.nType==2 then
		index=3
	elseif data.nType==3 then
		index=4
	end	
	self.GameData.HandselManager:UpdateHandselValue(data,data.nTime,index)
end






function GameController.GetInstance()
	if GameController.instance==nil then
		GameController.instance=GameController.New()
	end
	return GameController.instance
	
end


function GameController:ResetAllTimer()
	self:DeleteUpdate()
	self.GameData.GameStateManager:ResetTimer()
	if self.GameData.FreeGameRunIconControl then
		self.GameData.FreeGameRunIconControl:ResetStopTimer()
	end
	
end


function GameController:UnloadAssets()
	resMgr:UnloadGameAssetBundle(self.gameID)
	AudioManager.GetInstance():DeleteAllAudioAB()
end

function GameController:__delete( ... )
	self:ResetAllTimer()
	self:UnloadAssets()
--	self.GUIManager.Player:RemoveAll()
--	self.GUIManager.GameData.AllWinPanel:Delete()
	self:RemoveEvent()
	
end



return GameController