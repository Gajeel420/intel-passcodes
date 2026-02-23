GooglePayItem = BaseClass()

function GooglePayItem:__init(obj)
    self.obj = obj
    self:InitView()
end

function GooglePayItem:InitView()
    self.m_Index = 1
    self.m_IconName = "Coins_"
    self.m_ProductID = 0
    self.m_Mid = "0"
    local mTran = self.obj.transform
    self.m_Icon = mTran:Find("Icon"):GetComponent(typeof(UISprite))
    self.m_Icon.spriteName = self.m_IconName.."01"
    self.m_Label_Chips = mTran:Find("Label_Chips"):GetComponent(typeof(UILabel))
    self.m_Label = mTran:Find("Label"):GetComponent(typeof(UILabel))
    self.m_Label_Chips.text = "" 
    self.m_Label.text = "" 
    UIEventListener.Get(self.obj).onClick = function ()
        self:OnClickItem()
    end
end

function GooglePayItem:InitIndex(index)
    self.m_Index = index
end

function GooglePayItem:SetData(data)
    self.m_ProductID =data.proid
    self.m_Mid = data.mid
    if self.m_Index > 8 then
        self.m_Icon.spriteName = self.m_IconName.."08"
    else
        self.m_Icon.spriteName = self.m_IconName.."0"..self.m_Index
    end

    self.m_Label_Chips.text = "[b]"..data.money.."[-]"
    self.m_Label.text = "[b]₹"..data.money.."[-]"
    self.obj:SetActive(true)
end

function GooglePayItem:SetObjActive(bol)
    self.obj:SetActive(false)
end

function GooglePayItem:OnClickItem()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    HallRechargeController:GetInstance():SendGooglePayOrder(self.m_Mid,function (data)
        self:HandleRequestGooglePay(data)
    end)
   
end

function GooglePayItem:HandleRequestGooglePay(data)
    HallRechargeModel:GetInstance().orderID = ""
    print("--------------------------------  去google pay")
    if data then
        HallRechargeModel:GetInstance().orderID = data.orderid
        HallRechargeModel:GetInstance().orderMoney = data.money
        PhoneManager:GooglePay(self.m_ProductID)
    else
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("GooglePayResultFailed"))
    end
end

function GooglePayItem:__delete()
end