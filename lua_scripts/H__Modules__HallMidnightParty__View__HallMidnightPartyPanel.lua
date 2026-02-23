HallMidnightPartyPanel = HallMidnightPartyPanel or BaseClass(LuaPanel)

function HallMidnightPartyPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallMidnightParty].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallMidnightParty].path
	self.mPanelID = UIPanelDefine.EWndID.HallMidnightParty
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallMidnightPartyPanel:InitUI()
    self.m_TOP_TipsFormatStr = ""
    self.isTipProvider = false
    local m_Trans = self.obj.transform
    --Content_01
    self.m_Go_Content_01 = m_Trans:Find("Content_01").gameObject
    self.m_Btn_No = m_Trans:Find("Content_01/Btn_No").gameObject
    UIEventListener.Get(self.m_Btn_No).onClick = function() 
        self:OnClickNo() 
    end 
    self.m_Btn_Yes = m_Trans:Find("Content_01/Btn_Yes").gameObject
    UIEventListener.Get(self.m_Btn_Yes).onClick = function() 
        self:OnClickYes() 
    end 
    self.m_Btn_Help = m_Trans:Find("Content_01/Btn_Help").gameObject
    UIEventListener.Get(self.m_Btn_Help).onClick = function() 
        self:OnClickHelp() 
    end 


    self.m_Box_Yes = m_Trans:Find("Content_01/Btn_Yes"):GetComponent(typeof(BoxCollider))
   -- self.m_Sprite_Yes = m_Trans:Find("Content_01/Btn_Yes"):GetComponent(typeof(UISprite))
    self.m_Color_Normal = Color.white
    self.m_Color_Black = Color(0.3,0.3,0.3,1)
    -- self.m_Go_Effect_Coin_Fly = m_Trans:Find("Content_01/Btn_Yes/Effect_Coin_Fly").gameObject
    -- self.m_Go_Effect_Coin_Fly:SetActive(false)

    -- self.m_Tween_Effect_Coin_Fly = self.m_Go_Effect_Coin_Fly:GetComponent(typeof(TweenPosition))
    -- self.m_Tween_Effect_Coin_Fly.enabled = false
    -- self.m_Coin_Point = m_Trans:Find("Content_01/Btn_Yes/Coin_Point")

    self.tweenScaleconten1 = m_Trans:Find("Content_01"):GetComponent(typeof(TweenScale))
    self.tweenScaleconten2 = m_Trans:Find("Content_02"):GetComponent(typeof(TweenScale))

    --Content_02
    self.m_Go_Content_02 = m_Trans:Find("Content_02").gameObject
    self.m_Panel02 = m_Trans:Find("Content_02"):GetComponent(typeof(UIPanel))
    -- self.m_Scroll_Panel = m_Trans:Find("Content_02/ScrollView"):GetComponent(typeof(UIPanel))
    -- self.m_Scroll = m_Trans:Find("Content_02/ScrollView"):GetComponent(typeof(UIScrollView))
    self.m_Btn_Close = m_Trans:Find("Content_02/Btn_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function() 
        self:OnClickClose() 
    end

    --活动时间
    self.Label_Time = m_Trans:Find("Content_02/Time"):GetComponent(typeof(UILabel))
    
    -- self.Label_Monday = m_Trans:Find("Content_02/ScrollView/All_Item/Monday"):GetComponent(typeof(UILabel))
    -- self.Label_Tuesday = m_Trans:Find("Content_02/ScrollView/All_Item/Tuesday"):GetComponent(typeof(UILabel))
    -- self.Label_Wednesday = m_Trans:Find("Content_02/ScrollView/All_Item/Wednesday"):GetComponent(typeof(UILabel))
    -- self.Label_Thursday = m_Trans:Find("Content_02/ScrollView/All_Item/Thursday"):GetComponent(typeof(UILabel))
    -- self.Label_Friday = m_Trans:Find("Content_02/ScrollView/All_Item/Friday"):GetComponent(typeof(UILabel))
    -- self.Label_Saturday = m_Trans:Find("Content_02/ScrollView/All_Item/Saturday"):GetComponent(typeof(UILabel))
    -- self.Label_Sunday = m_Trans:Find("Content_02/ScrollView/All_Item/Sunday"):GetComponent(typeof(UILabel))

    -- self.m_Label_CurrentTime = m_Trans:Find("Content_02/ScrollView/All_Item/CurrentTime"):GetComponent(typeof(UILabel))
    -- self.m_Label_CurrentTime.text = ""

    -- self.m_Label_MonetLimite = m_Trans:Find("Content_02/ScrollView/All_Item/Money"):GetComponent(typeof(UILabel))
    -- self.m_Label_MonetLimite.text = ""

    -- self.m_Label_TOP_Tips = m_Trans:Find("Content_02/TOP_Tips"):GetComponent(typeof(UILabel))
    self.m_Label_Num_Bonus = m_Trans:Find("Content_02/Num_Bonus"):GetComponent(typeof(UILabel))
    self:ShowTOP_Tips(0,0,0,0)
    
	LuaPanel.InitUI(self)
end

function HallMidnightPartyPanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
end

function HallMidnightPartyPanel:ShowMidnightPartyView01(isTipProvider)
    self:PlayTween(self.tweenScaleconten1)
    self.m_Go_Content_01:SetActive(true)
    self.m_Go_Content_02:SetActive(false)
     self.m_Box_Yes.enabled = true
    -- self.m_Sprite_Yes.color = self.m_Color_Normal
    -- self.m_Tween_Effect_Coin_Fly.enabled = false
    self.isTipProvider = isTipProvider == 2
end

function HallMidnightPartyPanel:ShowMidnightPartyView02()
    self:ShowTOP_Tips(0, 0, 0, 0)
    self.m_Go_Content_01:SetActive(false)
    self.m_Go_Content_02:SetActive(true)
    self:PlayTween(self.tweenScaleconten2)
    -- self.m_Scroll:ResetPosition()    
end

function HallMidnightPartyPanel:RefreshMidnightPartyView02()
    -- 取数据赋值
    local currentTime = HallMidnightPartyModel:GetInstance():GetCurrentTime()
    --self:ShowCurrentTime(currentTime)
    local data = HallMidnightPartyModel:GetInstance():GetActivityData()
     print("--------------  活动数据")
     pt(data)
    if data and data.active_time then
        if data.active_time then
            self:ShowActivityDateLabel(self.Label_Time, data.active_time.Monday)
            -- self:ShowActivityDateLabel(self.Label_Tuesday, data.active_time.Tuesday)
            -- self:ShowActivityDateLabel(self.Label_Wednesday, data.active_time.Wednesday)
            -- self:ShowActivityDateLabel(self.Label_Thursday, data.active_time.Thursday)
            -- self:ShowActivityDateLabel(self.Label_Friday, data.active_time.Friday)
            -- self:ShowActivityDateLabel(self.Label_Saturday, data.active_time.Saturday)
            -- self:ShowActivityDateLabel(self.Label_Sunday, data.active_time.Sunday)
        end
    
        --提示数据
        -- self.m_Label_MonetLimite.text = NumberFormat(HallGoldRateSToC(data.recharge_threshold))

        if data.payAmount and data.bous and data.withdraw_balance and data.stillNeed then
            self:ShowTOP_Tips(data.payAmount,data.bous,data.withdraw_balance,data.stillNeed)
        else
            self:ShowTOP_Tips(0, 0, 0, 0)
        end
    end
end

function HallMidnightPartyPanel:ShowCurrentTime(currentTimestamp)
    -- local time1 = LuaUtils.GetServerTimestamp(GameConst.ServerTimeZone,currentTimestamp)
    -- local timeStr = os.date("%H:%M:%S",time1)
    -- local weekNum = os.date("%w",time1)
    -- self.m_Label_CurrentTime.text = timeStr.." "..StringFormatByLanguage("Week_Title_"..weekNum)
end

function HallMidnightPartyPanel:ShowActivityDateLabel(label,data)
    local str = ""
    for i = 1, #data do
        local startTime = self:HandleTimeFormat(data[i].startTime)
        local endTime = self:HandleTimeFormat(data[i].endTime)
        
        str = str..StringFormat("{0}-{1}{2} ",startTime,endTime,"(CST)")
    end
    label.text = str
end

---处理时间格式
function HallMidnightPartyPanel:HandleTimeFormat(time)
    local str = ""
    local tt = StringSplit(time,":")
    if tt and #tt >= 2 then
        local h = tonumber(tt[1])
        local m = tonumber(tt[2])
        if h < 12 then
            if m >= 0 then
               str = string.format("%02d",h)..":"..tt[2].."AM"   
            else
                str = h.."AM"
            end
        elseif h == 12 then
            if m >= 0 then
                str = h..":"..tt[2].."PM"
            else
                str = h.."PM"
            end
        else
            h = h - 12
            if m >= 0 then
                str = h..":"..tt[2].."PM"
            else
                str = h.."PM"
            end
        end
    end
    return str
end

function HallMidnightPartyPanel:ShowTOP_Tips(payAmount,bous,withdraw_balance,stillNeed)
    payAmount = NumberFormat(HallGoldRateSToC(payAmount))
    bous = NumberFormat(HallGoldRateSToC(bous))
    withdraw_balance = NumberFormat(HallGoldRateSToC(withdraw_balance))
    stillNeed = NumberFormat(HallGoldRateSToC(stillNeed))
    
    --self.m_TOP_TipsFormatStr = StringFormatByLanguage("WagerBonus_Tips")
    --self.m_Label_TOP_Tips.text = StringFormat(self.m_TOP_TipsFormatStr,payAmount,bous,withdraw_balance,stillNeed)
    self.m_Label_Num_Bonus.text = withdraw_balance
end

function HallMidnightPartyPanel:OnNotifyOperateResult(data)
    PrintLog("OnNotifyOperateResult===")
    --操作返回成功
    if data.rspParam.type == 2 and data.rspParam.value > 0 then
        --请求刷新用户金币信息
        PlayerInfoController:GetInstance():RequestGetUserMoney()
        UIManager.GetInstance():HidePanel(self.mPanelID)
        --飞金币动画
        -- self.m_Go_Effect_Coin_Fly:SetActive(true)
        -- self.m_Tween_Effect_Coin_Fly.enabled = false
        -- self.m_Tween_Effect_Coin_Fly.from = Vector3.zero
        -- self.m_Tween_Effect_Coin_Fly.to = self.m_Coin_Point.localPosition
        -- self.m_Tween_Effect_Coin_Fly.duration = 1.5
        -- self:PlayTween(self.m_Tween_Effect_Coin_Fly,self.OnCoinFlyFinish,self)
    end
end

function HallMidnightPartyPanel:OnCoinFlyFinish()
    --请求刷新用户金币信息
    PlayerInfoController:GetInstance():RequestGetUserMoney()
    self.m_Go_Effect_Coin_Fly:SetActive(false)
    self.m_Go_Effect_Coin_Fly.transform.localPosition = Vector3.zero
    UIManager.GetInstance():HidePanel(self.mPanelID)
    
end

--- 播放Tween动画
function HallMidnightPartyPanel:PlayTween(Tween,back,context)
    Tween.enabled = true
	Tween:ResetToBeginning()
	Tween:PlayForward()
	Tween:SetOnFinished(function ()
		if back ~= nil then
			back(context)
		end
	end)
end

function HallMidnightPartyPanel:OnClickYes()
    if self.isTipProvider then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("WagerBouns_Tip_Provider"))
        self:OnClickNo()
        return
    end
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- UIManager.GetInstance():HidePanel(self.mPanelID)
    local send = {}
    send.type = 2
    send.isAgree = 1
    ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus, send)
    self.m_Box_Yes.enabled = false
    --self.m_Sprite_Yes.color = self.m_Color_Black
    RenderMgr.AddInterval(function ()
        self.m_Box_Yes.enabled = true
        --self.m_Sprite_Yes.color = self.m_Color_Normal
    end, "HallMidnightPartyPanel:OnClickYes",5,5.1)
