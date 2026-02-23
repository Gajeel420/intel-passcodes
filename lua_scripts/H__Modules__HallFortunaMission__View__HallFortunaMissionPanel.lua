HallFortunaMissionPanel = HallFortunaMissionPanel or BaseClass(LuaPanel)

function HallFortunaMissionPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFortunaMission].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallFortunaMission].path
	self.mPanelID = UIPanelDefine.EWndID.HallFortunaMission
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallFortunaMissionPanel:InitUI()
	local mTran = self.obj.transform
	self.mTitle_itemList = {}
	self.mTask_ItemList = {}
	self.mCurrentIndex = 0
	local mTranUI = mTran:Find("Content/Btn_Back/Background")
	if mTranUI ~= nil then
		local mObj_Close = mTranUI.gameObject
		UIEventListener.Get(mObj_Close).onClick = function() self:OnButtonClose() end
	end
	mTranUI = mTran:Find("Content/ScrollView/Bank_Title")
	if mTranUI ~= nil then
		self.mParent_title = mTranUI
		self.mTitle_Grid = mTranUI:GetComponent(typeof(UIGrid))
	end

	mTranUI = mTran:Find("Content/ScrollView")
	if mTranUI ~= nil then
		self.mTitle_ScrollView = mTranUI:GetComponent(typeof(UIScrollView))
	end

	mTranUI = mTran:Find("Content/ScrollView/Bank_Title/Toggle_Item")
	if mTranUI ~= nil then
		self.mObj_Title =  mTranUI.gameObject
		self.mObj_Title:SetActive(false)
	end

	----------------------------------任务列表-----------------------------------
	mTranUI = mTran:Find("Content/TaskList/UI_Item")
	if mTranUI ~= nil then
		self.mObj_TaskItem =  mTranUI.gameObject
		self.mObj_TaskItem:SetActive(false)
	end

	mTranUI = mTran:Find("Content/TaskList/ScrollView/Grid")
	if mTranUI ~= nil then
		self.mParent_Task = mTranUI
		self.mTask_Grid = mTranUI:GetComponent(typeof(UIGrid))
	end

	mTranUI = mTran:Find("Content/TaskList/ScrollView")
	if mTranUI ~= nil then
		self.mTask_ScrollList = mTranUI:GetComponent(typeof(UIScrollView))
	end

	LuaPanel.InitUI(self)
end

----------------------------------------------------------任务大类型（标题）处理-----------------------------------------------------------------

----查询任务大类型返回
function HallFortunaMissionPanel:QueryTaskGeneralTypeResp(data)
	self:CleanAllTaskGenral()
	if data.m_sResultId == 0 then
		for i = 1, data.m_ucTypeCount do
			local item = self.mTitle_itemList[i]
			if item == nil then
				item = self:CreateTitleItem(i)
			end
			item:SetTitle(data.TaskGenealTypeList[i],i)
		end
		--self.mBtn_Grid
		self.mTitle_Grid:Reposition()
		self.mTitle_ScrollView:ResetPosition()
		self:OnTaskTitleClick(1)
	else
		print("请求任务大类型错误",data.m_sResultId)
	end
end

----创建任务大类型（标题）
function HallFortunaMissionPanel:CreateTitleItem(index)
	local go = GameObject.Instantiate(self.mObj_Title,self.mParent_title)
	go.transform.parent = self.mParent_title
	go.transform.localPosition = Vector3.zero
    go.transform.localScale = Vector3.one
	go.name = StringFormat("TaskTitle_{0}",index)
	local item = HallFortunaMissionTitleItem.New(go)
	self.mTitle_itemList[index]=item
	UIEventListener.Get(go).onClick = function(go)self:OnTaskTitleClick(index) end
	return item
end
----任务大类型（标题）点击事件
function HallFortunaMissionPanel:OnTaskTitleClick(index)
	self:CleanAllTaskList()
	self.mCurrentIndex = index
	local count = #self.mTitle_itemList
	for i = 1, count do
		self.mTitle_itemList[i]:SetTitleSelect(index)
	end
end
----清除任务大类型（标题）
function HallFortunaMissionPanel:CleanAllTaskGenral()
	local count = #self.mTitle_itemList
	for i = 1, count do
		self.mTitle_itemList[i]:RecycleTitleItem()
	end
end
----------------------------------------------------------任务大类型（标题）处理-----------------------------------------------------------------

----------------------------------------------------------任务列表处理-----------------------------------------------------------------

---更具大类型ID请求任务里列表返回
function HallFortunaMissionPanel:QueryTaskListresp(data)
	for i = 1, data.m_ucTaskCount do
		local item = self.mTask_ItemList[i]
		if item == nil then
			item = self:CreateTaskItem(i)
		end
		item:SetTaskData(data.m_ucGeneralTypeId,data.TaskItemList[i],self.mCurrentIndex)
	end
	self.mTask_Grid:Reposition()
	self.mTask_ScrollList:ResetPosition()
end

----创建任务（标题）
function HallFortunaMissionPanel:CreateTaskItem(index)
	local go = GameObject.Instantiate(self.mObj_TaskItem,self.mParent_Task)
	go.transform.parent = self.mParent_Task
	go.transform.localPosition = Vector3.zero
    go.transform.localScale = Vector3.one
	go.name = StringFormat("Task_{0}",index)
	local item = HallFortunaMissionTaskItem.New(go)
	self.mTask_ItemList[index]=item
	return item
end

function HallFortunaMissionPanel:CleanAllTaskList()
	local count = #self.mTask_ItemList
	for i = 1, count do
		self.mTask_ItemList[i]:RecycleTaskItem()
	end
end

----------------------------------------------------------任务列表处理-----------------------------------------------------------------

----关闭按钮点击事件
function HallFortunaMissionPanel:OnButtonClose()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallFortunaMissionPanel:ShowPanel()
	LuaPanel.ShowPanel(self)
	HallFortunaMissionModel.GetInstance():CClientQueryTaskGeneralTypeReq()
end

function HallFortunaMissionPanel:HidePanel()
	LuaPanel.HidePanel(self)
	self:CleanAllTaskList()
	HallFortunaMissionModel.GetInstance():CleanAllData()
end

function HallFortunaMissionPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	SetPanelstartingRenderQueue(self.mTitle_ScrollView.gameObject,depth +10)
	SetPanelstartingRenderQueue(self.mTask_ScrollList.gameObject,depth +10)
	
end

function HallFortunaMissionPanel:__delete( ... )
	self.mParentUI = nil
	self.mTitle_Grid =nil
	self.mTitle_itemList = nil
	self.mTask_ItemList = nil
end
