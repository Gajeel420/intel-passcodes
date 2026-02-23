HallGroupPanel = HallGroupPanel or BaseClass(LuaPanel)

function HallGroupPanel:__init(callBack)
   
    self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGroup].name
    self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGroup].path
	self.mPanelID = UIPanelDefine.EWndID.HallGroup
    self.mPanelType = UIPanelDefine.PanelType.TopPnael
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGroupPanel:InitUI()
    local mTran = self.obj.transform
    self.CurrentBindButtonType = HallGroupModel.BuildSuccessType.Nomar
    
    self.model=HallGroupModel:GetInstance()
   
    self.mPanel_BtnScroll = mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView").gameObject:GetComponent(typeof(UIPanel))

    self.mObj_ActiveButton=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Activity").gameObject
    self.mObj_ActiveButton:SetActive(false)
    UIEventListener.Get(self.mObj_ActiveButton).onClick = function() self:OnClickActiveButton() end
    self.mObj_ActiveRedPoint=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Activity/Background/Sprite").gameObject
    self:SetMailRedPoint(false)

    self.mObj_MailButton=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_New").gameObject
    self.mObj_MailButton:SetActive(false)
    UIEventListener.Get(self.mObj_MailButton).onClick = function() self:OnClickMailButton() end
    self.mobj_MailRedPoint = mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_New/Background/Sprite").gameObject
    self.mobj_MailRedPoint:SetActive(false)

    self.mObj_RankButton=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Rank").gameObject
    self.mObj_RankButton:SetActive(false)
    UIEventListener.Get(self.mObj_RankButton).onClick = function() self:OnClickRankButton() end


    self.mObj_ServiceButton=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Service").gameObject
    self.mObj_ServiceButton:SetActive(false)
    UIEventListener.Get(self.mObj_ServiceButton).onClick = function() self:OnClickServiceButton() end
    self.mObj_ServiceRedPoint=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Service/Background/Sprite").gameObject
    self.mObj_ServiceRedPoint:SetActive(false)

    self.mButton_Bank = mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Bank").gameObject
    self.mButton_Bank:SetActive(false)
    UIEventListener.Get(self.mButton_Bank).onClick = function() self:OnClickBankButton() end
    self.mPanel_LeftScrollView =  self.mPanel_BtnScroll:GetComponent(typeof(UIScrollView))
    self.mGrid_LeftBtn =  mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid").gameObject--:GetComponent(typeof(UIGrid))

    self.mObj_ExchangeButton=mTran:Find("Content/Bottom/TweenBottom/Down/ScrollView/Grid/Btn_Income").gameObject
    self.mObj_ExchangeButton:SetActive(false)
    UIEventListener.Get(self.mObj_ExchangeButton).onClick = function() self:OnClickExchangeButton() end

   

    self.mObj_SetButton=mTran:Find("Content/Top/Tween/Btn_Set").gameObject
    self.mObj_SetButton:SetActive(false)
    UIEventListener.Get(self.mObj_SetButton).onClick = function() 
        self:OnClickSetButton() 
    end

    -- self.mObj_GiveButton=mTran:Find("Content/Left/Tween/Btn_Gift").gameObject
    -- UIEventListener.Get(self.mObj_GiveButton).onClick = function() self:OnClickGiveButton() end

    self.mObj_WashCode = mTran:Find("Content/Top/Tween/Btn_WashCode").gameObject
    self.mObj_WashCode:SetActive(false)
    UIEventListener.Get(self.mObj_WashCode).onClick = function() self:OnClickWashCode() end
    
    self.mObj_ProxyButton=mTran:Find("Content/Top/Tween/Btn_Promoto").gameObject
    self.mObj_ProxyButton:SetActive(false)
    UIEventListener.Get(self.mObj_ProxyButton).onClick = function() self:OnClickProxyButton() end
  
   

    self.mObj_RechargeButton=mTran:Find("Content/Bottom/TweenBottom/Right/Btn_Shop").gameObject
    self.mObj_RechargeButton:SetActive(false)
   UIEventListener.Get(self.mObj_RechargeButton).onClick = function() self:OnClickRechargeButton() end


    self.mObj_FirstCharge=mTran:Find("Content/Top/Tween/Btn_FirstChargeRebate").gameObject
    self.mObj_FirstCharge:SetActive(false)
    UIEventListener.Get(self.mObj_FirstCharge).onClick = function(go) self:OnFirstChargeButton(go) end


    self.mObj_RisterPayment=mTran:Find("Content/Top/Tween/Btn_RegisterPayment").gameObject
    self.mObj_RisterPayment:SetActive(false)
    UIEventListener.Get(self.mObj_RisterPayment).onClick = function() self:OnClickRegisterPayment() end
    
    self.mTopGrid = mTran:Find("Content/Top/Tween").gameObject:GetComponent(typeof(UIGrid))

    LuaEvent:AddEventListener(EventName.HallEmaiNote,self.RefreshMailPoint,self)
    LuaEvent:AddEventListener(EventName.ACCOUNT_BindAccountCompeled,self.OnBindPhoneSuccessed,self)
    self.mObj_SaveGame =  mTran:Find("Content/Left/Tween/Btn_SaveGame").gameObject
    UIEventListener.Get(self.mObj_SaveGame).onClick = function() self:OnButtonSaveGame() end


    --local mAni_Recharge = mTran:Find("Content/Bottom/TweenBottom/Right/Btn_Shop/Label_CZ").gameObject
    --self.mSZRenderQueue_Recharge = SZUIRenderQueue.New(mAni_Recharge)


    self.mObj_FortunaMisson=mTran:Find("Content/Top/Tween/Btn_GodOfWealth").gameObject
    self.mObj_FortunaMisson:SetActive(false)
    UIEventListener.Get(self.mObj_FortunaMisson).onClick = function() self:OnClickFortunaMission() end

    local list_tweenList={}
    local tweenPosition_rightTop=mTran:Find("Content/Top/Tween"):GetComponent(typeof(TweenPosition))
    table.insert(list_tweenList, tweenPosition_rightTop)
    -- local tweenPosition_bottom=mTran:Find("Content/Bottom/TweenBottom"):GetComponent(typeof(TweenPosition))
    -- table.insert(list_tweenList, tweenPosition_bottom)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
    

    self.m_Btn_Modify = mTran:Find("Content/Top/Tween/Btn_Modify").gameObject
    UIEventListener.Get(self.m_Btn_Modify).onClick = function() 
        self:OnClickModifyPassword() 
    end

    self.m_BtnTiXian = mTran:Find("Content/Bottom/TweenBottom/Right/Btn_Wirhdraw").gameObject
    self.m_BtnTiXian:SetActive(false)
    UIEventListener.Get(self.m_BtnTiXian).onClick = function() self:OnClickTiXian() end

    self.m_BtnFacebook= mTran:Find("Content/Top/Tween/Btn_Facebook").gameObject
    UIEventListener.Get(self.m_BtnFacebook).onClick = function() self:OnClickFacebook() end

    self.m_BtnCopyLink= mTran:Find("Content/Top/Tween/Btn_CopyLink").gameObject
    UIEventListener.Get(self.m_BtnCopyLink).onClick = function() self:OnClickCopyLink() end

    self.m_Btn_Support= mTran:Find("Content/Top/Tween/Btn_Support").gameObject
    UIEventListener.Get(self.m_Btn_Support).onClick = function() self:OnClickSupport() end

    --转盘
    self.m_Btn_Turntable = mTran:Find("Content/Top/Tween/Btn_Turntable").gameObject
    UIEventListener.Get(self.m_Btn_Turntable).onClick = function() self:OnButtonTurntable() end
    self.m_Btn_Turntable:SetActive(false)

    self.mObjTurntableTimes = mTran:Find("Content/Top/Tween/Btn_Turntable/Background/Time").gameObject
    -- self.mObjTurntableTimes:SetActive(false)

    self.mLabelTurntableTime = mTran:Find("Content/Top/Tween/Btn_Turntable/Background/Time/Time"):GetComponent(typeof(UILabel))
    self.mLabelTurntableTime.text = ""

    self.mTweenScaleTurntableBack = mTran:Find("Content/Top/Tween/Btn_Turntable/Background/Turntable/Turntable_Back"):GetComponent(typeof(TweenScale))
    self.mTweenScaleTurntableBack.enabled = false
    self.mTweenRatationTurntable = mTran:Find("Content/Top/Tween/Btn_Turntable/Background/Turntable/Turntable_Back/Turn_Table"):GetComponent(typeof(TweenRotation))
    self.mTweenRatationTurntable.enabled = false

    self.updateName = "HallGroupPanel:LuckWhellUpdate"
    self.IsWaitStateCountDown = false
    self.mLuckRemainSeconds = 0 

    -- 排行榜
    self.m_Btn_Rank= mTran:Find("Content/Top/Tween/Btn_Rank").gameObject
    UIEventListener.Get(self.m_Btn_Rank).onClick = function() 
        self:OnClickOpenRank() 
    end

    self.Btn_Party= mTran:Find("Content/Top/Tween/Btn_Party").gameObject
    UIEventListener.Get(self.Btn_Party).onClick = function() 
        self:OnClickOpenParty() 
    end
    self.Btn_Party:SetActive(false)
    self.Btn_LevelBonus= mTran:Find("Content/Top/Tween/Btn_LevelBonus").gameObject
    UIEventListener.Get(self.Btn_LevelBonus).onClick = function() 
        
        self:OnClickLevelBonus() 
    end
    self.Btn_LevelBonus:SetActive(false)

    -- FortuneCookie
    self.m_Btn_FortuneCookie = mTran:Find("Content/Top/Tween/Btn_FortuneCookie").gameObject
    self.m_Ani_FortuneCookie = mTran:Find("Content/Top/Tween/Btn_FortuneCookie/Background"):GetComponent(typeof(Animator))
    self.m_Label_FortuneCookieTime = mTran:Find("Content/Top/Tween/Btn_FortuneCookie/Background/Label_time"):GetComponent(typeof(UILabel))
    RedDotModuleController:GetInstance():AddRedDotEvent(RedDotEvent.FortuneCookieBtn, self.m_Btn_FortuneCookie, RedDotTargetType.GAMEOBJECT)
	LuaEvent:AddEventListener(HallFortuneCookieConst.EventName_RefreshFortuneCookieState,self.RefreshFortuneCookieState,self)
	LuaEvent:AddEventListener(HallFortuneCookieConst.EventName_RefreshFortuneCookieState2,self.RefreshFortuneCookieState2,self)
	LuaEvent:AddEventListener(HallFortuneCookieConst.EventName_RefreshFortuneCookieTime,self.RefreshFortuneCookieTime,self)
    self.m_Btn_FortuneCookie:SetActive(false)
    UIEventListener.Get(self.m_Btn_FortuneCookie).onClick = function() 
        self:OnClickFortuneCookie() 
    end 

    -- 邀请链接
    self.m_Btn_Invite = mTran:Find("Content/Top/Tween/Btn_Invite").gameObject
    UIEventListener.Get(self.m_Btn_Invite).onClick = function() 
        self:OnClickInvite() 
    end 

    LuaPanel.InitUI(self)
