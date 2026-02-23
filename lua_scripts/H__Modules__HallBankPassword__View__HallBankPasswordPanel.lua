HallBankPasswordPanel = HallBankPasswordPanel or BaseClass(LuaPanel)

function HallBankPasswordPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBankPassword].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallBankPassword].path
	self.mPanelID = UIPanelDefine.EWndID.HallBankPassword
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.ThirdLevel --页面层级
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallBankPasswordPanel:InitUI()
	local mTran = self.obj.transform

	self.mInput_BankPsd = mTran:Find("Content/BankPassword/Input"):GetComponent(typeof(UIInput))
	self.mInput_BankPsd.inputType = HallDefine.NGUIInputType.Password
    self.mInput_BankPsd.validation = HallDefine.NGUIValidation.Integer
    self.mInput_BankPsd.keyboardType = HallDefine.NGUIKeyboardType.NumberPad

    self.mButton_Sure = mTran:Find("Content/Button_Sure").gameObject
    UIEventListener.Get(self.mButton_Sure).onClick = function () self:OnButton_Sure() end  -- 点击OnButton_Sure按钮事件
    self.mButton_Close = mTran:Find("Content/Button_Close").gameObject
	UIEventListener.Get(self.mButton_Close).onClick = function () self:Button_Close() end  -- 点击Button_Close按钮事件
	
	self.mButton_ForgetPassword = mTran:Find("Content/Button_Forget").gameObject
	UIEventListener.Get(self.mButton_ForgetPassword).onClick = function () self:Button_Forget() end  -- 点击:Button_Forget按钮事件

    self.TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
    self.mInputPassword = ""
	self.CheckUpCallBack = nil --检查密码时的回调函数
	
	local list_tweenList={}
    local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

	LuaPanel.InitUI(self)	
end

function HallBankPasswordPanel:SetPanelData()
	-- body
end
--按钮点击事件
--=============================================================================================================================================

--点击确认按钮事件
function HallBankPasswordPanel:OnButton_Sure( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local psd = self.mInput_BankPsd.value	
	TrimStr(psd)
	if psd == "" then
		UIManager:GetInstance():ShowNoteMessage("password_blank")
		return
	end

	if string.len(psd) < 6 or string.len(psd) > 20 then
		UIManager:GetInstance():ShowNoteMessage("Pls_Input_6_20_Number")
		return
	end

	local send = {}
	send.m_iTime = CommonUtil.GetCurrentTimeStamp()
	send.m_iUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID -- 用户ID
	local md5 = CommonUtil.GenMd5SDyPasswd(send.m_iUin, send.m_iTime, psd, CommonUtil.mstate)	
	send.m_szPassword = CommonUtil.StringToByteArrayTable(md5)
	for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
		if send.m_szPassword[i]==nil then
			send.m_szPassword[i]=0
		end
	end
	local staticPsd = CommonUtil.GenMd5StaticPasswd(send.m_iUin, psd, CommonUtil.mstate) --客户端缓存银行密码
	local isHasPsd=PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord~=nil
	self.TempPsd=CommonUtil.KeepTempPsd(staticPsd,isHasPsd,false)
	Net_SendHallData(NetworkDefine.ReqVerifyBankPassword, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_CHECK_BANK_PASSWD, 0)
end

--点击关闭按钮事件
function HallBankPasswordPanel:Button_Close( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end


function HallBankPasswordPanel:Button_Forget()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	

	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallResetBankPassword)
end
--=============================================================================================================================================
--end
-- 验证银行密码返回
function HallBankPasswordPanel:RspVerifyBankPassword( )
   PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord = self.TempPsd --保存缓存银行密码
   if self.CheckUpCallBack == nil then
	   UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Bank)
   else
	   pcall(self.CheckUpCallBack)
   end
   UIManager:GetInstance():HidePanel(self.mPanelID)
end


--设置子panel的深度
 function HallBankPasswordPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end
--创建排行榜列表

--
function HallBankPasswordPanel:SetCheckUpCallBack( callBack )
	self.CheckUpCallBack = callBack
end


function HallBankPasswordPanel:ShowPanel( callBack )	
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    self.CheckUpCallBack = nil
	self.mInput_BankPsd.value = ""
	LuaPanel.ShowPanel(self, callBack)
	self.mTweenPlayer:ParallelPlay(false)
end


function HallBankPasswordPanel:__delete( ... )
	self.mLabel_Tip = nil
	self.mLabel_PsdName = nil
	self.mLabel_InputPsd = nil
	self.mInput_BankPsd = nil
	self.mButton_Sure = nil
	self.mButton_Close = nil
	self.mInputPassword = nil
	self.CheckUpCallBack = nil	
end
