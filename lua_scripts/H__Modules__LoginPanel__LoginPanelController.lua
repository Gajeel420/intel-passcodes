LoginPanelController = LoginPanelController or BaseClass(LuaController)
require"H/Modules/LoginPanel/LoginPanelModel"
require"H/Modules/LoginPanel/LoginPanelView"
require"H/Modules/LoginPanel/View/LoginPanel"
function LoginPanelController:__init( )
	self.heartBeatCount = 0;
	self.model = LoginPanelModel:GetInstance()
	self.view = LoginPanelView.New()
	self:AddEvent()
	self:RegistProto()
    self.m_isLoginSuccessed = false;--//登陆陈宫
	self.mLoginMethodQueueIndex = 1
	self.mLoginCompleteMethodQueue = {}


	self.NeedCheckGameSate = false
	self.NeedCheckGameSateIndex = 0
	self.NeedChedGameStateName = "LoginPanelController.NeedChedGameStateName"
end

function LoginPanelController:RegistProto()

	if ConfigInfoMgr.UsNewLoginProtocol == nil then
		self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_SC_USER_INFO,"LoginSuccessCallBack")
	elseif  ConfigInfoMgr.UsNewLoginProtocol then
		self:RegistProtocal(ConfigInfoMgr.NEW_MSG_ID_SC_USER_INFO,"LoginSuccessCallBack")
	else
		self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_SC_USER_INFO,"LoginSuccessCallBack")
	end
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_NOTIFY_USER_OFFLINE,"NotifyUserOffLine")--通知客户端下线
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_LOGIN_BROAD_TRANSER,"OnLolginBroadCastBack")
end

function LoginPanelController:AddEvent()
	LuaEvent:AddEventListener(EventName.LOGIN_SUCCESS,self.LoginCompleted,self)
	LuaEvent:AddEventListener(EventName.BACK_TO_LOGIN,self.BackToLogin,self)
	LuaEvent:AddEventListener(EventName.LOGIN_FAIL,self.LoginFail,self)
	LuaEvent:AddEventListener(EventName.ConentBroadcastSuccess,self.OnBroatcastContentSuccess,self)
	LuaEvent:AddEventListener(EventName.GameSceneNoNotify,self.GameSceneNoNotify,self)
	LuaEvent:AddEventListener(EventName.FacebookLoginResult,self.FacebookLoginCallBack,self)
end


function LoginPanelController:GameSceneNoNotify()
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallNotify)
	ConfigModuleModel.GetInstance().GameSceneDisplayHallNotify = false
end

function LoginPanelController:JudgeNumberPhone(str)
	local tips = '[1][3-9]%d%d%d%d%d%d%d%d%d'
	return string.match( str,tips ) == str
end


function LoginPanelController:LoginSuccess()
	
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	self:LoginCompleted()
	-- if CacheDataMgr.mLoginInfo.nLoginType == 2  or CacheDataMgr.mLoginInfo.nLoginType == 102 then
	-- 	local account = Network.LoginAccount
	-- 	local accountAndPasswordTabel=SystemSetting.GetInstance():GetAccountAndPasswordTableList()
	-- 	local isSigned=false
		
	-- 	if self:JudgeNumberPhone(account) then
	-- 		for i = 1, #accountAndPasswordTabel do
	-- 			local item=accountAndPasswordTabel[i]
	-- 			if  tostring(item.account)==account then
	-- 				isSigned=true
	-- 				break
	-- 			end
	-- 		end
	-- 	else
	-- 		isSigned = true
	-- 	end

	-- 	if isSigned==false then
	-- 		UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPhoneVerification,function (panel)
	-- 			panel:SetVerificationData(account,function ()
	-- 				--Net_BeginLogin(NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL, account, password)
	-- 				self:LoginCompleted()
	-- 			end)
	-- 		end)
	-- 	else
	-- 		self:LoginCompleted()
	-- 	end
	-- else
	-- 	self:LoginCompleted()
	-- end
end

