GameController=BaseClass(GameLuaController)

AudioSource = CS.UnityEngine.AudioSource
AudioClip = CS.UnityEngine.AudioClip
UILabel = CS.UILabel
UISprite = CS.UISprite
FishComManager = CS.FishComManager
SpawnPool=CS.SpawnPool
UISlider = CS.UISlider
UICamera = CS.UICamera
UIRoot = CS.UIRoot
Application = CS.UnityEngine.Application
UISpriteAnimation = CS.UISpriteAnimation
PrefabPool=CS.PrefabPool
SpriteRenderer = CS.UnityEngine.SpriteRenderer
Texture2D = CS.UnityEngine.Texture2D
LuaBehaviour=CS.LuaBehaviour
Screen= CS.UnityEngine.Screen
Input=CS.UnityEngine.Input
BoxCollider=CS.UnityEngine.BoxCollider
Color=CS.UnityEngine.Color
Animator=CS.UnityEngine.Animator
Animation=CS.UnityEngine.Animation
Resources = CS.UnityEngine.Resources
ParticleSystem = CS.UnityEngine.ParticleSystem
SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
Quaternion = CS.UnityEngine.Quaternion
UIScrollView = CS.UIScrollView
TweenAlpha=CS.TweenAlpha
TweenRotation = CS.TweenRotation
TweenPosition = CS.TweenPosition  
TweenTransform = CS.TweenTransform
TweenScale = CS.TweenScale  
UIPanel = CS.UIPanel
UIButtonRotation = CS.UIButtonRotation
UIButtonScale = CS.UIButtonScale
UIButton = CS.UIButton
UIToggle = CS.UIToggle

function GameController:__init( ... )
  self.gameID = 40000291
  self:FindPath("GameLuaDefine")
  self:FindPath("EntityModule")
  self:FindPath("Config/FishConfig")
  self:FindPath("Config/SoundConfig")
  self:FindPath("Vo/FishVo")
  self:FindPath("GameModel")
  self:FindPath("GameView")
  self:FindPath("Msg/CMD_S_CONFIG_INFO")
  self:FindPath("Msg/CMD_S_FishTrace")
  self:FindPath("Msg/CMD_S_FishBombTrace")
  self:FindPath("Msg/CMD_S_HitFish")
  self:FindPath("Msg/CMD_S_PartBombKilledFish")
  self:FindPath("Msg/CMD_S_SpecialFishTrace")
  self:FindPath("View/Bullet")
  self:FindPath("View/UIOddPanel")
  self:FindPath("View/SettingPanel")
  --self:FindPath("View/Curve")
  self:FindPath("View/EffectThunder")
  self:FindPath("View/FishBase")
  self:FindPath("View/Fish")
  --self:FindPath("View/SpecialFish")
  self:FindPath("View/SpineFish")
  self:FindPath("View/LockFish")
  self:FindPath("View/ZuanTouBullet")
  self:FindPath("View/FishMoney")
  self:FindPath("View/DropSpecial")
  self:FindPath("View/KillLeiShe")
  self:FindPath("View/FloatNum")
  self:FindPath("View/Net")
  --self:FindPath("View/Spline")
  self:FindPath("View/UIPlayerGroup")
  self:FindPath("View/CameraShake")
  self:FindPath("View/FishKingTips")
  self:FindPath("View/BiKaQiuTips")
  self:FindPath("View/MoTianLunTips")
  self:FindPath("View/ZhangYuTips")
  self:FindPath("View/GoldTeamAdd")
  self:FindPath("View/TimerManager")
  self:FindPath("View/ParticleManager")
  self:FindPath("View/LieYanFengBao")
  self:FindPath("View/MinNiGame_CaiShenManager")
  self:FindPath("View/MinNiGame_CaiShenScoreItem")
  self:FindPath("View/MinNiGame_XingYunJinNiu")

  self:FindPath("View/MinGame/BeiKeXunBao/BeiKeXunBaoManager")
  self:FindPath("View/MinGame/BeiKeXunBao/BeiKeGameTimeManager")
end
function GameController:FindPath(path)
  table.insert(self.RequireList,StringFormat("G/{0}/{1}",self.gameID,path))
end

function GameController:Init(desk)
	CS.Debuger.IsEnableLog=true
  GameLuaController.Init(self)
  --self.LanguageType=2
  self:GetResCount()
  self:AddLodingEvent()
  self.DeleteList ={}
  local name = "GameGroup.prefab"
  local path = "Phone/Prefab/Game/GameGroup.unity3d"
  local cb = function ( obj )
    if obj~=nil and obj.Length>0 and obj[0] ~=nil then
      local prefab= obj[0]
      self.obj = GameObject.Instantiate(prefab)
      self.obj.transform.parent = nil
      self.obj.transform.localScale = Vector3.one
      self.obj.transform.localPosition = Vector3.zero
      self.obj:SetActive(true)
      prefab = nil
      obj[0] = nil
      Resources:UnloadUnusedAssets()
      self:ReInit(self.obj,desk)
    else
      print("游戏资源加载有问题")
    end
  end
  resMgr:LoadPrefabEx(self.gameID,path,name,cb)
end

