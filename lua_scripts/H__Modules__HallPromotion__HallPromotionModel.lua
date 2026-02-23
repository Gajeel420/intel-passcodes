HallPromotionModel=HallPromotionModel or BaseClass(LuaModel)

function HallPromotionModel:__init()
	
end


function HallPromotionModel:GetInstance()
	if HallPromotionModel.instance == nil then
		HallPromotionModel.instance = HallPromotionModel.New()
	end
	return HallPromotionModel.instance
end


---查询业绩
---callBack 回调方法
function HallPromotionModel:ReqEnquiryData(callBack)
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
	
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			local data={
				
				data= CheckServiceJsonDataIsNullOrEmpty(jsonData.data), --子项数据列表 {agent_water,create_date,id,self_water,team_water}
				team_week_water= CheckServiceJsonDataIsNullOrEmpty(jsonData.team_week_water),--团队业绩
				self_week_water= CheckServiceJsonDataIsNullOrEmpty(jsonData.self_week_water),--直营业绩
				agent_week_water= CheckServiceJsonDataIsNullOrEmpty(jsonData.agent_week_water),--下属业绩
				money= CheckServiceJsonDataIsNullOrEmpty(jsonData.money),--预计收益
				allow_money= CheckServiceJsonDataIsNullOrEmpty(jsonData.allow_money),--可预支额度
			}
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end

	WebRequestByGet(WebDataRequestManager.RequestInterface.GetDayachievement,param,sucFunc,nil)
end


----查询指定日期业绩
---date日期
---callBack 回调
function HallPromotionModel:ReqEnquiryDataByDate(date,callBack)
	-- body
	if date==nil then
		print("获取指定日期推广业绩信息返回:日期为nil！")
		return
	end 
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
	param:Add("date",date)
	
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			local data={
				data= CheckServiceJsonDataIsNullOrEmpty(jsonData.data), --子项数据列表 {id,self_water,agent_water}
			}
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTeamdayAchievement,param,sucFunc,nil,"查询中，请稍候...")
end


---查询团队管理
---callBack 回调方法
function HallPromotionModel:ReqTeamData(callBack)
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
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			local data={
				data= CheckServiceJsonDataIsNullOrEmpty(jsonData.data), --子项数据列表 {uid,self_water,agent_water,teamnum}
				teamnum= jsonData.teamnum,
				selfnum=jsonData.selfnum,
				teamwater= jsonData.teamwater,
			}
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTeamAchievement,param,sucFunc,nil)
end


---请求分享链接，二维码
---callBack 回调方法
function HallPromotionModel:ReqShareLinks(callBack,needNetworkMessage)
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

	local _,_,urlPrefix=string.find(ConfigInfoMgr.WEB_SERVICE_URL,"(http://%w[.%w]*:?%d*/)")
	if urlPrefix == nil then
		_,_,urlPrefix=string.find(ConfigInfoMgr.WEB_SERVICE_URL,"(https://%w[.%w]*:?%d*/)")
	end

	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0  or jsonData.retcode == -9 then
			local data={
				retcode = jsonData.retcode,
				weblink=  CheckServiceJsonDataIsNullOrEmpty(jsonData.weblink), --推广链接
				imglink=urlPrefix.. CheckServiceJsonDataIsNullOrEmpty(jsonData.imglink),   --推广二维码下载链接
				data = jsonData.data,
				type = jsonData.type
			}
			if callBack then
				callBack(data)
			end	
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetSpredLink,param,sucFunc,nil,nil,needNetworkMessage)
end




---查询提现记录
---callBack
function HallPromotionModel:ReqCashWithdrawalData(callBack)
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
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			local data={
				data= CheckServiceJsonDataIsNullOrEmpty(jsonData.data), --子项数据列表 {status_con,paymoney,day,time}
				all_shouyi= CheckServiceJsonDataIsNullOrEmpty(jsonData.all_shouyi),
				old_shouyi= CheckServiceJsonDataIsNullOrEmpty(jsonData.old_shouyi),
				wei_shouyi= CheckServiceJsonDataIsNullOrEmpty(jsonData.wei_shouyi),
			}
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.PromotionGetMoneyBill,param,sucFunc,nil,"查询中，请稍后...")
end


