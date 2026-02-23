HelpPanel = HelpPanel or BaseClass()

function HelpPanel:__init( obj )
    self.obj = obj
    self:InitUI()
    self:AddUIEventListener()
end

function HelpPanel:InitUI()
    local mTran = self.obj.transform
    self.m_Btn_Sure = mTran:Find("Content/UI_BT_Close").gameObject
end

function HelpPanel:AddUIEventListener()
    UIEventListener.Get(self.m_Btn_Sure).onClick = function () self:OnClickSure() end
end

--帮助界面
function HelpPanel:ShowHelpPanel(bol)
    self.obj:SetActive(bol)
end

function HelpPanel:OnClickSure()
    self:ShowHelpPanel(false)
end

function HelpPanel:__delete( ... )

end