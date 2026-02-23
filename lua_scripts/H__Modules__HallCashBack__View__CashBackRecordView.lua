CashBackRecordView = CashBackRecordView or BaseClass()

function CashBackRecordView:__init( go )
	-- body
	self.obj = go
    self.recordItemIns = {}
	self:InitUI()
end

function CashBackRecordView:InitUI( ... )
	local m_Trans = self.obj.transform
    self.m_PanelTran= m_Trans:GetComponent(typeof(UIPanel))
    --PrintLog("qqqq1111111111111111111")
    self.m_Panel_ScrollView = m_Trans:Find("Scroll_View_Item/Scroll View"):GetComponent(typeof(UIPanel))
    --PrintLog("qqqq22222222222222222222222")
    self.Item_Icon = m_Trans:Find("Scroll_View_Item/Item_Icon").gameObject
   -- PrintLog("qqqq33333333333333333333")
	self.Item_Icon:SetActive(false)
    self.mScroll = m_Trans:Find("Scroll_View_Item/Scroll View"):GetComponent(typeof(UIScrollView))
    self.mGrid = m_Trans:Find("Scroll_View_Item/Scroll View/Grid"):GetComponent(typeof(UIGrid))
    self.tweenScaleconten = m_Trans:GetComponent(typeof(TweenScale))
    --PrintLog("qqqq444444444444444444")
    self.closeBtn = m_Trans:Find("Btn_Close").gameObject
	UIEventListener.Get(self.closeBtn).onClick = function ()
        self.obj:SetActive(false)
    end
end


function CashBackRecordView:SetData(depth)
    PrintLog("wwwwwwwwwwwwwwwwwww1111111111111")
    self.m_PanelTran.depth = depth + 5
    self.m_Panel_ScrollView.depth = depth + 6
    local data = HallCashBackModel:GetInstance():GetRecordData()
    PrintLog("wwwwwwwwwwwwwwwwwww22222222222222222")
    pt(data)
    local index = 0
    for i = 1, #data do
        if data[i].status then
            index = index + 1
         self:CreateItem(index,data[i])
        end
    end
   self:PlayTween(self.tweenScaleconten)
    self.obj:SetActive(true)
    StartCoroutine(function()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mGrid:Reposition()
        self.mScroll:ResetPosition()
    end)  
end


function CashBackRecordView:CreateItem(index,data)
	local go
	if self.recordItemIns[index] == nil then
		go = GameObject.Instantiate(self.Item_Icon,self.mGrid.transform)
		self.recordItemIns[index] = CashBackRecordItem.New(go)
	end
	self.recordItemIns[index]:SetItemData(data)
end

function CashBackRecordView:PlayTween(Tween,back,context)
    Tween.enabled = true
	Tween:ResetToBeginning()
	Tween:PlayForward()
	Tween:SetOnFinished(function ()
		if back ~= nil then
			back(context)
		end
	end)
end

function CashBackRecordView:__delete( ... )
	self.obj = nil
end

