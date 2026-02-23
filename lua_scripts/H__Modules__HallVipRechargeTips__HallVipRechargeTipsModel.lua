HallVipRechargeTipsModel = BaseClass(LuaModel)

function HallVipRechargeTipsModel:__init()
end


function HallVipRechargeTipsModel:GetIsShowVipRechargeTips()
    local result = PlayerPrefs.GetInt("Key_GetIsShowVipRechargeTips", 1)
    result = result ==nil and 1 or result
    return result
end

function HallVipRechargeTipsModel:SaveIsShowVipRechargeTips(value)
    PlayerPrefs.SetInt("Key_GetIsShowVipRechargeTips", value or 0)
end


function HallVipRechargeTipsModel:GetInstance()
	if HallVipRechargeTipsModel.instance == nil then
		HallVipRechargeTipsModel.instance = HallVipRechargeTipsModel.New()
	end
	return HallVipRechargeTipsModel.instance
end

function HallVipRechargeTipsModel:__delete()
end