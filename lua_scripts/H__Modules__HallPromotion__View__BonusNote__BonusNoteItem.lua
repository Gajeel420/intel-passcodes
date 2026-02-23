
BonusNoteItem = BonusNoteItem or BaseClass()

function BonusNoteItem:__init( obj )
    self.obj=obj
    self:Init()
end

function BonusNoteItem:Init( )
    local mTran = self.obj.transform
    --self.mLabel_Level=mTran:Find("Label_01/Label"):GetComponent(typeof(UILabel))
    self.mLabel_Performance=mTran:Find("Label_02"):GetComponent(typeof(UILabel))
    self.mLabel_LevelName=mTran:Find("Label_01"):GetComponent(typeof(UILabel))
    self.mLabel_Proportion=mTran:Find("Label_03"):GetComponent(typeof(UILabel))
    
end


function BonusNoteItem:SetItemData(data)
    --子项数据列表 {id:等级，title：名称，s_money：业绩范围-最小，e_money：业绩范围-最大（单位：万），commission：返佣（每一万返多少元）}
    --self.mLabel_Level.text=tostring(data.id)
    local Performance=nil
    if  tonumber(data.s_money)==0  then
        Performance=NumberFormatAndNotRoation(HallGoldRateSToC( tonumber(data.e_money) )).."以下"
    elseif tonumber(data.e_money)==0 then
        Performance=NumberFormatAndNotRoation(HallGoldRateSToC(tonumber(data.s_money))).."以上"
    else
        Performance=NumberFormatAndNotRoation(HallGoldRateSToC(tonumber(data.s_money))).."-"..NumberFormatAndNotRoation(HallGoldRateSToC( tonumber(data.e_money)))
    end
    self.mLabel_Performance.text=Performance

    self.mLabel_LevelName.text=tostring(data.title)
    self.mLabel_Proportion.text=StringFormat("{0}/万",data.commission)


end

function BonusNoteItem:ShowItem()
    self.obj:SetActive(true)
end
function BonusNoteItem:HideItem()
    self.obj:SetActive(false)
end


function BonusNoteItem:__delete(  )

end
