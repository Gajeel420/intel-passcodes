HallRestBankPasswordModel = HallRestBankPasswordModel or BaseClass(LuaModel)

function HallRestBankPasswordModel:__init( ... )
	
end

function HallRestBankPasswordModel:GetInstance()
	if HallRestBankPasswordModel.instance == nil then
		HallRestBankPasswordModel.instance = HallRestBankPasswordModel.New()
	end
	return HallRestBankPasswordModel.instance
end





function HallRestBankPasswordModel:RestBankPassword( PhoneNo,password ,callBack)

    local param = Parameter.New()
    local itime=os.time()
    print("password:",password)
    param:Add("loginname",PhoneNo)
    param:Add("bankpwd",password)
    param:Add("time",itime)
    param:Add("code", GetRequestCode({PhoneNo,itime},"|"))
    local successFunc = function ( jd )
        -- body
        local code = jd.retcode
        local msg = jd.msg
        if tonumber(code) == 0 then
            if callBack then
                callBack()
            end
        else
            UIManager:GetInstance():ShowNoteMessage(msg) 
        end
    end
    WebRequestByGet(WebDataRequestManager.RequestInterface.ChangeUserBankPassword,param,successFunc,nil,StringFormatByLanguage("ChangePassword_Processing"))
end

function HallRestBankPasswordModel:__delete( ... )
end
