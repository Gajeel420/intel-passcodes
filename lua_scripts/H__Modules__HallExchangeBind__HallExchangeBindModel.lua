HallExchangeBindModel = HallExchangeBindModel or BaseClass(LuaModel)

function HallExchangeBindModel:__init( ... )
	
end


---获取绑定银行列表
function HallExchangeBindModel:GetOpenBankNameList(backFun,obj)
	
    local param = Parameter.New()
	local itime=os.time()
	local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    param:Add("uid",uiUserID)
	param:Add("itime",itime)
    param:Add("code", GetRequestCode({uiUserID,itime}))
    local successFunc = function(jd)  --请求数据成功
        local code = jd.retcode
        if (tonumber(code)==0 ) then
            if backFun ~=nil then
                backFun(obj,jd.data)
            end
        end
    end
    WebRequestByGet(WebDataRequestManager.RequestInterface.GetBankNameList,param,successFunc,nil,"Loading_tips")
end


function HallExchangeBindModel:GetInstance()
	if HallExchangeBindModel.instance == nil then
		HallExchangeBindModel.instance = HallExchangeBindModel.New()
	end
	return HallExchangeBindModel.instance
end

function HallExchangeBindModel:__delete( ... )
end
