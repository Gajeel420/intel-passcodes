RechargeRecordModel = BaseClass(LuaModel)

function RechargeRecordModel:__init()
    
end

RechargeRecordModel.StateName = {
    [1]="[1CF004FF]充值[-]",
	[2]="[FFDE00FF]体现[-]",
	[3]="[1CF004FF]官方充值[-]",
	[4]="[1CF004FF]充值[-]",
}

function RechargeRecordModel:GetSlidMoney(callBack)
    local param = Parameter.New()
     local itime = os.time()
     local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
 	local str = ConfigInfoMgr.WEB_SERVICE_URL 
    param:Add("itime",itime)
    param:Add("uid",uiUserID)
 	param:Add("code",GetRequestCode({uiUserID,itime},"|"))
 	local web = string.gsub(str,"Pay/","")
 	local sucFunc = function(datas)
		if(datas.retcode==0) then
			if CheckServiceJsonDataIsNullOrEmpty(datas.data) ~= nil then
				if callBack then
					callBack(datas.data)
				end
			end
		else
			UIManager:GetInstance():ShowNoteMessage(datas.msg)
		end
 	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetSlidMoneyLiset,param,sucFunc,nil)
end


function RechargeRecordModel.GetInstance()
    if RechargeRecordModel.instance == nil then
        RechargeRecordModel.instance = RechargeRecordModel.New()
    end
    return RechargeRecordModel.instance
end

function RechargeRecordModel:__delete()

end