function GameController:AddLodingEvent()
  LuaEvent:AddEventListener(EventName.LOADING_CALCULATE_RES_COUNT,self.CurLoadingResCount,self)
end

function GameController:RemoveLoadingEvent()
  LuaEvent:RemoveEventListener(EventName.LOADING_CALCULATE_RES_COUNT,self.CurLoadingResCount,self)
end

function GameController:CurLoadingResCount(data)
    self.curLoadCount = self.curLoadCount + 1

    LuaEvent:DispatchEvent(EventName.LoadingPanelProgress, (self.curLoadCount /self.resCount));
end

function GameController:AddDeleteUpdateList(updateName)
	table.insert(self.DeleteList,updateName)
end


function GameController:DeleteUpdate()
  for i=1,#self.DeleteList do
    RenderMgr.Remove(self.DeleteList[i])
	end
	
end

function GameController:GetResCount()
    self.resCount  = 0
    self.curLoadCount = 0;
    self.resCount = FishComManager.GetTraceFileCount(self.gameID)
    if ConfigInfoMgr.useHotFunction == false then
      self.resCount  = self.resCount + #GameLuaDefine.GameGroup

      self.resCount  = self.resCount + #GameLuaDefine.PlayerGroupRes

      self.resCount = self.resCount + #GameLuaDefine.YuRenPackRes
  
      -- for i,v in pairs(GameLuaDefine.BGTextureRes) do
      --   self.resCount= self.resCount + 1
      -- end
      -- for i,v in pairs(SoundConfig) do
      --   self.resCount= self.resCount + 1
      -- end
  
      -- for i,v in ipairs(GameLuaDefine.FishsRes) do
      --   self.resCount = self.resCount + v.count
      -- end
  
      -- for i,v in ipairs(GameLuaDefine.BulletRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.NetRes
      -- for i,v in ipairs(GameLuaDefine.NetRes) do
      --   self.resCount = self.resCount + v.count
      -- end    
      self.resCount =  self.resCount + #GameLuaDefine.FishMoneyRes * 2
  
      -- for i,v in ipairs(GameLuaDefine.FishMoneyRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.ThunderRes
      -- for i,v in ipairs(GameLuaDefine.ThunderRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      -- self.resCount =  self.resCount + #GameLuaDefine.FloatNumRes
      -- for i,v in ipairs(GameLuaDefine.FloatNumRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.ExplosiveRes
      -- for i,v in ipairs(GameLuaDefine.ExplosiveRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      
  
      --self.resCount =  self.resCount + #GameLuaDefine.DropObjRes
      -- for i,v in ipairs(GameLuaDefine.DropObjRes) do
      --   self.resCount = self.resCount + v.count
      -- end
  
     -- self.resCount =  self.resCount + #GameLuaDefine.KillLeiSheRes
      -- for i,v in ipairs(GameLuaDefine.KillLeiSheRes) do
      --   self.resCount = self.resCount + v.count
      -- end

    else
      local panelPath ={}
	    for i =1,#GameLuaDefine.GameGroup do
		    panelPath[i] = GameLuaDefine.GameGroup[i]["path"]
	    end
      self.resCount  = self.resCount + ((resMgr:LoadResourcePackerInfoSet(self.gameID,panelPath ,nil)) * 2)
      self.resCount  = self.resCount + #GameLuaDefine.PlayerGroupRes * 2
      self.resCount = self.resCount + #GameLuaDefine.YuRenPackRes * 2
      -- for i,v in pairs(GameLuaDefine.BGTextureRes) do
      --   self.resCount= self.resCount + 1
      -- end
      -- for i,v in pairs(SoundConfig) do
      --   self.resCount= self.resCount + 1
      -- end

      -- for i,v in ipairs(GameLuaDefine.FishsRes) do
      --   self.resCount = self.resCount + v.count
      -- end

      -- for i,v in ipairs(GameLuaDefine.BulletRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.NetRes * 2
      -- for i,v in ipairs(GameLuaDefine.NetRes) do
      --   self.resCount = self.resCount + v.count
      -- end    
      self.resCount =  self.resCount + #GameLuaDefine.FishMoneyRes * 2

      -- for i,v in ipairs(GameLuaDefine.FishMoneyRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.ThunderRes* 2
      -- for i,v in ipairs(GameLuaDefine.ThunderRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      -- self.resCount =  self.resCount + #GameLuaDefine.FloatNumRes
      -- for i,v in ipairs(GameLuaDefine.FloatNumRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      self.resCount =  self.resCount + #GameLuaDefine.ExplosiveRes* 2
      -- for i,v in ipairs(GameLuaDefine.ExplosiveRes) do
      --   self.resCount = self.resCount + v.count
      -- end
      -- self.resCount =  self.resCount + #GameLuaDefine.GoldTeamAddRes
      -- for i,v in ipairs(GameLuaDefine.GoldTeamAddRes) do
      --   self.resCount = self.resCount + v.count
      -- end

      --self.resCount =  self.resCount + #GameLuaDefine.DropObjRes* 2
      -- for i,v in ipairs(GameLuaDefine.DropObjRes) do
      --   self.resCount = self.resCount + v.count
      -- end

      self.resCount =  self.resCount + #GameLuaDefine.KillLeiSheRes* 2

      self.resCount = self.resCount + 20
      -- for i,v in ipairs(GameLuaDefine.KillLeiSheRes) do
      --   self.resCount = self.resCount + v.count
      -- end
    end

    
end

function GameController:ReInit(obj,desk)

    self.model = GameModel:GetInstance()
    self.entityModel=EntityModule.New()
   
    self:CreateAudio()

    self.view = GameView.New(obj)

    local cb = function()
      self.view: StartLoadGameRes()
    end
    local deskPos = desk:GetMyVo().iDeskStation
    if desk:GetMyVo().iDeskStation >= (desk.uDeskPeople * 0.5) then
      FishComManager.AccordingDeskLoadBinaryTraceFile(self.gameID,true,cb,true)
    else
      FishComManager.AccordingDeskLoadBinaryTraceFile(self.gameID,false,cb,true)
    end
end


function GameController:CreateAudio() --创建声音器
  local go=GameObject("asBg")
  go.transform.parent=self.obj.transform
  self.asBg=go:AddComponent(typeof(AudioSource))
  self.asBg.volume=self.model.musicVolume
  self.asBg.loop=true
  go=GameObject("asUIBottom")
  go.transform.parent=self.obj.transform
  self.asUIBottom=go:AddComponent(typeof(AudioSource))
  self.asUIBottom.volume=self.model.soundVolume
  go=GameObject("asGame")
  go.transform.parent=self.obj.transform
  self.asGame=go:AddComponent(typeof(AudioSource))
  self.asGame.volume=self.model.soundVolume
  
  go=GameObject("GunFen")
  go.transform.parent=self.obj.transform
  self.GunFen=go:AddComponent(typeof(AudioSource))
  self.GunFen.volume=self.model.soundVolume

  self.coinList = {}
  local coin
  for i=1,10 do
    go=GameObject("fishAs"..i)
    go.transform.parent=self.obj.transform
    coin=go:AddComponent(typeof(AudioSource))
    table.insert(self.coinList,coin)
    coin.volume=self.model.soundVolume
  end

  --鱼死亡的音效
  self.asFishList={}
  local as=nil
  for i=1,20 do
    go=GameObject("fishAs"..i)
    go.transform.parent=self.obj.transform
    as=go:AddComponent(typeof(AudioSource))
    table.insert(self.asFishList,as)
    as.volume=self.model.soundVolume
  end
end

function GameController:AddEvent()
  LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)
  --LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.BackChangeToFrontStage,self)	
 -- LuaEvent:AddEventListener(EventName.FRONT_TO_BACK_STAGE,self.FrontChangeToBackStage,self)	
end

function GameController:RemoveEvent()
  LuaEvent:RemoveEventListener(EventName.GameNetDispatchData,self.HandleData,self)
--  LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.BackChangeToFrontStage,self)	
 -- LuaEvent:RemoveEventListener(EventName.FRONT_TO_BACK_STAGE,self.FrontChangeToBackStage,self)	
end

function GameController:BackChangeToFrontStage()
  local send = {}
  send.byChairNo = self.model.m_myUserInfo.iDeskStation
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_PLAYER_COME_BACK_REQUEST_SYNC_FISHES
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_BackChangeToFontChairID,send,mainId,msgID)
end

function GameController:FrontChangeToBackStage()
  self:ClearnSceneObj()
end

function GameController:HandleData (context)
--print("游戏消息返回")
  if context == nil or context.m_data == nil then return end
  local clientID = context.m_data[0]
  local headStruct = context.m_data[1]
  local buffer = context.m_data[2]
  local state = context.m_data[3]
  if headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_GAME_SCENE then
  	local msg=self:ParseMsg(GameLuaDefine.CMD_S_GameScene,buffer)
    print("场景信息", Time.realtimeSinceStartup)
    print("msg.btCureSeaSceneKind===========",msg.btCureSeaSceneKind)
    self.view:SetBg(msg.btCureSeaSceneKind+1)
    
    if msg.byDHSZFlag == 1 then
      GameModel:GetInstance().ding= true
    else
      GameModel:GetInstance().ding= false
    end

    --设置玩家的初始状态
    for k,v in pairs(self.model.UserInfos) do
      local clientDesk=self:GetFishPlayerDirection(v.iDeskStation)
      local p=self.view.m_playerGroups[clientDesk]
      if p then
        p.isMe=clientDesk==self.model.m_myClientDesk
        p:SetGunLevel(1)
        p.isOtherLockShoot = false
        p:SetMoneyUILabel(v.iMoney)
        p:IsVisible(true)
        p:SetGunLevelBtn(p.isMe)
        p:SetPlayerName(v.szNickName)
        if p.isMe then
          p:ShowImHereTips()
        end
      end
    end
    -- if GameModel:GetInstance().gameState == GameLuaDefine.GameState.None then
    --   self.view.m_objTideTips:SetActive(true)
    -- end
    LuaEvent:DispatchEvent(EventName.LoadingPanelProgress, 1.01);
    LuaEvent:DispatchEvent(EventName.SetGameStateCompeleted)
    self.view:PlayEnterSceneAnimator()
    print("状态设置完成")
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_REDPACKET_FISH then
    local msg=self:ParseMsg(GameLuaDefine.CMS_S_REDPACKET_FISH_ON,buffer)
    if msg.byRedPacketFishOn == 0 then
      --self.view:SetClickPigBtnVisible(false)
    else
      --self.view:SetClickPigBtnVisible(true)
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_CONFIG_INFO then
    print("房间配置信息",string.len(buffer)," ",Time.realtimeSinceStartup)
  
  	local msg=CMD_S_CONFIG_INFO.Decode(buffer)
    pt(msg) 
    self.model.m_gunLevelList={}
    for i=1,msg.nCannonLevelValSize do
      if msg.nCannonLevelValList[i] > 0 then
        self.model.m_gunLevelList[i]=msg.nCannonLevelValList[i]
      else
        break
      end
    end
    self.model.m_maxBulletCount=msg.nBulletCountInSereen
    self.model.byFixTimes = msg.btFixTimes
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_FISHINFO then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_SpeicalData,buffer)
    if msg.byType == 0 then
      local direction=self:GetFishPlayerDirection(msg.dwData1)
      if direction<0 then return end
      if not self.model.UserInfos[direction] then
        print("没有这个玩家"..msg.dwData1)
        return
      end
      local fishUid = msg.dwData2
      self:SendClickZhaDan(60005,fishUid,0,direction)
    elseif msg.byType == 1 then
      local direction=self:GetFishPlayerDirection(msg.dwData1)
      if direction<0 then return end
      local player=self.view.m_playerGroups[direction]
      player:ShowTimerDown(msg.dwData2)
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_CHANGE_SCENE then
    --print("切换场景 :")
    GameModel:GetInstance().gameState = GameLuaDefine.GameState.JieSuan;
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_ChangeScene,buffer)
    local fileName=CommonUtil.LuaTableToStringNoEmpty(msg.szTraceFile)
    self.model.m_strfishTraceXmlFile=fileName
    self.model.m_iFishTraceXmlVersion=msg.szFileVersion
    self.model.ChangeSceneTime = msg.byPrepareTime * 0.1
    self.model.FishGoAwayTime = msg.byFishGoAwayTime * 0.1
    --清理掉之前服务器发过来的鱼的数据
    self.model.listFishVo=nil
    self.model.listFishVo={}
    msg.CureSeaSceneKind=msg.CureSeaSceneKind or 0
    self.view:ChangeScene(msg.CureSeaSceneKind+1)
  elseif  headStruct.dwAssistantID ==GameLuaDefine.ASS_GAME_TYPE.SUB_S_DHSZ_OVER then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_DHSZOver,buffer)
    GameModel:GetInstance().ding=false
    GameController:GetInstance().entityModel:ResumeAllFish()
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_TRACE_POINT then
    -- print("发送散鱼")
    GameModel:GetInstance().gameState = GameLuaDefine.GameState.SanYu;
    local msg=CMD_S_FishTrace.Decode(buffer)
  	-- pt(msg)
    if msg.fishTraceCount and msg.fishTraceCount>0 then
      for k,v in pairs(msg.fishList) do
        local curIndex = (v.usStartPointIndex + v.usOffsetIndex)
        local isLimit =  FishComManager.LimitTracePoint(v.usTraceId,curIndex)
        if isLimit == true then -- and v.btFishKind == 26 and v.usTraceId == 64
            --table.insert(self.model.fishRawData,v)
            self:ParseFishTrace(v)
        end
      end
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_TRACE_POINT_EX then
    GameModel:GetInstance().gameState = GameLuaDefine.GameState.SanYu;
	 print("特殊炸弹轨迹")
    local msg=CMD_S_FishBombTrace.Decode(buffer)
	pt(msg)
    if msg.fishTraceCount and msg.fishTraceCount>0 then
      for k,v in pairs(msg.fishList) do
        local curIndex = (v.usStartPointIndex + v.usOffsetIndex)
        local isLimit =  FishComManager.LimitTracePoint(v.usTraceId,curIndex)
        if isLimit == true then -- and v.btFishKind == 26 and v.usTraceId == 64
            --table.insert(self.model.fishRawData,v)
            self:ParseFishTrace(v)
        end
      end
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_SHOOTSUPERBOMB then  
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_SHOOTSUPERBOMB,buffer)
    local direction=self:GetFishPlayerDirection(msg.byChairId)
    if direction<0 then return end
    local player=self.view.m_playerGroups[direction]
    player:RemoveDropObj(msg)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_FISHSTATUS then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_FishStatus,buffer)
    local fish = GameController:GetInstance().entityModel:GetFishByFishUID(msg.dwFishID)
    if fish then
      fish:ChangeFishStatus(msg.byStatus)
    end

  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_HIT_FISH_EX then
    --print("捕获了一条鱼")
    local msg=CMD_S_HitFish.Decode(buffer)
   -- pt(msg)
    self.view:HandleHitFish(msg)
    --GameController:GetInstance():PlayGameAudio(109)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_USER_SHOOT then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_UserShoot,buffer)
    local direction=self:GetFishPlayerDirection(msg.wChairID)
    if direction<0 then return end
    local player=self.view.m_playerGroups[direction]
    player:SetGunLevel(msg.byCannonLevelIndex+1)
    --发射炮弹
    player:ShootGun(msg.dwBulletID, msg.fAngle / 10, false, 0)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_USER_SHOOT_EX then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_UserShootEx,buffer)
    local direction=self:GetFishPlayerDirection(msg.wChairID)
    if direction<0 then return end
    local player=self.view.m_playerGroups[direction]
    player:SetGunLevel(msg.byCannonLevelIndex+1)

    self.model.UserInfos[direction].iMoney=msg.imoney
    if not self.view.m_playerGroups[direction] then print("没有这个实体玩家组件",msg.wChairID,direction) return end 
    self.view.m_playerGroups[direction]:SetMoneyUILabel(msg.imoney)

    --发射炮弹
    player:ShootGun(msg.dwBulletID, msg.fAngle / 10, false, 0)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_ROBOT_SHOOT then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_RobotShoot,buffer)
    -- print(btRobotChairID)
    local direction=self:GetFishPlayerDirection(msg.btRobotChairID)
    if direction<0 then return end
    local player=self.view.m_playerGroups[direction]
    player.HelRobot_ID=msg.btProcUserChairID
    player:SetGunLevel(msg.btCannonLevelIndex+1)
    player:ShootGun(msg.dwBulletID, msg.fAngle / 10, true, msg.btRobotChairID)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_LOCK_FISH_NOTIFY then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_LockFish,buffer)
    local direction=self:GetFishPlayerDirection(msg.wChairID)
  
    if direction>0 and direction<5 then
      if msg.btLock==1 then
        local fish=self.entityModel:GetFishByFishUID(msg.dwFishID)
        --print("dddddddddddddddddd",fish)
        self.view.m_playerGroups[direction]:SetTarget(fish)
      else
        self.view.m_playerGroups[direction]:SetTarget(nil)
      end
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_CREATBOMB then  
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_CreatBomb,buffer)
    local direction=self:GetFishPlayerDirection(msg.byChairId)
    if direction<0 then return end
    local player=self.view.m_playerGroups[direction]
    player:CreateDropObj(msg)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_USERDATA then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_UserBtnData,buffer)
    local direction=self:GetFishPlayerDirection(msg.byChairID)
    if direction<0 then return end
    if not self.model.UserInfos[direction] then
      print("没有这个玩家"..msg.wChairID)
      return
    end
    
    local status = false
    if msg.dwData == 1 then
      status = true
    else
      status = false
    end

    if msg.dwType == 1 then
      self.view.m_playerGroups[direction].isOtherLockShoot = status
      self.view.m_playerGroups[direction]:SetGunLevel(self.view.m_playerGroups[direction]._curLevelIndex)
    elseif msg.dwType == 2 then
      self.view.m_playerGroups[direction]:SetAutoObjStaus(status)
    end
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_REDPACKET_MONEY_NOTIFY then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_REDPACKET_MONEY_NOTIFY,buffer)
    local direction=self:GetFishPlayerDirection(msg.byChairID)
    if direction<0 then return end
    if not self.model.UserInfos[direction] then
      print("没有这个玩家"..msg.wChairID)
      return
    end
    self.model.hongBaoMoney = msg.u32Packets
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_MONEY_NOTIFY then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_MONEY_NOTIFY,buffer)
    local direction=self:GetFishPlayerDirection(msg.wChairID)
    if direction<0 then return end
    if not self.model.UserInfos[direction] then
      print("没有这个玩家"..msg.wChairID)
      return
    end

    -- print(self,self.view,self.view.m_playerGroups,self.view.m_playerGroups[direction])
    self.model.UserInfos[direction].iMoney=msg.iMoney
    if not self.view.m_playerGroups[direction] then print("没有这个实体玩家组件",msg.wChairID,direction) return end 
    self.view.m_playerGroups[direction]:SetMoneyUILabel(msg.iMoney)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_NENGLIANGPAO_CTRL then
    local msg=self:ParseMsg(GameLuaDefine.CMD_S_NengLiangPao_Ctrl,buffer)
    local direction=self:GetFishPlayerDirection(msg.byChairID)
    if direction<0 then return end
    if not self.model.UserInfos[direction] then
      print("没有这个玩家"..msg.byChairID)
      return
    end
    self.view.m_playerGroups[direction]:EnterLieYanFengbao(msg.byOnOff)
  elseif headStruct.dwAssistantID==GameLuaDefine.ASS_GAME_TYPE.SUB_S_SEND_PARTBOMB_KILLED_LT_EX then
    --局部炸弹炸死鱼
    local t=CMD_S_PartBombKilledFish.Decode(buffer)
    self.view:HandleHitFishBoom(t)
  end
