CodeCommparisonTableItem= BaseClass()

function CodeCommparisonTableItem:__init(obj)
    self.obj = obj
    self:InitView()
end

function CodeCommparisonTableItem:InitView()
    local mTran = self.obj.transform
    mTran.localPosition = Vector3.zero
    mTran.localScale = Vector3.one

    self.mLable_GrandTotal = mTran:Find("Lable/Label"):GetComponent(typeof(UILabel))
    self.mLable_Code = mTran:Find("Lable/Label1"):GetComponent(typeof(UILabel))
    self.mLable_tody = mTran:Find("Lable/Label3"):GetComponent(typeof(UILabel))
    self.mLable_yesterday = mTran:Find("Lable/Label2"):GetComponent(typeof(UILabel))
    self.mObj_BG = mTran:Find("Tex").gameObject
end

function CodeCommparisonTableItem:SetItemDisplay(display)
    self.obj:SetActive(display)
end


function CodeCommparisonTableItem:SetLabelValue(mLabel,value)
    if not mLabel then return end
    if value =="-" then
        mLabel.text = value
    else
        value=value or 0
        value=HallGoldRateSToC(value)
        mLabel.text=string.gsub(NumberThousandsFormat(value),"元","")
    end
   
end

function CodeCommparisonTableItem:SetData(data,index)
    local n1,n2 = math.modf( index/2 )
    self.mObj_BG:SetActive(n2 ~= 0)
    self.mLable_GrandTotal.text = data.name
    self:SetLabelValue(self.mLable_yesterday,data.ywater)
    self:SetLabelValue(self.mLable_tody,data.water)
    self:SetLabelValue(self.mLable_Code,data.commission)
end


function CodeCommparisonTableItem:__delete()

end