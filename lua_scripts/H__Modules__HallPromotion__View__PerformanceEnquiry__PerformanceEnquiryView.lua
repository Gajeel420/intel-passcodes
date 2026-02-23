PerformanceEnquiryView = PerformanceEnquiryView or BaseClass()

function PerformanceEnquiryView:__init( obj )
    self.obj=obj
    self:Init()
end

function PerformanceEnquiryView:Init( )
    local mTran = self.obj.transform

    -- self.mLabel_TeamPerformance=mTran:Find("Con_Bottom/Results_01/Label_Result"):GetComponent(typeof(UILabel))
    -- self.mLabel_DirectPerformance=mTran:Find("Con_Bottom/Results_02/Label_Result"):GetComponent(typeof(UILabel))
    -- self.mLabel_Subordinateformance=mTran:Find("Con_Bottom/Results_03/Label_Result"):GetComponent(typeof(UILabel))
    -- self.mLabel_EstimatedRevenue=mTran:Find("Con_Bottom/Results_04/Label_Result"):GetComponent(typeof(UILabel))
    -- self.mLabel_AmountOfAdvance=mTran:Find("Con_Bottom/Results_05/Label_Result"):GetComponent(typeof(UILabel))


    self.mPanel_ScrollPanel=mTran:Find("ScrollPanel/Con_Detail"):GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel:ResetAndUpdateAnchors()
    self.mScrollView_ScrollPanel=mTran:Find("ScrollPanel/Con_Detail"):GetComponent(typeof(UIScrollView))
    self.mGird_ItemGrid=mTran:Find("ScrollPanel/Con_Detail/Grid"):GetComponent(typeof(UIGrid))
    self.mObj_ItemTemplate=mTran:Find("ScrollPanel/Item").gameObject
    self.mObj_ItemTemplate:SetActive(false)
    self.mList_ItemList={}


    --当日业绩页面初始化
    local obj_DayPerformanceView=mTran:Find("Content").gameObject
    self.DayPerformanceView=DayPerformanceView.New(obj_DayPerformanceView)

    self.mObj_NoData = mTran:Find("ScrollPanel/None").gameObject



end

function PerformanceEnquiryView:AddEvent( )

end

function PerformanceEnquiryView:RemoveEvent( )

end

function PerformanceEnquiryView:SetViewData(data)
    
    if data.data~=nil then
        for i = 1, #data.data do
            local item=self.mList_ItemList[i]
            if item==nil then
                local go=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGird_ItemGrid.transform)
                item=PerformanceEnquiryItem.New(go)
                self.mList_ItemList[i]=item
            end
            item:SetItemData(data.data[i],self.OnClickItem,self)
            item:ShowItem()
        end
    end
    self.mGird_ItemGrid:Reposition()
    self.mObj_NoData:SetActive(data.data == nil)
    StartCoroutine(function()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        
        self.mScrollView_ScrollPanel:ResetPosition()
    end)
    
end


function PerformanceEnquiryView:OnClickItem( data )
    self.DayPerformanceView:ShowView(data.create_date)
end


function PerformanceEnquiryView:HideAllItem( )
    for i = 1,#self.mList_ItemList do
        local item=self.mList_ItemList[i]
        item:HideItem()
    end
end


function PerformanceEnquiryView:ShowView( )
    self.DayPerformanceView:HideView()
    self.obj:SetActive(true)
    self:HideAllItem()

    HallPromotionModel.GetInstance():ReqEnquiryData(function (data)
        if self then
            self:SetViewData(data)
        end
    end)

end



function PerformanceEnquiryView:HideView( )
    self.DayPerformanceView:HideView()
    self.obj:SetActive(false)
end

function PerformanceEnquiryView:SetPanelDepth(depth)
    self.mPanel_ScrollPanel.depth=depth
    self.DayPerformanceView:SetPanelDepth(depth+5)
end

function PerformanceEnquiryView:__delete(  )

end
