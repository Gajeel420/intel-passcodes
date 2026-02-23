HallRankPanel = HallRankPanel or BaseClass(LuaPanel)

function HallRankPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRank].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRank].path
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.Destroy
	self.mPanelID = UIPanelDefine.EWndID.HallRank
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel--页面层级
	self:CreatePanel(0)----必须实现
end


--初始化ui界面  ----必须实现
function HallRankPanel:InitUI()
    self.m_AllRankItem = {}
	local m_Trans = self.obj.transform

    self.m_Btn_Close = m_Trans:Find("Content/Btn_Close").gameObject
    UIEventListener.Get(self.m_Btn_Close).onClick = function() self:OnClickClose() end

    self.m_Panel_Scroll = m_Trans:Find("Content/ScrollView_Rank/ScrollView"):GetComponent(typeof(UIPanel))
    self.m_Scroll = m_Trans:Find("Content/ScrollView_Rank/ScrollView"):GetComponent(typeof(UIScrollView))
    self.m_Grid = m_Trans:Find("Content/ScrollView_Rank/ScrollView/Grid"):GetComponent(typeof(UIGrid))
    self.m_Item_Prefab = m_Trans:Find("Content/ScrollView_Rank/Item_Rank").gameObject
    self.m_Item_Prefab:SetActive(false)


    -- 我的排名
    self.m_Label_MyRankNum = m_Trans:Find("Content/ScrollView_Rank/Your_Rank/Rank_Num"):GetComponent(typeof(UILabel))
    self.m_Label_MyScore = m_Trans:Find("Content/ScrollView_Rank/Your_Rank/Score_Num"):GetComponent(typeof(UILabel))
    self.m_Label_MyName = m_Trans:Find("Content/ScrollView_Rank/Your_Rank/Name"):GetComponent(typeof(UILabel))
    self.m_Label_MyName.text = "Your Ranking"

    --倒计时
    self.m_Label_Countdowntime = m_Trans:Find("Content/Label_Time"):GetComponent(typeof(UILabel))

	LuaPanel.InitUI(self)
end

function HallRankPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    
    -- 重置界面
    self:ClearAllRankItem()
    -- 请求数据，刷新界面
    HallRankController:GetInstance():RequestPlayerWinCoinRankList(NetworkDefine.E_WIN_RANK_TYPE.WEEK_TOTAL_WIN)

	LuaPanel.ShowPanel(self, callBack)
end

function HallRankPanel:HidePanel()
	LuaPanel.HidePanel(self)
    ActivityModuleController:GetInstance():ExecuteNextActivityEvent()
end

function HallRankPanel:ClearAllRankItem()
    for i = 1, #self.m_AllRankItem do
        self.m_AllRankItem[i]:SetObjActive(false)
    end
end

function HallRankPanel:SetRankViewData(data)
    if data == nil then
        print("------------- HallRankPanel:SetRankViewData 数据有误")
        return
    end

    -- 排名
    for i = 1, #data.WinCoinUserList do
        if not self.m_AllRankItem[i] then
            go = InstantiateNewGameObject(self.m_Item_Prefab, self.m_Grid.transform,i)
            self.m_AllRankItem[i] = HallRankItem.New(go)
        end

        self.m_AllRankItem[i]:SetRankItemData(data.WinCoinUserList[i],i)
    end
    self.m_Grid:Reposition()
    self.m_Scroll:ResetPosition()

    -- 单独自己的排名
    if data.m_wonWinIndex == 0 then
        -- 100+
        self.m_Label_MyRankNum.text = "100+"
        self.m_Label_MyScore.text = ""
    else
        self.m_Label_MyRankNum.text = tostring(data.m_wonWinIndex)
        self.m_Label_MyScore.text = NumberFormat(HallGoldRateSToC(data.m_wonWinMoney))
    end
end


function HallRankPanel:OnClickClose()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    UIManager:GetInstance():HidePanel(self.mPanelID)
end


--设置子panel的深度
 function HallRankPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
    self.m_Panel_Scroll.depth = depth + 2
end

function HallRankPanel:__delete( ... )

end
