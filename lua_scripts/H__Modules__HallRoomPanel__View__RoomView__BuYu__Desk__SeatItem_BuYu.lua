SeatItem_BuYu=DeskItem_BuYu or BaseClass()

function SeatItem_BuYu:__init( obj )
	self.obj=obj
    self:InitUI()
end

function SeatItem_BuYu:InitUI()
    self.m_DeskNum = 0   --桌子编号
    self.m_SeatNum = 0   --座位号
    self.m_RoomID = 0    --房间ID
    self.m_GameID = 0    --游戏ID
	local mTran = self.obj.transform
    self.m_Go_Tips = mTran:Find("Tips").gameObject
    self.m_Go_People = mTran:Find("People").gameObject
    self.m_AllPeople = {}
    for i = 1, 4 do
        self.m_AllPeople[i] =  mTran:Find("People/0"..i).gameObject
    end
	self:AddEvent()
end

function SeatItem_BuYu:InitIndex(index)
    self.m_SeatNum = index   --座位号
end


function SeatItem_BuYu:AddEvent()
    UIEventListener.Get(self.m_Go_Tips).onClick = function ()
        self:OnClickSeat()
    end
end

function SeatItem_BuYu:SetData(data)
    print("-----------------------------------------  SeatItem_BuYu:SetData ")
    pt(data)
    self.m_Go_Tips:SetActive(false)
    self.m_Go_People:SetActive(true)
    self:SetPlayerSexPeople(data.m_sSex)
end


function SeatItem_BuYu:SetObjActive(bol)
    self.obj:SetActive(bol)
end

function SeatItem_BuYu:ResetViewData(roomID, gameID, deskNum,mFlag)
    self.m_Go_Tips:SetActive(true)
    self.m_Go_People:SetActive(false)
    self.m_DeskNum = deskNum   --桌子编号
    self.m_RoomID = roomID    --房间ID
    self.m_GameID = gameID    --游戏ID
    self.m_nFlag = mFlag
end


function SeatItem_BuYu:__delete( )
    RenderMgr.Remove("SeatItem_BuYu:OnClickSeat")
end

function SeatItem_BuYu:OnClickSeat()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if not  HallRoomPanelModel:GetInstance().IsCanClickSeat then
        return
    end

    local send = {}
    send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_usGameID = self.m_GameID or 0
    send.m_usRoomID = self.m_RoomID or 0
    send.m_usDeskIndex = self.m_DeskNum
    send.m_bDeskStation = self.m_SeatNum
    send.m_iMoney = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
    send.m_bFlag =  self.m_nFlag
    send.m_szNickName= {}
    local temp = CommonUtil.StringToByteArrayTable(PlayerInfoController:GetInstance().model.mainPlayer.szNickName or "")
    for i = 1, HallDefine.ConstDefine.MAX_NICK_LEN do
        send.m_szNickName[i] = temp[i] or 0
    end
    if PlayerInfoController:GetInstance().model.mainPlayer.bBoy then
        send.m_usSex = 1
    else
        send.m_usSex = 0
    end
	RoomController:GetInstance():ReqChooseDeskEnterGame2(send)

    self.m_Go_Tips:SetActive(false)
    HallRoomPanelModel:GetInstance().IsCanClickSeat = false
    RenderMgr.Remove("SeatItem_BuYu:OnClickSeat")
    RenderMgr.AddInterval(function ()
        RenderMgr.Remove("SeatItem_BuYu:OnClickSeat")
        if  self.m_Go_Tips then
            self.m_Go_Tips:SetActive(true)
        end
        HallRoomPanelModel:GetInstance().IsCanClickSeat = true
    end,"SeatItem_BuYu:OnClickSeat",5,5.5)
end

function SeatItem_BuYu:PlayerSitDown(userInfo)
    self.m_Go_Tips:SetActive(false)
    self.m_Go_People:SetActive(true)
    if userInfo.bBoy then
        self:SetPlayerSexPeople(1)
    else
        self:SetPlayerSexPeople(0)
    end
end

function SeatItem_BuYu:PlayerLeaveSeat(userInfo)
    self.m_Go_Tips:SetActive(true)
    self.m_Go_People:SetActive(false)
end

function SeatItem_BuYu:SetPlayerSexPeople(sex)
    local num
    if sex == 1 then  --男
        num = math.random(1,2)
    else
        num = math.random(3,4)
    end
    
    for i = 1, #self.m_AllPeople do
        if num == i then
            self.m_AllPeople[i]:SetActive(true)
        else
            self.m_AllPeople[i]:SetActive(false)
        end
    end
end