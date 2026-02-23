PlayerInfoController = PlayerInfoController or BaseClass(LuaController)

require"H/Modules/PlayerInfo/PlayerInfoModel"
require"H/Modules/PlayerInfo/PlayerInfoConst"
require"H/Modules/PlayerInfo/Vo/SUserDetailInfo"
require"H/Modules/PlayerInfo/Vo/TUserInfo"

function PlayerInfoController:__init( ... )
	self.model = PlayerInfoModel.New()
	self.userInfo = TUserInfo.New()
	self:RegistProto()
	self:AddEvent()
end


--监听请求商品列表返回
function PlayerInfoController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_MONEY_REQUEST_CHANGE,"RefreshUserData") --监听用户数据变更消息
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_UPDATE_USERINFO,"ResUpdateUserInfo") --更新用户信息
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_QUERY_AIXIN_RATIO,"RsqQueryAiXinRatio") --监听查询爱心率返回
end

--用户数据变更刷新数据
function PlayerInfoController:RefreshUserData(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRspReFlushMoneyMsgPara, buffer)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	if msg.m_sResult == 0 then
	    if msg.m_unUin == self.model.mainPlayer.uiUserID then --返回ID相同
	    	local vo={}
	    	vo.iBank = (msg.m_i64BankBalance) --银行余额
	    	vo.iTreasure = msg.m_i64TreasureBalance --钻石余额
	    	vo.iMoney = (msg.m_i64CoinBalance) --金币余额
	    	vo.iLuckyBomb = msg.m_i64LuckyBomb --道具炸弹余额
	    	vo.m_i64LossPoints = msg.m_i64LossPoints --玩家拥有爱心数
			LuaEvent:DispatchEvent(EventName.REFRESHUSERDATA) --刷新用户数据
	    	self.model.mainPlayer:UpdateVo(vo)
	    end
	end
end

function PlayerInfoController:ResUpdateUserInfo(buffer)
	print("【@@@@】更新用户信息")
	self.isShow = true
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	local msg=CRspUpdatePlayerInfoMsgPara.Decode(buffer)
	pt(msg)
	if msg.m_sResultID==0 then
		
		local valStr=CommonUtil.LuaTableToStringNoEmpty(msg.m_szInfo)
		local valArray=StringSplit(valStr,",")
		local bitList={}
		for _,bit in pairs(HallDefine.E_ACCOUNT_TABLE_FIELD_BIT) do --不能保证有序 小的应放前面
			if((msg.m_unFieldTypeBits & bit)>0) then
				table.insert(bitList,bit)
			end
		end
		bitList = LuaUtils.SortTable(bitList)
	
		if #valArray~=#bitList then
			print("error[@@@]==!!! User Info 消息解析失败!!! length:",#valArray," #bitList:",#bitList)
			return
		end
		for i=1,#bitList do
			self:SetUserInfo(bitList[i],valArray[i])
		end
		if self.isShow then 
			UIManager:GetInstance():ShowNoteMessage("UserInfo_Modify_Success")
		end
	else
		ServerBackPrompt(msg.sResultID)
	end
end

function PlayerInfoController:SetUserInfo(bitType, val)
	local vo={}
	if bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_ID then
		vo.uiUserID=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Type then
		vo.iUserType=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_NickName then
		vo.szNickName=val
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_VipLevel then
		vo.iVipLevel=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Points then
		vo.iExperience=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_CertificatePhone then
		vo.iCertificateCellPhone=tonumber(val)==1
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_CertificateIDCArd then
		vo.iCertificate=tonumber(val)==1
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Sex then
		vo.bBoy=tonumber(val)==1
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Birthday then
		vo.dwBirthday=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_AreaID then
		vo.uAreaID=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_AgentID then
		vo.uAgencyID=tonumber(val)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_ImageNo then
		vo.iImageNO=tonumber(val)
		-- GetCSAPI.EventCallDataCenterChange(HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_ImageNo)
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Signature then
		vo.szSignature=val
	elseif bitType==HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Languige then
		HallNotifyController:GetInstance().model.mNotifyList = {}
		self.isShow = false
		HallMailModel:GetInstance():ReqMailListAgain()
	else

	end
	self.model.mainPlayer:UpdateVo(vo)
end

--查询爱心比率返回
function PlayerInfoController:RsqQueryAiXinRatio(buffer)
	local msg = self:ParseMsg(NetworkDefine.CRspQueryAiXinRatioMsgPara, buffer)
	if msg.m_sResult == 0 then
		if msg.m_sType == 1 then
			self.model.mainPlayer.SendHeartRatio = (msg.m_unRatio)
		elseif msg.m_sType == 2 then
			self.model.mainPlayer.ExpendHeartRatio = (msg.m_unRatio)
		else
			print("返回查询爱心比率类似有误！ message.m_sType : " , msg.m_sType)
		end
	else
		print("返回类型有误msg.m_sResult：  ", msg.m_sResult)
	end
end


--登录完成事件监听
function PlayerInfoController:AddEvent()
	LuaEvent:AddEventListener(EventName.LOGIN_SUCCESS_COMPLETE,self.ReqGetUserMoney,self) 
	-- LuaEvent:AddEventListener(EventName.LOGIN_SUCCESS_COMPLETE,self.GetExpendHeartRatio,self)
end

function PlayerInfoController:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.LOGIN_SUCCESS_COMPLETE,self.ReqGetUserMoney,self) 
	-- LuaEvent:RemoveEventListener(EventName.LOGIN_SUCCESS_COMPLETE,self.GetExpendHeartRatio,self)
