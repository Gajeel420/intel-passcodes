DayPerformanceItem = DayPerformanceItem or BaseClass()

function DayPerformanceItem:__init( obj )
    self.obj=obj
    self:Init()
end

function DayPerformanceItem:Init( )
    local mTran = self.obj.transform
    self.mLabel_Rank=mTran:Find("Label_01"):GetComponent(typeof(UILabel))
    self.mLabel_ID=mTran:Find("Label_02"):GetComponent(typeof(UILabel))
    self.mLabel_AgentWater=mTran:Find("Label_04"):GetComponent(typeof(UILabel))
    self.mLabel_SelfWater=mTran:Find("Label_03"):GetComponent(typeof(UILabel))
    self.mLabel_GX=mTran:Find("Label_05"):GetComponent(typeof(UILabel))  
end


function DayPerformanceItem:SetItemData(data)
    --子项数据列表 {rank,id,self_water,agent_water}
    local rank=nil
    local id=nil
    local self_water=nil
    local agent_water=nil
    if data.rank==nil or type(data.rank)=="function" then
        rank=""
    else
        rank=data.rank
    end

    if data.id==nil or type(data.id)=="function" then
        id=""
    else
        id=data.id
    end

    if data.self_water==nil or type(data.self_water)=="function" then
        self_water=0
    else
        self_water=data.self_water
    end

    if data.agent_water==nil or type(data.agent_water)=="function" then
        agent_water=0
    else
        agent_water=data.agent_water
    end

    self.mLabel_Rank.text=tostring(rank)
    self.mLabel_ID.text=tostring(id )
    self.mLabel_AgentWater.text=NumberFormat(HallGoldRateSToC(agent_water))
    self.mLabel_SelfWater.text=NumberFormat(HallGoldRateSToC(self_water))
    self.mLabel_GX.text = NumberFormat(HallGoldRateSToC(data.all))
end

function DayPerformanceItem:ShowItem()
    self.obj:SetActive(true)
end
function DayPerformanceItem:HideItem()
    self.obj:SetActive(false)
end


function DayPerformanceItem:__delete(  )

end
