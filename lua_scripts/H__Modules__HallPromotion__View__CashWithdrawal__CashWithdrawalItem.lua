

CashWithdrawalItem = CashWithdrawalItem or BaseClass()

function CashWithdrawalItem:__init( obj )
    self.obj=obj
    self:Init()
end

function CashWithdrawalItem:Init( )
    local mTran = self.obj.transform
    self.mLabel_Day=mTran:Find("Label_01"):GetComponent(typeof(UILabel))
    self.mLabel_Time=mTran:Find("Label_02"):GetComponent(typeof(UILabel))
    self.mLabel_Money=mTran:Find("Label_03"):GetComponent(typeof(UILabel))
    self.mLabel_State=mTran:Find("Label_04"):GetComponent(typeof(UILabel))
    
end


function CashWithdrawalItem:SetItemData(data)
    --子项数据列表 {status_con,paymoney,day,time}
    self.mLabel_Day.text=tostring(data.day)
    self.mLabel_Time.text=tostring(data.time)
    self.mLabel_Money.text=""..NumberFormat(HallGoldRateSToC(data.paymoney))
    self.mLabel_State.text=tostring(data.status_con)
end

function CashWithdrawalItem:ShowItem()
    self.obj:SetActive(true)
end
function CashWithdrawalItem:HideItem()
    self.obj:SetActive(false)
end


function CashWithdrawalItem:__delete(  )

end
