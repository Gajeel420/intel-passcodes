HallRoomPanelPanel = HallRoomPanelPanel or BaseClass(LuaPanel)

function HallRoomPanelPanel:__init(callBack)
	self.mPanelType = UIPanelDefine.PanelType.FullScreenSecondLevel
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRoom].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallRoom].path
	self.mPanelID = UIPanelDefine.EWndID.HallRoom
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallRoomPanelPanel:InitUI()
	self.mIsRositive = false
	local mTran = self.obj.transform
	self.mTransform_Content=mTran:Find("Content")
    self.mWidget_Content=mTran:Find("Content"):GetComponent(typeof(UIWidget))
	self.mWidget_Content:ResetAndUpdateAnchors()
	self.mWidget_Content.alpha = 0

	self.mTweenAlpha = mTran:Find("Content"):GetComponent(typeof(TweenAlpha))
	self.mTweenAlpha:SetOnFinished(function(bool)
		self:OnTweenAlphaFinished()
	end)

	self.mTransform_RoomViewParent=mTran:Find("Content/RoomView")
	self.mRoomView_CurrentView=nil
	self.mTable_RoomViewTable={}

	self.mTable_GameRoomViewList = {}
	self.IsDestroyGameResource = false
	self.mRoomList = nil

	for i=1,2 do
		---print("ccccccccccccccccccccc1111111111111111111111111    ",self:GetPanelDepth())
		--self:CreateRoomView(i)
		self:CreateRoomView(i,0,function (view)
			self:AddRoomView(view,i,0)
			view:SetPanelDepth(self:GetPanelDepth())
			
		end)

	end
	LuaPanel.InitUI(self)

end

--- 播放tween动画
--- @param isReverse bool 是否正向播放
function HallRoomPanelPanel:PlayTweenAni(isRositive)
	self.mIsRositive = isRositive
	self.mTweenAlpha.enabled=true
	if isRositive then
		self.mTweenAlpha.duration = 1
		self.mTweenAlpha.from = 1
		self.mTweenAlpha.to = 1
	else
		self.mTweenAlpha.duration = 0.3
		self.mTweenAlpha.from = 1
		self.mTweenAlpha.to = 0
	end
	self.mTweenAlpha:ResetToBeginning()
	self.mTweenAlpha:PlayForward()
end

--- tweenAlpha 动画播放完成回调
function HallRoomPanelPanel:OnTweenAlphaFinished()
	if not self.mIsRositive then
		--self:HideAllRoomView()
		LuaPanel.HidePanel(self)
	end
end

--- 隐藏所有Roompanel
function HallRoomPanelPanel:HideAllRoomView()
	for i = 1, #HallRoomPanelPanel.RoomView do
		if self.mTable_RoomViewTable[i] ~= nil then
			self.mTable_RoomViewTable[i]:HideView()
		end
	end
end


function HallRoomPanelPanel:AddRoomView(roomView,index,gameID)
	-- if index > 2 then 
	-- 	index = 1 
	-- end
	--print("dddddddddddddddddddddd    ",index)
	self.mTable_RoomViewTable[index]=roomView
end

function HallRoomPanelPanel:GetRoomView(index,gameID)
	-- if index > 2 then 
	-- 	index = 1
	-- end
	return self.mTable_RoomViewTable[index]
end

function HallRoomPanelPanel:CreateRoomView(index,gameID,callback)
	-- if index > 2 then 
	-- 	index = 1
	-- end
	local viewClass=HallRoomPanelPanel.RoomView[index]
	local view=viewClass.New(self.mTransform_RoomViewParent,gameID,callback)
end


--创建房间列表
function HallRoomPanelPanel:CreateRoomList( roomList )
	self.mRoomList = roomList
	local room_1=roomList[1]
	local viewIndex=ConfigModuleModel.GetInstance():GetGameConfigByCID(room_1.uNameID).iRoomIndex
	self:HideAllRoomView()
	print("CCCCCCCCCCCCCCCCCCCCC44444444444444444  ",viewIndex,"     ",room_1.uNameID)
	local view= self:GetRoomView(viewIndex,room_1.uNameID)
	if view==nil then
		print("ccccccccccccccccccccc222222222222222222222")
		self:CreateRoomView(viewIndex,room_1.uNameID,function (view)
			self:AddRoomView(view,viewIndex,room_1.uNameID)
			view:SetPanelDepth(self:GetPanelDepth())
			view:ShowView(roomList)
		end)
	else
		print("ccccccccccccccccccccc33333333333333333333333")
		view:ShowView(roomList)
	end
end


function HallRoomPanelPanel:ShowPanel( callBack )
	self.IsDestroyGameResource = false
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.enterRoom)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.enterRoom)
	LuaPanel.ShowPanel(self,callBack)
	self:PlayTweenAni(true)
end

function HallRoomPanelPanel:OnReLoginSuccess( )
	if self.mRoomView_CurrentView~=nil then
		self.mRoomView_CurrentView:RefreshRoom()
	end
end

function HallRoomPanelPanel:OnApplicationFocus( )
	if self.mRoomView_CurrentView~=nil then
		self.mRoomView_CurrentView:RefreshRoom()
	end
end



function HallRoomPanelPanel:HidePanel()
	--LuaPanel.HidePanel(self)
	print("bbbbbbbbbbbb3333333333333333333333333333333333")
	local view= self:GetRoomView(3)
	if view then
		view:DestroyObj()
		self.mTable_RoomViewTable[3] = nil
	end
	--SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.enterRoom)
	self:PlayTweenAni(false)
end

function HallRoomPanelPanel:SetIsDestroyGameResource(IsDestroy)
	self.IsDestroyGameResource = IsDestroy
end




--界面UI变动时的监听函数
function HallRoomPanelPanel:OnUIStateChange(panelType,uiState)
   
end


function HallRoomPanelPanel:HideAllRoomItem()
	if self.tbItem then
		for k,v in pairs(self.tbItem) do
			if v then
				v:SetVisible(false)
			end
		end
	end
end

--设置子panel的深度
 function HallRoomPanelPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallRoomPanelPanel:__delete( ... )
	UIManager.GetInstance():RemoveEventListener(UIManager.EventType.UIChange,self.OnUIStateChange,self)
	LuaEvent:RemoveEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.OnReLoginSuccess,self)
	LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)
	self.tbItem = nil
end


HallRoomPanelPanel.RoomView={
	[1]=RoomView_Default,
	[2]=RoomView_BuYu,
	[3]=RoomView_Other,
	[4]=RoomDeskView_BuYu,
	[5]=RoomDeskView_LianXianJi,
}

HallRoomPanelPanel.EventType={
	SelecteDesk="HallRoomPanelPanel.EventType.SelecteDesk",
	NoSelecteDesk="HallRoomPanelPanel.EventType.NoSelecteDesk",
}

function HallRoomPanelPanel:RefreshView_OffLine()
	for i = 4, #HallRoomPanelPanel.RoomView do
		if self.mTable_RoomViewTable[i] then
			self.mTable_RoomViewTable[i]:RerefreshView_OffLine()
		end
	end
end