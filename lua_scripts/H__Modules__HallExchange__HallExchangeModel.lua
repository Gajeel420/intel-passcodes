HallExchangeModel = HallExchangeModel or BaseClass(LuaModel)

function HallExchangeModel:__init( ... )
	self:InitData()
end


function HallExchangeModel:InitData( ... )
	-- body
	self.AliPayData = {}
	self.BankData = {}
end

function HallExchangeModel:GetInstance()
	if HallExchangeModel.instance == nil then
		HallExchangeModel.instance = HallExchangeModel.New()
	end
	return HallExchangeModel.instance
end

---获取请求提现状态
function HallExchangeModel:GetRecordState()
	local uTime = os.time()
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local postTable = {
		{"uid",uiUserID},
		{"itime",uTime},
		{"code",code},
	}
	local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end
	local sucFunc = function ( jsonData )
		if jsonData.retcode == 0 then
			local showBoxData ={}
			showBoxData.title = "温馨提示"
			showBoxData.context =  StringFormat("审核不通过:{0}",jsonData.msg)
			showBoxData.enterCB = function() 
				
			end--：点击确定返回；
			showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
			showBoxData.isHideAll = false--:隐藏所有按钮; 
			showBoxData.isShowBtnClose = false--:界面的关闭按钮
			UIManager:GetInstance():ShowMessageBox(showBoxData)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.GetTXAlertStatus,postTable,sucFunc,failFunc)

end


function HallExchangeModel:GetExchanageConfig()
	local uTime = os.time()
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local postTable = {
		{"agentid",uAgenID},
		{"uid",uiUserID},
		{"time",uTime},
		{"code",code},
	}
	local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end
	local sucFunc = function ( jsonData )
		if jsonData.code == 0 then
			HallExchangeBindModel.GetInstance().data = jsonData
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchange)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.GetExcConfig,postTable,sucFunc,failFunc)

end



---绑定账号
---  Account
---realName
---Bank_Bankname
---Bank_Bankbranch
---type
---callBack
function HallExchangeModel:BindingAccount(Account,realName,Bank_Bankname,Bank_Bankbranch,type,callBack )
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local szTemp = StringFormat("{0}1{1}1{2}1{3}",uiUserID,uiUserID,uTime,ConfigModuleModel:GetInstance().ClientKey)
	local code = GetRequestCode({uiUserID,uiUserID,uTime},"1")
	local code2 =  GetRequestCodeOther({ConfigModuleModel.GetInstance().mLoginState,uTime,ConfigModuleModel:GetInstance().ClientKey,uiUserID},"1")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"Type",type},
		{"time",uTime},
		{"logintype",loginType},
		{"Account",Account},
		{"Name",realName},
		{"Bank_Bankname",Bank_Bankname},
		{"Bank_Bankbranch",Bank_Bankbranch},
		{"code",code},
		{"code2",code2},
	}
	local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end

	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			if type==HallExchangeModel.BindType.Bank then
				self.BankData.Account = jsonData.data.Account
				self.BankData.relName = jsonData.data.Name
				self.BankData.Bank_Bankname = jsonData.data.Bank_Bankname
				self.BankData.Bank_Bankbranch = jsonData.data.Bank_Bankbranch
			else
				self.AliPayData.Account = jsonData.data.Account
				self.AliPayData.relName = jsonData.data.Name
			end

			local data = {}
			data.Account = jsonData.data.Account
			data.relName = jsonData.data.Name
			callBack(data)
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.PostTXBindingInfo,postTable,sucFunc,failFunc,"绑定中，请稍候...")
end

---兑换接口
---Account
---realName
---type
---amount
---callBack
function HallExchangeModel:Exchange( Account,realName,type,amount,callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local code = GetRequestCode({uiUserID,uiUserID,uTime},"1")
	local code2 =  GetRequestCodeOther({ConfigModuleModel.GetInstance().mLoginState,uTime,ConfigModuleModel:GetInstance().ClientKey,uiUserID},"1")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"Type",type},
		{"time",uTime},
		{"logintype",loginType},
		{"Account",Account},
		{"Name",realName},
		{"code",code},
		{"code2",code2},
		{"amount",amount},
	}
	local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			callBack()
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.PostTxCashWithdraw,postTable,sucFunc,failFunc,"请求中，请稍候...")
end

