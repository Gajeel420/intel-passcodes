DevelopmentOfflineView = DevelopmentOfflineView or BaseClass()

function DevelopmentOfflineView:__init(obj)
    self.obj = obj
    self:Init()
end

function DevelopmentOfflineView:Init()
    local mTran = self.obj.transform
    
    self.mTexture_ErWeiMa = mTran:Find("ErWeiMa/Sprite"):GetComponent(typeof(UITexture))
    UIEventListener.Get(self.mTexture_ErWeiMa.gameObject).onClick = function(obj) self:OnButtonErWeiMaClick(obj)  end
    self.mObj_ButtonWchat = mTran:Find("Button_WeiXin").gameObject
    UIEventListener.Get(self.mObj_ButtonWchat).onClick = function() self:OnClickSavaButton() end
    self.mObj_ButtonFriend = mTran:Find("Button_Friend").gameObject
    UIEventListener.Get(self.mObj_ButtonFriend).onClick = function() self:OnclickShareFriend() end

    self.mObj_ButtonQQ = mTran:Find("Button_QQ").gameObject
    UIEventListener.Get(self.mObj_ButtonQQ).onClick = function(obj) self:OnclickShareRefresh(obj) end

    self.mLabel_ShareLink = mTran:Find("Label_Link"):GetComponent(typeof(UILabel))
    self.mLabel_ShareLink.text = ""
    self.mObj_CopyButton = mTran:Find("Button_Copy").gameObject
    UIEventListener.Get(self.mObj_CopyButton).onClick = function() self:OnClickCopyButton() end

    self.mObj_GetButton = mTran:Find("Button_Get").gameObject       --领取佣金
    UIEventListener.Get(self.mObj_GetButton).onClick = function() self:OnClickGetButton() end

    self.mObj_RecordButton = mTran:Find("Button_Record").gameObject       --领取记录
    UIEventListener.Get(self.mObj_RecordButton).onClick = function() self:OnClickRecordButton() end

    self.mObj_ListdButton = mTran:Find("Button_List").gameObject       --返佣对照表
    UIEventListener.Get(self.mObj_ListdButton).onClick = function() self:OnClickListButton() end
  
    self.mLabel_myID =  mTran:Find("Label/Label_MYID"):GetComponent(typeof(UILabel))
    self.mLabel_TuiJIanID =  mTran:Find("Label/Label_TJID"):GetComponent(typeof(UILabel)) --推荐人
    self.mLabel_TeamNum =  mTran:Find("Label/Label_TDRS"):GetComponent(typeof(UILabel)) --团队人数
    self.mLabel_TDYJ =  mTran:Find("Label/Label_JRTDYJ"):GetComponent(typeof(UILabel)) --团队业绩
    self.mLabel_ZSRS =  mTran:Find("Label/Label_ZSRS"):GetComponent(typeof(UILabel)) --直属人数
    self.mLabel_ZSYJ =  mTran:Find("Label/Label_JRZYYJ"):GetComponent(typeof(UILabel)) --直属业绩
    self.mLabel_JRYJ =  mTran:Find("Label/Label_JRYJYG"):GetComponent(typeof(UILabel)) --今日佣金预估
    self.mLabel_ZRYJ =  mTran:Find("Label/Label_ZRYJYG"):GetComponent(typeof(UILabel)) --昨日佣金
    self.mLabel_LSYJ =  mTran:Find("Button_LSZYJ/Label"):GetComponent(typeof(UILabel)) --历史佣金
    self.mLabel_KTYJ =  mTran:Find("Button_KTQYJ/Label"):GetComponent(typeof(UILabel)) --可提佣金


    

    self.mButton_binding =   mTran:Find("Label/button_banding").gameObject
    self.mButton_binding:SetActive(false)
    UIEventListener.Get(self.mButton_binding).onClick = function() self:OnClickbinding() end

    self.mLabel_TuiJIanID.text =  ""
    self.mLabel_TeamNum.text = 0
    self.mLabel_TDYJ.text =  0
    self.mLabel_ZSRS.text = 0
    self.mLabel_ZSYJ.text =  0
    
    self.mLabel_JRYJ.text =  0
    self.mLabel_ZRYJ.text =  0
    self.mLabel_LSYJ.text = 0
    self.mLabel_KTYJ.text =  0
    
    self:SetGetButtonCanClick(false)

    self.data = nil
end

function DevelopmentOfflineView:AddEvent()

end

function DevelopmentOfflineView:RemoveEvent()

end


function DevelopmentOfflineView:OnButtonErWeiMaClick(ogj)
    SoundManager:GetInstance():PrePlaySound(0, SoundManager.SoundID.ButtonClick)
    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPromotionCode)
end

