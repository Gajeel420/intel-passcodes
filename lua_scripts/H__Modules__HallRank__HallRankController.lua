HallRankController = HallRankController or BaseClass(LuaController)

require"H/Modules/HallRank/HallRankView"
require"H/Modules/HallRank/HallRankModel"
require"H/Modules/HallRank/View/HallRankPanel"
require"H/Modules/HallRank/View/HallRankItem"


function HallRankController:__init( ... )
	self.model = HallRankModel:GetInstance()
	self.view = HallRankView.New()
    self:RegistProto()
end

--监听请求商品列表返回
function HallRankController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_WIN_COIN_RANK,"ResponsePlayerWinCoinRankList")
end

--请求排行榜
function HallRankController:RequestPlayerWinCoinRankList(reuqestType)
	self.model.mWinCoinRankList = nil
	self.model.mWinCoinRankList = {}
	local send={}
	send.m_unUIN=PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_ucOperType = reuqestType
	print("----------- RequestPlayerWinCoinRankList",reuqestType)
	UIManager.GetInstance():ShowNetWorkMessage(StringFormatByLanguage("HardLoad"),"",5,nil)
	Net_SendHallData(NetworkDefine.CGetUserWinCoinRankReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_WIN_COIN_RANK,13)
end


---请求玩家赢钱榜 返回
function HallRankController:ResponsePlayerWinCoinRankList(buffer)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg = self:DecodePlayerWinCoinRankList(buffer)
	print("----------- ResponsePlayerWinCoinRankList")
	pt(msg)
	if msg.m_ucOperType == NetworkDefine.E_WIN_RANK_TYPE.WEEK_TOTAL_WIN then
		self.model.mWinCoinRankList = msg
		if self.view.panel then
			self.view.panel:SetRankViewData(self.model.mWinCoinRankList)
		end
	end
end

function HallRankController:DecodePlayerWinCoinRankList(szBuffer)
	if szBuffer==nil then return end
	local iStartLength=0
    local result = {}
	result.m_wonWinIndex = 0
	result.m_wonWinMoney = 0
    result.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16
    result.m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)              
	iStartLength=iStartLength+NetworkDefine.DataType.Int32
    result.m_ucOperType=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)     ---操作类型 0=当日排行榜 ，1=本周排行榜 2 = 赢分周排行榜
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
    result.m_ucRankItemCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Byte
	result.WinCoinUserList= {}
    if result.m_ucRankItemCnt > 0 then
        for i = 1,  result.m_ucRankItemCnt do
			result.WinCoinUserList[i] = {}
			result.WinCoinUserList[i].m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int32; --//用户的UIN
			result.WinCoinUserList[i].m_szNickName = LuaUtils.HandleServerStr(DataParse.BytesToString2(szBuffer,iStartLength,64))
			iStartLength=iStartLength+64--//昵称
			result.WinCoinUserList[i].m_n64WinMoney = DataParse.NetworkToHostOrderToInt64(szBuffer,iStartLength)
			iStartLength=iStartLength+NetworkDefine.DataType.Int64; --// 排行榜玩家应分信息  
			if result.WinCoinUserList[i].m_unUIN == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
				result.m_wonWinIndex = i
				result.m_wonWinMoney = result.WinCoinUserList[i].m_n64WinMoney
			end
        end 
    end
    return result
end

function HallRankController:GetInstance()
	if HallRankController.instance == nil then
		HallRankController.instance = HallRankController.New()
	end
	return HallRankController.instance
end

function HallRankController:__delete( ... )
	self.view = nil
end
