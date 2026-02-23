HallServicePanel = HallServicePanel or BaseClass(LuaPanel)

function HallServicePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallService].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallService].path
	self.mPanelID = UIPanelDefine.EWndID.HallService
	self.mPanelType = UIPanelDefine.PanelType.FourLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallServicePanel:InitUI()
	local mTran = self.obj.transform
	self.mTransform_Content=mTran:Find("Content")
    self.mWidget_Content=mTran:Find("Content"):GetComponent(typeof(UIWidget))
	self.mWidget_Content:ResetAndUpdateAnchors()

	self.mObj_ButtonClose = mTran:Find("Content/Button_Close").gameObject
	UIEventListener.Get(self.mObj_ButtonClose).onClick = function () self:OnButtonClose( ) end -- 点击OnButtonClose按钮事件
	
    self.mTran_InformationGrid = mTran:Find("Content/ScrollView/ScrollPanel/Grid")
	self.mList_ItemInfo = {}
	
    self.mobj_itemQQ = mTran:Find("Content/Item/ItemInformationQQ").gameObject
    self.mobj_itemQQ:SetActive(false)
    self.mobj_itemWx = mTran:Find("Content/Item/ItemInformationWeixin").gameObject
	self.mobj_itemWx:SetActive(false)
    self.mobj_itemWeb = mTran:Find("Content/Item/ItemInformationWeb").gameObject
    self.mobj_itemWeb:SetActive(false)

	
	self.scriptQQ=nil
	self.scriptWeiXin=nil
	self.scriptWeb=nil

    self.panelScrollView=mTran:Find("Content/ScrollView/ScrollPanel"):GetComponent(typeof(UIPanel))
	self.svScrollView=mTran:Find("Content/ScrollView/ScrollPanel"):GetComponent(typeof(UIScrollView))
	


	--初始化动画
	local list_tweenList={}
	local tweenPosition_bottom=mTran:Find("Content"):GetComponent(typeof(TweenScale))
	table.insert(list_tweenList, tweenPosition_bottom)
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	
	LuaPanel.InitUI(self)    
end

function HallServicePanel:AddEvent( ... )
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
end
function HallServicePanel:RemoveEvent( ... )
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
end

function HallServicePanel:RefreshView(data)

	if(data.QQ ~= nil) then
		if self.scriptQQ==nil then
			local goQQ=GameObject.Instantiate(self.mobj_itemQQ)
			goQQ:SetActive(true)
			goQQ.transform.parent = self.mTran_InformationGrid.transform;
			goQQ.transform.localEulerAngles = Vector3.zero
			goQQ.transform.localScale = Vector3.one
			goQQ.transform.localPosition = Vector3.zero
			self.scriptQQ = HallQQServiceGrid.New(goQQ)
		end

        self.scriptQQ:SetGridData(data.QQ)
	end
	if(data.WeiXin ~= nil) then
		if self.scriptWeiXin==nil then
			local goWx = GameObject.Instantiate(self.mobj_itemWx)
			goWx:SetActive(true)
			goWx.transform.parent = self.mTran_InformationGrid.transform;
			goWx.transform.localEulerAngles = Vector3.zero
			goWx.transform.localScale = Vector3.one
			goWx.transform.localPosition = Vector3.zero
			self.scriptWeiXin=HallWechatServiceGrid.New(goWx)
		end

        self.scriptWeiXin:SetGridData(data.WeiXin)
	end
	if(data.Web ~= nil) then
		if self.scriptWeb==nil then
			local goWeb=GameObject.Instantiate(self.mobj_itemWeb)
			goWeb:SetActive(true)
			goWeb.transform.parent = self.mTran_InformationGrid.transform;
			goWeb.transform.localEulerAngles = Vector3.zero
			goWeb.transform.localScale = Vector3.one
			goWeb.transform.localPosition = Vector3.zero
			self.scriptWeb=HallServiceGrid.New(goWeb)
		end

        self.scriptWeb:SetGridData(data.Web)
	end
    self.mTran_InformationGrid:GetComponent(typeof(UIGrid)):Reposition()
	self.svScrollView:ResetPosition()
end

function HallServicePanel:ResetPanel()
	self.inited=false
	self:RemoveEvent()
end

--关闭按钮事件
function HallServicePanel:OnButtonClose( ... )
	UIManager:GetInstance():HidePanel(self.mPanelID)
	--SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_service)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
end

--设置子panel的深度
function HallServicePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.panelScrollView.depth = depth + 1
end

-- 复写父类 showpanel 方法
function HallServicePanel:ShowPanel(callBack)
	self.mTransform_Content.localPosition=Vector3(0,-10000,0)
	StartCoroutine(function ()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		HallServiceModel.GetInstance():ReqServiceData(function (data)
			if data.QQ==nil and data.WeiXin==nil and data.Web~=nil then
				Application.OpenURL(data.Web)
			elseif data.QQ~=nil or data.WeiXin~=nil then
				LuaPanel.ShowPanel(self,callBack)
				self:RefreshView(data)
				SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
				--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_service)
			end
		end) 
		self.mTransform_Content.localPosition=Vector3(0,0,0)
        self.mTweenPlayer:ParallelPlay(false)
	end)
	

end


function HallServicePanel:HidePanel( )
	self:SetVisible(false)
end



function HallServicePanel:__delete( ... )
	self:RemoveEvent()
	GameObjectDestroy(self.mobj_itemQQ)
	GameObjectDestroy(self.mobj_itemWx)
	GameObjectDestroy(self.mobj_itemWeb)
	self.mTran_InformationGrid = nil
	self.mList_ItemInfo = nil
	self.mobj_itemQQ = nil
	self.mobj_itemWx = nil
	self.mobj_itemWeb = nil
	self.mobj_itemMask  = nil
	self.panelScrollView = nil
	self.svScrollView = nil
	self.scriptWeb = nil
	self.scriptWeiXin = nil
	self.scriptQQ  = nil
end
