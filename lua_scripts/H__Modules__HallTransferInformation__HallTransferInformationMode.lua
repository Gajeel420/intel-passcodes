HallTransferInformationMode = BaseClass(LuaModel)

function HallTransferInformationMode:__init()

end

function HallTransferInformationMode:GetBankInfo(paytype,callBack)
    local uTime = os.time()
    local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local szTemp = StringFormat("{0}|{1}|{2}",uAgenID,uTime,ConfigModuleController.GetInstance().model.ClientKey)
    local code = CommonUtil.GenMd5CheckCode(szTemp)
    local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("time",uTime)
    param:Add("paytype",paytype)
    param:Add("code",code)
    print("type：",paytype)
    local webUrl =  StringFormat("{0}API/get_Bank_info/{1}",ConfigInfoMgr.WEB_SERVICE_URL,param:ToStringUrl())
    
    local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

        UIManager:GetInstance():ShowNoteMessage("请求超时")
    end
    
    local sucFunc = function ( www )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        local webText = www.text
        local jsonData = Json.decode(webText)
        if jsonData then
            if jsonData.retcode == 0 then
                if callBack then
                    callBack(jsonData.data)
                    self.data = jsonData.data
                end
            else
                UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
            end
        end
    end
    UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","",5)
    WebDataManager:BeginLuaReqWebURL(webUrl,sucFunc,failFunc)
end


function HallTransferInformationMode:RespRechargeInfo(data,paytype,callBack)
    local uTime = os.time()
    local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    local uiUserName = PlayerInfoController:GetInstance().model.mainPlayer.szNickName
    local szTemp = StringFormat("{0}1{1}1{2}1{3}",ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime,ConfigModuleController.GetInstance().model.ClientKey)
    local code = CommonUtil.GenMd5CheckCode(szTemp)
    local webUrl =  StringFormat("{0}Pay/bank_pay",ConfigInfoMgr.WEB_SERVICE_URL)
    local tb = {
        {"agentid",uAgenID},
        {"uid",uiUserID},
        {"username",uiUserName},
        {"kname",data.kname},
        {"bank_name",data.bank_name},
        {"bank_card",data.bank_card},
        {"time",uTime},
        {"code",code},
        {"input_time",data.input_time},
        {"cname",data.cname},
        {"mid",data.mid},
        {"paytype",paytype},
    }

    local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        UIManager:GetInstance():ShowNoteMessage("请求超时")
    end
    
    local sucFunc = function ( www )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
        local webText = www.text
    
        local jsonData = Json.decode(webText)
        if jsonData then
            if jsonData.retcode == 0 then
                UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
                if callBack then
                    callBack()
                end
            else
                UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
            end
        end
    end
    UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","",5)
    WebDataManager:BeginLuaReqWebURLForm(webUrl,tb,sucFunc,failFunc)
end


function HallTransferInformationMode:__delete()

end