function DevelopmentOfflineView:OnClickSavaButton()
    SoundManager:GetInstance():PrePlaySound(0, SoundManager.SoundID.ButtonClick)

    if self.data ~= nil and self.data.imglink ~= nil and type(self.data.imglink) ~= "function" and self.data.imglink ~= "" then

        PhoneManager:WechatSharePictureToWXSceneSession(self.data.imglink)
    end
end


function DevelopmentOfflineView:OnClickGetButton()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if self.data ~= nil and self.data.imglink ~= nil and type(self.data.imglink) ~= "function" and self.data.imglink ~= "" then
        self:OnClickWithdrawalButton(self.data.data.wei_shouyi)
    end
end


function DevelopmentOfflineView:OnClickWithdrawalButton(money)
	
   
    -- if money==nil or money=="" or money=="0" or tonumber(money)==0 then
    --     UIManager:GetInstance():ShowNoteMessage("余额不足！")
    --     return
    -- end
    
    HallPromotionModel.GetInstance():ReqSpreadModel(function (data)
        if data.Model==HallPromotionModel.SpreadType.Money then
            
            HallExchangeModel.GetInstance():GetBindingAccount(function (data)
                local zhiFuBaoAccount=nil
                local zhiFuBaoRelName=nil
                local bankAccount=nil
                local bankRelName=nil

                if CheckServiceJsonDataIsNullOrEmpty(data.ZhiFuBaoAccount) ==nil  then
                   
                    zhiFuBaoAccount=nil
                    zhiFuBaoRelName=nil
                else
        
                    zhiFuBaoAccount=data.ZhiFuBaoAccount
                    zhiFuBaoRelName=data.ZhiFuBaoRelName
                end
                
                if CheckServiceJsonDataIsNullOrEmpty(data.BankAccount)==nil then
                    
                    bankAccount=nil
                    bankRelName=nil
                else
        
                    bankAccount=data.BankAccount
                    bankRelName=data.BankRelName
                end


                if zhiFuBaoAccount==nil and bankAccount==nil then
                    
                    local sucBindFunc=function (data)
                        
                        UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchangeBind)
                        zhiFuBaoAccount = data.card
                        zhiFuBaoRelName = data.name
                        HallPromotionModel:ReqCashWithdrawal(money,zhiFuBaoAccount,zhiFuBaoRelName,bankAccount,bankRelName,function ()
                            UIManager:GetInstance():ShowNoteMessage("提交成功！")
                            self:RefreshView()
                        end)
                        
                    end
                    UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchangeBind,function (panel)
                        if ConfigModuleModel.GetInstance().exchangetype.alipay then
                            panel:OpenBindZhiFuBaoView(sucBindFunc)
                        elseif ConfigModuleModel.GetInstance().exchangetype.bank then
                            panel:OpenBindBankView(sucBindFunc)
                        end
                    end)
                    
                else
                    
                    HallPromotionModel:ReqCashWithdrawal(money,zhiFuBaoAccount,zhiFuBaoRelName,bankAccount,bankRelName,function ()
                        UIManager:GetInstance():ShowNoteMessage("提交成功！")
                        --self:RefreshView()
                        HallPromotionModel.GetInstance():ReqShareLinks(function(data)
                            if self then
                                --self.mButton_binding:SetActive(ConfigModuleModel.GetInstance().CanBindByClient)
                               
                                self:SetViewData(data)
                            end
                        end)
                    end)
                end
            end)

        elseif data.Model==HallPromotionModel.SpreadType.Gold then
            HallPromotionModel:ReqCashWithdrawal(money,nil,nil,nil,nil,function ()
                UIManager:GetInstance():ShowNoteMessage("提交成功！")
                --self:RefreshView()
                HallPromotionModel.GetInstance():ReqShareLinks(function(data)
                    if data then
                        --self.mButton_binding:SetActive(ConfigModuleModel.GetInstance().CanBindByClient)
                       
                        self:SetViewData(data)
                    end
                end)
            end)
        end
        
    end)

end




function DevelopmentOfflineView:OnClickRecordButton()
    HallPromotionController.GetInstance().view.panel:OpenCashWithdrawalView()
end

function DevelopmentOfflineView:OnClickListButton()
    HallPromotionController.GetInstance().view.panel:OpenBonusNoteView()
end


function DevelopmentOfflineView:OnClickbinding(go)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    HallPromotionController.GetInstance().view.panel.BindView:SetViewDispley(true)
end

---分享到朋友圈
function DevelopmentOfflineView:OnclickShareFriend()
    SoundManager:GetInstance():PrePlaySound(0, SoundManager.SoundID.ButtonClick)
    if self.data ~= nil and self.data.imglink ~= nil and type(self.data.imglink) ~= "function" and self.data.imglink ~= "" then
        PhoneManager:WechatSharePictureToWXSceneTimeline(self.data.imglink)
    end
end

