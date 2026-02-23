UIZhiFuBao=UIZhiFuBao or BaseClass()
function UIZhiFuBao:__init(obj)
	self.obj=obj
end

function UIZhiFuBao:InitUI()
	local tranRoot = self.obj.transform
	self.ScrollView=tranRoot:Find("ScrollView/ScrollPanel"):GetComponent(typeof(UIScrollView))
	self.GridParent=tranRoot:Find("ScrollView/ScrollPanel/Grid")
	self.objStoreGrid=tranRoot:Find("ScrollView/ScrollPanel/Grid/RechargeGrid").gameObject
	self.GridControl=tranRoot:Find("ScrollView/ScrollPanel/Grid"):GetComponent(typeof(UIGrid))

	self.objStoreGrid:SetActive(false)
	self.listItem={}
	self.model=HallRechargeModel:GetInstance()

end

function UIZhiFuBao:ShowUI()
	self.model:AddEventListener(HallRechargeConst.EventName_RequiredPayMoneyListCallBack,self.RequiredPayMoneyListCallBack,self)
	self.obj:SetActive(true)
	if self.iCount<=8 then
		self.GridParent.localPosition = Vector3(0,-45,0)
        self.GridControl.pivot = UIWidget.Pivot.Center
        self.GridControl.arrangement = UIGrid.Arrangement.Horizontal
        self.GridControl.maxPerLine = 4
    else
    	self.GridParent.localPosition =  Vector3(3,57,0)
        self.GridControl.pivot = UIWidget.Pivot.TopLeft
        self.GridControl.arrangement = UIGrid.Arrangement.Vertical
        self.GridControl.maxPerLine = 2
	end
	self.GridControl:Reposition()
	self.ScrollView:ResetPosition()
    -- self.ScrollView:SetXZero()
    -- self.ScrollView:SetYZero()
end

function UIZhiFuBao:HideUI()
	self.model:RemoveEventListener(HallRechargeConst.EventName_RequiredPayMoneyListCallBack,self.RequiredPayMoneyListCallBack,self)
	self.obj:SetActive(false)
end

function UIZhiFuBao:RequiredPayMoneyListCallBack()
	self:SetUI()
end

--生产排序商品Grid
function UIZhiFuBao:SortStoreGrid(item, grid)
	if item == nil or grid == nil then return end
	local go = GameObject.Instantiate(item, grid)
	go.transform.localPosition = Vector3.zero
	go.transform.localScale = Vector3.one
	go.transform.localEulerAngles = Vector3.zero
    return go
end

function UIZhiFuBao:SetUI(iType)
	self:RecycleItem()
	self.iType=iType or self.iType
	self.iCount=0
	local payItemList=StoreModuleModel:GetInstance():GetPayItemListByType(self.iType)
	if not payItemList or not next(payItemList) then return end
	for i,itemVo in ipairs(payItemList) do
		local item=self.listItem[i]
		if not item then
			local go=self:SortStoreGrid(self.objStoreGrid, self.GridParent)
			item = UIStoreGrid.New(go)
			table.insert(self.listItem,item)
		end
		item:SetItem(itemVo)
		item:Show()
		self.iCount=self.iCount+1
	end
end

function UIZhiFuBao:RecycleItem()
	if self.listItem then
		for _,item in ipairs(self.listItem) do
			item:Hide()
		end
	end
end

function UIZhiFuBao:SetPanelDepth(depth )
	self.ScrollView:GetComponent(typeof(UIPanel)).depth=depth
end

function UIZhiFuBao:__delete( ... )
	self.model:RemoveEventListener(HallRechargeConst.EventName_RequiredPayMoneyListCallBack,self.RequiredPayMoneyListCallBack,self)
	self.ScrollView = nil
	self.GridParent = nil
	self.objStoreGrid = nil
	self.GridControl = nil
end