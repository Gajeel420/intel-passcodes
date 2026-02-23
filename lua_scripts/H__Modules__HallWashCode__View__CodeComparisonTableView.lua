CodeComparisonTableView = BaseClass()
---礼金对照表
function CodeComparisonTableView:__init(obj)
    self.obj = obj
    self:InitData()
end

function CodeComparisonTableView:InitData()
    self.mPanel = self.obj:GetComponent(typeof(UIPanel))
    local mTran = self.obj.transform
    self.mScrollPanel =  mTran:Find("Content/CodeComparisonTable"):GetComponent(typeof(UIPanel))
    self.mObj_Close = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.mObj_Close).onClick = function(obj) self:OnButtonClose(obj)  end
    self.mObj_item = mTran:Find("Content/UI_ItemGrid").gameObject
    self.mObj_item:SetActive(false)
    self.mParent = mTran:Find("Content/CodeComparisonTable/Grid")
    self.mGrid = self.mParent:GetComponent(typeof(UIGrid))
    self.mItemList = {}
    local list_tweenList={}
    local TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, TweenAn)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
end


function CodeComparisonTableView:OnButtonClose(obj)
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    self:SetViewDisplay(false)
end


function CodeComparisonTableView:SetViewDisplay(display)
    self.obj:SetActive(display)
    if display then
        self.mTweenPlayer:ParallelPlay(false)
        HallWashCodeController.GetInstance().model:GetWashList(HallWashCodeModel.WashListType.washcode,function(data)
            self:RefreshData(data)
        end) 
    end
end

function CodeComparisonTableView:RefreshData(data)
    self:CleanAllItem()
    local count = #data.data
    local itemCount = #self.mItemList
    for i = 1, count do
        local item = self.mItemList[i]
        if item == nil then
            item = self:CreateItem()
            self.mItemList[i] = item
        end
       item:SetItemDisplay(true)
       item:SetData(data.data[i],i)
    end

    self.mGrid:Reposition()
end


function CodeComparisonTableView:CreateItem()
    local obj = GameObject.Instantiate(self.mObj_item,self.mParent)
    return CodeCommparisonTableItem.New(obj)
end

function CodeComparisonTableView:CleanAllItem()
    local count = #self.mItemList
    for i = 1, count do
        self.mItemList[i]:SetItemDisplay(false)
    end
end


function CodeComparisonTableView:SetPanelDepth(depth)
    SetPanelstartingRenderQueue(self.mPanel.gameObject,depth+20)
    SetPanelstartingRenderQueue(self.mScrollPanel.gameObject,depth+25)
end

function CodeComparisonTableView:__delete()
end