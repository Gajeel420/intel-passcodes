HallInvitePanel = HallInvitePanel or BaseClass(LuaPanel)

function HallInvitePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallInvite].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallInvite].path
	self.mPanelID = UIPanelDefine.EWndID.HallInvite
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallInvitePanel:InitUI()
	local mTran = self.obj.transform
    self.m_Btn_Close = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function ()
        self:OnClickClose()
    end
    self.m_Btn_Copy = mTran:Find("Content/Button_Copy").gameObject
    UIEventListener.Get(self.m_Btn_Copy).onClick = function ()
        self:OnClickCopy()
    end

    self.m_Label = mTran:Find("Content/Label_Msg"):GetComponent(typeof(UILabel))
    -- self.m_Label.text = ""
    
	LuaPanel.InitUI(self)
end

function HallInvitePanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
end

--设置子panel的深度
 function HallInvitePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallInvitePanel:HidePanel( )
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallInvitePanel:OnClickCopy()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:MyClipDataToClipboard(self.m_Label.text)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end

function HallInvitePanel:OnClickClose()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallInvitePanel:__delete( ... )

end