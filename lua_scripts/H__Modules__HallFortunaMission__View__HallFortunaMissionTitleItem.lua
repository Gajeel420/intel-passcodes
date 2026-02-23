HallFortunaMissionTitleItem = BaseClass()

function HallFortunaMissionTitleItem:__init(obj)
    self.obj = obj
    self:InitUI()
end

function HallFortunaMissionTitleItem:InitUI()
    local mTran = self.obj.transform
    self.index = 0
    self.data = nil
    self.IsSelect = false
    self.mObj_CheckMark = mTran:Find("Checkmark").gameObject
    self.mObj_CheckMark:SetActive(false)
    local mTranUI = mTran:Find("Checkmark/TitleLable")
    if mTranUI ~= nil then
        self.mLable_CheckMark = mTranUI:GetComponent(typeof(UILabel))
    end
    mTranUI = mTran:Find("Normal/TitleLable")
    if mTranUI ~= nil then
        self.mLable_Normal = mTranUI:GetComponent(typeof(UILabel))
    end
end

----设置标题
---title标题
---index 下标
function HallFortunaMissionTitleItem:SetTitle(data,index)
    self.index = index
    self.data = data
    if CheckServiceJsonDataIsNullOrEmpty(data.m_szContent) ~= nil then
        self.obj:SetActive(true)
        self.mLable_CheckMark.text = StringFormat("[b]{0}[-]",data.m_szContent)
        self.mLable_Normal.text = StringFormat("[b]{0}[-]",data.m_szContent)
    end
end

---设置被选中的标题
function HallFortunaMissionTitleItem:SetTitleSelect(index)
    if self.index == index then
        self.mObj_CheckMark:SetActive(true)
        if not self.IsSelect then
            self.IsSelect = true
            print("查询任务列表",self.data.m_GeneralTypeId)
            HallFortunaMissionModel.GetInstance():CClientQueryTaskListReq(self.data.m_GeneralTypeId)
        end
    else
        self.IsSelect = false
        self.mObj_CheckMark:SetActive(false)
    end

end

---回收当当前标题
function HallFortunaMissionTitleItem:RecycleTitleItem()
    self.index = 0
    self.data = nil
    self.IsSelect = false
    self.obj:SetActive(false)
end

function HallFortunaMissionTitleItem:__delete()
    self.mObj_CheckMark = nil
    self.mLable_CheckMark = nil
    self.mLable_Normal = nil
    self.index = nil
    self.data = nil
    self.IsSelect = nil
end