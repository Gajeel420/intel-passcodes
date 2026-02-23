CActivityOperateRsp = {}
function CActivityOperateRsp.Decode(szBuffer)  --解码
 	if szBuffer == nil then return end
	local iStartLength = 0
	local t={}

    t.resCode = DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)  -- 返回码 0=成功，1=失败
    iStartLength = iStartLength + NetworkDefine.DataType.Int16

    t.activeId = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.len = DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --返回参数长度
    iStartLength = iStartLength + NetworkDefine.DataType.Int32

    t.rspParam = Json.decode(DataParse.BytesToString2(szBuffer, iStartLength, t.len)) --返回参数
    iStartLength= iStartLength + NetworkDefine.DataType.Byte * t.len

    return t
end

-- // rspParam 返回参数json activeId=1(WagerBonus)
-- {
--     "type": 1,   // 显示 1=查询是否显示弹窗参与wagerBonus(客户端主动请求返回或者服务器主动下发)，2=操作是否同意返回结果  
-- 	   "value": 0   // 两种操作类型对应的结果值 type=1 时 value=0 表示不显示弹窗，value=1表示显示弹窗，value=2表示提示联系代理（点击确认都是放弃参与）。 
--                      type=2操作返回 如果value>0 表示同意参与wagerbonus，并获得了bonus的金额)
-- }
