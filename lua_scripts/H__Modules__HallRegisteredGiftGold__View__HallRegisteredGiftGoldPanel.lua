HallRegisteredGiftGoldPanel = HallRegisteredGiftGoldPanel or BaseClass(LuaPanel)

function HallRegisteredGiftGoldPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRagistMoney].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRagistMoney].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallRagistMoney
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallRegisteredGiftGoldPanel:InitUI()
	local mTran = self.obj.transform
    --new
	self.mObj_CloseButton=mTran:Find("Content/Button_Close").gameObject
	UIEventListener.Get(self.mObj_CloseButton).onClick = function () self:OnClickCloseButton( ) end 
	
	self.mObj_RegisterButton=mTran:Find("Content/Button_Sure").gameObject
	UIEventListener.Get(self.mObj_RegisterButton).onClick = function () self:OnClickRegisterButton( ) end 
	self.mLabel_GiveGold=mTran:Find("Content/Bg0/Tex_Label/Label_Money"):GetComponent(typeof(UILabel))
	self.mLabel_GiveGold.text = "0"
	
	local mTran_Ani = mTran:Find("Content/Bg0/Spine_Gril")
	if mTran_Ani ~= nil then
		self.mUIRenderQueue = SZUIRenderQueue.New(mTran_Ani.gameObject)
	end

	local mTranUI = mTran:Find("Content/Bg0/Tex_Label")
	if mTranUI ~= nil then
		self.obj_LabelPanel = mTranUI.gameObject
	end
	--初始化动画
	local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	
	self.IsFistShow = true
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	LuaPanel.InitUI(self)    
end


function HallRegisteredGiftGoldPanel:AddEvent( ... )
	HallBindPhoneModel:GetInstance():AddEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)
	
end
function HallRegisteredGiftGoldPanel:RemoveEvent( ... )
	HallBindPhoneModel:GetInstance():RemoveEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)

end

function HallRegisteredGiftGoldPanel:ResetPanel(context)
	
	self.IsFistShow = true
end


function HallRegisteredGiftGoldPanel:OnBindPhoneSuccess(data)
	if self.IsFistShow then
		self.IsFistShow = false
		
		if ConfigModuleModel.GetInstance().IsShowActiveCenter then
			HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
		else
			HallRedEnvelopesController:GetInstance().model.mCanRequest = true
			HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		end

	end 
    UIManager:GetInstance():HidePanel(self.mPanelID)
end





function HallRegisteredGiftGoldPanel:RefreshView(data)
	if data.bindphonesendcoins~=nil and data.bindphonesendcoins~="" then
		self.mLabel_GiveGold.text= NumberFormat(HallGoldRateSToC(tonumber(data.bindphonesendcoins)))
	else
		self.mLabel_GiveGold.text=""
	end
end



--关闭按钮事件

function HallRegisteredGiftGoldPanel:OnClickRegisterButton( ... )
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindPhone)
	
end


function HallRegisteredGiftGoldPanel:OnClickCloseButton( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	if self.IsFistShow then
		self.IsFistShow = false
		if ConfigModuleModel.GetInstance().IsShowActiveCenter then
			HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
		else
			HallRedEnvelopesController:GetInstance().model.mCanRequest = true
			HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		end
	end 
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

--设置子panel的深度
function HallRegisteredGiftGoldPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	if self.mUIRenderQueue ~= nil then
		self.mUIRenderQueue:SetShaderRenderQueue(depth+5)
	end
	SetPanelstartingRenderQueue(self.obj_LabelPanel,depth+7)
end

-- 复写父类 showpanel 方法
function HallRegisteredGiftGoldPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    --请求数据，然后刷新
	HallRegisteredGiftGoldModel.GetInstance():ReqRegisterData(function (data)
		self:RefreshView(data)
		LuaPanel.ShowPanel(self,callBack)
		StartCoroutine(function ()
			yield_return(CS.UnityEngine.WaitForEndOfFrame())
			self.mTweenPlayer:ParallelPlay(false)
		end)
		self:AddEvent()
	end)
	
end



function HallRegisteredGiftGoldPanel:HidePanel( )
    self:RemoveEvent()
	self.mTweenPlayer:ParallelPlay(true,function ()
		self:SetVisible(false)
	end)
	--UIManager.GetInstance():DestroyPanelByID(self.mPanelID)
end

function HallRegisteredGiftGoldPanel:__delete( ... )
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	self:RemoveEvent()
	self.mObj_CloseButton= nil
	
	self.mObj_RegisterButton=nil
	self.mLabel_GiveGold=nil
	self.mUIRenderQueue =nil
	self.obj_LabelPanel = nil
	--初始化动画
	local list_tweenList= nil
	self.mTweenPlayer=nil
	self.IsFistShow = true
	GameObject.Destroy(self.obj)
end

