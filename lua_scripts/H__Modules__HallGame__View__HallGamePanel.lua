HallGamePanel = HallGamePanel or BaseClass(LuaPanel)
function HallGamePanel:__init(callBack)
    self.mPanelType = UIPanelDefine.PanelType.HallGame
    self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGame].name
    self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGame].path
    self.mPanelID = UIPanelDefine.EWndID.HallGame
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGamePanel:InitUI()
    self.m_IsFirstEnter = true
    self.mItemGameList = {}
    self.mTempGameList = {}         --临时用下，用于排序
    self.CurrentLoadIndex = 1
    self.IsFrist = true
    local mTran = self.obj.transform

    self.mInt_CurrentItemLoadIndex = 0

    self.mGameTypeList = {}
    for i = 1, HallDefine.AllGameType.All do
        self.mGameTypeList[i] = {}
    end
    self.CurrentGametype = 0

    -- local mTranUI = mTran:Find("Content/FirstView/Left/Btn_QuanMinDaiLi")
    -- if mTranUI ~= nil then
    --     self.mQmtgView = HallQmtgView.New(mTranUI.gameObject) 
    -- end
    --self.center = mTran:Find("Content/center").transform
    --self.center = mTran:Find("Content/FirstView/GamePanel/center")

   -- Screen.width < Screen.height
    self.ThreedCamera = mTran:Find("Camera").transform
    local rate = Screen.width / 2436.0
    if rate < 1 then
        self.ThreedCamera.localPosition = Vector3(0,0,-(600+(1-rate)*120))    
    end
    mTranUI = mTran:Find("Content/GameItemSmall")
    if mTranUI ~= nil then
        self.mGameItem = mTranUI.gameObject
        self.mGameItem:SetActive(false)
    end
    mTranUI = mTran:Find("Content/FirstView/GamePanel")
    if mTranUI ~= nil then
        self.mPanelGame = mTranUI:GetComponent(typeof(UIPanel))
        self.mScrollGame = mTranUI:GetComponent(typeof(UIScrollView))
        self.mTweenAlpha = mTranUI:GetComponent(typeof(TweenAlpha))
        self.mScrollGame.dampenStrength=4
        self.mScrollGame.onDragFinished = function() self:OnScrollFinished() end
        self.mScrollBarGame = self.mScrollGame.horizontalScrollBar
        -- self.mScrollArcAniUpgrade = mTranUI:GetComponent(typeof(CS.UIScrollArcAniUpgrade))
        -- PrintLog("cccccccccccccccccccccccRRRRRRRRRRRRRRRRRRRRRRRRR",self.mScrollArcAniUpgrade==nil)
       -- self.mScrollArcAniUpgrade:SetLeftAnchor(0,-620)
    end

    mTranUI = mTran:Find("Content/FirstView/GamePanel/Right")
    if mTranUI ~= nil then
        self.mParent = mTranUI
        self.mGridGame = mTranUI:GetComponent(typeof(UIGrid))
    end

    mTranUI = mTran:Find("Content/Arrow")
    if mTranUI ~= nil then
        self.mPanelArrow = mTranUI:GetComponent(typeof(UIPanel))
    end
    mTranUI = mTran:Find("Content/Arrow")
    if mTranUI ~= nil then
        self.mPanelArrow = mTranUI:GetComponent(typeof(UIPanel))
    end

    mTranUI = mTran:Find("Content/FirstView/Left/Btn_QuanMinDaiLi/ZJM_Girl")
    if mTranUI ~= nil then
        self.mSZRenderQueue = SZUIRenderQueue.New(mTranUI.gameObject)
    end
  
    mTranUI = mTran:Find("Content/Arrow/rigeht")
    if mTranUI ~= nil then
        self.Obj_RightArrow = mTranUI.gameObject
        --UIEventListener.Get(self.Obj_RightArrow).onClick = function(obj) self:OnArrowClick(obj) end
    end
    mTranUI = mTran:Find("Content/Arrow/left")
    if mTranUI ~= nil then
        self.Obj_LeftArrow = mTranUI.gameObject
        --UIEventListener.Get(self.Obj_LeftArrow).onClick = function(obj) self:OnArrowClick(obj) end
    end
    

    mTranUI = mTran:Find("Content/Left")
    if mTranUI ~= nil then
        self.mLeft_Panel = mTranUI.gameObject
    end
    mTranUI = mTran:Find("Content/Left/All_Btn/Btn_Click")
    if mTranUI ~= nil then
        UIEventListener.Get(mTranUI.gameObject).onClick = function(obj) self:OnGameClssButtonClick(obj) end
    end

    self.mGameTypeSelectList = {}
    self.mGameTypeNomalList = {}
    mTranUI = mTran:Find("Content/Left/All_Btn/Grid")
    if mTranUI ~= nil then
       self.m_Ani_BtnLove = mTranUI:Find("Btn_Love"):GetComponent(typeof(Animation))
       self:ShowLoveBtnAni(false)
       self.mObj_AllGameClass = mTranUI.gameObject
       self.mObj_AllGameClass:SetActive(true)
       for i = 1, HallDefine.AllGameType.All do
        local tran = nil
        if i < HallDefine.AllGameType.All-3 then
            tran = mTranUI:Find("Btn_"..i)
        elseif i == HallDefine.AllGameType.Love then
            tran = mTranUI:Find("Btn_Love")
           
        elseif i == HallDefine.AllGameType.All then
            tran = mTranUI:Find("Btn_All")
        elseif i == HallDefine.AllGameType.New then
            tran = mTranUI:Find("Btn_NewTry")
            self.newPanel = tran:GetComponent(typeof(UIPanel))
            self.newAnimator = tran:GetComponent(typeof(Animator))
        elseif i== HallDefine.AllGameType.Hot then
            tran = mTranUI:Find("Btn_HotGame")
            self.hotPanel = tran:GetComponent(typeof(UIPanel))
            self.hotAnimator = tran:GetComponent(typeof(Animator))
        end
        if tran~=nil then
            UIEventListener.Get(tran.gameObject).onClick = function(obj) self:OnGameTypeButtonClick(i) end
            local bg = tran:Find("Background").gameObject
            local Background_N = tran:Find("Background_N").gameObject
            table.insert(self.mGameTypeSelectList,bg)
            table.insert(self.mGameTypeNomalList,Background_N)
            
        end
       end
    end

    mTranUI = mTran:Find("Content/Left/All_Btn/Background")
    if mTranUI ~= nil then
        self.mObj_AllGameBG = mTranUI.gameObject
        self.mObj_AllGameBG:SetActive(true)
    end
 
    self.m_UIScrollAni = mTran:Find("Content/FirstView/GamePanel"):GetComponent(typeof(UIScrollArcAniUpgrade))
    self:ShowUIScrollAni(false)
    self.m_RecoveryParent = mTran:Find("Content/FirstView/GamePanelRecovery")
    self.mFirstView = mTran:Find("Content/FirstView")
    self.mFristViewY = 0
    self.mFristViewX = 50
    self:CreateAllGame()

    self.UpdateName = "HallGamePanel:Update"

    self.m_Parent_EffectPoint = mTran:Find("Content/Effect")
    self.m_Item_EffectPoint = mTran:Find("Content/Effect/Effect_Hit").gameObject
    self.m_Item_EffectPoint:SetActive(false)
    self.m_RemoveItemEffectPoint = {}

    self:HandleIPadUI()
    --PrintLog("ggggggggggggggggggggggggg",LuaUtils.GetTimeZone(),LuaUtils.GetNextTimeZone())
   -- PrintLog("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",(1995000-500000) / (1500000))
    LuaPanel.InitUI(self)
