HallAccountLoginController = HallAccountLoginController or BaseClass(LuaController)

require"H/Modules/HallAccountLogin/HallAccountLoginView"
require"H/Modules/HallAccountLogin/View/HallAccountLoginPanel"

function HallAccountLoginController:__init( ... )
	self.view = HallAccountLoginView.New()

end

function HallAccountLoginController:GetInstance()
	if HallAccountLoginController.instance == nil then
		HallAccountLoginController.instance = HallAccountLoginController.New()
	end
	return HallAccountLoginController.instance
end

function HallAccountLoginController:__delete( ... )
	self.view = nil
end

--sFunc 登录
--fFunc 打开提示
function HallAccountLoginController:SendCheckIP(sFunc,fFunc)
    local param = Parameter.New()
    local itime=os.time()
    local md5code= GetRequestCode({itime})
    param:Add("itime",itime)
    param:Add("code", md5code)
    local successFunc = function(jd)  --请求数据成功
		if jd then
			local code = jd.retcode
			local msg = jd.msg
			if code == 200 and msg == "success" then
				--是大陆IP 
				if fFunc then
					fFunc()
				end
			elseif code == 400 and msg == "error" then
				--不是大陆IP
				if sFunc then
					sFunc()
				end
			else
				UIManager:GetInstance():ShowNoteMessage(msg)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("System_Error"))
		end
    end

	local failedFunc = function()
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Unstable_Network_State"))
	end

    WebRequestByGet(WebDataRequestManager.RequestInterface.Check_IP,param,successFunc,failedFunc,nil,true)
end

--sFunc 登录
--fFunc 打开提示
function HallAccountLoginController:SendCheckIPAndAgentID(loginname,sFunc,fFunc)
	-- local param = Parameter.New()
    local itime=os.time()
	local md5code= GetRequestCode({ConfigModuleModel:GetInstance().mCheckAgentID,loginname,itime})
	-- param:Add("itime",itime)
    -- param:Add("code", md5code)
	-- param:Add("loginname", loginname)
	-- param:Add("agentid", ConfigModuleModel:GetInstance().mCheckAgentID)
	local tb = {
        {"itime",itime},
        {"loginname",loginname },
		{"agentid",ConfigModuleModel:GetInstance().mCheckAgentID },
        {"code",md5code},
	}
    local successFunc = function(jd)  --请求数据成功
		if jd then
			local code = jd.retcode
			local msg = jd.msg
			if code == 0 then 
				--重置服务器 配置信息
				-- ConfigModuleModel:GetInstance():ResetServerConfigInfo(jd.data)

				if sFunc then
					sFunc()
				end
			elseif code == 102 then
				--是大陆IP 走失败
				if fFunc then
					fFunc()
				end
			else
				UIManager:GetInstance():ShowNoteMessage(msg)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("System_Error"))
		end
    end

	local failedFunc = function()
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Unstable_Network_State"))
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.Check_IPAndAgentid,tb,successFunc,failedFunc,nil,true)
	-- WebRequestByGet(WebDataRequestManager.RequestInterface.Check_IPAndAgentid,param,successFunc,failedFunc,nil,true)
end

function HallAccountLoginController:Client_Popup_Notes(callfun)
	-- body
	local uTime = os.time()
	local code = GetRequestCode({uTime},"|")
	local postTable = {
		{"time",uTime},
		{"code",code},
	}

	local failFunc = function ( ... )
		-- body
       -- UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Request_Timed_Out"))
	   callfun()
	end

	local sucFunc = function ( datas )
		if datas ~= nil and datas.retcode==0  then
			local content = datas.data
			local showBoxData ={}
			showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
			showBoxData.context = content--内容；
			showBoxData.enterCB = function()

			end

			showBoxData.cancelCB = nil
			showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
			showBoxData.isHideAll = false--:隐藏所有按钮;
			showBoxData.isShowBtnClose = false--:界面的关闭按钮
			UIManager:GetInstance():ShowMessageBox(showBoxData)
		else
			callfun()
        end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.Client_Popup_Notes,postTable,sucFunc,failFunc,nil,false)
end
