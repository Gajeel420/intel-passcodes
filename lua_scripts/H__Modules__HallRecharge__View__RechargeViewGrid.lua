RechargeViewGrid = BaseClass()

function RechargeViewGrid:__init(obj)
    self.obj = obj
    self:InitUI()
end

function RechargeViewGrid:InitUI()
    local mTran = self.obj.transform
    self.mLabel_Select = mTran:Find("Checkmark/Sprite").gameObject:GetComponent(typeof(UILabel))
    self.mLable_nomar = mTran:Find("Back/Sprite").gameObject:GetComponent(typeof(UILabel))
    self.mLable_nomar.text = "///"
    self.mObj_Select = mTran:Find("Checkmark").gameObject
    self.mObj_nomar =  mTran:Find("Back").gameObject
    self.payItemList = {};
    self.mBack = nil
    self.index = 0
    self:SetSelect(false)
    UIEventListener.Get(self.obj).onClick=function(go) self:OnItemClick(go) end
end


function RechargeViewGrid:OnItemClick(go)
    if self.mBack ~= nil then
        self.mBack(self.index,self.payItemList,tonumber(self.data.TypeID),self.data.Issdk)
    end
end

function RechargeViewGrid:SetData(data,index,back)
   
    if CheckServiceJsonDataIsNullOrEmpty(data.denomination) and data.denomination ~= "1" then
        self.index = index
        self.mBack = back
        self.data = data
        self.obj:SetActive(true)
        --self.mLabel_Select.text =data.PayName2
       -- self.mLable_nomar.text = data.PayName2
        self:ParstPayList()
        if index == 1 then
            self:OnItemClick(self.obj)
        end
    end
end


---解析面额列表
function RechargeViewGrid:ParstPayList()
    local jdList = self.data.denomination

    self.payItemList = {}
    for i=1,#jdList do
		local item=PayItemVo.New()
		if jdList[i].mid~=nil then
			item.iID=tonumber(jdList[i].mid)
		end

		if jdList[i].PayType~=nil then
			item.iType=tonumber(jdList[i].PayType)
		end

		if jdList[i].number~=nil then
			item.iGoodNum=tonumber(jdList[i].number)
		end

		if jdList[i].getnum~=nil then
			item.iGiveGold=tonumber(jdList[i].getnum)
		end

		if jdList[i].money~=nil then
			item.iRmbNum=tonumber(jdList[i].money)
		end
		item.iIndex=i
		table.insert(self.payItemList,item)
	end
end


function RechargeViewGrid:SetSelect(isSelect)
    --self.mObj_Select:SetActive(isSelect)
    --self.mObj_nomar:SetActive(not(isSelect))
    -- local scale = isSelect and 1.5 or 1
    -- self.obj.transform.localScale =  Vector3(1,1,scale)
end


function RechargeViewGrid:SetDisplay(display)
    self.obj:SetActive(display)
end
function RechargeViewGrid:__delete()

end