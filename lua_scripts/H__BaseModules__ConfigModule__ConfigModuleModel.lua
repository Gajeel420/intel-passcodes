ConfigModuleModel=ConfigModuleModel or BaseClass(LuaModel)

function ConfigModuleModel:__init()
	self.listGameConfig={}
	self.listGameID={}
	self.listGameName = {}
	self.elistGameName = {}
	self.listGamePaths = {}
	self.ListGameServiceID = {}
	self.ListAutoDownLoadID = {}

	self.PayRecommendArray={}		--支付title排序列表

	self.mNikeNameList = {}

	self.LanguageType =1

	self.PaoMaDengDisplayCount = 0 	--跑马灯显示的行数
	self.GameNotifyRebate = 0 		--游戏跑马灯显示比例
	self.VipNotifyRebate = 0 		--VIP充值公告比例
	self.BackNotifyRebate = 0 		--后台跑马灯公告比例
	self.CommissionNotifyRebate = 0	--领取佣金公告比例

    self.IsEnableAccount = false  --是否启用帐号登录
    self.IsEnableGuest= false --是否启用游客登录
    self.IsEnableWeiXin = false --是否启用微信登录
    self.IsEnableQQ= false    --是否启用QQ登录
	self.IsEnableRegist = false    -- 是否开启注册
	self.IsOpenRegistByPhon = false --是否开启短信注册
	self.IsOpenFacebookLogin = false
	
	self.IsShowMail = true --是否显示Email
	self.IsShowSetting = true --设置
	self.IsShowPlayerInfo = true --个人信息是否显示
	self.IsShowRecharge = true --充值是否显示
	self.IsShowShare = true --分享
	self.IsShowCJ = true --转盘
	self.IsShowBank = true --是否显示银行
	self.IsShowService = true --客服
	self.IsShowTuiGuang = false --是否显示推广
	self.IsShowGive=false --是否显示礼物
	self.IsShowExchange=false --是否显示兑换
	self.isShowWashCode = false --是否显示戏码
	self.IsShowRank = false  	-- 是否显示排行榜
	self.IsShowActiveCenter = false  	-- 是否活动中心
	self.IsShowRegisterPayment = false 	--是否显示注册送金
	self.IsShowLoginNotices = true  ---是否显示登录公告
	self.IsShowFirstRechargeRabe = true
	self.IsShowFortunaMission = false  ----是否显示财神任务

	self.CanChanangeBindInfo = false --是否能够修改绑定信息

	self.DisPlayArcade = false		--是否显示分类

	self.isAppStore = 0
	


	self.listVIPDes={} -- Vip信息描述
	self.LimtVipGiveLevel = 0 --vip等级限制赠送物品类型 
	self.GiveViewTips = nil --vip赠送物品提示

	self.GiveList={}

	self.IsNeedDianKaPassWord = false
	self.CashWithdrawalRatio=1
	--self.NoticeMsg=""
	self.RevenueAlert="结算金额至少100金币（结算收取1.5%的手续费，最低1.5元）"
	self.MinimumExchangeAmount=100
	self.RegisteredPayment=1

	self.WithdrawalLevel = 1
	self.GiftCanInputLevel = 1

	self.BannerURL = ""
	self.SaveGameSuffix = "/save"   ----保存游戏推广页后缀

	self.ClientKey = "our-secret"

	self.SpecialCharList = 
	{
		"/",
		",",
		">",
		"<",
		"'",
		"\n",
		"\b",
	}

	self.GameSceneDisplayHallNotify = true			---是否显示跑马灯

	self.exchangetype = {alipay = true,bank = true,record=true}

	self.RankListType = {GameblingList = true,RichList = true,ExtremeList =true,commissionList=false}

	self.PayListConfig = 
	{
		AliPay = { Rebate = 0,Tips=""},
		WechatPay = { Rebate = 0,Tips=""},
		PointCard = { Rebate = 0,Tips=""},
		AgentPay = { Rebate = 0,Tips=""},
		CloudFlash = { Rebate = 0,Tips=""},
		AlipayQR = { Rebate = 0,Tips=""},
		WechatQR = { Rebate = 0,Tips=""},
		BankTransfer = { Rebate = 0,Tips="",alipay=true,wechatpay=true,bankpay=true},
		OnePayment = { Rebate = 0,Tips=""},
		AlipayKC = { Rebate = 0},Tips="",
		WechatPayKC = { Rebate = 0,Tips=""},
	}

	self.UseGameRebate = true
	self.ActiveCenterUrl = ""

	self.mLoginState = ""
	self.CanBindByClient = false

	self.mCheckAgentID = "0"

