HallNotifyPanel = HallNotifyPanel or BaseClass(LuaPanel)

function HallNotifyPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallNotify].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallNotify].path
	self.mPanelID = UIPanelDefine.EWndID.HallNotify
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.Notify--页面层级
	self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallNotifyPanel:InitUI()
	local mTran = self.obj.transform
	self.ScrollPanelList = {}
	self.ScrollPanelList1 = {}

    self.nIndex = 1 --轮播到第几条
    self.nTotal = 0 --一共有多少条
    self.mIsNotifying = false
	self.mPanel_Notify = mTran:Find("Content/Content/NotifyPanel").gameObject
	self.mPanel_Notify:SetActive(false)
	self.parent = mTran:Find("Content/Content")
	self.objContent = mTran:Find("Content/Content/BG").gameObject
	self.count = HallNotifyController:GetInstance().model.disPlayCount
	
	for i = 1 ,self.count do
		local go = GameObject.Instantiate(self.mPanel_Notify)
		go:SetActive(false)
		local goTran = go.transform
		goTran.parent = self.parent
		local scrollPanel = HallNotifyScrollPanel.New(go)
		scrollPanel:SetIndex(i)
		table.insert(self.ScrollPanelList,scrollPanel)
	end

	self.Content_Game = mTran:Find("Content/Content02").gameObject
	self.objGame = mTran:Find("Content/Content02/BG").gameObject
	self.gameNotify = mTran:Find("Content/Content02/NotifyPanel").gameObject
	self.gameNotify:SetActive(false)
	for i = 1 ,self.count do
		local go = GameObject.Instantiate(self.gameNotify)
		go:SetActive(false)
		local goTran = go.transform
		goTran.parent = self.Content_Game.transform
		local scrollPanel = HallNotifyScrollPanel.New(go)
		scrollPanel:SetIndex(i)
		table.insert(self.ScrollPanelList1,scrollPanel)
	end

	LuaEvent:AddEventListener(EventName.GameSceneNoNotifyMove,self.OnNotifyMove,self) 
	local mObj_TopScore = mTran:Find("Content/Content/TopScorePanel").gameObject
	self.mTopScoreView = HallTopScoreView.New(mObj_TopScore)
	local mObj_TopScore02 = mTran:Find("Content/Content02/TopScorePanel").gameObject
	self.mTopScoreView02 = HallTopScoreView.New(mObj_TopScore02)

	self:HandleUI_LiuHaiPing()
	LuaPanel.InitUI(self)	
end

function HallNotifyPanel:HandleUI_LiuHaiPing()
	local mTrans = self.Content_Game.transform
	local IsLiuHaiPing = LuaUtils.CheckIsLiuHaiPing()
	local offect_w = 0
	local width_UI =  LuaUtils.GetUIRealWidth()
	if IsLiuHaiPing then
		offect_w = LuaUtils.GetOffectDistance()
	end
	mTrans.localPosition = Vector3(mTrans.localPosition.x, mTrans.localPosition.y - offect_w, 0)
end

function HallNotifyPanel:OnNotifyMove(context)
	if context and context.m_data then
		local x = context.m_data[0]
		local y = context.m_data[1]
		self.parent.localPosition = Vector3(x,y,0)
	end
end

function HallNotifyPanel:Update()
	if SceneManager:GetInstance().CurrentScreenOrientationType ~= SceneManager.ScreenOrientationType.Protrait then
		if self.mIsNotifying  then
			if self.nTotal > 0 then
				for i =1,self.count do
					if self.ScrollPanelList[i].mIsNotifying == false then
						local data = HallNotifyController:GetInstance().model.mNotifyList[1]
						if data ~= nil then
							table.remove(HallNotifyController:GetInstance().model.mNotifyList,1)
							self.objContent:SetActive(true)
							self.parent.gameObject:SetActive(true)
							self.Content_Game:SetActive(false)
							-- self.mTopScoreView:DisplayView(true)
							self.nTotal = #HallNotifyController:GetInstance().model.mNotifyList
							self.ScrollPanelList[i]:SetNotyData(data,function (index)
								local mTotal = #HallNotifyController:GetInstance().model.mNotifyList
								self:NotifyDisplay()
								self.ScrollPanelList[index].mIsNotifying = false
							end)
							break
						end
					end
				end
			end
		end
	else
		if self.mIsNotifying  then
			if self.nTotal > 0 then
				for i =1,self.count do
					if self.ScrollPanelList[i].mIsNotifying == false then
						local data = HallNotifyController:GetInstance().model.mNotifyList[1]
						if data ~= nil then
							table.remove(HallNotifyController:GetInstance().model.mNotifyList,1)
							self.objGame:SetActive(true)
							self.parent.gameObject:SetActive(false)
							self.Content_Game:SetActive(true)
							self.nTotal = #HallNotifyController:GetInstance().model.mNotifyList
							self.ScrollPanelList1[i]:SetNotyData(data,function (index)
								local mTotal = #HallNotifyController:GetInstance().model.mNotifyList
								self:NotifyDisplayVertical()
								self.ScrollPanelList1[index].mIsNotifying = false
							end)
							break
						end
					end
				end
			end
		end
	end
	
