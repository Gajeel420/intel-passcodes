ActivityModuleController=ActivityModuleController or BaseClass(LuaController)
require"H/BaseModules/ActivityModule/ActivityModuleModel"
require"H/BaseModules/ActivityModule/Msg/CGetActivityConfigRsp"
require"H/BaseModules/ActivityModule/Msg/CActivityOperateRsp"

function ActivityModuleController:__init()
	self:RegistProto()
	self:AddEvent()
	self.model=ActivityModuleModel:GetInstance()
end

function ActivityModuleController:AddEvent()
	LuaEvent:AddEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

function ActivityModuleController:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

function ActivityModuleController:RegistProto( ... )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_ACTIVITY_CONFIG,"CGetActivityConfigRsp")
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_ACTIVITY_OPERATE,"CActivityOperateRsp")
end

function ActivityModuleController:CGetActivityConfigReq (activeId)
    local send = {}
    send.uin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.activeId = activeId

    Net_SendHallData(NetworkDefine.CGetActivityConfigReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_ACTIVITY_CONFIG,28)
	print("-----------------  请求活动, 类型 ==", activeId)
end

function ActivityModuleController:CGetActivityConfigRsp(buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	print("--------------- 获取活动消息返回")
	local msg = CGetActivityConfigRsp.Decode(buffer)
	pt(msg)
	if msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus then
		-- WagerBonu
		HallMidnightPartyController:GetInstance().model:SetMidnightPartyData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate then
		HallCashBackController:GetInstance().model:SetCashBackData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_AllSaintsDay then
		HallHalloweenController:GetInstance().model:SetHelloweenData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie then
		HallFortuneCookieController:GetInstance().model:SetFortuneCookieData(msg)
	end
end

function ActivityModuleController:CActivityOperateReq(activeId,reqParamTab)
	local reqParamStr = Json.encode(reqParamTab)
    local send = {}
    send.uin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.activeId = activeId
    send.len = string.len(reqParamStr)
    send.reqParam = CommonUtil.StringToByteArrayTable(reqParamStr)

	NetworkDefine.CActivityOperateReq = 
	{
		{"uin","UInt32",0},
		{"activeId","Int32",0},
		{"len","Int32",0},
		{"reqParam","Byte[]",string.len(reqParamStr)},
	}
	-- 	// activeId=1(WagerBonus)
	-- {	
	--     "type": 1,         // 类型 1=主动请求是否有wagerBonus可参与; 2=确认是否参与
	-- 	   "isAgree": 0       // 是否参与wager bonus 0=否，1=是
	-- }

	NetworkMgr:AddMsgStruct("NetworkDefine.CActivityOperateReq",NetworkDefine.CActivityOperateReq)
    Net_SendHallData(NetworkDefine.CActivityOperateReq,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_ACTIVITY_OPERATE,28)
	print("-----------------  请求活动, 是否参与或是否有活动参与类型 ==", activeId)
	--UIManager.GetInstance():ShowNetWorkMessage(LocalizationGet("CLIENT_TIPS_4"),LocalizationGet("CLIENT_TIPS_30"),3)
end

function ActivityModuleController:CActivityOperateRsp(buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	print("--------------- 获取活动消息  是否有活动参与返回")
	local msg = CActivityOperateRsp.Decode(buffer)
	pt(msg)
	if msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus then
		-- WagerBonu
		HallMidnightPartyController:GetInstance().model:SetMidnightPartyOperateData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRank then
		HallRankController:GetInstance():ResponsePlayerBetRankList(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate then
		HallCashBackController:GetInstance().model:SetCashBackOperateData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_AllSaintsDay then
		HallHalloweenController:GetInstance().model:SetHelloweenOperateData(msg)
	elseif msg.activeId == NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie then
		HallFortuneCookieController:GetInstance().model:SetFortuneCookieOperateData(msg)
	end
end

function ActivityModuleController:InitPlayerCompeleted(context)

end

function ActivityModuleController:GetInstance()
	if ActivityModuleController.instance==nil then 
		ActivityModuleController.instance=ActivityModuleController.New()
	end
	return ActivityModuleController.instance
end

function ActivityModuleController:__delete()
	self:RemoveEvent()
end

function ActivityModuleController:AddActivityEvent(event)
    self.model:AddActivityEvent(event)
end

function ActivityModuleController:ExecuteNextActivityEvent()
    self.model:ExecuteNextActivityEvent()
end

function ActivityModuleController:ClearData()
    self.model:ClearData()
end