end

function HallGroupPanel:SetPartyIshow(bol)
    self.Btn_Party:SetActive(bol)
end

function HallGroupPanel:SetLevBonusIshow(bol)
    self.Btn_LevelBonus:SetActive(bol)
end

function HallGroupPanel:OnClickInvite()
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallInvite)
end

function HallGroupPanel:RefreshFortuneCookieState()
    local is_part_in = HallFortuneCookieModel:GetInstance():GetIsPartIn()
    if not is_part_in then
        self.m_Ani_FortuneCookie:Play("Ani_TipToReward", 0, 0)
    else
        self.m_Ani_FortuneCookie:Play("Ani_Idle", 0, 0)
        local remain_time = HallFortuneCookieModel:GetInstance():GetRemain_time()
        self:SetFortuneCookieTime(remain_time)

        local meet_cond = HallFortuneCookieModel:GetInstance():GetMeet_cond()
        local is_claimed = HallFortuneCookieModel:GetInstance():GetIsClaimed()
        if not is_claimed and meet_cond then
            self:OnClickFortuneCookie()
        end
    end
end

function HallGroupPanel:RefreshFortuneCookieState2()
    local is_part_in = HallFortuneCookieModel:GetInstance():GetIsPartIn()
    if not is_part_in then
        self.m_Ani_FortuneCookie:Play("Ani_TipToReward", 0, 0)
    else
        self.m_Ani_FortuneCookie:Play("Ani_Idle", 0, 0)
        local remain_time = HallFortuneCookieModel:GetInstance():GetRemain_time()
        self:SetFortuneCookieTime(remain_time)
    end
