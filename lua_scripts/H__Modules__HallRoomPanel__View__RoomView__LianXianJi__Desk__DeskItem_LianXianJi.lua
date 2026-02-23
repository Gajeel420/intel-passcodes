DeskItem_LianXianJi=DeskItem_LianXianJi or BaseClass()

function DeskItem_LianXianJi:__init( obj )
	self.obj=obj
    self:InitUI()
end

function DeskItem_LianXianJi:InitUI()
    self.m_RoomID = 0    --房间ID
    self.m_GameID = 0    --游戏ID
    self.m_nFlag = 0    
    self.m_sDeskNum = 0

    self.m_AllSeatList = {}
    self.m_DeskSeatCount = 1
	local mTran = self.obj.transform

    for i = 1, self.m_DeskSeatCount do
        local go = mTran:Find("Content/0"..i).gameObject
        self.m_AllSeatList[i] = SeatItem_LianXianJi.New(go)
        self.m_AllSeatList[i]:InitIndex(i-1)
    end

    self.m_Sprite_Icon = mTran:Find("Content/Common/SlotIcon"):GetComponent(typeof(UISprite))
	self:AddEvent()
end


function DeskItem_LianXianJi:AddEvent()

end


function DeskItem_LianXianJi:InitIndex(index)
    self.m_sDeskNum = index
end






function DeskItem_LianXianJi:SetData(data,roomInfo)
    self.m_RoomID = roomInfo.uRoomID
    self.m_GameID = roomInfo.m_usGameID
    self.m_nFlag = roomInfo.m_nFlag
    self.m_DeskPeople = roomInfo.uDeskPeople
    self.m_Sprite_Icon.spriteName = "SlotIcon_"..roomInfo.uNameID
    self:ResetAllViewData()

    for i = 1, #data.m_szUserInfoStruct do
        local seatNum = data.m_szUserInfoStruct[i].m_bDeskStation + 1
        if seatNum <= self.m_DeskSeatCount then
            self.m_AllSeatList[seatNum]:SetData(data.m_szUserInfoStruct[i])
        end
    end
    self:SetObjActive(true)
end

function DeskItem_LianXianJi:ResetAllViewData()
    for i = 1, self.m_DeskSeatCount do
        self.m_AllSeatList[i]:ResetViewData(self.m_RoomID ,self.m_GameID,self.m_sDeskNum,self.m_nFlag)
    end
end

function DeskItem_LianXianJi:SetSizeInfo(x,y)
    self:SetPos(x,y)
end

function DeskItem_LianXianJi:SetObjActive(bol)
    self.obj:SetActive(bol)
end

function DeskItem_LianXianJi:SetPos(x,y)
    self.obj.transform.localPosition = Vector3(x,y,0)
end

function DeskItem_LianXianJi:PlayerSitDown(userInfo)
    if self.m_AllSeatList[userInfo.iDeskStation + 1] then
        self.m_AllSeatList[userInfo.iDeskStation + 1]:PlayerSitDown(userInfo)
    end
end

function DeskItem_LianXianJi:PlayerLeaveSeat(userInfo)
    if self.m_AllSeatList[userInfo.m_usDeskStation + 1] then
        self.m_AllSeatList[userInfo.m_usDeskStation + 1]:PlayerLeaveSeat(userInfo)
    end
end

function DeskItem_LianXianJi:__delete( )
end

