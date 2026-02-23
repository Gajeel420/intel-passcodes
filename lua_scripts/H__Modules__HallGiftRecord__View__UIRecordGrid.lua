UIRecordGrid =  BaseClass()

function UIRecordGrid:__init(obj)
    self.obj = obj
    self:InitUI()
end

function UIRecordGrid:InitUI()

    local mTran = self.obj.transform
    self.obj:SetActive(false)

    self.mLabelDay = mTran:Find("Label_Time").gameObject:GetComponent(typeof(UILabel))
    self.mLabelMoney = mTran:Find("Label_Money").gameObject:GetComponent(typeof(UILabel))
    self.mLabelNickNale = mTran:Find("Label_NickName").gameObject:GetComponent(typeof(UILabel))
    self.mSpriteState = mTran:Find("Sprite_State").gameObject:GetComponent(typeof(UISprite))

    self.mBtnWithdraw = mTran:Find("Btn_Withdraw").gameObject

    UIEventListener.Get(self.mBtnWithdraw).onClick = function(obj) self:OnButtonClick(obj) end
    
end


function UIRecordGrid:OnButtonClick(obj)
    if self.data and self.data.m_unID then
        HallGiftRecordController.GetInstance().model:AddEventListener(HallGiftRecordModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
        HallGiftRecordController.GetInstance().model:ReqCancellationOfTransfer(self.data.m_unID)
    end
end

----更新撤销信息
function UIRecordGrid:UpdateData(data)
	if data.Record.m_unID~=self.data.m_unID or data.Record.m_ucSucceed==nil then
		return
	end
	HallGiftRecordController.GetInstance().model:RemoveEventListener(HallGiftRecordModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
	local state=tonumber(data.Record.m_ucSucceed)
	if state==2 then
		self.mBtnWithdraw:SetActive(false)
		self.mSpriteState.gameObject:SetActive(true)
		self.mSprite_State.spriteName=HallGiftRecordModel.ResutltList[4]
	end
	
end

function UIRecordGrid:SetData(data)
    self.data = data
    self.mLabelDay.text = TimeStampToTime(data.m_unTime)
    SetNumberLabel(self.mLabelMoney,data.m_un64Count)
    self.mLabelNickNale.text= CommonUtil.LuaTableToStringNoEmpty(data.m_szNickName)

    local vip=PlayerInfoController:GetInstance().model.mainPlayer.iVipLevel
    local state=tonumber(data.m_ucSucceed)

    if state == 0 then
        self.mBtnWithdraw:SetActive(false)
        self.mSpriteState.gameObject:SetActive(true)
        self.mSpriteState.spriteName = HallGiftRecordModel.ResultList[1]
    elseif state == 1 then
        if data.m_ucType == HallGiftRecordModel.RecordType.Give then
            if vip <= ConfigModuleController.GetInstance().model.WithdrawalLevel then
                self.mBtnWithdraw:SetActive(false)
                self.mSpriteState.gameObject:SetActive(true)
                self.mSpriteState.spriteName =  HallGiftRecordModel.ResultList[2]
            else
                self.mBtnWithdraw:SetActive(true)
                self.mSpriteState.gameObject:SetActive(false)
            end
        else
            self.mBtnWithdraw:SetActive(false)
            self.mSpriteState.gameObject:SetActive(true)
            self.mSpriteState.spriteName = HallGiftRecordModel.ResultList[3]
        end
    elseif state == 2 then
        self.mBtnWithdraw:SetActive(false)
        self.mSpriteState.gameObject:SetActive(true)
        self.mSpriteState.spriteName = HallGiftRecordModel.ResultList[4]
    end  
end

function UIRecordGrid:SetGridDisplay(display)
    self.obj:SetActive(display)
end



function UIRecordGrid:__delete()
end