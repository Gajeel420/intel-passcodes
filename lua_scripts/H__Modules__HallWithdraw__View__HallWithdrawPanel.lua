HallWithdrawPanel = HallWithdrawPanel or BaseClass(LuaPanel)

function HallWithdrawPanel:__init(callBack)
    self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWithdraw].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallWithdraw].path
	self.mPanelID = UIPanelDefine.EWndID.HallWithdraw
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallWithdrawPanel:InitUI()
	local mTran = self.obj.transform
    self.m_Btn_ClosePanel = mTran:Find("Content/Content01/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_ClosePanel).onClick = function ()
        self:OnClickClosePanel()
    end

    self.m_Btn_TiXian = mTran:Find("Content/Content01/Btn_Sure").gameObject
    UIEventListener.Get(self.m_Btn_TiXian).onClick = function ()
        self:OnClickTiXian()
    end

    self.m_Btn_Help = mTran:Find("Content/Content01/Help/Btn_Help").gameObject
    UIEventListener.Get(self.m_Btn_Help).onClick = function ()
        SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
        self.m_Go_Help:SetActive(true)
    end
    self.m_Go_Help = mTran:Find("Content/Content01/Help/Help_Content").gameObject
    self.m_Go_Help:SetActive(false)
    UIEventListener.Get(self.m_Go_Help).onClick = function ()
        SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
        self.m_Go_Help:SetActive(false)
    end

    self.m_Go_Tip_Bind = mTran:Find("Content/Content01/Info/Tip_Bind").gameObject
    self.m_Go_OveerBind = mTran:Find("Content/Content01/Info/OveerBind").gameObject

    self.m_Label_UPI_ID = mTran:Find("Content/Content01/Info/OveerBind/Upi Account/Label_Bank"):GetComponent(typeof(UILabel))
    self.m_Label_UPI_ID.text = ""
    self.m_Btn_AddBind = mTran:Find("Content/Content01/Info/Tip_Bind/Button_Add").gameObject
    UIEventListener.Get(self.m_Btn_AddBind).onClick = function ()
        self:OnClickAddBind()
    end

    self.m_Panel_Content02 = mTran:Find("Content/Content02"):GetComponent(typeof(UIPanel))
    self.m_Panel_Content03 = mTran:Find("Content/Content03"):GetComponent(typeof(UIPanel))
    self.m_Panel_Content04 = mTran:Find("Content/Content04"):GetComponent(typeof(UIPanel))

    self.m_Go_Content01 = mTran:Find("Content/Content01").gameObject
    self.m_Go_Content02 = mTran:Find("Content/Content02").gameObject
    self.m_Go_Content03 = mTran:Find("Content/Content03").gameObject
    self.m_Go_Content04 = mTran:Find("Content/Content04").gameObject

    self.m_MoneyList = {"100", "500", "1000" , "5000"}
    self.m_Panel_Scroll = mTran:Find("Content/Content01/ScrollView"):GetComponent(typeof(UIPanel))
    self.m_Go_ItemList = {}
    self.m_Lanel_ItemList = {}
    for i = 1, #self.m_MoneyList do
        self.m_Go_ItemList[i] = mTran:Find("Content/Content01/ScrollView/Button/Item0"..i).gameObject
        UIEventListener.Get(self.m_Go_ItemList[i]).onClick = function ()
            self:OnClickMoneyItem(i)
        end
        self.m_Lanel_ItemList[i] =  mTran:Find("Content/Content01/ScrollView/Button/Item0"..i.."/Label"):GetComponent(typeof(UILabel))
        self.m_Lanel_ItemList[i].text = self.m_MoneyList[i]
    end

    self.m_Input_Money = mTran:Find("Content/Content01/Amount/Input"):GetComponent(typeof(UIInput))
    self.m_Btn_Reset = mTran:Find("Content/Content01/Amount/Button_Delect").gameObject
    UIEventListener.Get(self.m_Btn_Reset).onClick = function ()
        self:OnClickResetInputMoney()
    end

    self.m_Btn_Bind2 = mTran:Find("Content/Content02/Button_OK").gameObject
    UIEventListener.Get(self.m_Btn_Bind2).onClick = function ()
        self:OnClickBindContent2()
    end

    self.m_Btn_Cancel2 = mTran:Find("Content/Content02/Button_Cancle").gameObject
    UIEventListener.Get(self.m_Btn_Cancel2).onClick = function ()
        self:OnClickCancelContent2()
    end

    self.m_Btn_Close2 = mTran:Find("Content/Content02/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close2).onClick = function ()
        self:OnClickCloseContent2()
    end

    self.m_Input_EnterUPI = mTran:Find("Content/Content03/EnterUPI/Input"):GetComponent(typeof(UIInput))
    self.m_Input_ComfirmUPI= mTran:Find("Content/Content03/ComfirmUPI/Input"):GetComponent(typeof(UIInput))
    self.m_Input_RealName = mTran:Find("Content/Content03/Name/Input"):GetComponent(typeof(UIInput))
    self.m_Input_PhoneNumber = mTran:Find("Content/Content03/PhoneNumber/Input"):GetComponent(typeof(UIInput))
    self.m_Input_EmailAddress = mTran:Find("Content/Content03/EmailAddress/Input"):GetComponent(typeof(UIInput))
    self.m_Btn_BindBankCard = mTran:Find("Content/Content03/Button_Sure").gameObject
    UIEventListener.Get(self.m_Btn_BindBankCard).onClick = function ()
        self:OnClickBindBankCard()
    end

    self.m_Btn_Close3= mTran:Find("Content/Content03/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close3).onClick = function ()
        self:OnClickCloseContent3()
    end

    self.m_Label_YourName = mTran:Find("Content/Content04/Content/Name/Label"):GetComponent(typeof(UILabel))
    self.m_Label_YourUPI_ID = mTran:Find("Content/Content04/Content/UPI ID/Label"):GetComponent(typeof(UILabel))
    self.m_Btn_Close4= mTran:Find("Content/Content04/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close4).onClick = function ()
        self:OnClickCloseContent4()
    end

    self.m_Btn_Cancel4= mTran:Find("Content/Content04/Button_Cancle").gameObject
    UIEventListener.Get(self.m_Btn_Cancel4).onClick = function ()
        self:OnClickCancelContent4()
    end

    self.m_Btn_Bind4= mTran:Find("Content/Content04/Button_OK").gameObject
    UIEventListener.Get(self.m_Btn_Bind4).onClick = function ()
        self:OnClickBindContent4()
    end

	LuaPanel.InitUI(self)
	
end

function HallWithdrawPanel:ShowPanel(callBack)
    self:ResetViewData()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    LuaPanel.ShowPanel(self, callBack)
    HallWithdrawController:GetInstance():GetBindingAccount(function ()
        self:ShowBindBankCardView()
    end)
end

function HallWithdrawPanel:HidePanel()
    LuaPanel.HidePanel(self)
end

--设置子panel的深度
 function HallWithdrawPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
    self.m_Panel_Scroll.depth = depth + 3
    self.m_Panel_Content02.depth = depth + 4
    self.m_Panel_Content03.depth = depth + 5
    self.m_Panel_Content04.depth = depth + 7
end
--创建排行榜列表


function HallWithdrawPanel:__delete( ... )
	
end

function HallWithdrawPanel:ResetViewData()
    self.m_Input_Money.value = ""
end

function HallWithdrawPanel:ShowBindBankCardView()
    if not HallWithdrawModel:GetInstance():CheckIsHasBindBankCard() then
        --没有绑定银行卡
        self.m_Go_Tip_Bind:SetActive(true)
        self.m_Go_OveerBind:SetActive(false)
    else
        self.m_Go_Tip_Bind:SetActive(false)
        self.m_Go_OveerBind:SetActive(true)
        self.m_Label_UPI_ID.text = HallWithdrawModel:GetInstance():GetCardNum()
    end
end

function HallWithdrawPanel:OpenContent3()
    self.m_Input_RealName.value = ""
    self.m_Input_EnterUPI.value = ""
    self.m_Input_ComfirmUPI.value = ""
    self.m_Input_PhoneNumber.value = ""
    self.m_Input_EmailAddress.value = ""
    self.m_Go_Content03:SetActive(true)
end

function HallWithdrawPanel:OpenContent4()
    if self.m_Input_EnterUPI.value == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("BindBankTip_UPI_ID"))
        return
    end
    if self.m_Input_ComfirmUPI.value == "" or self.m_Input_ComfirmUPI.value ~= self.m_Input_EnterUPI.value then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("BindBankTip_Confirm_UPI_ID"))
        return
    end

    if self.m_Input_RealName.value == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("BindBankTip_Name"))
        return
    end
    if self.m_Input_PhoneNumber.value == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("BindBankTip_Phone"))
        return
    end

    if self.m_Input_EmailAddress.value == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("BindBankTip_Email"))
        return
    end
    self.m_Label_YourName.text = self.m_Input_RealName.value
    self.m_Label_YourUPI_ID.text = self.m_Input_EnterUPI.value
    self.m_Go_Content04:SetActive(true)
