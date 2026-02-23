HallSettingPanel = HallSettingPanel or BaseClass(LuaPanel)

function HallSettingPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSetting].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSetting].path
	self.mPanelID = UIPanelDefine.EWndID.HallSetting
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现	
end

--初始化ui界面  ----必须实现
function HallSettingPanel:InitUI()
	local mTran = self.obj.transform
	local mButton_Close = mTran:Find("Content/Button_Close").gameObject
	
	-- local mButton_FeedBack = mTran:Find("Content/Button_FeedBack").gameObject
	local mButton_ChangeUser = mTran:Find("Content/Button_ChangeAccount").gameObject
	UIEventListener.Get(mButton_Close).onClick = function ()self:OnButtonClose() end 
	-- UIEventListener.Get(mButton_FeedBack).onClick = function ()self:OnButtonFeedBack() end
	UIEventListener.Get(mButton_ChangeUser).onClick = function ()self:OnButtonChangeUser() end
	
	self.objMusicBtn = mTran:Find("Content/Toggle_Music").gameObject
	self.objMusicOn = mTran:Find("Content/Toggle_Music/On").gameObject
	self.objMusicOff = mTran:Find("Content/Toggle_Music/Off").gameObject
	self.objSoundBtn = mTran:Find("Content/Toggle_Audio").gameObject
	self.objSoundOn = mTran:Find("Content/Toggle_Audio/On").gameObject
	self.objSoundOff = mTran:Find("Content/Toggle_Audio/Off").gameObject
	self.objZhenDongBtn = mTran:Find("Content/Toggle_ZhenDong").gameObject
	self.objZhenDongOn = mTran:Find("Content/Toggle_ZhenDong/On").gameObject
	self.objZhenDongOff = mTran:Find("Content/Toggle_ZhenDong/Off").gameObject

	self.Chinese = mTran:Find("Content/Toggle_Chinese"):GetComponent(typeof(UIToggle))
	UIEventListener.Get(self.Chinese.gameObject).onClick = function ()self:LanguageChineseOnCilck() end 
	self.Chinese.value = SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1]

	self.English = mTran:Find("Content/Toggle_English"):GetComponent(typeof(UIToggle))
	UIEventListener.Get(self.English.gameObject).onClick = function ()self:LanguageEngilshOnClick() end 
	self.English.value = SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[2]
	
	UIEventListener.Get(self.objMusicBtn).onClick = function () self:OnButtonMusic() end 
	UIEventListener.Get(self.objSoundBtn).onClick = function () self:OnButtonSound() end
	UIEventListener.Get(self.objZhenDongBtn).onClick = function () self:OnButtonZhenDong() end
	
	self.mLabel_UserName = mTran:Find("Content/Account/Label_Name"):GetComponent(typeof(UILabel))
	self.mTexture_Head = mTran:Find("Content/Account/Texture_Head"):GetComponent(typeof(UITexture))
	
	-- self.Label_Edition=mTran:Find("Content/Label_Edition"):GetComponent(typeof(UILabel))
	-- self.Label_Edition.gameObject:SetActive(true)
	self.TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
	LuaPanel.InitUI(self)
end

function HallSettingPanel:LanguageEngilshOnClick()
	print("aaaaaaaaaaaaaaaaaaa    222222222222222222222222222")
	SystemSetting:GetInstance():SetLanguage(SystemSetting:GetInstance().LanguageType[2])
	local value = "1"
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unTime = CommonUtil.GetCurrentTimeStamp()
	send.m_unFieldTypeBits = HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Languige
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
	HallNotifyController:GetInstance().view.panel.mTopScoreView:LanguigeChange(1)
	HallNotifyController:GetInstance().view.panel.mTopScoreView02:LanguigeChange(1)

	
end

function HallSettingPanel:LanguageChineseOnCilck()
	
	SystemSetting:GetInstance():SetLanguage(SystemSetting:GetInstance().LanguageType[1])
	local value = "0"
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unTime = CommonUtil.GetCurrentTimeStamp()
	send.m_unFieldTypeBits = HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Languige
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
	HallNotifyController:GetInstance().view.panel.mTopScoreView:LanguigeChange(0)
	HallNotifyController:GetInstance().view.panel.mTopScoreView02:LanguigeChange(0)

end

--panel 显示的时候调用
function HallSettingPanel:ShowPanel(callBack)	
	self:SetPanelData()
	LuaPanel.ShowPanel(self,callBack)
	self:PlayOpenAni()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