--登录成功
function LoginPanelController:LoginCompleted( )

	print("登陆成功:LoginCompleted")
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	self.m_isLoginSuccessed = true
	Network.isLoginSuccessed=true
	RoomController.GetInstance().CanRequest = true
	if self.buffer == nil then return end
	local msg = self:ParseMsg(NetworkDefine.CRspOpenLoginMsgPara,self.buffer)
	ConfigModuleModel.GetInstance().mLoginState = CommonUtil.LuaTableToStringNoEmpty(msg.m_szLoginState)
	if SceneManager:GetInstance():GetCurrentSceneState()~=SceneManager.SceneType.Login then --断线从连
		self:HandleLoginMessageReLogin(msg)
		--查询上次在玩的游戏状态
		if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Room then --断线从连
			if HallRoomPanelController:GetInstance().view.panel then
				print("------------------------  重新刷新房间")
				HallRoomPanelController:GetInstance().view.panel:RefreshView_OffLine()
			end
		elseif SceneManager:GetInstance():GetCurrentSceneState()~=SceneManager.SceneType.Game then --断线从连
			self:CheckPlayingState(msg)
		end
		return
	end
	--初始化RoomInfoController
	RoomController:GetInstance()
	GameJackPotNotyModuleController.GetInstance()
	NotifyModuleController:GetInstance()
	
	self:InitMethodQueue()
	if msg.m_sResultID == 0 then
		--登陆成功
		local mainPlayer = SUserDetailInfo.New()
		mainPlayer.uiUserID = msg.m_unUin --用户UIN
		mainPlayer.iExperience = msg.m_unExperience --经验值
		mainPlayer.iMoney = (msg.m_unWalletMoney) --身上钱
		--print("""mainPlayer.iMoney = (msg.m_unWalletMoney)",msg.m_unWalletMoney)
		mainPlayer.iBank = (msg.m_unBankMoney) -- 银行钱
		mainPlayer.iTreasure = msg.m_unYuanbao --/元宝  钻石
		mainPlayer.bBoy = msg.m_ucSex == 1 --/1: 男, 0: 女
		mainPlayer.iImageNO = (msg.m_ucImageNo - 1) % GameConst.MAX_IMAGE_NUM + 1  --头像编号, 默认为1
		mainPlayer.szSignature = CommonUtil.LuaTableToStringNoEmpty(msg.m_szSignature) --/个性签名
		mainPlayer.szNickName = CommonUtil.LuaTableToStringNoEmpty(msg.m_szNickName) --/昵称
		if mainPlayer.szNickName == nil or mainPlayer.szNickName == ""  then
			mainPlayer.szNickName = CommonUtil.LuaTableToStringNoEmpty(msg.m_szAccountName) --/昵称 没有昵称是使用账户名代替
		end
		mainPlayer.m_ucBindFlag = msg.m_ucBindFlag==1 --/绑定微信标志，0 ： 未绑定 1 绑定
		mainPlayer.iVipLevel = msg.m_unVIPLevel--///VIP等级   1 1级代理 2 1及代理下面的普通用户 3 二级代理 4 二级代理下面的普通用户 5 三级代理 6 三级代理下面的普通用户  7 平台普通用户
		mainPlayer.m_unUserType = msg.m_unUserType--用户类型  1 审核中 0 不在审核中
		mainPlayer.iCertificateCellPhone = msg.m_ucCertificateCellPhone == 1--/是否已经认证手机号码
		mainPlayer.iCertificate = msg.m_ucCertificate == 1--/是否已经认证身份证号
		mainPlayer.uAreaID = msg.m_usAreaID --/运营商ID
		mainPlayer.uAgencyID = msg.m_usAgentID --/代理商
		mainPlayer.iTransFlag = msg.m_unTransFlag --/0: 关闭转帐功能, 1: 开启转帐功能 (房卡总代id）
		mainPlayer.iTransMin = msg.m_unTransMin --/每次转帐的最低金额 //兑奖码赠送房卡数量
		mainPlayer.iTransMax = msg.m_unTransMax --/每次转帐的最高金额
		mainPlayer.iTransTax = msg.m_unTransTax --/转帐抽水额度  【开放卡项目 ，此字段表示自己创建的房间房卡号，如果为0表示没有创建房间】
		mainPlayer.isSetPasswordFlag = msg.m_ucSetBankPasswordFlag == 1 --/是否设置银行密码
		mainPlayer.isRechargeFlag = msg.m_ucRechargeFlag == 1 --/是否首冲
		mainPlayer.szAccountName = CommonUtil.LuaTableToStringNoEmpty(msg.m_szAccountName) --账号名
		local szUserLevel = LuaHelperUtil.mBitConverter(msg.m_unVIPLevel)
		mainPlayer.UserAgentLevel = LuaHelperUtil.GetArrayByIndex(szUserLevel,0)
		mainPlayer.UserAgentCheckSign = LuaHelperUtil.GetArrayByIndex(szUserLevel,1)
		
		if(PlayerInfoController:GetInstance().model.mainPlayer ~= nil and PlayerInfoController:GetInstance().model.mainPlayer.uiUserID ~= mainPlayer.uiUserID) then
			LuaEvent:DispatchEvent(EventName.USERCHANGE)
		end
		self.model:SaveLoginType()

		HallGameModel:GetInstance():SetIsResetAllGameType(true)

		PlayerInfoController:GetInstance().model.mainPlayer = mainPlayer
		local loginInfo=CacheDataMgr.mLoginInfo
		PlayerInfoController:GetInstance():SaveUserLoginInfo(loginInfo.LoginName,loginInfo.Password,loginInfo.nLoginType)
		LuaEvent:DispatchEvent(EventName.LOGIN_SUCCESS_COMPLETE,mainPlayer)
		SceneManager:GetInstance():LoginToHallScene()
		--上传头像
		PlayerHeadPortainMgr:GetInstance():HeadUpload(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID,ConfigInfoMgr.ThirdPlatformHeadURL,PlayerInfoController:GetInstance().model.mainPlayer.iImageNO)
		--查询上次在玩的游戏状态
		self:CheckPlayingState(msg)
		
		LuaEvent:DispatchEvent(EventName.INITMAINPLAYERCOMPELED)
		self:ExcuteLoginMethodQueue()

		NetworkMgr:StarConentBroast()
		NetworkMgr:SetBroadcastIsLoginSuccess(true)
		-- self:UpLanguige()

		--- 上报设备信息
		ConfigModuleModel:GetInstance():ReportLoginDevice()
	else

	end
end


function LoginPanelController:UpLanguige( ... )
	local value = "0"
	local x = SystemSetting:GetInstance().CurrentLanguage
	if x == SystemSetting:GetInstance().LanguageType[1] then
	else
		value = "1"
	end
	
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
end

function LoginPanelController:OnBroatcastContentSuccess()
	-- body
	self:OnLolginBroadCast()
end

---登录广播服务器
function LoginPanelController:OnLolginBroadCast( ... )
	-- body
	local send = {}
	send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unCheckTime = os.time()
	send.m_szSalt = CommonUtil.StringToByteArrayTable(CommonUtil.mstate)
	for i=1,16 do
		if send.m_szSalt[i] == nil then
			send.m_szSalt[i] = 0
		end
	end
	local szTemp = StringFormat("{0}{1}{2}",CommonUtil.mstate,send.m_unCheckTime,send.m_unUin)
	local md5 = CommonUtil.GenMd5CheckCode(szTemp)
	send.m_szLoginCheckCode = CommonUtil.StringToByteArrayTable(md5)
	for i=1,32 do
		if send.m_szLoginCheckCode[i] == nil then
			send.m_szLoginCheckCode[i] = 0
		end
	end
	Net_SendHallData(NetworkDefine.CReqLoginBroadTransferPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CS_LOGIN_BROAD_TRANSER, 0)
end

---登录广播服务器返回
function LoginPanelController:OnLolginBroadCastBack(buffer)
	-- body
	local msg = self:ParseMsg(NetworkDefine.CRspLoginBroadTransferPara, buffer)
	if msg.m_sResultID == 0 then
		HallMailController.GetInstance().model:ReqMailList()
		--CaijinModuleController:GetInstance():RequestAllCaiJin()
	end
end


function LoginPanelController:ShowMailPanel(context)
	if not context then return end
	local num=context[1]
	if num>0 then
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallMail)
	end
end



function LoginPanelController:BackToLogin(context)
	self.model.mLogintype = HallDefine.LOGIN_TYPE.LOGINTYPE_NOLOGING
	self.model:SaveLoginType()
	HallRedEnvelopesController:GetInstance().model.mCanRequest = false
	--清除缓存数据
	ActivityModuleController:GetInstance():ClearData()
	--销毁好友模块数据
	FriendModuleController:GetInstance():ClearData()

	HallCashBackModel:GetInstance():ClearData()

	HallMidnightPartyModel:GetInstance():ClearData()
	HallFortuneCookieModel:GetInstance():ClearData()
	--销毁客服
	--HallServiceController:GetInstance():ClearData()
	--销毁vip数据
	-- HallVIPController:GetInstance():ClearData()
	--销毁背包数据
	--PackageModuleController:GetInstance():ClearData()
	--销毁子弹头商店数据
	--ShopModuleController:GetInstance():ClearData()
	--销毁商店数据
	StoreModuleController:GetInstance():ClearData()
    --数据销毁完开始通知重置面板
	LuaEvent:DispatchEvent(EventName.ResetPanel)
	--销毁个人信息数据
	if PlayerInfoController:GetInstance().model.mainPlayer then
		PlayerInfoController:GetInstance().model.mainPlayer:Destroy()
	end
	PlayerInfoController:GetInstance().model.mainPlayer=nil
	self.mLoginMethodQueueIndex = 1
    self.mLoginCompleteMethodQueue = {}
	print("返回到登录界面")
    NetworkMgr:SetBroadcastIsLoginSuccess(false)		--关闭广播服务器
	--退出Facebook账号
	PhoneManager:FacebookLogOut()
end

function LoginPanelController:HandleLoginMessageReLogin(msg)
	print("重新连接登陆，消息返回".."///时间戳:"..os.time())
	LuaEvent:DispatchEvent(EventName.RELOGIN_SUCCESS_COMPLETE)
end

--查询上次在玩的游戏状态
function LoginPanelController:CheckPlayingState(msg)
	if msg.m_usGameID==0 then
		print("没有保存上次在玩状态")
		--HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		return
	end
	self.NeedCheckGameSate = true
	local send={}
	send.m_unUin = msg.m_unUin or 0;
    send.m_unGameID = msg.m_usGameID or 0;
    send.m_unRoomID = msg.m_usRoomID or 0;
    send.m_unDeskIndex = msg.m_usDeskIndex or 0;
    send.m_unDeskStation = msg.m_usDeskStation or 0;
    Net_SendPlatformGameData(NetworkDefine.CReqCheckUserPlayingMsgPara, send, send.m_unGameID, NetworkDefine.E_MSG_ID.MSG_ID_CS_CHECK_GAME_STATE, send.m_unRoomID, send.m_unDeskIndex)
end



--登录失败
function LoginPanelController:LoginFail(context)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	if self.buffer == nil then return end
	local msg = self:ParseMsg(NetworkDefine.CRspOpenLoginMsgPara,self.buffer)
	local resultCode = msg.m_sResultID
	print("登录失败返回 错误码 ",resultCode, msg.m_unExperience)
	if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Login then
		if resultCode == -303 then
			LuaEvent:DispatchEvent(EventName.AccountLockLimit, msg.m_unExperience)
		else
			ServerBackPrompt(resultCode)
		end
	else
		local showData={}
		local showBoxData ={}
        showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
        showBoxData.context = StringFormatByLanguage("ConnectLoginFail")--内容；
        showBoxData.enterCB = function()
        	SceneManager:GetInstance():BackToLoginScene()
        end--：点击确定返回；
        showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮;
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
	end
end

--登录返回
function LoginPanelController:LoginSuccessCallBack(buffer)
	self.buffer = buffer
end

function LoginPanelController:GetInstance()
	if LoginPanelController.instance == nil then
		LoginPanelController.instance = LoginPanelController.New()
	end
	return LoginPanelController.instance
end

function LoginPanelController:NotifyUserOffLine(buffer)
	local msg=self:ParseMsg(NetworkDefine.CRspLogoutGamePlatformPara,buffer)
	print("强制玩家下线 :",msg.m_unResult)
	HeartManager:GetInstance():NotifyUserOffLine()
	local p=ResultID2Key(msg.m_unResult) or ""
	local showBoxData ={}
    showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
    showBoxData.context = StringFormatByLanguage(p)--内容；
    showBoxData.enterCB = function()
    	SceneManager:GetInstance():BackToLoginScene()
    end--：点击确定返回；

    showBoxData.cancelCB = function()
    	
    end--：点击取消返回，
    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮;
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function LoginPanelController:__delete( ... )
	LoginPanelController.instance = nil
	self.model = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
	Resources:UnloadUnusedAssets()
end

function LoginPanelController:InitMethodQueue( ... )
	self.mLoginMethodQueueIndex = 1
	self.mLoginCompleteMethodQueue = {}
	
end

function LoginPanelController:ExcuteLoginMethodQueue()

	if not(PlayerInfoController:GetInstance().model.mainPlayer.iCertificateCellPhone) and ConfigModuleModel.GetInstance().IsShowRegisterPayment then
		UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRagistMoney)
		
	else
		if ConfigModuleModel.GetInstance().IsShowActiveCenter then
			HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
		else
			HallRedEnvelopesController:GetInstance().model.mCanRequest = true
			HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		end
	end
	-- if self.mLoginCompleteMethodQueue and next(self.mLoginCompleteMethodQueue) then
	-- 	local func=table.remove(self.mLoginCompleteMethodQueue,1)
	-- 	if func then
	-- 		pcall(func)
	-- 	end
	-- end
end

----------------------------------------每日登陆签到--------------------------------------------------------

function LoginPanelController:ReqCUserEverydayLogin( )
	print("----------------------------------请求每日登陆签到-------------------------------")

	local send = {}
	send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID

	Net_SendHallData(NetworkDefine.CUserGetEverydayLogin,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_GET_EVERYDAY_LOGIN,0)
end

function LoginPanelController:RspUserEverydayLogin( )
	print("----------------------------------每日登陆签到-------------------------------")

	local msg=self:ParseMsg(NetworkDefine.CUserGetEverydayLoginRsp,buffer)
	if msg==nil then
		print("消息解析失败")
	end
end

function LoginPanelController:FacebookLoginCallBack(data)
	if self.model then
		self.model:FacebookLoginCallBack(data)
	end
end