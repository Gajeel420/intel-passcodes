UIRoomGrid = UIRoomGrid or BaseClass()

function UIRoomGrid:__init(obj)
	if obj == nil then return end
	self.obj = obj
	self:InitUI(obj)
end

function UIRoomGrid:InitUI(obj)
	local mTran = obj.transform
	self.CallBack = nil
	local mTranUI = mTran:Find("Sprite/Label")
	if mTranUI then
		self.mLabel_Money = mTranUI:GetComponent(typeof(UILabel))
	end
	local mTranUI = mTran:Find("Sprite_HuiLv/Label")
	if mTranUI  then
		self.mLabel_ExchangeRete= mTranUI:GetComponent(typeof(UILabel))
	end
	self.roomInfo = nil
	UIEventListener.Get(self.obj).onClick = function() self:OnEnterRoom() end
	self.mBoxcllider = self.obj:GetComponent(typeof(BoxCollider))
end


function UIRoomGrid:SetVisible(isVisible)
	self.obj:SetActive(isVisible or false)
end


function UIRoomGrid:SetGridData(data,index,callBack)
	self.roomInfo = data
	self.CallBack = callBack
	self.obj.transform:SetSiblingIndex(index)
	local tmpMoney=NumberFormatRoom(HallGoldRateSToC(data.m_unMinMoney))
	if self.mLabel_Money then
		self.mLabel_Money.text= StringFormat("{0}",tmpMoney)
	end
	--兑率 m_unMaxMoney
	local exchangeReteString=nil
	if data.m_unMaxMoney==nil or tonumber(data.m_unMaxMoney)==0 then
		exchangeReteString="兑率1:"..ConfigInfoMgr.CoinRadio
	else
		exchangeReteString="兑率1:"..data.m_unMaxMoney
	end
	if self.mLabel_ExchangeRete then 
		self.mLabel_ExchangeRete.text="兑率1:"..exchangeReteString
	end
end



function UIRoomGrid:OnEnterRoom()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	HallRoomPanelController.GetInstance().view.panel:SetIsDestroyGameResource(false)
	if self.roomInfo == nil then return end
	if self.CallBack ~= nil then
		self.CallBack()
	end
	RoomModel.GetInstance():OnEnterRoom(self.roomInfo)
end

function UIRoomGrid:SetCanClick(enabled)
	self.mBoxcllider.enabled = enabled
end

function UIRoomGrid:__delete( ... )
	self.mTex_RoomLevel = nil
	self.mLabel_RoomName = nil
	self.mLabel_Money = nil
	self.mGO_SingleBet = nil
	self.mLabel_BetMoney = nil
	self.model = nil
	self.roomInfo = nil
end