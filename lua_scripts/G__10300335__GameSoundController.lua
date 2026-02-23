GameSoundController=BaseClass()

function GameSoundController:__init( obj )
    self.obj=obj
    self:InitData()
end

function GameSoundController:GetInstance( ... )
	if not GameSoundController.instance then
        go = GameObject("GameSoundController")
        go.transform.parent = GameController:GetInstance().obj.transform
		GameSoundController.instance=GameSoundController.New(go)
	end
	return GameSoundController.instance
end

function GameSoundController:__delete( ... )
	GameSoundController.instance=nil
end


function GameSoundController:InitData()
    self.gameID = GameController:GetInstance().gameID
    self:CreateAudio()
end

function GameSoundController:CreateAudio()
    local go=GameObject("asBg")
    go.transform.parent=self.obj.transform
    self.asBg=go:AddComponent(typeof(AudioSource))
    self.asBg.volume=GameModel:GetInstance().musicVolume
    self.asBg.loop=true

    go=GameObject("asGame")
    go.transform.parent=self.obj.transform
    self.asGame=go:AddComponent(typeof(AudioSource))
    self.asGame.volume=GameModel:GetInstance().soundVolume

    self.soundList = {}
    local so
    for i=1,20 do
      go=GameObject("sound"..i)
      go.transform.parent=self.obj.transform
      so=go:AddComponent(typeof(AudioSource))
      table.insert(self.soundList,so)
      so.volume=GameModel:GetInstance().soundVolume
    end
end

function GameSoundController:PlayBgAudio(soundID)
  local config=SoundConfig.Data[soundID]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.asBg.volume=GameModel:GetInstance().musicVolume
        self.asBg.clip=soundRes
        self.asBg:Play()
      else
        local cb=function(obj,audioName)
          if obj~=nil and obj[0]~=nil then
            local audioClip=obj[0]
            GameLuaDefine.listAudioRes[audioName] = audioClip
            self.asBg.volume=GameModel:GetInstance().musicVolume
            self.asBg.clip= audioClip
            self.asBg:Play()
          else
            print("游戏资源加载有问题: ",config.soundPath)
          end
        end
        resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
      end
    end
  end
end

function GameSoundController:ResumeBgAudio()
  if self.asBg then
    self.asBg.volume=GameModel:GetInstance().musicVolume
    self.asBg:Play()
  end
end

function GameSoundController:StopBgAudio()
    if self.asBg then
      self.asBg:Stop()
    end
end

function GameSoundController:StopSound(soundID)
    local config=SoundConfig.Data[soundID]
    if config then
      local soundName=config.sound
      if soundName then
        local soundRes=GameLuaDefine.listAudioRes[soundName]
        if soundRes then
          self.asGame.volume=GameModel:GetInstance().soundVolume
          self.asGame.clip=soundRes
          self.asGame:Stop()
        end
      end
    end
end


function GameSoundController:PlayGameAudio(soundID,isLoop)
    local config=SoundConfig.Data[soundID]
    if config then
      local soundName=config.sound
      if soundName then
        local soundRes=GameLuaDefine.listAudioRes[soundName]
        if soundRes then
          self.asGame.volume=GameModel:GetInstance().soundVolume
          self.asGame.clip=soundRes
          if isLoop then
            self.asGame.loop = true
          else
            self.asGame.loop = false
          end
          self.asGame:Play()
        else
          local cb=function(obj,audioName)
            if obj~=nil and obj[0]~=nil then
              local audioClip=obj[0]
              GameLuaDefine.listAudioRes[audioName] = audioClip
              self.asGame.volume=GameModel:GetInstance().soundVolume
              self.asGame.clip= audioClip
              if isLoop then
                self.asGame.loop = true
              else
                self.asGame.loop = false
              end
              self.asGame:Play()
            else
              print("游戏资源加载有问题: ",config.soundPath)
            end
          end
          resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
        end
      end
    end
  end

  function GameSoundController:PlaySound(soundID)
    local ass=nil
    for k,as in pairs(self.soundList) do
      if as and not as.isPlaying then
        ass=as
        break
      end 
    end
    if ass then
      local config=SoundConfig.Data[soundID]
      if config then
        local soundName=config.sound
        if soundName then
            local soundRes=GameLuaDefine.listAudioRes[soundName]
            if soundRes then
              ass.volume=GameModel:GetInstance().soundVolume
              ass.clip=soundRes
              ass:Play()
            else
                local cb=function(obj,audioName)
                    if obj~=nil and obj[0]~=nil then
                      local audioClip=obj[0]
                      GameLuaDefine.listAudioRes[audioName] = audioClip
                      ass.volume=GameModel:GetInstance().soundVolume
                      ass.clip=audioClip
                      ass:Play()
                    else
                      print("游戏资源加载有问题: ",audioName)
                    end
                end
                resMgr:LoadAssetImmediate(self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
            end
        end
      end
    end
  end

function GameSoundController:StopAllAudio()
  for i=1,#self.soundList do
    if self.soundList[i].isPlaying then
		self.soundList[i]:Stop()   
		self.soundList[i].clip=nil
    end
  end
end