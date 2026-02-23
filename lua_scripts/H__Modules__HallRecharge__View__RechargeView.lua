RechargeView = BaseClass()

function RechargeView:__init(obj)
    self.obj = obj
    self:InitUI()
end

function RechargeView:InitUI()
    local mTran = self.obj.transform
    
    self.mLabel_UID = mTran:Find("Common/UserInfo/UID/Label").gameObject:GetComponent(typeof(UILabel))
    self.mButton_Copy =  mTran:Find("Common/UserInfo/UID/BtnCopy").gameObject
    UIEventListener.Get(self.mButton_Copy).onClick=function(go) self:OnButtonCopy(go) end
    self.mParent =  mTran:Find("Common/Btn_All/ScrollView/All")
    self.mGrid = self.mParent.gameObject:GetComponent(typeof(UIGrid))
    self.mScrollView = mTran:Find("Common/Btn_All/ScrollView").gameObject:GetComponent(typeof(UIScrollView))
    self.mItemObj =  mTran:Find("Common/Btn_All/ScrollView/All/Item").gameObject
    self.mPanel_Obj = mTran:Find("Common/Btn_All").gameObject
    self.mItemObj:SetActive(false)
    self.mLabel_Tips = mTran:Find("Common/Tips/tipsLabel").gameObject:GetComponent(typeof(UILabel))
    self.mGridList = {}
end

---复制用户id
function RechargeView:OnButtonCopy(go)
    SoundManager.GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    PhoneManager:MyClipDataToClipboard(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end


function RechargeView:InitItem(intdex)
    local item =GameObject.Instantiate(self.mItemObj,self.mParent)
    item.transform.localPosition=Vector3.zero
	item.transform.localScale=Vector3.one
    item.name = StringFormat("RechargePayGrid_{0}",intdex)
    return RechargeViewGrid.New(item)
end

---设置panel的深度
function RechargeView:SetViewDepth(depth)
    SetPanelstartingRenderQueue(self.mScrollView.gameObject,depth+1)
    SetPanelstartingRenderQueue(self.mPanel_Obj,depth+3)
end

function RechargeView:SetTipsLabel(TipsStr)
    if CheckServiceJsonDataIsNullOrEmpty(TipsStr) ~= nil then
        --self.mLabel_Tips.text = TipsStr
    end
end

function RechargeView:SetData(dataList)
    self.mLabel_UID.text = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    self.obj:SetActive(true)
    self:CleanGridList()
    local count = #dataList
    --local 
    for i = 1, count do
        local item = self.mGridList[i]
        if item == nil then
            item = self:InitItem(i)
            table.insert(self.mGridList, item)
        end
        item:SetData(dataList[i],i,function(i,payList,payType,IsAppStore)
            self:OnItemClick(i,payList,payType,IsAppStore)
        end)
    end
    self.mGrid:Reposition()
    self.mScrollView:ResetPosition()
    --ResetPosition
end

function RechargeView:OnItemClick(index,payList,payType,IsAppStore)
    local count = # self.mGridList
    for i = 1, count do
        self.mGridList[i]:SetSelect(i == index)
    end
    if StoreModuleModel:GetInstance().Payprompt ~= nil then
        self:SetTipsLabel(StoreModuleModel:GetInstance().Payprompt[tostring(payType)])
    end
    HallRechargeController.GetInstance().view.panel:OpenRMBInputView(payList,payType,IsAppStore)
end

function RechargeView:CleanGridList()
    local count = # self.mGridList
    for i = 1, count do
        self.mGridList[i]:SetDisplay(false)
    end
end




function RechargeView:__delete()
end