end

--自己进入
function GameController:EnterGame(desk)
  self:RemoveEvent()
  self:AddEvent()
  --self.Clear()
  self.desk=desk
  self.model.m_myServerDesk=self.desk:GetMyVo().iDeskStation
  self.model.UserInfos={}
  for k,v in pairs(self.desk.DeskUsers) do
    local ndirection=self:GetFishPlayerDirection(v.iDeskStation)
    self.model.UserInfos[ndirection]={}
    self.model.UserInfos[ndirection].uiUserID=v.uiUserID
    self.model.UserInfos[ndirection].iDeskStation=v.iDeskStation
    self.model.UserInfos[ndirection].iMoney=v.iMoney
    self.model.UserInfos[ndirection].szNickName=v.szNickName
    if v.uiUserID==self.desk:GetMyVo().uiUserID then
      self.model.m_myUserInfo=self.model.UserInfos[ndirection]
    end
    self.view.waitPlayer[ndirection]:SetActive(false)
  end
  self.model.m_myClientDesk=self:GetFishPlayerDirection(self.model.m_myServerDesk)
  self:SendGameData({},{}, 150,1)

  self:PlayBgAudio(2)
  
end



function GameController:PlayerEnterRoom(userInfo)
  local direction = self:GetFishPlayerDirection(userInfo.iDeskStation);
  local info=self.model.UserInfos[direction]
  if not info then
    info={}
  end  
  info.uiUserID=userInfo.uiUserID
  info.iRoomID=userInfo.iRoomID
  info.iMoney=userInfo.iMoney
  info.iDeskStation=userInfo.iDeskStation
  info.szNickName=userInfo.szNickName
  self.model.UserInfos[direction]=info
  self.view.m_playerGroups[direction]:InitPlayerGroup()
  self.view.m_playerGroups[direction]:SetGunLevel(1)
  self.view.m_playerGroups[direction]:IsVisible(true)
  self.view.m_playerGroups[direction]:SetGunLevelBtn(false)
  self.view.m_playerGroups[direction]:SetPlayerName(info.szNickName)
  self.view.m_playerGroups[direction]:SetMoneyUILabel(info.iMoney)
  self.view.waitPlayer[direction]:SetActive(false)
  self.view.comePlayer[direction]:SetActive(true)
  self.view.outPlayer[direction]:SetActive(false)
