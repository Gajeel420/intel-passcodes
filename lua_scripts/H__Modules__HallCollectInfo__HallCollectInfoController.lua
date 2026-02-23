HallCollectInfoController = HallCollectInfoController or BaseClass(LuaController)

require"H/Modules/HallCollectInfo/HallCollectInfoView"
require"H/Modules/HallCollectInfo/View/HallCollectInfoPanel"
require"H/Modules/HallCollectInfo/Msg/CUserDetailInfoMsg"


function HallCollectInfoController:__init( ... )
	self.view = HallCollectInfoView.New()
    self:RegistProto()
end

--监听请求商品列表返回
function HallCollectInfoController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_OPERATE_USER_DETAIL_INFO,"RspOperateUserDetailInfo") --收集用户信息
end

--请求收集信息
function HallCollectInfoController:ReqOperateUserDetailInfo(operateType,real_name,phone,email)  --0=查询, 1=设置
    print("------------------------  请求收集信息")
    local detailInfo = ""
    if operateType == 1 then
        detailInfo = detailInfo.."real_name:"..real_name
        detailInfo = detailInfo..";phone:"..phone
        detailInfo = detailInfo..";email:"..email
    end

    local send = {}
    send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_byOperateType = operateType
    send.m_sLen = #detailInfo
    send.m_szDetailInfo = CommonUtil.StringToByteArrayTable(detailInfo)

    NetworkDefine.CUserDetailInfoMsg={
        {"m_unUin","UInt32",0},
        {"m_byOperateType", "Byte", 0},
        {"m_sLen","Int16",0},--实际长度
        {"m_szDetailInfo","Byte[]",#detailInfo},--更新的内容, ","分隔各信息内容, 各信息内容以字符串的形式存入缓冲区
    }
    NetworkMgr:AddMsgStruct("NetworkDefine.CUserDetailInfoMsg",NetworkDefine.CUserDetailInfoMsg)
    Net_SendHallData(NetworkDefine.CUserDetailInfoMsg, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_OPERATE_USER_DETAIL_INFO, 28)
end

--收集信息返回
function HallCollectInfoController:RspOperateUserDetailInfo(buffer)
    UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    local msg = CUserDetailInfoMsg.Decode(buffer)
    print("------------------------  收集信息返回")
    pt(msg)
    -- local str = CommonUtil.LuaTableToStringNoEmpty(msg.m_szDetailInfo)
    -- print("------------------------  收集信息返回 str == ",str)
    if msg.m_byOperateType == 0 and msg.m_sLen == 0 then
        -- 没有收集
        UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallCollectInfo)
    end
end

function HallCollectInfoController:GetInstance()
	if HallCollectInfoController.instance == nil then
		HallCollectInfoController.instance = HallCollectInfoController.New()
	end
	return HallCollectInfoController.instance
end

function HallCollectInfoController:__delete( ... )
	self.view = nil
end
