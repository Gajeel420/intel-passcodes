HallRankItem = HallRankItem or BaseClass()

function HallRankItem:__init( go )
	-- body
	self.obj = go
	self:InitUI()
end

function HallRankItem:InitUI( ... )
	local m_Trans = self.obj.transform

    self.m_Go_Rank_Num01 = m_Trans:Find("Rank_Num01").gameObject
    self.m_Sprite_Rank_Num01 = m_Trans:Find("Rank_Num01"):GetComponent(typeof(UISprite))
    
    self.m_Go_Rank_Num02 = m_Trans:Find("Rank_Num02").gameObject
    self.m_Label_Rank_Num02 = m_Trans:Find("Rank_Num02/Rank_Num"):GetComponent(typeof(UILabel))
    
    self.m_Label_Score = m_Trans:Find("Score_Num"):GetComponent(typeof(UILabel))
    self.m_Label_Name = m_Trans:Find("Name"):GetComponent(typeof(UILabel))
    self.m_Sprite_Rank_NO_BG= m_Trans:Find("Rank_NO_BG"):GetComponent(typeof(UISprite))
end

function HallRankItem:SetRankItemData(data,rankNum)
    if rankNum <= 3 and rankNum > 0 then
        self.m_Go_Rank_Num01:SetActive(true)
        self.m_Go_Rank_Num02:SetActive(false)
        self.m_Sprite_Rank_Num01.spriteName = "Rank_NO"..rankNum
        self.m_Sprite_Rank_NO_BG.spriteName = "Rank_BG_NO"..rankNum
    else
        self.m_Go_Rank_Num01:SetActive(false)
        self.m_Go_Rank_Num02:SetActive(true)
        self.m_Label_Rank_Num02.text = tostring(rankNum)
        self.m_Sprite_Rank_NO_BG.spriteName = "Rank_BG_NO4"
    end
    self.m_Label_Score.text = NumberFormat(HallGoldRateSToC(data.m_n64WinMoney))
    self.m_Label_Name.text = data.m_szNickName
    self:SetObjActive(true)
end

function HallRankItem:SetObjActive(bol)
    self.obj:SetActive(bol)
end

function HallRankItem:__delete( ... )
	self.obj = nil
end

