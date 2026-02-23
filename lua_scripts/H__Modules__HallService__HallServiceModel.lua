HallServiceModel=HallServiceModel or BaseClass(LuaModel)

function HallServiceModel:__init()
	self.data = nil
end
function HallServiceModel:GetInstance()
	if HallServiceModel.instance == nil then
		HallServiceModel.instance = HallServiceModel.New()
	end
	return HallServiceModel.instance
end

--获取客服信息
function HallServiceModel:ReqServiceData(callBack)
	local param = Parameter.New()
	
 	local itime = os.time()
 	local str = ConfigInfoMgr.WEB_SERVICE_URL 
 	param:Add("itime",itime)
 	param:Add("code",GetRequestCode({itime},"|"))
 	
	local sucFunc = function(datas)
		if datas.retcode==0 then
			local data={
				QQ=CheckServiceJsonDataIsNullOrEmpty(datas.qq),
				WeiXin=CheckServiceJsonDataIsNullOrEmpty(datas.weixin),
				Web=CheckServiceJsonDataIsNullOrEmpty(datas.website),
			}
			if data.Web ~= nil then
				data.Web = GetServiceUrl(data.Web)
			end
			self.data = data
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(datas.msg)
		end
 	end
 	local failFunc = function()
    	UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Service_Amount_Failure"))
	end
	
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetCustomerConfig,param,sucFunc,failFunc,"Get_customer_service")
end




function HallServiceModel:__delete()
	
end