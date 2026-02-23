HallRechargeController = HallRechargeController or BaseClass(LuaController)

require"H/Modules/HallRecharge/HallRechargeView"
require"H/Modules/HallRecharge/HallRechargeConst"
require"H/Modules/HallRecharge/HallRechargeModel"
require"H/Modules/HallRecharge/View/HallRechargePanel"
require"H/Modules/HallRecharge/View/GooglePayItem"
require"H/Modules/HallRecharge/View/UIDaili"
require"H/Modules/HallRecharge/View/UIDailiGrid"
require"H/Modules/HallRecharge/View/UIDianKa"
require"H/Modules/HallRecharge/View/UIStoreGrid"
require"H/Modules/HallRecharge/View/UIZhiFuBao"
require"H/Modules/HallRecharge/View/UIDaiLiDetailPanel"
require"H/Modules/HallRecharge/View/RechargeView"
require"H/Modules/HallRecharge/View/RechargeViewGrid"
require"H/Modules/HallRecharge/View/QuickPaymentView"
require"H/Modules/HallRecharge/View/QuickPaymentTitleItem"

function HallRechargeController:__init( ... )
	self.model=HallRechargeModel:GetInstance()
	self.IsNeedDianKaPassWord = false
	self.view = HallRechargeView.New()
end

function HallRechargeController:GetInstance()
	if HallRechargeController.instance == nil then
		HallRechargeController.instance = HallRechargeController.New()
	end
	return HallRechargeController.instance
end


function HallRechargeController:__delete( ... )
	self.view = nil
end

--请求商品列表
function HallRechargeController:SendGooglePay(backFunc)
    local uAgencyID = (PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local uTime = os.time()
    local md5code = CommonUtil.GenMd5CheckCode(uiUserID,uTime)

	local param = Parameter.New()

    param:Add("agentid",uAgencyID)
    param:Add("uid",uiUserID)
	param:Add("itime",uTime)
	param:Add("code",md5code)
	
	
	local sucFunc=function(jd)
		print("------------------------- HallRechargeController:SendGooglePay ")
		pt(jd)
    	local code = jd.retcode
		if (tonumber(code)==0 ) then
			self.model.googlePayList = jd.data.list
			if backFunc ~= nil then
				backFunc(jd.data)
			end
		else
			local msg = jd.msg
			UIManager.GetInstance():ShowNoteMessage(msg)
        end
        
	end
	local failFunc=function()
		-- UIManager.GetInstance():ShowNoteMessage("")
	end
	-- WebRequestByGet(WebDataRequestManager.RequestInterface.GooglePay,param,sucFunc,failFunc,nil,false)
end

--请求order
function HallRechargeController:SendGooglePayOrder(mid,backFunc)
    local uAgencyID = (PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local uTime = os.time()
    local md5code = CommonUtil.GenMd5CheckCode(uiUserID,uTime)

	local param = Parameter.New()

    param:Add("agentid",uAgencyID)
    param:Add("uid",uiUserID)
	param:Add("mid",tonumber(mid))
	param:Add("itime",uTime)
	param:Add("code",md5code)
	
	
	local sucFunc=function(jd)
		print("------------------------- HallRechargeController:SendGooglePayOrder ")
		pt(jd)
    	local code = jd.retcode
		if (tonumber(code)==0 ) then
			if backFunc ~= nil then
				backFunc(jd.data)
			end
		else
			local msg = jd.msg
			UIManager.GetInstance():ShowNoteMessage(msg)
        end
        
	end
	local failFunc=function()
		-- UIManager.GetInstance():ShowNoteMessage("")
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GooglePayOrder,param,sucFunc,failFunc,nil,false)
end

--请求支付完成加币
function HallRechargeController:SendGooglePayNotify(orderid,tOrderid,money,backFunc)
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local uTime = os.time()
	local str = orderid.."|"..uiUserID.."|"..uTime.."|"..tOrderid
    local md5code = CommonUtil.GenNewMd5CheckCode(str)

	local param = Parameter.New()

    param:Add("uid",uiUserID)
	param:Add("orderid",orderid)
	param:Add("torderid",tOrderid)
	param:Add("orderMoney",money)
	param:Add("itime",uTime)
	param:Add("code",md5code)
	
	
	local sucFunc=function(jd)
		print("------------------------- HallRechargeController:SendGooglePayNotify ")
		pt(jd)
    	local code = jd.retcode
		if (tonumber(code)==0 ) then
			if backFunc ~= nil then
				backFunc()
			end
		else
			local msg = jd.msg
			UIManager.GetInstance():ShowNoteMessage(msg)
        end
        
	end
	local failFunc=function()
		-- UIManager.GetInstance():ShowNoteMessage("")
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.GooglePayNotify,param,sucFunc,failFunc,nil,false)
end