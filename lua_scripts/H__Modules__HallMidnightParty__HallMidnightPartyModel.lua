HallMidnightPartyModel = HallMidnightPartyModel or BaseClass(LuaModel)

function HallMidnightPartyModel:__init( ... )
	self:InitData()
end


function HallMidnightPartyModel:InitData( ... )
    self.m_StartTime = 0
    self.m_EndTime = 0
    self.m_CurrentTime = 0
    self.m_IsActive = false
    self.m_ActivityData = {}

    -- 计时器
    self.m_NowTime = 0
    self.m_IntervalTime = 1
    self.m_IsStartTiming = false

    -- 是否是第一次进入
    self.m_IsFirstEnter = true
end

function HallMidnightPartyModel:ClearData()
    self.m_IsFirstEnter = true
    self.m_IsStartTiming = false
    self.m_NowTime = 0
    self.m_ActivityData = {}
    --RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.MidnightPartyEnterBtn, RedDotState.CLOSE)
end

function HallMidnightPartyModel:GetInstance()
	if HallMidnightPartyModel.instance == nil then
		HallMidnightPartyModel.instance = HallMidnightPartyModel.New()
	end
	return HallMidnightPartyModel.instance
end

function HallMidnightPartyModel:GetActivityData()
    return self.m_ActivityData
end

function HallMidnightPartyModel:GetCurrentTime()
    return self.m_CurrentTime
end

function HallMidnightPartyModel:SetMidnightPartyData(data)
    if data.resCode ~= 0 then
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
    end

    if HallGroupController:GetInstance().view.panel then
		HallGroupController:GetInstance().view.panel:SetPartyIshow(self.m_IsActive)
	end
--PrintLog("WWWWWWWWWWWWWWWWWW",self.m_IsActive)
    -- 通知活动开启关闭
    --RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.MidnightPartyEnterBtn, self.m_IsActive)
    if self.m_IsActive then
        self.m_NowTime = 0
        self.m_IsStartTiming = true
        if self.m_IsFirstEnter then
            UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMidnightParty, function (panel)
                panel:ShowMidnightPartyView02()
                panel:RefreshMidnightPartyView02()
            end) 
        else
            if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
                if HallMidnightPartyController:GetInstance().view.panel then
                    HallMidnightPartyController:GetInstance().view.panel:RefreshMidnightPartyView02()
                end
            else
                -- UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMidnightParty, function (panel)
                --     panel:ShowMidnightPartyView02()
                --     panel:RefreshMidnightPartyView02()
                -- end) 
            end
        end
    else
        self.m_IsStartTiming = false
        ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
        if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallMidnightParty)
        end
    end
    self.m_IsFirstEnter = false
end

function HallMidnightPartyModel:SetMidnightPartyOperateData(data)
    if data.resCode == 1 then
        -- 返回码 0=成功，1=失败
        if data.rspParam.type == 2 then
            -- 操作失败
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Failure"))
        end
        return
    elseif data.resCode == 14 then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("WagerBouns_Tip_Time_End"))
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallMidnightParty)
        return
    end

    -- 显示 1=显示MidnightParty 界面(客户端主动请求返回或者服务器主动下发)，2=操作是否同意返回结果 
    if data.rspParam.type == 1 then
        if data.rspParam.value ~= 0 then
            if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
                if HallMidnightPartyController:GetInstance().view.panel then
                    HallMidnightPartyController:GetInstance().view.panel:ShowMidnightPartyView01(data.rspParam.value)
                end
            else
                UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMidnightParty, function (panel)
                    panel:ShowMidnightPartyView01(data.rspParam.value)
                end) 
            end
        else
            if not UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
                ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
            end
        end
    elseif data.rspParam.type == 2 then
        if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
            if HallMidnightPartyController:GetInstance().view.panel then
                HallMidnightPartyController:GetInstance().view.panel:OnNotifyOperateResult(data)
            end
        end
    end
end

function HallMidnightPartyModel:OnUpdate()
    if self.m_IsStartTiming then
        self.m_NowTime = self.m_NowTime + Time.deltaTime
        if self.m_NowTime >= self.m_IntervalTime then
            self.m_NowTime = 0
            self:HandleCurrentTimeData()
        end
    end
end

function HallMidnightPartyModel:HandleCurrentTimeData()
    self.m_CurrentTime = self.m_CurrentTime + 1
    if self.m_CurrentTime >= self.m_EndTime then
        -- 活动结束,请求服务器对一下活动信息
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_MidnightParty)
    end

    -- 通知View 
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallMidnightParty) then
        if HallMidnightPartyController:GetInstance().view.panel then
            HallMidnightPartyController:GetInstance().view.panel:ShowCurrentTime(self.m_CurrentTime)
        end
    end
end
