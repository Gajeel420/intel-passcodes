UIDianKa=UIDianKa or BaseClass()
function UIDianKa:__init(obj)
	self.obj=obj
	self:InitUI()
end

function UIDianKa:InitUI()
	local mTran=self.obj.transform
	self.mInput_CardId=mTran:Find("DKView/IDInput/input"):GetComponent(typeof(UIInput))
	self.mObj_ExchangeButton=mTran:Find("DKView/RechangeButton").gameObject
	UIEventListener.Get(self.mObj_ExchangeButton).onClick = function() self:OnButtonExchange() end

end

function UIDianKa:OnButtonExchange()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	local cardId = TrimStr(self.mInput_CardId.value)
    local cardPassword = "123456"
    local verify_code = 1

    if cardId=="" then
        UIManager:GetInstance():ShowNoteMessage("卡号不能为空")
        return
    end

    UIManager:GetInstance():ShowNetWorkMessage("正在充值中","网络错误，请稍后再试",2)
    RechargeManager:DianKaReCharge(cardId, cardPassword,verify_code)
end

function UIDianKa:ShowUI()
	self.mInput_CardId.value=""
	self.obj:SetActive(true)
end



function UIDianKa:HideUI()
	self.obj:SetActive(false)
end

function UIDianKa:__delete()
	self.CardIdInput = nil
	self.CardPasswordInput = nil
	self.ExchangeBtnObj = nil
	self.objCloseBtn = nil
	self.labelMoney = nil
end