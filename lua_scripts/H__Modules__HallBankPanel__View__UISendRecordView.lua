UISendRecordView=UISendRecordView or BaseClass()

function UISendRecordView:__init( obj )
	
	self.obj=obj
	self:InitUI()
end

function UISendRecordView:InitUI()
	--new 
	local mTran = self.obj.transform
	
	self.mScrollView_ScrollPanel=mTran:Find("ScrollPanel"):GetComponent(typeof(UIScrollView))
	self.mGrid_ScrollGrid=mTran:Find("ScrollPanel/Grid"):GetComponent(typeof(UIGrid))
	self.mObj_ItemTemplate=mTran:Find("Item").gameObject
	self.mObj_ItemTemplate:SetActive(false)

	
	self.Transfer_in_record_01 = mTran:Find("Top/Transfer_in_record_01").gameObject
	self.Transfer_in_record_02 = mTran:Find("Top/Transfer_in_record_02").gameObject
	self.Transfer_in_record_01:SetActive(false)
	self.Transfer_in_record_02:SetActive(false)

	
	

	self.mCurrentSelete=0;
	self.mList_RecrdItem={}

	self.mInt_PageSize=30

	self.mInt_Item_Y=65

end

function UISendRecordView:ShowOrHide(isdis,index)
	self.obj:SetActive(isdis)
	if not isdis then
		self:RemoveAllEvent()
	else
		self:OnClickToggleButton(index)
	end
end


function UISendRecordView:RemoveAllEvent()
	HallBankModel.GetInstance():RemoveEventListener(HallBankModel.EventType.ReceiveDataReturn,self.UpdateDataList,self)
	HallBankModel.GetInstance():RemoveEventListener(HallBankModel.EventType.GiveDataReturn,self.UpdateDataList,self)
end


function UISendRecordView:UpdateDataList(recordData)
	--new

	if self.mCurrentSelete~=recordData.RecordList[1].m_ucType then
		return
	end
	self:UpdateScrollView(recordData.RecordList)

end


function UISendRecordView:UpdateScrollView(dataList)
	for i = 1, #dataList do
		if self.mList_RecrdItem[i]==nil then
			local obj=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGrid_ScrollGrid.transform)
			obj.name=tostring(i)
			obj.transform.localPosition = Vector3(0,0-(i-1)*self.mInt_Item_Y,0)
			obj.transform.localScale = Vector3.one
			obj.transform.localEulerAngles = Vector3.zero
			self.mList_RecrdItem[i]=UISendRecordItem.New(obj)
		end
		local item=self.mList_RecrdItem[i]
		item:SetData(dataList[i])
		item:SetActive(true)
	end

	for i = #dataList+1, #self.mList_RecrdItem do
		local item=self.mList_RecrdItem[i]
		item:SetActive(false)
	end

	self.mScrollView_ScrollPanel:ResetPosition()
end

function UISendRecordView:HideAllItem()
	for i = 1, #self.mList_RecrdItem do
		self.mList_RecrdItem[i]:SetActive(false)
	end
end


function UISendRecordView:OnClickToggleButton(index)
	self:RemoveAllEvent()
	self:HideAllItem()
	local type=nil
	if index==1 then
		type=HallBankModel.RecordType.Receive
		self.Transfer_in_record_01:SetActive(true)
		self.Transfer_in_record_02:SetActive(false)
	else
		type=HallBankModel.RecordType.Give
		self.Transfer_in_record_01:SetActive(false)
		self.Transfer_in_record_02:SetActive(true)
	end
	self.mCurrentSelete=type
	if type==HallBankModel.RecordType.Receive then
		HallBankModel.GetInstance():AddEventListener(HallBankModel.EventType.ReceiveDataReturn,self.UpdateDataList,self)
		HallBankModel.GetInstance():RequestRecordData(HallBankModel.RecordType.Receive,1,self.mInt_PageSize)
	else
		HallBankModel.GetInstance():AddEventListener(HallBankModel.EventType.GiveDataReturn,self.UpdateDataList,self)
		HallBankModel.GetInstance():RequestRecordData(HallBankModel.RecordType.Give,1,self.mInt_PageSize)
	end



end


function UISendRecordView:SetPanelDepth( depth )
	
	self.mScrollView_ScrollPanel:GetComponent(typeof(UIPanel)).depth=depth+1
end

function UISendRecordView:__delete( ... )
	self.model = nil
	self.scrollView = nil
	self.tranItemParent = nil
	self.objItemPrefab = nil
	self.itemList = nil
	self.fStartY = nil
	self.fOffsetY = nil
	self.obj = nil
end