TeamManagementView = TeamManagementView or BaseClass()

function TeamManagementView:__init( obj )
    self.obj=obj
    self:Init()
end

function TeamManagementView:Init( )
    local mTran = self.obj.transform

    self.mPanel_ScrollPanel=mTran:Find("ScrollPanel/Con_Detail"):GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel:ResetAndUpdateAnchors()
    self.mScrollView_ScrollPanel=mTran:Find("ScrollPanel/Con_Detail"):GetComponent(typeof(UIScrollView))
    self.mGird_ItemGrid=mTran:Find("ScrollPanel/Con_Detail/Grid"):GetComponent(typeof(UIGrid))
    self.mObj_ItemTemplate=mTran:Find("ScrollPanel/Item").gameObject
    self.mObj_ItemTemplate:SetActive(false)
    self.mList_ItemList={}
    self.mInput_ID=mTran:Find("Label/ShouSuo/Input"):GetComponent(typeof(UIInput))
    self.mObj_QueryButton=mTran:Find("Label/ShouSuo/Button_ShouSuo").gameObject
    UIEventListener.Get(self.mObj_QueryButton).onClick = function() self:OnClickQueryButton() end
    self.mObj_ButtonReset=mTran:Find("Label/ShouSuo/Button_Del").gameObject
    UIEventListener.Get(self.mObj_ButtonReset).onClick = function() self.mInput_ID.value="" end

    self.mLabel_TDRS = mTran:Find("Label/Label_ZSRS").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_ZHRS = mTran:Find("Label/Label_ZSDL").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_JRYJ = mTran:Find("Label/Label_JRZLS").gameObject:GetComponent(typeof(UILabel))

end

function TeamManagementView:AddEvent( )

end

function TeamManagementView:RemoveEvent( )

end


function TeamManagementView:OnClickQueryButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    local queryIdString=self.mInput_ID.value
    if queryIdString==nil or queryIdString=="" then
        UIManager:GetInstance():ShowNoteMessage("请输入玩家ID！")
        return
    end

    self:HideAllItem()
    self.mScrollView_ScrollPanel:ResetPosition()
    for i = 1, #self.mList_ItemList do
        local item=self.mList_ItemList[i]
        local id=item:GetId()
        if id then
            if tonumber(id)==tonumber(queryIdString) then
                item:ShowItem()
                self.mGird_ItemGrid:Reposition()
                
                return
            end
        end
    end
end






function TeamManagementView:SetViewData(data)
    self.mScrollView_ScrollPanel:ResetPosition()
    if data.data~=nil then
        for i = 1, #data.data do
            local item=self.mList_ItemList[i]
            if item==nil then
                local go=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGird_ItemGrid.transform)
                item=TeamManagementItem.New(go)
                self.mList_ItemList[i]=item
            end
            item:SetItemData(data.data[i])
            item:ShowItem()
        end
    end
    self.mLabel_JRYJ.text = NumberFormat(HallGoldRateSToC(data.teamwater))
    self.mLabel_TDRS.text = data.teamnum
    self.mLabel_ZHRS.text = data.selfnum
    self.mGird_ItemGrid:Reposition()
    
end


function TeamManagementView:HideAllItem( )
    for i = 1,#self.mList_ItemList do
        local item=self.mList_ItemList[i]
        item:HideItem()
    end
end


function TeamManagementView:ShowView( )
    self.obj:SetActive(true)
    self:HideAllItem()
    HallPromotionModel.GetInstance():ReqTeamData(function (data)
        if self then
            self:SetViewData(data)
        end
    end)
end



function TeamManagementView:HideView( )
    self.obj:SetActive(false)
end

function TeamManagementView:SetPanelDepth(depth)
    self.mPanel_ScrollPanel.depth=depth
end

function TeamManagementView:__delete(  )

end
