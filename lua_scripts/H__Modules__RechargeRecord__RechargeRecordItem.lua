RechargeRecordItem = BaseClass()

function RechargeRecordItem:__init(obj)
    self.obj = obj
    self:InitUI()
end

function RechargeRecordItem:InitUI()
    local mTrn = self.obj.transform
    self.Label_Name = mTrn:Find("Label_Name").gameObject:GetComponent(typeof(UILabel))
    self.Label_Money = mTrn:Find("Label_Money").gameObject:GetComponent(typeof(UILabel))
    self.mSprite_State = mTrn:Find("Sprite_State").gameObject:GetComponent(typeof(UILabel))
    self.mObj_Line =  mTrn:Find("Line").gameObject
end

function RechargeRecordItem:SetData(data,index)
    local m,d = math.modf( (index /2))
    self.mObj_Line:SetActive(d == 0)
    self.Label_Name.text = GetStringNotFull(data.nickname)
    self.Label_Money.text = data.money
    if tonumber(data.type) == 2 then
        self.mSprite_State.text = RechargeRecordModel.StateName[tonumber(data.type)]
    else
        if tonumber(data.paytype) == 701 or tonumber(data.paytype) == 702 then
            self.mSprite_State.text = RechargeRecordModel.StateName[3]
        else
            self.mSprite_State.text = RechargeRecordModel.StateName[4]
        end
    end
end

function RechargeRecordItem:SetDisplay(display)
    self.obj:SetActive(display)
end

function RechargeRecordItem:__delete()

end