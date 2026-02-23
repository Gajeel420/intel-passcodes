HallBankController = HallBankController or BaseClass(LuaController)

require"H/Modules/HallBankPanel/HallBankView"
require"H/Modules/HallBankPanel/View/BankPanel"
require"H/Modules/HallBankPanel/View/UISendGiveView"
require"H/Modules/HallBankPanel/HallBankModel"
require"H/Modules/HallBankPanel/HallBankConst"
require"H/Modules/HallGive/Msg/CRspGiveRecordMsg"
require"H/Modules/HallBankPanel/View/UISendRecordItem"
require"H/Modules/HallBankPanel/View/UISendRecordView"
require"H/Modules/HallBankPanel/View/SendGiveSuccess"

function HallBankController:__init( ... )
	self.view = HallBankView.New()
	self.model = HallBankModel:GetInstance()
	self:RegistProto()
	self:AddEvent()
end


--监听协议结果返回
function HallBankController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_SAVE_MONEY,"ReqGetMoneyToBank")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_GET_MONEY,"HandleUserGetMoneyBack")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CHANGE_PASSWORD,"HandlerUserChangePassword")

	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_TRANSFER_MONEY,"RespGiveGold")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD,"RspRequestRecordData")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,"RspRequestSummaryData")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE,"RspCancellationOfTransfer")
end


function HallBankController:ReqGetMoneyToBank(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRspSaveMoneyToBankMsgPara, buffer)
	if self.view then
		self.view.panel:ReqGetMoneyToBank(msg)
	end
end


function HallBankController:HandleUserGetMoneyBack( buffer )
	local msg = self:ParseMsg(NetworkDefine.CRspGetMoneyToBankMsgPara, buffer)
	if self.view then
		self.view.panel:HandleUserGetMoneyBack(msg)
	end
end


function HallBankController:HandlerUserChangePassword(buffer)--包含了设置密码
	local msg = self:ParseMsg(NetworkDefine.CRspSetPasswordMsgPara, buffer)
	if msg.m_sResult==0 then
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		if not PlayerInfoController:GetInstance().model.mainPlayer.isSetPasswordFlag then
			HallBankSetPasswordController:GetInstance():UserChangeBankPassword()	
		else
			if self.view and self.view.panel then
				self.view.panel:HandlerUserChangePassword(msg)
			end
		end
	else
		ServerBackPrompt(msg.m_sResult);
	end
end


--事件监听
function HallBankController:AddEvent( )
	LuaEvent:AddEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
	LuaEvent:AddEventListener(EventName.CSTOLUAOPENBANK,self.CSOpenLuaBank,self)
end

function HallBankController:RemoveEvent( )
	LuaEvent:RemoveEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
	LuaEvent:RemoveEventListener(EventName.CSTOLUAOPENBANK,self.CSOpenLuaBank,self)
end

function HallBankController:RefreshPanelData( )
	if self.view and self.view.pane then
		self.view.panel:SetPanelUserData()
	end
end


function HallBankController:CSOpenLuaBank()
	UIManager:GetInstance():OpenHallBankPanel()
end


function HallBankController:SelectShowThePanel(showstate)
	if self.view and self.view.panel then
		self.view.panel:SelectShowThePanel(showstate)
	end
end


function HallBankController:GetInstance()
	if HallBankController.instance == nil then
		HallBankController.instance = HallBankController.New()
	end
	return HallBankController.instance
end

-------------------------
function HallBankController:RespGiveGold(buffer)
	print("222222222222222222赠送返回")
	self.view.panel:clear()
	if buffer==nil then
		UDebug.Log("buffer==nil")
		return
	end

	local msg=self:ParseMsg(NetworkDefine.RspTransferAccounts,buffer)
	pt(msg)
	if msg.m_sResult==nil then
		UDebug.Log("msg.m_sResult==nil")
	end
	
	if msg.m_sResult==0 then
		self.view.panel.GiveSuccessView:ShowView(msg)
		UIManager:GetInstance():ShowNoteMessage("Hall_Give")
		PlayerInfoController:GetInstance():RequestGetUserMoney()
	else
		--UIManager:GetInstance():ShowNoteMessage("赠送失败！")
		ServerBackPrompt(msg.m_sResult);
	end
