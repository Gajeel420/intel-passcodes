
TeamManagementItem = TeamManagementItem or BaseClass()

function TeamManagementItem:__init( obj )
    self.obj=obj
    self:Init()
end

function TeamManagementItem:Init( )
    local mTran = self.obj.transform
    self.Data=nil
    self.mLabel_ID=mTran:Find("Label_01"):GetComponent(typeof(UILabel))
    self.mLabel_SelfWater=mTran:Find("Label_02"):GetComponent(typeof(UILabel))
    self.mLabel_AgentWater=mTran:Find("Label_03"):GetComponent(typeof(UILabel))
    self.mLabel_YongJin=mTran:Find("Label_04"):GetComponent(typeof(UILabel))
    self.mLabel_TeamNum=mTran:Find("Label_05"):GetComponent(typeof(UILabel))
    
end


function TeamManagementItem:SetItemData(data)
    self.Data=data
    --子项数据列表 {uid,self_water,agent_water,teamnum}
    self.mLabel_ID.text=tostring(data.uid)
    self.mLabel_SelfWater.text=NumberFormat(HallGoldRateSToC(data.self_water))
    self.mLabel_AgentWater.text=NumberFormat(HallGoldRateSToC(data.agent_water))
    self.mLabel_TeamNum.text=tostring(data.teamnum)
    self.mLabel_YongJin.text = NumberFormat(HallGoldRateSToC(data.gongxian_money))
end

function TeamManagementItem:GetId()
    if self.Data then
        return self.Data.uid
    else
        return nil
    end
end



function TeamManagementItem:ShowItem()
    self.obj:SetActive(true)
end
function TeamManagementItem:HideItem()
    self.obj:SetActive(false)
end


function TeamManagementItem:__delete(  )

end
