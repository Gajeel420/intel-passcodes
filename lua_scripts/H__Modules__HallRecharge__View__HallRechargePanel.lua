HallRechargePanel = HallRechargePanel or BaseClass(LuaPanel)

function HallRechargePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRecharge].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRecharge].path
	self.mPanelID = UIPanelDefine.EWndID.HallRecharge
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallRechargePanel:InitUI()
	local mTran = self.obj.transform
	self.mCurrentData = nil
	self.IsSdkPay = 0
	self.CurrentPayType = 0
	
	self.mObj_CloseButton=mTran:Find("Content/Common/ButtonGrid/Btn_Back/Background").gameObject
	UIEventListener.Get(self.mObj_CloseButton).onClick=function() self:OnClickCloseButton() end
	self.mObjList_Buttons={}
	self.mObjList_select = {}
	self.mObjList_unselect = {}
	self.mTransform_ButtonGrid=mTran:Find("Content/Common/ButtonGrid/ScrollView/Btn")
	self.mGrid_ButtonGrid=mTran:Find("Content/Common/ButtonGrid/ScrollView/Btn"):GetComponent(typeof(UIGrid))
	self.mPanel_Button =mTran:Find("Content/Common/ButtonGrid/ScrollView").gameObject:GetComponent(typeof(UIPanel))
	for i = 1, self.mTransform_ButtonGrid.childCount do
		UIEventListener.Get(self.mTransform_ButtonGrid:GetChild(i-1).gameObject).onClick=function (go)self:OnClickButtonToggle(go)end
		local buttonObj= self.mTransform_ButtonGrid:GetChild(i-1).gameObject
		buttonObj:SetActive(false)
		table.insert(self.mObjList_Buttons,buttonObj )
		local select = buttonObj.transform:Find("Checkmark").gameObject
		table.insert(self.mObjList_select,select )
		local unselect = buttonObj.transform:Find("Back").gameObject
		table.insert(self.mObjList_unselect,unselect)
	end
	self.mObjList_AllView={}

	self.mAgentButton = mTran:Find("Content/Common/ButtonGrid/ScrollView/Btn/AgentPay").gameObject

	--RMBInputView
	self.mObj_RBMInputView=mTran:Find("Content/Common/RMBInputView").gameObject
	self.mObj_RBMDeleteButton=mTran:Find("Content/Common/RMBInputView/Button_Delect").gameObject
	self.mObj_RBMButtonGrid=mTran:Find("Content/Common/RMBInputView/ScrollView/Button").gameObject
	self.mPanelScrollView = mTran:Find("Content/Common/RMBInputView/ScrollView").gameObject:GetComponent(typeof(UIPanel))
	self.mScrollView = self.mPanelScrollView:GetComponent(typeof(UIScrollView))
	self.mGrid_RBMButtonGrid=mTran:Find("Content/Common/RMBInputView/ScrollView/Button"):GetComponent(typeof(UIGrid))
	self.mObj_RBMButtonTemplate=mTran:Find("Content/Common/RMBInputView/ScrollView/Button/Item").gameObject
	
	self.mObj_RBMImmediatelyButton=mTran:Find("Content/Common/RMBInputView/Button_Immediately").gameObject
	self.mInput_RMBInput=mTran:Find("Content/Common/RMBInputView/Input"):GetComponent(typeof(UIInput))
	table.insert(self.mObjList_AllView, self.mObj_RBMInputView)
	UIEventListener.Get(self.mObj_RBMDeleteButton).onClick=function() self:OnClickRBMDeleteButton() end
	UIEventListener.Get(self.mObj_RBMImmediatelyButton).onClick=function() self:OnClickRBMImmediatelyButton() end
	self.mObj_RBMButtonTemplate:SetActive(false)
	self.mList_RMBButtonList={}
	self.mList_ItemSelectBg = {}
	self.mObj_ZhiFuBaoView=mTran:Find("Content/ZhiFuBaoContent").gameObject
	self.mView_Alipay = RechargeView.New(self.mObj_ZhiFuBaoView)
	table.insert(self.mObjList_AllView, self.mObj_ZhiFuBaoView)
	self.mObj_WeiXinView=mTran:Find("Content/WeiXinContent").gameObject
	self.mView_Wechat = RechargeView.New(self.mObj_WeiXinView)
	table.insert(self.mObjList_AllView, self.mObj_WeiXinView)
	self.mObj_DianKaView=mTran:Find("Content/DianKaContent").gameObject
	table.insert(self.mObjList_AllView, self.mObj_DianKaView)
	self.mDianKa_DianKaView=UIDianKa.New(self.mObj_DianKaView)
	self.VipViewObj = mTran:Find("Content/VIPContent").gameObject
	table.insert(self.mObjList_AllView,self.VipViewObj)
	self.VipView = UIDaili.New(self.VipViewObj)
	self.DailiDetailObj = mTran:Find("Content/DaiLi").gameObject
	table.insert(self.mObjList_AllView,self.DailiDetailObj)
	self.DaiLiView = UIDaiLiDetailPanel.New(self.DailiDetailObj)
	local mObj_QuickPay = mTran:Find("Content/QuickPayContents").gameObject
	table.insert(self.mObjList_AllView,mObj_QuickPay)
	self.mQuickPayMent = QuickPaymentView.New(mObj_QuickPay)

	self.mObj_JingDongView=mTran:Find("Content/JingDongContent").gameObject
	self.mView_JingDong = RechargeView.New(self.mObj_JingDongView)
	table.insert(self.mObjList_AllView, self.mObj_JingDongView)
	self.mObj_BankQuicView=mTran:Find("Content/BankQuickContent").gameObject
	self.mView_BankQuickView = RechargeView.New(self.mObj_BankQuicView)
	table.insert(self.mObjList_AllView, self.mObj_BankQuicView)
	self.mObj_CloubFlash = mTran:Find("Content/YunShanFuContent").gameObject
	table.insert(self.mObjList_AllView,self.mObj_CloubFlash)

	self.mLabel_CloudFlashUID = mTran:Find("Content/YunShanFuContent/Common/UserInfo/UID/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_CloudFlashUID.text = 0
	self.mLabel_CloudFlashTips = mTran:Find("Content/YunShanFuContent/Common/WechatTips/tipsLabel").gameObject:GetComponent(typeof(UILabel))
	local mObj_CopyCloudFlashUID = mTran:Find("Content/YunShanFuContent/Common/UserInfo/UID/BtnCopy").gameObject
	UIEventListener.Get(mObj_CopyCloudFlashUID).onClick=function(go) self:OnButtonCopy(go) end

	self.labelMineMoney = mTran:Find("Content/Common/Bg/Player_Money/Money/Label_Value"):GetComponent(typeof(UILabel))
	-- self.m_Btn_RefreshMoney = mTran:Find("Content/Common/Bg/Player_Money/Money/Button_Add").gameObject
	-- UIEventListener.Get(self.m_Btn_RefreshMoney).onClick = function ()
	-- 	 --请求刷新用户金币信息
	-- 	 PlayerInfoController:GetInstance():RequestGetUserMoney()
	-- end
	--充值所需参数界面
	self.m_Go_Content2 = mTran:Find("Content2").gameObject
	self.m_Go_Content2:SetActive(false)
	self.m_Panel_Contetnt2 = self.m_Go_Content2:GetComponent(typeof(UIPanel))
	self.m_Input_Account = mTran:Find("Content2/Account/Input"):GetComponent(typeof(UIInput))
	self.m_Input_Phone = mTran:Find("Content2/Phone/Input"):GetComponent(typeof(UIInput))
	self.m_Input_Password = mTran:Find("Content2/Password/Input"):GetComponent(typeof(UIInput))
	self.m_Input_Account.value = ""
	self.m_Input_Phone.value = ""
	self.m_Input_Password.value = ""
	self.m_Btn_CloseContent2 = mTran:Find("Content2/Button_Close").gameObject
	UIEventListener.Get(self.m_Btn_CloseContent2).onClick = function ()
		self:OnClickCloseContent2()
	end
	self.m_Btn_SureContent2 = mTran:Find("Content2/Button_Sure").gameObject
	UIEventListener.Get(self.m_Btn_SureContent2).onClick = function ()
		self:OnClickSureContent2()
	end
	self.m_Key_RechargeAccount = "m_Key_RechargeAccount"
	self.m_Key_RechargeEmail = "m_Key_RechargeEmail"
	self.m_Key_RechargePhone = "m_Key_RechargePhone"

	--当前选中的充值类型 

	

	self.mCurrentRechargeType=nil

	self:AddEvent()

	self:CloseAllView()
	local mObjRechargeRecord = mTran:Find("Content/RechargeRcord")

	self.mObjTryAgain = mTran:Find("Content/Content_Try").gameObject
	self.mObjTryAgain:SetActive(false)
	local mBtnTryAgain =  mTran:Find("Content/Content_Try/Button_Try").gameObject
	UIEventListener.Get(mBtnTryAgain).onClick = function() self:OnClickTryAgain() end

	self.mList_Tween={}
	local mTweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
	table.insert(self.mList_Tween,mTweenScale )
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(self.mList_Tween)

	--googlePay
	self.m_Go_GooglePay = mTran:Find("Content/Common/ButtonGrid/ScrollView/Btn/GooglePay").gameObject
	self.m_Go_AliPay = mTran:Find("Content/Common/ButtonGrid/ScrollView/Btn/AliPay").gameObject
	self.m_Go_RMBInputView02 = mTran:Find("Content/Common/RMBInputView02").gameObject
	self.m_Panel_RMBInputView02 = mTran:Find("Content/Common/RMBInputView02/ScrollView"):GetComponent(typeof(UIPanel))
	self.m_Scroll_RMBInputView02 = mTran:Find("Content/Common/RMBInputView02/ScrollView"):GetComponent(typeof(UIScrollView))
	self.m_Grid_RMBInputView02 = mTran:Find("Content/Common/RMBInputView02/ScrollView/Button"):GetComponent(typeof(UIGrid))
	self.m_ItemPrefabs_RMBInputView02 = mTran:Find("Content/Common/RMBInputView02/ScrollView/Button/Item").gameObject
	self.m_ItemPrefabs_RMBInputView02:SetActive(false)
	self.m_ItemList_RMBInputView02 = {}
	

	self.IsopenAgentPayView = false

	self.AlipayList = {}
	self.WeiChatList = {}
	self.AlipayListQR = {}
	self.JingDongList = {}
	self.mQuickPaymentList = {}
	self.BankQuickPayList = {}
	self.mRechargeRecordView = RechargeRecordView.New(mObjRechargeRecord,function()
		LuaPanel.InitUI(self)
	end)

end


-------------------------------------New start---------------------------------------

function HallRechargePanel:OnClickCloseContent2()
	SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self.m_Go_Content2:SetActive(false)
end

function HallRechargePanel:OnClickSureContent2()
	SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.m_Go_Content2:SetActive(false)

	local m_Phone = self.m_Input_Phone.value
	if m_Phone == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RechargeTip_Phone"))
        return
    end
	local m_email = self.m_Input_Password.value
    if m_email== "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RechargeTip_Email"))
        return
    end

	local m_account = self.m_Input_Account.value
    if m_account == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RechargeTip_Account"))
        return
    end


	local userID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	PlayerPrefs.SetString(self.m_Key_RechargeAccount..userID,m_account)
	PlayerPrefs.SetString(self.m_Key_RechargeEmail..userID,m_email)
	PlayerPrefs.SetString(self.m_Key_RechargePhone..userID,m_Phone)

	--去充值
	if self.mCurrentRechargeType~=nil  then
		if self.IsSdkPay == "0" then
			RechargeManager:GetInstance():OpenH5Pay(self.mCurrentRechargeType,self.mCurrentData.iRmbNum,self.mCurrentData.iID,m_Phone,m_email,m_account)
		else
			RechargeManager:GetInstance():H5Pay3(self.mCurrentRechargeType,self.mCurrentData.iRmbNum,self.mCurrentData.iID,self.IsSdkPay,m_Phone,m_email,m_account)
		end
	else
		UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("Please_Select_Amount"),1)
	end
