AudioManager=BaseClass()


local instance=nil
function AudioManager:__init(gameObj)
	self.gameObject=gameObj
	instance=self
	self:InitData()
	self:InitView()

end

--初始化数据
function AudioManager:InitData()
	self.AudioBG=nil									--背景声音
	self.Audios={}										--其它声音
	self.AllAudioClips={}								--所有的音频clip
	self.gameId=GameController.GetInstance().gameID --10300154
	self.AllAudioAB={}									--所有的音频包
	self.PreLoadCount=0
end


--初始化界面
function AudioManager:InitView()
	self:InitUIViewData()
	self:FindView()

	
end

--初始化UI数据
function AudioManager:InitUIViewData()
	self.isOpenMusic=false
	self.Key_BGMusicVolume = "Key_BGMusicVolume_"..self.gameId
	self.Key_SoundVolume = "Key_SoundVolume_"..self.gameId
	self.Key_IsOpenAudio = "Key_IsOpenAudio_"..self.gameId

	self.m_MusicVolume = self:GetLocalMusicVolume()
	self.m_SoundVolume = self:GetLocalSoundVolume()
	self.m_IsOpenAudio = self:GetLocalIsOpenAudio()
end

function AudioManager:FindView()
	local tf=self.gameObject.transform
	self.AudioBG=tf:Find("Audios/GameBGAudio"):GetComponent(typeof(AudioSource))
	self.AudioBG1=tf:Find("Audios/GameBGAudio1"):GetComponent(typeof(AudioSource))
	for i=1,10 do
		self.Audios[i]=tf:Find("Audios/GameAudio"..i):GetComponent(typeof(AudioSource))
	end
end

function AudioManager:SetEffectMuisc(isOff)
	local mVolume=0
	if isOff then
		mVolume=1
	else
		mVolume=0
	end
	for i=1,#self.Audios do
		self.Audios[i].volume =mVolume
	end
end

function AudioManager:SetBGMusic(isOff)
	local mVolume=0
	self.isOpenMusic=isOff
	if isOff then
		mVolume=0.5
	else
		mVolume=0
	end
	self.AudioBG.volume=mVolume
	self.AudioBG1.volume=mVolume
end


function AudioManager:SetBGMusicVolume(volume)
	PlayerPrefs.SetFloat(self.Key_BGMusicVolume,volume)
	self.m_MusicVolume = volume
	self.AudioBG.volume=volume
	if self.isOpenMusic then
		if self.AudioBG.volume==0 then
			CommonHelp.StopBgMusic()
		else
			self.AudioBG.volume=volume
			CommonHelp.ResumePlayBGAudio()
		end
	end
end

function AudioManager:SetSoundVolume(volume)
	PlayerPrefs.SetFloat(self.Key_SoundVolume,volume)
	self.m_SoundVolume = volume
end


--预加载所有的音频
function AudioManager:PreparatoryAllAudio(AllAudioInfo)

	for k,v in pairs(AllAudioInfo) do
		local tempTable={}
		if #v>0 then

			for i=1,#v do
				self:LoadAudio(v[i].name,v[i].path)
				self.PreLoadCount=self.PreLoadCount+1
			end
		else
			self:LoadAudio(v.name,v.path)
			self.PreLoadCount=self.PreLoadCount+1
		end

	end

end


function AudioManager:LoadAudio(name,path)
	table.insert(self.AllAudioAB,path)
	local onComplete=function (obj,name)
				if obj~=nil then
					if obj.Length>0 then
						local clip=obj[0]
						self.AllAudioClips[name]=clip
					end
				end
				self.PreLoadCount=self.PreLoadCount-1
				if self.PreLoadCount<=0 then
					LuaEvent:DispatchEvent(EventName.GameResLoadCompeleted)
					CommonHelp.PlayBGAudio(GameAudioPath.BGM1)
				end
			end
	resMgr:LoadAudio(self.gameId,path,name,onComplete)
end

function AudioManager:DeleteAllAudioAB()
	if next(self.AllAudioAB) ~= nil then
		for k,v in pairs(self.AllAudioAB) do 
			resMgr:UnLoadAssetBundle(self.gameId,v,true)
		end
	end
	-- for i=1,#self.AllAudioAB do
	-- 	local path=self.AllAudioAB[i]
	-- 	resMgr:UnLoadAssetBundle(self.gameId,path,true)
	-- end
end

function AudioManager:PlayBGAudio(audioPath)
	self.AllAudioAB[audioPath.name] = audioPath.path
	if(self.AllAudioClips[audioPath.name]==nil)then 
		local onComplete=function (obj,name)
			if obj~=nil then
				if obj.Length>0 then
					local clip=obj[0]
					self.AllAudioClips[name]=clip

					self.AudioBG.clip=self.AllAudioClips[audioPath.name]
					self.AudioBG.loop=true
					self.AudioBG.volume=self.m_MusicVolume
					self.AudioBG:Play()
				end
			end
		end
		resMgr:LoadAudio(self.gameId,audioPath.path,audioPath.name,onComplete);
	else
		self.AudioBG.clip=self.AllAudioClips[audioPath.name]
		self.AudioBG.loop=true
		self.AudioBG.volume=self.m_MusicVolume
		self.AudioBG:Play()
	end

