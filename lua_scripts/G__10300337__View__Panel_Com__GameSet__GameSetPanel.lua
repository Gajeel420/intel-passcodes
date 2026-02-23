GameSetPanel=BaseClass()

function GameSetPanel:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
	self:AddBtnEventListener()
end


function GameSetPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.EffectSpriteName={"Ui_Btn_Sound","Ui_Btn_Sound_N"}
	self.MusicSpriteName={"Ui_Btn_Music","Ui_Btn_Music_N"}
	self.SetAnimList={"Set_Animation","Set2_Animation"}
	self.IsOpenSet=false
	self.m_IsShowLine15 = false
end


function GameSetPanel:InitView()

	self:FindView()
	self:InitUIViewData()
	
	
end

function GameSetPanel:FindView()
	local tf=self.gameObject.transform
	self.HelpBtn=tf:Find("Bottom/Btn_Help").gameObject
	self.m_LineBtn=tf:Find("Bottom/Btn_Line").gameObject
	self.m_LineBtn_UIBUTTON=self.m_LineBtn:GetComponent(typeof(UIButton))
	self.HelpBtnEnabled=self.HelpBtn:GetComponent(typeof(UIButton))

	self.ExitBtn=tf:Find("Title/Btn_Set_BG/Btn_Ext").gameObject    --退出
	
	self.GameSetBtn=tf:Find("Title/Btn_Set").gameObject
	self.m_Go_CloseSetBtn = tf:Find("Title/Btn_Set/Back").gameObject
	self.m_Go_CloseSetBtn:SetActive(false)
	--self.GameSetBtnEnabled=self.GameSetBtn:GetComponent(typeof(UIButton))
	print(self.GameSetBtn)
	self.MusicBtn=tf:Find("Title/Btn_Set_BG/Btn_Music").gameObject    --音乐
	self.MusicSprite=tf:Find("Title/Btn_Set_BG/Btn_Music/On"):GetComponent(typeof(UISprite))    --音乐图片
	self.EffectMusicBtn=tf:Find("Title/Btn_Set_BG/Btn_Effect").gameObject    --音效
	self.EffectMusicSprite=tf:Find("Title/Btn_Set_BG/Btn_Effect/On"):GetComponent(typeof(UISprite))   --音效图片
	
	self.SetAnima=tf:Find("Title/Btn_Set_BG"):GetComponent(typeof(Animation))
	self.SetBox=tf:Find("Title/Btn_Set_BG/Mask_Black").gameObject

	self.m_SoundSetPanel = tf:Find("Title/Panel_Set").gameObject
	self:ShowSoundSetPanel(false)
	self.m_SoundBtn = tf:Find("Title/Btn_Set_BG/Btn_Sound").gameObject
	self.m_CloseSoundBtn = tf:Find("Title/Panel_Set/Content/UI_BT_Close").gameObject
	self.m_Toggle_Sound = tf:Find("Title/Panel_Set/Content/Toggle_Sound"):GetComponent(typeof(UIToggle))
	self.m_SliderMusic = tf:Find("Title/Panel_Set/Content/Music_Slider/Slider"):GetComponent(typeof(UISlider))
	self.m_SliderSound = tf:Find("Title/Panel_Set/Content/Sound_Slider/Slider"):GetComponent(typeof(UISlider))
end


function GameSetPanel:InitUIViewData()
	self:OnEffectMusicBtn(nil,true)
	self:OnBGMusicButton(nil,true)
	--self.SetAnima:Play(self.SetAnimList[2])
end