end

--请求个人信息
function PlayerInfoController:RequestGetUserMoney()
	if SceneManager:GetInstance():GetCurrentSceneState() ~= SceneManager.SceneType.Login then
		if self.model~=nil then
			if self.model.mainPlayer~=nil then
				print("请求刷新用户金钱")
				self:ReqGetUserMoney()
			end
		end
	end
end

--请求用户信息
function PlayerInfoController:ReqGetUserMoney( )
	local send = {}
	send.m_iSize = 0
	send.m_unUin = self.model.mainPlayer.uiUserID
	--UIManager.GetInstance():ShowNetWorkMessage("加载中","",2)
	Net_SendHallData(NetworkDefine.CReqGetUserMoneyDataMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_MONEY_REQUEST_CHANGE, 0)	
end

-- 存储用户的登录信息 --account 账号名,  password  密码（静态）,  loginType（登录方式）
function PlayerInfoController:SaveUserLoginInfo( account,  password,  loginType)
	if password == nil then
	else
	end


	if loginType == NetworkDefine.E_ACCOUNT_TYPE.E_ACCOUNT_TYPE_NORMAL then
		local isRem = (PlayerPrefs.GetInt(GameConst.Key_UserAccount_Remember,1) == 1)
		if isRem then
			PlayerPrefs.SetString(AppConst.Key_UserAccount, account)
		    PlayerPrefs.SetString(AppConst.Key_UserPassword, password)
		else
			PlayerPrefs.SetString(AppConst.Key_UserAccount, "")
		    PlayerPrefs.SetString(AppConst.Key_UserPassword, "")
		end
		
		local addTabel={}
		addTabel.account=account
		addTabel.password=password
		SystemSetting.GetInstance():AddAccountAndPasswordTable(addTabel)
	end

	PlayerPrefs.SetInt(AppConst.Key_LoginType, tonumber(loginType))
end

--请求更新玩家签名
function PlayerInfoController:ReqUpdateUserInfo(currentSignature)
	if ConTainsSpecial(currentSignature) then
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("UserSignature_SpecialChar"))
		return
	end
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unTime = CommonUtil.GetCurrentTimeStamp()
	send.m_unFieldTypeBits = 8388608 --用户个性签名 E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Signature
	send.m_usInfoLen = string.len(currentSignature)
	send.m_szInfo = CommonUtil.StringToByteArrayTable(currentSignature)
	NetworkDefine.CReqUpdatePlayerInfoMsgPara={
	    {"m_unUIN","Int32",0},--用户id
	    {"m_unTime", "Int32", 0},--时间
	    {"m_unFieldTypeBits", "Int64", 0},--要修改的字段位掩码
	    {"m_usInfoLen","UInt16",0},--实际长度
	    {"m_szInfo","Byte[]",string.len(currentSignature)},--更新的内容, ","分隔各信息内容, 各信息内容以字符串的形式存入缓冲区
	}
	NetworkMgr:AddMsgStruct("NetworkDefine.CReqUpdatePlayerInfoMsgPara",NetworkDefine.CReqUpdatePlayerInfoMsgPara)
	Net_SendHallData(NetworkDefine.CReqUpdatePlayerInfoMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_UPDATE_USERINFO, 0)
end

function PlayerInfoController:GetInstance()
	if PlayerInfoController.instance == nil then 
		PlayerInfoController.instance = PlayerInfoController.New()
	end
	return PlayerInfoController.instance
end


function PlayerInfoController:__delete( ... )
	self:RemoveEvent()
end