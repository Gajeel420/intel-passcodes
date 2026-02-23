HallActiveCentrePanel = HallActiveCentrePanel or BaseClass(LuaPanel)

function HallActiveCentrePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallActiveCenter].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallActiveCenter].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallActiveCenter
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel--页面层级
	self:CreatePanel(0)----必须实现
end


--初始化ui界面  ----必须实现
function HallActiveCentrePanel:InitUI()
	local mTran = self.obj.transform
	self.mButton_Close = mTran:Find("Content/Common/Btn_Back/Background").gameObject
	UIEventListener.Get(self.mButton_Close).onClick = function(obj) self:OnButton_Close(obj) end
	
	self.mText_Conter = mTran:Find("Content/Con_Title/Tex").gameObject:GetComponent(typeof(UITexture))
	self.mScrollView_Obj = mTran:Find("Content/ButtonGrid/Btn").gameObject
	
	self.mButton_title = mTran:Find("Content/ButtonGrid/Btn/Tween/Button_01").gameObject
	self.parentTrans = mTran:Find("Content/ButtonGrid/Btn/Tween")
	self.mButton_title:SetActive(false)
	self.ActiveCountItemList = {}
	self.IsFirst = true
	self.mTextureList = {}

	self.mObjTryAgain = mTran:Find("Content/Content_Try").gameObject
	self.mObjTryAgain:SetActive(false)
	local mBtnTryAgain =  mTran:Find("Content/Content_Try/Button_Try").gameObject
	UIEventListener.Get(mBtnTryAgain).onClick = function() self:OnClickTryAgain() end

	local list_tweenList={}
    local mTweenCenter=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, mTweenCenter)
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	self.CurrentUrl = ""
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	LuaPanel.InitUI(self)
end


---创建一个title
function HallActiveCentrePanel:CreateTitle(index)
	local go = GameObject.Instantiate(self.mButton_title,self.parentTrans)
	go.name = StringFormat("ActiveCenterItem{0}",index)
	return HallActiveCenterItem.New(go)
end


function HallActiveCentrePanel:OnClickTryAgain()
	if self.CurrentUrl ~= "" then
		self:SetActiveCenterTexture(self.CurrentUrl)
		self.mObjTryAgain:SetActive(false)
	end
end

---刷新数据
function HallActiveCentrePanel:ResfreshData()
	self:CleanItemData()
	local dataList = HallActiveCentreController.GetInstance().model.ActiveCenterDataList
	local dataListCount = #dataList
	for i = 1, dataListCount do
		local item = nil
		if i <= #self.ActiveCountItemList then
			item = self.ActiveCountItemList[i]
		else
			item = self:CreateTitle(i)
			table.insert(self.ActiveCountItemList,item)
		end
		item:SetItemDisplay(true)
		item:SetData(dataList[i])
		--if self.IsFirst then
			if i == 1 then
				self:OnButton_Title(dataList[i])
				item:SetToggleState(true)
			end
		--end
		UIEventListener.Get(item.obj).onClick = function(obj) self:OnButton_Title(dataList[i],i) end
	end
	
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.parentTrans.gameObject:GetComponent(typeof(UIGrid)):Reposition()
		self.mScrollView_Obj:GetComponent(typeof(UIScrollView)):ResetPosition()
	end)
	
	
end

function HallActiveCentrePanel:OnButton_Title(data,index)
	--print("tttttttttt111111111112222222222233333333333333333333")
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.data = data
	for i = 1, #self.ActiveCountItemList do
		self.ActiveCountItemList[i]:SetToggleState(i == index)
	end
	self:SetActiveCenterTexture(data.url)
end

--关闭按钮点击事件
function HallActiveCentrePanel:OnButton_Close(obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	--SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_acitivity)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallActiveCentrePanel:OnButton_Takeparty(obj)
	if self.data ~= nil then
		Application.OpenURL(self.data.url2)
	end
end

---清除item数据
function HallActiveCentrePanel:CleanItemData()
	local count = #self.ActiveCountItemList
	for i = 1, count do
		self.ActiveCountItemList[i]:SetItemDisplay(false)
	end
end

-- 设置活动内容
function HallActiveCentrePanel:SetActiveCenterTexture(url)
	self.CurrentUrl = url
	
	local mActiveUtl = ConfigModuleModel.GetInstance().ActiveCenterUrl
	
	
	local _,_,urlPrefix=string.find(mActiveUtl,"(http://%w[.%w]*:?%d*/)")
	if urlPrefix == nil then
		_,_,urlPrefix=string.find(mActiveUtl,"(https://%w[.%w]*:?%d*/)")
	end
	if urlPrefix == nil then
		print("解析图片地址urlPrefix为空")
	else
		local urlStr = StringFormat("{0}{1}",urlPrefix,url)
		if self.mTextureList[urlStr]  then
			self.mText_Conter.mainTexture = self.mTextureList[urlStr]
		else
			UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","",10,function()
				self.mObjTryAgain:SetActive(true)
			end)
			self.mText_Conter.mainTexture = ""

			local sunFun = function(tex)
				if tex then
					if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
						UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
					end
					self.mObjTryAgain:SetActive(false)
					self.mTextureList[urlStr] = tex
					tex = nil
					
				end
			end

			local failFun = function()
				if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then 
					UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
				end
				self.mObjTryAgain:SetActive(true)
			end
			DownLoadTextureAndSet(urlStr,self.mText_Conter,sunFun,failFun)
			
		end
	end
end

function HallActiveCentrePanel:ResetPanel()
	self.IsFirst = true
end


function HallActiveCentrePanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self:ResfreshData()
	LuaPanel.ShowPanel(self, callBack)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_acitivity)
	self.mTweenPlayer:ParallelPlay(false)
end

function HallActiveCentrePanel:HidePanel()
	LuaPanel.HidePanel(self)
	if self.IsFirst then
		self.IsFirst = false
		HallRedEnvelopesController:GetInstance().model.mCanRequest = true
		HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
	end
end


--设置子panel的深度
 function HallActiveCentrePanel:SetPanelDepth(depth)
	self.mScrollView_Obj:GetComponent(typeof(UIPanel)).depth = depth+1
	LuaPanel.SetPanelDepth(self,depth)
end


function HallActiveCentrePanel:__delete( ... )
	self.mButton_Close = nil
	self.mText_Conter = nil
	self.mScrollView_Obj = nil
	
	self.mButton_title = nil
	self.parentTrans =nil
	self.ActiveCountItemList = nil
	self.IsFirst = nil
	self.mTextureList = nil
	self.mObjTryAgain = nil
	local mBtnTryAgain = nil

	local list_tweenList= nil
	self.mTweenPlayer= nil

	self.CurrentUrl = ""
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
end
