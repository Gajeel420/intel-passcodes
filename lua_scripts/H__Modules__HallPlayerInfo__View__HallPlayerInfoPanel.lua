HallPlayerInfoPanel = HallPlayerInfoPanel or BaseClass(LuaPanel)

function HallPlayerInfoPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPlayerInfo].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPlayerInfo].path
	self.mPanelID = UIPanelDefine.EWndID.HallPlayerInfo
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel--页面层级
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallPlayerInfoPanel:InitUI()
	local mTran = self.obj.transform
	self.mTextUre_Head = mTran:Find("Content/PlayerInfo/HeadPortait/Texture_HeadPortait"):GetComponent(typeof(UITexture))
	self.mInput_Name = mTran:Find("Content/PlayerInfo/Name/NameInput"):GetComponent(typeof(UIInput))
	self.mInputSelect_Name = mTran:Find("Content/PlayerInfo/Name/NameInput"):GetComponent(typeof(UIInputSelectAction))
	self.mInputSelect_Name.onDeSelectAction = function()
		self:OnInputNameDeSelectAction()
	end
	self.mInput_Signature = mTran:Find("Content/PlayerInfo/Signature"):GetComponent(typeof(UIInput))
	self.mInputSelect_Signature = mTran:Find("Content/PlayerInfo/Signature"):GetComponent(typeof(UIInputSelectAction))
	self.mInputSelect_Signature.onDeSelectAction = function()
		self:OnInputSigleDeSelectAction()
	end
	self.mLable_IDNum = mTran:Find("Content/PlayerInfo/ID/Label_Value"):GetComponent(typeof(UILabel))
	self.mLable_GlodNum = mTran:Find("Content/PlayerInfo/Gold/Label_Value"):GetComponent(typeof(UILabel))
	self.mButton_AddGold = mTran:Find("Content/PlayerInfo/Gold/Button_Add").gameObject
	self.labelVIP=mTran:Find("Content/PlayerInfo/HeadPortait/Vip/Label"):GetComponent(typeof(UILabel))
    self.mButton_CopyId = mTran:Find("Content/PlayerInfo/ID/Btn_Copy").gameObject
	self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
    self.mButton_SubInfo = mTran:Find("Content/Button_ChangeInfo").gameObject;

    self.ModifyHeadBtn = mTran:Find("Content/PlayerInfo/HeadPortait/Texture_HeadPortait").gameObject
	local modifyHeadObj = mTran:Find("Content_2").gameObject
    modifyHeadObj:SetActive(false)
    self.modifyHeadPanel = ModifyHeadPortPanel.New(modifyHeadObj)
	self.modifyPanel = modifyHeadObj:GetComponent(typeof(UIPanel))

	self.mButton_ID = mTran:Find("Content/PlayerInfo/ID").gameObject
	UIEventListener.Get(self.mButton_CopyId).onClick = function() self:OnButton_CopyID() end
    UIEventListener.Get(self.mButton_AddGold).onClick = function() self:OnButton_AddGold() end
    UIEventListener.Get(self.mButton_Close).onClick = function() self:OnButton_Close() end
	UIEventListener.Get(self.mButton_SubInfo).onClick = function() self:OnButton_SubmitUserInfo() end
	UIEventListener.Get(self.mButton_ID).onClick = function() self:OnButton_CopyID() end
	

    UIEventListener.Get(self.ModifyHeadBtn).onClick = function() self:OnModifyHeadBtn() end
   

	self.mObj_BindPhoneButton=mTran:Find("Content/Button_Bindphone").gameObject
    UIEventListener.Get(self.mObj_BindPhoneButton).onClick = function() self:OnClickBindPhoneButton() end
	
	
	self.mBool_IsChange=false

	self.mList_Tween={}
	local mTweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(self.mList_Tween,mTweenScale )
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(self.mList_Tween)

	LuaPanel.InitUI(self)
end

function HallPlayerInfoPanel:AddEvent()
	LuaEvent:AddEventListener(EventName.ACCOUNT_BindAccountCompeled,self.OnBindPhoneSuccess,self)
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	--HallBindPhoneModel:GetInstance():AddEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)

end

function HallPlayerInfoPanel:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.ACCOUNT_BindAccountCompeled,self.OnBindPhoneSuccess,self)
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	--HallBindPhoneModel:GetInstance():RemoveEventListener(HallBindPhoneModel.EventType.BindPhoneSuccess,self.OnBindPhoneSuccess,self)

end

function HallPlayerInfoPanel:OnBindPhoneSuccess()
	self.mObj_BindPhoneButton:SetActive(false)
