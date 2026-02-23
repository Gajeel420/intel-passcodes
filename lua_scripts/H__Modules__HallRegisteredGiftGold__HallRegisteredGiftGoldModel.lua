HallRegisteredGiftGoldModel=HallRegisteredGiftGoldModel or BaseClass(LuaModel)

function HallRegisteredGiftGoldModel:__init()
	self.listData={}
end
function HallRegisteredGiftGoldModel:GetInstance()
	if HallRegisteredGiftGoldModel.instance == nil then
		HallRegisteredGiftGoldModel.instance = HallRegisteredGiftGoldModel.New()
	end
	return HallRegisteredGiftGoldModel.instance
end


---查询注册送金信息
---callBack 回调函数
function HallRegisteredGiftGoldModel:ReqRegisterData(callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local code = GetRequestCode({uiUserID,uTime},"|")
	
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
	param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
    param:Add("code",code)
	
    local failFunc = function ( ... )
		-- body
		if ConfigModuleModel.GetInstance().IsShowActiveCenter then
			HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
		else
			HallRedEnvelopesController:GetInstance().model.mCanRequest = true
			HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		end
	end

	local sucFunc = function ( jsonData )
		-- body	
		if jsonData.retcode == 0 then
			if CheckServiceJsonDataIsNullOrEmpty(jsonData.bindphonesendcoins) ~= nil then
				local data={
					bindphonesendcoins=jsonData.bindphonesendcoins, 
				}
				if callBack then
					callBack(data)
				end
			else
				
				if ConfigModuleModel.GetInstance().IsShowActiveCenter then
					HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
				else
					HallRedEnvelopesController:GetInstance().model.mCanRequest = true
					HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
				end
			end
		else
			
			if ConfigModuleModel.GetInstance().IsShowActiveCenter then
				HallActiveCentreController.GetInstance():ShowActiveCenterPanel(false)
			else
				HallRedEnvelopesController:GetInstance().model.mCanRequest = true
				HallRedEnvelopesController:GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
			end
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
        
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.RegisterSendGlod,param,sucFunc,failFunc,nil,false)
end




function HallRegisteredGiftGoldModel:__delete()
	
end