end

function HallGroupPanel:RefreshFortuneCookieTime(context)
    if context == nil then return end
    if context.m_data == nil then return end
    local remain_time = context.m_data[0]
    self:SetFortuneCookieTime(remain_time)
end

function HallGroupPanel:SetFortuneCookieTime(time)
    self.m_Label_FortuneCookieTime.text = GetTimeString(time)
end

function HallGroupPanel:OnClickFortuneCookie()
    -- 请求
    local send = {}
    send.type = 801
    ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie, send)
end

function HallGroupPanel:OnClickOpenParty()
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMidnightParty, function (panel)
        panel:ShowMidnightPartyView02()
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus)
    end) 
end

function HallGroupPanel:OnClickLevelBonus()
    HallCashBackModel:GetInstance():SetClientState(true)
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack, function (panel)
        --panel:RefreshCashBackView01()
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate)
    end) 
end

function HallGroupPanel:OnClickOpenRank()
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRank)
end

function HallGroupPanel:OnButtonTurntable(gameObject)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTurntable)
end

function HallGroupPanel:OnClickFacebook()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:FacebookShareLink(1,ConfigInfoMgr.FacebookShareLink)
end

function HallGroupPanel:OnClickCopyLink()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	PhoneManager:MyClipDataToClipboard(ConfigInfoMgr.FacebookShareLink)
    UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Copy_Success"))
