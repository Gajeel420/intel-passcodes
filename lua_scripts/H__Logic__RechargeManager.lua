
RechargeManager = RechargeManager or BaseClass(LuaController)

function RechargeManager:__init()
    self:AddEvent()
    self.mID = 0
    self.mOrderID = 0  -- 订单id
    self.mIsNeedCheckPayment = false
    self.mLastPayLink = nil
    self.mLastMid = 0
    self.LastPayTime = 0
    self.mPayLink = nil
end

function RechargeManager:__delete( ... )
    self:RemoveEvent()
end

function RechargeManager:GetInstance()
    if RechargeManager.instance == nil then
        RechargeManager.instance = RechargeManager.New()
    end
    return RechargeManager.instance
end

function RechargeManager:AddEvent()
    LuaEvent:AddEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.CheckPayment,self)
    LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.CheckPayment,self)
    LuaEvent:AddEventListener(EventName.APPLEPAYCHECKPAYMENT,self.AppleCheckPayment,self)
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CHANGE_PayMent,"HandleUserPayCheckMent")
    LuaEvent:AddEventListener(EventName.OPEN_RECHARGEPANEL,self.OpenRechargePanel,self) --lua打开商店
end

function RechargeManager:RemoveEvent()
    LuaEvent:RemoveEventListener(EventName.RELOGIN_SUCCESS_COMPLETE,self.CheckPayment,self)
    LuaEvent:RemoveEventListener(EventName.PAYCHECKPAYMENT,self.CheckPayment,self)
    LuaEvent:RemoveEventListener(EventName.APPLEPAYCHECKPAYMENT,self.AppleCheckPayment,self)
    LuaEvent:RemoveEventListener(EventName.OPEN_RECHARGEPANEL,self.OpenRechargePanel,self) --lua打开商店
end




function RechargeManager:OpenRechargePanel()
    StoreModuleController:GetInstance():RequiredPayMoneyList(function()
        if HallVipRechargeTipsModel.GetInstance():GetIsShowVipRechargeTips() == 1 then
            UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallVipRechargeTips)
        else
            UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
        end
    end)
end


-- 充值验单消息返回
function RechargeManager:HandleUserPayCheckMent( buffer )
    local msg = self:ParseMsg(NetworkDefine.CRspCheckPaymentMsgPara, buffer)

        if(SceneManager:GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game) then
            self:ReqAccountChangeNotify()
        end

    if msg.m_sResult == 0 then
        if msg.m_unUin == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("ReChargeSucess"), 2)
            PlayerInfoController:GetInstance().model.mainPlayer.iMoney = (msg.m_un64CoinBalance)
            PlayerInfoController:GetInstance().model.mainPlayer.iBank = (msg.m_un64BankBalance)
            LuaEvent:DispatchEvent(EventName.REFRESHUSERDATA) --刷新用户数据

            -- 游戏中通知刷新玩家金币
            if(SceneManager:GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game) then
                self:ReqAccountChangeNotify()
            end
        else
            --UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Info_Wrong"), 2)
            print("用户ID有误 :  "..msg.m_iUin)
        end
    else
        --ServerBackPrompt(msg.m_sResult)
    end
end

-- 请求充值验单
function RechargeManager:ReqCheckPayment()
    local send = {}
    send.m_unSize = 0
    send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_unOrderID = self.mOrderID
    send.m_unAmount = self.mMianENum

    print("uin " , send.m_unUin , " m_unOrderID ",send.m_unOrderID, "  m_unAmount ",send.m_unAmount)
    Net_SendHallData(NetworkDefine.CReqCheckPaymentMsgPara,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CHANGE_PayMent,0)
end

-- 游戏中通知刷新玩家金币消息
function RechargeManager:ReqAccountChangeNotify()
    print("游戏中通知刷新玩家金币消息")
    local send = {}
    send.m_unUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID

    local m_usGameID = PlayerInfoController:GetInstance().model.mainPlayer.desk.m_usGameID
    local m_usRoomID = PlayerInfoController:GetInstance().model.mainPlayer.desk.m_usRoomID
    local m_usDeskIndex = PlayerInfoController:GetInstance().model.mainPlayer.desk.m_usDeskIndex

    print("m_usGameID",m_usGameID,"m_usRoomID",m_usRoomID,"m_usDeskIndex",m_usDeskIndex)

    Net_SendPlatformGameData(NetworkDefine.CReqAccountChangesNotifyMsgPara,send,m_usGameID,NetworkDefine.E_MSG_ID.MSG_ID_CS_GAME_ACCOUNT_CHANGES_NOTIFY,m_usRoomID,m_usDeskIndex)