---请求提现
---money 
---zhiFuBaoAccount
---zhiFuBaoRelName
---bankAccount
---bankRelName
---callBack
function HallPromotionModel:ReqCashWithdrawal(money,zhiFuBaoAccount,zhiFuBaoRelName,bankAccount,bankRelName,callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
    local code = GetRequestCode({uiUserID,uTime},"|")
	local moneyString=tostring(money)
	local Aliname = zhiFuBaoRelName
	if Aliname==nil or Aliname == "" then
		Aliname = "-"
	end
	local Alinum = zhiFuBaoAccount
	if Alinum == nil or Alinum == "" then
		Alinum = "-"
	end
	local Bankname = bankRelName 
	if Bankname == nil or Bankname == "" then
		Bankname = "-"
	end
	local Banknum = bankAccount
	if Banknum == nil or Banknum == "" then
		Banknum = "-"
	end
	if type(loginType)=="function" then
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:1111111111")
	elseif type(Aliname)=="function" then 
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:2")
	elseif type(Alinum)=="function" then 
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:3")

	elseif type(Bankname)=="function" then 
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:4")

	elseif type(Banknum)=="function" then 
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:5")
	elseif type(moneyString)=="function" then 
		UDebug.Log("HallPromotionModel:ReqCashWithdrawal:666666666666")
	end
	-- local  param = 
	-- {
	-- 	{"agentid",uAgenID},
	-- 	{"uid",uiUserID},
	-- 	{"uid",uiUserID},
	-- 	{"time",uTime},
	-- 	{"logintype",loginType},
	-- 	{"code",code},
	-- 	{"money",moneyString},
	-- 	{"Aliname",Aliname},
	-- 	{"Alinum",Alinum},
	-- 	{"Bankname",Bankname},
	-- 	{"Banknum",Banknum},
	-- }

	local param = Parameter.New()
    param:Add("agentid",uAgenID)
	param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
    param:Add("code",code)
	param:Add("money",moneyString)
	param:Add("Aliname",Aliname)
	param:Add("Alinum",Alinum)
	param:Add("Bankname",Bankname)
	param:Add("Banknum",Banknum)
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			if callBack then
				callBack()
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.PromotionApplyMoney,param,sucFunc,nil,"正在提交请求，请稍后...")
end

---查询奖励说明
---callBack
function HallPromotionModel:ReqBonusNoteData(callBack)
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
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			local data={
				data= CheckServiceJsonDataIsNullOrEmpty(jsonData.data), --子项数据列表 {id:等级，title：名称，s_money：业绩范围-最小，e_money：业绩范围-最大（单位：万），commission：返佣（每一万返多少元）}
			}
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end 
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.PromotionGetBonusList,param,sucFunc,nil,"查询中，请稍后...")
end


---查询推荐码
---callBack
function HallPromotionModel:ReqRecommendData(callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local szTemp = StringFormat("{0}|{1}|{2}",uiUserID,uTime,ConfigModuleModel.GetInstance().ClientKey)
	
    local code = CommonUtil.GenMd5CheckCode(szTemp)
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
	param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
    param:Add("code",code)
	local webUrl =  StringFormat("{0}Spread/get_binding/{1}",ConfigInfoMgr.WEB_SERVICE_URL,param:ToStringUrl())
    UIManager:GetInstance():ShowNetWorkMessage("连接中","",2)
    local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end

	local sucFunc = function ( www )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		local webText = www.text
        print("请求查询推荐码返回",webText)
        --[
		local jsonData = Json.decode(webText)
        if jsonData  then
			if jsonData.retcode == 0 then
				local data={
                    --ruid=jsonData.ruid,
				}
				data.ruid= CheckServiceJsonDataIsNullOrEmpty(jsonData.ruid)
				if callBack then
					callBack(data)
				end
			else
				UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
            end
        end
        --]]
	end
	 WebDataManager:BeginLuaReqWebURL(webUrl,sucFunc,failFunc)
end


--绑定推荐码
function HallPromotionModel:ReqBindRecommend(recommend,callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	
    local code = GetRequestCodeOther({ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime,ConfigModuleModel.GetInstance().ClientKey},"1")
	local recommendString=tostring(recommend)
	
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
    param:Add("code",code)
    param:Add("ruid",recommendString)
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.retcode == 0 then
			if callBack then
				callBack()
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.PromotionSetBinding,param,sucFunc,nil,"提交信息中,请稍候...")
end

---查询体现模式
---callBack
function HallPromotionModel:ReqSpreadModel(callBack)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local uTime = os.time()
    local code = GetRequestCode({uiUserID,uTime},"|")
	local param = Parameter.New()
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("code",code)
	local successFunc = function (jsonData)
		if jsonData.retcode == 0 then
			
			local mode=CheckServiceJsonDataIsNullOrEmpty(jsonData.model)
			local modeNum=tonumber(mode)
			if modeNum==nil then
				return
			end
			local data={
				Model=0
			}
			if modeNum==0 then
				data.Model=HallPromotionModel.SpreadType.Money
			elseif modeNum==1 then
				data.Model=HallPromotionModel.SpreadType.Gold
			end
			if callBack then
				callBack(data)
			end
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.PromotionGetModel,param,successFunc,nil,"查询中，请稍候...")
end


function HallPromotionModel:__delete()
	
end


HallPromotionModel.SpreadType={
	Gold=1,
	Money=2,
}


HallPromotionModel.EventType={
	BindRecommendSuccess="HallPromotionModel.EventType.BindRecommendSuccess",
}



