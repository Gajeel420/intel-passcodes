HallBankSetPasswordPanel = HallBankSetPasswordPanel or BaseClass(LuaPanel)

function HallBankSetPasswordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBankSetPassword].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBankSetPassword].path
	self.mPanelID = UIPanelDefine.EWndID.HallBankSetPassword
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel --页面层级
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallBankSetPasswordPanel:InitUI()
	local mTran = self.obj.transform
	self.mIpt_Password = mTran:Find("Content/UserSetPassword/Input"):GetComponent(typeof(UIInput))
	self.mIpt_Password.inputType = HallDefine.NGUIInputType.Password
    self.mIpt_Password.validation = HallDefine.NGUIValidation.Integer
    self.mIpt_Password.keyboardType = HallDefine.NGUIKeyboardType.NumberPad

	self.mIpt_SurePassword = mTran:Find("Content/UserConfirmtPassword/Input"):GetComponent(typeof(UIInput))
	self.mIpt_SurePassword.inputType = HallDefine.NGUIInputType.Password
    self.mIpt_SurePassword.validation = HallDefine.NGUIValidation.Integer
    self.mIpt_SurePassword.keyboardType = HallDefine.NGUIKeyboardType.NumberPad

    self.mButton_Sure = mTran:Find("Content/Button_Sure").gameObject

    UIEventListener.Get(self.mButton_Sure).onClick = function () self:OnButton_Sure() end  -- 点击OnButton_Sure按钮事件
    self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(self.mButton_Close).onClick = function () self:Button_Close() end  -- 点击Button_Close按钮事件

    self.setNewPassword = "" --新密码缓存

	self.CheckUpCallBack = nil --检查密码时的回调函数
	
	local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	LuaPanel.InitUI(self)
	
end

--按钮点击事件
--=============================================================================================================================================

--点击确认按钮事件
function HallBankSetPasswordPanel:OnButton_Sure( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	local psd = TrimStr(self.mIpt_Password.value)
	local surePsd = TrimStr(self.mIpt_SurePassword.value)

	if psd == "" then
		UIManager:GetInstance():ShowNoteMessage("password_blank")
		return
	end

	if surePsd == "" then
		UIManager:GetInstance():ShowNoteMessage("password_blank")
		return
	end

	if surePsd ~= psd then
		UIManager:GetInstance():ShowNoteMessage("Inconsistent_passwords")
		return
	end

	if string.len(psd) < 6 or string.len(psd) > 20 then
		UIManager:GetInstance():ShowNoteMessage("Pls_Input_6_20_Number")
		return
	end
	local p1=StringFormatByLanguage("Setting_Psd_Now")
	local p2=StringFormatByLanguage("NetWorkOrrer")
	local p3=2
	UIManager:GetInstance():ShowNetWorkMessage(p1,p2,p3)

	local send = {}
	send.m_iSize = 0
	send.m_iTime = os.time()
	send.m_iUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID -- 用户ID
	send.m_sDstAccountType = 1 -- 1代表银行 0 代表支付
	local md5 = CommonUtil.GenMd5SDyPasswd(send.m_iUin, send.m_iTime, "123456", CommonUtil.mstate)
	send.m_szOldPassword = CommonUtil.StringToByteArrayTable(md5) --初始化银行密码是123456
	for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
		if send.m_szOldPassword[i]==nil then
			send.m_szOldPassword[i]=0
		end
	end
	local newMd5 = CommonUtil.GenMd5StaticPasswd(send.m_iUin, surePsd, CommonUtil.mstate)
	send.m_szNewPassword = CommonUtil.StringToByteArrayTable(newMd5)   
	for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
		if send.m_szNewPassword[i]==nil then
			send.m_szNewPassword[i]=0
		end
	end 
	local isHasPsd=PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord~=nil
	self.TempPsd = CommonUtil.KeepTempPsd(newMd5,isHasPsd,true) --缓存静态密码
	Net_SendHallData(NetworkDefine.CReqSetPasswordMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CHANGE_PASSWORD, 18)
end


--点击关闭按钮事件
function HallBankSetPasswordPanel:Button_Close( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

--=============================================================================================================================================
--end

--修改密码成功后回调
function HallBankSetPasswordPanel:UserChangeBankPassword()
    UIManager:GetInstance():ShowNoteMessage("Set_Password_Success")
	PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord = self.TempPsd --保存银行缓存密码
	PlayerInfoController:GetInstance().model.mainPlayer.isSetPasswordFlag = true --已经设置的银行密码
    if self.CheckUpCallBack == nil then 
	    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Bank)		
	else
		pcall(self.CheckUpCallBack)
	end

	UIManager:GetInstance():HidePanel(self.mPanelID)
end


--设置子panel的深度
 function HallBankSetPasswordPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end


--
function HallBankSetPasswordPanel:SetCheckUpCallBack( callBack )
	self.CheckUpCallBack = callBack
end



function HallBankSetPasswordPanel:ShowPanel( callBack )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self.mIpt_Password.value = ""
    self.mIpt_SurePassword.value = ""
    self.onBackOperation = nil
    self.onCloseOperation = nil
	LuaPanel.ShowPanel(self, callBack)
	self.mTweenPlayer:ParallelPlay(false)
end


function HallBankSetPasswordPanel:__delete( ... )
	self.mLabel_Des = nil
	self.mLabel_PsdName = nil
	self.mLabel_SurePsdName = nil
	self.mIpt_Password = nil
	self.mIpt_SurePassword = nil
	self.mButton_Sure = nil
	self.mButton_Close = nil
	self.setNewPassword = nil
	self.CheckUpCallBack = nil --检查密码时的回调函数

end
