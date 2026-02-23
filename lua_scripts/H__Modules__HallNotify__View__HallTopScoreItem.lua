HallTopScoreItem = BaseClass()

function HallTopScoreItem:__init(obj)
    self.obj = obj
    self:InitView()
end

function HallTopScoreItem:InitView()
    local mTran = self.obj.transform
    self.mObj_Num = mTran:Find("Num").gameObject

    self.mLable_UserName = mTran:Find("Label/Label_Name").gameObject:GetComponent(typeof(UILabel))
    self.mLable_GameName = mTran:Find("Label/Label_GameName").gameObject:GetComponent(typeof(UILabel))
    self.mLable_Other = mTran:Find("Label/Label_Other").gameObject:GetComponent(typeof(UILabel))
    self.mLable_Money = mTran:Find("Label/Label_Money").gameObject:GetComponent(typeof(UILabel))
    self.mLable_Time = mTran:Find("Label/Label_Time").gameObject:GetComponent(typeof(UILabel))

    self.LabelObj = mTran:Find("Label").gameObject
    self.Label1Obj=mTran:Find("Label1").gameObject
    self.Labele = mTran:Find("Label1/Label").gameObject:GetComponent(typeof(UILabel))
    self.Label1 = mTran:Find("Label/Label").gameObject:GetComponent(typeof(UILabel))
    mTran = nil
end

---设置是否显示
function HallTopScoreItem:SetItemDisplay(display)
    self.obj:SetActive(display)
end

---回收Item
function HallTopScoreItem:RecycleItem()
    self:SetItemDisplay(false)
    self.data = nil
end

function HallTopScoreItem:SetItemData(index,data)
    self.data = data
    self:SetItemDisplay(true)
    if index <= 10 then
        self.mObj_Num:SetActive(true)
    else
        self.mObj_Num:SetActive(false)
    end
    local x = SystemSetting:GetInstance().CurrentLanguage
    if x == SystemSetting:GetInstance().LanguageType[1] then
       
        self.LabelObj:SetActive(true)
        self.Label1Obj:SetActive(false) 
        -- self.mLable_UserName.text =StringFormat("玩家[00F0FFFF]{0}[-]在", GetStringNotFull(data.m_szNickName)) 
        -- self.mLable_GameName.text = data.m_szGameName
        -- self.mLable_Other.text = "游戏爆分"
        -- self.mLable_Money.text = NumberThousandsFormat(HallGoldRateSToC(tonumber(data.m_unScore)),1)
        -- self.mLable_Time.text = StringFormat("！！({0})",os.date("%H:%M",data.m_unTime)) 
       
    else
        
        
        self.LabelObj:SetActive(false)
        self.Label1Obj:SetActive(true) 
    end
     local y = StringFormat("玩家[00F0FFFF]{0}[-]在", GetStringNotFull(data.m_szNickName)).."[00F0FFFF]"..data.m_szGameName.."[-]".."游戏爆分"..NumberThousandsFormat(HallGoldRateSToC(tonumber(data.m_unScore)),1)..StringFormat("！！({0})",os.date("%H:%M",data.m_unTime))
        self.Label1.text = y
    local x = StringFormat("Congratulations to [00F0FFFF]{0}[-] for won {1} in [00F0FFFF]{2}[-] ! - {3}",GetStringNotFull(data.m_szNickName),NumberThousandsFormat(HallGoldRateSToC(tonumber(data.m_unScore)),1),data.m_szeGameName,os.date("%H:%M",data.m_unTime))
    self.Labele.text = x
   
end

function HallTopScoreItem:ChangeLangui(etype)
    if etype == 0 then
        self.LabelObj:SetActive(true)
        self.Label1Obj:SetActive(false) 
    else
        self.LabelObj:SetActive(false)
        self.Label1Obj:SetActive(true) 
    end
end

function HallTopScoreItem:__delete()
    self.mObj_Num = nil
    self.mLable_UserName = nil
    self.mLable_GameName = nil
    self.mLable_Other = nil
    self.mLable_Money = nil
    self.mLable_Time = nil
end