end

function HallRechargePanel:OnButtonCopy(go)
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:MyClipDataToClipboard(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end 

function HallRechargePanel:OnClickTryAgain()
	SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	StoreModuleController:GetInstance():RequiredPayMoneyList()
	self:SetObjTryAgainDisplay(false)
end

function HallRechargePanel:SetObjTryAgainDisplay(display)
	self.mObjTryAgain:SetActive(display)
end

--content
function HallRechargePanel:OnClickCloseButton()
	--SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self.IsopenAgentPayView = false
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallRecharge)
	--处理体现按钮
	if HallGroupController:GetInstance().view.panel then
		HallGroupController:GetInstance().view.panel:RequestHandleGooglePay()
	end
end

function HallRechargePanel:OnClickButtonToggle(buttonObj)
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	self:CloseAllView()
	for i = 1, #self.mObjList_Buttons do
		local obj=self.mObjList_Buttons[i]
		self.mObjList_select[i]:SetActive(obj == buttonObj)
		self.mObjList_unselect[i]:SetActive(obj ~= buttonObj)
	end
	self.mCurrentData = nil
	if buttonObj.name=="AliPay" then
		self:OpenZhiFuBaoView(HallDefine.StoreType.AliPay)
	elseif buttonObj.name=="AgentPay" then
		self:OpenVipView()
	elseif buttonObj.name=="WechatPay" then
		self:OpenWeiXinView(HallDefine.StoreType.WeChatPay)
	elseif buttonObj.name=="PointCard" then
		self:OpenDianKaView()
	elseif buttonObj.name=="ScanCodeToPay" then
		self:OpenZhiFuBaoView(HallDefine.StoreType.AlipayQR)
	elseif buttonObj.name == "BankTransfer" then
		self:OpenQuickPayView()
	elseif buttonObj.name == "CloudFlash" then
		self:OpenCloudFlashView(HallDefine.StoreType.YunShanFu)
	elseif buttonObj.name == "JDPay" then
		self:OpenJingDongView(HallDefine.StoreType.JingDong)
	elseif buttonObj.name == "BankQuickPay" then
		self:OpenBankQuickView(HallDefine.StoreType.BankQuickPay)
	elseif buttonObj.name == "GooglePay" then
		self:OpenGooglePayView()
	end