end

function HallWithdrawPanel:OnClickAddBind()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self:OpenContent3()
end

function HallWithdrawPanel:OnClickMoneyItem(index)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Help:SetActive(false)
    local money = self.m_MoneyList[index]
    self.m_Input_Money.value = money
end

function HallWithdrawPanel:OnClickResetInputMoney()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Input_Money.value = ""
end

function HallWithdrawPanel:OnClickClosePanel()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallWithdrawPanel:OnClickTiXian()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    local isHasBind = HallWithdrawModel:GetInstance():CheckIsHasBindBankCard()
    if not isHasBind then
        self.m_Go_Content02:SetActive(true)
        return
    end

    if self.m_Input_Money.value == "" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("TiXianTip_Money"))
        return
    end

    local Num = tonumber(self.m_Input_Money.value)
    if Num<100 or Num >100000 then
        UIManager:GetInstance():ShowNoteMessage("Limit (₹100  - ₹100000)")
        return
    end
    --申请提现

    HallWithdrawController:GetInstance():Exchange(Num,function ()
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("TiXianTip_Success"))
    end)
end

function HallWithdrawPanel:OnClickBindContent2()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content02:SetActive(false)
    self:OpenContent3()
end

function HallWithdrawPanel:OnClickCancelContent2()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content02:SetActive(false)
end

