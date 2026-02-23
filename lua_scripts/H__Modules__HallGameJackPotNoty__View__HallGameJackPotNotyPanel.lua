HallGameJackPotNotyPanel = HallGameJackPotNotyPanel or BaseClass(LuaPanel)

function HallGameJackPotNotyPanel:__init(callBack)
    self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HalGameJackPotNoty].name
    self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HalGameJackPotNoty].path
	self.mPanelID = UIPanelDefine.EWndID.HalGameJackPotNoty
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

function HallGameJackPotNotyPanel:InitUI( ... )
	-- body
	self.intervalTime = 5
	self.removevalTime = 5.5
	local mTran = self.obj.transform
	self.PlayerName = mTran:Find("Content/Content/NotifyPanel/Label/Label_Player").gameObject:GetComponent(typeof(UILabel))
	self.JackPotType = mTran:Find("Content/Content/NotifyPanel/Label/Label_Jackpot").gameObject:GetComponent(typeof(UILabel))
	self.WinMoney = mTran:Find("Content/Content/NotifyPanel/Label/Money/Label_Money").gameObject:GetComponent(typeof(UILabel))
	LuaPanel.InitUI(self)
end


function HallGameJackPotNotyPanel:ShowPanel(callBack)
	-- body
	self:SetNotyData()
	LuaPanel.ShowPanel(self,callBack)
end

function HallGameJackPotNotyPanel:SetNotyData( ... )
	-- body
	local data = GameJackPotNotyModuleController:GetInstance().data
	self.PlayerName.text = data.m_szNickName
	local value=HallGoldRateSToC(data.m_un64Profit)
	self.WinMoney.text=NumberFormat(value)
	local back = function ( ... )
		-- body
		GameJackPotNotyModuleController:GetInstance().data = nil
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HalGameJackPotNoty)
	end
	RenderMgr.AddInterval(back,"GameJackPotNoty",self.intervalTime,self.removevalTime)
end

function HallGameJackPotNotyPanel:__delete( ... )
	-- body
	self.PlayerName = nil
	self.JackPotType = nil
	self.WinMoney = nil
end