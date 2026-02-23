ExchangeView = ExchangeView or BaseClass()

function ExchangeView:__init( obj )
	-- body
	self.obj = obj
	self:InitData()
	self:InitView()
end

function ExchangeView:InitData( ... )
	-- body
	self.TypeIndex = ExchangeView.ViewType.ZhiFuBao
	self.BindBtnLabelName = ""
	self.Account=nil
	self.relName=nil
end

function ExchangeView:InitView( ... )
	-- body
	
	local mTran = self.obj.transform
	
	self.currentMoneyInput = mTran:Find("Tip_Label_Coin/label").gameObject:GetComponent(typeof(UILabel))	--当前用用的钱
	
	self.exchangeMoneyInput = mTran:Find("Coin/Kuang/input").gameObject:GetComponent(typeof(UIInput))		--兑换金额

	self.AccountLabel = mTran:Find("BangDing/Label").gameObject:GetComponent(typeof(UILabel))  --绑定账号
	self.QuickDrewSlider = mTran:Find("ZuiDa/Kuang").gameObject:GetComponent(typeof(UISlider))		-- 快速
	
	self.bigBtnObj = mTran:Find("ZuiDa/ZuiDa").gameObject
	--self.delBtnObj = mTran:Find("Coin/ChongZhi").gameObject
	self.confirmBtnObj = mTran:Find("Button_Sure").gameObject
	self.BindingBtnObj = mTran:Find("BangDing/Btn_BangDing").gameObject
	self:InitAll()
	UIEventListener.Get(self.confirmBtnObj).onClick = function(obj)self:OnConfirmButton(obj) end
	--UIEventListener.Get(self.delBtnObj).onClick = function(obj)self:OnDelButton(obj) end
	UIEventListener.Get(self.BindingBtnObj).onClick = function(obj)self:OnBindingButton(obj) end
	UIEventListener.Get(self.bigBtnObj).onClick = function(obj)self:OnBigButton(obj) end
	local selectActionCount = self.exchangeMoneyInput.gameObject:GetComponent(typeof(UIInputSelectAction))
	selectActionCount.onDeSelectAction = function() self:OnDeSelectActionCount() end
	self.mBool_IsInputing=false
    local back = function ( ... )
		-- body
		if self.mBool_IsInputing then
			self.mBool_IsInputing=false
			return
		end
    	self:OnQuickDrawChanage()
	end
	EventDelegate.Add(self.QuickDrewSlider.onChange,back)
	self.mLabel_TipLabel=mTran:Find("Tex/Label_02").gameObject:GetComponent(typeof(UILabel))
	self.obj:SetActive(false)
	--self.mLabel_TipLabel.text=ConfigModuleModel.GetInstance().RevenueAlert
end

function ExchangeView:InitAll( ... )
	-- body
	self.QuickDrewSlider.value = 0
	--self.mLabel_SliderTip.text="0%"
	self.exchangeMoneyInput.value = 0
end


function ExchangeView:SetViewType( type )
	-- body
	self.TypeIndex = type
	self.BindBtnLabelName = self.TypeIndex == 1 and "更换支付宝" or "更换银行卡"
end

function ExchangeView:OnDeSelectActionCount( ... )
	self.mBool_IsInputing=true
	-- body
	local value = self.exchangeMoneyInput.value
	if value==nil or value=="" then
		value=0
	end
	value = tonumber(value)
	value=HallGoldRateCToS(value)
	if value >self.MyMoney then
		value = self.MyMoney
		self:SetExchangeMoney(value)
	end
	-- value = (value > self.MyMoney) and self.MyMoney or value
	local pressValue = value / self.MyMoney 
	self.QuickDrewSlider.value = pressValue
	--self.mLabel_SliderTip.text=tostring( math.floor( pressValue*100+0.5 ) ).."%"
	--self:SetExchangeMoney(value)
end

function ExchangeView:OnQuickDrawChanage( ... )
	-- body
	if self.MyMoney ~= 0 then 
		local value = self.QuickDrewSlider.value *self.MyMoney
		self:SetExchangeMoney(value)
		--self:OnDeSelectActionCount()
	end
end


function ExchangeView:SetUserMoney( value )
	-- body
	value=value or 0
	self.MyMoney = value
	value=HallGoldRateSToC(value)
	self.currentMoneyInput.text=NumberFormat(value)
end

function ExchangeView:SetExchangeMoney( value )
	-- body
	if value==nil then
		return
	end
	value=tonumber(value)
	value= value ~= nil and  value or 0
	
	value = value > self.MyMoney and self.MyMoney or value
	value=HallGoldRateSToC(value)

	self.exchangeMoneyInput.value = value