end

function HallGamePanel:HandleIPadUI()
    if not LuaUtils.CheckIsiPad() then
        return
    end

    local mTran = self.obj.transform
    local mCamera = mTran:Find("Camera")
    if mCamera then
        mCamera.localPosition = Vector3(0,0,-830)       
    end
    local mScrollArc = mTran:Find("Content/FirstView/GamePanel"):GetComponent(typeof(UIScrollArcAniUpgrade))
    if mScrollArc then
        mScrollArc.m_ScaleFactor=0.03
    end
end

function HallGamePanel:PlayOpenAni(bool)
    -- body
    
    self.mTweenAlpha.enabled=true
    self.mTweenAlpha.duration = 0.6
	self.mTweenAlpha:ResetToBeginning()
    self.mTweenAlpha:PlayForward()
end

function HallGamePanel:ShowLoveBtnAni(bol)
    if bol then
        self.m_Ani_BtnLove.enabled = true
        self.m_Ani_BtnLove:Play()
    else
        self.m_Ani_BtnLove.enabled = false
    end
end

--收藏的游戏数据
function HallGamePanel:SetPlayerLoveGameData()
    self.mGameTypeList[HallDefine.AllGameType.Love] = {}
    for i = 1, #self.mGameTypeList[HallDefine.AllGameType.All] do
        local data_Temp = self.mGameTypeList[HallDefine.AllGameType.All][i]
        if HallGameModel:GetInstance():CheckIsLoveGame(data_Temp.vo.gameID) then
            table.insert(self.mGameTypeList[HallDefine.AllGameType.Love],data_Temp)
        end
    end
