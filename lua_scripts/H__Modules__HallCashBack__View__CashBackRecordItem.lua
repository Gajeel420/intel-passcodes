CashBackRecordItem = CashBackRecordItem or BaseClass()

function CashBackRecordItem:__init( go )
	-- body
	self.obj = go
    self.Idel = "LevelBonus_Lock"
    self.Open = "LevelBonus_Lock_Open"
    self.iconName = "Icon_%02d"
    self.lvBgSpName = {"LV_BG_B","LV_BG_C","LV_BG_P","LV_BG_G"}
	self:InitUI()
end

function CashBackRecordItem:InitUI( ... )
	local m_Trans = self.obj.transform
    self.Level = m_Trans:Find("Level"):GetComponent(typeof(UILabel))
    self.Bonus = m_Trans:Find("Bonus"):GetComponent(typeof(UILabel))
    self.Time = m_Trans:Find("Time"):GetComponent(typeof(UILabel))
end



function CashBackRecordItem:SetItemData(data)
    self.Bonus.text = NumberFormat(HallGoldRateSToC(data.cash_back))
    self.Time.text = data.date
    local lv = HallCashBackModel:GetInstance():GetLvByCashBack(data.cash_back)
    self.Level.text = "LV."..lv
    self.obj:SetActive(true)
end

function CashBackRecordItem:__delete( ... )
	self.obj = nil
end
