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
LuaBehaviour1=CS.LuaBehaviour1
LuaBehaviour_PlinkoBall = CS.LuaBehaviour_PlinkoBall
Rigidbody2D = CS.UnityEngine.Rigidbody2D
ForceMode2D = CS.UnityEngine.ForceMode2D
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
Time = CS.UnityEngine.Time
LineRenderer = CS.UnityEngine.LineRenderer

function GameController:__init( ... )
  self.gameID = 10300335
  self:FindPath("GameView")
  self:FindPath("GameModel")
  self:FindPath("GameSoundController")
  self:FindPath("GameLuaDefine")
  self:FindPath("Config/SoundConfig")
  self:FindPath("Common/CommonHelp")
  self:FindPath("Common/TimerManager")
  self:FindPath("View/Help/HelpPanel")
  self:FindPath("View/Panel_Com/BtnView")
  self:FindPath("View/Coin/CoinPanel")

  self:FindPath("Msg/MSG_GameStationDataRes")

end

function GameController:FindPath(path)
  table.insert(self.RequireList,StringFormat("G/{0}/{1}",self.gameID,path))
end


function GameController:GetInstance( ... )
	if not GameController.instance then
		GameController.instance=GameController.New()
	end
	return GameController.instance
end

function GameController:AddEvent()
  LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)
  LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.BackChangeToFrontStage,self)	
  LuaEvent:AddEventListener(EventName.FRONT_TO_BACK_STAGE,self.FrontChangeToBackStage,self)	
end
  
function GameController:RemoveEvent()
  LuaEvent:RemoveEventListener(EventName.GameNetDispatchData,self.HandleData,self)
  LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.BackChangeToFrontStage,self)	
  LuaEvent:RemoveEventListener(EventName.FRONT_TO_BACK_STAGE,self.FrontChangeToBackStage,self)	
end


function GameController:Init(desk)
  GameLuaController.Init(self)
  self:GetResCount()
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
      self:ReInit(self.obj)
    else
      print("游戏资源加载有问题")
    end
  end
  resMgr:LoadPrefabEx(self.gameID,path,name,cb)

end



function GameController:GetResCount()
  if ConfigInfoMgr.useHotFunction == true then
    local panelPath ={}
    for i =1,#GameLuaDefine.GameGroup do
      panelPath[i] = GameLuaDefine.GameGroup[i]["path"]
    end
    resMgr:LoadResourcePackerInfoSet(self.gameID,panelPath ,nil)
  end
end

function GameController:ReInit(obj)
  CommonHelp.ConfigLog(false)
  --self.m_GameController_ShowWinMoney = "GameController:ShowWinMoney"
  -- print("--------------------------  初始化小游戏")
  self.model = GameModel:GetInstance()
  self.view = GameView.New(obj)
  self.gameSoundController = GameSoundController:GetInstance()

  GameLuaDefine.listAudioRes = {}
  LuaEvent:DispatchEvent(EventName.GameResLoadCompeleted)

end

--自己进入
function GameController:EnterGame(desk)
  print("------------------座位信息")
  pt(desk)
  self:RemoveEvent()
  self:AddEvent()
  self.desk=desk
  self.model.m_MyDeskStation = self.desk:GetMyVo().iDeskStation
  print("----------------self.model.m_MyDeskStation",self.model.m_MyDeskStation)
  GameSoundController:GetInstance():PlayBgAudio(GameLuaDefine.SoundID.BGM)
  -- print("--------------------------  请求游戏状态小游戏")
  self:SendGameStationDataRes()
end

function GameController:__delete( ... )
  RenderMgr.Remove(self.m_GameController_ShowWinMoney)
  self:RemoveEvent()
  self.gameSoundController:Destroy()
  self.gameSoundController = nil
  self.model:Destroy()
  self.model=nil
  self.view:Destroy()
  self.view=nil

  GameObject.Destroy(self.obj)
  self.obj = nil

  resMgr:UnloadGameAssetBundle(self.gameID)
end
  
function GameController:BackChangeToFrontStage()
  self:SendGameStationDataRes()
end
  
function GameController:FrontChangeToBackStage()
end

function GameController:SendGameData(templetTable,dataTable, mainId,assistantID )
  local m_usGameID=self.desk.m_usGameID
  local m_usRoomID=self.desk.m_usRoomID
  local m_usDeskIndex=self.desk.m_usDeskIndex
  Net_SendGameData(templetTable, dataTable, mainId,assistantID, m_usGameID,m_usRoomID, m_usDeskIndex)
end

function GameController:HandleData (context)
  --print("--------------游戏消息返回",os.time())
  if context == nil or context.m_data == nil then return end
  local clientID = context.m_data[0]
  local headStruct = context.m_data[1]
  local buffer = context.m_data[2]
  local state = context.m_data[3]
  if headStruct.dwAssistantID == GameLuaDefine.ASS_GAME_TYPE.ASS_GM_GAME_STATION then                    --游戏状态
    self:RecvGameStationDataRes(buffer)
  elseif headStruct.dwAssistantID == GameLuaDefine.ASS_GAME_TYPE.ASS_GAME_BET_RES then                   --下注返回
    self:RecvBetData(buffer)
  end
end

--#region 发送接收消息

--获取游戏状态
function GameController:SendGameStationDataRes()
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_FRAME
  GameController:GetInstance():SendGameData({},{}, mainId,1)
end

--下注请求   ---需要处理
function GameController:SendBetData(index)
  local mainId=GameLuaDefine.MAIN_MSG_TYPE.MDM_GM_GAME_NOTIFY
  local msgID=GameLuaDefine.ASS_GAME_TYPE.ASS_GAME_BET_APPLY
  local send = {}
  send.byChipIndex = self.model.m_MyBetIndex - 1
  send.byBetFaceIndex = index
  GameController:GetInstance():SendGameData(GameLuaDefine.MSG_BetDataApply,send,mainId,msgID)
end

--游戏状态返回
function GameController:RecvGameStationDataRes(buffer)
  local msg = MSG_GameStationDataRes.Decode(buffer)
  print("----------------------------  游戏状态返回")
  pt(msg)
  self.model:SetGameState(msg.byGameState)
  self.model.m_CountDown=msg.unBetTime
  self.model:SetBetListData(msg.byChipIndex, msg.vecChipAmounts)
  self.model.m_MyBalanceMoney = msg.n64BalanceCoin
  self.model.m_MyWinMoney = msg.n64WinLoseMoney
  self.view.m_BtnViewPanel:ShowPlayerMoney(msg.n64BalanceCoin)
  self.view:Start()

  LuaEvent:DispatchEvent(EventName.LoadingPanelProgress, 1.01);
  LuaEvent:DispatchEvent(EventName.SetGameStateCompeleted)

  --开始游戏

end

--下注返回
function GameController:RecvBetData(buffer)
  local msg = self:ParseMsg(GameLuaDefine.MSG_BetDataRes,buffer)
  print("---------------------  下注返回")
  pt(msg)
  if msg.byErrorCode == 0 then  --成功
    self.view.m_BtnViewPanel:ShowPlayerMoney(msg.n64BalanceCoin-msg.n64WinCoin)
    self.model:SetGameState(GameLuaDefine.GameStateType.STATE_OPEN_PRIZE)
    self.model.m_MyBalanceMoney = msg.n64BalanceCoin
    self.view.m_BtnViewPanel:StartGameCallBack()
    self.view.m_CoinPanel:HandelOpenData(msg)
  end
end

--#endregion 发送接收消息


--#region 辅助工具





--#endregion 辅助工具