end

function HallRechargePanel:OpenAgentView()
	self.IsopenAgentPayView = true
end


function HallRechargePanel:CloseAllView()
	for i = 1,#self.mObjList_AllView  do
		local obj=self.mObjList_AllView[i]
		obj:SetActive(false)
	end
	self:SetSelectState(0)
end

function HallRechargePanel:CloseAllButtonItem()
	for i = 1, #self.mObjList_Buttons do
		self.mObjList_Buttons[i]:SetActive(false)
	end
end


--RMBInput
function HallRechargePanel:OpenRMBInputView(payItemList,payType,IsSdkPay)
	self.mInput_RMBInput.value=""
	self.mObj_RBMInputView:SetActive(true)
	if payType ~= nil then
		self.mCurrentRechargeType = payType
	end
	-- if IsSdkPay ~= nil then
	-- 	if tonumber(IsSdkPay) == 1 and self.CurrentPayType == 1 then
	-- 		self.IsSdkPay = 1
	-- 	elseif tonumber(IsSdkPay) == 1 and self.CurrentPayType == 2 then
	-- 		self.IsSdkPay = 2
	-- 	else
	-- 		self.IsSdkPay = 0
	-- 	end
	-- else
	-- 	self.IsSdkPay = 0
	-- end
	self.IsSdkPay = IsSdkPay == nil and "0" or IsSdkPay
	if payItemList == nil then
		payItemList=StoreModuleModel:GetInstance():GetPayItemListByType(self.mCurrentRechargeType)
	end
	self:InitRMBButtonGrid(payItemList)