end



function HallPlayerInfoPanel:OnClickBindPhoneButton()

	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindPhone)
end

function HallPlayerInfoPanel:OnButton_SetAccount()
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBindAccount);
end


function HallPlayerInfoPanel:UpdatePlayerInfo(context)
	if self.mBool_IsChange then
		return
	end
	if not context then
		return 
	end
	local key=context[1]
	local newValue=context[2] 
	local oldValue=context[3] 
	if key=="szSignature" then --个性签名
		self.mInput_Signature.value = newValue
		UIManager:GetInstance():ShowNoteMessage("UserInfo_Modify_Success")
	end
	if key=="iVipLevel" then
		self:SetStringLabel( self.labelVIP,newValue )
	end
	if key=="iMoney" then
		self:SetNumberLabel( self.mLable_GlodNum,newValue )
	end
	if key == "iImageNO" then
		self.modifyHeadPanel:SetModifyHeadPortPanelDisply(false)

		local texture=UIPanelDefine.GetHeadTexturByIconIndex(newValue)
		if texture then
			self.mTextUre_Head.mainTexture=texture
		end

		PlayerHeadPortainMgr:GetInstance():HeadUpload(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID,ConfigInfoMgr.ThirdPlatformHeadURL,PlayerInfoController:GetInstance().model.mainPlayer.iImageNO)
	
	end


	if key == "szNickName" then
		-- if newValue ~= oldValue then
		-- 	self.mInput_Name.value=newValue
		-- end
	end
end

function HallPlayerInfoPanel:OnInputNameDeSelectAction()
	local newName= TrimStr(self.mInput_Name.value)
	local oldName=GetUserNickNameUnique(PlayerInfoController:GetInstance().model.mainPlayer.szNickName)
	if newName == "" then
		newName = oldName
		self.mInput_Name.value=newName
	end
	self.mButton_SubInfo:SetActive(newName ~= oldName)
end

function HallPlayerInfoPanel:OnInputSigleDeSelectAction()
	local newStrValSignature=TrimStr(self.mInput_Signature.value)
	local oldStrValSignature=PlayerInfoController:GetInstance().model.mainPlayer.szSignature
	if newStrValSignature == "" then
		newStrValSignature = oldStrValSignature
		self.mInput_Signature.value=newStrValSignature
	end
	self.mButton_SubInfo:SetActive(newStrValSignature ~= oldStrValSignature)
end

function HallPlayerInfoPanel:OnClickChangeNameButton()
	local value=TrimStr(self.mInput_Name.value)
	if value == "" then
		 return
	end

	if ConTainsSpecial(value) == true then
		--self.mInput_Name.value = GetUserNickNameUnique(PlayerInfoController:GetInstance().model.mainPlayer.szNickName)
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("UserName_SpecialChar"))
		return
	end

	UIManager:GetInstance():ShowNetWorkMessage("","",2)
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unTime = CommonUtil.GetCurrentTimeStamp()
	send.m_unFieldTypeBits = HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_NickName
	send.m_usInfoLen = string.len(value)
	send.m_szInfo = CommonUtil.StringToByteArrayTable(value)
	NetworkDefine.CReqUpdatePlayerInfoMsgPara={
	    {"m_unUIN","Int32",0},--用户id
	    {"m_unTime", "Int32", 0},--时间
	    {"m_unFieldTypeBits", "Int64", 0},--要修改的字段位掩码
	    {"m_usInfoLen","UInt16",0},--实际长度
	    {"m_szInfo","Byte[]",string.len(value)},--更新的内容, ","分隔各信息内容, 各信息内容以字符串的形式存入缓冲区
	}
	NetworkMgr:AddMsgStruct("NetworkDefine.CReqUpdatePlayerInfoMsgPara",NetworkDefine.CReqUpdatePlayerInfoMsgPara)
	Net_SendHallData(NetworkDefine.CReqUpdatePlayerInfoMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_UPDATE_USERINFO, 0)

end



function HallPlayerInfoPanel:OnButton_SubmitUserInfo( ... )
	local newStrStyleName=TrimStr(self.mInput_Signature.value)
	local oldStrStyleName=PlayerInfoController:GetInstance().model.mainPlayer.szSignature
	if newStrStyleName~=nil and newStrStyleName~=oldStrStyleName then

		--UIManager:GetInstance():ShowNetWorkMessage("","",2)
		PlayerInfoController:GetInstance():ReqUpdateUserInfo(newStrStyleName)
	end

	
	local newName= self.mInput_Name.value
	local oldName=GetUserNickNameUnique(PlayerInfoController:GetInstance().model.mainPlayer.szNickName)
	if newName~=nil and newName~= oldName then
		--UIManager:GetInstance():ShowNetWorkMessage("","",2)
		self:OnClickChangeNameButton()
	end

	self.mButton_SubInfo:SetActive(false);
	self.mBool_IsChange=false