end

function ConfigModuleModel : LoadRoomConfigXml()
	local cb = function(data)
		self:ParseGameConfigXmlText(data)
	end
	--ConfigInfoMgr.IsSpeed = true
	resMgr:LoadPhoneZip(UIPanelDefine.ConfigFileName[1],cb)
end

function ConfigModuleModel : LoadUIConfigXml()
	local cb = function(data)
		self:ParseGameUIConfigXmlText(data)
	end
	resMgr:LoadPhoneZip(UIPanelDefine.ConfigFileName[2],cb)
end

function ConfigModuleModel : LoadDataHotXml()
	local cb = function(data)
		self:ParseDataHotXmltext(data)
	end
	resMgr:LoadPhoneZip(UIPanelDefine.ConfigFileName[3],cb)
end

function ConfigModuleModel: ParseDataHotXmltext(content)
	local parseXml=Xml:ParseXmlText(content)
	local rootNode=parseXml.ROOT
	local  urlData = rootNode.BannerURL
	if urlData then
		self.BannerURL = urlData["@url"]
	end
	
	urlData = rootNode.ActiveCenterURL
	if urlData then
		self.ActiveCenterUrl = urlData["@url"]
		print("self.ActiveCenterUrl",self.ActiveCenterUrl)
	end

end


function ConfigModuleModel:ParseGameConfigXmlText(content)
	local parseXml=Xml:ParseXmlText(content)
	local rootNode=parseXml.ROOT
	if rootNode==nil then
		rootNode=parsedXml.root
	end
	local goldGameConfigNode=rootNode.GoldGame
	if #goldGameConfigNode.gameitem==0 then

	else
		for i=1,#goldGameConfigNode.gameitem do
			local gameNode=goldGameConfigNode.gameitem[i]
			local gameConfig={}
			gameConfig.iGameCID=tonumber((gameNode["@id"]))
			gameConfig.iGameSID=tonumber((gameNode["@serverid"]))
			gameConfig.strGameName=(gameNode["@name"])
			gameConfig.iGameType=tonumber((gameNode["@gametype"]))
			gameConfig.iShowCaiJin=tonumber((gameNode["@showcaijin"]))
			gameConfig.iStatus=tonumber((gameNode["@status"]))
			gameConfig.iRoomIndex=tonumber((gameNode["@roomindex"]))
			gameConfig.Ename=(gameNode["@Ename"])
			
			local screenOrientatione =gameNode["@screenOrientatione"]
			if screenOrientatione then
				gameConfig.iScreenOrientatione=tonumber(screenOrientatione)
			end
			gameConfig.iOpen=tonumber((gameNode["@open"]))
			self.listGamePaths[i] =  "Phone/Prefabs/Game/"..tostring(gameConfig.iGameCID)..".unity3d"--资源路径
			ConfigInfoMgr:AddCSGameID(gameConfig.iGameCID,gameConfig.iGameSID)
			table.insert(self.listGameConfig, gameConfig)
			self.listGameID[gameConfig.iGameCID]=gameConfig.iGameSID
			self.listGameID[gameConfig.iGameSID]=gameConfig.iGameCID
			self.listGameName[gameConfig.iGameSID] = gameConfig.strGameName
			
			self.elistGameName[gameConfig.iGameSID] = gameConfig.Ename
			self.ListGameServiceID[gameConfig.iGameSID] = gameConfig.iGameSID
			if gameNode["@isautodownload"] then
				table.insert(self.ListAutoDownLoadID, gameConfig.iGameCID )
			end
		end
	end
	
