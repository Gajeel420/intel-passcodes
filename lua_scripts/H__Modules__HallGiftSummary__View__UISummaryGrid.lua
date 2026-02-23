UISummaryGrid =  BaseClass()

function UISummaryGrid:__init(obj)
    self.obj = obj
    self:InitUI()
end

function UISummaryGrid:InitUI()

    local mTran = self.obj.transform
    self.obj:SetActive(false)

    self.mLabelDay = mTran:Find("Label_Time").gameObject:GetComponent(typeof(UILabel))
    self.mLabelReceive = mTran:Find("Label_Receive").gameObject:GetComponent(typeof(UILabel))
    self.mLabelSend = mTran:Find("Label_Send").gameObject:GetComponent(typeof(UILabel))
end

function UISummaryGrid:SetData(data)
    self.data = data
    self.mLabelDay = CommonUtil.LuaTableToStringNoEmpty(data.m_szDay)
    SetNumberLabel(self.mLabelReceive,data.m_un64TotalRecv) 
	SetNumberLabel(self.mLabelSend,data.m_un64TotalSend) 
end

function UISummaryGrid:SetGridDisplay(display)
    self.obj:SetActive(display)
end

function UISummaryGrid:__delete()

end