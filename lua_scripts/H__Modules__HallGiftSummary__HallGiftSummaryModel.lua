HallGiftSummaryModel = BaseClass(LuaModel)

function HallGiftSummaryModel:__init()
    self:RegistProto()
end

function HallGiftSummaryModel:RegistProto( ... )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,"RspRequestSummaryData")
end

function HallGiftSummaryModel:RemoveProto( ... )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,"RspRequestSummaryData")
end


---请求礼物汇总
function HallGiftSummaryModel:RequestSummaryData(index)

	local startTime=nil
	local endTime=nil
	local currentTime_Second=os.time()
	local currentTime_Tabel=os.date("*t",currentTime_Second)
	local ThisMonthStartTime_Tabel={
		day=1,
		month=currentTime_Tabel.month,
		year=currentTime_Tabel.year,
		hour=0,
		minute=0,
		second=0,
	}
	--1:本月 2:上个月
	if index==1 then
		local ThisMonthStartTimeSecond=os.time(ThisMonthStartTime_Tabel)
		startTime=ThisMonthStartTimeSecond
		endTime=currentTime_Second
	else
		local LastMonthStartTime_Tabel=nil
		local LastMonthStartTime_Second=nil
		local LastMonthEndTime_Talbe=nil
		local LastMonthEndTime_Second=nil
		if currentTime_Tabel.month==1 then
			LastMonthStartTime_Tabel={
				day=1,
				month=12,
				year=currentTime_Tabel.year-1,
				hour=0,
				minute=0,
				second=0,
			}
		else
			LastMonthStartTime_Tabel={
				day=1,
				month=currentTime_Tabel.month-1,
				year=currentTime_Tabel.year,
				hour=0,
				minute=0,
				second=0,
			}
		end
		LastMonthEndTime_Talbe=ThisMonthStartTime_Tabel
		LastMonthStartTime_Second=os.time(LastMonthStartTime_Tabel)
		LastMonthEndTime_Second=os.time(LastMonthEndTime_Talbe)
		startTime=LastMonthStartTime_Second
		endTime=LastMonthEndTime_Second
	end
	local send={}
	send.m_unID=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unStartTime=startTime
	send.m_unEndTime=endTime
	Net_SendHallData(NetworkDefine.ReqQueryTransferSummary,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TRANSFER_SUMMARY,13)
end


--查询转账汇总返回
function HallGiftSummaryModel:RspRequestSummaryData(buffer)
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
		HallGiftSummaryController.GetInstance().view.panel:OnUpdateSendData(msg)
		--self.model:UpdateSummaryData(msg)
	else
		ServerBackPrompt(msg.m_sResultId);
	end

end

HallGiftSummaryModel.SpriteNames =
{
	[1] = "Hall_Label_BYZJ",
	[2] = "Hall_Label_BYZJ",
}


function HallGiftSummaryModel:__delete()

end