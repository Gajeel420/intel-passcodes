SoundManager = SoundManager or BaseClass()

--大厅音乐
SoundManager.BGSoundID = {
	BGM_Hall ={name="BGM_Hall",path="Common/Sounds/BG/BGM_Hall.unity3d"},
	bgm={name="bgm",path="common/audio/bg/bgm.unity3d"},
}

SoundManager.SoundID = {
	ButtonClick ={name="ButtonClick",path="Common/Sounds/Audio/ButtonClick.unity3d"},
	CloseButtonClick = {name="CloseButtonClick",path="Common/Sounds/Audio/CloseButtonClick.unity3d"},
	enterRoom = {name="enterRoom",path="Common/Sounds/Audio/enterRoom.unity3d"},
	outRoom = {name="outRoom",path="Common/Sounds/Audio/outRoom.unity3d"},
	OpenWin = {name="OpenWin",path="Common/Sounds/Audio/OpenWin.unity3d"},
	music_acitivity={name="music_acitivity",path="Common/Sounds/Audio/music_acitivity.unity3d"},
	music_promotion={name="music_promotion",path="Common/Sounds/Audio/music_promotion.unity3d"},
	music_service={name="music_service",path="Common/Sounds/Audio/music_service.unity3d"},
	music_Bank={name="music_Bank",path="Common/Sounds/Audio/music_Bank.unity3d"},
	music_recharge={name="music_recharge",path="Common/Sounds/Audio/music_recharge.unity3d"},
	music_mail={name="music_mail",path="Common/Sounds/Audio/music_mail.unity3d"},
	music_Exchange={name="music_Exchange",path="Common/Sounds/Audio/music_Exchange.unity3d"},
	music_Room={name="music_Room",path="Common/Sounds/Audio/music_Room.unity3d"},
}

-- SoundManager.SoundGrid = {
-- 	audioClip,
-- 	playEndAction,
-- }

function SoundManager:__init( ... )
	self:Initlize()
end 

function SoundManager:__delete( ... )
	self:RemoveEvent()
end

function SoundManager:GetInstance()
	if SoundManager.instance == nil then
		SoundManager.instance = SoundManager.New()
	end
	return SoundManager.instance
end

function SoundManager:Initlize( ... )
	-- local go = GameObject("SoundManager")
	self.m_IsFindSoundManager = false
	local go = GameObject.Find("SoundManager")
	if go == nil then
		self.m_IsFindSoundManager = false
		go = GameObject("SoundManager")
		self.mTran = go.transform
		self.SoundGO = go
		self.SoundTran = self.mTran
		go:AddComponent(typeof(CS.DontDestroyOnLoad))
		local  listener = GameObject.FindObjectOfType(typeof(AudioListener))
		if(listener == nil) then
			go:AddComponent(typeof(AudioListener))
		end

		
		local hallBG = GameObject("HallBG")
		hallBG.transform.parent = self.mTran
		self.hallBGAS = hallBG:AddComponent(typeof(AudioSource))
	else
		self.m_IsFindSoundManager = true
		self.mTran = go.transform
		self.SoundGO = go
		self.SoundTran = self.mTran
		self.hallBGAS = self.mTran:Find("HallBG"):GetComponent(typeof(AudioSource))
	end
	
	self.mHallBgMusicDic = {} -- 大厅背景音乐

	self.mGameBgMusicDic = {} -- 游戏背景音乐

	self.mHallSoundDic = {} --大厅声音
	self.mGameSoundDic = {} --游戏声音
	self.m_hallBgMusicOff=false
	self.m_hallSoundOff=false
	self.mHallPlayEffect= {}
	self:AddEvent()
end

function SoundManager:GetIsFindSoundManager()
	return self.m_IsFindSoundManager
end

function SoundManager:AddEvent()
	LuaEvent:AddEventListener(EventName.CSGAME_ONCHANGESOUND,self.CSGameOnChangeSound,self)
	LuaEvent:AddEventListener(EventName.CSGAME_ONCHANGEBGMUSIC,self.CSGameOnChangeBGMusic,self)
end

function SoundManager:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.CSGAME_ONCHANGESOUND,self.CSGameOnChangeSound,self)
	LuaEvent:RemoveEventListener(EventName.CSGAME_ONCHANGEBGMUSIC,self.CSGameOnChangeBGMusic,self)
end

