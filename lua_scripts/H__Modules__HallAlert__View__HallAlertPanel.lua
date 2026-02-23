HallAlertPanel = HallAlertPanel or BaseClass(LuaPanel)

function HallAlertPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAlert].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallAlert].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallAlert
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel--页面层级
	self:CreatePanel(0)----必须实现
end


--初始化ui界面  ----必须实现
function HallAlertPanel:InitUI()

    self.m_CopyContent = "download.gamevault999.com"
	local m_Trans = self.obj.transform

    self.m_Btn_Confirm = m_Trans:Find("Content/Button_Sure/Button_OK").gameObject
    UIEventListener.Get(self.m_Btn_Confirm).onClick = function() self:OnButton_Close() end
    
    self.m_Btn_Close = m_Trans:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function() self:OnButton_Close() end

    self.m_Btn_Copy = m_Trans:Find("Content/Button_Copy").gameObject
    UIEventListener.Get(self.m_Btn_Copy).onClick = function() self:OnButton_Copy() end

	LuaPanel.InitUI(self)
end

function HallAlertPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self, callBack)
end

function HallAlertPanel:HidePanel()
	LuaPanel.HidePanel(self)
	ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallAlertPanel:OnButton_Close( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallAlertPanel:OnButton_Copy( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:MyClipDataToClipboard(self.m_CopyContent)
    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end

--设置子panel的深度
 function HallAlertPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end


function HallAlertPanel:__delete( ... )

end
