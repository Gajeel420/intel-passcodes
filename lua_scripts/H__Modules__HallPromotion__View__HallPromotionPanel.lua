HallPromotionPanel = HallPromotionPanel or BaseClass(LuaPanel)

function HallPromotionPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPromotion].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPromotion].path
	self.mPanelID = UIPanelDefine.EWndID.HallPromotion
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallPromotionPanel:InitUI()

    local mTran = self.obj.transform
    self.mTransform_Content=mTran:Find("Content")
   
    self.mObj_CloseButton=mTran:Find("Content/Title/Btn_Back").gameObject
    UIEventListener.Get(self.mObj_CloseButton).onClick = function() self:OnClickCloseButton() end

    --View节点初始化
    self.mTable_View={}
    self.CurrentOpenViewType=nil
    -----推广
    local obj_DevelopmentOffline=mTran:Find("Content/Con_TG").gameObject
    self.DevelopmentOfflineView=DevelopmentOfflineView.New(obj_DevelopmentOffline)
    self.mTable_View[HallPromotionPanel.ViewType.DevelopmentOffline]=self.DevelopmentOfflineView
    --业绩查询
    local obj_PerformanceEnquiry=mTran:Find("Content/Con_YJ").gameObject
    self.PerformanceEnquiryView=PerformanceEnquiryView.New(obj_PerformanceEnquiry)
    self.mTable_View[HallPromotionPanel.ViewType.PerformanceEnquiry]=self.PerformanceEnquiryView
    --团队
    local obj_TeamManagement=mTran:Find("Content/Con_ZH").gameObject
    self.TeamManagementView=TeamManagementView.New(obj_TeamManagement)
    self.mTable_View[HallPromotionPanel.ViewType.TeamManagement]=self.TeamManagementView

    local obj_Bind = mTran:Find("Content_4").gameObject
    obj_Bind:SetActive(false)
    self.BindView = PromotionBindView.New(obj_Bind)

    local obj_BonusNote=mTran:Find("Content_2").gameObject
    self.BonusNoteView=BonusNoteView.New(obj_BonusNote)

    local obj_BonusNoteMap = mTran:Find("Content/Con_JC").gameObject
    self.BonusNoteMapView = BonusNoteMapView.New(obj_BonusNoteMap)
    self.mTable_View[HallPromotionPanel.ViewType.BonusNote]=self.BonusNoteMapView

    local obj_CashWithdrawal=mTran:Find("Content_3").gameObject
    self.CashWithdrawalView=CashWithdrawalView.New(obj_CashWithdrawal)
    

    -- --Toggle按钮初始化
    self.mTable_Toggle={}
    self.CurrentSeleteToggleType=nil
    self.mToggle_PerformanceEnquiry=mTran:Find("Content/Btn/Tween/Btn_YJ"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_PerformanceEnquiry.gameObject).onClick = function() self:OnClickToggle(HallPromotionPanel.ViewType.PerformanceEnquiry) end
    self.mTable_Toggle[HallPromotionPanel.ViewType.PerformanceEnquiry]=self.mToggle_PerformanceEnquiry
   
    self.mToggle_TeamManagement=mTran:Find("Content/Btn/Tween/Btn_ZH"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_TeamManagement.gameObject).onClick = function() self:OnClickToggle(HallPromotionPanel.ViewType.TeamManagement) end
    self.mTable_Toggle[HallPromotionPanel.ViewType.TeamManagement]=self.mToggle_TeamManagement

    self.mToggle_DevelopmentOffline=mTran:Find("Content/Btn/Tween/Btn_TG"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_DevelopmentOffline.gameObject).onClick = function() self:OnClickToggle(HallPromotionPanel.ViewType.DevelopmentOffline) end
    self.mTable_Toggle[HallPromotionPanel.ViewType.DevelopmentOffline]=self.mToggle_DevelopmentOffline

    self.mToggle_BonusNote=mTran:Find("Content/Btn/Tween/Btn_JC"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_BonusNote.gameObject).onClick = function() self:OnClickToggle(HallPromotionPanel.ViewType.BonusNote) end
    self.mTable_Toggle[HallPromotionPanel.ViewType.BonusNote]=self.mToggle_BonusNote
  
	--初始化动画
	local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
    self.mPanel_Btn = mTran:Find("Content/Btn").gameObject:GetComponent(typeof(UIPanel))

    self:AddEvent()
    LuaPanel.InitUI(self)    
    
end





function HallPromotionPanel:AddEvent( ... )
    HallPromotionModel:GetInstance():AddEventListener(HallPromotionModel.EventType.BindRecommendSuccess,self.SetRecommendCodeSuccess,self)
end
function HallPromotionPanel:RemoveEvent( ... )
    HallPromotionModel:GetInstance():RemoveEventListener(HallPromotionModel.EventType.BindRecommendSuccess,self.SetRecommendCodeSuccess,self)
end

function HallPromotionPanel:SetRecommendCodeSuccess()
    self:OnClickToggle(HallPromotionPanel.ViewType.PerformanceEnquiry)
    self.mToggle_Recommend.gameObject:SetActive(false)
end


function HallPromotionPanel:OpenBonusNoteView()
    self.BonusNoteView:ShowView() 
end

function HallPromotionPanel:OpenCashWithdrawalView()
    self.CashWithdrawalView:ShowView()
end



function HallPromotionPanel:OnClickToggle(viewType)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    if self.mTable_View ==nil or self.mTable_Toggle==nil then
        return
    end

    if self.CurrentOpenViewType==nil or self.CurrentSeleteToggleType==nil then
        self:HideAllView()
    end

    if self.CurrentSeleteToggleType~=nil then
        self.mTable_Toggle[self.CurrentSeleteToggleType].value=false
    end
    self.mTable_Toggle[viewType].value=true
    self.CurrentSeleteToggleType=viewType


    if self.CurrentOpenViewType~=nil then
        self.mTable_View[self.CurrentOpenViewType]:HideView()
    end

    self.mTable_View[viewType]:ShowView()

    self.CurrentOpenViewType=viewType

end


function HallPromotionPanel:HideAllView()
    for k, v in pairs(self.mTable_View) do
        v:HideView()
    end
end



function HallPromotionPanel:OnClickCloseButton()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    --SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_promotion)
    UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallPromotion)
end



--设置子panel的深度
function HallPromotionPanel:SetPanelDepth(depth)
    LuaPanel.SetPanelDepth(self,depth)
    local index=2;
    for k, v in pairs(self.mTable_View) do
        v:SetPanelDepth(depth+index)
        index=index+2
    end
    self.BonusNoteView:SetPanelDepth(depth +25)
    self.CashWithdrawalView:SetPanelDepth(depth+30)
    self.BindView:SetViewDepth(depth)
end

-- 复写父类 showpanel 方法
function HallPromotionPanel:ShowPanel(callBack)
   
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    LuaPanel.ShowPanel(self,callBack)
    self:OnClickToggle(HallPromotionPanel.ViewType.DevelopmentOffline)
    self.mTweenPlayer:ParallelPlay(false)
    -- SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_promotion)


end

function HallPromotionPanel:HidePanel( )
    self:SetVisible(false)
end




function HallPromotionPanel:__delete( ... )
	self:RemoveEvent()
end


HallPromotionPanel.ViewType={
    BonusNote=1,    --奖励说明
    CashWithdrawal=2,   --提现
    DevelopmentOffline=3,   --发展下线
    PerformanceEnquiry=4,   --业绩查询
    Recommend=5,      --邀请码
    TeamManagement=6,   --团队管理
}