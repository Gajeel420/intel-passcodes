HallRechargeModel = HallRechargeModel or BaseClass(LuaModel)

function HallRechargeModel:__init( ... )
	
end


function HallRechargeModel:CheckPayListNull(payList)
	local result = {}
	if CheckServiceJsonDataIsNullOrEmpty(payList) ~= nil and payList ~= "1" then
		local count = #payList
		for i = 1, count do
			if CheckServiceJsonDataIsNullOrEmpty(payList[i].denomination) ~= nil and payList[i].denomination ~= "1" then
			
				local type = payList[i].TypeID
				local apkType = StoreModuleModel:GetInstance().apktype_data[type]
				if apkType == nil then
					table.insert(result, payList[i])
				elseif tonumber(apkType) == 0 then 
					table.insert(result, payList[i])
				elseif tonumber(apkType) == 1 and AppConst.PlatformPath()=="Android5.0" then  
					table.insert(result, payList[i])
				elseif tonumber(apkType) == 2 and AppConst.PlatformPath()=="IOS5.0" then
					table.insert(result, payList[i])
				end
			end
		end
	end
	return result
end

function HallRechargeModel:GetInstance()
	if HallRechargeModel.instance == nil then
		HallRechargeModel.instance = HallRechargeModel.New()
	end
	return HallRechargeModel.instance
end

function HallRechargeModel:__delete( ... )
end
