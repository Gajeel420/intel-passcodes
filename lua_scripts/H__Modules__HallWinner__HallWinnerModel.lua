HallWinnerModel = BaseClass(LuaModel)

function HallWinnerModel:__init()
    self.Key_Winner = "Winner"
end

function HallWinnerModel:GetInstance()
	if HallWinnerModel.instance == nil then
		HallWinnerModel.instance = HallWinnerModel.New()
	end
	return HallWinnerModel.instance
end

function HallWinnerModel:SetWinnerKeyValue()
    local uid = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    local key = self.Key_Winner..uid
    PlayerPrefs.SetString(key,"true")
end

function HallWinnerModel:GetWinneKeyValue()
    local uid = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    local key = self.Key_Winner..uid
    if PlayerPrefs.GetString(key)=="" then
        return true 
    else    
        return false 
    end
end

function HallWinnerModel:__delete()

end