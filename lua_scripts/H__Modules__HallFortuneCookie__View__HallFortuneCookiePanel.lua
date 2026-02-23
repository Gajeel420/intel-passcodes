HallFortuneCookiePanel = HallFortuneCookiePanel or BaseClass(LuaPanel)

function HallFortuneCookiePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFortuneCookie].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFortuneCookie].path
	self.mPanelID = UIPanelDefine.EWndID.HallFortuneCookie
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallFortuneCookiePanel:InitUI()
    local m_Trans = self.obj.transform
    self.m_Go_Content = m_Trans:Find("Content").gameObject
    self.m_Ani_Content = m_Trans:Find("Content"):GetComponent(typeof(Animator))

    self.m_Btn_Close = m_Trans:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function() 
        self:OnClickClose() 
    end

    self.m_Label_Money = m_Trans:Find("Content/Cookie_Open/Label_Money"):GetComponent(typeof(UILabel))
    self.m_Label_Tip = m_Trans:Find("Content/Cookie_Open/Tip"):GetComponent(typeof(UILabel))
    self.m_Label_FlyMoney = m_Trans:Find("Content/Cookie_Open/Recieved_Effect/Fly_Coin/Label_Money"):GetComponent(typeof(UILabel))
    self.m_Label_time = m_Trans:Find("Content/Cookie_Open/Label_time"):GetComponent(typeof(UILabel))

	self.m_Btn_Claim = m_Trans:Find("Content/Cookie_Open/Button_Claim"):GetComponent(typeof(UIButton))
    -- self.m_Btn_Claim.enabled = false
    UIEventListener.Get(self.m_Btn_Claim.gameObject).onClick = function() 
        self:OnClickClaim() 
    end

    self.m_Go_Tap_Recieved =  m_Trans:Find("Content/Cookie_Open/Tap_Recieved").gameObject
    self.m_Go_Icon_Receieved =  m_Trans:Find("Content/Cookie_Open/Icon_Receieved").gameObject

    self.m_Go_Recieved_Effect = m_Trans:Find("Content/Cookie_Open/Recieved_Effect").gameObject
    self.m_Tween_Fly_Coin = m_Trans:Find("Content/Cookie_Open/Recieved_Effect/Fly_Coin"):GetComponent(typeof(TweenTransform))

    LuaEvent:AddEventListener(HallFortuneCookieConst.EventName_RefreshFortuneCookieTime,self.RefreshFortuneCookieTime,self)

	LuaPanel.InitUI(self)
end

function HallFortuneCookiePanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self.m_Go_Content:SetActive(false)
    self.m_Go_Recieved_Effect:SetActive(false)
    self.m_Btn_Claim.isEnabled = false
	LuaPanel.ShowPanel(self,callBack)
end

function HallFortuneCookiePanel:ShowFortuneCookieView(data)
    if data.resCode == 0 then
        self.m_Go_Content:SetActive(true)
        local is_part_in = HallFortuneCookieModel:GetInstance():GetIsPartIn()
        if not is_part_in then
            self.m_Ani_Content:Play("Ani_CookieOpen", 0, 0)
        else
            self.m_Ani_Content:Play("Ani_CookieOpened", 0, 0)
        end
        self:SetFortuneCookieState(data)
    else
        UIManager.GetInstance():HidePanel(self.mPanelID)
        -- resCode = -244  参与失败
       -- UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("FortuneCookieTip_Cannot_Participate"))
       local showBoxData ={}
       showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
       local str = StringFormatByLanguage("FortuneCookieTip_Cannot_Participate")
       showBoxData.context = str
       showBoxData.enterCB = function() 
           -- LuaEvent:DispatchEvent(EventName.OPEN_RECHARGEPANEL,{1})
       end--：点击确定返回；
       showBoxData.cancelCB = nil
       showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
       showBoxData.isHideAll = false--:隐藏所有按钮; 
       showBoxData.isShowBtnClose = false--:界面的关闭按钮
       UIManager:GetInstance():ShowMessageBox(showBoxData)
    end
end