end


--查询转账记录返回
function HallBankController:RspRequestRecordData(buffer)
	if buffer==nil then
		UDebug.Log("buffer==nil")
		return
	end

	local msg=self:ParseMsg(NetworkDefine.RspQueryTransferRecord,buffer)
	if msg.m_sResultId==nil then
		UDebug.Log("msg.m_sResult==nil")
		return
	end
	if msg.m_sResultId==0 then

		self.model:UpdateRecordData(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end


--查询转账汇总返回
function HallBankController:RspRequestSummaryData(buffer)
	if buffer==nil then
		UDebug.Log("buffer==nil")
		return
	end

	local msg=self:ParseMsg(NetworkDefine.RspQueryTransferSummary,buffer)
	if msg.m_sResultId==nil then
		UDebug.Log("msg.m_sResult==nil")
		return
	end
	if msg.m_sResultId==0 then

		self.model:UpdateSummaryData(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end

--请求撤销转账返回
function HallBankController:RspCancellationOfTransfer(buffer)
	if buffer==nil then
		UDebug.Log("buffer==nil")
		return
	end

	local msg=self:ParseMsg(NetworkDefine.RspCancellationOfTransfer,buffer)
	if msg.m_sResultId==nil then
		UDebug.Log("msg.m_sResult==nil")
		return
	end
	if msg.m_sResultId==0 then

		self.model:RspCancellationOfTransfer(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end


function HallBankController:QueryShopItemListCallBack(context)
	if not context then return end
	local itemList=context
	self.model.itemList={}
	for _,itemVo in pairs(itemList) do
		table.insert(self.model.itemList,itemVo)
	end
	TableTool.SortTableByKey(self.model.itemList,"iItemID",true)
	self.model:DispatchEvent(HallGiveConst.EventName_QueryShopItemListCallBack)
end

function HallBankController:QueryPackageItemListCallBack( context )
	if not context then return end
	local itemList=context
	self.model.packageItemList={}
	for _,itemVo in pairs(itemList) do
		if itemVo.iCount > 0 then 
			table.insert(self.model.packageItemList,itemVo)
		end
	end
	TableTool.SortTableByKey(self.model.packageItemList,"iItemID",true)
	self.model:DispatchEvent(HallGiveConst.EventName_QueryPackageItemListCallBack)
end

--查询赠送记录
function HallBankController:ReqQueryGiveRecordData()
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
   	Net_SendHallData(NetworkDefine.DataRequestGiveJiLuData,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_USER_QUERY_DONATE_PROP_RECORD_PINPAI,16)
end

function HallBankController:RecordHandle(buffer)
	local msg=CRspGiveRecordMsg.Decode(buffer)
	self.model.recordItemList=msg.itemList
	TableTool.SortTableByKey(self.model.recordItemList,"iTime")
	self.model:DispatchEvent(HallGiveConst.EventName_ReqGiveRecordCallBack,self.model.recordItemList)
end

----请求撤回礼物
function HallBankController:RequeryWithdrawGift( current_unID )
	-- body
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unID = current_unID
	Net_SendHallData(NetworkDefine.WithdrawGift,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_USER_REVOKE_DONATE_PROP,15)
end


function HallBankController:RespWithdrawGift( buffer )
	-- body
	local msg=self:ParseMsg(NetworkDefine.WithdrawGiftResult,buffer)
	self.model:DispatchEvent(HallGiveConst.EventName_WithdrawGift,msg)
end


function HallBankController:__delete( ... )
	HallBankController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
	self:RemoveEvent()
end