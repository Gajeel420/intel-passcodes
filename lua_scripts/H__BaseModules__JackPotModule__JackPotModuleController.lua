JackPotModuleController = JackPotModuleController or BaseClass(LuaController)

require"H/BaseModules/JackPotModule/Msg/CRspQueryJackMsgPara"

function JackPotModuleController:__init( ... )
	-- body
	self:RegistProto()
end

---监听协议结果返回
function JackPotModuleController:RegistProto( ... )
	-- body
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SVR_BROADCAST_GET_LOTTERY_LIST,"QueryJackPotListHandle") --响应查询邮件
end

---处理服务器返回的彩金得主信息
function JackPotModuleController:QueryJackPotListHandle( buffer )
	-- body
	local msg = CRspQueryJackMsgPara.Decode(buffer)
	HallJackPotController:GetInstance():SetJackPotList(msg)
end

---请求彩金得主列表
function JackPotModuleController:ReqJackPotList( ... )
	-- body
	local send = {}
	send.time = 0
	Net_SendHallData(NetworkDefine.CNotifyGetLotteryListReqPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_SVR_BROADCAST_GET_LOTTERY_LIST,20)
end

function JackPotModuleController:GetInstance()
	if JackPotModuleController.instance==nil then
		JackPotModuleController.instance=JackPotModuleController.New()
	end
	return JackPotModuleController.instance
end