function GameSetPanel:AddBtnEventListener()
	UIEventListener.Get(self.HelpBtn).onClick=function () self:HelpBtnOnclick() end
	UIEventListener.Get(self.m_LineBtn).onClick=function () self:OnClickLineBtn() end
	UIEventListener.Get(self.ExitBtn).onClick=function () self:ExitGame() end
	UIEventListener.Get(self.GameSetBtn).onClick=function () self:ExitGame() end
	UIEventListener.Get(self.MusicBtn).onClick=function () self:OnBGMusicButton() end
	UIEventListener.Get(self.EffectMusicBtn).onClick=function () self:OnEffectMusicBtn() end
	UIEventListener.Get(self.SetBox).onClick=function () self:GameSetBoxBtnOnclick() end

	UIEventListener.Get(self.m_SoundBtn).onClick=function () self:OnClickSoundSet() end
	UIEventListener.Get(self.m_CloseSoundBtn).onClick=function () self:OnClickCloseSoundSet() end
	UIEventListener.Get(self.m_Toggle_Sound.gameObject).onClick=function () self:OnToggleSound() end
	UIEventListener.Get(self.m_SliderMusic.gameObject).onPress=function (go,press) self:OnPressSliderMusic(go,press) end
	UIEventListener.Get(self.m_SliderSound.gameObject).onPress=function (go,press) self:OnPressSliderSound(go,press) end
end



function GameSetPanel:GameSetBtnOnclick()
	if self.gameData.bySubGameStation==GameDefine.SubGameState.FreeGame then return end
	self.IsOpenSet=not self.IsOpenSet
	if self.IsOpenSet then
		self.SetAnima:Play(self.SetAnimList[1])
		self.m_Go_CloseSetBtn:SetActive(true)
	else
		self.SetAnima:Play(self.SetAnimList[2])
		self.m_Go_CloseSetBtn:SetActive(false)
	end
end

function GameSetPanel:GameSetBoxBtnOnclick()
	self.IsOpenSet=not self.IsOpenSet
	if self.IsOpenSet then
		self.SetAnima:Play(self.SetAnimList[1])
		self.m_Go_CloseSetBtn:SetActive(true)
	else
		self.SetAnima:Play(self.SetAnimList[2])
		self.m_Go_CloseSetBtn:SetActive(false)
	end
end

function GameSetPanel:SetGameSetBtnEnabled(isEnable)
	--self:IsEnableBtn(self.GameSetBtnEnabled,isEnable)
end


function GameSetPanel:HelpBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	local isLoaded=self.gameData.LoadModuleManager.ModuleList[GameDefine.ModuleName.Panel_Help].IsLoad
	if isLoaded==false then
		self:SetHelpBtnEnabled(false)
		self.gameData.LoadModuleManager:LoadAllocateModule(GameDefine.ModuleName.Panel_Help)
	else
		print("Panel_Help已经加载")
		self.gameData.HelpPanel:IsShowHelpPanel(true)
	end
end



function GameSetPanel:SetHelpBtnEnabled(isEnable)
	self:IsEnableBtn(self.HelpBtnEnabled,isEnable)
end


function GameSetPanel:IsEnableBtn(btnEnable,isEnable)
	btnEnable.isEnabled=isEnable
end



function GameSetPanel:ExitGame()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	RoomController:GetInstance():ReqQuitGame(GameController.GetInstance().desk)
end





function GameSetPanel:PlaySetAnim(index)
	self.SetAnima:Play(self.SetAnimList[index])
end



----音效点击事件处理
function GameSetPanel:OnEffectMusicBtn( go ,isInit )
	
	if isInit==nil  then
		SystemSetting:GetInstance().IsSoundOn = not (SystemSetting:GetInstance().IsSoundOn)
	end

	self:SetEffectMuisc(SystemSetting:GetInstance().IsSoundOn)	
	if SystemSetting:GetInstance().IsSoundOn then
		self.EffectMusicSprite.spriteName=self.EffectSpriteName[1]
	else
		self.EffectMusicSprite.spriteName=self.EffectSpriteName[2]
	end
end
----背景音乐点击事件
function GameSetPanel:OnBGMusicButton( go ,isInit)
	if isInit==nil  then
		SystemSetting:GetInstance().IsBGMusicOn = not (SystemSetting:GetInstance().IsBGMusicOn)
	end
	self:SetBGMusic(SystemSetting:GetInstance().IsBGMusicOn)
	if SystemSetting:GetInstance().IsBGMusicOn then
		self.MusicSprite.spriteName=self.MusicSpriteName[1]
	else
		self.MusicSprite.spriteName=self.MusicSpriteName[2]
	end
