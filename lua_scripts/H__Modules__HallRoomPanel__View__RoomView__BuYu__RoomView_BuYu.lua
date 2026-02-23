RoomView_BuYu = RoomView_BuYu or BaseClass(LuaUI)

function RoomView_BuYu:__init(parent,gameId,initCallBack)
    self.parent=parent
    self.initCallBack=initCallBack
	self.assetName = "RoomView_BuYu"--资源名称
	self.resPath = "Phone/Prefabs/Room/RoomView_BuYu.unity3d"--资源路径
	self.createCallBack = self.InitUI	
	self.mBool_IsShowNetWorkMessage=false
	self.GameID = gameId
	self:CreateUI(0)
end
--初始化ui界面  ----必须实现
function RoomView_BuYu:InitUI()
	local mTran = self.obj.transform
	self.OnItemCanClickTimes = "RoomView_BuYu.OnItemCanClickTimes"
	self.mPanel = self.obj:GetComponent(typeof(UIPanel))
    self.obj.transform.parent=self.parent
	self.mTransform_Content=mTran:Find("Content")
	self.mTweenAlpha = mTran:Find("Content/Content").gameObject:GetComponent(typeof(TweenAlpha))
    self.mWidget_Content=mTran:Find("Content"):GetComponent(typeof(UIWidget))
    self.mWidget_Content:ResetAndUpdateAnchors()
    --self.mSprite_GameName = mTran:Find("Content/Content/Top/GameName/Sprite").gameObject:GetComponent(typeof(UISprite))
    self.mSprite_GameName = mTran:Find("Content/Content/Top/GameName/Sprite"):GetComponent(typeof(UISprite))
	self.mGrid_ItemGrid= mTran:Find("Content/Content/ScrollView/Grid"):GetComponent(typeof(UIGrid))
	self.mScrollView =  mTran:Find("Content/Content/ScrollView"):GetComponent(typeof(UIScrollView))
	self.tbItem={}
	for i=1,5 do
		local path=StringFormat("Content/Content/ScrollView/Grid/Room{0}",i)
		local go=mTran:Find(path).gameObject
		local itemScript=UIRoomGrid.New(go)
		self.tbItem[i]=itemScript
	end
	self.mObj_BackButton=mTran:Find("Content/Content/Top/Btn_Back").gameObject
	UIEventListener.Get(self.mObj_BackButton).onClick = function() self:OnClickBackButton() end

	self.topPanel=mTran:Find("Content/Content/Top").gameObject

	self.mLabel_Money = mTran:Find("Content/Content/Top/Player_Money/Money/Label_Value").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_Money.text = ""
	--PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshUserInof,self)
    --初始化动画
	local list_tweenList={}
    local tweenPosition_bottom=mTran:Find("Content/Content"):GetComponent(typeof(TweenAlpha))
	table.insert(list_tweenList, tweenPosition_bottom)
	local tweenPosition_Top=mTran:Find("Content/Content/Top/Btn_Back"):GetComponent(typeof(TweenAlpha))
    table.insert(list_tweenList, tweenPosition_Top)
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	
    if self.initCallBack then
        self.initCallBack(self)
	end
end

function RoomView_BuYu:OnClickBackButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.outRoom)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(true)
	SceneManager.GetInstance():OnClickEscapeBack()
end

function RoomView_BuYu:RemoveMyData()

end

function RoomView_BuYu:ShowView(data)
	self.obj:SetActive(true) 
	self:RefreshUserInof()
	self:RefreshView(data)
	self:ReSetItemClickEnabled()
    -- StartCoroutine(function ()
    --     yield_return(CS.UnityEngine.WaitForEndOfFrame())
    --     self.mTweenPlayer:ParallelPlay(false)
    -- end)
end


function RoomView_BuYu:RefreshUserInof()
	local mainPlayer=PlayerInfoController:GetInstance().model.mainPlayer
	SetNumberLabel( self.mLabel_Money,mainPlayer.iMoney )
end


function RoomView_BuYu:HideAllRoom()
	for i = 1, #self.tbItem do
		local item=self.tbItem[i]
		item:SetVisible(false)
	end
end

function RoomView_BuYu:RefreshView(roomList)
	if roomList==nil then 
		return 
	end
	self:HideAllRoom()
	local total=#roomList
	print("房间列表个数aaaaaaaaaaaaa   ",total)
	pt(roomList)
	for i=1,total do
		--print("rrrrrrrrrrrrrrrrrrr11111111111111111111111111111111111")
		local roomInfo = roomList[i]
		local item=self.tbItem[i]
		if item then
			--print("rrrrrrrrrrrrrrrrr222222222222222222222222222222222")
			item:SetGridData(roomInfo,i,function()
				self:OnItemClickBack()
			end)
			item:SetVisible(true)
		end
	end
	local roomName = StringFormat("Hall_GameName_{0}_EN",roomList[1].uNameID)
	self.mSprite_GameName.spriteName = roomName
	self.mGrid_ItemGrid.enabled = true
	self.mGrid_ItemGrid:Reposition()
	-- StartCoroutine(function()
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	self.mGrid_ItemGrid:Reposition()
	-- end)
end

function RoomView_BuYu:OnItemClickBack()
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

function RoomView_BuYu:ReSetItemClickEnabled()
    for i = 1, #self.tbItem do
        self.tbItem[i]:SetCanClick(true)
    end
end

function RoomView_BuYu:SetPanelDepth(depth)
	--self.mPanel.depth = depth + 10
	depth = 3500
	SetPanelstartingRenderQueue(self.mPanel.gameObject,depth + 10)
	SetPanelstartingRenderQueue(self.mScrollView.gameObject,depth +15)
	SetPanelstartingRenderQueue(self.topPanel,depth +15)
	
	--self.mScrollView:GetComponent(typeof(UIPanel)).depth = depth + 11
end

function RoomView_BuYu:RefreshRoom()
	
end

function RoomView_BuYu:HideView()
	self.obj:SetActive(false) 
	--self.mTweenPlayer:ParallelPlay(true)
	RenderMgr.Remove(self.OnItemCanClickTimes)
	-- for i = 1, #self.tbItem do
	-- 	self.tbItem[i]:SetCanClick(true)
	-- end 
end

function RoomView_BuYu:__delete( ... )
	--self.vo = nil
	PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshUserInof,self)
	self.obj:SetActive(false) 
	RenderMgr.Remove(self.OnItemCanClickTimes)
	self.mPanel = nil
    self.mScrollView = nil
	self.tbItem = nil
	self.mSprite_GameName = nil
	self.mGrid_ItemGrid = nil
	self.mObj_BackButton = nil
	self.mTweenPlayer = nil
	GameObject.Destroy(self.obj)
	self.obj =nil
	resMgr:UnloadGameAssetBundle(self.GameID)
	if ConfigInfoMgr.useHotFunction ~= false then
		LuaManager:RemoveLuaBundle(self.GameID)
	end
	Resources:UnloadUnusedAssets()	
end


