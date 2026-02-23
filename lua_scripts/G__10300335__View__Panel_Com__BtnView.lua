BtnView = BtnView or BaseClass()

function BtnView:__init( obj )
    self.obj = obj
    self:InitUI()
    self:InitData()
    self:AddUIEventListener()
end

function BtnView:InitUI()
    local mTran = self.obj.transform
    self.m_HelpBtn = mTran:Find("Bottom/Btn_Help").gameObject
    self.Tip = mTran:Find("Bottom/Tip").gameObject
    self.Heads = mTran:Find("Bottom/Tip/Heads").gameObject
    self.Tails = mTran:Find("Bottom/Tip/Tails").gameObject
    self.m_HeadsBtn = mTran:Find("Bottom/Heads").gameObject
    self.m_TailsBtn = mTran:Find("Bottom/Tails").gameObject
    self.m_ExitBtn = mTran:Find("Title/Btn_Ext").gameObject
    self.m_AddBtn = mTran:Find("Bottom/Bet/Btn_Add").gameObject
    self.m_AddBtnIsEnable = self.m_AddBtn:GetComponent(typeof(UIButton))
    self.m_SubBtn = mTran:Find("Bottom/Bet/Btn_Minus").gameObject
    self.m_SubBtnIsEnable =self.m_SubBtn:GetComponent(typeof(UIButton))
    self.m_Label_Bet = mTran:Find("Bottom/Bet/Label"):GetComponent(typeof(UILabel))
    self.m_Label_WinScore = mTran:Find("Bottom/Score/Label_DeFen"):GetComponent(typeof(UILabel))
    self.m_Label_PlayerMoney = mTran:Find("Bottom/Planer_Info/Money/Label_MyMoney"):GetComponent(typeof(UILabel))
end

function BtnView:InitData()
    self.model = GameModel:GetInstance()
    self.BetFaceIndex = 0
end

function BtnView:Start()
    self:ShowBetMoney()
    self:ShowWinScore(0)
end

function BtnView:AddUIEventListener()
    UIEventListener.Get(self.m_ExitBtn).onClick = function () self:ExitGame() end
    UIEventListener.Get(self.m_AddBtn).onClick = function () self:OnClickAddBtn() end
    UIEventListener.Get(self.m_SubBtn).onClick = function () self:OnClickSubBtn() end
    UIEventListener.Get(self.m_HeadsBtn).onClick = function () self:OnClickHeadsBtn() end
    UIEventListener.Get(self.m_TailsBtn).onClick = function () self:OnClickTailsBtn() end
    UIEventListener.Get(self.m_HelpBtn).onClick = function () self:OnClickHelpBtn() end
end

function BtnView:OnClickAddBtn()
    GameModel:GetInstance():AddBetMoney()
    self:ShowBetMoney()
end

function BtnView:OnClickSubBtn()
    GameModel:GetInstance():ReduceBetMoney()
    self:ShowBetMoney()
end

function BtnView:ShowBetMoney()
    local money = GameModel:GetInstance():GetMyBetMoney()
    if money == nil then
        money = 0
    end
    self.m_Label_Bet.text = NumberFormat(HallGoldRateSToC(money))
end

function BtnView:ShowWinScore(score)
    if score>0 then
        self.m_Label_WinScore.text = "WIN:"..NumberFormat(HallGoldRateSToC(score))
    else
        self.m_Label_WinScore.text = ""
    end
end

function BtnView:ShowPlayerMoney(value)
    self.m_Label_PlayerMoney.text = NumberFormat(HallGoldRateSToC(value))
end

function BtnView:SetBetBtnEnabled(isEnable)
    self.m_AddBtnIsEnable.isEnabled=isEnable
    self.m_SubBtnIsEnable.isEnabled=isEnable
end

function BtnView:ExitGame()
    GameController:GetInstance().view:QuitGame()
end

function BtnView:OnClickHelpBtn()
    GameController:GetInstance().view.m_HelpPanel:ShowHelpPanel(true)
end

function BtnView:OnClickHeadsBtn()
    self.BetFaceIndex = 0
    self:StartGame()
    self:SetHeadsorTailsShow(false)
    self:SetBetBtnEnabled(false)
end

function BtnView:OnClickTailsBtn()
    self.BetFaceIndex = 1
    self:StartGame()
    self:SetHeadsorTailsShow(false)
    self:SetBetBtnEnabled(false)
end

function BtnView:StartGame()
    if self.model.m_MyBalanceMoney<self.model:GetMyBetMoney() then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CurrentBetMoneyInsufficient"),10)
        return
    end
    self:ShowWinScore(0)
    self:MonitoringStartGame()
end

function BtnView:MonitoringStartGame()
	self:ResetAutoReciveTimer()
	GameController:GetInstance():SendBetData(self.BetFaceIndex)
	self:IsStartAutoRecieveSeverRetrunData()
end


function BtnView:IsStartAutoRecieveSeverRetrunData()
	self.AutoRecieveReturnDataTimer=CommonHelp.SetTimeBackCall(3,self.RecieveReturnDataCallBack,self)
end

function BtnView:ResetAutoReciveTimer()
	if self.AutoRecieveReturnDataTimer then
		self.AutoRecieveReturnDataTimer:RemoveTimer()
		self.AutoRecieveReturnDataTimer=nil
	end
end

function BtnView:RecieveReturnDataCallBack()
	GameController:GetInstance().view:IsShowDuanWang(true)
	self:MonitoringStartGame()
end

function BtnView:StartGameCallBack()
    self:ResetAutoReciveTimer()
    GameController:GetInstance().view:IsShowDuanWang(false)
end

function BtnView:IsShowTip(isDisplay)
    self.Tip:SetActive(isDisplay)
end

function BtnView:IsShowTipHeads()
    self:IsShowTip(true)
    self.Heads:SetActive(self.BetFaceIndex==0)
    self.Tails:SetActive(not (self.BetFaceIndex==0))
end

function BtnView:SetHeadsorTailsShow(isDisplay)
    self.m_HeadsBtn:SetActive(isDisplay)
    self.m_TailsBtn:SetActive(isDisplay)
end

function BtnView:SetOpenDataView(data)
    self:IsShowTip(false)
    self:SetHeadsorTailsShow(true)
    self:SetBetBtnEnabled(true)
    if data.n64WinCoin>0 then
        GameSoundController:GetInstance():PlaySound(GameLuaDefine.SoundID.Win)
    end
    self:ShowWinScore(data.n64WinCoin)
    self:ShowPlayerMoney(data.n64BalanceCoin)
end

function BtnView:__delete( ... )

end