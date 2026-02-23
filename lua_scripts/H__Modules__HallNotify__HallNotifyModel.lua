HallNotifyModel =  BaseClass(LuaModel)

function HallNotifyModel:__init()
	self.mNotifyList = {} --公告内容列表
	self.mGameNotifyCount = 0	--游戏跑马灯累计条数
	self.mBackNotifyCount = 0	--后台公告累计条数
	self.mVipNotifyCount = 0	--vip充值公告累计条数
	self.mCommissionCount = 0	--领取佣金累计条数
	self.disPlayCount = 1  --公告通道数

	self.TopScoreRankData={}

	self.IsTopScorePanelOpne = false
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_SCORE_RANK,"CQueryScoreRankRsp")

	self.IsShowTopScorePanel = true
end

---- data.m_ucType 1游戏跑马灯 2 后台公告  3 vip充值公告  4 领取佣金公告
function HallNotifyModel:AddNotifyList(data)

	if data.m_ucType == 1 then
		if ConfigModuleModel.GetInstance().GameNotifyRebate > 0 then
			self.mGameNotifyCount = self.mGameNotifyCount + 1
			if self.mGameNotifyCount > ConfigModuleModel.GetInstance().GameNotifyRebate -1 then
				self.mGameNotifyCount = 0
				table.insert(self.mNotifyList,data)
			end
		end
	elseif data.m_ucType == 2 then
		if ConfigModuleModel.GetInstance().BackNotifyRebate > 0 then
			self.mBackNotifyCount = self.mBackNotifyCount + 1
			if self.mBackNotifyCount > ConfigModuleModel.GetInstance().BackNotifyRebate -1 then
				self.mBackNotifyCount = 0
				table.insert(self.mNotifyList,data)
			end
		end
	elseif data.m_ucType == 3 then
		if ConfigModuleModel.GetInstance().VipNotifyRebate > 0 then
			self.mVipNotifyCount = self.mVipNotifyCount + 1
			if self.mVipNotifyCount > ConfigModuleModel.GetInstance().VipNotifyRebate -1 then
				self.mVipNotifyCount = 0
				table.insert(self.mNotifyList,data)
			end
		end
	elseif data.m_ucType == 4 then
		if ConfigModuleModel.GetInstance().CommissionNotifyRebate > 0 then
			self.mCommissionCount = self.mCommissionCount + 1
			if self.mCommissionCount > ConfigModuleModel.GetInstance().CommissionNotifyRebate -1 then
				self.mCommissionCount = 0
				table.insert(self.mNotifyList,data)
			end
		end
	end

end

---发送请求爆分排行榜
function HallNotifyModel:CQueryScoreRankReq()
	local send = {}
	UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","Load timeout",15)
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_usReqCount = 50
	Net_SendBoradCastData(NetworkDefine.CQueryScoreRankReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_SCORE_RANK,20)
	send = nil
end

---请求爆分排行榜返回
function HallNotifyModel:CQueryScoreRankRsp(buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	self:DecodetQueryTopScoreRank(buffer)
	HallNotifyController.GetInstance().view.panel.mTopScoreView:SetTopScoreListData(self.TopScoreRankData)
	HallNotifyController.GetInstance().view.panel.mTopScoreView02:SetTopScoreListData(self.TopScoreRankData)
end

---解析客户端查询爆分排行榜
function HallNotifyModel:DecodetQueryTopScoreRank(szBuffer)
	
	if szBuffer==nil then return end
   local iStartLength=0
   self.TopScoreRankData={}
   self.TopScoreRankData.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
   iStartLength=iStartLength+NetworkDefine.DataType.Int16

   self.TopScoreRankData.m_usReturnCount=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)--邮件发送时间
   iStartLength=iStartLength+NetworkDefine.DataType.Int16
   
   self.TopScoreRankData.TopScoreRankList={}
   if self.TopScoreRankData.m_usReturnCount>0 then
	   for i=1,self.TopScoreRankData.m_usReturnCount do
		   local temp = {}
		   temp.m_szNickName=DataParse.BytesToString2(szBuffer,iStartLength,64)--玩家昵称
		   iStartLength=iStartLength+64

		   temp.m_usGameId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)	--游戏ID
		   iStartLength=iStartLength+NetworkDefine.DataType.Int16

		   temp.m_unTime=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)	--时间
		   iStartLength=iStartLength+NetworkDefine.DataType.Int32
		   
		   temp.m_unScore=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)	--得分
		   iStartLength=iStartLength+NetworkDefine.DataType.Int32
		 
		   if ConfigModuleModel.GetInstance().listGameName[temp.m_usGameId] ~= nil then
		   		
				temp.m_szGameName = ConfigModuleModel.GetInstance().listGameName[temp.m_usGameId]
				temp.m_szeGameName = ConfigModuleModel.GetInstance().elistGameName[temp.m_usGameId]
				table.insert(self.TopScoreRankData.TopScoreRankList, temp)
		   end
	   end
   end
  
end

function HallNotifyModel:SubNotifyList(number)
	for i=1, number do
    	self.mNotifyList[i] = nil
    end
end


function HallNotifyModel:__delete( )
	-- body
end

function HallNotifyModel:GetInstance()
	if HallNotifyModel.instance == nil then
		HallNotifyModel.instance = HallNotifyModel.New()
	end
	return HallNotifyModel.instance
end