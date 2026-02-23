UISendRecordItem=UISendRecordItem or BaseClass()
function UISendRecordItem:__init( obj )
	self.obj=obj
	self.data=nil
	self:InitUI()
end

function UISendRecordItem:InitUI()
	local tranRoot=self.obj.transform
	self.mLabel_Time=tranRoot:Find("Time/Label"):GetComponent(typeof(UILabel))
	self.mLabel_Gold=tranRoot:Find("Number/Label"):GetComponent(typeof(UILabel))
	self.mLabel_Name=tranRoot:Find("ID/Label_Day"):GetComponent(typeof(UILabel))
	--self.mLabel_ID=tranRoot:Find("Player/Label_ID"):GetComponent(typeof(UILabel))
	self.mObj_CancellationButton=tranRoot:Find("Button_Recall").gameObject
	UIEventListener.Get(self.mObj_CancellationButton).onClick=function() self:OnClickCancellationButton() end
	self.mObj_CancellationButton:SetActive(false)

	self.mSprite_State=tranRoot:Find("Situation/Label"):GetComponent(typeof(Localize))
	-- self.mObj_State=tranRoot:Find("State").gameObject
	-- self.mObj_State:SetActive(false)

end

function UISendRecordItem:SetData(data)
	self.data=data
	self.mLabel_Time.text=TimeStampToTime(data.m_unTime)
	SetNumberLabel(self.mLabel_Gold,data.m_un64Count) 
	self.mLabel_Name.text= CommonUtil.LuaTableToStringNoEmpty(data.m_szNickName)..string.format("(%d)",data.m_unUIN)


	local vip=PlayerInfoController:GetInstance().model.mainPlayer.iVipLevel
	local state=tonumber(data.m_ucSucceed)
	if state==0  then
		self.mObj_CancellationButton:SetActive(false)
		self.mSprite_State.gameObject:SetActive(true)
		self.mSprite_State:SetTerm(HallBankConst.ResutltList[1])
		--self.mSprite_State.text=HallBankConst.ResutltList[1]
	elseif state==1	then
		if data.m_ucType==HallBankModel.RecordType.Give then
			if  vip<ConfigModuleController.GetInstance().model.WithdrawalLevel   then
				self.mObj_CancellationButton:SetActive(false)
				self.mSprite_State.gameObject:SetActive(true)
				self.mSprite_State:SetTerm(HallBankConst.ResutltList[2])
			else
				self.mObj_CancellationButton:SetActive(true)
				--self.mObj_State:SetActive(false)
			end
		else
			self.mObj_CancellationButton:SetActive(false)
			self.mSprite_State.gameObject:SetActive(true)
			self.mSprite_State:SetTerm(HallBankConst.ResutltList[3])
		end

	elseif state==2	then
		self.mObj_CancellationButton:SetActive(false)
		self.mSprite_State.gameObject:SetActive(true)
		self.mSprite_State:SetTerm(HallBankConst.ResutltList[4])
	end
end



function UISendRecordItem:OnClickCancellationButton()
	if self.data and self.data.m_unID then

		HallBankModel.GetInstance():AddEventListener(HallBankModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
		HallBankModel.GetInstance():ReqCancellationOfTransfer(self.data.m_unID)
	end

end

function UISendRecordItem:UpdateData(data)
	if data.Record.m_unID~=self.data.m_unID or data.Record.m_ucSucceed==nil then
		return
	end
	HallBankModel.GetInstance():RemoveEventListener(HallBankModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
	local state=tonumber(data.Record.m_ucSucceed)
	if state==2 then
		self.mObj_CancellationButton:SetActive(false)
		self.mSprite_State.gameObject:SetActive(true)
		
		self.mSprite_State:SetTerm(HallBankConst.ResutltList[4])
	end
	
end





function UISendRecordItem:SetActive(isActive)
	if isActive==false then
		HallBankModel.GetInstance():RemoveEventListener(HallBankModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
	end
	self.obj:SetActive(isActive)
end

function UISendRecordItem:__delete( ... )
	HallBankModel.GetInstance():RemoveEventListener(HallBankModel.EventType.CancellationOfTransferReturn,self.UpdateData,self)
end