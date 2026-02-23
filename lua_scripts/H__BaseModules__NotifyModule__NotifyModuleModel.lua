NotifyModuleModel=NotifyModuleModel or BaseClass(LuaModel)

function NotifyModuleModel:__init( ... )
	self.g_NotifyList={}
end

function NotifyModuleModel:AddNotifyList(notify)
	if  not self.g_NotifyList then
		table.insert(self.g_NotifyList,notify)
	end
	self:DispatchEvent(NotifyModuleConst.EventName_AddNotify,notify)
end

function NotifyModuleModel:SubNotifyList(index)
	
end

function NotifyModuleModel:GetInstance( ... )
	if not NotifyModuleModel.instance then
		NotifyModuleModel.instance=NotifyModuleModel.New()
	end
	return NotifyModuleModel.instance
end

function NotifyModuleModel:__delete( ... )
	-- body
end