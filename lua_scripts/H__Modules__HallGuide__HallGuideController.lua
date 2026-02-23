HallGuideController = HallGuideController or BaseClass(LuaController)

require"H/Modules/HallGuide/HallGuideView"
require"H/Modules/HallGuide/View/HallGuidePanel"

function HallGuideController:__init( ... )
	self.view = HallGuideView.New()

    self.m_Key_GuideGame = "Key_GuideGame"
end

function HallGuideController:GetInstance()
	if HallGuideController.instance == nil then
		HallGuideController.instance = HallGuideController.New()
	end
	return HallGuideController.instance
end

function HallGuideController:GetIsHasGuideGame()
    local isHasGuideGame = PlayerPrefs.GetInt(self.m_Key_GuideGame, 0)
    return isHasGuideGame == 1
end

function HallGuideController:SetIsHasGuideGame()
    PlayerPrefs.SetInt(self.m_Key_GuideGame, 1)
    PlayerPrefs.Save()
end

function HallGuideController:__delete( ... )
	self.view = nil
end