end



function HallRechargePanel:OnClickRBMDeleteButton()
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:SetSelectState(0)
	self.mInput_RMBInput.value=""
end

function HallRechargePanel:OnClickRBMImmediatelyButton()
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local userID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	self.m_Input_Phone.value = PlayerPrefs.GetString(self.m_Key_RechargePhone..userID,"")
	self.m_Input_Password.value = PlayerPrefs.GetString(self.m_Key_RechargeEmail..userID,"")
	self.m_Input_Account.value = PlayerPrefs.GetString(self.m_Key_RechargeAccount..userID,"")
	self.m_Go_Content2:SetActive(true)
end

function HallRechargePanel:OnClickRBMOptionButton(data,index)
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self.mCurrentData = data
	self.mInput_RMBInput.value=data.iRmbNum
	self:SetSelectState(index)
end

function HallRechargePanel:SetSelectState(index)
	for i = 1, #self.mList_ItemSelectBg do
		self.mList_ItemSelectBg[i]:SetActive(i == index)
	end
end

--1：支付宝，2：微信支付，3：点卡充值，4：代理充值，5：苹果支付，6：QQ钱包，7：京东支付，8：银联支付，9：网银支付
function HallRechargePanel:InitRMBButtonGrid(payItemList)
	self.mObj_RBMInputView:SetActive(true)

	for i = 1, #self.mList_RMBButtonList do
		self.mList_RMBButtonList[i]:SetActive(false)
		self.mList_ItemSelectBg[i]:SetActive(false)
	end
	
	local index=0
	if not payItemList or not next(payItemList) then 
		return 
	end

	for i,itemVo in ipairs(payItemList) do
		index=index+1
		if self.mList_RMBButtonList[index]==nil then
			local item=GameObject.Instantiate(self.mObj_RBMButtonTemplate,self.mObj_RBMButtonGrid.transform)
			self.mList_RMBButtonList[index]=item
		end
		local item=self.mList_RMBButtonList[index]
		item.name=tostring(itemVo.iRmbNum)
		item.transform:Find("Label"):GetComponent(typeof(UILabel)).text=StringFormat("{0}",tostring(itemVo.iRmbNum))
		local selectBG = item.transform:Find("BackSelect").gameObject
		selectBG:SetActive(false)
		self.mList_ItemSelectBg[index] = selectBG 
		UIEventListener.Get(item).onClick=function(buttonObj) self:OnClickRBMOptionButton(itemVo,i) end
		item:SetActive(true)
	end
	self.mGrid_RBMButtonGrid:Reposition()
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.mScrollView:ResetPosition()
	end)
	