end
function GameController:PlayerLeaveRoom(deskStation)
  local direction = self:GetFishPlayerDirection(deskStation);
  self.model.UserInfos[direction]=nil
  self.view.m_playerGroups[direction]:IsVisible(false)
  self.view.m_playerGroups[direction]:DestroyPlayer()
  
  self.view.waitPlayer[direction]:SetActive(false)
  self.view.comePlayer[direction]:SetActive(false)
  self.view.outPlayer[direction]:SetActive(true)
  RenderMgr.Remove("outPlayerinig")
  RenderMgr.AddInterval(function()
    self.view.outPlayer[direction]:SetActive(false)
    self.view.waitPlayer[direction]:SetActive(true)
		end,"outPlayerinig",2,2.22)
end

function GameController:ClearnSceneObj()
  GameController:GetInstance().entityModel:RemoveAllFish()
  GameController:GetInstance().entityModel:RemoveAllFishMoney()
  GameController:GetInstance().entityModel:RemoveAllThunder()
  GameController:GetInstance().entityModel:RemoveAllFloatNum()

  for k,v in pairs (self.view.m_playerGroups) do
    v:RemoveAllBulletAndNet()
  end
end

function GameController:Clear()
  if self~=nil and self.entityModel ~= nil then 
    GameController:GetInstance().entityModel:RemoveAllFish()
    GameController:GetInstance().entityModel:RemoveAllFishMoney()
    GameController:GetInstance().entityModel:RemoveAllThunder()
    GameController:GetInstance().entityModel:RemoveAllFloatNum()
  end 
 
  if self~= nil and self.view~=nil then
    for k,v in pairs (self.view.m_playerGroups) do
      v:IsVisible(false)
      v:DestroyPlayer()
    end
  end
  
  if self~=nil and self.model ~= nil then
    self.model.UserInfos = {}
  end
