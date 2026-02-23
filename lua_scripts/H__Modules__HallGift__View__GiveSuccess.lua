GiveSuccess =  BaseClass()

function GiveSuccess:__init(obj)
    self.obj = obj
    self:InitUI()
end

function GiveSuccess:InitUI()

    local mTran = self.obj.transform
    self.obj:SetActive(false)
    self.mLabel_Title = mTran:Find("Content/Label_Title").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Money = mTran:Find("Content/Money/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Copital = mTran:Find("Content/Capital/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Time = mTran:Find("Content/Time/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_State = mTran:Find("Content/Label_State").gameObject:GetComponent(typeof(UILabel))
    self.mButton_Sure =mTran:Find("Content/Button_Sure").gameObject
    UIEventListener.Get(self.mButton_Sure).onClick=function(obj) self:OnButtonSure(obj) end

end

function GiveSuccess:ShowView(data)
    self.mLabel_Title.text = StringFormat("[ff0000]{0}[-][ffebbf]赠送给[-][1eff00]{1}[-]",data.m_unID,data.m_unDstUin)
    self.mLabel_Money.text = NumberFormat(HallGoldRateSToC(HallGiftController.GetInstance().model.CurrentGiveMoney))
    self.mLabel_Copital.text = NumberToChineseLowercaseString(HallGoldRateSToC(HallGiftController.GetInstance().model.CurrentGiveMoney))
    self.mLabel_Time.text = os.date("%Y-%m-%d %H:%M:%S")
    local state = data.m_sResult == 0 and "成功！！！" or "失败！！！"
    self.obj:SetActive(true)
end

function GiveSuccess:OnButtonSure(obj)
    HallGiftController.GetInstance().model.CurrentGiveMoney = 0
    self.obj:SetActive(false)
end



function GiveSuccess:__delete()
end