HallExchangeBindPanel = HallExchangeBindPanel or BaseClass(LuaPanel)

function HallExchangeBindPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallExchangeBind].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallExchangeBind].path
	self.mPanelID = UIPanelDefine.EWndID.HallExchangeBind
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallExchangeBindPanel:InitUI()
	local mTran = self.obj.transform
	self.IsInitOpenBankNameList = false
	--new
	--支付宝
	self.mPanel_BindZhiFuBao=mTran:Find("Content_2"):GetComponent(typeof(UIPanel))
	self.mInput_ZhiFuBaoCard=mTran:Find("Content_2/CarkInput"):GetComponent(typeof(UIInput))
	self.mInput_ZhiFuBaoName=mTran:Find("Content_2/NameInput"):GetComponent(typeof(UIInput))
	self.mObj_BindZhiFuBaoButton=mTran:Find("Content_2/Button_Sure").gameObject
	self.mObj_CloseZhiFuBaoButton=mTran:Find("Content_2/Button_Close").gameObject
	self.mFunc_BindZhiFuBaoSucCallBack=nil
	self.mInput_ZhiFuBaoName:GetComponent(typeof(BoxCollider)).enabled = false
	UIEventListener.Get(self.mObj_BindZhiFuBaoButton).onClick = function()self:OnClickBindZhiFuBaoButton() end
	UIEventListener.Get(self.mObj_CloseZhiFuBaoButton).onClick = function()self:OnClickCloseButton() end
	--银行卡
	self.mPanel_BindBank=mTran:Find("Content"):GetComponent(typeof(UIPanel))
	self.mInput_BankCard=mTran:Find("Content/CarkInput"):GetComponent(typeof(UIInput))
	self.mInput_BankName=mTran:Find("Content/NameInput"):GetComponent(typeof(UIInput))
	

	self.mLabel_OpenBankName =mTran:Find("Content/OpenBankName/PopupList/Label"):GetComponent(typeof(UILabel))
	self.mObj_OpenBankName = mTran:Find("Content/OpenBankName/PopupList").gameObject
	UIEventListener.Get(self.mObj_OpenBankName).onClick = function()self:onPupupButton() end
	self.mBox_OpenBankName = self.mObj_OpenBankName:GetComponent(typeof(BoxCollider))
	local mObj_Popup = mTran:Find("Content/OpenBankName/PopupWindow").gameObject
	self.mView_Popup = PopupWindow.New(mObj_Popup)

	self.mInput_OpenChildBankName=mTran:Find("Content/OpenChildBankName"):GetComponent(typeof(UIInput))
	self.mObj_BindBankButton=mTran:Find("Content/Button_Sure").gameObject
	self.mObj_CloseBankButton=mTran:Find("Content/Button_Close").gameObject
	self.mFunc_BindBankSucCallBack=nil
	UIEventListener.Get(self.mObj_BindBankButton).onClick = function()self:OnClickBindBankButton() end
	UIEventListener.Get(self.mObj_CloseBankButton).onClick = function()self:OnClickCloseButton() end

	self.ZhifuBaoName = nil
	self.BankName = nil

	LuaPanel.InitUI(self)
end

--new
function HallExchangeBindPanel:OnClickBindZhiFuBaoButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local name = self.ZhifuBaoName
	if name == nil then
		name=self.mInput_ZhiFuBaoName.value
	end
	local card=self.mInput_ZhiFuBaoCard.value

	if name==nil or name=="" then
		UIManager:GetInstance():ShowNoteMessage("收款人姓名不能为空！")
		return
	end

	if ConTainsSpecial(name) then
		UIManager:GetInstance():ShowNoteMessage("收款姓名不能包含特殊字符")
		return
	end

	if card==nil or card=="" then
		UIManager:GetInstance():ShowNoteMessage("User_Account_Null")
		return
	end

	if ConTainsSpecial(card) then
		UIManager:GetInstance():ShowNoteMessage("账号不能包含特殊字符")
		return
	end

	local callBack= function (data)
		if self.mFunc_BindZhiFuBaoSucCallBack then
			local mData={}
			mData.card=data.Account
			mData.name=data.relName
			self.mFunc_BindZhiFuBaoSucCallBack(mData)
		end
	end

	HallExchangeModel.GetInstance():BindingAccount(card,name,"","",HallExchangeModel.BindType.ZhiFuBao,callBack)