function HallFortuneCookiePanel:SetFortuneCookieState(data)
    self:SetReward(data.rspParam.reward)
    self:SetFortuneCookieTip(data.rspParam.today_bet_cond)
    if data.rspParam.is_claimed == 0 then
        self.m_Go_Tap_Recieved:SetActive(false)
        self.m_Go_Icon_Receieved:SetActive(false)
        self.m_Btn_Claim.gameObject:SetActive(true)
        self.m_Label_time.gameObject:SetActive(true)
        if data.rspParam.meet_cond == 0 then
            self.m_Btn_Claim.isEnabled = false
        else
            self.m_Btn_Claim.isEnabled = true
        end
    else
        self.m_Go_Tap_Recieved:SetActive(true)
        self.m_Go_Icon_Receieved:SetActive(true)
        self.m_Btn_Claim.gameObject:SetActive(false)
        self.m_Label_time.gameObject:SetActive(false)
    end
end

function HallFortuneCookiePanel:RefreshFortuneCookieTime(context)
    if context == nil then return end
    if context.m_data == nil then return end
    local remain_time = context.m_data[0]
    self:SetFortuneCookieTime(remain_time)
end

function HallFortuneCookiePanel:SetReward(money)
    self.m_Label_Money.text = NumberFormat(HallGoldRateSToC(money))
    self.m_Label_FlyMoney.text = NumberFormat(HallGoldRateSToC(money))
end

function HallFortuneCookiePanel:SetFortuneCookieTime(time)
    self.m_Label_time.text = GetTimeString(time)
end

function HallFortuneCookiePanel:SetFortuneCookieTip(money)
    self.m_Label_Tip.text = StringFormat(StringFormatByLanguage("FortuneCookieTip"), NumberFormat(HallGoldRateSToC(money)))
end

function HallFortuneCookiePanel:OnClickClaim()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    -- 请求
    local send = {}
    send.type = 802
    ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie, send)
    self.m_Btn_Claim.isEnabled = false
end

function HallFortuneCookiePanel:OnNotifyOperateResult(data)
    if data.resCode == 0 then
        if data.rspParam.rewards > 0 then
            self:SetReward(data.rspParam.rewards)
            self.m_Go_Recieved_Effect:SetActive(true)
            self:PlayTween(self.m_Tween_Fly_Coin, self.OnCoinFlyFinish, self)

            -- 领取状态
            self.m_Go_Tap_Recieved:SetActive(true)
            self.m_Go_Icon_Receieved:SetActive(true)
            self.m_Btn_Claim.gameObject:SetActive(false)
            self.m_Label_time.gameObject:SetActive(false)
        end
    else
        self.m_Btn_Claim.isEnabled = true
        if data.resCode == -261 then
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("WagerBouns_Tip_Time_End"))
        elseif data.resCode == -301 then  -- 设备领取超限
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Device_Get_Limit"))
        else
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Device_Get_Limit_2"))
        end
        UIManager.GetInstance():HidePanel(self.mPanelID)
    end
end

function HallFortuneCookiePanel:OnClickClose()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallFortuneCookiePanel:OnCoinFlyFinish()
    --请求刷新用户金币信息
    PlayerInfoController:GetInstance():RequestGetUserMoney()
    self.m_Go_Recieved_Effect:SetActive(false)

    RenderMgr.Remove("HallFortuneCookiePanel:OnCoinFlyFinis")
    RenderMgr.AddInterval(function()
        UIManager.GetInstance():HidePanel(self.mPanelID)
    end,"HallFortuneCookiePanel:OnCoinFlyFinish", 1.5, 2.5)
end

--- 播放Tween动画
function HallFortuneCookiePanel:PlayTween(Tween,back,context)
    Tween.enabled = true
	Tween:ResetToBeginning()
	Tween:PlayForward()
	Tween:SetOnFinished(function ()
		if back ~= nil then
			back(context)
		end
	end)
end

--设置子panel的深度
function HallFortuneCookiePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallFortuneCookiePanel:HidePanel( )
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallFortuneCookiePanel:__delete( ... )

end

