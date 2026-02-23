HallAdPopPanel = HallAdPopPanel or BaseClass(LuaPanel)

function HallAdPopPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAdPop].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAdPop].path
	self.mPanelID = UIPanelDefine.EWndID.HallAdPop
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallAdPopPanel:InitUI()
	self.itemWith = 900
	self.m_CurrentIndex = 1
	self.selectObj = {}
	self.UpdateName = "addPopUpdate"
	self.m_NowTime = 0
	self.m_IsStart = false
	self.m_IntervalTime = 3
	self.instansObj = {{},{}}
	local mTran = self.obj.transform
	self.scrPanel = mTran:Find("Content/ScrollView"):GetComponent(typeof(UIPanel))
	self.closeBtn = mTran:Find("Content/Btn_Close").gameObject
	self.content = mTran:Find("Content/ScrollView/Content").transform
	self.cloneItem = mTran:Find("Content/cloneItem").gameObject
	self.cloneItem:SetActive(false)
	self.pointItem = mTran:Find("Content/pointItem").gameObject
	self.pointItem:SetActive(false)
	self.Point = mTran:Find("Content/Point").transform
    UIEventListener.Get(self.closeBtn).onClick = function ()
        self:OnCloseButtonClick()
    end
	self.mGrid = mTran:Find("Content/Point"):GetComponent(typeof(UIGrid))
	self.m_CenterOnChildObj = mTran:Find("Content/ScrollView/Content").gameObject
	self.m_CenterOnChild = mTran:Find("Content/ScrollView/Content"):GetComponent(typeof(UICenterOnChild))
	self.UIWrapContent = mTran:Find("Content/ScrollView/Content"):GetComponent(typeof(UIWrapContent))
	self.m_Scrollview = mTran:Find("Content/ScrollView"):GetComponent(typeof(UIScrollView))
	PrintLog("HallAdPopPanel3777777777777777777777777777777")
	self.m_CenterOnChild.onCenter=function(go) self:OnCenterChildGame(go) end
    self.m_CenterOnChild.onFinished=function() self:OnCenterChildGameFinished() end
	PrintLog("HallAdPopPanel888888888888888888888888888")
	self.alloctObj =  mTran:Find("alloctObj").transform
	PrintLog("HallAdPopPanel33333333333333333333333")
    self.m_Scrollview.onDragStarted = function()
        self.m_NowTime = 0
        self.m_IsStart = false
    end
	LuaPanel.InitUI(self)
end

function HallAdPopPanel:OnCloseButtonClick( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
	self:HidePanel()
end

function HallAdPopPanel:HidePanel( callBack,isPlayTween )
	for i = 1, 2 do
		for j = 1,#self.instansObj[i] do
			self.instansObj[i][j]:SetActive(false)
			self.instansObj[i][j].transform:SetParent(self.alloctObj)
		end
	end
	--GameObject.Destroy(self.m_CenterOnChild)
	--self.instansObj = {}
	self.selectObj = {}
    RenderMgr.Remove(self.UpdateName)
    LuaPanel.HidePanel(self,callBack)
	ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallAdPopPanel:RefreshPanel()
	self.selectObj = {}
	--self.instansObj = {}
	self.UIWrapContent.enabled = false
	self.m_NowTime = 0
	self.m_IsStart = false
	self.m_CurrentIndex = 1
	-- if self.m_CenterOnChildObj then
	-- 	self.m_CenterOnChild = self.m_CenterOnChildObj:AddComponent(typeof(CS.UICenterOnChild))
	-- 	self.m_CenterOnChild.onCenter=function(go) self:OnCenterChildGame(go) end
    -- 	self.m_CenterOnChild.onFinished=function() self:OnCenterChildGameFinished() end
	-- end
	local data = HallAdPopModel:GetInstance().adData
	for i = 1, #data do
		local go
		if self.instansObj[1][i] then
			go = self.instansObj[1][i]
			go.transform:SetParent(self.content)
		else
			go = GameObject.Instantiate(self.cloneItem,self.content)
			table.insert(self.instansObj[1],go)
		end
		local tex = go.transform:Find("sp"):GetComponent(typeof(UITexture))
		tex.color = Color(1,1,1,0)
		local url = data[i].image_url
		local OnComplete = function( wwwLoad )
			if(wwwLoad ~= nil) then
				tex.mainTexture = wwwLoad.texture
				tex.color = Color(1,1,1,1)
			end
		end
		DownLoadManager:BeginWWWRequest(url,OnComplete)
		go:SetActive(true)
		go.name =  tostring(i)
		go.transform.localPosition = Vector3(self.itemWith*(i-1),0,0)
		go.transform.localScale = Vector3.one
		go.transform.localEulerAngles = Vector3.zero
		if self.instansObj[2][i] then
			go = self.instansObj[2][i]
			go.transform:SetParent(self.Point)
		else
			go = GameObject.Instantiate(self.pointItem,self.Point)
			table.insert(self.instansObj[2],go)
		end
		go:SetActive(true)
		go.name =  tostring(i)
		go.transform.localScale = Vector3.one
		go.transform.localEulerAngles = Vector3.zero
		
		local obj = go.transform:Find("select").gameObject
		table.insert(self.selectObj,obj)
	end
	--self.m_CenterOnChild:CenterOn(self.instansObj[1][3].transform)
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mGrid:Reposition()
		self.m_Scrollview:ResetPosition()
		self.UIWrapContent.enabled = true
    end)  

	self:ShowPageLight()
	RenderMgr.Remove(self.UpdateName)
	if data and #data > 1 then
		RenderMgr.Add(function ()
			self:Update()
		end,self.UpdateName)
	end
end


function HallAdPopPanel:Update()
	--PrintLog("Update====================")
    if self.m_IsStart then
		--PrintLog("aaaaaaaaaaaaaaaaaaaaaa222222222222222222")
		self.m_NowTime = self.m_NowTime + Time.deltaTime
		if self.m_NowTime >= self.m_IntervalTime then
			self.m_NowTime = 0
			self.m_CurrentIndex = self.m_CurrentIndex + 1
			if self.m_CurrentIndex > #self.selectObj then
				self.m_CurrentIndex = 1
			end
			self:ShowPageLight()
			self.m_currentPosX = self.m_currentPosX - self.itemWith
			SpringPanel.Begin(self.m_Scrollview.gameObject,Vector3(self.m_currentPosX,0,0),8)
		end
	end

end


function HallAdPopPanel:OnCenterChildGame(go)
	PrintLog(go.name)
    self.m_CurrentIndex = tonumber(go.name)
    -- print("------------   self.m_CurrentIndex == ",self.m_CurrentIndex)
    self:ShowPageLight()
end

function HallAdPopPanel:OnCenterChildGameFinished()
    self.m_currentPosX = self.m_Scrollview.gameObject.transform.localPosition.x
    self.m_IsStart = true
end

function HallAdPopPanel:ShowPageLight()
	PrintLog("m_CurrentIndex====",self.m_CurrentIndex)
    for i = 1, #self.selectObj, 1 do
        if self.m_CurrentIndex == i then
            self.selectObj[i]:SetActive(true)
        else
            self.selectObj[i]:SetActive(false)
        end
    end
end


function HallAdPopPanel:SetPanelDepth(depth)
    self.scrPanel.depth = depth + 2
	LuaPanel.SetPanelDepth(self,depth)
end

function HallAdPopPanel:__delete( ... )

end