end

function HallGroupPanel:OnClickSupport()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:SupportWhatsApp(ConfigInfoMgr.SupportMobile)
end

function HallGroupPanel:OnClickTiXian()
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallWithdraw)
end

function HallGroupPanel:OnClickModifyPassword()
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallModifyPassword)
end

---首充返利
function HallGroupPanel:OnFirstChargeButton(obj)
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if GetLeroleadtime() > 600 then
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallFirstChargeRebate)
    else
        UIManager.GetInstance():ShowNoteMessage("统计中请稍后...",1)
    end
end



function HallGroupPanel:RefreshMailPoint()
    self:SetMailRedPoint(true)
end

function HallGroupPanel:OnBindPhoneSuccessed()
    self.mObj_RisterPayment:SetActive(false)
    self.mObj_FirstCharge:SetActive(ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe)
    if not ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe then
        self:SetButtonVisible(self.mObj_FortunaMisson, ConfigModuleModel.GetInstance().IsShowFortunaMission)
    end
    --self.mTopGrid:Reposition()
end

function  HallGroupPanel:OnButtonSaveGame(obj)
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallSaveGame)
;end

---活动按钮
function HallGroupPanel:OnClickActiveButton(  )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    HallActiveCentreController.GetInstance():ShowActiveCenterPanel()
    self.mObj_ActiveRedPoint:SetActive(false)
end

---点击邮件按钮
function HallGroupPanel:OnClickMailButton(  )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMail)
    self.mobj_MailRedPoint:SetActive(false) 
end

---点击排行榜事件
function HallGroupPanel:OnClickRankButton(  )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallWealthList) 
end


