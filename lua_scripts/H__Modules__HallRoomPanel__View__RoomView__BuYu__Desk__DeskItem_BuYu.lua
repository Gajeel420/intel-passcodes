DeskItem_BuYu=DeskItem_BuYu or BaseClass()

function DeskItem_BuYu:__init( obj )
	self.obj=obj
    self:InitUI()
end

function DeskItem_BuYu:InitUI()
    self.m_RoomID = 0    --房间ID
    self.m_GameID = 0    --游戏ID
    self.m_nFlag = 0    
    self.m_sDeskNum = 0

    self.m_AllSeatList = {}
    self.m_DeskSeatCount = 6
	local mTran = self.obj.transform

    for i = 1, self.m_DeskSeatCount do
        local go = mTran:Find("Content/0"..i).gameObject
        self.m_AllSeatList[i] = SeatItem_BuYu.New(go)
        self.m_AllSeatList[i]:InitIndex(i-1)
    end
    self.m_Label_DeskNum = mTran:Find("Content/Common/Desk/Label"):GetComponent(typeof(UILabel))
    self.m_Label_DeskNum.text = "01"
	self:AddEvent()
end


function DeskItem_BuYu:AddEvent()

end


function DeskItem_BuYu:InitIndex(index)
    self.m_sDeskNum = index
    if self.m_sDeskNum + 1 < 10 then
        self.m_Label_DeskNum.text = "0"..self.m_sDeskNum + 1
    else
        self.m_Label_DeskNum.text = self.m_sDeskNum + 1
    end
end






function DeskItem_BuYu:SetData(data,roomInfo)
    self.m_RoomID = roomInfo.uRoomID
    self.m_GameID = roomInfo.m_usGameID
    self.m_nFlag = roomInfo.m_nFlag
    self.m_DeskPeople = roomInfo.uDeskPeople
    self:ResetAllViewData()

    for i = 1, #data.m_szUserInfoStruct do
        local seatNum = data.m_szUserInfoStruct[i].m_bDeskStation + 1
        if seatNum <= self.m_DeskSeatCount then
            self.m_AllSeatList[seatNum]:SetData(data.m_szUserInfoStruct[i])
        end
    end
    self:SetObjActive(true)
end

function DeskItem_BuYu:ResetAllViewData()
    for i = 1, self.m_DeskSeatCount do
        self.m_AllSeatList[i]:ResetViewData(self.m_RoomID ,self.m_GameID,self.m_sDeskNum,self.m_nFlag)
    end
    --处理4 、6 人桌
    if self.m_DeskPeople == 4 then
        self.m_AllSeatList[5]:SetObjActive(false)
        self.m_AllSeatList[6]:SetObjActive(false)
    else
        self.m_AllSeatList[5]:SetObjActive(true)
        self.m_AllSeatList[6]:SetObjActive(true)
    end
end

function DeskItem_BuYu:SetSizeInfo(x,y,isTop)
    self:SetSize(isTop)
    self:SetPos(x,y)
end

function DeskItem_BuYu:SetObjActive(bol)
    self.obj:SetActive(bol)
end

function DeskItem_BuYu:SetPos(x,y)
    self.obj.transform.localPosition = Vector3(x,y,0)
end

function DeskItem_BuYu:SetSize(isTop)
    if isTop then
        self.obj.transform.localScale = Vector3.one * 0.83
    else
        self.obj.transform.localScale = Vector3.one
    end
end

function DeskItem_BuYu:PlayerSitDown(userInfo)
    if self.m_AllSeatList[userInfo.iDeskStation + 1] then
        self.m_AllSeatList[userInfo.iDeskStation + 1]:PlayerSitDown(userInfo)
    end
end

function DeskItem_BuYu:PlayerLeaveSeat(userInfo)
    if self.m_AllSeatList[userInfo.m_usDeskStation + 1] then
        self.m_AllSeatList[userInfo.m_usDeskStation + 1]:PlayerLeaveSeat(userInfo)
    end
end

function DeskItem_BuYu:__delete( )
end

