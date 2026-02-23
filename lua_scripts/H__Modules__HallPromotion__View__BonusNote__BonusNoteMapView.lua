BonusNoteMapView = BonusNoteMapView or BaseClass()

function BonusNoteMapView:__init(obj)
    self.obj = obj
    self:InitUI()
end

function BonusNoteMapView:InitUI()
    self:HideView()
    local mTran = self.obj.transform
    self.mObj_ListButton = mTran:Find("Button_List").gameObject
    UIEventListener.Get(self.mObj_ListButton).onClick = function() self:OnClickListButton() end
end

function BonusNoteMapView:OnClickListButton()
    HallPromotionController.GetInstance().view.panel:OpenBonusNoteView()
end

function BonusNoteMapView:SetPanelDepth(depth)
    
end

function BonusNoteMapView:ShowView()
    self.obj:SetActive(true)
end

function BonusNoteMapView:HideView()
    self.obj:SetActive(false)
end

function BonusNoteMapView:__delete()
end