end

function HallGamePanel:RefreshLoveView()
    if  self.CurrentGametype ~= HallDefine.AllGameType.Love then
        return
      
    end
    --收藏数据
    self:SetPlayerLoveGameData()
    self:SortGameList(self.mGameTypeList[HallDefine.AllGameType.Love])
end

function HallGamePanel:OnGameTypeButtonClick(index)
    
    if self.CurrentGametype == index  then
        return 
    end
    self.CurrentGametype = index
    local count = #self.mGameTypeSelectList
    for i = 1, count do
        self.mGameTypeSelectList[i]:SetActive(index ==i)
        self.mGameTypeNomalList[i]:SetActive(index~=i)
    end
    -- if index == HallDefine.AllGameType.New then
    --     self.newAnimator:Play("GamePanel_NewTry_Click")
    -- else
    --     self.newAnimator:Play("GamePanel_NewTry")
    -- end
    
    if index == HallDefine.AllGameType.Hot then
        self.hotAnimator:Play("GamePanel_HotGame_Click")
    else
        self.hotAnimator:Play("GamePanel_HotGame_Idel")
    end
    

    --收藏数据
    if index == HallDefine.AllGameType.Love then
       self:SetPlayerLoveGameData()
    end

    self:SortGameList(self.mGameTypeList[index])
end

function HallGamePanel:OnGameClssButtonClick(go)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    local isActive =  not (self.mObj_AllGameClass.activeSelf)
    self:SetAllGameViewDisplay(isActive)
end

function HallGamePanel:SetAllGameViewDisplay(display)
    -- self.mObj_AllGameClass:SetActive(display)
    -- self.mObj_AllGameBG:SetActive(display)
    -- local xPoint = display and self.mFristViewX  or self.mFristViewX -110
    -- self.mFirstView.localPosition = Vector3(xPoint,self.mFristViewY,0)
    -- local t = display and 328 or 208
    -- self.mPanelGame:SetAnchor(self.obj,t,113,0,-127)
    --self.mScrollGame:ResetPosition()
end


--设置子panel的深度
function HallGamePanel:SetPanelDepth(depth)
    LuaPanel.SetPanelDepth(self,depth)
    -- if self.mQmtgView ~= nil then
    --     self.mQmtgView:SetDepth(depth +15)
    --     --SetPanelstartingRenderQueue(self.mQmtgView.gameObject,3250)
    -- end
    if self.mPanelGame ~= nil then 
        --self.mPanelGame.depth = depth +10
        SetPanelstartingRenderQueue(self.mPanelGame.gameObject,3200)
    end

    if self.mPanelArrow ~= nil then
        --self.mPanelArrow.depth = depth + 12
        SetPanelstartingRenderQueue(self.mPanelArrow.gameObject,3400)
    end

    if self.mSZRenderQueue ~= nil then 
        self.mSZRenderQueue:SetShaderRenderQueue(3355)
    end
    if self.mLeft_Panel ~= nil then
        SetPanelstartingRenderQueue(self.mLeft_Panel,3710)
    end

    if  self.newPanel~= nil then
        SetPanelstartingRenderQueue(self.newPanel,3210)
    end

    if  self.hotPanel~= nil then
        SetPanelstartingRenderQueue(self.hotPanel,3210)
    end
end

function HallGamePanel:ShowPanel(callBack,isPlayTween)
    LuaPanel.ShowPanel(self,callBack)
    if self.mQmtgView ~= nil then
        --self.mQmtgView:ShowPanel()
    end
    --self:SetAllGameViewDisplay(true)

    --初始化收藏状态
    for i = 1, #self.mGameTypeList[HallDefine.AllGameType.All] do
        self.mGameTypeList[HallDefine.AllGameType.All][i]:InitLoveState()
    end
    if self.m_IsFirstEnter or HallGameModel:GetInstance().IsCanResetAllGameTypeAfterLoginSuccess then
        self.m_IsFirstEnter =false
        HallGameModel:GetInstance():SetIsResetAllGameType(false)
        self:OnGameTypeButtonClick(HallDefine.AllGameType.All)
    end

    self.uiCamera = NGUITools.FindCameraForLayer(self.obj.layer)
    RenderMgr.Add(function ()
        self:Update()
    end,self.UpdateName)
end

