GameRoomBuYuItem = BaseClass()

function GameRoomBuYuItem:__init(obj)
    if obj == nil then return end
    self.obj = obj
    self:InitUI()
end

--初始化界面
function GameRoomBuYuItem:InitUI()
	self.CallBack = nil
	local mTran = self.obj.transform
	local mTranUI = mTran:Find("Sprite1/Label")
	if mTranUI ~= nil then
		self.mLabel_min = mTranUI:GetComponent(typeof(UILabel))
		mTranUI.gameObject:SetActive(true)
	end

	local mTranUI = mTran:Find("Sprite1/Label_Ty")
	if mTranUI ~= nil then
		mTranUI.gameObject:SetActive(false)
	end

	mTranUI =  mTran:Find("Sprite2/Label")
	if mTranUI ~= nil then
		self.mLabel_di = mTranUI:GetComponent(typeof(UILabel))
	end
	if self.mLabel_di ~= nil then
		self.mLabel_di.text = "0"
	end
	if self.mLabel_min ~= nil then
		self.mLabel_min.text = "0"
	end

	mTranUI = mTran:Find("Sprite1")
	if mTranUI ~= nil then
		self.minPanel = mTranUI.gameObject
	end

	mTranUI = mTran:Find("Bg/Sprite")
	if mTranUI ~= nil then
		self.mUIRenderQueue = SZUIRenderQueue.New(mTranUI.gameObject)
	end

	self.roomInfo = nil
	UIEventListener.Get(self.obj).onClick = function() self:OnEnterRoom() end
	self.mBoxcllider = self.obj:GetComponent(typeof(BoxCollider))
end

function GameRoomBuYuItem:SetItemDepth(depth)
	
	if self.mUIRenderQueue ~= nil then
		self.mUIRenderQueue:SetShaderRenderQueue(depth + 6)
	end
	
	if self.minPanel ~= nil then
		SetPanelstartingRenderQueue(self.minPanel,depth +8)
	end
	
end

--是否显示
function GameRoomBuYuItem:SetVisible(isVisible)
	self.obj:SetActive(isVisible or false)
end

---设置房间数据
function GameRoomBuYuItem:SetGridData(data,index,callBack)
	self.roomInfo = data
	self.CallBack = callBack
    self.obj.transform:SetSiblingIndex(index)
	local tmpMoney=NumberFormat(HallGoldRateSToC(data.m_unMinMoney))
	local tmDi = NumberFormat(HallGoldRateSToC(data.iMoneyPoint))
	if self.mLabel_min then
		local str = data.m_nFlag == 1 and "免费体验" or StringFormat("{0} 入场",tmpMoney)
		self.mLabel_min.text = str
	end
	if self.mLabel_di then
		if data.iMoneyPoint < 100 then
			self.mLabel_di.text = "-"
		else
			self.mLabel_di.text = StringFormat("{0} 底注",tmDi)
		end
	end
end

--房间点击事件
function GameRoomBuYuItem:OnEnterRoom()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(false)
	if self.roomInfo == nil then return end
	if self.CallBack ~= nil then
		self.CallBack()
	end
	RoomModel.GetInstance():OnEnterRoom(self.roomInfo)
end

function GameRoomBuYuItem:SetCanClick(enabled)
	self.mBoxcllider.enabled = enabled
end

function GameRoomBuYuItem:__delete()
end