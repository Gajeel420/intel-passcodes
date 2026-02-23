HallSignalStrengthPanel = HallSignalStrengthPanel or BaseClass(LuaPanel)

function HallSignalStrengthPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSignalStrength].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSignalStrength].path
	self.mPanelID = UIPanelDefine.EWndID.HallSignalStrength
	self.mPanelType = UIPanelDefine.PanelType.Prompt --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallSignalStrengthPanel:InitUI()

	self.mList_StrengthSprite = {}
	self.mList_StengthTips = 
	{
		[1] = "[2DFF2EFF]{0}ms[-]",
		[2] = "[FFFF36FF]{0}ms[-]",
		[3] = "[FF0000FF]{0}ms[-]",
	}
	self.mColor = Color(1,1,1)
	local mTran = self.obj.transform
	local mTranUI = mTran:Find("Content/Label")
	if mTranUI ~= nil then
		self.mLabel_Strength = mTranUI:GetComponent(typeof(UILabel))
	end
	for i = 1, 5 do
		mTranUI = mTran:Find(StringFormat("Content/Signal/Sprite0{0}",i))
		if mTranUI ~= nil then
			mTranUI.gameObject:SetActive(false)
			table.insert(self.mList_StrengthSprite,mTranUI:GetComponent(typeof(UISprite)) )
		end
	end
	mTranUI = nil
	mTran = nil
	self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[1],10)
	self:SetState(5)
	LuaEvent:AddEventListener(EventName.GameSignalStrength,self.SetSignalStrength,self)
	LuaPanel.InitUI(self)
end

--- 设置信号强度
function HallSignalStrengthPanel:SetSignalStrength(content)
	local SignalState = content.m_data[0]
	if SignalState ~= nil then
		if SignalState > 0 and SignalState <= 50 then
			self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[1],SignalState)
			self:SetState(5)
		elseif SignalState > 50 and SignalState <= 100 then
			self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[1],SignalState)
			self:SetState(4)
		elseif SignalState > 100 and SignalState <= 250 then
			self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[2],SignalState)
			self:SetState(3)
		elseif SignalState > 250 and SignalState <= 500 then
			self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[3],SignalState)
			self:SetState(2)
		elseif SignalState > 500  then
			self.mLabel_Strength.text = StringFormat(self.mList_StengthTips[3],SignalState)
			self:SetState(1)
		end
	end
end

function HallSignalStrengthPanel:SetState(num)
	if num < 3 then
		self.mColor.r = 1
		self.mColor.g = 0
		self.mColor.b = 0
	elseif num == 3 then
		self.mColor.r = 1
		self.mColor.g = 1
		self.mColor.b = 0.2
	else
		self.mColor.r = 0
		self.mColor.g = 1
		self.mColor.b = 0
	end
	for i = 1, 5 do
		self.mList_StrengthSprite[i].gameObject:SetActive(i <= num)
		if i <= num then
			self.mList_StrengthSprite[i].color = self.mColor
		end
	end
end

function HallSignalStrengthPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end

function HallSignalStrengthPanel:__delete( ... )
	self.mRendeerQueue_BG = nil
	self.obj = nil
end
