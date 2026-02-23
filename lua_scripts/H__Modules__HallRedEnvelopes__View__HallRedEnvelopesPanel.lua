HallRedEnvelopesPanel = HallRedEnvelopesPanel or BaseClass(LuaPanel)

function HallRedEnvelopesPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRedEnvelopes].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRedEnvelopes].path
	self.mPanelID = UIPanelDefine.EWndID.HallRedEnvelopes
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallRedEnvelopesPanel:InitUI()
	self.OpenRedTick = "HallRedEnvelopesPanel:OpenRedTickInitUI"
	self.OPenRedPanleTick = "HallRedEnvelopesPanel:OPenRedPanleTickInitUI"
	local mTran = self.obj.transform
	self.mContent1 =  mTran:Find("Content_1").gameObject
	self.mRedPackTextPanel = mTran:Find("Content_1/Content/Tex"):GetComponent(typeof(UIPanel))
	self.mEffect2Obj =  mTran:Find("Content_1/Content/Effects2").gameObject
	self.mEffect2Obj:SetActive(false)
	self.mContent2Panel = mTran:Find("Content_2"):GetComponent(typeof(UIPanel))
	self.mContent2Panel.gameObject:SetActive(false)

	self.mRedPackText2Obj = mTran:Find("Content_2/Content/Tex").gameObject

	self.mMoneyLabel = mTran:Find("Content_2/Content/Tex/Lable"):GetComponent(typeof(UILabel))
	self.mMoneyLabel.text = 0
	self.mObj_OpenRedPack = mTran:Find("Content_1/Content/Tex").gameObject
	self.mBox_Text = self.mObj_OpenRedPack:GetComponent(typeof(BoxCollider))

	local mBtn_Close = mTran:Find("Content_2/Content/Button_Close").gameObject

	self.mLabel_Tips = mTran:Find("Content_2/Content/Tex/Lable_Tips1"):GetComponent(typeof(UILabel))
	--self.mLabel_Tips.text = ""

	local mBtn_Service =  mTran:Find("Content_2/Content/Tex/Button_KeFu").gameObject

	UIEventListener.Get(self.mObj_OpenRedPack).onClick = function(obj) self:OnOpenRedPackClick()  end
	UIEventListener.Get(mBtn_Close).onClick = function(obj) self:OnCloseButton(obj)  end
	UIEventListener.Get(mBtn_Service).onClick = function(obj) self:OnServiceButton(obj)  end

	LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)					--后台切换到前台
	LuaPanel.InitUI(self)
end


function HallRedEnvelopesPanel:OnApplicationFocus()
	--HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
end


function HallRedEnvelopesPanel:OnServiceButton(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallService)
end


function HallRedEnvelopesPanel:OnCloseButton(Obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID,function()
		HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
	end)
end

function HallRedEnvelopesPanel:OpenRedEffect(tips)
	self.mEffect2Obj:SetActive(true)
	--self.mLabel_Tips.text = tips
	RenderMgr.AddInterval(function()
		RenderMgr.Remove(self.OpenRedTick)
		self.mEffect2Obj:SetActive(false)
		self:OpenRedPanel()
	end,self.OpenRedTick,1.22,1.5)
end


function HallRedEnvelopesPanel:OpenRedPanel()
	self.mContent1:SetActive(false)
	self.mContent2Panel.gameObject:SetActive(true)
	
end

function HallRedEnvelopesPanel:OnOpenRedPackClick(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.mBox_Text.enabled = false
	HallRedEnvelopesController.GetInstance().model.mPanelActive = false
	HallRedEnvelopesController.GetInstance().model:CClientDrawRedPacketGiftReq(self.data.m_unId)
end


function HallRedEnvelopesPanel:SetRedpackData(data)
	self.data = data
	self.mMoneyLabel.text = NumberFormat(HallGoldRateSToC(data.m_un64SendCoins))
end


function HallRedEnvelopesPanel:ShowPanel(back)
	self.mContent1:SetActive(true)
	self.mEffect2Obj:SetActive(false)
	self.mBox_Text.enabled = true
	self.mContent2Panel.gameObject:SetActive(false)
	LuaPanel.ShowPanel(self,back)
end

function HallRedEnvelopesPanel:SetPanelDepth(depth)
	-- self.mRedPackTextPanel.depth = depth + 10
	-- self.mContent2Panel.depth = depth + 5
	SetPanelstartingRenderQueue(self.mRedPackTextPanel.gameObject,depth +1)
	SetPanelstartingRenderQueue(self.mContent2Panel.gameObject,depth +2)
	SetPanelstartingRenderQueue(self.mRedPackText2Obj,depth+8)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallRedEnvelopesPanel:__delete( ... )
	
end