function HallWithdrawPanel:OnClickCloseContent2()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content02:SetActive(false)
end

function HallWithdrawPanel:OnClickBindBankCard()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self:OpenContent4()
end

function HallWithdrawPanel:OnClickCloseContent3()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content03:SetActive(false)
end

function HallWithdrawPanel:OnClickCloseContent4()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content04:SetActive(false)
end

function HallWithdrawPanel:OnClickCancelContent4()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content04:SetActive(false)
end

function HallWithdrawPanel:OnClickBindContent4()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.m_Go_Content04:SetActive(false)
    self.m_Go_Content03:SetActive(false)

    local name = self.m_Label_YourName.text
    local upi_id = self.m_Label_YourUPI_ID.text
    local phoneNum = self.m_Input_PhoneNumber.value
    local emailAdress = self.m_Input_EmailAddress.value

    HallWithdrawController:GetInstance():BindingAccount(upi_id,name,phoneNum,emailAdress,function ()
        self:ShowBindBankCardView()
    end)
end

function HallWithdrawPanel:SystemBack()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    if self.m_Go_Content04.activeSelf then
        self.m_Go_Content04:SetActive(false)
    elseif self.m_Go_Content03.activeSelf then
        self.m_Go_Content03:SetActive(false)
    elseif self.m_Go_Content02.activeSelf then
        self.m_Go_Content02:SetActive(false)
    else
        UIManager:GetInstance():HidePanel(self.mPanelID)
    end
end