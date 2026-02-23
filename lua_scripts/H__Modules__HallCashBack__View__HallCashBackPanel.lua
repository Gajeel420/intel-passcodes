HallCashBackPanel = HallCashBackPanel or BaseClass(LuaPanel)

function HallCashBackPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallCashBack].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallCashBack].path
	self.mPanelID = UIPanelDefine.EWndID.HallCashBack
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallCashBackPanel:InitUI()
	-- self.m_IsSelectRule = true
	-- self.m_BetLabels = {}
	-- self.m_CashBackLabels = {}
	-- self.m_AllRecordItem = {}
	--PrintLog("HallCashBackPanel:InitUI()1111111111111111111111")
	self.UpdateName = "CashBackUpdate"
	self.levItemIns = {}
    local m_Trans = self.obj.transform
	self.closeBtn = m_Trans:Find("Content/Btn_Close").gameObject
	UIEventListener.Get(self.closeBtn).onClick = function ()
        self:OnCloseButtonClick()
    end
	--PrintLog("HallCashBackPanel:InitUI()22222222222222222222222221")
	self.Btn_Collect = m_Trans:Find("Content/Btn_Collect").gameObject
	
	UIEventListener.Get(self.Btn_Collect).onClick = function ()
        self:OnClickClaim()
    end
	self.m_Box_Btn_Claim = self.Btn_Collect:GetComponent(typeof(BoxCollider))

	self.CollectSp = m_Trans:Find("Content/Btn_Collect/Collect"):GetComponent(typeof(UISprite))

	self.Collect_Time = m_Trans:Find("Content/Collect_Time").gameObject
	self.Label_Time = m_Trans:Find("Content/Collect_Time/Label_Time"):GetComponent(typeof(UILabel))
	
	self.mScroll = m_Trans:Find("Content/Scroll_View_ALLIcon/Scroll View"):GetComponent(typeof(UIScrollView))
	self.mGrid = m_Trans:Find("Content/Scroll_View_ALLIcon/Scroll View/Grid"):GetComponent(typeof(UIGrid))
	self.m_Panel_ScrollView = m_Trans:Find("Content/Scroll_View_ALLIcon/Scroll View"):GetComponent(typeof(UIPanel))
	self.Item_Icon = m_Trans:Find("Content/Scroll_View_ALLIcon/Item_Icon").gameObject
	self.Item_Icon:SetActive(false)

	self.sliderLevUp = m_Trans:Find("Content/Level_Up"):GetComponent(typeof(UISlider))

	self.texCurrentLv = m_Trans:Find("Content/Level_Up/LV_BG_C/Label"):GetComponent(typeof(UILabel))
	self.texNextLv = m_Trans:Find("Content/Level_Up/LV_BG_P/Label"):GetComponent(typeof(UILabel))

	self.recordObj = m_Trans:Find("Record").gameObject
	self.Btn_Record = m_Trans:Find("Content/Btn_Record").gameObject
	UIEventListener.Get(self.Btn_Record).onClick = function ()
        if self.recordView == nil then
			self.recordView = CashBackRecordView.New(self.recordObj)
		end
		self.recordView:SetData(self.depth)
    end
	self:InitUI1()

	LuaPanel.InitUI(self)
end

function HallCashBackPanel:InitUI1()
	self.Btn_Collect:SetActive(false)
	self.sliderLevUp.value = 0
	self.texCurrentLv.text = "LV.0"
	self.texNextLv.text = "LV.0"
end

function HallCashBackPanel:StarCountTime()
	self.currentTime = 0
	local now = os.time()
	local next_day = os.time({year=os.date("%Y",now),month=os.date("%m",now),day = os.date("%d",now) + 1,hour = 0,min = 0,sec = 0})
	local serverTime = LuaUtils.GetServerTimestamp(GameConst.ServerTimeZone,HallCashBackModel:GetInstance():GetCurrentTime())
	self.timeDiff = next_day - serverTime
	
	RenderMgr.Remove(self.UpdateName)
	RenderMgr.Add(function ()
        self:Update()
    end,self.UpdateName)
end

function HallCashBackPanel:Update()
	self.currentTime=self.currentTime+Time.deltaTime
	if self.currentTime>=1 then
		self.currentTime = 0
		self:UpdateTime()
	end
end

function HallCashBackPanel:UpdateTime()
	-- local now = os.time()
	-- local next_day = os.time({year=os.date("%Y",now),month=os.date("%m",now),day = os.date("%d",now) + 1,hour = 0,min = 0,sec = 0})
	-- local timeDiff = next_day - now
	self.timeDiff = self.timeDiff - 1
	local hours = math.floor(self.timeDiff/3600)
	if hours >= 24 then
		hours = hours - 24
	end
	local minutes = math.floor((self.timeDiff%3600)/60)
	local seconds = self.timeDiff % 60
	self.Label_Time.text = string.format("%02d:%02d:%02d",hours,minutes,seconds)
	if self.timeDiff <= 0 then
		RenderMgr.Remove(self.UpdateName)
		-- HallCashBackModel:GetInstance():SetClameState(true)
		-- ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate)
		-- self.Collect_Time:SetActive(false)
		-- self.Btn_Collect:SetActive(true)
	end
	--PrintLog(string.format("距离第二天还有:%02d:%02d:%02d",hours,minutes,seconds))
end

function HallCashBackPanel:CreateItem(index,data)
	local go
	if self.levItemIns[index] == nil then
		go = GameObject.Instantiate(self.Item_Icon,self.mGrid.transform)
		self.levItemIns[index] = CashBackItem.New(go)
	end
	self.levItemIns[index]:SetItemData(data)
