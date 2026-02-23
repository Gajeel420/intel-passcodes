LoginBGPanel = LoginBGPanel or BaseClass(LuaPanel)

function LoginBGPanel:__init( callBack )
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.LoginBG].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.LoginBG].path
	self.mPanelID = UIPanelDefine.EWndID.LoginBG
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.objRole = nil
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function LoginBGPanel:InitUI()
	local mTran = self.obj.transform
	--替换背景图，使用resource下面的图
	local tex=mTran:Find("Content/BG"):GetComponent(typeof(UITexture))
	self.logoObj = mTran:Find("Content/Logo").gameObject
	self.logoObj:SetActive(true)
	LuaPanel.InitUI(self)

end


function LoginBGPanel:__delete( ... )
	self.objRole = nil
end