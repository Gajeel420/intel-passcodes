HallGiftRecordModel = BaseClass(LuaModel)

function HallGiftRecordModel:__init()
    self.CurrentGiveMoney = 0

    self:RegistProto()
end

function HallGiftRecordModel:RegistProto( ... )
	
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD,"RspRequestRecordData")
	-- self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,"RspRequestSummaryData")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE,"RspCancellationOfTransfer")
	
end

function HallGiftRecordModel:RemoveProto( ... )
	
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD,"RspRequestRecordData")
	-- self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,"RspRequestSummaryData")
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE,"RspCancellationOfTransfer")
	
end


--请求赠送记录：type:请求类型，pageIndex：请求页数，pageSize：请求数量
function HallGiftRecordModel:RequestRecordData(type,pageIndex,pageSize)
	local send={}
	send.m_unID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_ucType=type
	send.m_unPageIndex=pageIndex
	send.m_unPageSize=pageSize
	Net_SendHallData(NetworkDefine.ReqQueryTransferRecord,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD,13)
end

--查询转账记录返回
function HallGiftRecordModel:RspRequestRecordData(buffer)
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

		self:UpdateRecordData(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end


function HallGiftRecordModel:UpdateRecordData(msg)
	local dataList=msg.m_TransferRecordArray
	if dataList==nil or #dataList<1 then
		return
	end

	local data={
		PageIndex=msg.m_unPageIndex,
		PageSize=msg.m_unPageSize,
		ThisReturnCount=msg.m_unThisReturnCount,
		RecordList=dataList,
	}
	
	HallGiftRecordController.GetInstance().view.panel:OnUpdateSendData(data.RecordList)

end

---撤销转账
function HallGiftRecordModel:ReqCancellationOfTransfer(tid)
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unID=tonumber(tid)
	
	Net_SendHallData(NetworkDefine.ReqCancellationOfTransfer,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE,13)
end


--请求撤销转账返回
function HallGiftRecordModel:RspCancellationOfTransfer(buffer)
	
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
		
		self:RspCancellationOfTransfer(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end

--解析撤销转账返回
function HallGiftRecordModel:RspCancellationOfTransfer(msg)
	local record=msg.m_TransferRecord
	if record==nil then
		return
	end

	local data={
		Record=record
	}

	self:DispatchEvent(HallGiftRecordModel.EventType.CancellationOfTransferReturn,data)
end



---查询类型
HallGiftRecordModel.RecordType = 
{
	Give = 1,
	Receive = 2,
}

HallGiftRecordModel.ResultList =
{
	[1] = "Hall_Bt_Givefailure",
	[2] = "Hall_Bt_HaveGive2",
	[3] = "Hall_BT_HaveReceive2",
	[4] = "Hall_BT_HaveWithdraw",
}


HallGiftRecordModel.EventType=
{
	CancellationOfTransferReturn="HallGiveModel.EventType.CancellationOfTransferReturn",
}



function HallGiftRecordModel:__delete()

end