end

function GameController:GetFishPlayerDirection( deskIndex )
if self.model.m_myServerDesk<0 then return -1 end
if self.model.m_myServerDesk>=2 then
  if deskIndex>=2 then
    return deskIndex-1
  else
    return deskIndex+3
  end
end
return deskIndex+1
end

function GameController:ParseFishTrace( msg )
  -- local msg=CMD_S_FishTrace.Decode(buffer)
  --根据id取出本地配置表
  -- msg.btFishKind=28
  local localConfig=FishConfig[msg.btFishKind]
  local vo={}
  vo.fishKind=msg.btFishKind
  vo.uid=msg.dwFishID
  vo.fishConfig=localConfig
  vo.ishongBaoFish = false
  if vo.fishKind == 100 then
    vo.ishongBaoFish = true
  end
  --检测组合鱼
  for i=1,5 do
    vo["FishKindGroup"..i]=msg["FishKindGroup"..i]
  end
  vo.TraceId = msg.usTraceId
  vo.StartPointIndex = msg.usStartPointIndex
  vo.OffsetIndex = msg.usOffsetIndex

  -- local fVo=self.model:SpawnFishVo()
  -- fVo:InitVo(vo)
  -- if msg.byChairId ~= nil then
  --   fVo.byChairId = self:GetFishPlayerDirection(msg.byChairId)
  -- end

  GameModel:GetInstance():AddFishVo(vo)