end

function HallNotifyPanel:NotifyDisplay()
	do
		return
	end
	local mTotal = #HallNotifyController:GetInstance().model.mNotifyList
	if mTotal > 0 then
		self.objContent:SetActive(true)
		self.mTopScoreView:DisplayView(true)
	else
		if not self.ScrollPanelList[1].obj.activeSelf and not HallNotifyModel.GetInstance().IsTopScorePanelOpne then
			self.objContent:SetActive(false)
			self.mTopScoreView:DisplayView(false)
		end
	end
end


function HallNotifyPanel:NotifyDisplayVertical()
	do
		return
	end
	local mTotal = #HallNotifyController:GetInstance().model.mNotifyList
	if mTotal > 0 then
		self.objGame:SetActive(true)
		self.mTopScoreView02:DisplayView(true)
	else
		if not self.ScrollPanelList1[1].obj.activeSelf and not HallNotifyModel.GetInstance().IsTopScorePanelOpne then
			self.objGame:SetActive(false)
			self.mTopScoreView02:DisplayView(false)
		end
	end
end


--设置子panel的深度
function HallNotifyPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	for i=1,self.count do
		self.ScrollPanelList[i]:SetPanelDepth(depth)
		self.ScrollPanelList1[i]:SetPanelDepth(depth)
	end
	self.mTopScoreView:SetViewDepth(depth)
	self.mTopScoreView02:SetViewDepth(depth)
end

function HallNotifyPanel:HidePanel( )
	for i = 1, self.count do
		if self.ScrollPanelList[i].mIsNotifying  then
			self.ScrollPanelList[i]:MoveEnd()
		end
		if self.ScrollPanelList1[i].mIsNotifying  then
			self.ScrollPanelList1[i]:MoveEnd()
		end
	end
	RenderMgr.Remove("HallNotifyPanel:Update")    
	--HallNotifyController:GetInstance().model:SubNotifyList(self.nIndex)
	self.nIndex = 1 --轮播到第几条
    self.nTotal = 0 --一共有多少条
    self.mIsNotifying = false
	LuaPanel.HidePanel(self)
end



function HallNotifyPanel:ShowPanel(callBack)
	RenderMgr.Add(function () self:Update() end,"HallNotifyPanel:Update")
	LuaPanel.ShowPanel(self, callBack)	
end

function HallNotifyPanel:ResetPanel( ... )
	-- body
	
	self.nIndex = 1 --轮播到第几条
    self.nTotal = 0 --一共有多少条
    self.mIsNotifying = false
    HallNotifyController:GetInstance().model.mNotifyList = nil
    HallNotifyController:GetInstance().model.mNotifyList = {}
    for i=1, self.count  do
    	self.ScrollPanelList[i]:ResetPanel()
    	self.ScrollPanelList1[i]:ResetPanel()
    end
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
end

function HallNotifyPanel:OpenHallNotifyPanel()

	self.nTotal = #HallNotifyController:GetInstance().model.mNotifyList --公告内容列表
	if self.mIsNotifying == false then
		if self.nTotal == 0 then return end   
		self.mIsNotifying = true
		LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)     
		UIManager:GetInstance():ShowPanel(self.mPanelID)
	else
	end
end


function HallNotifyPanel:__delete( ... )
	self.nIndex = nil
	self.nTotal = nil
end