end

function ConfigModuleModel:GetGameConfigList()
	return self.listGameConfig
end

function ConfigModuleModel:GetGameConfigByCID(CID)
	local gameConfig=nil

	for i, v in ipairs(self.listGameConfig) do
		if  tonumber(v.iGameCID)==tonumber(CID) then
			gameConfig=v
		end

	end

	return gameConfig
end


function ConfigModuleModel:GameIDChange( id )
	return self.listGameID[id]
end

function ConfigModuleModel:GetGameNameByServerID( serverid )
	-- body
	return self.listGameName[serverid]
end

function ConfigModuleModel: GetListGamePaths()
	return self.listGamePaths;
end

function ConfigModuleModel: GetGameConfigLength()
	local total = 0;
	for k,v in pairs(self.listGameConfig) do
        total = total + 1
	end
	return total
end

function ConfigModuleModel:GetOnePrivilegeDesc(level)
	local desc=""
	if self.listVIPDes then
		if self.listVIPDes[level] then
			desc=self.listVIPDes[level]
		end
	end
	return desc
end

function ConfigModuleModel:ParserRechargeAttributes(payItem,ConfigName)
	if payItem ~= nil then
		
		local pay = payItem["@alipay"]
		if pay ~= nil then
			self.PayListConfig[ConfigName].alipay = tonumber(pay) == 1
		end
		pay = payItem["@wechatpay"]
		if pay ~= nil then
			self.PayListConfig[ConfigName].wechatpay = tonumber(pay) == 1
		end
		pay = payItem["@bankpay"]
		if pay ~= nil then
			self.PayListConfig[ConfigName].bankpay = tonumber(pay) ==1
		end
	end
end