end


function ExchangeView:SetBinDingData( data )
	-- body
	if data~=nil and data.Account~=nil and data.Account~="null" and data.Account~=""  and type(data.Account)~="function"  and data.relName~=nil and data.relName~="null" and data.relName~="" and type(data.relName)~="function" then
		self.Account= data.Account
		self.relName=data.relName
		self.AccountLabel.text=GetStringNotFull(self.relName)
		--self.BindingBtnObj:SetActive(ConfigModuleModel.GetInstance().CanChanangeBindInfo)
	else
		self.Account=nil
		self.relName=nil
		self.AccountLabel.text="未绑定"
	end

end

function ExchangeView:OnBigButton( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- body
	self.QuickDrewSlider.value = 1
	--self.mLabel_SliderTip.text="100%"
	self:SetExchangeMoney(self.MyMoney)
end

---退格键按钮事件
function ExchangeView:OnDelButton( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	self:InitAll()
end

---兑换按钮事件
function ExchangeView:OnConfirmButton( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	if self.Account==nil or self.Account=="" or self.relName==nil or self.relName=="" then
		UIManager:GetInstance():ShowNoteMessage("User_Account_Null")
		return
	end
	-- body
	local value = tonumber(self.exchangeMoneyInput.value)
	local Account = self.Account

	if value <= 0 then
		UIManager:GetInstance():ShowNoteMessage("请输入如有效金额")
		return
	end


	if ConfigModuleModel.GetInstance().MinimumExchangeAmount > 0 then
		local t1,t2 = math.modf( value/ ConfigModuleModel.GetInstance().MinimumExchangeAmount )
		if t2 > 0 then
			local tips = StringFormat("只能提取{0}的整数倍",ConfigModuleModel.GetInstance().MinimumExchangeAmount)
			UIManager:GetInstance():ShowNoteMessage(tips)
			return 
		end
	end


	local types =nil
	if self.TypeIndex==ExchangeView.ViewType.ZhiFuBao then
		types=HallExchangeModel.BindType.ZhiFuBao
	elseif self.TypeIndex==ExchangeView.ViewType.Bank then
		types=HallExchangeModel.BindType.Bank
	end

	HallExchangeModel.GetInstance():Exchange( Account,self.relName,types,HallGoldRateCToS(value),function ()
		UIManager:GetInstance():ShowNoteMessage("兑换成功！")
		self.exchangeMoneyInput.value = 0
	end)

end

--绑定按钮事件
function ExchangeView:OnBindingButton( obj )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)


	local sucBindFunc=function (data)
		UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallExchangeBind)
		self.AccountLabel.text=GetStringNotFull(data.name)
		self.Account=data.card
		self.relName=data.name
	end
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallExchangeBind,function (panel)
		if self.TypeIndex==ExchangeView.ViewType.ZhiFuBao then
			panel:OpenBindZhiFuBaoView(sucBindFunc)
		elseif self.TypeIndex==ExchangeView.ViewType.Bank then
			panel:OpenBindBankView(sucBindFunc)
		end

	end)


end



function ExchangeView:ShowView( )
	-- body
	self.obj:SetActive(true)
	if self.TypeIndex == 1 then
		if CheckServiceJsonDataIsNullOrEmpty(HallExchangeBindModel.GetInstance().data.zfbdata.desc) ~= nil then
			self.mLabel_TipLabel.text= HallExchangeBindModel.GetInstance().data.zfbdata.desc
		end
	else
		if CheckServiceJsonDataIsNullOrEmpty(HallExchangeBindModel.GetInstance().data.bankdata.desc) ~= nil then
			self.mLabel_TipLabel.text= HallExchangeBindModel.GetInstance().data.bankdata.desc
		end
	end
end

function ExchangeView:HideView( )
	-- body
	self.obj:SetActive(false)
end

--设置子panel的深度
function ExchangeView:SetPanelDepth(depth)

end

function ExchangeView:__delete( ... )
	-- body
	self.currentMoneyInput = nil
	self.exchangeMoneyInput = nil
	self.AccountLabel = nil
	self.QuickDrewSlider = nil
	self.bigBtnObj = nil
	self.delBtnObj = nil
	self.confirmBtnObj = nil
	self.BindingBtnObj = nil
	self.exchangeRecordingBtnObj = nil
end

ExchangeView.ViewType={
	ZhiFuBao=1,
	Bank=2,
}