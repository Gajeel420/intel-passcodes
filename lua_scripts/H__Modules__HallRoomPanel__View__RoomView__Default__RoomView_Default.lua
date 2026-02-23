RoomView_Default = RoomView_Default or BaseClass(LuaUI)

function RoomView_Default:__init(parent,gameId,initCallBack)
    self.parent=parent
    self.initCallBack=initCallBack
	self.assetName = "RoomView_Default"--资源名称
	self.resPath = "Phone/Prefabs/Room/RoomView_Default.unity3d"--资源路径
	self.createCallBack = self.InitUI
	self.gameID = gameId
	self:CreateUI(0)
	
end
--初始化ui界面  ----必须实现
function RoomView_Default:InitUI()
	self.OnItemCanClickTimes = "RoomView_Default.OnItemCanClickTimes"
	local mTran = self.obj.transform
	self.mPanel = self.obj:GetComponent(typeof(UIPanel))
    self.obj.transform.parent=self.parent

	self.mSprite_GameName = mTran:Find("Content/Content/Top/GameName/Sprite"):GetComponent(typeof(UISprite))
    
	self.mGrid_ItemGrid= mTran:Find("Content/Content/ScrollView/Grid"):GetComponent(typeof(UIGrid))
	self.tbItem={}
	self.mScrollView =  mTran:Find("Content/Content/ScrollView"):GetComponent(typeof(UIScrollView))
	for i=1,5 do
		local path=StringFormat("Content/Content/ScrollView/Grid/Room{0}",i)
		local go=mTran:Find(path).gameObject
		local itemScript=UIRoomGrid.New(go)
		self.tbItem[i]=itemScript
	end
	self.mObj_BackButton=mTran:Find("Content/Content/Top/Btn_Back").gameObject
	UIEventListener.Get(self.mObj_BackButton).onClick = function() self:OnClickBackButton() end

	self.mLabel_Money = mTran:Find("Content/Content/Top/Player_Money/Money/Label_Value").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_Money.text = ""

	self.mTopPanle = mTran:Find("Content/Content/Top").gameObject
	
	--初始化动画
	-- local list_tweenList={}
    -- local tweenPosition_bottom=mTran:Find("Content/Content"):GetComponent(typeof(TweenAlpha))
	-- table.insert(list_tweenList, tweenPosition_bottom)
	-- local tweenPosition_Top=mTran:Find("Content/Content/Top/Btn_Back"):GetComponent(typeof(TweenAlpha))
    -- table.insert(list_tweenList, tweenPosition_Top)
	-- self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	--PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.RefreshUserInof,self)
	
    if self.initCallBack then
    
        self.initCallBack(self)
    end
end


function RoomView_Default:OnClickBackButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.outRoom)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(true)
	SceneManager.GetInstance():OnClickEscapeBack()
end

function RoomView_Default:RemoveMyData()

end


function RoomView_Default:ShowView(data)
	self.obj:SetActive(true)
	self:RefreshUserInof()
	self:RefreshView(data)
	self:ReSetItemClickEnabled()
    -- StartCoroutine(function ()
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
		
    --     self.mTweenPlayer:ParallelPlay(false)
    -- end)

end


function RoomView_Default:HideAllRoom()
	
	for i = 1, #self.tbItem do
		local item=self.tbItem[i]
		item:SetVisible(false)
	end
end


function RoomView_Default:RefreshUserInof()
	local mainPlayer=PlayerInfoController:GetInstance().model.mainPlayer
	SetNumberLabel( self.mLabel_Money,mainPlayer.iMoney )
end

function RoomView_Default:RefreshView(roomList)
	if roomList==nil then 
		return 
	end
	
	self:HideAllRoom()
	local total=#roomList
	-- if total > 3 then
	-- 	self.mGrid_ItemGrid.pivot = UIWidget.Pivot.Left
	-- 	self.mScrollView.contentPivot= UIWidget.Pivot.Left;
	-- else
	-- 	self.mGrid_ItemGrid.pivot = UIWidget.Pivot.Center
	-- 	self.mScrollView.contentPivot= UIWidget.Pivot.Center;
	-- end
	print("房间列表个数aaaaaaaaaaaaa   ",total)
	pt(roomList)
	for i=1,total do
		local roomInfo = roomList[i]
		local item=self.tbItem[i]
		if item then
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
	--self.mScrollView:ResetPosition()
	-- StartCoroutine(function()
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	yield_return(CS.UnityEngine.WaitForEndOfFrame())
	-- 	self.mScrollView:ResetPosition()
	-- end)
	
end

function RoomView_Default:OnItemClickBack()
	print("llllllllllllllllllllllllkkkkkkkkkkkkkkkkk111111111111111")
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

function RoomView_Default:ReSetItemClickEnabled()
    for i = 1, #self.tbItem do
        self.tbItem[i]:SetCanClick(true)
    end
end

function RoomView_Default:RefreshRoom()

end




function RoomView_Default:SetPanelDepth(depth)
	depth = 3500
	SetPanelstartingRenderQueue(self.obj,depth+10)
	SetPanelstartingRenderQueue(self.mScrollView.gameObject,depth+15)
	SetPanelstartingRenderQueue(self.mTopPanle,depth+15)
	
	--self.mPanel.depth = depth + 10
	--self.mScrollView:GetComponent(typeof(UIPanel)).depth = depth + 11
end

function RoomView_Default:HideView()
	self.obj:SetActive(false) 
	RenderMgr.Remove(self.OnItemCanClickTimes)
	-- for i = 1, #self.tbItem do
	-- 	self.tbItem[i]:SetCanClick(true)
	-- end 
end

function RoomView_Default:__delete( ... )
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
	resMgr:UnloadGameAssetBundle(self.gameID)
	if ConfigInfoMgr.useHotFunction ~= false then
		LuaManager:RemoveLuaBundle(self.gameID)
	end
	Resources:UnloadUnusedAssets()
end
