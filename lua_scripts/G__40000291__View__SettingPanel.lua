SettingPanel=BaseClass()

function SettingPanel:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self:Find()
end
function SettingPanel:Find()
	self.animator = self.transform:GetComponent(typeof(Animator))
	local btnClose=self.transform:Find("Content/Button_Close").gameObject
	UIEventListener.Get(btnClose).onClick=function() self:OnCloseBtn() end
	self.objMusicBtn = self.transform:Find("Content/Toggle_Music").gameObject
	self.objMusicOn = self.transform:Find("Content/Toggle_Music/On").gameObject
	self.objMusicOff = self.transform:Find("Content/Toggle_Music/Off").gameObject
	self.objSoundBtn = self.transform:Find("Content/Toggle_Sounds").gameObject
	self.objSoundOn = self.transform:Find("Content/Toggle_Sounds/On").gameObject
	self.objSoundOff = self.transform:Find("Content/Toggle_Sounds/Off").gameObject
	UIEventListener.Get(self.objMusicBtn).onClick = function () self:OnButtonMusic() end 
	UIEventListener.Get(self.objSoundBtn).onClick = function () self:OnButtonSound() end
	self:SetMusicState(SystemSetting:GetInstance():GetIsBGMusicOn())
	self:SetSoundState(SystemSetting:GetInstance():GetIsSoundOn())
end

function SettingPanel:OnButtonMusic( ... )
	GameController:GetInstance():PlayUIBottomAudio(113)
	SystemSetting:GetInstance():SetBGMusicOn(not SystemSetting:GetInstance():GetIsBGMusicOn())
	self:SetMusicState(SystemSetting:GetInstance():GetIsBGMusicOn())
	
end
function SettingPanel:SetMusicState( isMute )
	self.objMusicOn:SetActive(isMute)
	self.objMusicOff:SetActive(not isMute)
	
	GameModel.GetInstance().musicVolume= isMute and 1 or 0
	GameController.GetInstance():ChaneMusicVolume(isMute and 1 or 0)
end

function SettingPanel:OnButtonSound( ... )
	GameController:GetInstance():PlayUIBottomAudio(113)
	SystemSetting:GetInstance():SetSoundOn(not SystemSetting:GetInstance():GetIsSoundOn())
	self:SetSoundState(SystemSetting:GetInstance():GetIsSoundOn())
end

function SettingPanel:SetSoundState( isMute )
	self.objSoundOn:SetActive(isMute)
	self.objSoundOff:SetActive(not isMute)
	GameModel.GetInstance().soundVolume = isMute and 1 or 0
	GameController.GetInstance():ChaneSoundVolume(isMute and 1 or 0)
end
function SettingPanel:OnCloseBtn( ... )
	GameController:GetInstance():PlayUIBottomAudio(114)
	self:Close()
end
function SettingPanel:Open()
	self.gameObject:SetActive(true)
end
function SettingPanel:Close( ... )
	self.animator:Play("Ani_Narrow",0,0)
	RenderMgr.Remove("SettingPanelClose")
	RenderMgr.AddInterval(function()
		self.gameObject:SetActive(false)
		  end,"SettingPanelClose",0.8,0.82)

end
function SettingPanel:__delete( ... )

end