end

function HallMidnightPartyPanel:OnClickNo()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
    local send = {}
    send.type = 2
    send.isAgree = 0
    ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus, send)
end

function HallMidnightPartyPanel:OnClickHelp()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.m_Go_Content_02:SetActive(true)
    self:PlayTween(self.tweenScaleconten2)
    --self.m_Scroll:ResetPosition()
    ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus)
end

function HallMidnightPartyPanel:OnClickClose()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if self.m_Go_Content_01.activeSelf then
        self.m_Go_Content_02:SetActive(false)
    else
        UIManager.GetInstance():HidePanel(self.mPanelID)
    end
    --UIManager.GetInstance():HidePanel(self.mPanelID)
end

--设置子panel的深度
function HallMidnightPartyPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
    self.m_Panel02.depth = depth + 2
    -- self.m_Scroll_Panel.depth = depth + 4
end

function HallMidnightPartyPanel:HidePanel( )
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallMidnightPartyPanel:SystemBack()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    if self.m_Go_Content_01.activeSelf and self.m_Go_Content_02.activeSelf then
        self.m_Go_Content_02:SetActive(false)
    elseif not self.m_Go_Content_01.activeSelf and self.m_Go_Content_02.activeSelf then
        UIManager.GetInstance():HidePanel(self.mPanelID)
    end
end


function HallMidnightPartyPanel:__delete( ... )

end