function HallGamePanel:HidePanel( callBack,isPlayTween )
    UIManager.GetInstance():RemoveEventListener(UIManager.EventType.UIChange,self.OnUIStateChange,self)
    RenderMgr.Remove("HallGamePanel:OnUpdate")
    RenderMgr.Remove(self.UpdateName)
    self:SetAllGameViewDisplay(true)
    LuaPanel.HidePanel(self,callBack)
end

function HallGamePanel:Update()
    self:CheckInputEvent()
end

function HallGamePanel:CheckInputEvent()

	if Application.isMobilePlatform  then
		if  Input.touchCount > 0 and Input.GetTouch(0).phase == CS.UnityEngine.TouchPhase.Began then
			local vecMouse = Input.GetTouch(0).position
			local vecMouseWorld=self.uiCamera:ScreenToWorldPoint(Vector3(vecMouse.x,vecMouse.y,0))
            self:PlayEffectPoint(vecMouseWorld)
		end
	
	else
		if Input.GetMouseButtonDown(0) == true then
			local vecMouse=Input.mousePosition
			local vecMouseWorld=self.uiCamera:ScreenToWorldPoint(vecMouse)
            self:PlayEffectPoint(vecMouseWorld)
		end
	end
end

function HallGamePanel:CreateGame(gameConfig,i,itemIntiDelay)
    local vo={
        gameID=gameConfig.iGameCID,
        gameType=gameConfig.iGameType,
        gameName=gameConfig.strGameName,
        isShowBig=false,--gameConfig.iStatus>=10,
        status=gameConfig.iStatus,
        isOpen=gameConfig.iOpen==1,
        index = i,
        --caijinVo=CaijinModuleModel:GetInstance():GetCaijinVoByGameCID(gameConfig.iGameCID),
    }
    vo.callBack=function()
        self:StartLoadNextItemUi()
    end
    
    local go = GameObject.Instantiate(self.mGameItem,self.mParent)
    go:SetActive(true)
    go.name =  tostring(vo.gameID)
    go.transform.localPosition = Vector3.zero
    go.transform.localScale = Vector3.one
    go.transform.localEulerAngles = Vector3.zero
    local grid = HallGameBaseGrid.New(go,vo,itemIntiDelay)
    grid:InitUI()
    grid:SetEffectData(i%4+1)

    table.insert(self.mGameTypeList[gameConfig.iGameType],grid)

    -- 新游戏
    if HallGameModel:GetInstance():CheckIsNewGame(grid.vo) then
        table.insert(self.mGameTypeList[HallDefine.AllGameType.Hot],grid)
    end

    if gameConfig.iShowCaiJin > 0 and self.mGameTypeList[HallDefine.AllGameType.All][gameConfig.iShowCaiJin] == nil then
        self.mGameTypeList[HallDefine.AllGameType.All][gameConfig.iShowCaiJin] = grid
        --table.insert(self.mItemGameList,grid)
        self.mItemGameList[gameConfig.iShowCaiJin] = grid
    else
        table.insert(self.mTempGameList,grid)
    end
    
    return grid
end



function HallGamePanel:CreateAllGame()
    local itemIntiDelay= 0.3
    local gameConfigList=ConfigModuleModel:GetInstance():GetGameConfigList()
    --new
    local total =#gameConfigList
    local count=0
    
    for i = 1, #gameConfigList do
        local gameConfig=gameConfigList[i]
        self:CreateGame(gameConfig,i,itemIntiDelay)
    end
    local count = #self.mTempGameList
    for i = 1, count do
        table.insert(self.mItemGameList, self.mTempGameList[i])
    end
    self.mTempGameList = nil
    self:StartLoadItemUi()
end


function HallGamePanel:SortGameList(gameList)
    self:ShowUIScrollAni(false)
    self:CleanAllGameItem()
    self.mPanelGame.alpha = 0
    local count = #gameList
    for i = 1, count do
        local grid = gameList[i]
        grid:SetDisplay(true)
        grid:SetParent(self.mGridGame.transform)
        grid:CloseEffect()
    end

    RenderMgr.AddInterval(function() 
        RenderMgr.Remove("HallGamePanel:SortGameList")
        for i = 1, count do
            local grid = gameList[i]
            grid:OpenEffect()
        end
    end,"HallGamePanel:SortGameList",5,5.1)

    self:PlayOpenAni(true)
    StartCoroutine(function()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        -- yield_return(CS.UnityEngine.WaitForEndOfFrame())
        -- yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mGridGame:Reposition()
        self.mScrollGame:ResetPosition()
        self:ShowUIScrollAni(true)
        self.m_UIScrollAni:IsEnableUICenterOnChild(true)
       
        
        --处理居中效果
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        if count == 1 then
            self.m_UIScrollAni:CenterOnIndex(0)
        elseif count > 1 and count < 7 then
           self.m_UIScrollAni:CenterOnIndex(math.floor(count / 2))     
           --self.m_UIScrollAni:CenterOnTransform(self.center)
        elseif count > 6 then
            self.m_UIScrollAni:IsEnableUICenterOnChild(false)
            --yield_return(CS.UnityEngine.WaitForSeconds(1.1))
            --self.mGridGame:Reposition()
            self.mScrollGame:ResetPosition()
        end
        -- if count == 6 then
        --     self.m_UIScrollAni:CenterOnIndex(2)
        -- elseif count >= 2 and count <= 4 then
        --     self.m_UIScrollAni:CenterOnIndex(1)
        -- elseif count >= 5 then
        --     self.m_UIScrollAni:IsEnableUICenterOnChild(false)
        --     self.mGridGame:Reposition()
        --     self.mScrollGame:ResetPosition()
        -- end
    end)  
