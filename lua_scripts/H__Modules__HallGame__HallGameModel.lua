HallGameModel=HallGameModel or BaseClass(LuaModel)
function HallGameModel:__init( ... )
	self.m_Key_PlayerLoveGame = "Key_PlayerLoveGame"
	self.m_dataStr = ""
	self.m_PlayerLoveGameList = self:GetPlayerLoveGameList()
	self.IsCanResetAllGameTypeAfterLoginSuccess = false
end

function HallGameModel:GetInstance()
	if HallGameModel.instance == nil then
		HallGameModel.instance = HallGameModel.New()
	end
	return HallGameModel.instance
end

function HallGameModel:__delete( ... )

end

function HallGameModel:GetPlayerLoveGameList()
	self.m_dataStr = PlayerPrefs.GetString(self.m_Key_PlayerLoveGame,"")
	if self.m_dataStr ~= "" then
		self.m_PlayerLoveGameList = Json.decode(self.m_dataStr)
		if self.m_PlayerLoveGameList then
			return self.m_PlayerLoveGameList
		end
	end
	return {}
end

function HallGameModel:SetPlayerLoveGameList()
	if self.m_PlayerLoveGameList == nil or #self.m_PlayerLoveGameList == 0  then
		self.m_PlayerLoveGameList = {}
	end
	self.m_dataStr = Json.encode(self.m_PlayerLoveGameList)
	PlayerPrefs.SetString(self.m_Key_PlayerLoveGame,self.m_dataStr)
	PlayerPrefs.Save()
end

function HallGameModel:AddPlayerLoveGameList(gameID)
	print("--------------------------------- HallGameModel:AddPlayerLoveGameList ")
	pt(self.m_PlayerLoveGameList)
	table.insert(self.m_PlayerLoveGameList,gameID)
	self:SetPlayerLoveGameList()
end

function HallGameModel:RemovePlayerLoveGameList(gameID)
	for i = 1, #self.m_PlayerLoveGameList do
		if self.m_PlayerLoveGameList[i] == gameID then
			table.remove(self.m_PlayerLoveGameList,i)
			break
		end
	end
	self:SetPlayerLoveGameList()
end

function HallGameModel:CheckIsLoveGame(gameID)
	for i = 1, #self.m_PlayerLoveGameList do
		if self.m_PlayerLoveGameList[i] == gameID then
			return true
		end
	end

	return false
end
HallGameModel=HallGameModel or BaseClass(LuaModel)
function HallGameModel:__init( ... )
	self.m_Key_PlayerLoveGame = "Key_PlayerLoveGame"
	self.m_dataStr = ""
	self.m_PlayerLoveGameList = {}
end

function HallGameModel:GetInstance()
	if HallGameModel.instance == nil then
		HallGameModel.instance = HallGameModel.New()
	end
	return HallGameModel.instance
end

function HallGameModel:__delete( ... )

end

function HallGameModel:InitPlayerLoveGameData()
	self.m_PlayerLoveGameList = self:GetPlayerLoveGameList()
end

function HallGameModel:GetPlayerLoveGameList()
	local userID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	self.m_dataStr = PlayerPrefs.GetString(self.m_Key_PlayerLoveGame..userID,"")
	if self.m_dataStr ~= "" then
		self.m_PlayerLoveGameList = Json.decode(self.m_dataStr)
		if self.m_PlayerLoveGameList then
			return self.m_PlayerLoveGameList
		end
	end
	return {}
end

function HallGameModel:SetPlayerLoveGameList()
	if self.m_PlayerLoveGameList == nil or #self.m_PlayerLoveGameList == 0  then
		self.m_PlayerLoveGameList = {}
	end
	self.m_dataStr = Json.encode(self.m_PlayerLoveGameList)
	local userID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	PlayerPrefs.SetString(self.m_Key_PlayerLoveGame..userID,self.m_dataStr)
	PlayerPrefs.Save()
end

function HallGameModel:AddPlayerLoveGameList(gameID)
	table.insert(self.m_PlayerLoveGameList,gameID)
	self:SetPlayerLoveGameList()
end

function HallGameModel:RemovePlayerLoveGameList(gameID)
	for i = 1, #self.m_PlayerLoveGameList do
		if self.m_PlayerLoveGameList[i] == gameID then
			table.remove(self.m_PlayerLoveGameList,i)
			break
		end
	end
	self:SetPlayerLoveGameList()
end

function HallGameModel:CheckIsLoveGame(gameID)
	for i = 1, #self.m_PlayerLoveGameList do
		if self.m_PlayerLoveGameList[i] == gameID then
			return true
		end
	end

	return false
end

function HallGameModel:CheckIsNewGame(vo)
	return vo.status >= 10
end

function HallGameModel:SetIsResetAllGameType(bol)
	-- body
	self.IsCanResetAllGameTypeAfterLoginSuccess = bol
end