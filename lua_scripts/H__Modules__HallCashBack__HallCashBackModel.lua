HallCashBackModel = HallCashBackModel or BaseClass(LuaModel)

function HallCashBackModel:__init( ... )
	self:InitData()
end


function HallCashBackModel:InitData( ... )
    self.currentLev = 0 
    self.m_StartTime = 0
    self.m_EndTime = 0
    self.m_CurrentTime = 0
    self.m_IsActive = false
    self.m_ActivityData = {}
    self.m_Date = ""
    -- 计时器
    self.m_NowTime = 0
    self.m_IntervalTime = 1
    self.m_IsStartTiming = false
    self.isNeedGetClamState = false
    self.recordData = {}
    self.clientClick = flase
    self.clickCount = 0
    self.isClaimList = {}
end

function HallCashBackModel:SetClientState(bol)
    self.clientClick = bol
end

function HallCashBackModel:SetClameState(bol)
    self.isNeedGetClamState = bol
end

function HallCashBackModel:GetClameState()
   return self.isNeedGetClamState
end

function HallCashBackModel:ClearData()
    self.m_IsStartTiming = false
    self.m_NowTime = 0
    self.m_ActivityData = {}
    self.isNeedGetClamState = false
    self.recordData = {}
    self.isClaimList = {}
    --RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.CashBackEnterBtn, RedDotState.CLOSE)
end

function HallCashBackModel:GetRecordData()
    return self.recordData
end

function HallCashBackModel:GetInstance()
    --PrintLog("wwwwwwwwwwwwwwwwwwwwwwwwwwwww",25/100)
	if HallCashBackModel.instance == nil then
		HallCashBackModel.instance = HallCashBackModel.New()
	end
	return HallCashBackModel.instance
end

function HallCashBackModel:GetClaimDate()
    return self.m_Date
end

function HallCashBackModel:GetIsClaim()
    return not (self.m_Date == nil or self.m_Date == "" or #self.m_Date == 0)
end

function HallCashBackModel:GetActivityData()
    return self.m_ActivityData
end

function HallCashBackModel:GetCovertLevelData()
    if self.m_ActivityData then
        self.levData = {}
      --  self.levData[1] = {reward = 0,min = 0,max =0,lev = 0}
        for i = 1, #self.m_ActivityData do
            local t = self.m_ActivityData[i]
            local v = {}
            v.lev = i - 1
            -- if i == #self.m_ActivityData then
            --     --local minBet = NumberFormat(HallGoldRateSToC(t.min))
            --    --math.floor(tonumber(minBet)*tonumber(t.rebateRate)*10)
            -- else
			--     --local maxBet = NumberFormat(HallGoldRateSToC(t.max))
            --     v.reward = tonumber(t.rebateRate)--math.floor(tonumber(maxBet)*tonumber(t.rebateRate))
            -- end
            v.reward = tonumber(t.rebateRate)
            v.min = t.min
            v.max = t.max
            --self.levData[i] = v
            table.insert(self.levData,v)
        end
    end
    pt(self.levData)
    return self.levData
end

function HallCashBackModel:GetLvByCashBack(num)
    num = tonumber(NumberFormat(HallGoldRateSToC(num)))
    if self.levData then
        for i =1, #self.levData do
            if self.levData[i].reward == num then
                return i - 1
            end
        end
    end
    return 0
end

function HallCashBackModel:GetCurrentLev(bets)
    if self.levData then
        for i = #self.levData, 1, -1 do
            if bets >= self.levData[i].min then
                if self.levData[i].max == -1 then
                    return i-1,1
                else
                    return i-1,(bets-self.levData[i].min) / (self.levData[i].max - self.levData[i].min)
                end             
            end
        end
    end
    return 0,0
end

function HallCashBackModel:IsMaxLev(bets)
    return bets >= self.levData[#self.levData].min
end

function HallCashBackModel:GetCurrentTime()
    return self.m_CurrentTime
end

function HallCashBackModel:SetCashBackData(data)
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
        -- local now = os.time()
        -- local next_day = os.time({year=os.date("%Y",now),month=os.date("%m",now),day = os.date("%d",now) + 1,hour = 0,min = 0,sec = 0})
        -- local serverTime = LuaUtils.GetServerTimestamp(GameConst.ServerTimeZone,self.m_CurrentTime)
        -- local timeDiff = next_day - serverTime
        
        
        -- local hours = math.floor(timeDiff/3600)
        -- local minutes = math.floor((timeDiff%3600)/60)
        -- local seconds = timeDiff % 60
        --PrintLog("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww",timeDiff)
       -- PrintLog("wwwwwwwaaaaaaaaaaaaaaa",timeDiff,hours,minutes,seconds,os.date("%H:%M:%S",timeDiff))
        --PrintLog("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",LuaUtils.GetNextTimeZone(),os.date("%H:%M:%S",timeDiff))
        -- print("---------------  GameConst.ServerTimeZone == ",GameConst.ServerTimeZone)
    end
	if HallGroupController:GetInstance().view.panel then
		HallGroupController:GetInstance().view.panel:SetLevBonusIshow(self.m_IsActive)
	end
    -- 通知活动开启关闭
   -- RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.CashBackEnterBtn, self.m_IsActive)
    if self.m_IsActive then
        self.m_NowTime = 0
        self.m_IsStartTiming = true
        -- if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) and self.clickCount > 1 then
        --     if HallCashBackController:GetInstance().view.panel then
        --         HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
        --         return
        --     end
        -- end
        --请求记录数据
        local send = {}
        send.type = 401 -- 401=获取返利记录
        ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate, send)
        -- if self.isNeedGetClamState then
        --     self.isNeedGetClamState = false
        --      --请求记录数据
        --     local send = {}
        --     send.type = 401 -- 401=获取返利记录
        --     ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate, send)
        -- else
        --     -- UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack,function (panel)
        --     --     panel:RefreshCashBackView01()
        --     -- end)
        -- end  
    else
        ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
        self.m_IsStartTiming = false
    end