end

function GameController:Update( ... )
  -- if self.model.fishRawData and next(self.model.fishRawData) then
  --   for k,v in pairs(self.model.fishRawData) do
  --     self:ParseFishTrace(v)
  --   end
  --   self.model.fishRawData = {}
  -- end
  self.entityModel:Update()
  self.view:Update()
  ParticleManager:GetInstance():Update()
end

function GameController:RealPointToScreenPoint( xPoint,yPoint )
  xPoint = xPoint + self.model.ResolutionWidth * 0.5
  yPoint = self.model.ResolutionHeight * 0.5 - yPoint;

  if (self.model.m_myServerDesk >= 2) then--//位置大于2需要转相对坐标为真实的屏幕坐标，否则直接返回真实的屏幕坐标
    -- //2.然后再将相对的屏幕坐标转化为真实的屏幕坐标（即相对于0,1,2位置的真实的屏幕坐标）
     xPoint = self.model.ResolutionWidth - xPoint;
     yPoint = self.model.ResolutionHeight - yPoint;
  end 
  xPoint = xPoint * (1560 / self.model.ResolutionWidth);
  yPoint =  yPoint * (960 / self.model.ResolutionHeight);
  return xPoint,yPoint
end

function GameController:SendUserBtnStatus(type,data)
  local send = {}
  send.dwType = type;
  send.dwData = data;
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_USERDATA
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_UserBtnData,send,mainId,msgID)
end

