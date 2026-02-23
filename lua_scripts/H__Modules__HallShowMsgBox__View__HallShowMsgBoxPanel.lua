HallShowMsgBoxPanel = HallShowMsgBoxPanel or BaseClass(LuaPanel)

function HallShowMsgBoxPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.MessageBox].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.MessageBox].path
	self.mPanelID = UIPanelDefine.EWndID.MessageBox
	self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self.mPanelType = UIPanelDefine.PanelType.SelectBox
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallShowMsgBoxPanel:InitUI()
	
	local tran = self.obj.transform
	if tran:Find("Content/Label_Title") then
		self.labTitle = tran:Find("Content/Label_Title"):GetComponent(typeof(UILabel))
	end
	if tran:Find("Content/Label_Msg") then
		self.labMessage = tran:Find("Content/Label_Msg"):GetComponent(typeof(Localize)) --tran:Find("Content/Label_Msg"):GetComponent(typeof(UILabel))
		self.mLabel_Msg = tran:Find("Content/Label_Msg"):GetComponent(typeof(UILabel))
	end
	self.btnEnter = tran:Find("Content/Button_Sure/Button_OK").gameObject
	UIEventListener.Get(self.btnEnter).onClick = function() self:OnClickEnter() end
	self.btnCancel = tran:Find("Content/Button_Cancle").gameObject
	UIEventListener.Get(self.btnCancel).onClick = function() self:OnClickCancel() end
	self.btnClose = tran:Find("Content/Button_Close").gameObject
	self.btnClose:SetActive(false)
	UIEventListener.Get(self.btnClose).onClick = function() self:OnClickClose() end
	self.mButton_Sure = tran:Find("Content/Button_Sure").gameObject
	self.vecEnter = self.mButton_Sure.transform.localPosition
    self.vecCancel = self.btnCancel.transform.localPosition
    self.vecCenter = (self.vecEnter+self.vecCancel)/2
    self.TweenAn = tran:Find("Content"):GetComponent(typeof(TweenScale))
    self.LocalizationManager = CS.I2.Loc.LocalizationManager
	LuaPanel.InitUI(self)
end
--title:标签，context：内容；enterCB：点击确定返回；cancelCB：点击取消返回，isShowCancel：true显示两个，fasle显示一个确定按钮；
--isHideAll:隐藏所有按钮; isShowBtnClose:界面的关闭按钮
function HallShowMsgBoxPanel:ShowMessage(showBoxData)
	if showBoxData == nil then return end 

	if self.labTitle then
	 	self.labTitle.text = showBoxData.title or ""
	end

	 if self.LocalizationManager.GetTranslation(showBoxData.context) == nil then
        self.mLabel_Msg.text = showBoxData.context

    else
        self.labMessage:SetTerm(showBoxData.context)
    end 
	--self.labMessage.text = showBoxData.context or ""
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa     ",showBoxData.context)
	
	if showBoxData.isHideAll then
		self.mButton_Sure:SetActive(false)
		self.btnCancel:SetActive(false)
		if self.btnClose then self.btnClose:SetActive(false) end
	else
		if showBoxData.isShowCancel then
			self.mButton_Sure:SetActive(true)
			self.btnCancel:SetActive(true)
			StartCoroutine(function()
				--yield_return(WaitForSeconds(0.1))
				self.mButton_Sure.transform.localPosition = self.vecEnter
				self.btnCancel.transform.localPosition = self.vecCancel
			end)
			
		else
			self.mButton_Sure:SetActive(true)
			self.btnCancel:SetActive(false)
			self.mButton_Sure.transform.localPosition = self.vecCenter
		end
		if self.btnClose then self.btnClose:SetActive(showBoxData.isShowBtnClose or false) end
	end
	self.actionEnter = showBoxData.enterCB
	self.actionCancel = showBoxData.cancelCB
end

function HallShowMsgBoxPanel:OnClickEnter()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	if self.actionEnter then
		pcall(self.actionEnter)
	end

	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallShowMsgBoxPanel:OnClickCancel()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	if self.actionCancel then
		pcall(self.actionCancel)
	end
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallShowMsgBoxPanel:OnClickClose()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallShowMsgBoxPanel:PlayOpenAni( ... )
	-- body
	self.TweenAn.enabled=true
	self.TweenAn:ResetToBeginning()
	self.TweenAn:PlayForward()
end

function HallShowMsgBoxPanel:ShowPanel( callBack )
	-- body
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
	self:PlayOpenAni()
	
end

function HallShowMsgBoxPanel:__delete( ... )
	self.labTitle = nil
	self.labMessage = nil
	self.btnEnter = nil
	self.btnCancel = nil
	self.btnClose = nil
	self.vecEnter = nil
	self.vecCancel = nil
	self.vecCenter = nil
end