end



function AudioManager:PlayBGAudio1(audioPath,isloop)
	self.AllAudioAB[audioPath.name] = audioPath.path
	if(self.AllAudioClips[audioPath.name]==nil)then 
		local onComplete=function (obj,name)
			if obj~=nil then
				if obj.Length>0 then
					local clip=obj[0]
					self.AllAudioClips[name]=clip

					self.AudioBG1.clip=self.AllAudioClips[audioPath.name]
					if self.isOpenMusic then
						self.AudioBG1.volume=1
					else
						self.AudioBG1.volume=0
					end
					self.AudioBG1.volume=self.m_MusicVolume
					self.AudioBG1.loop=isloop
					self.AudioBG1:Play()
				end
			end
		end
		resMgr:LoadAudio(self.gameId,audioPath.path,audioPath.name,onComplete);
	else
		self.AudioBG1.clip=self.AllAudioClips[audioPath.name]
		if self.isOpenMusic then
			self.AudioBG1.volume=1
		else
			self.AudioBG1.volume=0
		end
		self.AudioBG1.volume=self.m_MusicVolume
		self.AudioBG1.loop=isloop
		self.AudioBG1:Play()
	end
end

function AudioManager:ResumePlayBGAudio()
	if self.AudioBG then
		self.AudioBG:Play()
	end

	if self.AudioBG1 then
		self.AudioBG1:Play()
	end
end

function AudioManager:StopBgMusic()
  self.AudioBG:Stop();
 self.AudioBG1:Stop();
end

function AudioManager:PlayAudio(audioPath,isloop)

	self.AllAudioAB[audioPath.name] = audioPath.path
	local currentAudio = nil
	if(self.AllAudioClips[audioPath.name]==nil)then 
		local onComplete=function (obj,name)
			if obj~=nil then
				if obj.Length>0 then
					local clip=obj[0]
					self.AllAudioClips[name]=clip

					for i=1,10 do
						if self.Audios[i]~=nil then
							if(self.Audios[i].isPlaying==false) then
								currentAudio=self.Audios[i]
								break
							end
						end
					end
				
					if(currentAudio~=nil) then
						currentAudio.clip=self.AllAudioClips[audioPath.name]
						if(isloop~=nil)then
							currentAudio.loop=isloop
						else
							currentAudio.loop=false
						end
						currentAudio.volume = self.m_SoundVolume
						currentAudio:Play()
					end  
				end
			end
		end
		resMgr:LoadAudio(self.gameId,audioPath.path,audioPath.name,onComplete);
	else
		for i=1,10 do
			if self.Audios[i]~=nil then
				if(self.Audios[i].isPlaying==false) then
					currentAudio=self.Audios[i]
					break
				end
			end
		end
	
		if(currentAudio~=nil) then
			currentAudio.clip=self.AllAudioClips[audioPath.name]
			if(isloop~=nil)then
			  currentAudio.loop=isloop
			else
			  currentAudio.loop=false
			end
			currentAudio.volume = self.m_SoundVolume
			currentAudio:Play()
		end  
	end
end


function AudioManager:StopAudio(audioPath)
  for i=1,10 do
    if(self.Audios[i].isPlaying and self.Audios[i].clip==self.AllAudioClips[audioPath.name]) then
      self.Audios[i]:Stop()
      break
    end
  end

end

function AudioManager:StopAllAudio()
  for i=1,10 do
    if self.Audios[i].isPlaying then
		self.Audios[i]:Stop()   
		self.Audios[i].clip=nil
    end
  end

end

function AudioManager:GetLocalMusicVolume()
	return PlayerPrefs.GetFloat(self.Key_BGMusicVolume,1)
end

function AudioManager:GetLocalSoundVolume()
	return PlayerPrefs.GetFloat(self.Key_SoundVolume,1)
end

function AudioManager:GetLocalIsOpenAudio()
	return PlayerPrefs.GetInt(self.Key_IsOpenAudio,1) == 1
end

function AudioManager:GetMusicVolume()
	return self.m_MusicVolume
end

function AudioManager:GetSoundVolume()
	return self.m_SoundVolume
end

function AudioManager:GetIsOpenAudio()
	return self.m_IsOpenAudio
end

function AudioManager:SetIsOpenAudio(bol)
	self.m_IsOpenAudio = bol
	if bol then
		PlayerPrefs.SetInt(self.Key_IsOpenAudio,1)
	else
		PlayerPrefs.SetInt(self.Key_IsOpenAudio,0)
	end
end

function AudioManager.GetInstance()
	return instance
end


return AudioManager