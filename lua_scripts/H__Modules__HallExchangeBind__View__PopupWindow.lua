PopupWindow = BaseClass()

function PopupWindow:__init(obj)
    self.obj = obj
    self.obj:SetActive(false)
    self:InitView()
end

function PopupWindow:InitView()
    self.mItemList = {}
    local mTran = self.obj.transform
    local mTranUI = mTran:Find("ScrollView")
    if mTranUI ~= nil then
        self.mScrollView = mTranUI:GetComponent(typeof(UIScrollView))
        self.mPanel_ScrollView = mTranUI.gameObject
    end
    mTranUI = mTran:Find("ScrollView/Grid")
    if mTranUI ~= nil then
        self.mParent = mTranUI
        self.mGrid= mTranUI:GetComponent(typeof(UIGrid))
    end

    mTranUI = mTran:Find("ScrollView/Grid/Item")
    if mTranUI ~= nil then
        self.mObj_item = mTranUI.gameObject
        self.mObj_item:SetActive(false)
    end
end

---设置开户银行名字
--- @param dataList table
--- @param funBack function
--- @param obj Context
function PopupWindow:SetBankListData(dataList,funBack,obj)
    local count = #dataList
    for i = 1, count do
        if self.mItemList[i] == nil then
            self.mItemList[i] = PopupWindowItem.New(InstantiateNewGameObject(self.mObj_item,self.mParent,i))
        end
        self.mItemList[i]:SetItemData(dataList[i],funBack,obj)
        self.mItemList[i]:SetPopupWindownDisplay(true)
    end
    self.mGrid:Reposition()
    
end

function PopupWindow:CleanAllItem()
    local cont = #self.mItemList
    for i = 1, cont do
        sself.mItemList[i]:SetPopupWindownDisplay(false)
    end
end

function PopupWindow:SetPopupViewDepth(depth)
    SetPanelstartingRenderQueue(self.obj,depth+8)
    SetPanelstartingRenderQueue(self.mPanel_ScrollView,depth + 10)
end

--- 设置弹框的显示隐藏
--- @param display bool
function PopupWindow:DisplayPopuwindow(display)
    if display then
        StartCoroutine(function ()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        
        self.mScrollView:ResetPosition()
    end)
    end
    self.obj:SetActive(display)
end

function PopupWindow:__delete()
end