function SoundManager:CSGameOnChangeBGMusic( context)
	if context and context.m_data then
		local volume=context.m_data[0]
		print("音乐",volume)
		SystemSetting:GetInstance():SetBGMusicOn(volume>0)
	end
end

function SoundManager:CSGameOnChangeSound( context )
	if context and context.m_data then
		local volume=context.m_data[0]
		SystemSetting:GetInstance():SetSoundOn(volume>0)
	end
end
----------------------------------背景音乐-------------------------------------

function SoundManager:GetBGAudioSource( isHall )
	--local  bgAS=nil

	-- if(isHall) then
	-- 	bgAS = self.hallBGAS
	-- else
	-- 	if(self.gameBGAS == nil) then
	-- 		local gameBG = GameObject("GameBG")
	-- 		gameBG.transform.parent =self.mTran
	-- 		self.gameBGAS = gameBG:AddComponent(typeof(AudioSource))
	-- 	end

	-- 	bgAS = self.gameBGAS
	-- end

	return self.hallBGAS
end

function SoundManager:AddBGMusic( isHall,resPath,bgClip,gameId)
	
	if(isHall) then
		self.mHallBgMusicDic[resPath] = bgClip
	else
		-- resPath =  StringFormat("{0}/{1}",gameId,resPath)
		-- self.mGameBgMusicDic[resPath] = bgClip		
	end
end

function SoundManager:GetBGMusic(isHall,resPath,gameId)
	local bgClip 
	if(isHall) then
		bgClip = self.mHallBgMusicDic[resPath]
	else
		resPath =  StringFormat("{0}/{1}",gameId,resPath)
		bgClip = self.mGameBgMusicDic[resPath]		
	end

	return bgClip
end

--播放音乐
function SoundManager:PrePlayBGMusic( gameId,audioInfo )
	SystemSetting:GetInstance():SetBGMusicVolume(1)
	local isHall = gameId == 0
	local audioName=audioInfo.name
	local audioPath=audioInfo.path
	
	local bgClip = self:GetBGMusic(isHall,audioPath,gameId)

	if(bgClip ~= nil) then

		self:PlayBGMusic(isHall,bgClip)
	else

		local cb = function (obj,name)
			if obj~=nil and obj[0]~=nil then
				local clip=obj[0]
				self:PlayBGMusic(isHall,clip)
				local p=SoundManager.BGSoundID[name].path
				self:AddBGMusic(isHall,p,clip,gameId)
				obj = nil
				
				--Resources:UnloadUnusedAssets()
				--self.xxxxxx=clip
			end
		end
		
		resMgr:LoadAudio(gameId,audioPath,audioName,cb,false,true)
	end
end

function SoundManager:PlayBGMusic(isHall,bgClip )
	if(bgClip == nil) then
		return 
	end
	local bgAS = self:GetBGAudioSource(isHall)
	if(bgAS ~= nil) then
		bgAS.loop = true
		bgAS.clip = bgClip
		bgAS.volume=SystemSetting:GetInstance():GetBGMusicVolume()
		if(SystemSetting:GetInstance():GetIsBGMusicOn()) then
			bgAS:Play()
		else
			bgAS:Stop()
		end
	end
end

function SoundManager:ResumeBGMusic(isHall)
	if(SystemSetting:GetInstance():GetIsBGMusicOn()) then
		local  bgAS = self:GetBGAudioSource(isHall)
		if(bgAS ~= nil) then
			bgAS:Play()
		end
	end
end

function SoundManager:PauseBGMusic(isHall)
	local  bgAS = self:GetBGAudioSource(isHall)

	if(bgAS ~= nil) then
		bgAS:Pause()
	end
end

--停止播放音乐
function SoundManager:StopBGMusic(isHall)
	isHall=isHall or true
	local  bgAS = self:GetBGAudioSource(isHall)

	if(bgAS ~= nil) then
		print("停止播放声音")
		bgAS:Stop()
	end
end


function SoundManager:SetBGMusicVolume(volume)
	local  hallBgAS = self:GetBGAudioSource(true)
	hallBgAS.volume=volume
	local  gameBgAS = self:GetBGAudioSource(false)
	gameBgAS.volume=volume
	SystemSetting:GetInstance():SetBGMusicVolume(volume)
end


----------------------------------背景音乐-------------------------------------

