HallChanagePasswordModel = HallChanagePasswordModel or BaseClass(LuaModel)

function HallChanagePasswordModel:__init( ... )
	
end

---修改用户密码
---PhoneNo      --帐号
---password     --密码
---backFun      --成功回调
---obj          --上下文
function HallChanagePasswordModel:FindPassword( PhoneNo,password ,emsCode,backFun,obj)
    -- body
    local itime=os.time()
    local md5code= GetRequestCode({PhoneNo,itime},"|")
    
	local tb = {
        {"loginname",PhoneNo},
        {"loginpwd",password },
		{"time",itime },
        {"code",md5code},
        {"mobile",PhoneNo},
        {"insert_code",emsCode},
	}
    local successFunc = function ( jd )
		-- body
        local code = jd.retcode
        local msg = jd.msg
        if jd.retcode == 0 then
            if backFun ~= nil then
                backFun(obj) 
             end
        end
        UIManager:GetInstance():ShowNoteMessage(msg) 
    end
    WebRequestByPost(WebDataRequestManager.RequestInterface.ModifyUserPassWord,tb,successFunc,nil,StringFormatByLanguage("ChangePassword_Processing"))
end

function HallChanagePasswordModel:GetInstance()
	if HallChanagePasswordModel.instance == nil then
		HallChanagePasswordModel.instance = HallChanagePasswordModel.New()
	end
	return HallChanagePasswordModel.instance
end

function HallChanagePasswordModel:__delete( ... )
end