end


function HallRechargePanel:OpenCloudFlashView(zhifuType)
	self.mCurrentRechargeType=zhifuType
	if CheckServiceJsonDataIsNullOrEmpty(StoreModuleModel:GetInstance().Payprompt[tostring(HallDefine.StoreType.YunShanFu)]) == nil then
		if CheckServiceJsonDataIsNullOrEmpty(ConfigModuleModel.GetInstance().PayListConfig.CloudFlash.Tips) ~= nil then
			--self.mLabel_CloudFlashTips.text = ConfigModuleModel.GetInstance().PayListConfig.CloudFlash.Tips
		end
	else
		--self.mLabel_CloudFlashTips.text = StoreModuleModel:GetInstance().Payprompt[tostring(HallDefine.StoreType.YunShanFu)]
	end
	self.mObj_CloubFlash:SetActive(true)
	self:OpenRMBInputView()
	
end

function HallRechargePanel:OpenGooglePayView()
	self.m_Go_RMBInputView02:SetActive(true)

	--测试代码
	local payItemList = HallRechargeModel:GetInstance().googlePayList
	-- print("------------------------------ HallRechargePanel:OpenGooglePayView ")
	-- pt(payItemList)

	if payItemList == nil or #payItemList<=0 then
		print("--------------------- google pay 没数据")
		return
	end

	for i = 1, #self.m_ItemList_RMBInputView02 do
		self.m_ItemList_RMBInputView02[i]:SetObjActive(false)
	end
	for i = 1, #payItemList do
		if not self.m_ItemList_RMBInputView02[i] then
			go = InstantiateNewGameObject(self.m_ItemPrefabs_RMBInputView02,self.m_Grid_RMBInputView02.transform,i)
			self.m_ItemList_RMBInputView02[i] = GooglePayItem.New(go)
			self.m_ItemList_RMBInputView02[i]:InitIndex(i)
		end
		self.m_ItemList_RMBInputView02[i]:SetData(payItemList[i])
	end
	self.m_Grid_RMBInputView02:Reposition()
end

