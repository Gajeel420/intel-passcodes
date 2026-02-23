ActivityModuleModel=ActivityModuleModel or BaseClass(LuaModel)

function ActivityModuleModel:__init()
    -- 活动列表
    self.m_ActivityList = {}
    -- 是否正在显示活动
    self.m_IsShowActivity = false
end

function ActivityModuleModel:GetInstance()
	if ActivityModuleModel.instance==nil then 
		ActivityModuleModel.instance=ActivityModuleModel.New()
	end
	return ActivityModuleModel.instance
end

function ActivityModuleModel:__delete()
    self.m_ActivityList = nil
end

function ActivityModuleModel:AddActivityEvent(event)
    -- print("-------------   添加活动 ")
    table.insert(self.m_ActivityList, event)

    if not self.m_IsShowActivity then
        self.m_IsShowActivity = true
        self:ExecuteNextActivityEvent()
    end
end

function ActivityModuleModel:ExecuteNextActivityEvent()
    StartCoroutine(function ()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        -- print("----------------  准备执行下一条活动")
        if #self.m_ActivityList <= 0 then
            --活动弹窗展示结束
            -- print("-------------   活动弹窗展示结束 ")
            self.m_IsShowActivity = false
            return
        end
    
        local nowActivity = self.m_ActivityList[1]
        table.remove(self.m_ActivityList,1)
        if nowActivity then
            -- print("-------------   展示活动弹窗  2222")
            nowActivity()
            nowActivity = nil
        end
    end)
end

function ActivityModuleModel:ClearData()
    self.m_ActivityList = nil
    self.m_ActivityList = {}
    self.m_IsShowActivity = false
end