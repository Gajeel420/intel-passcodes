LoadingPanel = LoadingPanel or BaseClass(LuaPanel)

function LoadingPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.LoginLoad].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.LoginLoad].path
	self.mPanelID = UIPanelDefine.EWndID.LoginLoad
	self.mPanelType = UIPanelDefine.PanelType.WindowLoading
	self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function LoadingPanel:InitUI()
	local mTran = self.obj.transform
	self.mCurProgress=0
	self.mSliderProgress = mTran:Find("Content/Ani"):GetComponent(typeof(UISlider))
	self.mSliderProgress_Vertical = mTran:Find("ContentVertical/Ani"):GetComponent(typeof(UISlider))

	--self.mObj_Logo=mTran:Find("Content/BG/Logo").gameObject
	self.texBG = mTran:Find("Content/BG").gameObject:GetComponent(typeof(UITexture))

	self.mSliderProgress.value = 0
	self.mSliderProgress_Vertical.value = 0
	self.preLoadFinished = false

	self.ContentObj = mTran:Find("Content").gameObject
	self.ContentVerticalObj = mTran:Find("ContentVertical").gameObject

	LuaPanel.InitUI(self)

end
--=====================================================================================================
----加载资源用
--=====================================================================================================

-- function LoadingPanel:ShowLogo(isShow)
-- 	self.mObj_Logo:SetActive(true)
-- end

function LoadingPanel:ShowPanel(callBack)
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		StartCoroutine(function()
			self.ContentObj:SetActive(false)
			self.ContentVerticalObj:SetActive(false)
			yield_return(WaitForSeconds(0.2))
			self.ContentObj:SetActive(SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Landscape)
			self.ContentVerticalObj:SetActive(SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait)
		end)
	else
		self.ContentObj:SetActive(SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Landscape)
		self.ContentVerticalObj:SetActive(SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait)
	end
	LuaPanel.ShowPanel(self,callBack)
end

function LoadingPanel:SetBG(texName)
	local texRes=UIResources.mUITextureDic[texName]
	if texRes then
		self.texBG.mainTexture=nil
		self.texBG.mainTexture=texRes
	end
	self.texBG.gameObject:SetActive(true)
end

function LoadingPanel:LoadingProgressValue(value)
	print("aaaaaaaaaaaaaaaaa    ",value)
	RenderMgr.Remove("LoadingPanel:Update")
	self.mCurProgress = value
	self.mSliderProgress.value = value
	self.mSliderProgress_Vertical.value = value
end

function LoadingPanel:StartPreLoad()
	self.mIsPreLoadRes = true
    self.PreLoadSpeed = 1/3
    self.preLoadFinished=false
	self.mSliderProgress.value = 0
	self.mSliderProgress_Vertical.value = 0
    RenderMgr.Add(function ( )
		self:Update()
	end,"LoadingPanel:Update")
end

function LoadingPanel:PreLoadCompleted()
	self.preLoadFinished = true
	if self.mCurProgress >= 1 then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.LoginLoad)
		UIManager:GetInstance():HidePanelAll()
		RenderMgr.Remove("LoadingPanel:Update")
	else
		self.PreLoadSpeed = 5
	end
end

function LoadingPanel:Update( )
	if self.mIsPreLoadRes then
		self.mCurProgress = self.mSliderProgress.value
		if self.mCurProgress>0.98 and not self.preLoadFinished then
			self.PreLoadSpeed=1/1000
		end
		local tmp = Time.deltaTime*self.PreLoadSpeed
		self.mCurProgress = tmp + self.mCurProgress
		self.mSliderProgress.value = self.mCurProgress
		self.mSliderProgress_Vertical.value = self.mCurProgress
		if self.mCurProgress >= 1 and self.preLoadFinished then
			UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.LoginLoad)
			RenderMgr.Remove("LoadingPanel:Update")
		end
	end
end
--=====================================================================================================


--=====================================================================================================
---下载用
--=====================================================================================================

function LoadingPanel:OnShowSpeed(context)
	
end

function LoadingPanel:OnProgress(context)
	-- body
end

function LoadingPanel:AddEvent( )
	GlobalDispatcher:GetInstance():AddEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self)
	GlobalDispatcher:GetInstance():AddEventListener(EventName.UPDATE_SPEED, self.OnShowSpeed,self)
	--GlobalDispatcher:GetInstance():AddEventListener(EventName.LOADER_ALL_COMPLETED, self.OnAllCompleted,self)
end

function LoadingPanel:RemoveEvent( )
	GlobalDispatcher:GetInstance():RemoveEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self)
	GlobalDispatcher:GetInstance():RemoveEventListener(EventName.UPDATE_SPEED, self.OnShowSpeed,self)
	--GlobalDispatcher:GetInstance():RemoveEventListener(EventName.LOADER_ALL_COMPLETED, self.OnAllCompleted,self)
end
--=====================================================================================================

function LoadingPanel:__delete( ... )
	self.preLoadFinished = false
	self.mSliderProgress = nil
	self.mSliderProgress_Vertical = nil
	self.mLabel_Prompt = nil
	self.mLabel_LoadingTip = nil
	self.mSliderProgress.value = 0
	self.mSliderProgress_Vertical.value = 0
end