---点击客服事件
function HallGroupPanel:OnClickServiceButton(  )
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
   UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallService)
   -- self.mObj_ServiceRedPoint:SetActive(false)
  -- print("aaaaaaaaaeeeeeeeeeeeeeeeeeee  ",CS.I2.Loc.LocalizationManager.GetTranslation("SendSucess"))
 -- UIManager:GetInstance():ShowNoteMessage("SendSucess")
  
       
end

--点击OnButton_Bank按钮事件
function HallGroupPanel:OnClickBankButton( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():OpenHallBankPanel()   
end

---点击兑换按钮事件
function HallGroupPanel:OnClickExchangeButton( )
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    --UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchange)
    if PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone then
        --UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchange)
        HallExchangeController.GetInstance().model.GetExchanageConfig()
    else
        local showBoxData ={}
        showBoxData.title = "温馨提示"
        showBoxData.context ="为了保护您的财产安全，请先绑定您的手机号！"
        showBoxData.enterCB = function() 
            HallBindPhoneModel:GetInstance():AddEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
            UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindPhone)
            self.CurrentBindButtonType = HallGroupModel.BuildSuccessType.ExchangeButton
        end--：点击确定返回；
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮; 
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
        UIManager:GetInstance():ShowMessageBox(showBoxData)
    end
end

--设置按钮点击事件
function HallGroupPanel:OnClickSetButton()
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallSetting)
    -- UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallAdPop)
    --HallAdPopModel:GetInstance():GetAd()
end

function HallGroupPanel:OnClickWashCode()
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallWashCode)
end

--推广按钮点击事件
function HallGroupPanel:OnClickProxyButton()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPromotion)
end


--赠送礼物按钮点击事件
function HallGroupPanel:OnClickGiveButton( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	if PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone then
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGive)
    else
        local showBoxData ={}
        showBoxData.title = "温馨提示"
        showBoxData.context ="为了保护您的财产安全，请先绑定您的手机号！"
        showBoxData.enterCB = function() 
            HallBindPhoneModel:GetInstance():AddEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
            self.CurrentBindButtonType = HallGroupModel.BuildSuccessType.GiveButton
            UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindPhone)
        end--：点击确定返回；
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮; 
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
        UIManager:GetInstance():ShowMessageBox(showBoxData)

	end
end

---点击充值按钮事件
function HallGroupPanel:OnClickRechargeButton( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    StoreModuleController:GetInstance():RequiredPayMoneyList(function()
        self:RequiredPayMoneyListCallBack()
    end)
end

function HallGroupPanel:RequiredPayMoneyListCallBack()
    -- if HallVipRechargeTipsModel.GetInstance():GetIsShowVipRechargeTips() == 1 then
    --     UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallVipRechargeTips)
    -- else
    -- end
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end

---点击注册送金按钮事件
function HallGroupPanel:OnClickRegisterPayment( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindPhone)
end


---点击财神任务按钮事件
function HallGroupPanel:OnClickFortunaMission( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallFortunaMission)
end