end

function HallSettingPanel:PlayOpenAni( ... )
	-- body
	self.TweenAn.enabled=true
	self.TweenAn:ResetToBeginning()
	self.TweenAn:PlayForward()
end

function HallSettingPanel:SetPanelData()
	self.objMusicOn:SetActive(SystemSetting:GetInstance():GetIsBGMusicOn())
	self.objMusicOff:SetActive(not SystemSetting:GetInstance():GetIsBGMusicOn())
	self.objSoundOn:SetActive(SystemSetting:GetInstance():GetIsSoundOn())
	self.objSoundOff:SetActive(not SystemSetting:GetInstance():GetIsSoundOn())
	self.objZhenDongOn:SetActive(SystemSetting:GetInstance():GetIsZhenDongOn())
	self.objZhenDongOff:SetActive(not SystemSetting:GetInstance():GetIsZhenDongOn())
	self.mLabel_UserName.text = (PlayerInfoController:GetInstance().model.mainPlayer.szNickName)
	--self.Label_Edition.text=GameConst.Version or ""
	-- self.mLabel_UserID.text = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	--print("rrrrrrrrrr   ",ConfigInfoMgr.ThirdPlatformHeadURL,"    ",PlayerInfoController:GetInstance().model.mainPlayer.iImageNO)
	PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.mTexture_Head.gameObject,ConfigInfoMgr.ThirdPlatformHeadURL,1,PlayerInfoController:GetInstance().model.mainPlayer.iImageNO)
end

function HallSettingPanel:OnButtonClose( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallSettingPanel:OnButtonFeedBack(...)

	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallFeedBack)
end

function HallSettingPanel:OnButtonChangeUser( ... )
	-- print("HallSettingPanel:OnButtonChangeUserHallSettingPanel:OnButtonChangeUserHallSettingPanel:OnButtonChangeUser")
	local showBoxData ={}
    showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
    showBoxData.context = "CLIENT_TIPS_6"--StringFormatByLanguage("IsNoChangeUser")--内容；
    showBoxData.enterCB = function() 
        SceneManager:GetInstance():BackToLoginScene()
    end--：点击确定返回；
    
    -- showBoxData.cancelCB = function() end--：点击取消返回，
    showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮; 
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
    UIManager:GetInstance():ShowMessageBox(showBoxData)

end

function HallSettingPanel:OnButtonMusic( ... )
	SystemSetting:GetInstance():SetBGMusicOn(not SystemSetting:GetInstance():GetIsBGMusicOn())
	if(SystemSetting:GetInstance():GetIsBGMusicOn()) then
		SoundManager:GetInstance():ResumeBGMusic(true)
	else
		SoundManager:GetInstance():StopBGMusic(true)
	end
	self.objMusicOn:SetActive(SystemSetting:GetInstance():GetIsBGMusicOn())
	self.objMusicOff:SetActive(not SystemSetting:GetInstance():GetIsBGMusicOn())
end

function HallSettingPanel:OnButtonSound( ... )
	SystemSetting:GetInstance():SetSoundOn(not SystemSetting:GetInstance():GetIsSoundOn())
	self.objSoundOn:SetActive(SystemSetting:GetInstance():GetIsSoundOn())
	self.objSoundOff:SetActive(not SystemSetting:GetInstance():GetIsSoundOn())
end

function HallSettingPanel:OnButtonZhenDong( ... )
	SystemSetting:GetInstance():SetZhenDongOn(not SystemSetting:GetInstance():GetIsZhenDongOn())
	self.objZhenDongOn:SetActive(SystemSetting:GetInstance():GetIsZhenDongOn())
	self.objZhenDongOff:SetActive(not SystemSetting:GetInstance():GetIsZhenDongOn())
end

--设置子panel的深度
 function HallSettingPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end
--创建排行榜列表


function HallSettingPanel:__delete( ... )
	self.objMusicBtn = nil
	self.objMusicOn = nil
	self.objMusicOff = nil
	self.objSoundBtn = nil
	self.objSoundOn = nil
	self.objSoundOff = nil
	self.objZhenDongBtn = nil
	self.objZhenDongOn = nil
	self.objZhenDongOff = nil
	self.mLabel_UserName = nil
	self.mTexture_Head = nil
	self.Label_Edition = nil
end
