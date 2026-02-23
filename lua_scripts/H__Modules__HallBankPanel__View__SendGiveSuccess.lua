SendGiveSuccess = SendGiveSuccess or BaseClass()

function SendGiveSuccess:__init(obj)
    self.obj = obj
    self:InitUI()
end

function SendGiveSuccess:InitUI()

    local mTran = self.obj.transform
    self.mLabel_Title = mTran:Find("Content/Label_Title").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Money = mTran:Find("Content/Money/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Copital = mTran:Find("Content/Capital/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_Time = mTran:Find("Content/Time/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_State = mTran:Find("Content/Label_State").gameObject:GetComponent(typeof(UILabel))
    self.mButton_Sure =mTran:Find("Content/Button_Sure").gameObject
    self.mButtonClose = mTran:Find("Content/CloseBtn").gameObject
    UIEventListener.Get(self.mButton_Sure).onClick=function(obj) self:OnButtonSure(obj) end
    UIEventListener.Get(self.mButtonClose).onClick=function(obj) self:OnButtonSure(obj) end

end

function SendGiveSuccess:ShowView(data)
    if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
         self.mLabel_Title.text = StringFormat("[ff0000]{0}[-][ffebbf]赠送给[-][1eff00]{1}[-]",data.m_unID,data.m_unDstUin)
    else
         self.mLabel_Title.text = StringFormat("[ff0000]{0}[-][ffebbf] Give to [-][1eff00]{1}[-]",data.m_unID,data.m_unDstUin)
    end
   
    self.mLabel_Money.text = NumberFormat(HallGoldRateSToC(HallBankController.GetInstance().model.CurrentGiveMoney))
    self.mLabel_Copital.text = NumberToChineseLowercaseString(HallGoldRateSToC(HallBankController.GetInstance().model.CurrentGiveMoney))
    self.mLabel_Time.text = os.date("%Y-%m-%d %H:%M:%S")
    local state = data.m_sResult == 0 and "成功！！！" or "失败！！！"
    self.obj:SetActive(true)
end

function SendGiveSuccess:OnButtonSure(obj)
    HallBankController.GetInstance().model.CurrentGiveMoney = 0
    self.obj:SetActive(false)
end



function SendGiveSuccess:__delete()
end