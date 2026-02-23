HallExchangePanel = HallExchangePanel or BaseClass(LuaPanel)

function HallExchangePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallExchange].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallExchange].path
	self.mPanelID = UIPanelDefine.EWndID.HallExchange
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallExchangePanel:InitUI()

	local mTran = self.obj.transform
	-- self.mTransform_Content=mTran:Find("Content")
    -- self.mWidget_Content=mTran:Find("Content"):GetComponent(typeof(UIWidget))
	-- self.mWidget_Content:ResetAndUpdateAnchors()

	self.BackObjList = {}

	self.mToggle_ZhiFuBao = mTran:Find("Content/ButtonGrid/Tween/Toggle_ZhiFuBao"):GetComponent(typeof(UIToggle))
	self.mToggle_Bank = mTran:Find("Content/ButtonGrid/Tween/Toggle_BankCard"):GetComponent(typeof(UIToggle))
	self.mToggle_Record=mTran:Find("Content/ButtonGrid/Tween/Toggle_record"):GetComponent(typeof(UIToggle))
	self.mToggle_Bank.gameObject:SetActive(false)
	self.mToggle_ZhiFuBao.gameObject:SetActive(false)
	self.mToggle_Record.gameObject:SetActive(false)
	self.mGrid_tween = mTran:Find("Content/ButtonGrid/Tween"):GetComponent(typeof(UIGrid))

	self.BackObjList[HallExchangePanel.ViewType.ZhiFuBao] = mTran:Find("Content/ButtonGrid/Tween/Toggle_ZhiFuBao/Back").gameObject
	self.BackObjList[HallExchangePanel.ViewType.Bank] = mTran:Find("Content/ButtonGrid/Tween/Toggle_BankCard/Back").gameObject
	self.BackObjList[HallExchangePanel.ViewType.Record] = mTran:Find("Content/ButtonGrid/Tween/Toggle_record/Back").gameObject
	local AliPayViewObj = mTran:Find("Content/ZFBCard").gameObject
	local BankViewObj = mTran:Find("Content/BankCard").gameObject
	local RecordViewObj=mTran:Find("Content/Settlement_record").gameObject
	local CloseObj = mTran:Find("Content/ButtonGrid/Btn_Back/Background").gameObject
	self.AliPayView = ExchangeView.New(AliPayViewObj)
	self.AliPayView:SetViewType(ExchangeView.ViewType.ZhiFuBao)
	self.BankPayView = ExchangeView.New(BankViewObj)
	self.BankPayView:SetViewType(ExchangeView.ViewType.Bank)
	self.RecordView=RecordView.New(RecordViewObj)


	UIEventListener.Get(self.mToggle_ZhiFuBao.gameObject).onClick = function()self:OnClickToggle(HallExchangePanel.ViewType.ZhiFuBao) end
	UIEventListener.Get(self.mToggle_Bank.gameObject).onClick = function() self:OnClickToggle(HallExchangePanel.ViewType.Bank) end
	UIEventListener.Get(self.mToggle_Record.gameObject).onClick = function() self:OnClickToggle(HallExchangePanel.ViewType.Record) end
	UIEventListener.Get(CloseObj).onClick = function(obj) self:OnCloseButtonClick(obj) end
	self.model = HallExchangeModel:GetInstance()

	--初始化动画
	local list_tweenList={}
	local tweenPosition_buttonGrid=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenPosition_buttonGrid)
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	local mRechargeRecordObj = mTran:Find("Content/RechargeRecord")

	self.mRechargeRecordView = RechargeRecordView.New(mRechargeRecordObj,function() 
		LuaPanel.InitUI(self)
	end)
	
end




