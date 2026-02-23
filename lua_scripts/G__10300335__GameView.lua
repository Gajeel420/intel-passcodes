GameView=BaseClass()

function GameView:__init( obj )
	self.obj=obj
	self.transform=obj.transform
	self.gameID = GameController.GetInstance().gameID

	self:InitUI()
	self:InitPanel()
	--self:AddUIEventListener()
end

function GameView:InitUI()
	local mTrans = 	self.transform
	self.model = GameModel:GetInstance()
	self.m_Go_Com = mTrans:Find("UIStretch/Group/Game_UI/Panel_Com").gameObject
	self.m_Go_Help = mTrans:Find("UIStretch/Group/Game_UI/Panel_Help").gameObject
	self.m_Go_Coin = mTrans:Find("UIStretch/Group/Game_UI/com/GunDong/ItemGroup/Item").gameObject
	self.m_Go_Duanwang = mTrans:Find("UIStretch/Group/Game_UI/Panel_duanwang").gameObject
end

function GameView:InitPanel()
	self.m_HelpPanel = HelpPanel.New(self.m_Go_Help)
	self.m_BtnViewPanel = BtnView.New(self.m_Go_Com)
	self.m_CoinPanel = CoinPanel.New(self.m_Go_Coin)
	--self:HandleUI_LiuHaiPing()
end

function GameView:HandleUI_LiuHaiPing()
	local mTrans = self.ComTitle.transform
	local IsLiuHaiPing = LuaUtils.CheckIsLiuHaiPing()
	local offect_w = 0
	local width_UI =  LuaUtils.GetUIRealWidth()
	if IsLiuHaiPing then
		--offect_w = LuaUtils.GetOffectDistance()
		offect_w = 200
		mTrans.localPosition = Vector3(0,width_UI / 2 - offect_w,0)
	end
end


function GameView:AddUIEventListener()
	--UIEventListener.Get(self.m_Btn_CloseHelp).onClick = function () self:OnClickCloseHelp() end
end

function GameView:Start()
	self.m_UpdateName = "GameView"..self.gameID..":Upadte"
	RenderMgr.Remove(self.m_UpdateName)
    RenderMgr.Add(function()
    	self:Update()
	end,self.m_UpdateName)

	self.m_BtnViewPanel:Start()
end

function GameView:IsShowDuanWang(isDisplay)
	self.m_Go_Duanwang:SetActive(isDisplay)
end

function GameView:__delete( ... )
	RenderMgr.Remove(self.m_UpdateName)

	if self.m_HelpPanel then
		self.m_HelpPanel:Destroy()
		self.m_HelpPanel = nil
	end

end

function GameView:Update( ... )
end

function GameView:QuitGame()
	GameSoundController:GetInstance():StopBgAudio()
	RoomController:GetInstance():ReqQuitGame(GameController:GetInstance().desk)
end

function GameView:ResetViewData()

end