function ConfigModuleModel:ParseGameUIConfigXmlText(content)
	local parseXml=Xml:ParseXmlText(content)
	local rootNode=parseXml.ROOT
	if rootNode==nil then
		rootNode=parsedXml.root
	end

	local rechargeNode=rootNode.Recharge

	if rechargeNode ~= nil then
		-- local recommend=rechargeNode.Recharge["@recommend"]
		-- if recommend~=nil then
		-- 	self.PayRecommendArray=StringSplit(recommend,",")
		-- end
		-- self:ParserRechargeAttributes(rechargeNode.AliPay,"AliPay")
		-- self:ParserRechargeAttributes(rechargeNode.WechatPay,"WechatPay")
		-- self:ParserRechargeAttributes(rechargeNode.PointCard,"PointCard")
		-- self:ParserRechargeAttributes(rechargeNode.AgentPay,"AgentPay")
		-- self:ParserRechargeAttributes(rechargeNode.CloudFlash,"CloudFlash")
		-- self:ParserRechargeAttributes(rechargeNode.AlipayQR,"AlipayQR")
		-- self:ParserRechargeAttributes(rechargeNode.WechatQR,"WechatQR")
		self:ParserRechargeAttributes(rechargeNode.BankTransfer,"BankTransfer")
	-- 	self:ParserRechargeAttributes(rechargeNode.OnePayment,"OnePayment")
	-- 	self:ParserRechargeAttributes(rechargeNode.AlipayKC,"AlipayKC")
	-- 	self:ParserRechargeAttributes(rechargeNode.WechatPayKC,"WechatPayKC")
	end 

	local UseGameRebateNode = rootNode.UseGameRebate
	if UseGameRebateNode ~= nil then
		local value = UseGameRebateNode["@useing"]
		if value ~= nil then
			self.UseGameRebate = tonumber(value) == 1
		end
	end

	local speedNode=rootNode.IsOpenSpeed
	if speedNode ~= nil then
		local value = speedNode["@value"]
		if value ~= nil then
			ConfigInfoMgr.IsSpeed = tonumber(value) == 1
		end
	end
	
	

	local languageNode=rootNode.language
	if(tonumber(languageNode["chinese"]) ==1) then
		self.LanguageType = 1
	elseif(tonumber(languageNode["english"]) ==1) then
		self.LanguageType = 2
	elseif(tonumber(languageNode["fanti"]) ==1) then
		self.LanguageType = 3
	end

	local notifyNode=rootNode.Notify
	if notifyNode ~= nil then
		local rebate = notifyNode["@disPlayCount"]
		if rebate ~= nil then
			self.PaoMaDengDisplayCount = tonumber(rebate)
		end

		rebate = notifyNode["@GameRebate"]
		if rebate ~= nil then
			self.GameNotifyRebate = tonumber(rebate)
		end

		rebate = notifyNode["@VIPRebate"]
		if rebate ~= nil then
			self.VipNotifyRebate = tonumber(rebate)
		end

		rebate = notifyNode["@BackNoteRebate"]
		if rebate ~= nil then
			self.BackNotifyRebate = tonumber(rebate)
		end

		rebate = notifyNode["@CommissionRebate"]
		if rebate ~= nil then
			self.CommissionNotifyRebate = tonumber(rebate)
		end

	end

	local loginType = rootNode.logintype
	if(tonumber(loginType["@account"]) == 1) then
		self.IsEnableAccount = true
	end
	if(tonumber(loginType["@guest"]) == 1) then
		self.IsEnableGuest = true
	end
	if(tonumber(loginType["@weixin"]) == 1) then
		self.IsEnableWeiXin = true
	end
	if(tonumber(loginType["@qq"]) == 1) then
		self.IsEnableQQ = true
	end
	if(tonumber(loginType["@regist"]) == 1) then
		self.IsEnableRegist = true
	end
	if(tonumber(loginType["@registbyphone"]) == 1) then
		self.IsOpenRegistByPhon = true
	end
	if(tonumber(loginType["@Facebook"]) == 1) then
		self.IsOpenFacebookLogin = true
	end

	local exchangeType = rootNode.exchangetype
	if exchangeType ~= nil then
		self.exchangetype.alipay = tonumber(exchangeType["@alipay"]) == 1
		self.exchangetype.bank = tonumber(exchangeType["@bank"]) == 1
		self.exchangetype.record = tonumber(exchangeType["@record"]) == 1
	end

	local ranklisttype = rootNode.ranklisttype
	if ranklisttype ~= nil then
		self.RankListType.GameblingList = tonumber(ranklisttype["@gameblinglist"]) == 1
		self.RankListType.RichList = tonumber(ranklisttype["@richlist"]) == 1
		self.RankListType.ExtremeList = tonumber(ranklisttype["@extremelist"]) == 1
		self.RankListType.commissionList = tonumber(ranklisttype["@commission"]) == 1
	end

	local platform = rootNode.platform
	for i=1,#platform.item do
		local itemName=tostring(platform.item[i].functionname:value())
		local itemValue=tostring(platform.item[i].isshow:value()) == "1"  and true or false 

		if(itemName == "Button_Mail") then
			self.IsShowMail = itemValue 
		elseif  (itemName == "Button_Set") then
			self.IsShowSetting = itemValue 
		elseif  (itemName == "Button_UserInfo") then
			self.IsShowPlayerInfo = itemValue 
		elseif  (itemName == "Button_CZ") then
			self.IsShowRecharge = itemValue 	
		elseif  (itemName == "Button_Share") then
			self.IsShowShare = itemValue 		
		elseif  (itemName == "Button_CJ") then
			self.IsShowCJ = itemValue 
		elseif  (itemName == "Button_Bank") then
			self.IsShowBank  = itemValue
		elseif  (itemName == "Button_Rank") then
			self.IsShowRank  = itemValue 	
		elseif  (itemName == "Button_Service") then
			self.IsShowService  = itemValue 			
		elseif  (itemName == "Button_TuiGuang") then
			self.IsShowTuiGuang  = itemValue 		
		elseif  (itemName == "Button_Give") then
			self.IsShowGive  = itemValue 	
		elseif  (itemName == "Button_Exchange") then
			self.IsShowExchange  = itemValue 
		elseif  (itemName == "Button_Wash") then
			self.isShowWashCode  = itemValue 
		elseif  (itemName == "Button_ActiveCenter") then
			self.IsShowActiveCenter  = itemValue
		elseif  (itemName == "Button_RegisterPayment") then
			self.IsShowRegisterPayment  = itemValue
		elseif  (itemName == "Button_LoginNotices") then
			self.IsShowLoginNotices  = itemValue
		elseif  (itemName == "Button_FirstRechargeRabe") then
			self.IsShowFirstRechargeRabe  = itemValue
		elseif  (itemName == "Button_FortunaMission") then
			self.IsShowFortunaMission  = itemValue							
		end
	end


	local giveNode = rootNode.Give
	for i=1,10 do
		local desc=giveNode.Give["@item".. i]
		if desc~=nil then
			table.insert(self.GiveList,tostring(desc))
		else
			break
		end
	end

	local Node=rootNode.DianKa
	if Node~= nil then
		local isNeedPassWord = Node["@IsNeedPassword"]
		self.IsNeedDianKaPassWord = tonumber(isNeedPassWord) == 1
	end

	Node = rootNode.IsAppStore
	if Node ~= nil then
		self.isAppStore = tonumber(Node["@value"])
	end

	local CashWithdrawalNode=rootNode.CashWithdrawal
	if CashWithdrawalNode then
		local ratio=tonumber(CashWithdrawalNode.CashWithdrawal["@Ratio"])
		if ratio then
			self.CashWithdrawalRatio=ratio
		end
	end


	local bindInfo=rootNode.CanChanangeBindInfo
	if bindInfo then
		local info=tonumber(bindInfo["@value"])
		if info then
			self.CanChanangeBindInfo= tonumber(info) == 1
		end
	end

	local data=rootNode.DisPlayArcade
	if data then
		local info=tonumber(data["@value"])
		if info then
			self.DisPlayArcade= tonumber(info) == 1
		end
	end
	
	data=rootNode.CanBindByClient
	if data then
		local info=tonumber(data["@value"])
		if info then
			self.CanBindByClient= tonumber(info) == 1
		end
	end

	local RevenueAlertNode=rootNode.RevenueAlert
	if RevenueAlertNode then
		local RevenueAlert=RevenueAlertNode["@item"]
		if RevenueAlert then
			self.RevenueAlert=RevenueAlert
		end
	end


	local MinimumExchangeAmountNode=rootNode.MinimumExchangeAmount
	if MinimumExchangeAmountNode then
		local MinimumExchangeAmount=MinimumExchangeAmountNode["@amount"]
		if MinimumExchangeAmount then
			self.MinimumExchangeAmount=tonumber(MinimumExchangeAmount)
		end
	end

	local RegisteredPaymentAmountNode=rootNode.RegisteredPayment
	if RegisteredPaymentAmountNode then
		local RegisteredPayment=RegisteredPaymentAmountNode["@amount"]
		if RegisteredPayment then
			self.RegisteredPayment=RegisteredPayment
		end
	end

	local data = rootNode.WithdrawalLevel
	if data then
		local level = data["@level"]
		if level then
			self.WithdrawalLevel = tonumber(level) -- 撤回礼物需要等级
		end
	end

	data = rootNode.GiftCanInputLevel
	if data then
		local level = data["@level"]
		if level then
			self.GiftCanInputLevel = tonumber(level) -- 撤回礼物需要等级
		end
	end
	data = rootNode.CheckAgentID
	if data then
		local value = data["@value"]
		if value then
			self.mCheckAgentID = value
		end
	end

	data = nil