function HallExchangePanel:OnClickToggle(viewType)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	self:HideAllView()

	if viewType==HallExchangePanel.ViewType.ZhiFuBao then
		self.mToggle_ZhiFuBao.value=true
		self.mToggle_Bank.value=false
		self.mToggle_Record.value=false
		self.AliPayView:ShowView()
		self.BackObjList[HallExchangePanel.ViewType.ZhiFuBao]:SetActive(false)
		self.BackObjList[HallExchangePanel.ViewType.Bank]:SetActive(true)
		self.BackObjList[HallExchangePanel.ViewType.Record]:SetActive(true)
		self.mRechargeRecordView:ShowView()
	elseif viewType==HallExchangePanel.ViewType.Bank then
		self.mToggle_ZhiFuBao.value=false
		self.mToggle_Bank.value=true
		self.mToggle_Record.value=false
		self.BackObjList[HallExchangePanel.ViewType.ZhiFuBao]:SetActive(true)
		self.BackObjList[HallExchangePanel.ViewType.Bank]:SetActive(false)
		self.BackObjList[HallExchangePanel.ViewType.Record]:SetActive(true)
		self.BankPayView:ShowView()
		self.mRechargeRecordView:ShowView()
	elseif viewType==HallExchangePanel.ViewType.Record then
		self.mToggle_ZhiFuBao.value=false
		self.mToggle_Bank.value=false
		self.mToggle_Record.value=true
		self.BackObjList[HallExchangePanel.ViewType.ZhiFuBao]:SetActive(true)
		self.BackObjList[HallExchangePanel.ViewType.Bank]:SetActive(true)
		self.BackObjList[HallExchangePanel.ViewType.Record]:SetActive(false)
		self.RecordView:ShowView()
		self.mRechargeRecordView:HideView()
	end
end


function HallExchangePanel:HideAllView()
	self.AliPayView:HideView()
	self.BankPayView:HideView()
	self.RecordView:HideView()
end



function HallExchangePanel:OnCloseButtonClick( obj )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	-- body
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchange)
end

function HallExchangePanel:ShowPanel(callBack)
	HallExchangeModel.GetInstance():GetBindingAccount(function (data)
		self.AliPayView:SetBinDingData(self.model.AliPayData)
		self.BankPayView:SetBinDingData(self.model.BankData)
	end)
	HallExchangeModel.GetInstance():GetRecordState()
	LuaPanel.ShowPanel(self,callBack)

	self.mainPlayer=PlayerInfoController:GetInstance().model.mainPlayer
	self.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshPanelData,self)
	self:InitAll()
	self.AliPayView:SetUserMoney(self.mainPlayer.iMoney)
	self.BankPayView:SetUserMoney(self.mainPlayer.iMoney)
	local data = HallExchangeBindModel.GetInstance().data 
	self.mToggle_ZhiFuBao.gameObject:SetActive(data.zfbdata.IsEnable == "1")
	self.mToggle_Bank.gameObject:SetActive(data.bankdata.IsEnable == "1")
	self.mToggle_Record.gameObject:SetActive(data.isopenbill == "1")
	if data.zfbdata.IsEnable == "1" then
		self:OnClickToggle(HallExchangePanel.ViewType.ZhiFuBao)
	elseif data.bankdata.IsEnable == "1" then
		self:OnClickToggle(HallExchangePanel.ViewType.Bank)
	elseif data.isopenbill == "1" then
		self:OnClickToggle(HallExchangePanel.ViewType.Record)
	end
	self.mGrid_tween:Reposition()
	self.mTweenPlayer:ParallelPlay(false)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_Exchange)
end


function HallExchangePanel:HidePanel(callBack)
	self.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshPanelData,self)
	--SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_Exchange)
	self.mRechargeRecordView:HideView()
	LuaPanel.HidePanel(self,callBack)
	
end



function HallExchangePanel:InitAll( ... )
	-- body
	self.AliPayView:InitAll()
	self.BankPayView:InitAll()
end




function HallExchangePanel:RefreshPanelData( context )
	-- body
	if not context then return end
	local key=context[1]
	local newValue=context[2]
	local oldValue=context[3]
	if key=="iMoney" then
		self.AliPayView:SetUserMoney(newValue)
		self.BankPayView:SetUserMoney(newValue)
	end
end


--设置子panel的深度
 function HallExchangePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.AliPayView:SetPanelDepth(depth+5)
	self.BankPayView:SetPanelDepth(depth+10)
	self.RecordView:SetPanelDepth(depth+15)
	self.mRechargeRecordView:SetDepth(depth+15)
end

function HallExchangePanel:__delete( ... )
	self.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshPanelData,self)
	self.AliyToggle = nil
	self.BankToggle = nil
	self.AliPayView = nil
	self.BankPayView = nil
end


HallExchangePanel.ViewType={
	ZhiFuBao=1,
	Bank=2,
	Record=3,
}