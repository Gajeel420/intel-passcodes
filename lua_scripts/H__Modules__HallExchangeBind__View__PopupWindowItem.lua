PopupWindowItem = BaseClass()

function PopupWindowItem:__init(obj)
    self.obj = obj
    self:InitView()
end

function PopupWindowItem:InitView()
    local mTran = self.obj.transform
    local mTranUI = mTran:Find("Lable")
    if mTranUI ~= nil then
        self.mLabel_BankName = mTranUI:GetComponent(typeof(UILabel))
    end
    UIEventListener.Get(self.obj).onClick = function(obj) self:OnItemClick(obj) end
end

--- 设置银行名字
--- @param bankname string
--- @param backFun function
--- @param obj Context
function PopupWindowItem:SetItemData(bankName,backFun,obj)
    self.BackFun = backFun
    self.Self = obj
    self.BankName = bankName
    if self.mLabel_BankName ~= nil then
        self.mLabel_BankName.text = bankName
    end
end

function PopupWindowItem:SetPopupWindownDisplay(display)
    self.obj:SetActive(display)
    if not display then
        self.BankName = nil
        self.BankName = nil
        self.Self = nil
    end
end

function PopupWindowItem:OnItemClick(obj)
    if self.BankName ~= nil and self.BackFun ~= nil then
        self.BackFun(self.Self,self.BankName)
    end
end


function PopupWindowItem:__delete()
end