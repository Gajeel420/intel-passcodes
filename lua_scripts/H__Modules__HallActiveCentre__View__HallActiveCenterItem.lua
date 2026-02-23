HallActiveCenterItem = HallActiveCenterItem or BaseClass()

function HallActiveCenterItem:__init(obj)
    self.obj = obj
    self:InitUI()
end

function HallActiveCenterItem:InitUI()
    local mTran = self.obj.transform
    self.mLabel_upTitle = mTran:Find("Checkmark/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_NormalTitle = mTran:Find("Back/Label").gameObject:GetComponent(typeof(UILabel))
    self.NormalObj = mTran:Find("Back").gameObject
    self.CheckMarkObj = mTran:Find("Checkmark").gameObject
    self.CheckMarkObj:SetActive(false)
    UIEventListener.Get(self.obj).onClick = function(obj) self:OnItemClick(obj) end
end

function HallActiveCenterItem:SetData(data)
    self.data = data
    self.mLabel_NormalTitle.text = data.Title
    self.mLabel_upTitle.text = data.Title
end

function HallActiveCenterItem:SetItemDisplay(display)
    self.obj:SetActive(display)
    if (not(display)) then
        self.data = nil
        self.onClickBack = nil
        self.mLabel_NormalTitle.text = ""
        self.mLabel_upTitle.text = ""
    end
end

function HallActiveCenterItem:SetToggleState(value)
    
    self.CheckMarkObj:SetActive(value)
    self.NormalObj:SetActive(not(value))
end

function HallActiveCenterItem:OnItemClick()
    
    if self.onClickBack then
        self.onClickBack(self.data.url)
    end
end

function HallActiveCenterItem:__delete()
end