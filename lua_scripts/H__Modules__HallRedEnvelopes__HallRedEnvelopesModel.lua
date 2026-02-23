HallRedEnvelopesModel = BaseClass(LuaModel)

function HallRedEnvelopesModel:__init()
    self.OPenRedPanleTick = "HallRedEnvelopesModel:OPenRedPanleTick"
    self.mPanelActive = false
    self.mCanRequest = false
    self:AddEvent()
end

function HallRedEnvelopesModel:AddEvent()
    -- self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_RED_PACKET_GIFT,"MSG_ID_CS_NOTIFY_RED_PACKET_GIFT")
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_RED_PACKET_GIFT,"MSG_ID_CS_QUERY_RED_PACKET_GIFT")
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_DRAW_RED_PACKET_GIFT,"MSG_ID_CS_DRAW_RED_PACKET_GIFT")
    --LuaEvent:AddEventListener(EventName.LOGIN_SUCCESS_COMPLETE,self.CClientQueryNotDrawedRedPacketGiftReq,self)
end

---后台向客户端赠送彩金领红包
function HallRedEnvelopesModel:MSG_ID_CS_NOTIFY_RED_PACKET_GIFT(buffer)
    if true then
        return
    end
    if SceneManager.GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game or self.mPanelActive then
        return 
    end

    local msg=self:ParseMsg(NetworkDefine.CMgrSendRedPacketGiftNotify,buffer)
    if msg.m_ucGiftType == NetworkDefine.BonusType.E_GIFT_TYPE_RED_PACKET then
        local data = {}
        data.m_unId = msg.m_unId
        data.m_un64SendCoins = msg.m_un64SendCoins
        self.mPanelActive = true
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRedEnvelopes,function(panel)
            panel:SetRedpackData(data)
        end)
    end
end

---客户端查询未领取的彩金红包
function HallRedEnvelopesModel:MSG_ID_CS_QUERY_RED_PACKET_GIFT(buffer)
    UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    local msg=self:ParseMsg(NetworkDefine.CClientQueryNotDrawedRedPacketGiftRsp,buffer)
    if msg.m_sResultId == 0 and msg.m_unId > 0 then
        if msg.m_ucGiftType == NetworkDefine.BonusType.E_GIFT_TYPE_RED_PACKET then
            local data = {}
            data.m_unId = msg.m_unId
            data.m_un64SendCoins = msg.m_un64SendCoins
            self.mPanelActive = true
            UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRedEnvelopes,function(panel)
                panel:SetRedpackData(data)
            end)
        end
    end
end


---客户端领取彩金红包回包
function HallRedEnvelopesModel:MSG_ID_CS_DRAW_RED_PACKET_GIFT(buffer)
    local msg=self:DecodeMSG_ID_CS_DRAW_RED_PACKET_GIFT(buffer)
    UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    if msg. m_sResultId == 0   then
        HallRedEnvelopesController.GetInstance().view.panel:OpenRedEffect(msg.m_szContent)
    else
        UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallRedEnvelopes)
        ServerBackPrompt(msg.m_sResultId)
    end
end

---解析领取红包会包
function HallRedEnvelopesModel:DecodeMSG_ID_CS_DRAW_RED_PACKET_GIFT(szBuffer)
    if szBuffer==nil then return end
    local iStartLength=0
    local t={}
    t.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--错误码
    iStartLength=iStartLength+NetworkDefine.DataType.Int16
    
    t.m_unId=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)--领取成功的记录ID
    iStartLength=iStartLength+NetworkDefine.DataType.Int32
    
    t.m_ucGiftType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--领取成功的彩金类型
    iStartLength=iStartLength+NetworkDefine.DataType.Byte
    
    t.m_un64SendCoins=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)--领取成功增加的游戏币
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
    
    t.m_un64BankBalance=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---银行账号余额
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
    
    t.m_un64TreasureBalance=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---元宝账号余额
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
    
    t.m_un64CoinBalance=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---游戏币账号余额
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
    
    t.m_un64Auxiliary=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---辅助帐号(幸运炸弹)
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
    
    t.m_un64Card=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---房卡
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
   
    t.m_un64WinMatches=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---累积赢局数
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
  
    t.m_un64WinPoints=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---累积赢分数
    iStartLength=iStartLength+NetworkDefine.DataType.Int64
   
    t.m_un64LossPoints=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)---累积输分数
    iStartLength=iStartLength+NetworkDefine.DataType.Int64

    t.m_iMsgLen=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)---长度
    iStartLength=iStartLength+NetworkDefine.DataType.Int32
    if t.m_iMsgLen > 0 then
        t.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,t.m_iMsgLen)--信息
        iStartLength=iStartLength+t.m_iMsgLen
    else
        t.m_szContent = "红包现金直接存入您的钱包"
    end
    -- t.m_szContent = "红包现金直接存入您的钱包"
    -- print("回报长度",iStartLength,t.m_iMsgLen)
	return t

end

----客户端查询未领取的彩金红包
function HallRedEnvelopesModel:CClientQueryNotDrawedRedPacketGiftReq()
    -- if self.mPanelActive  or SceneManager.GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game or not self.mCanRequest then
    --     return 
    -- end
    -- --UIManager.GetInstance():ShowNetWorkMessage("加载中。。","",5)
    -- local send = {}
    -- send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    -- send.m_ucGiftType = NetworkDefine.BonusType.E_GIFT_TYPE_RED_PACKET
    -- Net_SendHallData(NetworkDefine.CClientQueryNotDrawedRedPacketGiftReq , send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_RED_PACKET_GIFT, 0)
end

----客户端领取彩金红包
function HallRedEnvelopesModel:CClientDrawRedPacketGiftReq(m_unId)
    UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","",5)
    local send = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_unId = m_unId
    Net_SendHallData(NetworkDefine.CClientDrawRedPacketGiftReq , send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_DRAW_RED_PACKET_GIFT, 0)
end




function HallRedEnvelopesModel:__delete()

end