end

--导入随机名字配置
function ConfigModuleModel:ImportNameText()
	--body
	local temp = Resources.Load(UIPanelDefine.ConfigFileName[4],typeof(TextAsset))
	if temp == nil then return end
	local tab = StringSplit(temp.text,"|")
	local count = #tab
	for i=1,count do
		table.insert(self.mNikeNameList,tab[i])
	end

end

function  ConfigModuleModel:GetRandomName()
	-- body

	local count = math.random(1,#self.mNikeNameList)

	return self.mNikeNameList[count]
end

function ConfigModuleModel:ReportLoginDevice()
	--处理数据
	local device_type = 3  --Android Windows ios 0-2
	local device_category = 3  --phone pad compute 0-2
	local device_model = SystemInfo.deviceModel

	local os_version = {}
	os_version.os = SystemInfo.operatingSystem
	os_version.device = ""
	if LuaUtils.IsSimulator() then
		os_version.device = "Emulator "
	end
	os_version.vpn = "0"
	os_version.lang = Application.systemLanguage:ToString()
	os_version.tz = tostring(LuaUtils.GetTimeZone())
	local os_versionStr = Json.encode(os_version)

	local platformName = AppConst.PlatformName()
	local client_version = "unity_"..Application.unityVersion
	if platformName == "Windows" then
		device_type = 1
		device_category = 2
	elseif platformName == "Android" then
		device_type = 0
		local physicscreen = 1.0 * Screen.width / Screen.height
		if Screen.width < Screen.height then
			physicscreen = 1.0 * Screen.height / Screen.width
		end
		if physicscreen > 1.5 then
			device_category = 0
		else
			device_category = 1
		end
	else
		device_type = 2
		local resultStr = string.match(device_model,"iPhone")
		if resultStr == "iPhone" then
			device_category = 0
		else
			device_category = 1
		end
	end

	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uAgenID,uiUserID,uTime},"|")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"client_version",client_version},
		{"device_type",device_type},
		{"device_category",device_category},
		{"device_model",device_model},
		{"os_version",os_versionStr},
		{"mac",PhoneManager:GetDeviceUniqueIdentifier() or ""},
		{"login_state",self.mLoginState},
		{"itime",uTime},
		{"code",code},
	}
	-- local failFunc = function ( ... )
	-- 	-- 报失败
	-- end

	local sucFunc = function ( datas )
		if datas.retcode==0  then
			--上报成功
			-- print("----------------   上报设备信息成功")
        else
			-- print("----------------   上报设备信息失败 --- ", datas.retcode, datas.msg)
            --UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.Report_Login_Device,postTable,sucFunc,nil,nil,false)
