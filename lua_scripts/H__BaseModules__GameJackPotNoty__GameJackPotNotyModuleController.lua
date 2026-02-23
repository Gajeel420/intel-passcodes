GameJackPotNotyModuleController = GameJackPotNotyModuleController or BaseClass(LuaController)

require"H/BaseModules/GameJackPotNoty/Vo/GameJackPotNotyVo"

function GameJackPotNotyModuleController:__init( ... )
	-- body
	self:RegistProto()
end

function GameJackPotNotyModuleController:RegistProto( ... )
	-- body
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SVR_BROADCAST_LOTTERY,"GameJackPotNoty") --响应查询邮件
end

function NotifyModuleController:RemoveProto( ... )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_SVR_BROADCAST_LOTTERY,"GameJackPotNoty")
end

--游戏中彩金通知处理
function GameJackPotNotyModuleController:GameJackPotNoty( buffer )
	-- body
	local msg=self:ParseMsg(NetworkDefine.GameJackPotNoty,buffer)
	self.data = GameJackPotNotyVo.New()
	local gameName = ConfigModuleModel:GetInstance():GetGameNameByServerID(msg.m_usGameId)
	local userName = CommonUtil.LuaTableToStringNoEmpty(msg.m_szNickName)
	self.data:InitData(msg.m_unUIN,userName,gameName,msg.m_iLotteryType,msg.m_un64Profit)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HalGameJackPotNoty)
end

function GameJackPotNotyModuleController:GetInstance()
	if GameJackPotNotyModuleController.instance==nil then
		GameJackPotNotyModuleController.instance=GameJackPotNotyModuleController.New()
	end
	return GameJackPotNotyModuleController.instance
end