UIOddPanel=BaseClass()

function UIOddPanel:__init( t )
	self.transform=t
	self.gameObject=t.gameObject
	self:Find()
end
function UIOddPanel:Find()
	self.animator = self.transform:GetComponent(typeof(Animator))
	local btnClose=self.transform:Find("Btn_Close").gameObject
	UIEventListener.Get(btnClose).onClick=function() self:OnCloseBtn() end

	self.objPutongBtn = self.transform:Find("toggle_putong").gameObject
	UIEventListener.Get(self.objPutongBtn).onClick=function(go) self:OnClickTypeBtn(go) end
	-- self.objBossBtn = self.transform:Find("toggle_boss").gameObject
	-- UIEventListener.Get(self.objBossBtn).onClick=function(go) self:OnClickTypeBtn(go) end
	self.objTeShuBtn = self.transform:Find("toggle_zhadan").gameObject
	UIEventListener.Get(self.objTeShuBtn).onClick=function(go) self:OnClickTypeBtn(go) end

	self.objPanelPutong = self.transform:Find("Panel_WenBen/Help_ground/putongPanel").gameObject
	self.objPanelPutong:SetActive(self.objPutongBtn:GetComponent(typeof(UIToggle)).value)
	-- self.objPanelBoss = self.transform:Find("Panel_WenBen/Help_ground/bossPanel").gameObject
	-- self.objPanelBoss:SetActive(self.objBossBtn:GetComponent(typeof(UIToggle)).value)
	self.objPanelTeXiao = self.transform:Find("Panel_WenBen/Help_ground/texiaoPanel").gameObject
	--self.objPanelTeXiao:SetActive(self.objTeShuBtn:GetComponent(typeof(UIToggle)).value)

	self.scrollView=self.transform:Find("Panel_WenBen"):GetComponent(typeof(UIScrollView))
	self.scrollView:OnScrollBar()
end
function UIOddPanel:OnClickTypeBtn(go)
	GameController:GetInstance():PlayUIBottomAudio(105)
	self.objPanelPutong:SetActive(self.objPutongBtn:GetComponent(typeof(UIToggle)).value)
	-- self.objPanelBoss:SetActive(self.objBossBtn:GetComponent(typeof(UIToggle)).value)
	--self.objPanelTeXiao:SetActive(self.objTeShuBtn:GetComponent(typeof(UIToggle)).value)
	self.scrollView:OnScrollBar()
end
function UIOddPanel:OnCloseBtn( ... )
	GameController:GetInstance():PlayUIBottomAudio(114)
	self:Close()
end
function UIOddPanel:Open()
	self.gameObject:SetActive(true)
	self.objPutongBtn:GetComponent(typeof(UIToggle)).value=true
	self.objPanelPutong:SetActive(self.objPutongBtn:GetComponent(typeof(UIToggle)).value)
	-- self.objPanelBoss:SetActive(self.objBossBtn:GetComponent(typeof(UIToggle)).value)
	--self.objPanelTeXiao:SetActive(self.objTeShuBtn:GetComponent(typeof(UIToggle)).value)
	self.scrollView:OnScrollBar()
end
function UIOddPanel:Close( ... )
	self.animator:Play("Ani_Narrow",0,0)
	RenderMgr.Remove("UIOddPanelClose")
	RenderMgr.AddInterval(function()
		self.gameObject:SetActive(false)
		  end,"UIOddPanelClose",0.8,0.82)
end
function UIOddPanel:__delete( ... )
	-- body
end