end


-- 重置服务器 配置信息
function  ConfigModuleModel:ResetServerConfigInfo(data)
	if data then
		local dataInfo = 
		{
			{"m_szDomain4Web",data.m_szDomain4Web},
			{"m_szDomain4Download",data.m_szDomain4Download},
			{"m_szDomain4Broadcast",data.m_szDomain4Broadcast},
			{"m_szDomain4Login",data.m_szDomain4Login},
			{"m_szDomain4Activity",""},
		}
		CommonUtil.DomainCfigByUserVIP(dataInfo)
	end
end

function ConfigModuleModel:ClientCommonConfig(callBack )
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uAgenID,uiUserID,uTime},"|")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"time",uTime},
		{"code",code},
	}

	local sucFunc = function ( datas )
		PrintLog("ClientCommonConfig==================")
		pt(datas)
		if datas.retcode==0  then
			-- self.WithdrawalRestrictions = datas.data.cashout_amount
			-- self.IsBindPhone = datas.data.is_bind_phone
			--print("888888888888888888",self.IsBindPhone)
			self.adPopStatus = tonumber(datas.data.client_popup_status) == 1
            if callBack then
                callBack()
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.Client_Common_Config,postTable,sucFunc,nil,nil,false)
end

function ConfigModuleModel:GetInstance()
	if ConfigModuleModel.instance==nil then 
		ConfigModuleModel.instance=ConfigModuleModel.New()
	end
	return ConfigModuleModel.instance
end

function ConfigModuleModel:__delete()
	
end

