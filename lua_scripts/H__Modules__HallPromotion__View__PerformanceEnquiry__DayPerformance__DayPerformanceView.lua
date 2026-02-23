DayPerformanceView = DayPerformanceView or BaseClass()

function DayPerformanceView:__init( obj )
    self.obj=obj
    self:Init()
end

function DayPerformanceView:Init( )
    local mTran = self.obj.transform
    self.mPanel_ConterPanel=mTran:GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel:ResetAndUpdateAnchors()
    self.mScrollView_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIScrollView))
    self.mGird_ItemGrid=mTran:Find("Content/ScrollPanel/Con_Detail/Grid"):GetComponent(typeof(UIGrid))
    self.mObj_ItemTemplate=mTran:Find("Content/ScrollPanel/Item").gameObject
    self.mObj_ItemTemplate:SetActive(false)
    self.mList_ItemList={}
    self.mObj_CloseButton=mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.mObj_CloseButton).onClick = function() 
        self:HideView()
    end
     
end

function DayPerformanceView:AddEvent( )

end

function DayPerformanceView:RemoveEvent( )

end

function DayPerformanceView:SetViewData(data)
    --[[
    local data={
        data=jsonData.data, --子项数据列表 {id,self_water,agent_water}
    }
    --]]
    self.mScrollView_ScrollPanel:ResetPosition()
    if data.data~=nil and  type(data.data)~="function" then
        for i = 1, #data.data do
            local item=self.mList_ItemList[i]
            if item==nil then
                local go=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGird_ItemGrid.transform)
                item=DayPerformanceItem.New(go)
                self.mList_ItemList[i]=item
            end
            data.data[i].rank=i
            item:SetItemData(data.data[i])
            item:ShowItem()
        end
    end
    self.mGird_ItemGrid:Reposition()
    -- StartCoroutine(function()
    --     yield_return(WaitForSeconds(0.12))
        
    -- end)
    
end


function DayPerformanceView:HideAllItem( )
    for i = 1,#self.mList_ItemList do
        local item=self.mList_ItemList[i]
        item:HideItem()
    end
end


function DayPerformanceView:ShowView(date )
    self.obj:SetActive(true)
    self:HideAllItem()
    HallPromotionModel.GetInstance():ReqEnquiryDataByDate(date,function (data)
        if self then
            self:SetViewData(data)
        end
    end)
end



function DayPerformanceView:HideView( )
    self.obj:SetActive(false)
end

function DayPerformanceView:SetPanelDepth(depth)
    self.mPanel_ConterPanel.depth=depth+1
    self.mPanel_ScrollPanel.depth=depth+2
end

function DayPerformanceView:__delete(  )

end
