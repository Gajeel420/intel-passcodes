
CashBackItem = CashBackItem or BaseClass()

function CashBackItem:__init( go )
	-- body
	self.obj = go
    self.Idel = "LevelBonus_Lock"
    self.Open = "LevelBonus_Lock_Open"
    self.iconName = "Icon_%02d"
    self.lvBgSpName = {"LV_BG_B","LV_BG_C","LV_BG_P","LV_BG_G"}
	self:InitUI()
end

function CashBackItem:InitUI( ... )
	local m_Trans = self.obj.transform
    self.ani = m_Trans:GetComponent(typeof(Animator))
    --self.ani.enabled = false
    self.icon = m_Trans:Find("Icon"):GetComponent(typeof(UISprite))
    self.Label_Bonus = m_Trans:Find("Label_Bonus"):GetComponent(typeof(UILabel))
    self.sliderLev = m_Trans:Find("Level_ALL"):GetComponent(typeof(UISlider))
    self.LV_BG = m_Trans:Find("Level_ALL/LV_BG"):GetComponent(typeof(UISprite))
    self.Level_Line_B = m_Trans:Find("Level_ALL/Level_Line_B").gameObject
    self.Level_Line_G = m_Trans:Find("Level_ALL/Level_Line_G").gameObject
    self.Label_Level = m_Trans:Find("Level_ALL/Label_Level"):GetComponent(typeof(UILabel))
end



function CashBackItem:SetItemData(data)
    --self.ani.enabled = false
    self.Label_Level.text = "LV."..data.lev
    self.Label_Bonus.text = data.reward
    --PrintLog(string.format(self.iconName,data.lev))
    self.icon.spriteName = string.format(self.iconName,data.lev)
    self.obj:SetActive(true)
end

function CashBackItem:SetLevBgSp(index)
    self.LV_BG.spriteName = self.lvBgSpName[index]
end

function CashBackItem:SetRewardActive(bol)
    self.Label_Bonus.gameObject:SetActive(bol)
end

function CashBackItem:SetRate(rate)
    self.sliderLev.value = rate
end

function CashBackItem:IshowLine(bol)
    self.Level_Line_B:SetActive(bol)
    self.Level_Line_G:SetActive(bol)
end

function CashBackItem:SetAnimator(open)
   -- self.ani.enabled = false
    --self.ani.enabled = true
    if open then
        self.ani:Play(self.Open)
    else
        self.ani:Play(self.Idel)
    end
end

function CashBackItem:__delete( ... )
	self.obj = nil
end