end



--点击增加金币图标
function HallPlayerInfoPanel:OnButton_AddGold()
	--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end


function HallPlayerInfoPanel:OnModifyHeadBtn( obj )

	-- body
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self.modifyHeadPanel:SetModifyHeadPortPanelDisply(true)
end

--点击复制ID按钮
function HallPlayerInfoPanel:OnButton_CopyID( )

	PhoneManager:MyClipDataToClipboard(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end
--点击关闭按钮
function HallPlayerInfoPanel:OnButton_Close()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self.mBool_IsChange=false
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallPlayerInfoPanel:InitPanelData()
	self.isInitedPanelData=true
	self.mInput_Signature.value = PlayerInfoController:GetInstance().model.mainPlayer.szSignature
	self.mInput_Name.value = GetUserNickNameUnique(PlayerInfoController:GetInstance().model.mainPlayer.szNickName) --用户昵称
end
function HallPlayerInfoPanel:SetStringLabel( comlabel,value )
	if not comlabel then return end
	value=value or ""
	comlabel.text=(value)
end
function HallPlayerInfoPanel:SetNumberLabel(comlabel,value)
	if not comlabel then return end
	value=value or 0
	value=HallGoldRateSToC(value)
	comlabel.text=NumberThousandsFormat(value)
end
--设置子panel的深度
function HallPlayerInfoPanel:SetPanelDepth(depth)
	self.modifyPanel.depth = depth + 2
	LuaPanel.SetPanelDepth(self,depth)
end
--初始化显示用户信息
function HallPlayerInfoPanel:SetUserData( )
	local Id = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	self.mLable_IDNum.text = Id
	self.labelVIP.text=PlayerInfoController:GetInstance().model.mainPlayer.iVipLevel
	self.mLable_GlodNum.text = NumberThousandsFormat(HallGoldRateSToC(PlayerInfoController:GetInstance().model.mainPlayer.iMoney))
	PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.mTextUre_Head.gameObject,ConfigInfoMgr.ThirdPlatformHeadURL,1,PlayerInfoController:GetInstance().model.mainPlayer.iImageNO)
	local isHasAccountName=(PlayerInfoController:GetInstance().model.mainPlayer.szAccountName~="" and PlayerInfoController:GetInstance().model.mainPlayer.szAccountName)
	local isEnableAccount=ConfigInfoMgr.IsEnableAccount
	local isLoginTypeAuto=CacheDataMgr.mLoginInfo.nLoginType==NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_AUTO
	local isSetAccountEnable=(not isHasAccountName and isEnableAccount and isLoginTypeAuto)
	local isLoginTypeNormal=CacheDataMgr.mLoginInfo.nLoginType==NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL
	local isSetModifyUserPsdEnable=(isHasAccountName and isEnableAccount and isLoginTypeNormal)
	--self.mInput_Name.value = GetUserNickNameUnique(PlayerInfoController:GetInstance().model.mainPlayer.szNickName) --用户昵称
end



function HallPlayerInfoPanel:ShowPanel(callBack,isPlayTween)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self:SetUserData()
	if not self.isInitedPanelData then
		
		self:AddEvent()
	end
	self:InitPanelData()
	
	self.mButton_SubInfo:SetActive(false)
	if PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone then
		self.mObj_BindPhoneButton:SetActive( false)
	else
		self.mObj_BindPhoneButton:SetActive( true)
	end
	if isPlayTween==nil or isPlayTween==true then
		self.mTweenPlayer:ParallelPlay(false)
	end
	LuaPanel.ShowPanel(self, callBack)
end

function HallPlayerInfoPanel:ResetPanel( ... )
	self.isInitedPanelData=false
	self:RemoveEvent()
end

function HallPlayerInfoPanel:__delete( ... )
	self.mBool_IsChange=false
	self:RemoveEvent()
	self.mTextUre_Head = nil
	self.mLable_Name = nil
	self.mLable_IDNum = nil
	self.mLable_DiamoadNum = nil
	self.mButton_AddDiamoad = nil
	self.mLable_GlodNum = nil
	self.mButton_AddGold = nil
	self.mInput_Signature = nil
	self.mButton_CopyId = nil
	self.mButton_Close = nil
	self.mLable_GlodNum = nil
	self.mSignature = nil
	
end
