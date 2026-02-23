HallGiftModel = BaseClass(LuaModel)

function HallGiftModel:__init()
    self.CurrentGiveMoney = 0

    self:RegistProto()
end

function HallGiftModel:RegistProto( ... )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_TRANSFER_MONEY,"RespGiveGold")
end

function HallGiftModel:RemoveProto( ... )
	self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_TRANSFER_MONEY,"RespGiveGold")
end

--请求赠送礼物
function HallGiftModel:ReqGiveGift(id,gold)
    local send={}
    send.m_unSize=0
    send.m_unID = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_unDstUin = id
    send.m_sAccountType=2
    send.m_sTransferReason=8
    send.m_unActionID=os.time()+math.random(0,1000)
    send.m_un64Count= HallGoldRateCToS(tonumber(gold))
    send.m_iTime=os.time()
    local md5=CommonUtil.GenNewMd5SDyPasswd(CommonUtil.ReturnBankPsd(PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord), send.m_iTime, CommonUtil.mstate)
    send.m_szPassword=CommonUtil.StringToByteArrayTable(md5)
    --补齐
    for i=1,32 do
        if send.m_szPassword[i]==nil then
            send.m_szPassword[i]=0
        end
    end
    self.CurrentGiveMoney = send.m_un64Count
    Net_SendHallData(NetworkDefine.ReqTransferAccounts, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_TRANSFER_MONEY, 18)
end

----请求赠送礼物返回
function HallGiftModel:RespGiveGold(buffer)
    if buffer==nil then
		UDebug.Log("buffer==nil")
		return
	end

	local msg=self:ParseMsg(NetworkDefine.RspTransferAccounts,buffer)
	if msg.m_sResult==nil then
		UDebug.Log("msg.m_sResult==nil")
	end
	HallGiftController.GetInstance().view.panel:OnGiveGiftSuccess(msg)
	if msg.m_sResult==0 then
		UIManager:GetInstance():ShowNoteMessage("Hall_Give")
		PlayerInfoController:GetInstance():RequestGetUserMoney()
	else
		
		ServerBackPrompt(msg.m_sResult);
	end
end


function HallGiftModel:__delete()

end