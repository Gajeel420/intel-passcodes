RoomDeskView_BuYu = RoomDeskView_BuYu or BaseClass(LuaUI)

function RoomDeskView_BuYu:__init(parent,gameId,initCallBack)
    self.parent=parent
    self.initCallBack=initCallBack
	self.assetName = "RoomView_BuYu02"--资源名称
	self.resPath = "Phone/Prefabs/Room/RoomView_BuYu02.unity3d"--资源路径
	self.createCallBack = self.InitUI	
	self.mBool_IsShowNetWorkMessage=false
	self.GameID = gameId
	self:CreateUI(0)
end
--初始化ui界面  ----必须实现
function RoomDeskView_BuYu:InitUI()
    self.m_IsHasTiYanChang = false
    self.m_Tab_RoomList_TiYan = {}
    self.m_Tab_RoomList_Normal = {}
    self.m_CurrentSelectRoom = {}
    self.m_TotalDeskCount = 0
    self.m_CurrentDeskPageIndex = 0
    self.m_CurrentDeskPageCount = 10
    self.m_IsHasGetAllDeskInfo = false
    self.m_AllDeskList = {}
    self.m_StartPos_X = 550 
    self.m_StartPos_Y = -145 
    self.m_Offset_Y = 280
    self.m_Offset_X = 450
    self.m_Offset_Top_X = 100

	local mTran = self.obj.transform
    self.obj.transform.parent=self.parent
    self.mPanel = self.obj:GetComponent(typeof(UIPanel))

    self.mSprite_GameName = mTran:Find("Content/Content/Top/GameName/Sprite"):GetComponent(typeof(UISprite))

    self.mObj_BackButton=mTran:Find("Content/Content/Top/Btn_Back").gameObject
	UIEventListener.Get(self.mObj_BackButton).onClick = function() self:OnClickBackButton() end

    self.mLabel_Money = mTran:Find("Content/Content/Top/Player_Money/Money/Label_Value").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_Money.text = ""

    self.m_PanelScroll = mTran:Find("Content/Content/ScrollView"):GetComponent(typeof(UIPanel))
    self.m_Scroll = mTran:Find("Content/Content/ScrollView"):GetComponent(typeof(UIScrollView))
    self.m_ItemParent = mTran:Find("Content/Content/ScrollView/Grid")
    self.m_ItemPrefab = mTran:Find("Content/Content/ScrollView/Item01").gameObject
    self.m_ItemPrefab:SetActive(false)
    self.m_Scroll.onDragFinished = function() self:OnScrollFinished() end

    --体验场
    self.m_Go_TiYan = mTran:Find("Content/Content/Tiyanchang").gameObject
    UIEventListener.Get(self.m_Go_TiYan).onClick = function() self:OnClickTiYan() end

    --快速开始
    self.m_Btn_Start = mTran:Find("Content/Content/Btn_Start").gameObject
    UIEventListener.Get(self.m_Btn_Start).onClick = function() self:OnClickQuickStart() end

    RoomModel:GetInstance():AddEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
    RoomModel:GetInstance():AddEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)

    if self.initCallBack then
        self.initCallBack(self)
	end
    
end

function RoomDeskView_BuYu:OnClickBackButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.outRoom)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(true)
	SceneManager.GetInstance():OnClickEscapeBack()
    if self.m_CurrentSelectRoom then
        RoomModel:GetInstance():ReqLogoutRoomPara(self.m_CurrentSelectRoom.m_usGameID,self.m_CurrentSelectRoom.uRoomID,0)
    end
end

function RoomDeskView_BuYu:OnClickTiYan()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if self.m_CurrentSelectRoom then
        RoomModel:GetInstance():ReqLogoutRoomPara(self.m_CurrentSelectRoom.m_usGameID,self.m_CurrentSelectRoom.uRoomID,0)
    end
    
    if #self.m_Tab_RoomList_TiYan > 0 then
        RoomModel.GetInstance():OnEnterRoom(self.m_Tab_RoomList_TiYan[1])
    else
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("No_TiYanChang_Tip"))
    end
end

function RoomDeskView_BuYu:OnClickQuickStart()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if self.m_CurrentSelectRoom then
        RoomModel.GetInstance():OnEnterRoom(self.m_CurrentSelectRoom)
    end
end

