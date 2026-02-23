StoreModuleController = StoreModuleController or BaseClass(LuaController)

require"H/BaseModules/StoreModule/StoreModuleConst"
require"H/BaseModules/StoreModule/Vo/PayItemVo"
require"H/BaseModules/StoreModule/StoreModuleModel"

function StoreModuleController:__init( ... )
	self.model = StoreModuleModel:GetInstance()
	self:AddEvent()
end

--监听事件
function StoreModuleController:AddEvent()
	--LuaEvent:AddEventListener(EventName.OPEN_RECHARGEPANEL,self.OpenStore,self) --lua打开商店
	LuaEvent:AddEventListener(EventName.CSTOLUA_OPEN_RECHARGEPANEL,self.CSOpenStore,self) --C#打开商店
	self.model:AddEventListener(StoreModuleConst.EventName_ClearWebInfoCallBack,self.ClearWebInfo,self) --清除web端请求回来的商品列表数据
	-- LuaEvent:AddEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

--
function StoreModuleController:RemoveEvent()
	--LuaEvent:RemoveEventListener(EventName.OPEN_RECHARGEPANEL,self.OpenStore,self)
	LuaEvent:RemoveEventListener(EventName.CSTOLUA_OPEN_RECHARGEPANEL,self.CSOpenStore,self)
	self.model:RemoveEventListener(StoreModuleConst.EventName_ClearWebInfoCallBack,self.ClearWebInfo,self)
	-- LuaEvent:RemoveEventListener(EventName.INITMAINPLAYERCOMPELED,self.InitPlayerCompeleted,self)
end

function StoreModuleController:InitPlayerCompeleted( ... )
	-- body
	--self:RequiredPayMoneyList()
end

--请求商品列表
function StoreModuleController:RequiredPayMoneyList(backFunc,needNetworkMessage)
	local uAreaID = (PlayerInfoController:GetInstance().model.mainPlayer.uAreaID)
    local uAgencyID = (PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local uTime = os.time()
    local md5code = CommonUtil.GenMd5CheckCode(uiUserID,uTime)

	local param = Parameter.New()

	param:Add("areaid",uAreaID)
    param:Add("agentid",uAgencyID)
    param:Add("uid",uiUserID)
	param:Add("itime",uTime)
	param:Add("isappstore",GetRequestCode({uiUserID,uTime},"|"))
	param:Add("code",md5code)
	
	
	local sucFunc=function(jd)
    	local code = jd.retcode
		local msg = jd.msg
		if (tonumber(code)==0 ) then
			self.model.listPayItemVo = nil
			self.model.listPayItemVo = {}
        	
	
            if (jd.ios~=nil) then
                self:ParseJsonH5Pay(jd.ios, HallDefine.StoreType.ApplePay)
            end
			
          
            if (jd.wy~=nil) then
                self:ParseJsonH5Pay(jd.wy, HallDefine.StoreType.YunShanFu)
			end

			self.model.isGetData=true
			self.model.DailiData = jd.agent
			self.model.QuickDatalist = jd.kuaijie_data
			self.model.alipay = jd.zhifuban_data
			self.model.weixin = jd.weixin_data
			self.model.apktype_data = jd.apktype_data
			self.model.Payprompt = jd.Payprompt
			self.model.Corner = jd.Corner
			self.model.AlipayQR = jd.zfbsm_data
			self.model.JingDong = jd.jd_data
			self.model:AddSortList(jd.sort)
			self.model.BankQuickData = jd.bankquick_data
			if backFunc ~= nil then
				backFunc()
			end
		else
			--HallRechargeController.GetInstance().view.panel:SetObjTryAgainDisplay(true)
			UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("GetPayInfoFailed"))
        end
        
	end
	local failFunc=function()
		--HallRechargeController.GetInstance().view.panel:SetObjTryAgainDisplay(true)
		UIManager.GetInstance():ShowNoteMessage(StringFormatByLanguage("GetPayInfoFailed"))
	end
	WebRequestByGet(WebDataRequestManager.RequestInterface.RequestDonomination,param,sucFunc,failFunc,nil,needNetworkMessage)
end

function StoreModuleController:ParseJsonH5Pay( jdList, mytype )
	
	if jdList =="1" then 
		return 
	end
	local payItemList={}
	for i=1,#jdList do
		local item=PayItemVo.New()
		if jdList[i].mid~=nil then
			item.iID=tonumber(jdList[i].mid)
		end

		if jdList[i].PayType~=nil then
			item.iType=tonumber(jdList[i].PayType)
		end

		if jdList[i].number~=nil then
			item.iGoodNum=tonumber(jdList[i].number)
		end

		if jdList[i].getnum~=nil then
			item.iGiveGold=tonumber(jdList[i].getnum)
		end

		if jdList[i].money~=nil then
			item.iRmbNum=tonumber(jdList[i].money)
		end
		item.iIndex=i
		table.insert(payItemList,item)
	end

	if self.model.listPayItemVo[mytype]==nil then
		self.model.listPayItemVo[mytype]=payItemList
	end
	-- body
end
--lua游戏打开大厅商城
function StoreModuleController:OpenStore()
	
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end

--C#游戏打开大厅商城
function StoreModuleController:CSOpenStore()
	-- UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallStore)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
end

function StoreModuleController:ClearData()
	self.model:ClearData()
end
--实现事件的接口-----------------------------------------------------------------

function StoreModuleController:GetInstance()
	if StoreModuleController.instance == nil then
		StoreModuleController.instance = StoreModuleController.New()
	end
	return StoreModuleController.instance
end


function StoreModuleController:__delete( ... )
	self:RemoveEvent()
end