end
function HallExchangeBindPanel:OnClickBindBankButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local name = self.BankName
	if name == nil then
		name=self.mInput_BankName.value
	end
	local card=self.mInput_BankCard.value
	local bankname = self.mLabel_OpenBankName.text
	local bankBranchName = self.mInput_OpenChildBankName.value 
	
	if name==nil or name=="" then
		UIManager:GetInstance():ShowNoteMessage("收款人姓名不能为空！")
		return
	end

	if ConTainsSpecial(name) then
		UIManager:GetInstance():ShowNoteMessage("收款姓名不能包含特殊字符")
		return
	end

	if card==nil or card=="" then
		UIManager:GetInstance():ShowNoteMessage("User_Account_Null")
		return
	end

	if ConTainsSpecial(card) then
		UIManager:GetInstance():ShowNoteMessage("账号不能包含特殊字符")
		return
	end



	if bankname==nil or bankname=="" or bankname == "请选择开户行" then
		UIManager:GetInstance():ShowNoteMessage("开户行不能为空")
		return
	end
	
	if ConTainsSpecial(bankname) then
		UIManager:GetInstance():ShowNoteMessage("开户行不能包含特殊字符")
		return
	end

	if bankBranchName==nil or bankBranchName=="" then
		UIManager:GetInstance():ShowNoteMessage("开户行支行不能为空")
		return
	end
	
	if ConTainsSpecial(bankBranchName) then
		UIManager:GetInstance():ShowNoteMessage("开户行支行不能包含特殊字符")
		return
	end

	local callBack= function (data)
		UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchangeBind)
		if self.mFunc_BindBankSucCallBack then
			local mData={}
			mData.card=data.Account
			mData.name=data.relName
			self.mFunc_BindBankSucCallBack(mData)
		end
	end

	HallExchangeModel.GetInstance():BindingAccount(card,name,bankname,bankBranchName,HallExchangeModel.BindType.Bank,callBack)
end


function HallExchangeBindPanel:OnClickCloseButton()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self.mFunc_BindBankSucCallBack=nil
	self.mFunc_BindZhiFuBaoSucCallBack=nil
	self.mInput_BankCard.value = ""
	self.mInput_BankName.value = ""
	self.mInput_ZhiFuBaoCard.value = ""
	self.mInput_ZhiFuBaoName.value = ""
	self.mLabel_OpenBankName.text = "请选择开户行"
	self.mInput_OpenChildBankName.value = ""
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchangeBind)
end

function HallExchangeBindPanel:OpenBindZhiFuBaoView(sucCallBack)
	self.mPanel_BindZhiFuBao.gameObject:SetActive(true)
	self.mPanel_BindBank.gameObject:SetActive(false)
	self.mFunc_BindZhiFuBaoSucCallBack=sucCallBack

	self.mInput_ZhiFuBaoCard.value = HallExchangeModel:GetInstance().AliPayData.Account == nil and "" or HallExchangeModel:GetInstance().AliPayData.Account
	self.mInput_ZhiFuBaoName.value = GetStringNotFull(HallExchangeModel:GetInstance().AliPayData.relName)

	if HallExchangeModel:GetInstance().AliPayData.Account ~= nil and HallExchangeModel:GetInstance().AliPayData.Account~="" then
		self.ZhifuBaoName = HallExchangeModel:GetInstance().AliPayData.relName
		self.mInput_ZhiFuBaoCard:GetComponent(typeof(BoxCollider)).enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		self.mInput_ZhiFuBaoName:GetComponent(typeof(BoxCollider)).enabled = false
		self.mObj_BindZhiFuBaoButton:GetComponent(typeof(BoxCollider)).enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		local color = ConfigModuleModel.GetInstance().CanChanangeBindInfo and 1 or 0
		self.mObj_BindZhiFuBaoButton:GetComponent(typeof(UISprite)).color = Color(color,1,1)
	else
		self.mInput_ZhiFuBaoCard:GetComponent(typeof(BoxCollider)).enabled = true
		self.mInput_ZhiFuBaoName:GetComponent(typeof(BoxCollider)).enabled = true
		self.mObj_BindZhiFuBaoButton:GetComponent(typeof(BoxCollider)).enabled = true
		self.mObj_BindZhiFuBaoButton:GetComponent(typeof(UISprite)).color = Color(1,1,1)
	end
	