function RoomDeskView_BuYu:OnScrollFinished()
    if self:GetCurrentTotalDeskCount() >= self.m_TotalDeskCount then
        print("-----------------------没有多余的桌子了")
        return
    end
    local temp = self.m_Scroll.horizontalScrollBar.value
    -- print("----------------------------- 滑动结束  ",temp)
    if temp > 0.5 then
        --请求下一页
        self:SendNextPage()
    end
end

function RoomDeskView_BuYu:SendNextPage()
    if self.m_CurrentSelectRoom then
        self.m_CurrentDeskPageIndex = self.m_CurrentDeskPageIndex  + self.m_CurrentDeskPageCount
        self:SendReqDeskPlayerList()
    end
end

function RoomDeskView_BuYu:RemoveMyData()

end

function RoomDeskView_BuYu:ShowView(data)
	self.obj:SetActive(true) 
	self:RefreshUserInof()
    self:ClearAllDesk()
    UIManager:GetInstance():ShowNetWorkMessage("","",1)
    RenderMgr.Remove("RoomDeskView_BuYu:RefreshView")
    RenderMgr.AddInterval(function ()
        RenderMgr.Remove("RoomDeskView_BuYu:RefreshView")
        self:RefreshView(data)
    end,"RoomDeskView_BuYu:RefreshView",1,1.5)
end


function RoomDeskView_BuYu:RefreshUserInof()
	local mainPlayer=PlayerInfoController:GetInstance().model.mainPlayer
	SetNumberLabel( self.mLabel_Money,mainPlayer.iMoney )
end

function RoomDeskView_BuYu:RefreshRoom()
	
end

function RoomDeskView_BuYu:PlayerEnterRoom(context)
    local userInfo=context
    -- print("------------------------------   玩家坐下 userInfo ==  ")
    -- pt(userInfo)
    if userInfo and  self.m_AllDeskList and self.m_AllDeskList[userInfo.iDeskNO + 1] then
        self.m_AllDeskList[userInfo.iDeskNO + 1]:PlayerSitDown(userInfo)
    end
end

function RoomDeskView_BuYu:PlayerLeaveRoom(context)
    local userInfo=context
    -- print("------------------------------   玩家离开 userInfo ==  ")
    -- pt(userInfo)
    if userInfo and self.m_AllDeskList and self.m_AllDeskList[userInfo.m_usDeskIndex + 1] then
        self.m_AllDeskList[userInfo.m_usDeskIndex + 1]:PlayerLeaveSeat(userInfo)
    end
end

function RoomDeskView_BuYu:HideAllRoom()

end

--重新刷新
function RoomDeskView_BuYu:RerefreshView_OffLine()
    self.m_IsHasGetAllDeskInfo = true
    self.m_CurrentDeskPageIndex = 0
    HallRoomPanelModel:GetInstance().IsCanClickSeat = true
    self:ClearAllDesk()
    self:SendReqDeskPlayerList()
end

function RoomDeskView_BuYu:SendReqDeskPlayerList()
    if self.m_CurrentSelectRoom then
        RoomModel.GetInstance():AddEventListener(RoomModel.EventType.RsqDeskPlayerListNewData,self.ShowDeskListData,self)
        RoomController:GetInstance():ReqDeskPlayerListNew(self.m_CurrentSelectRoom.uRoomID, self.m_CurrentDeskPageIndex, 
            self.m_CurrentDeskPageCount, self.m_CurrentSelectRoom.m_usGameID)
    end
end

function RoomDeskView_BuYu:RefreshView(roomList)
    local roomName = StringFormat("Hall_GameName_{0}_EN",roomList[1].uNameID)
	self.mSprite_GameName.spriteName = roomName
	-- print("-----------------------------------   RefreshView  roomList  ==   ")
    -- pt(roomList)
    self:HandleRoomData(roomList)
    self:RerefreshView_OffLine()
end

function RoomDeskView_BuYu:ClearAllDesk()
    for i = 1, #self.m_AllDeskList do
        self.m_AllDeskList[i]:SetObjActive(false)
    end
end

