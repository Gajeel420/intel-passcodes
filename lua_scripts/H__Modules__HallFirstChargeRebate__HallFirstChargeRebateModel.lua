HallFirstChargeRebateModel = BaseClass(LuaModel)

function HallFirstChargeRebateModel:__init( ... )
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUERY_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PROGRESS,"CQueryDayFirstRechargeDaMaSendActivityProgressRsp")
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_DRAW_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PRIZE,"CDrawDayFirstRechargeDaMaSendActivityPrizeRsp")
end

---查询每日首充打码赠送活动进度
function HallFirstChargeRebateModel:CQueryDayFirstRechargeDaMaSendActivityProgressReq()
    UIManager:GetInstance():ShowNetWorkMessage("查询中","查询失败，请关闭重新打开",8)
    local send = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	Net_SendHallData(NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUERY_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PROGRESS,16)
end

---查询每日首充打码赠送活动进度 返回
function HallFirstChargeRebateModel:CQueryDayFirstRechargeDaMaSendActivityProgressRsp(buffer)
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
    local msg=self:ParseMsg(NetworkDefine.CQueryDayFirstRechargeDaMaSendActivityProgressRsp,buffer)
    pt(msg)
    if msg.m_sResultId==0 then
        HallFirstChargeRebateController.GetInstance().view.panel:QueryDayFirstRechargeDaBack(msg)
    else
        print("查询失败")
    end
end

---领取每日首充打码量
function HallFirstChargeRebateModel:CDrawDayFirstRechargeDaMaSendActivityPrizeReq()
    UIManager:GetInstance():ShowNetWorkMessage("领取中","",8)
    local send = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
   Net_SendHallData(NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_DRAW_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PRIZE,16)
end

---领取每日首充打码量返回
function HallFirstChargeRebateModel:CDrawDayFirstRechargeDaMaSendActivityPrizeRsp(buffer)
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
    local msg=self:ParseMsg(NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeRsp,buffer)
    if msg.m_sResultId == 0 then
        local iMoney = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
        local iBank = PlayerInfoController:GetInstance().model.mainPlayer.iBank
        PlayerInfoController:GetInstance().model.mainPlayer:SetValue("iMoney",msg.m_un64Coin,iMoney)
        PlayerInfoController:GetInstance().model.mainPlayer:SetValue("iBank",msg.m_un64Bank,iBank)
        self:CQueryDayFirstRechargeDaMaSendActivityProgressReq()
    else
        ServerBackPrompt(msg.m_sResultId)
        print("领取失败")
    end
    
end


function HallFirstChargeRebateModel:GetInstance()
	if HallFirstChargeRebateModel.instance==nil then
		HallFirstChargeRebateModel.instance=HallFirstChargeRebateModel.New()
	end
	return HallFirstChargeRebateModel.instance
end


HallFirstChargeRebateModel.ProgressType = 
{
    E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NO_RECHARGE                       = 0,    --当天还没有充值
    E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_IN_PROGRESS                       = 1,    --当天已经充值, 活动进行中
    E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_WAIT_RECHARGE_TO_TRIGGER = 2,    --已经到了次日, 等待充值任意金额领取奖励
    E_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_STATUS_NEXT_DAY_CAN_DRAW_PRIZE           = 3,     --可以领取奖励
}

function HallFirstChargeRebateModel:__delete()

end
