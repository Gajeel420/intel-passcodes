
CashWithdrawalView = CashWithdrawalView or BaseClass()

function CashWithdrawalView:__init( obj )
    self.obj=obj
    self.mData=nil
    self:Init()
end

function CashWithdrawalView:Init( )
    local mTran = self.obj.transform
    self:HideView()
    self.mPanel_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIPanel))
    self.mPanel_ScrollPanel:ResetAndUpdateAnchors()
    self.mScrollView_ScrollPanel=mTran:Find("Content/ScrollPanel/Con_Detail"):GetComponent(typeof(UIScrollView))
    self.mGird_ItemGrid=mTran:Find("Content/ScrollPanel/Con_Detail/Grid"):GetComponent(typeof(UIGrid))
    self.mObj_ItemTemplate=mTran:Find("Content/ScrollPanel/Item").gameObject
    self.mObj_ItemTemplate:SetActive(false)
    self.mList_ItemList={}

    self.mObj_CloseButton = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.mObj_CloseButton).onClick = function() self:HideView() end

    local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
end

function CashWithdrawalView:AddEvent( )

end

function CashWithdrawalView:RemoveEvent( )

end




function CashWithdrawalView:OnClickWithdrawalButton(money)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
   
    
    if money==nil or money=="" or money=="0" or tonumber(money)==0 then
        UIManager:GetInstance():ShowNoteMessage("余额不足！")
        return
    end
    

    HallPromotionModel.GetInstance():ReqSpreadModel(function (data)
     
        if data.Model==HallPromotionModel.SpreadType.Money then
  
            HallExchangeModel.GetInstance():GetBindingAccount(function (data)
                local zhiFuBaoAccount=nil
                local zhiFuBaoRelName=nil
                local bankAccount=nil
                local bankRelName=nil

                if data.ZhiFuBaoAccount==nil or data.ZhiFuBaoAccount=="" or type(data.ZhiFuBaoAccount)=="function" then
                    zhiFuBaoAccount=nil
                    zhiFuBaoRelName=nil
                else
                    zhiFuBaoAccount=data.ZhiFuBaoAccount
                    zhiFuBaoRelName=data.ZhiFuBaoRelName
                end
                
                if data.BankAccount==nil or data.BankAccount=="" or type(data.BankAccount)=="function" then
                    bankAccount=nil
                    bankRelName=nil
                else
                    bankAccount=data.BankAccount
                    bankRelName=data.BankRelName
                end


                if zhiFuBaoAccount==nil and bankAccount==nil then
                    local sucBindFunc=function (data)
                        UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchangeBind)
                        zhiFuBaoAccount = data.card
                        zhiFuBaoRelName = data.name
                        HallPromotionModel:ReqCashWithdrawal(money,zhiFuBaoAccount,zhiFuBaoRelName,bankAccount,bankRelName,function ()
                            UIManager:GetInstance():ShowNoteMessage("提交成功！")
                            self:RefreshView()
                        end)
                    end
                    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchangeBind,function (panel)
                        panel:OpenBindZhiFuBaoView(sucBindFunc)
                    end)
                else
                    HallPromotionModel:ReqCashWithdrawal(money,zhiFuBaoAccount,zhiFuBaoRelName,bankAccount,bankRelName,function ()
                        UIManager:GetInstance():ShowNoteMessage("提交成功！")
                        self:RefreshView()
                    end)
                end
            end)

        elseif data.Model==HallPromotionModel.SpreadType.Gold then
            HallPromotionModel:ReqCashWithdrawal(money,nil,nil,nil,nil,function ()
                UIManager:GetInstance():ShowNoteMessage("提交成功！")
                self:RefreshView()
            end)
        end
        
    end)




end





function CashWithdrawalView:SetViewData(data)
    
    self.mData=data
    self.mScrollView_ScrollPanel:ResetPosition()
    if data.data~=nil then
        for i = 1, #data.data do
            local item=self.mList_ItemList[i]
            if item==nil then
                local go=GameObject.Instantiate(self.mObj_ItemTemplate,self.mGird_ItemGrid.transform)
                item=CashWithdrawalItem.New(go)
                self.mList_ItemList[i]=item
            end
            item:SetItemData(data.data[i])
            item:ShowItem()
        end
    end

    self.mGird_ItemGrid:Reposition()
    
end


function CashWithdrawalView:HideAllItem( )
    for i = 1,#self.mList_ItemList do
        local item=self.mList_ItemList[i]
        item:HideItem()
    end
end


function CashWithdrawalView:ShowView( )
    self.obj:SetActive(true)
    self:RefreshView()
    self.mTweenPlayer:ParallelPlay(false)
end

function CashWithdrawalView:RefreshView()
    self.mData=nil
    self:HideAllItem()
    HallPromotionModel.GetInstance():ReqCashWithdrawalData(function (data)
        if self then
            self:SetViewData(data)
        end
    end)
end


function CashWithdrawalView:HideView( )
    self.obj:SetActive(false)
end

function CashWithdrawalView:SetPanelDepth(depth)
    self.obj:GetComponent(typeof(UIPanel)).depth = depth
    self.mPanel_ScrollPanel.depth=depth+5
end

function CashWithdrawalView:__delete(  )

end
