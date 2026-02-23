HallBankModel = HallBankModel or BaseClass(LuaModel)

function HallBankModel:__init( ... )
	self.itemList={}
	self.packageItemList={}
	self.recordItemList={}
	self.CurrentGiveMoney = 0

end

function HallBankModel:GetInstance()
	if HallBankModel.instance == nil then
		HallBankModel.instance = HallBankModel.New()
	end
	return HallBankModel.instance
end


--[[
--查询转账记录
NetworkDefine.ReqQueryTransferRecord=
{
    {"m_unUIN","UInt32",0}, --用户ID
    {"m_ucType","Byte",0},  --查询类型, 0: 查询赠送和接收记录, 1: 只查赠送记录, 2: 只查接收记录
    {"m_unPageIndex","UInt32",0},--分页查询索引, 从1开始
    {"m_unPageSize","UInt32",0},--分页查询一次查询的记录条数
}

--查询转账记录返回记录结构体
NetworkDefine.TTransferRecord=
{
    {"m_unTime","UInt32",0},--赠送或接收的时间
    {"m_ucType","Byte",0},--类型, 1: 赠送, 2: 接收
    {"m_un64Count","Int64",0},--赠送或接收数量
    {"m_unUIN","UInt32",0},--对方的玩家ID
    {"m_szNickName","Byte[]",HallDefine.ConstDefine.E_MAX_NICK_LEN},--对方的昵称
}

--查询转账记录返回
NetworkDefine.RspQueryTransferRecord=
{
    {"m_sResultId","Int16",0},
    {"m_unPageIndex","UInt32",0},
    {"m_unPageSize","UInt32",0},
    {"m_unThisReturnCount","UInt32",0},
    {"m_TransferRecordArray","NetworkDefine.TTransferRecord",HallDefine.ConstDefine.ONE_QUERY_MAX_TRANSFER_RECORD_COUNT},

}

--]]

--请求赠送记录：type:请求类型，pageIndex：请求页数，pageSize：请求数量
function HallBankModel:RequestRecordData(type,pageIndex,pageSize)
	local send={}
	send.m_unID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_ucType=type
	send.m_unPageIndex=pageIndex
	send.m_unPageSize=pageSize
	Net_SendHallData(NetworkDefine.ReqQueryTransferRecord,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD,13)

end





function HallBankModel:UpdateRecordData(msg)
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
	if dataList[1].m_ucType==HallBankModel.RecordType.Give then

		self:DispatchEvent(HallBankModel.EventType.GiveDataReturn,data)
	else

		self:DispatchEvent(HallBankModel.EventType.ReceiveDataReturn,data)
	end
end






--[[

--请求撤销转账
NetworkDefine.ReqCancellationOfTransfer=
{
    {"m_unUIN","UInt32",0}, --用户ID
    {"m_unID","UInt32",0}, --转账标识
}


--请求撤销转账返回
NetworkDefine.RspCancellationOfTransfer=
{
    {"m_sResultId","Int16",0},--错误码 0: 成功, 其它: 出错
    {"m_TransferRecord","NetworkDefine.TTransferRecord",0}, --转账记录消息体
}

--]]

--请求撤销转账: tid:转账记录标识
function HallBankModel:ReqCancellationOfTransfer(tid)
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unID=tonumber(tid)
	Net_SendHallData(NetworkDefine.ReqCancellationOfTransfer,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE,13)

end


--撤销转账返回
function HallBankModel:RspCancellationOfTransfer(msg)
	local record=msg.m_TransferRecord
	if record==nil then
		return
	end

	local data={
		Record=record
	}

	self:DispatchEvent(HallBankModel.EventType.CancellationOfTransferReturn,data)
end


--请求转账汇总
function HallBankModel:RequestSummaryData(startTime,endTime)
	local send={}
	send.m_unID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unStartTime=startTime
	send.m_unEndTime=endTime
	Net_SendHallData(NetworkDefine.ReqQueryTransferSummary,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,13)

end



function HallBankModel:UpdateSummaryData(msg)
	local dataList=msg.m_DaySummaryArray
	if dataList==nil or #dataList<1 then

		return
	end

	local data={
		ReturnCount=msg.m_unReturnCount,
		SummaryList=msg.m_DaySummaryArray
	}

	self:DispatchEvent(HallBankModel.EventType.SummaryDataReturn,data)

end











function HallBankModel:__delete( ... )
end




HallBankModel.EventType=
{
	GiveDataReturn="HallBankModel.EventType.GiveDataReturn",
	ReceiveDataReturn="HallBankModel.EventType.ReceiveDataReturn",
	SummaryDataReturn="HallBankModel.EventType.SummaryDataReturn",
	CancellationOfTransferReturn="HallBankModel.EventType.CancellationOfTransferReturn",
}



HallBankModel.RecordType=
{
	Give=1,
	Receive=2,
}

