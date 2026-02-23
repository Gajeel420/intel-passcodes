GameStateManager=BaseClass()

function GameStateManager:__init()
	self:InitData()
end


function GameStateManager:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.IsEnabledStateWait=false		--是否启用状态等待
end


--	设置主游戏状态
function GameStateManager:SetGameNextStation(stationNum)
	self.gameData.GameStation=stationNum
end

--	设置子游戏状态
function GameStateManager:SetSubGameStation(stationNum)
	self.gameData.bySubGameStation=stationNum
end



function GameStateManager:SetState(isEnable)
	self.IsEnabledStateWait=isEnable
end

function GameStateManager:GetState()
	return self.IsEnabledStateWait
end

function GameStateManager:EnableState(isEnableTimer,delayTimes)
	self:SetState(true)
	if isEnableTimer then
		self.gameData.StateTimer=CommonHelp.SetTimeBackCall(delayTimes,self.EndStateCallBack,self)
	end
	
end


function GameStateManager:ResetTimer()
	if self.gameData.StateTimer then
		self.gameData.StateTimer:RemoveTimer()
		self.gameData.StateTimer=nil
	end
end


function GameStateManager:ResetStateTime()
	if self.gameData.StateTimer then
		if self.gameData.StateTimer.delayTime>0.2 then
			self.gameData.StateTimer.delayTime=0
		end 
	end
end


function GameStateManager:EndStateCallBack()
	self:SetState(false)
	self.gameData.GameControlManager:StateCallBack()
end