end

function HallCashBackModel:SetCashBackOperateData(data)
    if data.resCode == 1 then
        self.clientClick = false
        -- 返回码 0=成功，1=失败
        if data.rspParam.type == 2 then
            -- 操作失败
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Failure"))
        end
        return
    elseif data.resCode == 14 then
        --self.clientClick = false
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("WagerBouns_Tip_Time_End"))
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallCashBack)
        return
    end

    if data.rspParam.type == 401 then  -- 获取返利记录
        local isClaim = false
        local bets = 0
        local cashBack = 0
        if data.rspParam.records == nil  or type(data.rspParam.records) == "function" or #data.rspParam.records == 0 then
            if HallCashBackController:GetInstance().view.panel then
                HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
            end
            ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
            return
        end
        self.recordData = data.rspParam.records
        local v = data.rspParam.records[1]
        if not v.status then
            isClaim = true
            self.m_Date = v.date
            bets = tonumber(v.bets)--tonumber(NumberFormat(HallGoldRateSToC(value.bets)))
            cashBack = tonumber(v.cash_back)
        end
        PrintLog("SetCashBackOperateData=11111111111",isClaim,self.m_Date,bets,cashBack)
        -- for i = 1, #data.rspParam.records do
        --     local v = data.rspParam.records[i]
        --     if not v.status then
        --         isClaim = true
        --         self.m_Date = v.date
        --         bets = tonumber(v.bets)--tonumber(NumberFormat(HallGoldRateSToC(value.bets)))
        --         cashBack = tonumber(v.cash_back)
        --         --PrintLog("wwwwwwwwwwwwwwwwww",tonumber(NumberFormat(HallGoldRateSToC(value.bets))))
        --         break
        --     end
        -- end

        if isClaim then
            local getClaim = PlayerPrefs.GetInt(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID..self.m_Date,0)
            if getClaim == 1 then
                if self.isNeedGetClamState then
                    self.isNeedGetClamState = false
                    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
                    return
                end
                if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
                    if HallCashBackController:GetInstance().view.panel then
                        HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
                    end
                else
                    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack, function (panel)
                        panel:RefreshCashBackView01()
                    end) 
                end
            else
                if cashBack == 0 then
                    --self.isClaimList[self.m_Date] = 1
                    PlayerPrefs.SetInt(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID..self.m_Date,1)
                end
                if getClaim == 1 then
                     if self.clientClick then
                        self.clientClick = false
                        if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
                            if HallCashBackController:GetInstance().view.panel then
                                HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
                            end
                        else
                            UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack, function (panel)
                                panel:RefreshCashBackView01()
                            end) 
                        end
                     end
                else
                    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
                        if HallCashBackController:GetInstance().view.panel then
                            HallCashBackController:GetInstance().view.panel:RefreshCashBackView02(bets,isClaim,cashBack)
                        end
                    else
                        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack, function (panel)
                            HallCashBackController:GetInstance().view.panel:RefreshCashBackView02(bets,isClaim,cashBack)
                        end) 
                    end
                end
            end 
        else
            PrintLog("SetCashBackOperateData=22222222222222")
            if self.isNeedGetClamState then
                self.isNeedGetClamState = false
                ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
                return
            end
            PrintLog("SetCashBackOperateData=33333333333333333")
            if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
                if HallCashBackController:GetInstance().view.panel then
                    PrintLog("SetCashBackOperateData=44444444444444444444")
                    HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
                end
            else
                PrintLog("SetCashBackOperateData=55555555555555555555")
                UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack, function (panel)
                    panel:RefreshCashBackView01()
                end) 
            end
        end
  
        -- if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
        --     PrintLog("UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack)=================")
        --     self.clientClick = false
        --     if HallCashBackController:GetInstance().view.panel then
        --         if isClaim then
        --             HallCashBackController:GetInstance().view.panel:RefreshCashBackView02(bets,isClaim,cashBack)
        --         else
        --             HallCashBackController:GetInstance().view.panel:RefreshCashBackView01()
        --         end         
        --     end
        -- else
        --     if isClaim then
        --         UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCashBack,function (panel)
        --             panel:RefreshCashBackView02(bets,isClaim,cashBack)
        --         end)
        --     else
        --         if self.clientClick then
        --             self.clientClick = false
        --         else
        --             ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
        --         end
        --         --self:GetCovertLevelData()
        --     end      
        -- end
    elseif data.rspParam.type == 402 then  -- 领取返利
        self.isNeedGetClamState = false
        self.clientClick = false
        PlayerInfoController:GetInstance():RequestGetUserMoney()
        if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.HallCashBack) then
            if HallCashBackController:GetInstance().view.panel then
                HallCashBackController:GetInstance().view.panel:OnNotifyCashBackClaimResult(data.rspParam.record)
            end
        end
        if data.rspParam.records == nil  or type(data.rspParam.records) == "function" or #data.rspParam.records == 0 then
            return
        end
        for key, value in pairs(data.rspParam.record) do
            if value.date == self.m_Date then
                PlayerPrefs.SetInt(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID..self.m_Date,1)
                --self.isClaimList[self.m_Date] = 1
            end
        end
    end
end

function HallCashBackModel:OnUpdate()
    if self.m_IsStartTiming then
        self.m_NowTime = self.m_NowTime + Time.deltaTime
        if self.m_NowTime >= self.m_IntervalTime then
            self.m_NowTime = 0
            self:HandleCurrentTimeData()
        end
    end
end

function HallCashBackModel:HandleCurrentTimeData()
    self.m_CurrentTime = self.m_CurrentTime + 1
    if self.m_CurrentTime >= self.m_EndTime then
        self:ClearData()
        -- 活动结束,请求服务器对一下活动信息
        ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate)
    end
end

function HallCashBackModel:ClearData()
    self.clientClick = flase
    self.clickCount = 0
    self.isClaimList = {}
end