function HallGroupPanel:UIFunctionSwitch()

    self:SetButtonVisible(self.mObj_ActiveButton, ConfigModuleModel.GetInstance().IsShowActiveCenter)
    self:SetButtonVisible(self.mObj_RankButton, ConfigModuleModel.GetInstance().IsShowRank)
    self:SetButtonVisible(self.mObj_MailButton, ConfigModuleModel.GetInstance().IsShowMail)
    self:SetButtonVisible(self.mObj_ServiceButton, ConfigModuleModel.GetInstance().IsShowService)
    self:SetButtonVisible(self.mButton_Bank, ConfigModuleModel.GetInstance().IsShowBank)
    self:SetButtonVisible(self.mObj_ExchangeButton, ConfigModuleModel.GetInstance().IsShowExchange)

    self:SetButtonVisible(self.mObj_WashCode, ConfigModuleModel.GetInstance().isShowWashCode)
    self:SetButtonVisible(self.mObj_ProxyButton, ConfigModuleModel.GetInstance().IsShowTuiGuang)
    self:SetButtonVisible(self.mObj_GiveButton, ConfigModuleModel.GetInstance().IsShowGive)
    self:SetButtonVisible(self.mObj_SetButton, ConfigModuleModel.GetInstance().IsShowSetting)
    
    --self:SetButtonVisible(self.mObj_FirstCharge,true)

    if not(PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone) then
       -- self:SetButtonVisible(self.mObj_RisterPayment, ConfigModuleModel.GetInstance().IsShowRegisterPayment)
        if ConfigModuleModel.GetInstance().IsShowRegisterPayment then
            self:SetButtonVisible(self.mObj_FirstCharge,false)
        else
            
            self:SetButtonVisible(self.mObj_FirstCharge,ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe)
            if not ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe then
                self:SetButtonVisible(self.mObj_FortunaMisson, ConfigModuleModel.GetInstance().IsShowFortunaMission)
            end
        end
    else
       -- self:SetButtonVisible(self.mObj_RisterPayment, false)
        self:SetButtonVisible(self.mObj_FirstCharge,ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe)
        if not ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe then
            self:SetButtonVisible(self.mObj_FortunaMisson, ConfigModuleModel.GetInstance().IsShowFortunaMission)
        end
    end

    self:SetButtonVisible(self.mObj_RechargeButton, ConfigModuleModel.GetInstance().IsShowRecharge)
    
    local index = 0 
    if ConfigModuleModel.GetInstance().IsShowActiveCenter then
        index = index + 1
    end
    if ConfigModuleModel.GetInstance().IsShowRank then
        index = index +1
    end
    
    if ConfigModuleModel.GetInstance().IsShowService then
        index = index +1
    end
    if ConfigModuleModel.GetInstance().IsShowBank then
        index = index +1
    end
    if ConfigModuleModel.GetInstance().IsShowExchange then
        index = index + 1
    end
    if ConfigModuleModel.GetInstance().IsShowMail then
        index = index + 1
    end
    --self.mGrid_LeftBtn.cellWidth = (self.mPanel_BtnScroll.width / index)
    --self.mGrid_LeftBtn:Reposition()
    --self.mTopGrid:Reposition()
    
    StartCoroutine(function ()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        
        self.mPanel_LeftScrollView:ResetPosition()
    end)
    
   
end

---绑定成功回调
function HallGroupPanel:OnBindPhoneSuccess()
    self.mObj_FirstCharge:SetActive(ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe)
    if not ConfigModuleModel.GetInstance().IsShowFirstRechargeRabe then
        self:SetButtonVisible(self.mObj_FortunaMisson, ConfigModuleModel.GetInstance().IsShowFortunaMission)
    end
    HallBindPhoneModel:GetInstance():RemoveEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
    if self.CurrentBindButtonType == HallGroupModel.BuildSuccessType.GiveButton then
        UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGive)
    elseif self.CurrentBindButtonType == HallGroupModel.BuildSuccessType.ExchangeButton then
        HallExchangeController.GetInstance().model.GetExchanageConfig()
    end
    self.CurrentBindButtonType = HallGroupModel.BuildSuccessType.Nomar
end


function HallGroupPanel:SetMailRedPoint(display)
    self:SetButtonVisible(self.mobj_MailRedPoint,display)
end



function HallGroupPanel:RemoveEvent( ... )
    HallBindPhoneModel:GetInstance():RemoveEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
    LuaEvent:RemoveEventListener(EventName.ACCOUNT_BindAccountCompeled,self.OnBindPhoneSuccessed(),self)
end


function HallGroupPanel:SetButtonVisible(go,isVisible)
    if go then go:SetActive(isVisible) end
end