end

--支付验单消息
function RechargeManager:CheckPayment( ... )
    if SceneManager:GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Login then return end
    --请求刷新用户金币信息
    PlayerInfoController:GetInstance():RequestGetUserMoney()

    if(self.mIsNeedCheckPayment) then
        self.mIsNeedCheckPayment = false
        print("发送支付验单消息")
        self:ReqCheckPayment()
    end
end

--支付验单消息
function RechargeManager:AppleCheckPayment(context)
   
    if(self.mOrderID == 0) then return end
    if context and context.m_data then
        local productID=context.m_data[0]
        local appleOrderID=context.m_data[1]
        local appleReceiveData=context.m_data[2]
        local uTime = os.time()
        local szTemp = appleOrderID .. "|" .. uTime .. "|" .. "our-secret"
        local code = CommonUtil.GenMd5CheckCode(szTemp)

        local tb = {
            {"ios_order",appleOrderID},
            {"order_no",self.mOrderID },
            {"apple_receipt",appleReceiveData },
            {"proid",productID },
            {"itime",uTime },
            {"code",code },
        }
        local webUrl= ConfigInfoMgr.WEB_SERVICE_URL.."validate_ios_pay"
        print("AppleCheckPayment URL " ,webUrl)

        UIManager:GetInstance():ShowNetWorkMessage("","",5);

        local sucFunc = function(www)
            if(www ~= nil) then
                UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
                local webText = www.text
                -- print("web return text ",webText)

                local datas=Json.decode(webText)

                if datas then
                    if datas.retcode==0 and datas.retmsg=="succeed" then
                        print("苹果支付验单成功")

                        --请求刷新用户金币信息
                        PlayerInfoController:GetInstance():RequestGetUserMoney()

                        UIManager:GetInstance():ShowNoteMessage("支付成功")
                    else
                        print(" msg-------------------------> ",datas.retmsg)
                        UIManager:GetInstance():ShowNoteMessage(datas.retmsg)
                    end
                end
            end
        end

        local failFunc = function()
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

            UIManager:GetInstance():ShowNoteMessage("校验凭证失败")
        end

        WebDataManager:BeginLuaReqWebURLForm(webUrl,tb,sucFunc,failFunc)
    end
end

function RechargeManager:OpenH5Pay(payWayType,money,mid,m_phone,m_email,m_account)
    local tempTime = os.time()
    local differenceTime = tempTime - self.LastPayTime
    if self.mLastMid == mid and differenceTime < 15 and CheckServiceJsonDataIsNullOrEmpty(self.mLastPayLink) ~= nil then
        Application.OpenURL(self.mLastPayLink)
    else
        self.mLastMid = mid
        self.LastPayTime = tempTime
        self:OpenPayTips()
        local uAgencyID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
        local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
        local uTime = os.time()
        local param = Parameter.New()
        param:Add("agentid",uAgencyID) --代理ID
        param:Add("uid",uiUserID)  --用户ID
        param:Add("username","test") --用户名
        param:Add("money",tostring(money)) --面额
        param:Add("pay_way",payWayType)  --支付方式
        param:Add("itime",uTime)
        param:Add("mid",tostring(mid)) --面额
        local szTemp = StringFormat("{0}1{1}1{2}1{3}",ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime,ConfigModuleModel.GetInstance().ClientKey)
        param:Add("code", CommonUtil.GenMd5CheckCode(szTemp))
        param:Add("isnew","1015")
        param:Add("phone",m_phone)
        param:Add("email",m_email)
        param:Add("account",m_account)

        local web = string.gsub(ConfigInfoMgr.WEB_SERVICE_URL,"Pay/","")
        local webUrl=StringFormat("{0}{1}/{2}",web,"Pay/h5pay",param:ToStringUrl())
        print("支付地址：",webUrl)
        self.mLastPayLink = webUrl
        Application.OpenURL(webUrl)
    end 
end

function RechargeManager:OpenPayTips()
    local showBoxData ={}
    showBoxData.title = "提示"
    showBoxData.context ="Recharge_tips4"
    showBoxData.enterCB = function() 
        PlayerInfoController:GetInstance():RequestGetUserMoney()
    end--：点击确定返回；
    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮; 
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
    UIManager:GetInstance():ShowMessageBox(showBoxData)
end

