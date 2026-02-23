RechangeInfoView = BaseClass()

function RechangeInfoView:__init(obj)
    self.obj = obj
    self:InitView()
end

function RechangeInfoView:InitView()
    local mTran = self.obj.transform
    self.mInput_RechargeName = mTran:Find("RechageName/Input").gameObject:GetComponent(typeof(UIInput))     --充值姓名
    self.mLabel_RechargeTime =  mTran:Find("RechageTime/label").gameObject:GetComponent(typeof(UILabel))     --充值时间
    self.mLabel_RechargeNum =  mTran:Find("RechageNum/label").gameObject:GetComponent(typeof(UILabel))     --充值金额
    local mBtn_Submit = mTran:Find("Btn_Submit").gameObject
    self:RefreshTime()
    UIEventListener.Get(mBtn_Submit).onClick = function(go) self:OnButtonSubmit() end
end

function RechangeInfoView:RefreshTime()
    self.mLabel_RechargeTime.text = TimeStampToTime(os.time())
end

function RechangeInfoView:RefreshMoney (data,paytype)
    self.datas = data
    self.paytype = paytype
    self.mLabel_RechargeNum.text = data.money
end

function RechangeInfoView:OnButtonSubmit(go)

    if self.mInput_RechargeName.value == "" then
        UIManager.GetInstance():ShowNoteMessage("请输入充值姓名")
        return 
    end

    local data = {}
    data.kname = HallTransferInformationController.GetInstance().model.data.Name
    data.bank_name = HallTransferInformationController.GetInstance().model.data.bankName
    data.bank_card = HallTransferInformationController.GetInstance().model.data.bankCard
    data.cname = self.mInput_RechargeName.value
    data.input_time = self.mLabel_RechargeTime.text
    data.mid = self.datas.mid

    HallTransferInformationController.GetInstance().model:RespRechargeInfo(data,self.paytype,function()
        self:CleanInptValue()   
        UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallTransferInformation)
        local showBoxData ={}
        showBoxData.title = "提示"
        showBoxData.context ="订单已提交，支付确认到帐在点击确定，网络波动时到帐会延迟。"
        showBoxData.enterCB = function() 
            PlayerInfoController:GetInstance():RequestGetUserMoney()
        end--：点击确定返回；
        showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮; 
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
        UIManager:GetInstance():ShowMessageBox(showBoxData)
    end)
end

function RechangeInfoView:CleanInptValue()
    self.mInput_RechargeName.value = ""
end

function RechangeInfoView:__delete()

end