CRspGetUserTotalScore={}

-- --房卡结算汇总返回
-- NetworkDefine.CRspGetUserTotalScore={
--     {"m_usMsgLen","Int16",0}, --
--     {"m_sResultID","Int16",0}, --!<响应消息的结果；0：成功；1：一部分成功；-1：全部失败；
--     {"m_unCardID","Int32",0},--房卡id
--     {"m_unCreateTime","Int32",0},--创建时间
--     {"m_unReqType","Int32",0},--请求类型  1 显示汇总结算  2 战绩请求
--     {"m_usUsedNum","Int16",0}, --使用过的局数
--     {"m_usTotalNum","Int16",0}, --总局数
--     {"m_usUserCount","Int16",0}, --用户数
--     {"mGameDataList","NetworkDefine.Result_GAME_DATA",0}, --用户信息
-- }
-- ---------------------------结构--------------------------------
-- NetworkDefine.Result_GAME_DATA={
--     {"unUserID","Int32",0}, --结算玩家id
--     {"usPlayedNum","Int16",0},--玩过的局数
--     {"n64AfterScore","Int64",0},--结算后积分
--     {"n64ChangeScore","Int64",0},--变化积分，输赢
--     {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--名称
--     {"mDataLen", "Int32", 0},--名称
--     {"mGameTypeData", "NetworkDefine.GameTypeData", 0},--名称
-- }

-- NetworkDefine.GameTypeData={
--     {"mType","Int32",0}, --游戏类型
--     {"nNum","Int32",0}, --/数量
-- }

function CRspGetUserTotalScore.Decode(szBuffer)
	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.m_usMsgLen=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_sResultID=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_unCardID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_unCreateTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_unReqType=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int32

	t.m_usUsedNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_usTotalNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.m_usUserCount=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	t.mGameDataList = {};
	if t.m_usUserCount>1 then
		for i=1,t.m_usUserCount do
			t.mGameDataList[i]={}
			t.mGameDataList[i].unUserID=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32

			t.mGameDataList[i].usPlayedNum=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int16

			t.mGameDataList[i].n64AfterScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64

			t.mGameDataList[i].n64ChangeScore=DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64

			t.mGameDataList[i].m_szNickName=DataParse.BytesToString(szBuffer,iStartLength,HallDefine.ConstDefine.MAX_NICK_LEN)
			iStartLength=iStartLength+NetworkDefine.DataType.Byte*HallDefine.ConstDefine.MAX_NICK_LEN

			t.mGameDataList[i].mDataLen=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32
			
			t.mGameDataList[i].mGameTypeData={}
			if t.mGameDataList[i].mDataLen>1 then
				for j=1,t.mGameDataList[i].mDataLen do
					t.mGameDataList[i].mGameTypeData[j]={}
					t.mGameDataList[i].mGameTypeData[j].mType= DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
					iStartLength=iStartLength+NetworkDefine.DataType.Int32

					t.mGameDataList[i].mGameTypeData[j].nNum= DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
					iStartLength=iStartLength+NetworkDefine.DataType.Int32
				end
			end
		end
	end

	return t
end