function HallRechargePanel:GooglePayCallBack(context)
	print("---------------------------------------  GooglePayCallBack")
    if context == nil then return end
    if context.m_data == nil then return end 
    local str = context.m_data[0]
    if str == nil then return end 

    if str then
        local data = Json.decode(str)
        pt(data)
        local resultCode = data.resultCode
        --0:成功  1：取消  2：错误
        if resultCode == 0 then
			local money =  HallRechargeModel:GetInstance().orderMoney
			local orderID =  HallRechargeModel:GetInstance().orderID
			HallRechargeController:GetInstance():SendGooglePayNotify(orderID,data.orderId,money,function ()
				--请求刷新用户金币信息
				PlayerInfoController:GetInstance():RequestGetUserMoney()
				UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("GooglePayResultSuccess"))
			end)
        elseif resultCode == 1 then
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("GooglePayResultCancel"))
        else
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("GooglePayResultFailed"))
        end
    end
end

--ZhiFuBao
function HallRechargePanel:OpenZhiFuBaoView(zhifuType)
	self.mCurrentRechargeType=zhifuType
	if self.mCurrentRechargeType == HallDefine.StoreType.AliPay then
		self.mView_Alipay:SetData(self.AlipayList)
	else
		self.mView_Alipay:SetData(self.AlipayListQR)
	end
	if self.mObj_ZhiFuBaoView.activeSelf then
		self.mObj_ZhiFuBaoView:SetActive(false)
	end

	if self.m_Go_RMBInputView02.activeSelf then
		self.m_Go_RMBInputView02:SetActive(false)
	end
	
end
--ZhiFuBao

---JD
function HallRechargePanel:OpenJingDongView(zhifuType)
	self.mCurrentRechargeType=zhifuType
	self.mView_JingDong:SetData(self.JingDongList)
end
---JD

---打开银行快捷
function HallRechargePanel:OpenBankQuickView(zhifuType)
	self.mCurrentRechargeType=zhifuType
	self.mView_BankQuickView:SetData(self.BankQuickPayList)
end

function HallRechargePanel:OpenQuickPayView()
	self.mCurrentRechargeType=HallDefine.StoreType.QuickPayment
	self.mQuickPayMent:ShowView(self.mQuickPaymentList)
end

function HallRechargePanel:OpenQuickPayView()
	self.mCurrentRechargeType=HallDefine.StoreType.QuickPayment
	self.mQuickPayMent:ShowView(self.mQuickPaymentList)
end


--WeiXin 微信
function HallRechargePanel:OpenWeiXinView(zhifuType)
	self.mCurrentRechargeType=zhifuType
	
	self.mView_Wechat:SetData(self.WeiChatList)
	
end
--WeiXin

--DianKa
function HallRechargePanel:OpenDianKaView()
	self.mCurrentRechargeType=HallDefine.StoreType.Dianka
	self.mDianKa_DianKaView:ShowUI()
end
--DianKa
function HallRechargePanel:OpenVipView()
	self.mCurrentRechargeType=HallDefine.StoreType.DaiLi
	self.VipView:ShowUI()
end


-------------------------------------New end---------------------------------------

function HallRechargePanel:AddEvent()
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	--StoreModuleModel:GetInstance():AddEventListener(StoreModuleConst.EventName_RequiredPayMoneyListCallBack,self.RequiredPayMoneyListCallBack,self)
	PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerVo,self)
	LuaEvent:AddEventListener(EventName.GooglePayResult,self.GooglePayCallBack,self)
end

function HallRechargePanel:RemoveEvent( ... )
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerVo,self)
	--StoreModuleModel:GetInstance():RemoveEventListener(StoreModuleConst.EventName_RequiredPayMoneyListCallBack,self.RequiredPayMoneyListCallBack,self)
	LuaEvent:RemoveEventListener(EventName.GooglePayResult,self.GooglePayCallBack,self)
end

function HallRechargePanel:ResetPanel( ... )

end

function HallRechargePanel:OnDailItemClick( vo)
	-- body
	self.DaiLiView:ShowUI(vo)
end

function HallRechargePanel:UpdatePlayerVo(context)
	print("--------------------- HallRechargePanel:UpdatePlayerVo 11 ")
	if not context then return end
	local key=context[1]
	local newValue=context[2]
	local oldValue=context[3]
	if key=="iMoney" then
		print("---------------------HallRechargePanel:UpdatePlayerVo  22 ",newValue)
		SetNumberLabel( self.labelMineMoney,newValue )
	end