function SoundManager:DestoryGameSound()
	--游戏背景音乐
	local bgAS = self.gameBGAS

	if(bgAS ~= nil) then
		bgAS:Stop()
		bgAS.clip = nil
	end

	for k,v in pairs(self.mGameBgMusicDic) do
		GameObject.Destroy(v)
	end

	self.mGameBgMusicDic = {}

	--游戏声音
	for k,v in pairs(self.mGameSoundDic) do
		GameObject.Destroy(v)
	end

	self.mGameSoundDic = {}
end 


---------------------------------音效-------------------------------------
function SoundManager:GetSound(isHall,resPath)
	local bgClip 
	if(isHall) then
		bgClip = self.mHallSoundDic[resPath]
	else
		bgClip = self.mGameSoundDic[resPath]		
	end

	return bgClip
end

function SoundManager:AddSound( isHall,resPath,bgClip)
	if(isHall) then
		self.mHallSoundDic[resPath] = bgClip
	else
		self.mGameSoundDic[resPath] = bgClip		
	end
end

function SoundManager:PrePlaySound(gameId,audioInfo)
	local isHall = gameId == 0
	local audioName=audioInfo.name

	local audioPath=audioInfo.path
	local bgClip = self:GetSound(isHall,audioPath)

	if(bgClip ~= nil) then
		self:BasePlaySound(bgClip,1,1,false,nil)
	else
		local cb = function (obj,name)
			if obj~=nil and obj[0]~=nil then
				
				local p=SoundManager.SoundID[name].path
				-- resMgr:UnLoadAssetBundle(gameId,p,false)
				self:BasePlaySound(obj[0],1,1,false,nil)
				self:AddSound(isHall,p,obj[0])
			else

			end
		end
		resMgr:LoadAudio(gameId,audioPath,audioName,cb)
	end
end


function SoundManager:StopPrePlaySound(isHall,audioInfo)
	if isHall then
		local name = self.mHallSoundDic[audioInfo.path].name
		if self.mHallPlayEffect[name] ~= nil then
			self.mHallPlayEffect[name]:Stop()
			--self.mHallPlayEffect[name] = nil
			--GameObjectDestroy(self.mHallPlayEffect[name])
			--self.mHallPlayEffect[name] = nil
		end
	end
end


function SoundManager:PrePlaySoundIgnore(gameId,resPath,callBack)

					-- print("PrePlaySoundIgnore    PrePlayBGMusic  PrePlaySoundIgnore    ------------------------------> ",resPath)
	local isHall = gameId == 0
	local bgClip = self:GetSound(isHall,resPath)

	if(bgClip ~= nil) then
		self:BasePlaySound(bgClip,1,1,true,callBack)
	else
		local path = resPath
		local name =  CommonUtil.GetFileName(resPath)
		local cb = function (obj)
			if obj~=nil and obj[0]~=nil then
				-- print("SoundManager    PrePlayBGMusic  LoadresComplete    ------------------------------> ",resPath)
				-- resMgr:UnLoadAssetBundle(gameId,resPath,false)
				self:BasePlaySound(obj[0],1,1,true,callBack)
				self:AddSound(isHall,resPath,obj[0])
			end
		end
		resMgr:LoadAudio(gameId,path,name,cb)
	end
end

function SoundManager:PlaySoundIgnore(clip,callBack)
	return self:BasePlaySound(clip,1,1,true,callBack)
end

function SoundManager:StopPlaySound(mAudioSource)
	if(mAudioSource ~= nil) then
		GameObject.Destroy(mAudioSource)
	end
end

-- 声音文件 音量 音调  循环 是否忽略开关 多充多送
function SoundManager:BasePlaySound(clip,volume,pitch,ignore,callBack)
	if(clip == nil) then return end

	if(SystemSetting:GetInstance():GetIsSoundOn() or ignore) then
		local go = GameObject(clip.name)
		go.transform.parent = self.SoundTran
		local as = go:AddComponent(typeof(AudioSource))
		as.clip = clip
		as.volume = volume*SystemSetting:GetInstance():GetSoundVolume()
		as.pitch = pitch
		as.loop = false
		as:Play()
		
		self.mHallPlayEffect[clip.name]= as
		local destAction = go:AddComponent(typeof(DestoryDelay))
		local func = function()
			pcall(callBack)
			self.mHallPlayEffect[clip.name] = nil
		end
		destAction:SetDestoryDelay(clip.length,func)

		return go
	end
end

function SoundManager:SetSoundVolume(volume)
	SystemSetting:GetInstance():SetSoundVolume(volume)
end

