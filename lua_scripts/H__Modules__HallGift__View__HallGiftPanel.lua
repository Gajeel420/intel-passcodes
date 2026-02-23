HallGiftPanel = HallGiftPanel or BaseClass(LuaPanel)

function HallGiftPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGive].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallGive].path
	self.mPanelID = UIPanelDefine.EWndID.HallGive
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallGiftPanel:InitUI()
	local mTran = self.obj.transform

	self.mBtnClose = mTran:Find("Common/Btn_Back/Background").gameObject
	UIEventListener.Get(self.mBtnClose).onClick = function(obj) self:OnButtonClose(obj) end
	
	self.mCurrentValue = 0

	self.mGridCenter = mTran:Find("Content/GiftView/AllGift")
	local goodList = ConfigModuleModel.GetInstance().GiveList
	if self.mGridCenter.childCount then
		for i = 1, self.mGridCenter.childCount do
			local itemTransform=self.mGridCenter:GetChild(i-1)
			local gold=goodList[i]
			local C_Gold= HallGoldRateSToC(tonumber(gold))
			itemTransform:Find("Label"):GetComponent(typeof(UILabel)).text=NumberFormat(tonumber(C_Gold))
			UIEventListener.Get(itemTransform.gameObject).onClick=function() self:OnClickGoodsButton(C_Gold) end
		end
	end
	
	self.mInput_ID = mTran:Find("Content/GiveView/ReceiveID/Input"):GetComponent(typeof(UIInput))
	self.mInput_GlobalValue = mTran:Find("Content/GiveView/GlobalValue/Input"):GetComponent(typeof(UIInput))
	
	self.mLabel_Money = mTran:Find("Content/InfoView/MoneyLabel/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_Money.text = NumberFormat(HallGoldRateSToC(PlayerInfoController:GetInstance().model.mainPlayer.iMoney))
	
	self.mBtn_Check = mTran:Find("Content/GiveView/ReceiveID/BtnCheck").gameObject
	UIEventListener.Get(self.mBtn_Check).onClick = function(go) self:OnClickCheckIDButton() end
	
	-- self.mBtn_Clean = mTran:Find("Content/GiveView/GlobalValue/BtnClean").gameObject
	-- UIEventListener.Get(self.mBtn_Clean).onClick = function(go) self.mInput_GlobalValue.value = "" end
	
	self.mBtn_Give =  mTran:Find("Content/GiveView/ButtonGive").gameObject
	UIEventListener.Get(self.mBtn_Give).onClick = function(go) self:OnClickGiveButton() end
	
	local mSccessViewObj = mTran:Find("Content_2").gameObject
	self.mPanel_Success = mSccessViewObj:GetComponent(typeof(UIPanel))
	self.mSccessView = GiveSuccess.New(mSccessViewObj)

	self.mBtn_GiftRecord = mTran:Find("Content/InfoView/Btn_Record").gameObject
	UIEventListener.Get(self.mBtn_GiftRecord).onClick = function(go)self:OnButtonRecordClick(go) end

	self.mBtn_GiftSummary= mTran:Find("Content/InfoView/Btn_Summary").gameObject
	UIEventListener.Get(self.mBtn_GiftSummary).onClick = function(go)self:OnButtonSummaryClick(go) end
	LuaPanel.InitUI(self)
end


function HallGiftPanel:OnButtonRecordClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGiftRecord)
end

function HallGiftPanel:OnButtonSummaryClick(go)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGiftSummary)
end


function HallGiftPanel:OnClickGoodsButton(C_Gold)
	--self.mCurrentValue = self.mCurrentValue + C_Gold
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local value = self.mInput_GlobalValue.value or "0"
	value = tonumber(value) or 0
	local globalVale =value + C_Gold
	self.mInput_GlobalValue.value =  globalVale
end

---检测玩家ID
function HallGiftPanel:OnClickCheckIDButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local idString=self.mInput_ID.value or ""
	if idString=="" then
		UIManager:GetInstance():ShowNoteMessage("用户ID不能为空！")
		return
	end
	local id=TrimStr(idString)
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckIDSuccess,self)
	UIManager:GetInstance():ShowNetWorkMessage("Hall_Querying","Hall_failed",3)
	FriendModuleController:GetInstance():ReqSearchFriend(0,(id),1,1)
