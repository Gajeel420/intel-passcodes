QuickPaymentTitleItem = BaseClass()

function QuickPaymentTitleItem:__init(obj)
    self.obj = obj
    self:InitView()
end

function QuickPaymentTitleItem:InitView()
    local mTran = self.obj.transform
    local mTranUI = mTran:Find("Checkmark")
    if mTranUI ~= nil then
        self.mObj_Checked = mTranUI.gameObject
        self.mObj_Checked:SetActive(false)
    end

    mTranUI  = mTran:Find("Checkmark/Sprite")
    if mTranUI ~= nil then
        self.mLabel_Checkedtitle = mTranUI:GetComponent(typeof(UILabel))
    end

    mTranUI  = mTran:Find("Back/Sprite")
    if mTranUI ~= nil then
        self.mLabel_NormalTitle = mTranUI:GetComponent(typeof(UILabel))
    end
    self.IsScleck = false
    UIEventListener.Get(self.obj).onClick = function(obj) self:onItemClick(obj) end
end

--- 设置title
--- @param backFun function
--- @param obj Context
function QuickPaymentTitleItem:SetItemData(data,index,backFun,obj)
    self.data = data
    self.backFun = backFun
    self.mContext = obj
    self.mIndex = index
   -- self.mLabel_Checkedtitle.text = data.PayName2
   -- self.mLabel_NormalTitle.text = data.PayName2
    self:SetItemDispay(true)
    if self.mIndex == 1 then
        self:onItemClick(self.obj)
    end
end

--- 设置显隐
--- @param display bool
function QuickPaymentTitleItem:SetItemDispay(display)
    self.obj:SetActive(display)
    if not display then
        self.data = nil
        self.backFun = nil
        self.mContext = nil
    end
end

--- 设置是否选中
function QuickPaymentTitleItem:SetITemSelect(selectIndex)
    self.mObj_Checked :SetActive(selectIndex == self.mIndex)
end

function QuickPaymentTitleItem:onItemClick(obj)
    if not self.IsScleck then
        if self.backFun ~= nil then
            self.backFun(self.mContext,self.mIndex,self.data)
        end
    end
end

function QuickPaymentTitleItem:__delete()
end