function RoomDeskView_BuYu:ShowDeskListData(datas)
    RoomModel.GetInstance():RemoveEventListener(RoomModel.EventType.RsqDeskPlayerListNewData,self.ShowDeskListData,self)
    -- print("------------------------------   准备刷新桌子数据")
    -- pt(datas)
    local destStartIndex = datas.m_uDeskIndex
    local deskDataList = datas.m_DeskUserInfo
    for i = 1, #deskDataList do
        destStartIndex = destStartIndex + 1
        if not self.m_AllDeskList[destStartIndex] then
            go = InstantiateNewGameObject(self.m_ItemPrefab, self.m_ItemParent,destStartIndex)
            self.m_AllDeskList[destStartIndex] = DeskItem_BuYu.New(go)
            self.m_AllDeskList[destStartIndex]:InitIndex(destStartIndex - 1)
            --处理位置
            local index_Temp = math.ceil(destStartIndex/2)
            local IsTop = (destStartIndex%2) == 0
            local x = 0
            local y = 0
            if IsTop then
                x = self.m_StartPos_X + (index_Temp-1) * self.m_Offset_X + self.m_Offset_Top_X
                y = self.m_StartPos_Y + self.m_Offset_Y
            else
                x = self.m_StartPos_X + (index_Temp-1) * self.m_Offset_X
                y = self.m_StartPos_Y
            end
            self.m_AllDeskList[destStartIndex]:SetSizeInfo(x,y,IsTop)
        end
       
        self.m_AllDeskList[destStartIndex]:SetData(deskDataList[i],self.m_CurrentSelectRoom)
    end
    
    self.m_IsHasGetAllDeskInfo = datas.m_ucSendFlag == 0   --//分包标志 0  发完     1 后面还有包

    if self.m_CurrentDeskPageIndex == 0 then
        self.m_Scroll:ResetPosition()

        --请求下一张桌子
        RenderMgr.Remove("RoomDeskView_BuYu:NextDesk")
        RenderMgr.AddInterval(function ()
            RenderMgr.Remove("RoomDeskView_BuYu:NextDesk")
            self:SendNextPage()
        end,"RoomDeskView_BuYu:NextDesk",1,1.5)
    end
end

--处理房间数据
function RoomDeskView_BuYu:HandleRoomData(roomList)
    self.m_Tab_RoomList_TiYan = {}
    self.m_Tab_RoomList_Normal = {}
    for i = 1, #roomList do
        local data = roomList[i]
        if data.m_nFlag == HallDefine.GameRoomFlag.TiYanChang then
            table.insert(self.m_Tab_RoomList_TiYan, data)
        elseif roomList[i].m_nFlag == HallDefine.GameRoomFlag.Normal then
            table.insert(self.m_Tab_RoomList_Normal, data)
        end
    end

    self.m_IsHasTiYanChang = false
    if #self.m_Tab_RoomList_TiYan > 0 then
        self.m_IsHasTiYanChang = true
    end
    self.m_CurrentSelectRoom = nil
    if #self.m_Tab_RoomList_Normal > 0 then
        self.m_CurrentSelectRoom = self.m_Tab_RoomList_Normal[1]
        self.m_TotalDeskCount  = self.m_CurrentSelectRoom.uDeskCount
        RoomModel:GetInstance().CurrentRoomInfo =  self.m_CurrentSelectRoom
    end
end


function RoomDeskView_BuYu:SetPanelDepth(depth)
	self.mPanel.depth = depth + 10
    self.m_PanelScroll.depth = depth + 11
end

function RoomDeskView_BuYu:HideView()
    RenderMgr.Remove("RoomDeskView_BuYu:RefreshView")
    RenderMgr.Remove("RoomDeskView_BuYu:NextDesk")
	self.obj:SetActive(false) 
end

function RoomDeskView_BuYu:GetCurrentTotalDeskCount()
    local index = 0
    for i = 1, #self.m_AllDeskList do
        if self.m_AllDeskList[i].obj.activeSelf then
            index = index + 1
        end
    end
    return index
end

function RoomDeskView_BuYu:__delete( ... )
    RoomModel:GetInstance():RemoveEventListener(RoomConst.PlayerEnterRoom,self.PlayerEnterRoom,self)
    RoomModel:GetInstance():RemoveEventListener(RoomConst.PlayerLeaveRoom,self.PlayerLeaveRoom,self)
    self.mSprite_GameName = nil
	self.obj:SetActive(false) 
	GameObject.Destroy(self.obj)
	self.obj =nil
	resMgr:UnloadGameAssetBundle(self.GameID)
	if ConfigInfoMgr.useHotFunction ~= false then
		LuaManager:RemoveLuaBundle(self.GameID)
	end
	Resources:UnloadUnusedAssets()	
end

function RoomDeskView_BuYu:DestroyObj( ... )
	GameObject.Destroy(self.obj)
	self.obj =nil
end
