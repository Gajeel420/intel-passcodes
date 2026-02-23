RedDotModuleModel = RedDotModuleModel or BaseClass(LuaModel)

function RedDotModuleModel:__init( ... )
    -- 红点目标数据
    self.m_AllRedDotTarger = {}
    -- 临时目标
    self.m_TempTarget = nil
end

--- 添加红点事件
function RedDotModuleModel:AddRedDotEvent(eventName, obj, targetType)
    if self.m_AllRedDotTarger[eventName] == nil then
        self.m_AllRedDotTarger[eventName] = {}
    end

    local redDotData = {}
    redDotData.Obj = obj
    redDotData.TargetType = targetType

    table.insert(self.m_AllRedDotTarger[eventName], redDotData)
end

--- 移除红点事件
function RedDotModuleModel:RemoveRedDotEvent(eventName, obj)
    if self.m_AllRedDotTarger[eventName] == nil then
        return
    end

    if obj == nil then
        if self.m_AllRedDotTarger[eventName] then
            self.m_AllRedDotTarger[eventName] = nil
            return
        end
    end

    for i = 1, #self.m_AllRedDotTarger[eventName] do
        if self.m_AllRedDotTarger[eventName][i].Obj == obj then
            table.remove(self.m_AllRedDotTarger[eventName], i)
            return
        end
    end

end

--- 通知处理红点事件
function RedDotModuleModel:DispatchRedDotEvent(eventName, redDotState, num)
    if self.m_AllRedDotTarger[eventName] == nil then
        print("------ 请先添加  RedDotEvent."..eventName.."  对应的红点目标")
        return
    end

    for i = 1, #self.m_AllRedDotTarger[eventName] do
        self.m_TempTarget = self.m_AllRedDotTarger[eventName][i]
        if redDotState == RedDotState.OPEN then
            if self.m_TempTarget.TargetType == RedDotTargetType.GAMEOBJECT then
                self.m_TempTarget.Obj:SetActive(true)
            elseif self.m_TempTarget.TargetType == RedDotTargetType.TEXT then
                if num then
                    if tonumber(num) > 99 then
                        self.m_TempTarget.Obj.text = "99+"
                    else
                        self.m_TempTarget.Obj.text = tostring(num)
                    end
                end
            end
        else
            if self.m_TempTarget.TargetType == RedDotTargetType.GAMEOBJECT then
                self.m_TempTarget.Obj:SetActive(false)
            elseif self.m_TempTarget.TargetType == RedDotTargetType.TEXT then
                self.m_TempTarget.Obj.text = "0"
            end
        end
    end
end

function RedDotModuleModel:__delete( ... )
    self.m_AllRedDotTarger = {}
    self.m_AllRedDotTarger = nil
    self.m_TempTarget = nil
end