HallGuidePanel = HallGuidePanel or BaseClass(LuaPanel)

function HallGuidePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGuide].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGuide].path
	self.mPanelID = UIPanelDefine.EWndID.HallGuide
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGuidePanel:InitUI()
    self.m_CurIndex = 1
    self.m_TotalIndex = 6
    self.m_AniName = {
        "Ani_Guide01",
        "Ani_Guide02",
        "Ani_Guide03",
        "Ani_Guide04",
        "Ani_Guide05",
        "Ani_Guide_over",
    }
	local mTran = self.obj.transform
    
    self.m_Ani = mTran:Find("Content"):GetComponent(typeof(Animator))

    self.m_Btn_BG = mTran:Find("Content/BlackCollider").gameObject
    UIEventListener.Get(self.m_Btn_BG).onClick = function ()
        self:OnClickNext()
    end
    
	LuaPanel.InitUI(self)
end

function HallGuidePanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self.m_CurIndex = 1
	LuaPanel.ShowPanel(self,callBack)
end

--设置子panel的深度
 function HallGuidePanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallGuidePanel:HidePanel( )
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallGuidePanel:OnClickNext()
    self.m_CurIndex = self.m_CurIndex + 1
    if self.m_CurIndex > self.m_TotalIndex then return end
    self.m_Ani:Play(self.m_AniName[self.m_CurIndex], 0, 0)
    if self.m_CurIndex == self.m_TotalIndex then
        RenderMgr.AddInterval(function ()
            UIManager:GetInstance():HidePanel(self.mPanelID)
        end,"HallGuidePanel:OnClickNext",1, 1.8)
    end
end

function HallGuidePanel:__delete( ... )

end