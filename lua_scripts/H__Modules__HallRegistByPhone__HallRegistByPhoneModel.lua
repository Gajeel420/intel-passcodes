HallRegistByPhoneModel = HallRegistByPhoneModel or BaseClass(LuaModel)

HallRegistByPhoneModel.EventName_RegisterAccountSuccess = "EventName_RegisterAccountSuccess"

function HallRegistByPhoneModel:__init( ... )
	self.szAccountName = nil
    self.szPassWord = nil
    self.nRecommendCode=PlayerPrefs.GetInt("Key_RecommendCode", 0)
end

function HallRegistByPhoneModel:SaveRecommendCode()--推荐码
	NetworkMgr.MyRecomendCode=self.nRecommendCode
	PlayerPrefs.SetInt("Key_RecommendCode", self.nRecommendCode or 0)
end

function HallRegistByPhoneModel:GetRecommendCode()
	return PlayerPrefs.GetInt("Key_RecommendCode", 0)
end

--- 注册帐号
---account          帐号
---staticPassword   密码
---nickName         昵称
function HallRegistByPhoneModel:ReqDataRequestRegister(account,staticPassword,nickName,emsCode)
    self.szAccountName=account or ""
    self.szPassWord =staticPassword or ""
	self.szNickName =nickName or ""
	local time = os.time()
    local code=GetRequestCode({time},"|")
    local agentid = 1
    if ConfigInfoMgr.agentid > 1 then
        agentid = ConfigInfoMgr.agentid
    else
        agentid = ConfigInfoMgr.WBFlag 
    end

    local AndroidIndependentCode = ConfigInfoMgr.AndroidIndependentCode == nil and "0" or ConfigInfoMgr.AndroidIndependentCode
    
    local tb = {
        {"loginname",account},
        {"nickname",nickName },
        {"password",staticPassword },
        {"agentid", agentid },
        {"recommenmend",self.nRecommendCode},
        {"code",code },
        {"time",time},
        {"ip",CommonUtil.GetUserIP or ""},
        {"mac",PhoneManager:GetDeviceUniqueIdentifier() or ""},
        {"ruid",ConfigInfoMgr.ruid},
        {"refererid",AndroidIndependentCode},
        {"channelno",ConfigInfoMgr.ChannelID},
        {"mobile",account},
        {"insert_code",emsCode},
    }

    local sucFunc=function(datas)
        if datas.retcode==0 then
            local context=StringFormatByLanguage("RegisterAccountSuccess")
            UIManager:GetInstance():ShowNoteMessage(context)
            self:DispatchEvent(HallRegistByPhoneModel.EventName_RegisterAccountSuccess,{self.szAccountName,self.szPassWord})
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
    end

    local failFunc=function()
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("RegisterAccountFailed"))  --Request_Share_Failure
    end
    WebRequestByPost(WebDataRequestManager.RequestInterface.AddUser,tb,sucFunc,failFunc,StringFormatByLanguage("ChangePassword_Processing"))
end

----获取短信验证码
---phoneNo  电话号码
---backFun  回调方法
---obj      上下文
function HallRegistByPhoneModel:GetEmsCode( phoneNo,backFun,obj )
    -- body
    self.backFun = backFun
    if obj ~= nil then
        self.Self = obj
    end
    local param = Parameter.New()
    local itime=os.time()
    param:Add("uid","2000000")
    param:Add("mobile",phoneNo)
    param:Add("itime",itime)

    local md5code= GetRequestCode({"2000000",itime})
    param:Add("code", md5code)
    print("++++++++++++++++++++++++++++++")
    local successFunc = function(jd)  --请求数据成功
        local code = jd.retcode
        local msg = jd.retmsg
        -- print("----------------------------------")
        -- pt(jd)
        if (tonumber(code)==0 ) then
            local mCode = jd.code
            if self.backFun ~=nil then
                self.backFun(mCode,self.Self)
            end
        end
    end
    WebRequestByGet(WebDataRequestManager.RequestInterface.GetSMSCode,param,successFunc,nil,"Get_verification_code")
end


---验证推荐码
---recommendCode    推荐吗
function HallRegistByPhoneModel:ReqTestRecommendCode(recommendCode,backFun)
    self.nRecommendCode=recommendCode or 0
    local time = os.time()
    local code=GetRequestCode({time})
    
    local tb = {
        {"recommenmend",self.model.nRecommendCode},
        {"code",code },
        {"time",time},
    }
    local sucFunc=function(datas)
        if datas.retcode==0 then
            UIManager:GetInstance():ShowNoteMessage("推荐码验证通过")
            self.model:SaveRecommendCode()
            if backFun ~= nil then
                backFun()
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
    end
    local failFunc=function()
        UIManager:GetInstance():ShowNoteMessage("验证推荐码失败")  
    end
    WebRequestByPost(WebDataRequestManager.RequestInterface.CheckRecommenmend,tb,sucFunc,failFunc,"验证推荐码中...")
end

function HallRegistByPhoneModel:GetInstance()
	if HallRegistByPhoneModel.instance == nil then
		HallRegistByPhoneModel.instance = HallRegistByPhoneModel.New()
	end
	return HallRegistByPhoneModel.instance
end

function HallRegistByPhoneModel:__delete( ... )
end
