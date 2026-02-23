StoreModuleModel = StoreModuleModel or BaseClass(LuaModel)

function StoreModuleModel:__init( ... )
	self.listPayItemVo={}
	self.DailiData = {}
	self.isGetData=false
	self.QuickDatalist = nil
	self.SortList = {}
end

-- 清除缓存数据
function StoreModuleModel:ClearData()
	self.listPayItemVo={}
	self.isGetData=false
end

function StoreModuleModel:AddSortList(sort)
	self.SortList = {}
	self.SortList[tonumber(sort.guanfang)] = HallDefine.StoreType.DaiLi
	self.SortList[tonumber(sort.kuaijie)] = HallDefine.StoreType.QuickPayment
	self.SortList[tonumber(sort.zfb)] = HallDefine.StoreType.AliPay
	self.SortList[tonumber(sort.weixin)] = HallDefine.StoreType.WeChatPay
	self.SortList[tonumber(sort.sm)] = HallDefine.StoreType.AlipayQR
	self.SortList[tonumber(sort.jd)] = HallDefine.StoreType.JingDong
	self.SortList[tonumber(sort.ysf)] = HallDefine.StoreType.YunShanFu
	if sort.bankquick ~= nil then
		self.SortList[tonumber(sort.bankquick)] = HallDefine.StoreType.BankQuickPay
	end
end

function StoreModuleModel:GetPayItemListByType(iType)
	return self.listPayItemVo[iType]
end

function StoreModuleModel:GetInstance( ... )
	if StoreModuleModel.instance == nil then
		StoreModuleModel.instance = StoreModuleModel.New()
	end
	return StoreModuleModel.instance
end

function StoreModuleModel:__delete( ... )
	self.listPayItemVo=nil
	self.isGetData=nil
end