--支持充值任意金额的充值入口
function RechargeManager:H5Pay3(payWayType,money,mid,IsSdkPay,phone,email,account)
    UIManager.GetInstance():ShowNetWorkMessage("正在组装支付数据，请稍候...","加载超时。。",15)
    local uAgencyID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    local uTime = os.time()
    local param = Parameter.New()
    param:Add("agentid",uAgencyID) --代理ID
    param:Add("uid",uiUserID)  --用户ID
    param:Add("username","test") --用户名
    param:Add("money",tostring(money)) --面额
    param:Add("pay_way",payWayType)  --支付方式
    param:Add("itime",uTime)
    param:Add("mid",tostring(mid)) --面额
    local szTemp = StringFormat("{0}1{1}1{2}1{3}",ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime,ConfigModuleModel.GetInstance().ClientKey)
    param:Add("code", CommonUtil.GenMd5CheckCode(szTemp))
    param:Add("isnew","0")
    param:Add("phone",phone)
    param:Add("email",email)
    param:Add("account",account)

    local webUrl=StringFormat("{0}Pay/h5pay/{1}",ConfigInfoMgr.WEB_SERVICE_URL,param:ToStringUrl())
    local sucFunc = function(www)
        if(www ~= nil) then
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
            local webText = www.text
            print("web return text ",webText)

            if CheckServiceJsonDataIsNullOrEmpty(webText ) == nil then
                -- UIManager:GetInstance():ShowNoteMessage("获取支付信息异常，请重试。。")
                UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("TiXianTip_Ing"))
                return
            end

            local datas=Json.decode(webText)
          
            if datas then
                local orderNo = datas.order_no
               
                if datas.retcode==0  then
                    self.mMianENum = money
                    self.mOrderID = tonumber(orderNo)
                    self.mIsNeedCheckPayment = true
                    if CheckServiceJsonDataIsNullOrEmpty(datas.Issdk) == nil then
                        datas.Issdk = 0
                    end
                    if (tonumber(datas.Issdk) == 2) then
                        if CheckServiceJsonDataIsNullOrEmpty(datas.data) ~= nil then
                            PhoneManager:MyThirdPay("2",webText)
                        else
                            UIManager.GetInstance():ShowNoteMessage("通道维护中，请稍后再试")
                        end
                    elseif (tonumber(datas.Issdk) == 1) then
                        if CheckServiceJsonDataIsNullOrEmpty(datas.data) ~= nil then
                            PhoneManager:MyThirdPay("1",webText)
                        else
                            UIManager.GetInstance():ShowNoteMessage("通道维护中，请稍后再试")
                        end
                        
                    else
                        Application.OpenURL(datas.pay_link)
                    end
                    local showBoxData ={}
                    showBoxData.title = "提示"
                    showBoxData.context ="Recharge_tips4"
                    showBoxData.enterCB = function() 
                        PlayerInfoController:GetInstance():RequestGetUserMoney()
                    end--：点击确定返回；
                    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
                    showBoxData.isHideAll = false--:隐藏所有按钮; 
                    showBoxData.isShowBtnClose = false--:界面的关闭按钮
                    UIManager:GetInstance():ShowMessageBox(showBoxData)
               
                else
                    self.mIsNeedCheckPayment = false
                    UIManager:GetInstance():ShowNoteMessage(datas.retmsg)
                end
            end
        end
    end

    local failFunc = function()
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        self.mIsNeedCheckPayment = false
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Order_Failure"))
    end

    WebDataManager:BeginLuaReqWebURL(webUrl,sucFunc,failFunc)
end



