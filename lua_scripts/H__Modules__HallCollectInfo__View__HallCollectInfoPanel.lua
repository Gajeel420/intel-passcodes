HallCollectInfoPanel = HallCollectInfoPanel or BaseClass(LuaPanel)

function HallCollectInfoPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallCollectInfo].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallCollectInfo].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallCollectInfo
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel--页面层级
	self:CreatePanel(0)----必须实现
end


--初始化ui界面  ----必须实现
function HallCollectInfoPanel:InitUI()
	local m_Trans = self.obj.transform

    self.m_Btn_Confirm = m_Trans:Find("Content/Button_Confirm").gameObject
    UIEventListener.Get(self.m_Btn_Confirm).onClick = function() self:OnClickConfirm() end

    self.m_Btn_Close = m_Trans:Find("Content/Button_Closse").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function() self:OnClickClose() end

    self.m_Input_Name = m_Trans:Find("Content/Name/Input"):GetComponent(typeof(UIInput))
    self.m_Input_Phone_Num = m_Trans:Find("Content/Phone_Num/Input"):GetComponent(typeof(UIInput))
    self.m_Input_Email = m_Trans:Find("Content/Email/Input"):GetComponent(typeof(UIInput))
    EventDelegate.Add(self.m_Input_Name.onChange,function()
        local name = self.m_Input_Name.value
        self.m_Input_Name.value = string.gsub(name,"[%:*%;*%\"\"*]","")
    end)

	LuaPanel.InitUI(self)
end

function HallCollectInfoPanel:ResetUIViewData()
    self.m_Input_Name.value = ""
    self.m_Input_Phone_Num.value = ""
    self.m_Input_Email.value = ""
end

function HallCollectInfoPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self, callBack)
end

function HallCollectInfoPanel:HidePanel()
	LuaPanel.HidePanel(self)
end

function HallCollectInfoPanel:OnClickConfirm()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    local name = self.m_Input_Name.value
    name = string.gsub(name,"[%:*%;*%\"\"*]","")
    if name == "" or #name > 50 then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CollectInfo_Name"))
        return
    end

    local phone_Num = self.m_Input_Phone_Num.value
    if phone_Num == "" or #phone_Num > 12 then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CollectInfo_Phone"))
        return
    end

    local email = self.m_Input_Email.value
    if email == "" or (not LuaUtils.IsRightEmail(email)) then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CollectInfo_Email"))
        return
    end

	HallCollectInfoController:GetInstance():ReqOperateUserDetailInfo(1,name,phone_Num,email)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallCollectInfoPanel:OnClickClose()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end


--设置子panel的深度
 function HallCollectInfoPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end


function HallCollectInfoPanel:__delete( ... )

end
