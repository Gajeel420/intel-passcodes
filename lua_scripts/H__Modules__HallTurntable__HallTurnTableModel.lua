HallTurnTableModel  = BaseClass(LuaModel)

function HallTurnTableModel:__init()
    self.mLuckyWhellResult = nil
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_OPERATE_LUCKY_WHEEL,"ResponseLuckyWhell")
end


function HallTurnTableModel:RequestLuckyWheel(questType)
    local send = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_ucOperType = questType
    print("--------------------发  HallTurnTableModel:RequestLuckyWheel ")
    -- pt(send)
    Net_SendHallData(NetworkDefine.COperLuckyWheelTaskReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_OPERATE_LUCKY_WHEEL,0)
end


function HallTurnTableModel:ResponseLuckyWhell(buffer)
    print("--------------------回  HallTurnTableModel:ResponseLuckyWhell ")
    self.mLuckyWhellResult = self:DecodeLuckyWhell(buffer)
    pt("************HallTurnTableModelHallTurnTableModelHallTurnTableModelHallTurnTableModel****************",self.mLuckyWhellResult)
    LuaEvent:DispatchEvent(EventName.LuckyWhellCallBack)
end


function HallTurnTableModel:DecodeLuckyWhell(szBuffer)
    if szBuffer==nil then return end
	local iStartLength=0
    local result = {}
    result.m_sResult=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
    result.m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)               ---操作类型 0 查询转盘信息 1=转动转盘获取幸运奖项
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
    result.m_ucOperType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)               ---操作类型 0 查询转盘信息 1=转动转盘获取幸运奖项
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
    result.m_ucPrizeStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)        --奖励状态 0: 不可领取, 1: 可领取, 2: 等待下一期
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
    result.m_unRemainSeconds=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)     --等待下一期 剩余秒数
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
    result.m_ucPrizeIndex=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)         --中奖转盘项索引
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
    result.m_n64PrizeMoney=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)     --中奖金额
	iStartLength=iStartLength+NetworkDefine.DataType.Int64
    result.m_ucWheelItemCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
    if result.m_ucWheelItemCnt > 0 then
        result.mLuckyWhell= {}
        for i = 1,  result.m_ucWheelItemCnt do
            result.mLuckyWhell[i]=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)     --转盘值
	        iStartLength=iStartLength+NetworkDefine.DataType.Int64
        end 
    end
    return result
end

function HallTurnTableModel:GetInstance()
	if HallTurnTableModel.instance == nil then
		HallTurnTableModel.instance = HallTurnTableModel.New()
	end
	return HallTurnTableModel.instance
end

function HallTurnTableModel:__delete()
    
end