function RechargeManager:AppPay(payType,payWay,mid)
    local tempPayType = payType

    if(tempPayType == 0 and payWay == 1) then
        tempPayType = 1 --官方微信支付
    end

    print("App支付 支付类型 ： ",tempPayType," 支付方式 ",payWay)

    local uAreaID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAreaID)
    local uAgencyID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    local uTime = os.time()

    local param = Parameter.New()
    param:Add("areaid",uAreaID)
    param:Add("agentid",uAgencyID)
    param:Add("uid",uiUserID)
    param:Add("mid",tostring(mid))
    param:Add("username","test")
    param:Add("itime",uTime)
    param:Add("paytype",tostring(tempPayType))

    local szTemp = uiUserID .. "|" .. uTime .. "|" .. "our-secret"
    param:Add("code", CommonUtil.GenMd5CheckCode(szTemp))

    UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Request_Order"),"",2)

    local webUrl= ConfigInfoMgr.WEB_SERVICE_URL.."create_pay_order/"..param:ToStringUrl()

    print("AppPay URL " ,webUrl)

    local sucFunc = function(www)
        if(www ~= nil) then
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
            local webText = www.text

            -- print("web return text ",webText)

            local datas=Json.decode(webText)

            if datas then
                if datas.retcode==0 and datas.retmsg=="succeed" then
                    local orderNo = datas.order_no
                    print("order_no  " , orderNo)

                    self.mID = mid
                    self.mOrderID = tonumber(orderNo)
                    self.mIsNeedCheckPayment = true

                    if(payType == 0) then -- 官方支付
                        PhoneManager:MyOfficialPay(tostring(payWay),datas)
                    else
                        PhoneManager:MyThirdPay(tostring(payType),tostring(payWay),datas)
                    end
                else
                    UIManager:GetInstance():ShowNoteMessage(datas.retmsg)
                end
            end
        end
    end

    local failFunc = function()
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Order_Failure"))
    end

    WebDataManager:BeginLuaReqWebURL(webUrl,sucFunc,failFunc)
end

function RechargeManager:ApplePay(mid)
    local uAreaID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAreaID)
    local uAgencyID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    local uTime = os.time()

    local param = Parameter.New()
    param:Add("areaid",uAreaID)
    param:Add("agentid",uAgencyID)
    param:Add("uid",uiUserID)
    param:Add("mid",tostring(mid))
    param:Add("username","test")
    param:Add("itime",uTime)
    param:Add("paytype","8")

    local szTemp = uiUserID .. "|" .. uTime .. "|" .. "our-secret"
    param:Add("code", CommonUtil.GenMd5CheckCode(szTemp))

    UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Request_Order"),"",2)

    local webUrl= ConfigInfoMgr.WEB_SERVICE_URL.."create_pay_order/"..param:ToStringUrl()

    print("AppPay URL " ,webUrl)

    local sucFunc = function(www)
        if(www ~= nil) then
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
            local webText = www.text

            -- print("web return text ",webText)

            local datas=Json.decode(webText)

            if datas then
                if datas.retcode==0 and datas.retmsg=="succeed" then
                    local orderNo = datas.order_no
                    local proid = datas.proid
                    print("order_no  " , orderNo," proid ",proid)

                    self.mID = mid
                    self.mOrderID = tonumber(orderNo)
                    self.mIsNeedCheckPayment = false

                    PhoneManager:ApplePay(proid)
                else
                    UIManager:GetInstance():ShowNoteMessage(datas.retmsg)
                end
            end
        end
    end

    local failFunc = function()
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Order_Failure"))
    end

    WebDataManager:BeginLuaReqWebURL(webUrl,sucFunc,failFunc)
end

-- 点卡支付--------------------------------------------------------------------------------------------------------
function RechargeManager:DianKaReCharge(CarNum, password,verify_code)
    local mainPlayer=PlayerInfoController.GetInstance().model.mainPlayer
    local t={}
    if mainPlayer then
        t.cardno=CarNum
        t.cardpwd=password
        t.agentid=mainPlayer.uAgencyID
        t.uid=mainPlayer.uiUserID
        t.verify_code = verify_code
        t.itime=os.time()
        t.code=CommonUtil.GenMd5CheckCode(mainPlayer.uiUserID,os.time())
    end

    local strAppend=""
    if t then
        for k,v in pairs(t) do
            local strTmp = tostring(k).."/"..tostring(v).."/"
            strAppend = strAppend..strTmp
        end

        UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Request_Order"),"",2)

        local strWebUrl = string.gsub(ConfigInfoMgr.WEB_SERVICE_URL, "Pay/", "").."Pay/cardpay/"..strAppend
        print("strWebUrl  == ",strWebUrl)
        local sucFunc = function(www)
            if(www ~= nil) then
                UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
                local webText = www.text
                local datas = Json.decode(webText)
                if datas then
                    if datas.retcode == 0 and datas.retmsg == "succeed" then
                        self.mOrderID = datas.order_no --订单号
                        self.mMianENum = datas.money -- 面额
                        self:ReqCheckPayment()
                    else
                        print(" msg-------------------------> ",datas.retmsg)
                        UIManager:GetInstance():ShowNoteMessage(datas.retmsg)
                    end
                end
            end
        end

        local failFunc = function()
            UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
            UIManager:GetInstance():ShowNoteMessage("校验凭证失败")
        end
        WebDataManager:BeginLuaReqWebURL(strWebUrl,sucFunc,failFunc)
    end
end