end

function HallGamePanel:CleanAllGameItem()
    local count = #self.mItemGameList
    for i = 1, count do
        local grid = self.mItemGameList[i]
        grid:SetDisplay(false)
        grid:SetParent(self.m_RecoveryParent)
    end
end


---街机按钮点击事件
function HallGamePanel:OnArcadeClick(obj)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
end


function HallGamePanel:StartLoadItemUi()
    self.mInt_CurrentItemLoadIndex=0
    self:StartLoadNextItemUi()
end

function HallGamePanel:StartLoadNextItemUi()
    --print("StartLoadNextItemUi")
    
    local item = self.mItemGameList[self.CurrentLoadIndex]
    self.CurrentLoadIndex = self.CurrentLoadIndex + 1
    if item ~= nil then
        item:StartLoadItemUI()
    end
    
end


function HallGamePanel:OnArrowClick(obj)
    if obj == self.Obj_LeftArrow then
        self.mScrollGame.contentPivot =CS.UIWidget.Pivot.Left
        self.Obj_RightArrow:SetActive(true)
    elseif obj == self.Obj_RightArrow then 
        self.mScrollGame.contentPivot =CS.UIWidget.Pivot.Right
        self.Obj_LeftArrow:SetActive(true)
    end
    obj:SetActive(false)
    
end

function HallGamePanel:OnScrollFinished()
    -- print(self.mScrollBarGame.value )
    -- if self.mScrollBarGame.value == 1 then
    --     self:SetAllGameViewDisplay(false)
    -- end
    -- self.Obj_LeftArrow:SetActive(self.mScrollBarGame.value ~= 0)
    -- self.Obj_RightArrow:SetActive(self.mScrollBarGame.value ~= 1)
end

--处理滑动列表3D效果
function HallGamePanel:ShowUIScrollAni(bol)
    if bol then
        self.m_UIScrollAni.enabled = true
        self.m_UIScrollAni:InitData()
        -- self.m_UIScrollAni:InitCallBack(function(go,index)
        --     local count = #self.mGameTypeList[self.CurrentGametype]
        --     if index == 0 then
        --         if count >= 5 then
        --             self.m_UIScrollAni:CenterOnIndex(2)
        --         elseif count == 4 or count == 3 then
        --             self.m_UIScrollAni:CenterOnIndex(1)
        --         end
              
        --     elseif index == count - 1 then
        --         if count >= 5 then
        --             self.m_UIScrollAni:CenterOnIndex(count - 3)
        --         elseif count == 4 or count == 3 then
        --             self.m_UIScrollAni:CenterOnIndex(count - 2)
        --         end
        --     end
        -- end,nil)
    else
        self.m_UIScrollAni.enabled = false
    end
end

function HallGamePanel:PlayEffectPoint(pos)
    local m_EffectPont = nil
    if #self.m_RemoveItemEffectPoint > 0 then
        m_EffectPont = self.m_RemoveItemEffectPoint[1]
        table.remove(self.m_RemoveItemEffectPoint,1)
    else
        go = GameObject.Instantiate(self.m_Item_EffectPoint,self.m_Parent_EffectPoint)
        go.transform.localPosition = Vector3.zero
        go.transform.localEulerAngles = Vector3.zero
        go.transform.localScale = Vector3.one
        m_EffectPont = EffectPoint.New(go)
    end
    m_EffectPont:Play(pos)
end

function HallGamePanel:CallBackEffectPoint(effectPoint)
    table.insert(self.m_RemoveItemEffectPoint,effectPoint)
end



function HallGamePanel:__delete( ... )
    RenderMgr.Remove("HallGamePanel:OnUpdate")
    RenderMgr.Remove(self.UpdateName)
end
