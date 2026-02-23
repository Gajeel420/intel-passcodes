RecordView = RecordView or BaseClass()

function RecordView:__init( obj )
	-- body
	self.obj = obj
    self:Init()
end

function RecordView:Init()
    self.CurrentPage = 1
	self.PageSize = 50
	self.mGridList = {}
	local mTran = self.obj.transform
	self.parentPanel = mTran:Find("Con_Detail").gameObject:GetComponent(typeof(UIPanel))
	
	self.parentPanel:ResetAndUpdateAnchors()
	
	self.mScrollView_parentPanel=mTran:Find("Con_Detail"):GetComponent(typeof(UIScrollView))

	self.itemObj = mTran:Find("Con_Detail/Grid/Item").gameObject
	self.itemObj:SetActive(false)

	self.parentTran = mTran:Find("Con_Detail/Grid")

	self.mGrid = self.parentTran:GetComponent(typeof(UIGrid))
	self.obj:SetActive(false)

end

function RecordView:ShowView()
    self.obj:SetActive(true)
    HallExchangeModel:GetInstance():GetRecordList(self.CurrentPage,self.PageSize,function (recordList)
		self:SetRecordData(recordList)
	end)
end

function RecordView:HideView()
    self.obj:SetActive(false)
end

function RecordView:SetPanelDepth(depth)
    self.parentPanel.depth = depth
end



function RecordView:SetRecordData( resultData )
	self:HideAllGrid()
	self.mScrollView_parentPanel:ResetPosition()
	if resultData.num > 0 then
		if resultData.list ~= nil then
			local count = #resultData.list
			local gridCount = #self.mGridList
			for i=1,count do
				-- print(resultData.list[i].time)
				if i > gridCount then
					self:CreateItem(resultData.list[i],i)
				else
					self.mGridList[i]:SetDisPlay(true)
					self.mGridList[i]:SetData(resultData.list[i],i)
				end
			end
			self.mGrid:Reposition()
			StartCoroutine(function()
				yield_return(CS.UnityEngine.WaitForEndOfFrame())
				yield_return(CS.UnityEngine.WaitForEndOfFrame())
				yield_return(CS.UnityEngine.WaitForEndOfFrame())
				self.mScrollView_parentPanel:ResetPosition()
			end)
		end
	end
end

function RecordView:CreateItem(itemData,i)
	-- body
	local go = GameObject.Instantiate(self.itemObj,self.parentTran)
	go:SetActive(true)
	local grid = RecordItem.New(go)
	grid:SetData(itemData,i)
	table.insert(self.mGridList,grid)
end

function RecordView:HideAllGrid(  )
	-- body
	local count = #self.mGridList
	for i=1,count do
		self.mGridList[i]:SetDisPlay(false)
	end
end




function RecordView:__delete( ... )
	-- body

end