--刷新二维码
function DevelopmentOfflineView:OnclickShareRefresh(ogj)
    SoundManager:GetInstance():PrePlaySound(0, SoundManager.SoundID.ButtonClick)
    HallPromotionModel.GetInstance():ReqShareLinks(function(data)
        if self then
            --self.mButton_binding:SetActive(ConfigModuleModel.GetInstance().CanBindByClient)
           
            self:SetViewData(data)
        end
    end)
end


function DevelopmentOfflineView:OnClickCopyButton()
    SoundManager:GetInstance():PrePlaySound(0, SoundManager.SoundID.ButtonClick)

    local shareLinkString = self.mLabel_ShareLink.text
    if shareLinkString ~= nil and shareLinkString ~= "" then
        PhoneManager:MyClipDataToClipboard(shareLinkString)
        UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
    end

end

function DevelopmentOfflineView:OnBindSuccess(uid)
    self.mLabel_TuiJIanID.text=uid
    self.mButton_binding:SetActive(false)
end

function DevelopmentOfflineView:SetViewData(data)
    if CheckServiceJsonDataIsNullOrEmpty(data) ~=nil then
        if CheckServiceJsonDataIsNullOrEmpty(data.imglink) ~= nil then
            local OnComplete = function(wwwLoad)
                if (wwwLoad ~= nil) then
                    local tex = wwwLoad.texture
                    self.mTexture_ErWeiMa.mainTexture = tex
                end
            end
            DownLoadManager:BeginWWWRequest(data.imglink, OnComplete)
        end
        if CheckServiceJsonDataIsNullOrEmpty(data.weblink)  ~= nil then
            self.mLabel_ShareLink.text = data.weblink
        end
        if data.retcode == 0 then
            if CheckServiceJsonDataIsNullOrEmpty(data.data) ~= nil then
                if CheckServiceJsonDataIsNullOrEmpty(data.data.ruid) == nil or data.data.ruid == "--" then
                self.mButton_binding:SetActive(ConfigModuleModel.GetInstance().CanBindByClient)
            else
                self.mButton_binding:SetActive(false)
            end
                self.mLabel_TuiJIanID.text =  data.data.ruid
            self.mLabel_TeamNum.text = data.data.team_num
            self:SetLabelValue(self.mLabel_TDYJ,data.data.agent_water) 
            self.mLabel_ZSRS.text = data.data.self_num
            self:SetLabelValue(self.mLabel_ZSYJ,data.data.self_water)
            self:SetLabelValue( self.mLabel_JRYJ,data.data.tmoney)
            self:SetLabelValue(self.mLabel_ZRYJ,data.data.ymoney)
            self:SetLabelValue(self.mLabel_LSYJ,data.data.all_shouyi)
            self:SetLabelValue(self.mLabel_KTYJ,data.data.wei_shouyi)
            self.data = data
            --初始化二维码
            self:SetGetButtonCanClick(true)
            end
        else
            if CheckServiceJsonDataIsNullOrEmpty(data.data) ~= nil then
                self.mLabel_TuiJIanID.text =  data.data.ruid
            end
            self.mLabel_TeamNum.text = "统计中"
            self.mLabel_TDYJ.text =  "统计中"
            self.mLabel_ZSRS.text = "统计中"
            self.mLabel_ZSYJ.text =  "统计中"
            
            self.mLabel_JRYJ.text =  "统计中0点-5点"
            self.mLabel_ZRYJ.text =  "统计中0点-5点"
            self.mLabel_LSYJ.text = "统计中0点-5点"
            self.mLabel_KTYJ.text =  "统计中0点-5点"
            self:SetGetButtonCanClick(false)
        end
    end
end

function DevelopmentOfflineView:SetGetButtonCanClick(display)
    local mColorValue = display and 1 or 0
    self.mObj_GetButton:GetComponent(typeof(UISprite)).color = Color(mColorValue,1,1)
    self.mObj_GetButton:GetComponent(typeof(BoxCollider)).enabled = display
end

function DevelopmentOfflineView:SetLabelValue(mLabel,value)
    if not mLabel then return end
    value=value or 0
    value=HallGoldRateSToC(value)
    mLabel.text=StringFormat("{0}",NumberFormat(value))
end

function DevelopmentOfflineView:ShowView()
    self.obj:SetActive(true)
    self.mLabel_myID.text = PlayerInfoController.GetInstance().model.mainPlayer.uiUserID
    HallPromotionModel.GetInstance():ReqShareLinks(function(data)
        if self then
            
            --self.mButton_binding:SetActive(ConfigModuleModel.GetInstance().CanBindByClient)
            
            self:SetViewData(data)
        end
    end)
end
function DevelopmentOfflineView:HideView()
    self.imglink = nil
    self.obj:SetActive(false)
end

function DevelopmentOfflineView:SetPanelDepth(depth)

end

function DevelopmentOfflineView:__delete()

end