end

function HallCashBackPanel:OnCloseButtonClick( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self:HidePanel()
end


function HallCashBackPanel:ShowPanel(callBack)
   	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
	--self:StarCountTime()
end

function HallCashBackPanel:ShowCashBackView01()


end

function HallCashBackPanel:ShowCashBackView02()

end

function HallCashBackPanel:RefreshCashBackView01()
    -- 取数据赋值
	PrintLog("RefreshCashBackView01==================")
   self:CreateIns()
	local data = HallCashBackModel:GetInstance():GetActivityData()
	if data then
		if data[1] then
			local bets = data[1].betAmount
			self:DealComSlier(bets)
			-- if bets > 0 then
			-- 	self:StarCountTime()
			-- end
			--self.Collect_Time:SetActive(true)
			
			self.Btn_Collect.gameObject:SetActive(false)
			self.closeBtn.gameObject:SetActive(true)
		else
			PrintLog("无数据==================")
		end
	end
end

function HallCashBackPanel:CreateIns()
	local data = HallCashBackModel:GetInstance():GetCovertLevelData()
	pt(data)
    if data then
		for i = 1, #data do
			self:CreateItem(i,data[i])
		end
		StartCoroutine(function()
			yield_return(CS.UnityEngine.WaitForEndOfFrame())
			yield_return(CS.UnityEngine.WaitForEndOfFrame())
			self.mGrid:Reposition()
			self.mScroll:ResetPosition()
		end)
    end
end

function HallCashBackPanel:RefreshCashBackView02(bets,isNeedClaim,cashBack)
	PrintLog("RefreshCashBackView02==================",isNeedClaim,cashBack,bets)
	if isNeedClaim then
		self:CreateIns()
		--PrintLog("RefreshCashBackView02==================111111111111",bets)
		self:DealComSlier(bets)
		if cashBack>0 then
			self.closeBtn.gameObject:SetActive(false)
			self.m_Box_Btn_Claim.enabled = true
			self.CollectSp.color = Color(1,1,1)
		else
			self.closeBtn.gameObject:SetActive(true)
			self.m_Box_Btn_Claim.enabled = false
			self.CollectSp.color = Color(0.42,0.42,1)
		end
	else
		self.m_Box_Btn_Claim.enabled = true
		self.CollectSp.color = Color(1,1,1)
	end
	self.Btn_Collect.gameObject:SetActive(isNeedClaim)
	--self.Collect_Time:SetActive(false)
	
	--self.Btn_Collect.gameObject:SetActive(bol)

	
	--self.Collect_Time:SetActive(not isNeedClaim)
	-- -- 通知 未领取红点显示
	-- RedDotModuleController:GetInstance():DispatchRedDotEvent(RedDotEvent.CashBackRecordNoClain, isNeedClaim)
end

local function truncate(num,decimal)
	local mult = 10 ^ decimal
	return math.floor(num*mult) / mult
end

function HallCashBackPanel:DealComSlier(bets)
	local lev,rate = HallCashBackModel:GetInstance():GetCurrentLev(bets)
	print("DealComSlier=========",lev,rate)
	self.sliderLevUp.value = truncate(rate,2)--tonumber(string.format("%.3f",rate))
	self.texCurrentLv.text = "LV."..tostring(lev)
	if lev + 1 == #self.levItemIns then
		self.texNextLv.text = "MAX"
	else
		self.texNextLv.text = "LV."..tostring(lev + 1)
	end
	for i = 1, #self.levItemIns do
		if i-1 < lev then
			self.levItemIns[i]:SetRewardActive(false)
			self.levItemIns[i]:SetRate(1)
			self.levItemIns[i]:SetAnimator(true)
			self.levItemIns[i]:SetLevBgSp(1)
			
		elseif i-1 > lev then
			if i - 1 == lev + 1 then
				self.levItemIns[i]:SetLevBgSp(3)
			else
				self.levItemIns[i]:SetLevBgSp(4)
			end
			self.levItemIns[i]:SetRewardActive(true)
			self.levItemIns[i]:SetRate(0)
			self.levItemIns[i]:SetAnimator(false)
			self.levItemIns[i]:IshowLine(i~=#self.levItemIns)
		else
			self.levItemIns[i]:SetLevBgSp(2)
			self.levItemIns[i]:SetRewardActive(lev ~= 0)
			self.levItemIns[i]:SetRate(rate)
			self.levItemIns[i]:SetAnimator(true)
		end	
	end
end

function HallCashBackPanel:OnClickClaim()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    local send = {}
	send.type = 402 -- 402=领取返利
	send.date = HallCashBackModel:GetInstance():GetClaimDate()  -- 领取日期
	ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate, send)

    self.m_Box_Btn_Claim.enabled = false
    RenderMgr.AddInterval(function ()
        self.m_Box_Btn_Claim.enabled = true
    end,"HallCashBackPanel:OnClickClaim",2,2.1)
end

function HallCashBackPanel:OnNotifyCashBackClaimResult(dataInfo)
	PrintLog("领取完毕===========================")
	-- if dataInfo == nil then
	-- 	return
	-- end
	self:HidePanel()
end


--设置子panel的深度
function HallCashBackPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	-- self.m_Panel_Content_02.depth = depth + 2
	self.m_Panel_ScrollView.depth = depth + 4
end

function HallCashBackPanel:HidePanel( )
	RenderMgr.Remove(self.UpdateName)
	self:InitUI1()
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallCashBackPanel:SystemBack()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    
end


function HallCashBackPanel:__delete( ... )

end

