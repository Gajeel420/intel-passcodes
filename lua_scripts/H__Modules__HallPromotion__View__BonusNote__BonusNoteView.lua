
BonusNoteView = BonusNoteView or BaseClass()

function BonusNoteView:__init( obj )
    self.obj=obj
    self:Init()
end

function BonusNoteView:Init( )
    local mTran = self.obj.transform
    self.obj:SetActive(false)
    self.mPanel_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel:ResetAndUpdateAnchors()
    self.mScrollView_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIScrollView))
    self.mGird_ItemGrid=mTran:Find("Content/ScrollPanel/Con_Detail/Grid"):GetComponent(typeof(UIGrid))
    self.mObj_ItemTemplate=mTran:Find("Content/ScrollPanel/Item").gameObject
    self.mObj_ItemTemplate:SetActive(false)
    self.mList_ItemList={}
    self.mobj_BackButton = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.mobj_BackButton).onClick = function() self:HideView() end

    local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
end

function BonusNoteView:AddEvent( )

end

function BonusNoteView:RemoveEvent( )

end

function BonusNoteView:SetViewData(data)

    self.mScrollView_ScrollPanel:ResetPosition()
    if data.data~=nil then
        for i = 1, #data.data do
            local item=self.mList_ItemList[i]
            if item==nil then
                local go=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGird_ItemGrid.transform)
                item=BonusNoteItem.New(go)
                self.mList_ItemList[i]=item
            end
            item:SetItemData(data.data[i])
            item:ShowItem()
        end
    end
    self.mGird_ItemGrid:Reposition()
    
   
    
end


function BonusNoteView:HideAllItem( )
    for i = 1,#self.mList_ItemList do
        local item=self.mList_ItemList[i]
        item:HideItem()
    end
end


function BonusNoteView:ShowView( )
    self.obj:SetActive(true)
    self:HideAllItem()
    HallPromotionModel.GetInstance():ReqBonusNoteData(function (data)
        if self then
            self:SetViewData(data)
        end
    end)
    self.mTweenPlayer:ParallelPlay(false)
end



function BonusNoteView:HideView( )
    self.obj:SetActive(false)
end

function BonusNoteView:SetPanelDepth(depth)
    self.mPanel_ScrollPanel.depth=depth +5
    self.obj:GetComponent(typeof(UIPanel)).depth = depth 
end

function BonusNoteView:__delete(  )

end