end

function HallRechargePanel:UpdatePlayerVoNew(newValue)
	print("---------------------HallRechargePanel:UpdatePlayerVoNew  11 ",newValue)
	SetNumberLabel( self.labelMineMoney,newValue )
end

function HallRechargePanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self.m_Go_Content2:SetActive(false)
	LuaPanel.ShowPanel(self,callBack)
	self.mLabel_CloudFlashUID.text = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_recharge)
	self.mRechargeRecordView:ShowView()
	--StoreModuleController:GetInstance():RequiredPayMoneyList()
	self:RequiredPayMoneyListCallBack()
	self.mTweenPlayer:ParallelPlay(false)
	SetNumberLabel( self.labelMineMoney,PlayerInfoController:GetInstance().model.mainPlayer.iMoney )

	HallRechargeController:GetInstance():SendGooglePay(function (data)
		self:HandleGooglePay(data)
	end)
end

function HallRechargePanel:HandleGooglePay(data)
	if data.googlepay_status == 1 then
		--打开我们自己的支付按钮
		self.m_Go_GooglePay:SetActive(true)
		self.m_Go_AliPay:SetActive(true)
		self:OnClickButtonToggle(self.m_Go_AliPay)
	else
		self.m_Go_GooglePay:SetActive(true)
		self.m_Go_AliPay:SetActive(false)
		self:OnClickButtonToggle(self.m_Go_GooglePay)
	end
	self.mGrid_ButtonGrid:Reposition()
end

function HallRechargePanel:HidePanel( ... )
	self:CloseAllView()
	self:CloseAllButtonItem()
	--self:OnClickButtonToggle(self.mObjList_Buttons[1])
	--SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_recharge)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self.mRechargeRecordView:HideView()
	LuaPanel.HidePanel(self)
end



function HallRechargePanel:OpenSeleteByTypeList()
	
	self:CloseAllView()

	for i = 1, #self.mObjList_Buttons do
		self.mObjList_Buttons[i]:SetActive(false)
	end

	local recommendArray=StoreModuleModel.GetInstance().SortList
	if recommendArray == nil then 
		return 
	end
	local itemIndex=0  ---排序
	for i = 1, #recommendArray do
		local typeString = nil
		local type= tonumber(recommendArray[i])
		local payList = nil
		if type==HallDefine.StoreType.AliPay then
			typeString="AliPay"
			self.AlipayList = HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().alipay)
			if #self.AlipayList > 0 then
				payList = self.AlipayList
			else
				payList = "1"
			end
		elseif type== HallDefine.StoreType.AlipayQR then
			typeString = "ScanCodeToPay"
			self.AlipayListQR =  HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().AlipayQR)
			if #self.AlipayListQR > 0 then
				payList = self.AlipayListQR
			else
				payList = "1"
			end
		elseif type==HallDefine.StoreType.WeChatPay then
			typeString="WechatPay"
			self.WeiChatList = HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().weixin)
			if #self.WeiChatList > 0 then
				payList = self.WeiChatList
			else
				payList = "1"
			end
		elseif type==HallDefine.StoreType.Dianka then
			typeString="PointCard"		
		elseif type==HallDefine.StoreType.DaiLi then
			typeString="AgentPay"
			payList = StoreModuleModel:GetInstance().DailiData
		elseif type== HallDefine.StoreType.QuickPayment then
			typeString = "BankTransfer"
			self.mQuickPaymentList = HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().QuickDatalist)
			if #self.mQuickPaymentList > 0 then
				payList = self.mQuickPaymentList
			else
				payList = "1"
			end
		elseif type== HallDefine.StoreType.YunShanFu then
			payList = StoreModuleModel:GetInstance():GetPayItemListByType(HallDefine.StoreType.YunShanFu)
			typeString = "CloudFlash"
		elseif type== HallDefine.StoreType.JingDong then
			typeString = "JDPay"
			self.JingDongList =  HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().JingDong)
			if #self.JingDongList > 0 then
				payList = self.JingDongList
			else
				payList = "1"
			end
		elseif type== HallDefine.StoreType.BankQuickPay then
			typeString = "BankQuickPay"
			self.BankQuickPayList =  HallRechargeModel.GetInstance():CheckPayListNull(StoreModuleModel:GetInstance().BankQuickData)
			if #self.BankQuickPayList > 0 then
				payList = self.BankQuickPayList
			else
				payList = "1"
			end
		end

		-- for i = 1, #self.mObjList_Buttons do
		-- 	local payItemList= nil 
		-- 	local button = self.mObjList_Buttons[i]
		-- 	if button.name == typeString then
		-- 		button.transform:SetSiblingIndex(itemIndex)
		-- 		if type == 3   then
		-- 			itemIndex=itemIndex+1
		-- 			self:SetSubscript(button,type)
		-- 			button:SetActive(true)
		-- 		else
		-- 			if payList ~= nil and payList ~= "1" then
						
		-- 				if  next(payList) then
		-- 					itemIndex=itemIndex+1
		-- 					self:SetSubscript(button,type)
		-- 					button:SetActive(true)
		-- 				else
		-- 					button:SetActive(false)
		-- 					break
		-- 				end
		-- 			else
		-- 				button:SetActive(false)
		-- 				break
		-- 			end
		-- 		end
		-- 		-- if itemIndex == 1 then
		-- 		-- 	self:OnClickButtonToggle(button)
		-- 		-- end
		-- 		payList = {}
		-- 		break
		-- 	end
		-- end
	end

	if self.IsopenAgentPayView  then
		self:OnClickButtonToggle(self.mAgentButton)
	end

	self.mGrid_ButtonGrid:Reposition()