end

function HallExchangeBindPanel:OpenBindBankView(sucCallBack)
	self.mPanel_BindZhiFuBao.gameObject:SetActive(false)
	self.mPanel_BindBank.gameObject:SetActive(true)
	self.mFunc_BindBankSucCallBack=sucCallBack

	self.mInput_BankCard.value =  HallExchangeModel:GetInstance().BankData.Account == nil and "" or  HallExchangeModel:GetInstance().BankData.Account
	self.mInput_BankName.value =   GetStringNotFull(HallExchangeModel:GetInstance().BankData.relName)
	
	self.mLabel_OpenBankName.text = CheckServiceJsonDataIsNullOrEmpty(HallExchangeModel:GetInstance().BankData.Bank_Bankname) == nil and "请选择开户行" or  HallExchangeModel:GetInstance().BankData.Bank_Bankname
	self.mInput_OpenChildBankName.value = HallExchangeModel:GetInstance().BankData.Bank_Bankbranch == nil and "" or  HallExchangeModel:GetInstance().BankData.Bank_Bankbranch

	if  HallExchangeModel:GetInstance().BankData.Account ~= nil and HallExchangeModel:GetInstance().BankData.Account~="" then
		self.BankName = HallExchangeModel:GetInstance().BankData.relName
		self.mInput_BankCard:GetComponent(typeof(BoxCollider)).enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		self.mInput_BankName:GetComponent(typeof(BoxCollider)).enabled = false
		self.mBox_OpenBankName.enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		self.mInput_OpenChildBankName:GetComponent(typeof(BoxCollider)).enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		self.mObj_BindBankButton:GetComponent(typeof(BoxCollider)).enabled = ConfigModuleModel.GetInstance().CanChanangeBindInfo
		local color = ConfigModuleModel.GetInstance().CanChanangeBindInfo and 1 or 0
		self.mObj_BindBankButton:GetComponent(typeof(UISprite)).color = Color(color,1,1)
	else
		self.mInput_BankCard:GetComponent(typeof(BoxCollider)).enabled = true
		self.mInput_BankName:GetComponent(typeof(BoxCollider)).enabled = true
		self.mBox_OpenBankName.enabled = true
		self.mInput_OpenChildBankName:GetComponent(typeof(BoxCollider)).enabled = true
		self.mObj_BindBankButton:GetComponent(typeof(BoxCollider)).enabled = true
		self.mObj_BindBankButton:GetComponent(typeof(UISprite)).color = Color(1,1,1)
	end
end

function HallExchangeBindPanel:ShowPanel(back)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	if not self.IsInitOpenBankNameList then 
		HallExchangeBindModel.GetInstance():GetOpenBankNameList(self.GetOpenBankNameListBack,self)
	end
	LuaPanel.ShowPanel(self,back)
end

function HallExchangeBindPanel:GetOpenBankNameListBack(dataList)
	self.IsInitOpenBankNameList = true
	if CheckServiceJsonDataIsNullOrEmpty(dataList ~= nil) then
		self.mView_Popup:SetBankListData(dataList,self.OnPopupListWindowClick,self)
	end
end

function HallExchangeBindPanel:onPupupButton(obj)
	self.mView_Popup:DisplayPopuwindow(true)
end

function HallExchangeBindPanel:OnPopupListWindowClick(bankName)
	self.mLabel_OpenBankName.text = bankName
	self.mView_Popup:DisplayPopuwindow(false)
end

--设置子panel的深度
 function HallExchangeBindPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.mPanel_BindBank.depth=depth+5
	self.mPanel_BindZhiFuBao.depth=depth+6
	self.mView_Popup:SetPopupViewDepth(depth)
end

function HallExchangeBindPanel:__delete( ... )
	
end
