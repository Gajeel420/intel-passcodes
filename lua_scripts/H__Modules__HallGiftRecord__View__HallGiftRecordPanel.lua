HallGiftRecordPanel = HallGiftRecordPanel or BaseClass(LuaPanel)

function HallGiftRecordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGiftRecord].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGiftRecord].path
	self.mPanelID = UIPanelDefine.EWndID.HallGiftRecord
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGiftRecordPanel:InitUI()
	self.mInt_PageSize=30
	local mTran = self.obj.transform

	self.mBtnClose = mTran:Find("Common/Btn_Back/Background").gameObject
	UIEventListener.Get(self.mBtnClose).onClick = function(obj) self:OnButtonClose(obj) end
	self.mButton_Send = mTran:Find("Content/Left/ToggleSend").gameObject
	self.mButton_SendNormal =  mTran:Find("Content/Left/ToggleSend/Normal").gameObject
	self.mButton_SendUp = mTran:Find("Content/Left/ToggleSend/Up").gameObject
	UIEventListener.Get(self.mButton_Send).onClick = function(obj) self:OnButtonSendClick(obj) end
	self.mButton_Record = mTran:Find("Content/Left/ToggleReceived").gameObject
	self.mButton_RecordNormal =  mTran:Find("Content/Left/ToggleReceived/Normal").gameObject
	self.mButton_RecordUp = mTran:Find("Content/Left/ToggleReceived/Up").gameObject
	UIEventListener.Get(self.mButton_Record).onClick = function(obj) self:OnButtonRecordClick(obj) end
	self.mPanelScroll = mTran:Find("Content/Right/ScrollView").gameObject:GetComponent(typeof(UIPanel))
	self.mGridParent = mTran:Find("Content/Right/ScrollView/Grid")
	self.mObjItem = mTran:Find("Content/Right/ScrollView/Item").gameObject
	self.mObjItem:SetActive(false)
	self.mLabel_Money = mTran:Find("Content/Right/Title/Money/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_NickName = mTran:Find("Content/Right/Title/NickName/Label").gameObject:GetComponent(typeof(UILabel))
	self.mItemList = {}
	LuaPanel.InitUI(self)
end


---点击关闭按钮
function HallGiftRecordPanel:OnButtonClose(obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallGiftRecordPanel:OnButtonSendClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:CloseAllItem()
	self.mButton_SendNormal:SetActive(false)
	self.mButton_SendUp:SetActive(true)
	self.mButton_RecordNormal:SetActive(true)
	self.mButton_RecordUp:SetActive(false)
	self.mLabel_Money.text = "送出礼物"
	self.mLabel_NickName.text = "收到玩家"
	HallGiftRecordController.GetInstance().model:RequestRecordData(HallGiftRecordModel.RecordType.Give,1,self.mInt_PageSize)
end

function HallGiftRecordPanel:OnButtonRecordClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:CloseAllItem()
	self.mButton_SendNormal:SetActive(true)
	self.mButton_SendUp:SetActive(false)
	self.mButton_RecordNormal:SetActive(false)
	self.mButton_RecordUp:SetActive(true)
	self.mLabel_Money.text = "收到礼物"
	self.mLabel_NickName.text = "送出玩家"
	HallGiftRecordController.GetInstance().model:RequestRecordData(HallGiftRecordModel.RecordType.Receive,1,self.mInt_PageSize)
end


function HallGiftRecordPanel:OnUpdateSendData(dataList)
	local count = #dataList
	for i = 1, count do
		if self.mItemList[i]  == nil then
			local obj=GameObject.Instantiate(self.mObjItem,self.mGridParent)
			obj.name=tostring(i)
			obj.transform.localPosition = Vector3.zero
			obj.transform.localScale = Vector3.one
			obj.transform.localEulerAngles = Vector3.zero
			self.mItemList[i]=UIRecordGrid.New(obj)
		end
		local item = self.mItemList[i]
		item:SetData(dataList[i])
		item:SetGridDisplay(true)
	end
	self.mGridParent.gameObject:GetComponent(typeof(UIGrid)):Reposition()
end


function HallGiftRecordPanel:CloseAllItem()
	local count = #self.mItemList
	for i = 1, count do
		self.mItemList[i]:SetGridDisplay(false)
	end
end



function HallGiftRecordPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.mPanelScroll.depth = depth + 2
	
end

function HallGiftRecordPanel:ShowPanel(back)
	self:OnButtonSendClick(self.mButton_Send)
	LuaPanel.ShowPanel(self,back)
end


function HallGiftRecordPanel:HidePanel()
	
	LuaPanel.HidePanel(self)
end

function HallGiftRecordPanel:__delete( ... )
	
end
