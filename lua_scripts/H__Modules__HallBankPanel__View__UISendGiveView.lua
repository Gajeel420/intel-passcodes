UISendGiveView=UISendGiveView or BaseClass()

function UISendGiveView:__init( obj )
	
	self.obj=obj
	self:InitUI()
end

function UISendGiveView:InitUI()
	--new 
	local mTran = self.obj.transform

	self.mObj_CheckIDButton=mTran:Find("Button_Check").gameObject
	self.mInput_GiveGold=mTran:Find("InputMoney/Input"):GetComponent(typeof(UIInput))

	self.mInput_AddresseeID=mTran:Find("InputID/Input"):GetComponent(typeof(UIInput))
	
	self.mBtn_Clean=mTran:Find("Button_Clear").gameObject
	self.mObj_GiveButton=mTran:Find("Button_Confirm").gameObject
	self:InitGoodsGrid()

	UIEventListener.Get(self.mBtn_Clean).onClick=function() self:OnClickCleanButton() end
	UIEventListener.Get(self.mObj_CheckIDButton).onClick=function() self:OnClickCheckIDButton() end
	UIEventListener.Get(self.mObj_GiveButton).onClick=function() self:OnClickGiveButton() end
	
end

function UISendGiveView:InitGoodsGrid()
	local mTran = self.obj.transform
	local goodList=ConfigModuleModel.GetInstance().GiveList
	for i = 1, 6 do
		
		local itemTransform=mTran:Find("ScrollView/Grid/Button_Num_"..i).gameObject
		if goodList[i] then
			
			itemTransform:SetActive(true)
			local gold=goodList[i]
			local C_Gold= HallGoldRateSToC(tonumber(gold))
			print("tttttttttttttttttttttttt  ",C_Gold)
			
			itemTransform.transform:Find("Value"):GetComponent(typeof(UILabel)).text=NumberFormat(tonumber(C_Gold))
			
			UIEventListener.Get(itemTransform.gameObject).onClick=function() self:OnClickGoodsButton(C_Gold) end

		else
			itemTransform:SetActive(false)
		end
	end
end

function UISendGiveView:OnClickGoodsButton(gold)
	local currentGoldString=self.mInput_GiveGold.value or "0"
	local currentGoldNum=tonumber(currentGoldString) or 0
	local newGoldNum=currentGoldNum+tonumber(gold)
	self.mInput_GiveGold.value=tostring(newGoldNum)
end

function UISendGiveView:OnClickCleanButton( ... )
	-- body
	self.mInput_GiveGold.value = 0
end

function UISendGiveView:OnClickCheckIDButton()
	local idString=self.mInput_AddresseeID.value or ""
	if idString=="" then
		UIManager:GetInstance():ShowNoteMessage("用户ID不能为空！")
		return
	end
	local id=TrimStr(idString)
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckIDSuccess,self)
	UIManager:GetInstance():ShowNetWorkMessage("Hall_Querying","Hall_failed",3)
	FriendModuleController:GetInstance():ReqSearchFriend(0,(id),1,1)
end


function UISendGiveView:OnClickGiveButton()
	local idString=self.mInput_AddresseeID.value or ""
	if idString=="" then
		UIManager:GetInstance():ShowNoteMessage("用户ID不能为空！")
		return
	end
 

	local id=TrimStr(idString)
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckGiveSuccess,self)
	UIManager:GetInstance():ShowNetWorkMessage("Hall_Querying","Hall_failed",3)
	FriendModuleController:GetInstance():ReqSearchFriend(0,(id),1,1)

end

function UISendGiveView:OnClickGiveButton()
	local idString=self.mInput_AddresseeID.value or ""
	if idString=="" then
		UIManager:GetInstance():ShowNoteMessage("用户ID不能为空！")
		return
	end
 

	local id=TrimStr(idString)
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckGiveSuccess,self)
	UIManager:GetInstance():ShowNetWorkMessage("Hall_Querying","Hall_failed",3)
	FriendModuleController:GetInstance():ReqSearchFriend(0,(id),1,1)

end

function UISendGiveView:OnCheckIDSuccess(context)
	if context==nil then
		UIManager:GetInstance():ShowNoteMessage("用户不存在！")
		return
	end
	UDebug.Log("检测ID成功")
	--移除监听
	FriendModuleModel:GetInstance():RemoveEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckIDSuccess,self)

	local showBoxData ={}
    showBoxData.title = "用户ID存在"
    if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
        showBoxData.context ="用户昵称：".. context.m_szNickName
    else
       showBoxData.context ="The user nickname：".. context.m_szNickName
    end
    
    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮; 
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function UISendGiveView:OnCheckGiveSuccess(context)
	if context==nil then
		UIManager:GetInstance():ShowNoteMessage("用户不存在！")
		return
	end
	--移除监听
	FriendModuleModel:GetInstance():RemoveEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckGiveSuccess,self)
	local goldString=self.mInput_GiveGold.value or ""
	local goldNum=tonumber(goldString) or 0
	if goldString=="" or goldNum==0 then
		UIManager:GetInstance():ShowNoteMessage("Hall_amount0")
		return
	end
	if goldNum>HallGoldRateCToS(tonumber(PlayerInfoController:GetInstance().model.mainPlayer.iMoney)) then
		UIManager:GetInstance():ShowNoteMessage("余额不足！")
		return
	end


	local showBoxData ={}
    showBoxData.title = "确认赠送"
    if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
         showBoxData.context = StringFormat("是否给{0}\n赠送：{1} 游戏币",context.m_szNickName, NumberFormat(tonumber(goldString)))
    else
          showBoxData.context = StringFormat("Whether to give {0} game currency \n to {1}", NumberFormat(tonumber(goldString)),context.m_szNickName)--StringFormat("是否给{0}\n赠送：{1} 游戏币",context.m_szNickName, NumberFormat(tonumber(goldString)))
    end
   
    showBoxData.enterCB = function() 
		self:GiveGold(context.m_unUIN,goldNum)
    end--：点击确定返回；

    
		showBoxData.isHideAll = false--:隐藏所有按钮; 
		showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function UISendGiveView:GiveGold(id,gold)
	--[
	local cb=function ()
		local send={}
		send.m_unSize=0
		send.m_unID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
		send.m_unDstUin = id
		send.m_sAccountType=2
		send.m_sTransferReason=8
		send.m_unActionID=os.time()+math.random(0,1000)
		send.m_un64Count= HallGoldRateCToS(tonumber(gold))
		send.m_iTime=os.time()
		local md5=CommonUtil.GenNewMd5SDyPasswd(CommonUtil.ReturnBankPsd(PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord), send.m_iTime, CommonUtil.mstate)
		send.m_szPassword=CommonUtil.StringToByteArrayTable(md5)
		--补齐
		for i=1,32 do
			if send.m_szPassword[i]==nil then
				send.m_szPassword[i]=0
			end
		end
		HallBankController.GetInstance().model.CurrentGiveMoney = send.m_un64Count
		print("1111111111111111发起赠送")
		Net_SendHallData(NetworkDefine.ReqTransferAccounts, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_TRANSFER_MONEY, 18)


	end

	UIManager.GetInstance():CheckHallBankPassword(cb)
	
end



function UISendGiveView:ShowOrHide(isdis)
	self.obj.gameObject:SetActive(isdis)
	if not isdis then
		self.mInput_GiveGold.value = 0
		self.mInput_AddresseeID.value = 0
	end
end

function UISendGiveView:clear( ... )
	self.mInput_GiveGold.value = 0
		self.mInput_AddresseeID.value = 0
end




