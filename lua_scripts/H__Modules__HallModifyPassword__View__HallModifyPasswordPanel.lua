HallModifyPasswordPanel = HallModifyPasswordPanel or BaseClass(LuaPanel)

function HallModifyPasswordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallModifyPassword].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallModifyPassword].path
	self.mPanelID = UIPanelDefine.EWndID.HallModifyPassword
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现

end

--初始化ui界面  ----必须实现
function HallModifyPasswordPanel:InitUI()
    self.oldVlue = ""
    self.newValue = ""
    self.sureValue = ""
	local mTran = self.obj.transform

    self.m_Btn_Close = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function ()
        self:OnClickClosePanel()
    end

    self.m_Btn_Ok = mTran:Find("Content/Button_Sure").gameObject
    UIEventListener.Get(self.m_Btn_Ok).onClick = function ()
        self:OnClickOk()
    end

    self.m_InputAccount = mTran:Find("Content/Account/Input"):GetComponent(typeof(UIInput))
    self.m_InputPassword = mTran:Find("Content/Password/Input"):GetComponent(typeof(UIInput))
    self.m_InputSure = mTran:Find("Content/Sure/Input"):GetComponent(typeof(UIInput))
    
	LuaPanel.InitUI(self)
end

--内部调用事件
--================================================================================================================================================================================
function HallModifyPasswordPanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self:SetCloseBtnView(true)
	LuaPanel.ShowPanel(self,callBack)
    self.m_InputAccount.value = ""
    self.m_InputPassword.value = ""
    self.m_InputSure.value = ""
end



--设置子panel的深度
 function HallModifyPasswordPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallModifyPasswordPanel:HidePanel( )
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end



function HallModifyPasswordPanel:__delete( ... )

end

function HallModifyPasswordPanel:SetCloseBtnView(bol)
    self.m_Btn_Close:SetActive(bol)
end

function HallModifyPasswordPanel:OnClickClosePanel()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallModifyPasswordPanel:OnClickOk()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.oldVlue = self.m_InputAccount.value
    self.newValue = self.m_InputPassword.value
    self.sureValue = self.m_InputSure.value

    if self.oldVlue == "" then
        UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Old_Password"))
        return
    end

    if self.newValue == "" then
        UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_New_Password"))
        return
    end

    if self.sureValue == "" then
        UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Sure_Password"))
        return
    end

    if self.newValue ~= self.sureValue then
        UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("SurePassWordError"))
        return
    end
    HallModifyPasswordController:GetInstance():SendChangePassword(self.oldVlue,self.newValue)
end