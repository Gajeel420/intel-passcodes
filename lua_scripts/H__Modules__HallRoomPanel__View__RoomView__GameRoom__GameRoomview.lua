GameRoomview = BaseClass(LuaUI)

function GameRoomview:__init(parent,gameId,initCallBack)
    self.parent=parent
    self.initCallBack=initCallBack
    self.assetName = "Hall_RoomPanel"
	self.resPath = "Phone/Prefab/Game/Hall_RoomPanel.unity3d"--资源路径
	self.createCallBack = self.InitUI	
    self.mBool_IsShowNetWorkMessage=false
    resMgr:LoadResourcePackerInfoSet(gameId,nil,nil)
    self.gameId = gameId
	self:CreateUI(gameId)
end

function GameRoomview:InitUI()
    local mTran = self.obj.transform
    self.OnItemCanClickTimes = "GameRoomview.GameRoomview"
    self.obj.transform.parent=self.parent
    self.obj.name = self.assetName

    self.mPanel = self.obj:GetComponent(typeof(UIPanel))

    self.mObj_Back = mTran:Find("Content/RoomView/Button_Exit").gameObject
    UIEventListener.Get(self.mObj_Back).onClick = function() self:OnClickBackButton() end

    self.mLabel_NickName = mTran:Find("Content/RoomView/UserInfo/Player_Info/Info/Label_Name"):GetComponent(typeof(UILabel))
    self.mLabel_ID = mTran:Find("Content/RoomView/UserInfo/Player_Info/Info/Label_ID"):GetComponent(typeof(UILabel))
    self.mText_Head = mTran:Find("Content/RoomView/UserInfo/Player_Info/Info/HeadPortait/Texture_HeadPortait"):GetComponent(typeof(UITexture))
    self.mLabel_Money = mTran:Find("Content/RoomView/UserInfo/Player_Money/Money/Label_Value"):GetComponent(typeof(UILabel))

    self.mGrid_RoolList = mTran:Find("Content/RoomView/ScrollView/Grid"):GetComponent(typeof(UIGrid))
    self.mScrollView = mTran:Find("Content/RoomView/ScrollView"):GetComponent(typeof(UIScrollView))
    self.tbItem = {}
    for i=1,5 do
        local path=StringFormat("Content/RoomView/ScrollView/Grid/Room{0}",i)
        local mTranUI = mTran:Find(path)
        if mTranUI  ~= nil then
            local go=mTranUI.gameObject
            local itemScript=GameRoomItem.New(go)
            self.tbItem[i]=itemScript
        end
    end
    local mobjReader= mTran:Find("Content/RoomView/Tex_BG/Girl").gameObject
    self.mUIRenderQueue = SZUIRenderQueue.New(mobjReader)
    self.mUserInfoPanel =  mTran:Find("Content/RoomView/UserInfo"):GetComponent(typeof(UIPanel))


    PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshUserInof,self)
    if self.initCallBack then
        self.initCallBack(self)
    end
end

---关闭按钮事件
function GameRoomview:OnClickBackButton()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(true)
	SceneManager.GetInstance():OnClickEscapeBack()
end

---显示界面
function GameRoomview:ShowView(data)
   
    self.obj:SetActive(true)
    self:RefreshUserInof()
    self:RefreshView(data)
    SoundManager:GetInstance():PrePlayBGMusic(self.gameId,SoundManager.BGSoundID.bgm)
end

--刷新用户信息
function GameRoomview:RefreshUserInof()
    local mainPlayer=PlayerInfoController:GetInstance().model.mainPlayer
    local name = mainPlayer.szNickName or ""
    self.mLabel_NickName.text = GetUserNickNameUnique(name) 
    self.mLabel_ID.text = StringFormat("ID:{0}",mainPlayer.uiUserID ) 
    self:SetNumberLabel( self.mLabel_Money,mainPlayer.iMoney )
    PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.mText_Head,ConfigInfoMgr.ThirdPlatformHeadURL,1,mainPlayer.iImageNO)
end



function GameRoomview:RefreshView(roomList)
	if roomList==nil then 
		return 
	end
    self:HideAllRoom()
    local total=#roomList
	for i=1,total do
        local roomInfo = roomList[i]
		local item=self.tbItem[roomInfo.uRoomID]
		if item then
            item:SetGridData(roomInfo,i,function()
                self:OnItemClickBack()
            end)
			item:SetVisible(true)
		end
	end
	
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.mGrid_RoolList:Reposition()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.mScrollView:ResetPosition()
	end)
end


function GameRoomview:ReSetItemClickEnabled()
    for i = 1, #self.tbItem do
        self.tbItem[i]:SetCanClick(true)
    end
end

function GameRoomview:OnItemClickBack()
	for i = 1, #self.tbItem do
		self.tbItem[i]:SetCanClick(false)
	end
	RenderMgr.AddInterval(function()
		RenderMgr.Remove(self.OnItemCanClickTimes)
		for i = 1, #self.tbItem do
			self.tbItem[i]:SetCanClick(true)
		end
	end,self.OnItemCanClickTimes,2,2.1)
end

function GameRoomview:HideAllRoom()
	for i = 1, #self.tbItem do
		local item=self.tbItem[i]
		item:SetVisible(false)
	end
end

function GameRoomview:SetPanelDepth(depth)
    depth = UIPanelDefine.SecondLevelPanelStart
    SetPanelstartingRenderQueue(self.obj,depth)
    self.mUIRenderQueue:SetShaderRenderQueue(depth + 12)
    SetPanelstartingRenderQueue(self.mUserInfoPanel.gameObject,depth + 14)
    SetPanelstartingRenderQueue(self.mScrollView.gameObject,depth + 15)
end

function GameRoomview:SetNumberLabel(comlabel,value)
    if not comlabel then return end
    value=value or 0
    comlabel.text=NumberFormat(HallGoldRateSToC(value))
end

function GameRoomview:RefreshRoom()

end

function GameRoomview:RemoveMyData()

end
---
function GameRoomview:HideView()
    --self.obj:SetActive(false)
    RenderMgr.Remove(self.OnItemCanClickTimes)
    for i = 1, #self.tbItem do
        self.tbItem[i]:SetCanClick(true)
    end
end

function GameRoomview:__delete()
    self.obj:SetActive(false)
    RenderMgr.Remove(self.OnItemCanClickTimes)
    PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshUserInof,self)
    SoundManager:GetInstance():PrePlayBGMusic(0,SoundManager.BGSoundID.BGM_Hall)
    self.mPanel = nil
    self.mObj_Back = nil
    self.mLabel_NickName = nil
    self.mLabel_ID =nil
    self.mText_Head =nil
    self.mLabel_Money =nil
    self.mGrid_RoolList = nil
    self.mScrollView = nil
    self.mUIRenderQueue = nil
    self.mUserInfoPanel =  nil
    self.tbItem = nil
    GameObject.Destroy(self.obj)
    self.obj =nil
    resMgr:UnloadGameAssetBundle(self.gameId)
    if ConfigInfoMgr.useHotFunction ~= false then
		LuaManager:RemoveLuaBundle(self.gameId)
	end
	Resources:UnloadUnusedAssets()
end