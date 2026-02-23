HallWealthListModel = HallWealthListModel or BaseClass(LuaModel)

function HallWealthListModel:__init( ... )
	self.m_listRankWealth=nil
	self:RegistProto()
end

function HallWealthListModel:RegistProto()
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUERY_REAL_SPURIOUS_WIN_RANKING_LIST,"ResWinRankingListCallBack")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_RICH_RANKING,"ResUserRankCallBack")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUEERY_REAL_SPURIOUS_RECHARGE_RANKING_LIST,"ResRechargeRankingListCallBack")
end

function HallWealthListModel:CheckRanklist()
	if not self.m_listRankWealth or not next(self.m_listRankWealth) then
		--没有数据就要请求
		return false 
	end
	return true
end

function HallWealthListModel:RefreshRankWealthList(list)
	self.m_listRankWealth=list
	if self.m_listRankWealth then
		self:DispatchEvent(HallWealthListConst.EventName_RefreshRankList,self.m_listRankWealth)
	end
end


----请求赢钱榜
function  HallWealthListModel:ReqWinRankingList()
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	UIManager.GetInstance():ShowNetWorkMessage("CLIENT_TIPS_2","",20,nil)
	Net_SendHallData(NetworkDefine.CReqQueryWinRankListPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUERY_REAL_SPURIOUS_WIN_RANKING_LIST,13)
end

------请求赢榜返回
function HallWealthListModel:ResWinRankingListCallBack(buffer)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg = CRspQueryWinRankingListPara.Decode(buffer)
	self:RefreshRankWealthList(msg.m_RspUserList)

end

--请求排行榜
function HallWealthListModel:ReqUserRank(m_ucDataType,m_ucMoneyType,m_usReqUserCount)
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_usAgentId=PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID
	send.m_ucDataType=m_ucDataType
	send.m_ucMoneyType=m_ucMoneyType
	send.m_usReqUserCount=m_usReqUserCount
	UIManager.GetInstance():ShowNetWorkMessage("CLIENT_TIPS_2","",5,nil)
	Net_SendHallData(NetworkDefine.CReqQueryRechargeListPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_RICH_RANKING,13)
end

---请求排行榜返回
function HallWealthListModel:ResUserRankCallBack(buffer)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg = CRspQueryRechargeListPara.Decode(buffer) 
	self:RefreshRankWealthList(msg.m_RspUserList)
end

----请求充值榜
function  HallWealthListModel:ReqRechargeRankingList()
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	UIManager.GetInstance():ShowNetWorkMessage("CLIENT_TIPS_2","",5,nil)
	Net_SendHallData(NetworkDefine.CReqQueryWinRankListPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUEERY_REAL_SPURIOUS_RECHARGE_RANKING_LIST,13)
end

---请求充值榜返回
function HallWealthListModel:ResRechargeRankingListCallBack(buffer)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg = CRspQueryRechargeRankingListPara.Decode(buffer) 
	self:RefreshRankWealthList(msg.m_RspUserList)
end

---请求佣金排行榜
function HallWealthListModel:ReqCommssionRankingList()
	local param = Parameter.New()
	local uid = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    local itime=os.time()
    param:Add("uid",uid)
    param:Add("itime",itime)
    param:Add("code", GetRequestCode({uid,itime},"|"))
    local str = ConfigInfoMgr.WEB_SERVICE_URL
    local web = string.gsub(str,"Pay/","")
	local successFunc = function(jd)  --请求数据成功
		if jd.retcode == 0 then
			local data = {}
			local type = jd.type
			local jdList = jd.data
			for i=1,#jdList do
				local commission= {}
				commission.m_unUIN = jdList[i].uid
				commission.money = jdList[i].value
				commission.m_szNickName = jdList[i].name
				commission.type = type
				data[i] = commission
			end
			self:RefreshRankWealthList(data)
		else
			UIManager.GetInstance().ShowNoteMessage(jd.retmsg,1)
		end
    end
    local failFunc = function()  --请求数据失败
		UIManager.GetInstance().ShowNoteMessage("获取佣金排行榜失败",1)
    end
    WebRequestByGet(WebDataRequestManager.RequestInterface.GetCommissionRank,param,successFunc,failFunc,"获取排行榜数据中，请稍后...")
end


function HallWealthListModel:ClearData()
	self.m_listRankWealth=nil
	self:DispatchEvent(HallWealthListConst.EventName_OnDestroyRankModel)
end

function HallWealthListModel:GetInstance()
	if HallWealthListModel.instance == nil then
		HallWealthListModel.instance = HallWealthListModel.New()
	end
	return HallWealthListModel.instance
end




HallWealthListModel.RankeLisTypeConst = 
{
	[1] = "赢金币",
	[2] = "充值金币",
	[3] = "拥有金币",
	[4] = "今日佣金",
}

function HallWealthListModel:__delete( ... )

end