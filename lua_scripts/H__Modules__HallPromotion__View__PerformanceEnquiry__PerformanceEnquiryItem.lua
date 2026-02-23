PerformanceEnquiryItem = PerformanceEnquiryItem or BaseClass()

function PerformanceEnquiryItem:__init( obj )
    self.obj=obj
    self.data=nil
    self.OnClickItemCallBackTabel={callBack=nil,obj=nil}

    self:Init()
end

function PerformanceEnquiryItem:Init( )
    local mTran = self.obj.transform
    self.mLabel_Time=mTran:Find("Label_01"):GetComponent(typeof(UILabel))
    self.mLabel_TeamWater=mTran:Find("Label_02"):GetComponent(typeof(UILabel))
    self.mLabel_SelfWater=mTran:Find("Label_03"):GetComponent(typeof(UILabel))
    self.mLabel_AgentWater=mTran:Find("Label_04"):GetComponent(typeof(UILabel))
    self.mLabel_YongJin = mTran:Find("Label_05"):GetComponent(typeof(UILabel))
    UIEventListener.Get(self.obj).onClick = function() 
        self:OnClickItem()
     end
end


function PerformanceEnquiryItem:SetItemData(data,callback,callbackObj)
    --子项数据列表 {agent_water,create_date,id,self_water,team_water}
    self.data=data
    self.mLabel_Time.text=tostring(data.create_date) 
    self.mLabel_TeamWater.text=NumberFormat(HallGoldRateSToC(data.team_water))
    self.mLabel_SelfWater.text=NumberFormat(HallGoldRateSToC(data.self_water))
    self.mLabel_AgentWater.text=NumberFormat(HallGoldRateSToC(data.agent_water))
    self.mLabel_YongJin.text = NumberFormat(HallGoldRateSToC(data.spread_money))
    self.OnClickItemCallBackTabel.callBack=callback
    self.OnClickItemCallBackTabel.obj=callbackObj
end


function PerformanceEnquiryItem:OnClickItem()
    if self.data~=nil and self.OnClickItemCallBackTabel~=nil and self.OnClickItemCallBackTabel.callBack~=nil and self.OnClickItemCallBackTabel.obj~=nil then
        self.OnClickItemCallBackTabel.callBack(self.OnClickItemCallBackTabel.obj,self.data)
    end
end

function PerformanceEnquiryItem:ShowItem()
    self.obj:SetActive(true)
end
function PerformanceEnquiryItem:HideItem()
    self.obj:SetActive(false)
end


function PerformanceEnquiryItem:__delete(  )

end