end

---设置按钮的角标
function HallRechargePanel:SetSubscript(obj,payType)
	
	local mLable_subscript = obj.transform:Find("Subscript/Lable"):GetComponent(typeof(UILabel))
	local mObj_subscript = obj.transform:Find("Subscript").gameObject
	if mLable_subscript ~= nil then
		mObj_subscript:SetActive(false)
		if CheckServiceJsonDataIsNullOrEmpty(StoreModuleModel:GetInstance().Corner) ~= nil then
			if (payType == 100) then
				payType = 61
			end
			if CheckServiceJsonDataIsNullOrEmpty(StoreModuleModel:GetInstance().Corner[tostring(payType)]) ~= nil and tonumber(StoreModuleModel:GetInstance().Corner[tostring(payType)]) > 0 then
				--mObj_subscript:SetActive(true)
				mLable_subscript.text =StringFormat("返利{0}%",StoreModuleModel:GetInstance().Corner[tostring(payType)]) 
			end
		end
	end
end

function HallRechargePanel:RequiredPayMoneyListCallBack()
	self:InitRMBButtonGrid()
	self.VipView:SetUI(StoreModuleModel:GetInstance().DailiData)
	self.mQuickPayMent:SetData(StoreModuleModel:GetInstance().QuickDatalist)
	
	self:OpenSeleteByTypeList()
end


--设置子panel的深度
 function HallRechargePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.VipView:SetPanelDepth(depth+5)
	self.DailiDetailObj:GetComponent(typeof(UIPanel)).depth=depth+8
	self.mPanelScrollView.depth = depth + 5
	self.m_Panel_RMBInputView02.depth = depth + 5
	self.mRechargeRecordView:SetDepth(depth+5)
	self.mQuickPayMent:SetDepth(depth+5)
	self.mPanel_Button.depth = depth +3
	self.mView_Alipay:SetViewDepth(depth + 5)
	self.mView_Wechat:SetViewDepth(depth + 5)
	self.mView_JingDong:SetViewDepth(depth + 5)
	self.mView_BankQuickView:SetViewDepth(depth + 5)
	self.m_Panel_Contetnt2.depth = depth + 8

end




function HallRechargePanel:__delete( ... )
	self:RemoveEvent()
	self.objSelectRoot = nil
	self.uiSelect = nil
	self.objZhiFuContentRoot = nil
	self.objZhiFuBaoUIRoot = nil
	self.uiZhiFuBao = nil
	self.objDailiRoot = nil
	self.uiDaili = nil
	self.objDianKaRoot = nil
	self.uiDianKa = nil
end
