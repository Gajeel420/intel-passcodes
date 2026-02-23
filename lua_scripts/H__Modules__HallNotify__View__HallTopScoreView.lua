---爆分榜    
---Author:Rube
HallTopScoreView = BaseClass()

function HallTopScoreView:__init(obj)
    self.obj = obj
    self:InitView()
end

function HallTopScoreView:InitView()
    --self.obj:SetActive(false)
    local mTran = self.obj.transform
    self.mTopScoreItemList = {}
    self.mBtn_OpenScore = mTran:Find("Btn_OPenScore").gameObject
    UIEventListener.Get(self.mBtn_OpenScore).onClick = function(go) self:OnOpenTopScoreButton(go) end
    self.mObj_TopScore =  mTran:Find("TopScoreList").gameObject
    self.mObj_TopScore:SetActive(false)
    self.mBtn_CloseTopScore = mTran:Find("TopScoreList/Btn_CloseScore").gameObject
    UIEventListener.Get(self.mBtn_CloseTopScore).onClick = function(go) self:OnCloseTopScoreButton(go) end

    self.mBtn_Black = mTran:Find("TopScoreList/Sprite_BlackCollider").gameObject
    UIEventListener.Get(self.mBtn_Black).onClick = function(go) self:OnCloseTopScoreButton(go) end

    self.mObj_item =  mTran:Find("TopScoreList/UI_Item").gameObject
    self.mObj_item:SetActive(false)
    self.mScrollView = mTran:Find("TopScoreList/ScrollView"):GetComponent(typeof(UIScrollView))
    self.mParent = mTran:Find("TopScoreList/ScrollView/Grid")
    self.mGrid = self.mParent:GetComponent(typeof(UIGrid))
    HallNotifyModel.GetInstance().IsTopScorePanelOpne = false
end

---打开爆分排行榜
function HallTopScoreView:OnOpenTopScoreButton(go)
    self.mObj_TopScore:SetActive(true)
    self.mBtn_OpenScore:SetActive(false)
    HallNotifyModel.GetInstance().IsTopScorePanelOpne = true
    HallNotifyModel.GetInstance():CQueryScoreRankReq()
end

---关闭爆分排行榜
function HallTopScoreView:OnCloseTopScoreButton(go)
    self.mObj_TopScore:SetActive(false)
    self.mBtn_OpenScore:SetActive(true)
    HallNotifyModel.GetInstance().IsTopScorePanelOpne = false
    
    HallNotifyController.GetInstance().view.panel:NotifyDisplay()
end

function HallTopScoreView:LanguigeChange( etype )
    if not self.mObj_TopScore.activeInHierarchy then return end
   if etype == 0 then
    for i=1,#self.mTopScoreItemList do
        self.mTopScoreItemList[i]:ChangeLangui(0)
    end
   else
    for i=1,#self.mTopScoreItemList do
        self.mTopScoreItemList[i]:ChangeLangui(1)
    end
   end
end


function HallTopScoreView:SetTopScoreListData(data)
    self:CleanAllTopScoreItem()
    local count = #data.TopScoreRankList
    for i = 1, count do
        if self.mTopScoreItemList[i] == nil then
           self:CreateTitleItem(i)
        end
        self.mTopScoreItemList[i]:SetItemData(i,data.TopScoreRankList[i])
    end
    self.mGrid:Reposition()
    self.mScrollView:ResetPosition()
end


----创建爆分排行榜
function HallTopScoreView:CreateTitleItem(index)
    local go = GameObject.Instantiate(self.mObj_item,self.mParent)
	go.transform.parent = self.mParent
	go.transform.localPosition = Vector3.zero
    go.transform.localScale = Vector3.one
	go.name = StringFormat("TopScore_{0}",index)
    self.mTopScoreItemList[index] = HallTopScoreItem.New(go)
end


function HallTopScoreView:CleanAllTopScoreItem()
    local count = #self.mTopScoreItemList
    for i = 1, count do
        self.mTopScoreItemList[i]:RecycleItem()
    end
end


function HallTopScoreView:DisplayView(display)

    if display then
        if NetworkMgr.mHandle.SendBraodcastData ~= nil then
            self.obj:SetActive(HallNotifyModel.GetInstance().IsShowTopScorePanel)
        end
    else
        self.obj:SetActive(false)
        self.mObj_TopScore:SetActive(false)
        self.mBtn_OpenScore:SetActive(true)
        HallNotifyModel.GetInstance().IsTopScorePanelOpne = false
    end
end

function HallTopScoreView:SetViewDepth(depth)
    SetPanelstartingRenderQueue(self.mScrollView.gameObject,depth+200)
end

function HallTopScoreView:__delete()
end