end


-----设置音效的开关
function GameSetPanel:SetEffectMuisc(isOff)
	local audioM=AudioManager.GetInstance()
	audioM:SetEffectMuisc(isOff)
end

---设置背景音乐的开关
function GameSetPanel:SetBGMusic(isOff)
	local audioM=AudioManager.GetInstance()
	audioM:SetBGMusic(isOff)
end

--是否显示声音设置面板
function GameSetPanel:ShowSoundSetPanel(bol)
	if bol then
		local isOpen = AudioManager.GetInstance():GetLocalIsOpenAudio()
		if isOpen then
			self.m_SliderMusic.value = AudioManager.GetInstance():GetMusicVolume()
			self.m_SliderSound.value = AudioManager.GetInstance():GetSoundVolume()
		else
			self.m_SliderMusic.value = 0
			self.m_SliderSound.value = 0
		end
		self.m_Toggle_Sound.value = isOpen
		
		self.m_SoundSetPanel:SetActive(true)
	else
		self.m_SoundSetPanel:SetActive(false)
	end
end

--声音设置按钮点击
function GameSetPanel:OnClickSoundSet()
	self:ShowSoundSetPanel(true)
end

--关闭声音设置按钮点击
function GameSetPanel:OnClickCloseSoundSet()
	self:ShowSoundSetPanel(false)
end

--开关声音
function GameSetPanel:OnToggleSound()
	if self.m_Toggle_Sound.value then
		AudioManager.GetInstance():SetBGMusicVolume(1)
		AudioManager.GetInstance():SetSoundVolume(1)
		self.m_SliderMusic.value = AudioManager.GetInstance():GetLocalMusicVolume()
		self.m_SliderSound.value = AudioManager.GetInstance():GetLocalSoundVolume()
		AudioManager.GetInstance():SetIsOpenAudio(true)
	else
		AudioManager.GetInstance():SetBGMusicVolume(0)
		AudioManager.GetInstance():SetSoundVolume(0)
		self.m_SliderMusic.value = 0
		self.m_SliderSound.value = 0
		AudioManager.GetInstance():SetIsOpenAudio(false)
	end
end

--调控背景音效
function GameSetPanel:OnPressSliderMusic(go,press)
	if not press then
		AudioManager.GetInstance():SetBGMusicVolume(self.m_SliderMusic.value)
		self:HandleSoundToggleState()
		if self.m_SliderMusic.value == 0 then
			CommonHelp.StopBgMusic()
		end
	end
end

--调控音效
function GameSetPanel:OnPressSliderSound(go,press)
	if not press then
		AudioManager.GetInstance():SetSoundVolume(self.m_SliderSound.value)
		self:HandleSoundToggleState()
	end
end

--处理toggle状态
function GameSetPanel:HandleSoundToggleState()
	local volume = AudioManager.GetInstance().m_MusicVolume
	local volume2 = AudioManager.GetInstance().m_SoundVolume
	if volume == 0  and volume2 == 0 then
		self.m_Toggle_Sound.value = false
		AudioManager.GetInstance():SetIsOpenAudio(false)
	else
		self.m_Toggle_Sound.value = true
		AudioManager.GetInstance():SetIsOpenAudio(true)
	end
end

function GameSetPanel:IsEnableLineBtn(isEnable)
	self.m_LineBtn_UIBUTTON.isEnabled=isEnable
end

function GameSetPanel:OnClickLineBtn()
	self.m_IsShowLine15 = not self.m_IsShowLine15
	if self.m_IsShowLine15 then --显示
		self.gameData.LineManager:ShowAllLine()
	else
		self.gameData.LineManager:HideAllLine()
	end
end

function GameSetPanel:ResetLineBtnState()
	self.m_IsShowLine15 = false
end