function GameController:SendClickZhaDan(bulletID,data,dwBombID,chairID)
  
  local bulletId = bulletID --70000  --GameModel:GetInstance():GetBulletID()
  local curIndex = 1
  
  if  chairID == self.model.m_myClientDesk then
    local me = self.view.m_playerGroups[chairID]
    curIndex = me._curLevelIndex
    GameController:GetInstance():SendUserShoot(bulletId,0,(curIndex-1))

    local fish=GameController:GetInstance().entityModel:GetFishByFishUID(data)
    local send={}--CMD_C_HitFish
    send.dwBulletID=bulletId  
    send.dwFishID=data

    local xScreenPoint
    local yScreenPoint
    if fish ~= nil then
      local localPosition = fish:GetLocalPosition();
      xScreenPoint= localPosition.x;
      yScreenPoint= localPosition.y;
      xScreenPoint,yScreenPoint=GameController:GetInstance():RealPointToScreenPoint(xScreenPoint, yScreenPoint);
    else
      xScreenPoint = 0
      yScreenPoint = 0
    end

    send.nCaptureNetX=math.floor(xScreenPoint)
    send.nCaptureNetY=math.floor(yScreenPoint)
    send.dwBombId = dwBombID 
    GameController:GetInstance():SendSpecialBulletHitFish(send)
  end 
  
  
  -- local send = {}
  -- send.byType = type;
  -- send.dwData1 = data;
  -- send.dwData2 = 0;
  -- local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  -- local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_FISHINFO
  -- GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_ScreenHasFish,send,mainId,msgID)
end

function GameController:SendScreenExitFish(type,data)
  local send = {}
  send.byType = type;
  send.dwData1 = data;
  send.dwData2 = 0;
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_FISHINFO
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_ScreenHasFish,send,mainId,msgID)
end

function GameController:SendShootSuperBomb(data,x,y,angle)
local send = {}
send.uBombId = data;
send.sCaptureNetX =math.floor(x)
send.sCaptureNetY = math.floor(y)
send.sAngle =math.floor(angle)
send.uData = 0;
local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_SHOOTSUPERBOMB
GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_SHOOTSUPERBOMB,send,mainId,msgID)
end

function GameController:SendLockFishMsg(isLock,fishUID)
  local send = {}
  send.btLock = isLock and 1 or 0;
  send.dwFishID = fishUID;
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_LOCK_FISH
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_LockFish,send,mainId,msgID)
end
function GameController:SendUserShoot( bulletId,angle,gunLevelIndex)
  local send = {}
  send.dwBulletID = bulletId;
  send.fAngle = angle;
  send.byCannonLevelIndex = gunLevelIndex;
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_USER_SHOOT
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_UserShoot,send,mainId,msgID)
end
function GameController:SendHitFish( send )
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_HIT_FISH
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_HitFish,send,mainId,msgID)
end

function GameController:SendSpecialBulletHitFish( send )
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_BOMB_HIT_FISH
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_SpecialBulletHitFish,send,mainId,msgID)
end

function GameController:SendRobotHitFish( send)
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.SUB_C_ROBOT_HIT_FISH
  GameController:GetInstance():SendGameData(GameLuaDefine.CMD_C_RobotHitFishFromUser,send,mainId,msgID)
end
function GameController:SendGameData(templetTable,dataTable, mainId,assistantID )
  local m_usGameID=self.desk.m_usGameID
  local m_usRoomID=self.desk.m_usRoomID
  local m_usDeskIndex=self.desk.m_usDeskIndex
  Net_SendGameData(templetTable, dataTable, mainId,assistantID, m_usGameID,m_usRoomID, m_usDeskIndex)
