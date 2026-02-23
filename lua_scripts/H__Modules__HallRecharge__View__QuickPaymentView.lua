QuickPaymentView = BaseClass()

function QuickPaymentView:__init(obj)
    self.obj = obj
    self.obj:SetActive(false)
    self:InitUI()
end

function QuickPaymentView:InitUI()
   
    self.ItemList = {}
    self.ItemSelectList = {}

    self.TypeID = 0

    self.mTitleList = {}

    local mTran = self.obj.transform
    self.mLabel_ID = mTran:Find("Common/UserInfo/UserID/Label").gameObject:GetComponent(typeof(UILabel))
    self.mLabel_ID.text ="0"
    
    self.mBtn_Submit = mTran:Find("Button_Immediately").gameObject

    self.mPanel_ScrollView = mTran:Find("ScrollView").gameObject:GetComponent(typeof(UIPanel))
    self.mScroll = self.mPanel_ScrollView:GetComponent(typeof(UIScrollView))
    self.mPrant = mTran:Find("ScrollView/Button")
    self.ItemObj = mTran:Find("ScrollView/Button/Item").gameObject
    self.ItemObj:SetActive(false)
   
    self.mObj_CopyID = mTran:Find("Common/UserInfo/UserID/BtnCopy").gameObject
    UIEventListener.Get(self.mObj_CopyID).onClick = function() 
		PhoneManager:MyClipDataToClipboard(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
		UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
    end
    
    self.mInput_money = mTran:Find("Input").gameObject:GetComponent(typeof(UIInput))
    self.mInput_money.value = ""
    self.mObj_Reset = mTran:Find("Button_Delect").gameObject
    UIEventListener.Get(self.mObj_Reset).onClick = function()
        SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick) 
        self.mInput_money.value = ""
        self.data = nil
        self:SetSelectBg(0)
    end


    UIEventListener.Get(self.mBtn_Submit).onClick = function(obj) 
        self:OnButtonSubmit(obj)
    end

    

    self.mLable_Tips = mTran:Find("Common/Tips/tipsLabel"):GetComponent(typeof(UILabel))

    self.mObj_Title = mTran:Find("Common/TitleScrollView").gameObject
    self.mScrollView_Title = self.mObj_Title:GetComponent(typeof(UIScrollView))

    self.mTran_TitleParent = mTran:Find("Common/TitleScrollView/Grid")
    self.mGrid_Title = self.mTran_TitleParent:GetComponent(typeof(UIGrid))

    self.mObj_TitleItem = mTran:Find("Common/TitleScrollView/Grid/TitleItem").gameObject
    self.mObj_TitleItem:SetActive(false)

end


function QuickPaymentView:OnButtonSubmit(obj)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if self.data ~= nil then
        UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTransferInformation,function(panel)
            panel:SetRechargeMoney(self.data,self.TypeID)
        end)
    else
        UIManager.GetInstance():ShowNoteMessage("请输入充值金额")
    end
end

function QuickPaymentView:SetTipsLabel(TipsStr)
    if CheckServiceJsonDataIsNullOrEmpty(TipsStr) ~= nil then
        --self.mLable_Tips.text = TipsStr
    else
        --self.mLable_Tips.text ="温馨提示"
    end
end


function QuickPaymentView:SetData(dataList)
    
    for i = 1, #self.ItemList do
        self.ItemList[i]:SetActive(false)
        self.ItemSelectList[i]:SetActive(false)
	end
	
	local index=0
	if not dataList == nil or dataList=="1" or not next(dataList) then 
		return 
	end

	for i,itemVo in ipairs(dataList) do
		index=index+1
		if self.ItemList[index]==nil then
			local item=GameObject.Instantiate(self.ItemObj,self.mPrant)
            self.ItemList[index]=item
            local selectBg = item.transform:Find("BackSelect").gameObject
            selectBg:SetActive(false)
            self.ItemSelectList[index] = selectBg
		end
		local item=self.ItemList[index]
		item.name=tostring(itemVo.money)
		item.transform:Find("Label"):GetComponent(typeof(UILabel)).text=StringFormat("{0}",tostring(itemVo.money)) 
		UIEventListener.Get(item).onClick=function(buttonObj) self:OnitemClick(itemVo,i) end
		item:SetActive(true)
	end
    self.mPrant.gameObject:GetComponent(typeof(UIGrid)):Reposition()
    
    StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.mScroll:ResetPosition()
	end)
end


function QuickPaymentView:OnitemClick(data,index)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self.data = data
    self.mInput_money.value = data.money
    self:SetSelectBg(index)
end

function QuickPaymentView:SetSelectBg(index)
    for i = 1, #self.ItemSelectList do
        self.ItemSelectList[i]:SetActive(i == index)
    end
    
end


function QuickPaymentView:SetDepth(depth)
    self.mPanel_ScrollView.depth = depth + 1
    SetPanelstartingRenderQueue(self.mObj_Title,depth+2)
end


function QuickPaymentView:ShowView(dataList)
    self.mLabel_ID.text = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    self.obj:SetActive(true)
    self:CreateTitle(dataList)
end

function QuickPaymentView:CreateTitle(dataList)
    local count = #dataList
    for i = 1, count do
        if self.mTitleList[i]  == nil then
            local go = InstantiateNewGameObject(self.mObj_TitleItem,self.mTran_TitleParent,i)
            self.mTitleList[i] = QuickPaymentTitleItem.New(go)
        end
        self.mTitleList[i]:SetItemData(dataList[i],i,self.OnTitleItemClick,self)
    end
    self.mGrid_Title:Reposition()
    StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mScrollView_Title:ResetPosition()
    end)
end

function QuickPaymentView:OnTitleItemClick(index,data)
    local count = #self.mTitleList
    for i = 1, count do
        self.mTitleList[i]:SetITemSelect(index)
    end
    self.TypeID = data.TypeID
   
    if StoreModuleModel:GetInstance().Payprompt ~= nil then
        self:SetTipsLabel(StoreModuleModel:GetInstance().Payprompt[tostring(data.TypeID)])
    end

    self:SetData(data.denomination)
    
end

function QuickPaymentView:HideView()
    self.obj:SetActive(false)
end

function QuickPaymentView:__delete()

end