end

---检测Id成功回调
function HallGiftPanel:OnCheckIDSuccess(context)
	if context==nil then
		UIManager:GetInstance():ShowNoteMessage("用户不存在！")
		return
	end
	--移除监听
	FriendModuleModel:GetInstance():RemoveEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckIDSuccess,self)

	local showBoxData ={}
    showBoxData.title = "用户ID存在"
     if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
        showBoxData.context ="用户昵称：".. context.m_szNickName
    else
       showBoxData.context ="The user nickname：".. context.m_szNickName
    end
    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮; 
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

---赠送事件
function HallGiftPanel:OnClickGiveButton()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local idString=self.mInput_ID.value or ""
	if idString=="" then
		UIManager:GetInstance():ShowNoteMessage("用户ID不能为空！")
		return
	end
 
	local id=TrimStr(idString)
	FriendModuleModel:GetInstance():AddEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckGiveSuccess,self)
	UIManager:GetInstance():ShowNetWorkMessage("Hall_Querying","Hall_failed",3)
	FriendModuleController:GetInstance():ReqSearchFriend(0,(id),1,1)
end

--检测用户ID返回
function HallGiftPanel:OnCheckGiveSuccess(context)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	if context==nil then
		UIManager:GetInstance():ShowNoteMessage("用户不存在！")
		return
	end
	--移除监听
	FriendModuleModel:GetInstance():RemoveEventListener(FriendModuleConst.EventName_QueryPlayerCallBack,self.OnCheckGiveSuccess,self)
	local goldString=self.mInput_GlobalValue.value or ""
	local goldNum=tonumber(goldString) or 0
	if  goldNum==0 then
		UIManager:GetInstance():ShowNoteMessage("Hall_amount0")
		return
	end
	if goldNum >HallGoldRateCToS(tonumber(PlayerInfoController:GetInstance().model.mainPlayer.iMoney)) then
		UIManager:GetInstance():ShowNoteMessage("余额不足！")
		return
	end


	local showBoxData ={}
    showBoxData.title = "确认赠送"
    if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
         showBoxData.context = StringFormat("是否给{0}\n赠送：{1} 游戏币",context.m_szNickName, NumberFormat(tonumber(goldString)))
    else
          showBoxData.context = StringFormat("Whether to give {0} game currency \n to {1}", NumberFormat(tonumber(goldString)),context.m_szNickName)--StringFormat("是否给{0}\n赠送：{1} 游戏币",context.m_szNickName, NumberFormat(tonumber(goldString)))
    end
    --showBoxData.context = StringFormat("是否给{0}\n赠送：{1} 游戏币",context.m_szNickName, NumberFormat(tonumber(goldString)))
    showBoxData.enterCB = function() 
		self:GiveGold(context.m_unUIN,goldNum)
    end--：点击确定返回；   
	showBoxData.isHideAll = false--:隐藏所有按钮; 
	showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end



function HallGiftPanel:GiveGold(id,gold)

	local cb=function ()
		HallGiftController.GetInstance().model:ReqGiveGift(id,gold)
	end
	--检测银行密码
	UIManager.GetInstance():CheckHallBankPassword(cb)
	
end

---点击关闭按钮
function HallGiftPanel:OnButtonClose(obj)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)

end


---刷新玩家信息
function HallGiftPanel:UpdatePlayerInfo(context)
	if not context then return end
	local key=context[1]
	local newValue=context[2]
	local oldValue=context[3]
	if key=="iMoney" then
		self.mLabel_Money.text = NumberFormat(HallGoldRateSToC(PlayerInfoController:GetInstance().model.mainPlayer.iMoney))
	end
end


function HallGiftPanel:OnGiveGiftSuccess(msg)
	self.mInput_GlobalValue.value = ""
	self.mInput_ID.value = ""
	self.mSccessView:ShowView(msg)
end


function HallGiftPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.mPanel_Success.depth = depth + 1
end

function HallGiftPanel:ShowPanel(back)
	PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	LuaPanel.ShowPanel(self,back)
end


function HallGiftPanel:HidePanel()
	self.mInput_GlobalValue.value = ""
	self.mInput_ID.value = ""
	PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	LuaPanel.HidePanel(self)
end

function HallGiftPanel:__delete( ... )
	
end
