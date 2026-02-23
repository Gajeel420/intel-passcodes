CollectBankView = BaseClass()

function CollectBankView:__init(obj)
    self.obj = obj
    self:InitView()
end

function CollectBankView:InitView()
    local mTran = self.obj.transform
    self.mLabel_BankName = mTran:Find("BankName/label").gameObject:GetComponent(typeof(UILabel))        --收款银行
    self.mLabel_BankName.text = ""

    self.mLabel_BankNum = mTran:Find("BankNum/label").gameObject:GetComponent(typeof(UILabel))          --银行卡号
    local mBtn_BankNum = mTran:Find("BankNum/BtnCopy").gameObject
    UIEventListener.Get(mBtn_BankNum).onClick = function(go) self:OnButtonCopyBankNum(go)  end
    self.mLabel_BankNum.text = ""

    self.mLabel_OpenAccount = mTran:Find("OpenAccount/label").gameObject:GetComponent(typeof(UILabel))  --开户姓名
    local mBtn_OpenAccount = mTran:Find("OpenAccount/BtnCopy").gameObject
    UIEventListener.Get(mBtn_OpenAccount).onClick = function(go) self:OnButtonCopyOpenAccount(go)  end
    self.mLabel_OpenAccount.text = ""

    self.mLabel_GameID = mTran:Find("GameID/label").gameObject:GetComponent(typeof(UILabel))            --游戏ID
    self.mLabel_GameID.text = "0"
    local mBtn_CopyGameID = mTran:Find("GameID/BtnCopy").gameObject
    UIEventListener.Get(mBtn_CopyGameID).onClick = function(go) self:OnButtonCopyGameIDClick(go)  end
   
end


function CollectBankView:SetData(data)

    self.mLabel_GameID.text = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    self.mLabel_BankName.text = data.bankName
    self.mLabel_BankNum.text =data.bankCard
    self.mLabel_OpenAccount.text = data.Name
    
end

---拷贝游戏ID
function CollectBankView:OnButtonCopyGameIDClick(go)
    local value = self.mLabel_GameID.text
    if value then
        PhoneManager:MyClipDataToClipboard(value)
	    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
    end
end

---拷贝开户姓名
function CollectBankView:OnButtonCopyOpenAccount(go)
    local value = self.mLabel_OpenAccount.text
    if value then
        PhoneManager:MyClipDataToClipboard(value)
	    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
    end
end

---拷贝银行卡
function CollectBankView:OnButtonCopyBankNum(go)
    local value = self.mLabel_BankNum.text
    if value then
        PhoneManager:MyClipDataToClipboard(value)
	    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
    end
end

function CollectBankView:__delete()

end