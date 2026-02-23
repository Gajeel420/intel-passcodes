GameRoomItem = BaseClass()

function GameRoomItem:__init(obj)
    if obj == nil then return end
    self.obj = obj
    self:InitUI()
end

--初始化界面
function GameRoomItem:InitUI()
	self.CallBack = nil
	local mTran = self.obj.transform
	local mTranUI = mTran:Find("Sprite2/Label")
	if mTranUI ~= nil then
		self.mLabel_min = mTranUI:GetComponent(typeof(UILabel))
	end
	mTranUI =  mTran:Find("Sprite1/Label")
	if mTranUI ~= nil then
		self.mLabel_di = mTranUI:GetComponent(typeof(UILabel))
	end
	if self.mLabel_di ~= nil then
		self.mLabel_di.text = "0"
	end
	if self.mLabel_min ~= nil then
		self.mLabel_min.text = "0"
	end
	self.roomInfo = nil
	UIEventListener.Get(self.obj).onClick = function() self:OnEnterRoom() end
	self.mBoxcllider = self.obj:GetComponent(typeof(BoxCollider))
end

--是否显示
function GameRoomItem:SetVisible(isVisible)
	self.obj:SetActive(isVisible or false)
end

---设置房间数据
function GameRoomItem:SetGridData(data,index,callBack)
	self.roomInfo = data
	self.CallBack = callBack
    self.obj.transform:SetSiblingIndex(index)
	local tmpMoney=NumberFormat(HallGoldRateSToC(data.m_unMinMoney))
	local tmDi = NumberFormat(HallGoldRateSToC(data.iMoneyPoint))
	if self.mLabel_min then
		self.mLabel_min.text= StringFormat("{0}",tmpMoney)
	end
	if self.mLabel_di then
		if data.iMoneyPoint < 100 then
			self.mLabel_di.text = "-"
		else
			self.mLabel_di.text = StringFormat("{0}",tmDi)
		end
	end
end

--房间点击事件
function GameRoomItem:OnEnterRoom()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(false)
	if self.roomInfo == nil then return end
	if self.CallBack ~= nil then
		self.CallBack()
	end
	RoomModel.GetInstance():OnEnterRoom(self.roomInfo)
end

function GameRoomItem:SetCanClick(enabled)
	self.mBoxcllider.enabled = enabled
end

function GameRoomItem:__delete()
end