function HallGroupPanel:ShowPanel( ... )
    LuaPanel.ShowPanel(self)
    RenderMgr.Add(function () self:mUpdate() end,self.updateName)
    self:RequestLuckyWhell()
    self:ReqFortuneCookieConfig()
    StartCoroutine(function ()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self:UIFunctionSwitch()
        self.mTweenPlayer:ParallelPlay(false,function ()
            -----零食解决下进入游戏出来不显示问题
            self.mPanel_BtnScroll.gameObject:SetActive(false)
            self.mPanel_BtnScroll.gameObject:SetActive(true)
        end)
    end)
end

function HallGroupPanel:ReqFortuneCookieConfig()
    if not HallFortuneCookieModel:GetInstance():GetIsFirstEnter() then
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie)
    end
    HallFortuneCookieModel:GetInstance():SetIsFirstEnter(false)
end

function HallGroupPanel:LuckyWhellBack()
    LuaEvent:RemoveEventListener(EventName.LuckyWhellCallBack,self.LuckyWhellBack,self)
    if HallTurnTableModel:GetInstance().mLuckyWhellResult ~= nil then
        self.m_Btn_Turntable:SetActive(HallTurnTableModel:GetInstance().mLuckyWhellResult.m_ucPrizeStatus > 0)
        
        HallTurntableController:GetInstance().view.panel:SetTurnTablePanelData()
        self:SetTurnTableBtnState(HallTurnTableModel:GetInstance().mLuckyWhellResult.m_ucPrizeStatus == 1)
        if HallTurnTableModel:GetInstance().mLuckyWhellResult.m_ucPrizeStatus == 2 then
            self.IsWaitStateCountDown = true
            self.mLuckRemainSeconds = HallTurnTableModel:GetInstance().mLuckyWhellResult.m_unRemainSeconds
            self.mLabelTurntableTime.text = GetTimeString(self.mLuckRemainSeconds)
        end
        
    end
end

function HallGroupPanel:mUpdate()
    if self.IsWaitStateCountDown then
        if self.mLuckRemainSeconds >= 0 then
            self.mLuckRemainSeconds = self.mLuckRemainSeconds - Time.deltaTime
            self.mLabelTurntableTime.text = GetTimeString(math.ceil(self.mLuckRemainSeconds))
        else
            self:SetTurnTableBtnState(true)
        end
    end
end

function HallGroupPanel:SetTurnTableBtnState(Available)
    self.mObjTurntableTimes:SetActive(not Available)
    self.mTweenScaleTurntableBack.enabled = Available
    self.mTweenRatationTurntable.enabled = Available
    self.m_Btn_Turntable:GetComponent(typeof(BoxCollider)).enabled = Available
end

function HallGroupPanel:RequestLuckyWhell()
    self.m_Btn_Turntable:SetActive(false)
    LuaEvent:AddEventListener(EventName.LuckyWhellCallBack,self.LuckyWhellBack,self)
    HallTurnTableModel:GetInstance():RequestLuckyWheel(0)
end

function HallGroupPanel:HidePanel( callBack,isPlayTween)
    UIManager.GetInstance():RemoveEventListener(UIManager.EventType.UIChange,self.OnUIStateChange,self)
    self.mLuckRemainSeconds = 0
    self.m_Btn_Turntable:SetActive(false)
    RenderMgr.Remove(self.updateName)
    if isPlayTween==nil or isPlayTween==true then
        self.mTweenPlayer:ParallelPlay(true,function ()
            self:SetVisible(false)
            if callBack then
                callBack()
            end
        end)
    else
        self:SetVisible(false)
        if callBack then
            callBack()
        end
    end
end

function HallGroupPanel:SetPanelDepth(depth)
    LuaPanel.SetPanelDepth(self,depth)
    
    --self.mPanel_BtnScroll.depth = depth + 2
    --self.mSZRenderQueue_Recharge:SetShaderRenderQueue(depth+3)
    SetPanelstartingRenderQueue(self.mPanel_BtnScroll.gameObject,self:GetPanelstartingRenderQueue()+2)
    RenderMgr.Remove("RoomController:ReqGetRoomLevel")
end

function HallGroupPanel:__delete( ... )
    self:RemoveEvent()
end