---获取绑定的信息
---callBack
function HallExchangeModel:GetBindingAccount( callBack )
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local loginType = tostring(CacheDataMgr.mLoginInfo.nLoginType)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local code2 = GetRequestCode({ConfigModuleModel.GetInstance().mLoginState,uiUserID,uTime},"1")
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("logintype",loginType)
	param:Add("code",code)
	param:Add("code2",code2)
    local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			self.AliPayData = {}
			self.AliPayData.Account=nil
			self.AliPayData.relName=nil
			self.BankData = {}
			self.BankData.Account=nil
			self.BankData.relName=nil
			if jsonData.data ~= nil then
				self.AliPayData.Account = jsonData.data.Ali.Account
				self.AliPayData.relName = jsonData.data.Ali.Name
				self.BankData.Account = jsonData.data.Bank.Account
				self.BankData.relName = jsonData.data.Bank.Name
				self.BankData.Bank_Bankname = jsonData.data.Bank.Bank_Bankname
				self.BankData.Bank_Bankbranch = jsonData.data.Bank.Bank_Bankbranch
			end
			local data={
				ZhiFuBaoAccount=self.AliPayData.Account,
				ZhiFuBaoRelName=self.AliPayData.relName,
				BankAccount=self.BankData.Account,
				BankRelName=self.BankData.relName,
				Bank_Bankname=self.BankData.Bank_Bankname,
				Bank_Bankbranch=self.BankData.Bank_Bankbranch,
			}
			
			callBack(data)
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTXBindingInfo,param,sucFunc,failFunc)
end

---获取记录列表
---page
---size
function HallExchangeModel:GetRecordList( page,size ,callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("code",code)
    param:Add("page",page)
    param:Add("size",size)
    local failFunc = function ( ... )
		-- body
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)

        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end
	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			local result = {}
			result.page = jsonData.page
			result.size = jsonData.size
			result.num = jsonData.size
			if jsonData.data ~= nil then
				local count = #jsonData.data
				result.list = {}
				for i=1,count do
					local item = jsonData.data[i]
					local resultItem = {}
					resultItem.Id = item.Id
					resultItem.orderId = item.orderId
					resultItem.tx_type = item.tx_type
					resultItem.amount = item.amount
					resultItem.time = item.time
					resultItem.tx_status = item.tx_status
					resultItem.beizhu = item.beizhu
					result.list[i] = resultItem
				end 
			end
			callBack(result)
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTXWithdrawList,param,sucFunc,failFunc)
end

--- 请求提现记录详情
--- orderID
--- callBack
function HallExchangeModel:GetRecordDetail( orderID, callBack)
	-- body
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uiUserID,uTime},"|")
	local param = Parameter.New()
    param:Add("agentid",uAgenID)
    param:Add("uid",uiUserID)
    param:Add("time",uTime)
    param:Add("code",code)
    param:Add("id",orderID)
    local failFunc = function ( ... )
		-- body
        UIManager:GetInstance():ShowNoteMessage("请求超时")
	end

	local sucFunc = function ( jsonData )
		-- body
		if jsonData.code == 0 then
			local result = {}
			result.account = jsonData.account
			result.name = jsonData.name
			result.status = jsonData.status
			result.time = jsonData.time
			result.tip = jsonData.tip
			result.money = jsonData.money
			result.notice = jsonData.notice
			result.title = jsonData.title
			callBack(result)
		else
			UIManager:GetInstance():ShowNoteMessage(jsonData.msg)
		end
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GetTXDetail,param,sucFunc,failFunc)
end


function HallExchangeModel:__delete( ... )
end



HallExchangeModel.BindType={
	ZhiFuBao="Ali",
	Bank="Bank",
}

