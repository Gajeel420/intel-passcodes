PromotionBindView = BaseClass()

function PromotionBindView:__init(obj)
    self.obj = obj
    self:InitUI()
end

function PromotionBindView:InitUI()
    local mTran = self.obj.transform
    self.mInput_UID = mTran:Find("Content/UserID/Input").gameObject:GetComponent(typeof(UIInput))
    local mObj_Close = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(mObj_Close).onClick = function() self:OnButtonClose() end
    local mObj_Bind = mTran:Find("Content/Button_Sure").gameObject
    UIEventListener.Get(mObj_Bind).onClick = function() self:OnButtonBind() end
end


function PromotionBindView:OnButtonClose()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
    --SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self:SetViewDispley(false)
end

function PromotionBindView:OnButtonBind()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    local uid = self.mInput_UID.value
    if uid ~= nil and uid ~="" then
        HallPromotionModel.GetInstance():ReqBindRecommend(uid,function()
            -- self.mButton_binding:SetActive(false)
            -- self.mBox_Input.enabled = false
            HallPromotionController.GetInstance().view.panel.DevelopmentOfflineView:OnBindSuccess(uid);
            self:SetViewDispley(false)
        end)
    else
        UIManager.GetInstance():ShowNoteMessage("请输入上级ID")
    end
end

function PromotionBindView:SetViewDispley(disPlay)
    self.obj:SetActive(disPlay)
end


function PromotionBindView:SetViewDepth(depth)
    SetPanelstartingRenderQueue(self.obj,depth+30)
end

function PromotionBindView:__delete()
end