end
function GameController:PlayUIBottomAudio(audioId)
  local config=SoundConfig[audioId]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.asUIBottom.clip=soundRes
        self.asUIBottom:Play()
      else
        local cb=function(obj,audioName)
          if obj~=nil and obj[0]~=nil then
            local audioClip=obj[0]
            GameLuaDefine.listAudioRes[audioName] = audioClip
            self.asUIBottom.clip=audioClip
            self.asUIBottom:Play()
          else
            print("游戏资源加载有问题: ",config.soundPath)
          end
        end
        resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true) 
      end
    end
  end
end
function GameController:PlayFishDieSound(soundName)
  local ass=nil
  for k,as in pairs(self.asFishList) do
    if as and not as.isPlaying then
      ass=as
      break
    end 
  end
  if ass then
    local soundRes=GameLuaDefine.listAudioRes[soundName]
    if soundRes then
      ass.volume=GameModel:GetInstance().soundVolume
      ass.clip=soundRes
      ass:Play()
    else
      local config = nil
      for k,v in pairs(SoundConfig) do
        if v.sound == soundName then
          config = v
          break
        end
      end

      if config == nil then
         config = SoundConfig[soundName]
      end
      
      if config ~= nil then 
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

function GameController:StopFishDieSound(soundID)
  -- body
  local config = SoundConfig[soundID]
  if config ~= nil then
    for i,v in pairs(self.asFishList) do
      if v.isPlaying and v.clip.name == config.sound then
        v:Stop()
        break
      end
    end
  end
end

function GameController:PlayGameAudio(audioId)
  local config=SoundConfig[audioId]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.asGame.clip=soundRes
        self.asGame:Play()
      else
        local cb=function(obj,audioName)
          if obj~=nil and obj[0]~=nil then
            local audioClip=obj[0]
            GameLuaDefine.listAudioRes[audioName] = audioClip
            self.asGame.clip= audioClip
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

function GameController:PlayPaoFenAudio(audioId,volume)
  local config=SoundConfig[audioId]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.GunFen.clip= soundRes
        self.GunFen.volume = volume
        self.GunFen:Play()
      else
        local cb=function(obj,audioName)
            if obj~=nil and obj[0]~=nil then
              local audioClip=obj[0]
              GameLuaDefine.listAudioRes[audioName] = audioClip
              self.GunFen.clip= audioClip
              self.GunFen.volume = volume
              self.GunFen:Play()
            else
              print("游戏资源加载有问题: ",config.soundPath)
            end
          end
        	resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true)
      end
    end
  end
end

function GameController:PlayBgAudio(audioId)
  --播放背景音乐
  local config=SoundConfig[audioId]
  if config then
    local soundName=config.sound
    if soundName then
      local soundRes=GameLuaDefine.listAudioRes[soundName]
      if soundRes then
        self.asBg.clip= soundRes
        self.asBg:Play()
      else
        local cb=function(obj,audioName)
            if obj~=nil and obj[0]~=nil then
              local audioClip=obj[0]
              GameLuaDefine.listAudioRes[audioName] = audioClip
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

function GameController:PlayConinAudio(audioId)
  local ass
  local config=SoundConfig[audioId]
  for k,as in pairs(self.coinList) do
    if as and not as.isPlaying then
      ass=as
      break
    end 
  end

  if ass  and config then
    
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
            print("游戏资源加载有问题: ",config.soundPath)
          end
        end
        resMgr:LoadAssetImmediate( self.gameID,config.soundPath,config.sound,typeof(AudioClip),cb,false,true)
      end
    end
  end
end 

function GameController:StopConinAudio(audioId)
  local config=SoundConfig[audioId]
  if config ~= nil then
    for i,v in pairs(self.coinList) do
      if v.isPlaying == true and v.clip.name == config.sound then
        v:Stop()
        break
      end
    end
  end
end

function GameController:ChaneMusicVolume(val)
    self.asBg.volume=val
end
function GameController:ChaneSoundVolume(val)
  
  self.asGame.volume=val
  self.asUIBottom.volume=val
  if self.view~= nil then
    self.view.m_asWave.volume=val
  end
end
function GameController:GetEntityModule( ... )
  return self.entityModel
end
function GameController:GetInstance( ... )
	if not GameController.instance then
		GameController.instance=GameController.New()
	end
	return GameController.instance
end
function GameController:__delete( ... )
  self:RemoveEvent()
  self:DeleteUpdate()
  self.DeleteList ={}
	RenderMgr.Remove("Game"..self.gameID.."Update")
  self.entityModel:Destroy()
  self.entityModel=nil
  self.model:Destroy()
  self.model=nil
  self.view:Destroy()
  self.view=nil
  
  GameObject.Destroy(self.obj)
  self.obj = nil
  
  resMgr:UnloadGameAssetBundle(self.gameID)

  
  --销毁ab包
  -- if GameLuaDefine.m_listAssetBundle then
  --   for k,path in pairs(GameLuaDefine.m_listAssetBundle) do
  --     resMgr:UnLoadAssetBundle(self.gameID,path,true)
  --   end
  -- end
  -- GameLuaDefine.m_listAssetBundle=nil
end
