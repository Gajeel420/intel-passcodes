HallFortuneCookieModel = HallFortuneCookieModel or BaseClass(LuaModel)

function HallFortuneCookieModel:__init( ... )
	self:InitData()
end


function HallFortuneCookieModel:InitData( ... )
    self.m_StartTime = 0
    self.m_EndTime = 0
    self.m_CurrentTime = 0
    self.m_IsActive = false
    self.m_ActivityData = {}
    self.m_IsPartIn = false
    self.m_Remain_time = 0
    -- 是否可以领取
    self.m_Meet_cond = false
    self.m_IsClaimed = false

    -- 计时器
    self.m_NowTime = 0
    self.m_IntervalTime = 1
    self.m_IsStartTiming = false

    -- 是否是第一次进入
    self.m_IsFirstEnter = true
end

function HallFortuneCookieModel:ClearData()
    self.m_IsFirstEnter = true
    self.m_IsStartTiming = false
    self.m_NowTime = 0
    self.m_ActivityData = {}
    self.m_IsPartIn = false
    self.m_Remain_time = 0
    self.m_Meet_cond = false
    self.m_IsClaimed = false
    RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.FortuneCookieBtn, RedDotState.CLOSE)
end

function HallFortuneCookieModel:GetInstance()
	if HallFortuneCookieModel.instance == nil then
		HallFortuneCookieModel.instance = HallFortuneCookieModel.New()
	end
	return HallFortuneCookieModel.instance
end

function HallFortuneCookieModel:GetActivityData()
    return self.m_ActivityData
end

function HallFortuneCookieModel:GetCurrentTime()
    return self.m_CurrentTime
end

function HallFortuneCookieModel:GetIsPartIn()
    return self.m_IsPartIn
end

function HallFortuneCookieModel:GetMeet_cond()
    return self.m_Meet_cond
end

function HallFortuneCookieModel:GetIsClaimed()
    return self.m_IsClaimed
end

function HallFortuneCookieModel:GetRemain_time()
    return self.m_Remain_time
end

function HallFortuneCookieModel:GetIsFirstEnter()
    return self.m_IsFirstEnter
end

function HallFortuneCookieModel:SetIsFirstEnter(bol)
    self.m_IsFirstEnter = bol
end

function HallFortuneCookieModel:SetFortuneCookieData(data)
    if data.resCode ~= 0 then
        ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
        return
    end

    self.m_IsActive = data.isActive == 1
    if self.m_IsActive then
        self.m_StartTime = data.startTimestamp
        self.m_EndTime = data.endTimestamp
        self.m_CurrentTime = data.currentTimestamp
        self.m_ActivityData = {}
        self.m_ActivityData = data.activitySchedule
        if self.m_CurrentTime >= self.m_StartTime and self.m_CurrentTime <= self.m_EndTime then
            self.m_IsActive = true
        else
            self.m_IsActive = false
        end
        
        -- 服务器时区
        GameConst.ServerTimeZone = tonumber(data.timeZone)
        -- print("---------------  GameConst.ServerTimeZone == ",GameConst.ServerTimeZone)

        self.m_IsPartIn = self.m_ActivityData.is_part_in == 1
        self.m_Remain_time = self.m_ActivityData.remain_time
        self.m_Meet_cond = self.m_ActivityData.meet_cond == 1
        self.m_IsClaimed = self.m_ActivityData.is_claimed == 1
    end

    -- 通知活动开启关闭
    RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.FortuneCookieBtn, self.m_IsActive)
    if self.m_IsActive then
        self.m_NowTime = 0
        self.m_IsStartTiming = true
        LuaEvent:DispatchEvent(HallFortuneCookieConst.EventName_RefreshFortuneCookieState)
        if self.m_IsPartIn then
            if not self.m_IsClaimed and self.m_Meet_cond then
            else
                ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
            end
        else
            ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
        end
    else
        self.m_IsStartTiming = false
        ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
    end
end

function HallFortuneCookieModel:SetFortuneCookieOperateData(data)
    if data.rspParam.type == 801 then
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallFortuneCookie, function (panel)
            panel:ShowFortuneCookieView(data)

            if data.resCode == 0 then
                self.m_IsPartIn = true
                self.m_Remain_time = data.rspParam.remain_time
                LuaEvent:DispatchEvent(HallFortuneCookieConst.EventName_RefreshFortuneCookieState2)
            end
        end)
    elseif data.rspParam.type == 802 then
        if HallFortuneCookieController:GetInstance().view.panel then
            HallFortuneCookieController:GetInstance().view.panel:OnNotifyOperateResult(data)
        end
    end
end

function HallFortuneCookieModel:OnUpdate()
    if self.m_IsStartTiming then
        self.m_NowTime = self.m_NowTime + Time.deltaTime
        if self.m_NowTime >= self.m_IntervalTime then
            self.m_NowTime = 0
            self:HandleCurrentTimeData()
        end
    end
end

function HallFortuneCookieModel:HandleCurrentTimeData()
    self.m_CurrentTime = self.m_CurrentTime + 1
    if self.m_CurrentTime >= self.m_EndTime then
        -- 活动结束,请求服务器对一下活动信息
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie)
    end

    if self.m_Remain_time > 0 then
        self.m_Remain_time = self.m_Remain_time - 1
        LuaEvent:DispatchEvent(HallFortuneCookieConst.EventName_RefreshFortuneCookieTime, self.m_Remain_time)
    end
end
