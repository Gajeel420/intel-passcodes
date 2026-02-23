CRspGiveRecordMsg={}

function CRspGiveRecordMsg.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
	t.m_unThisReturnCount=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
	t.itemList={}
	for i=1,t.m_unThisReturnCount do
		local item={}
		item.iID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --赠送人id
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.iSrcUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --赠送人id
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.strSrcNickName=DataParse.BytesToString2(szBuffer,iStartLength,64)
		iStartLength=iStartLength+64;--//昵称
		item.iDstUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --接收人id
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.strDstNickName=DataParse.BytesToString2(szBuffer,iStartLength,64)
		iStartLength=iStartLength+64;--//昵称
		item.iTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --赠送时间
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.iItemID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --赠送道具ID
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.iCount=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --赠送道具数量
		iStartLength=iStartLength+NetworkDefine.DataType.Int32
		item.iSucceedState=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength) --捐赠状态 0. 失败  1. 成功，2.已撤回
		iStartLength=iStartLength+NetworkDefine.DataType.Byte
		if item.iSucceedState ~= 0 then
			--t.itemList[i]=item
			table.insert(t.itemList,item)
		end
	end
	return t
 end
--  --赠送记录
-- tagUserDonatePropRecord=
-- {
--     {"m_unID","UInt32"},  --数据库ID
--     {"m_unSrcUIN","UInt32"},  --来源id
--     {"m_szSrcNickName","Byte[]",64},
--     {"m_unDstUIN","UInt32"},   --目标id
--     {"m_szDstNickName","Byte[]",64},
--     {"m_unTime","UInt32"},  --赠送时间
--     {"m_unPropId","UInt32"},  --赠送道具ID
--     {"m_unPropCount","UInt32"},  --赠送道具数量
-- 	{"m_ucSucceedState","Byte"}  --捐赠状态  1. 成功，2.已撤回
-- }
