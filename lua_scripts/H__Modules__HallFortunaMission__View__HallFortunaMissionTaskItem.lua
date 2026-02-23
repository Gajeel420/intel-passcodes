HallFortunaMissionTaskItem = BaseClass()

function HallFortunaMissionTaskItem:__init(obj)
    self.obj= obj
    self:InitUI()
end

function HallFortunaMissionTaskItem:InitUI()
    local mTran = self.obj.transform
    local mTranUI = mTran:Find("HeadPortait/Texture_HeadPortait")
    if mTranUI ~= nil then
        self.mSprite_TaskIcon = mTranUI:GetComponent(typeof(UISprite))      --icon
    end

    mTranUI = mTran:Find("Label_Title")
    if mTranUI ~= nil then
        self.mLable_TaskTitle = mTranUI:GetComponent(typeof(UILabel))       --标题
    end

    mTranUI = mTran:Find("Label_Money/Label_Tips1")
    if mTranUI ~= nil then
        self.mLable_TaskBonus = mTranUI:GetComponent(typeof(UILabel))       --奖励金额
    end

    mTranUI = mTran:Find("Label_Desc")
    if mTranUI ~= nil then
        self.mLable_TaskDesc = mTranUI:GetComponent(typeof(UILabel))       --说明
    end

    mTranUI = mTran:Find("Button_Receive")
    if mTranUI ~= nil then
        self.mBtn_Receive = mTranUI.gameObject
        self.mSprite_Receive = mTranUI:GetComponent(typeof(UISprite))
        self.mBox_Receive = self.mBtn_Receive:GetComponent(typeof(BoxCollider))
        UIEventListener.Get(self.mBtn_Receive).onClick = function(go)self:OnReceiveBtnClick(go) end
    end

    mTranUI = mTran:Find("Button_Join")
    if mTranUI ~= nil then
        self.mBtn_Join = mTranUI.gameObject
        self.mBtn_Join:SetActive(false)
        UIEventListener.Get(self.mBtn_Join).onClick = function(go)self:OnJoinBtnClick(go) end
    end

    mTranUI = mTran:Find("Slider")
    if mTranUI ~= nil then
        self.mSlider_Progress = mTranUI:GetComponent(typeof(UISlider))       --领取
    end

    mTranUI = mTran:Find("Slider/Label")
    if mTranUI ~= nil then
        self.mLable_Progress = mTranUI:GetComponent(typeof(UILabel))       --领取
    end
end

---设置任务数据
function HallFortunaMissionTaskItem:SetTaskData(GeneralTypeId,data,index)
    self.mData = data
    self.mGeneralTypeId = GeneralTypeId
    index = index > 5 and 5 or index
    self.obj:SetActive(true)
    self.mSprite_TaskIcon.spriteName = StringFormat("Hall_icon_0{0}",index)
    self.mLable_TaskBonus.text = NumberFormat(HallGoldRateSToC(data.m_PrizeValue))
    self.mLable_TaskTitle.text = data.m_Title
    self.mLable_TaskDesc.text = data.m_szContent
    
    local mprogress = data.m_CurrentValue / data.m_ThresholdValue
    if GeneralTypeId >2 then
        self.mLable_Progress.text = StringFormat("{0}/{1}",NumberFormat(HallGoldRateSToC(data.m_CurrentValue)),NumberFormat(HallGoldRateSToC(data.m_ThresholdValue)))
    else
        self.mLable_Progress.text = StringFormat("{0}/{1}",data.m_CurrentValue,data.m_ThresholdValue)
    end
    self.mSlider_Progress.value = mprogress
    if data.m_DrawPrizeStatus < 2 then     -- 0 不可领取状态 1 可领取
        self.mSprite_Receive.spriteName = "Hall_BT_Receive"
        local colorValue = data.m_DrawPrizeStatus == 0 and 1 or 0
        local enabled = data.m_DrawPrizeStatus == 0
        self.mSprite_Receive.color = Color(colorValue,1,1)
        self.mBox_Receive.enabled = enabled
        if GeneralTypeId == 1 then
            if data.m_DrawPrizeStatus ==1 then
                self.mBtn_Join:SetActive(true)
                self.mBtn_Receive:SetActive(false)
            else
                self.mBtn_Join:SetActive(false)
                self.mBtn_Receive:SetActive(true)
            end
        else
            self.mBtn_Join:SetActive(false)
            self.mBtn_Receive:SetActive(true)
        end
    elseif  data.m_DrawPrizeStatus == 2 then        --已经领取过了
        self.mBtn_Join:SetActive(false)
        self.mBtn_Receive:SetActive(true)
        self.mSprite_Receive.spriteName = "Hall_BT_Already_Received"
        self.mBox_Receive.enabled = false
    end
end

function HallFortunaMissionTaskItem:OnReceiveBtnClick(go)
    HallFortunaMissionModel.GetInstance():AddEventListener(EventName.ClientDrawTaskPrizeResp,self.ClientDrawTaskPrizeResp,self)
    HallFortunaMissionModel.GetInstance():CClientDrawTaskPrizeReq(self.mGeneralTypeId,self.mData.m_Id) 
end


function HallFortunaMissionTaskItem:OnJoinBtnClick(go)
   UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPromotionCode)
end

function HallFortunaMissionTaskItem:ClientDrawTaskPrizeResp(data)
    
    if data.m_ucGeneralTypeId == self.mGeneralTypeId and data.TaskItem.m_Id == self.mData.m_Id then
        HallFortunaMissionModel.GetInstance():RemoveEventListener(EventName.ClientDrawTaskPrizeResp,self.ClientDrawTaskPrizeResp,self)
        self.mSprite_Receive.spriteName = "Hall_BT_Already_Received"
        self.mBox_Receive.enabled = false
    end
end

---回收任务
function HallFortunaMissionTaskItem:RecycleTaskItem()
    self.mData = nil
    self.obj:SetActive(false)
end

function HallFortunaMissionTaskItem:__delete()

end