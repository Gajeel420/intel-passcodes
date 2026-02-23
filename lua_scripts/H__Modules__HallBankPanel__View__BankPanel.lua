BankPanel = BankPanel or BaseClass(LuaPanel)

function BankPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.Bank].name
    self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.Bank].path  --资源路径
    self.mPanelID = UIPanelDefine.EWndID.Bank
	self.createPanelCallBack = self.InitUI----必须实现
    self.callBack = callBack----必须实现    
    self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
    self:CreatePanel(0)----必须实现    
end

--初始化ui界面
function BankPanel:InitUI()
	local mTran = self.obj.transform
    self.mBankState = HallDefine.BankState.DrawMoney -- 当前页面状态值
	-- self.mLabel_CarryMoneyName = mTran:Find("Content/Label_CarryMoney/Value"):GetComponent(typeof(UILabel))
	-- self.mLabel_CarryMoneyName.text = StringFormatByLanguage("Carrying_Amount")
   
	-- self.mLabel_BankMoneyName = mTran:Find("Content/Label_BankMoney"):GetComponent(typeof(UILabel))
	-- self.mLabel_BankMoneyName.text = StringFormatByLanguage("Amount_Of_Bank")

    self.Sprite_BG = mTran:Find("Content/BankBG/Sprite_BG").gameObject

     self.CarryMoneyObj = mTran:Find("Content/Label_CarryMoney").gameObject
     self.BankMoneyObj = mTran:Find("Content/Label_BankMoney/Value").gameObject
	self.mLabel_CarryMoney = mTran:Find("Content/Label_CarryMoney/Value"):GetComponent(typeof(UILabel))
	self.mLabel_BankMoney = mTran:Find("Content/Label_BankMoney/Value"):GetComponent(typeof(UILabel))

    self.mToggle_SaveMoney = mTran:Find("Content/Bank_Title/Toggle_Save"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_SaveMoney.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end -- 点击SelectTitleDrawMoney按钮事件

    self.mToggle_DrawMoney = mTran:Find("Content/Bank_Title/Toggle_Draw"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_DrawMoney.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end -- 点击SelectTitleDrawMoney按钮事件

    self.mToggle_ChangePassword = mTran:Find("Content/Bank_Title/Toggle_ChangePassword"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_ChangePassword.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end -- 点击SelectTitleChangePassword按钮事件

    self.mButton_Colse = mTran:Find("Content/Bank_Title/Btn_Back/Background").gameObject
    UIEventListener.Get(self.mButton_Colse).onClick = function () self:OnButtonClose() end-- 点击OnButtonClose按钮事件 

    self.mToggle_SendGive = mTran:Find("Content/Bank_Title/Toggle_Present"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_SendGive.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end --

    self.mToggle_SendGiveRecord = mTran:Find("Content/Bank_Title/Toggle_Transfer_in_record"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_SendGiveRecord.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end --

    self.mToggle_GetGiveRecord = mTran:Find("Content/Bank_Title/Toggle_Transfer_out_record"):GetComponent(typeof(UIToggle))
    UIEventListener.Get(self.mToggle_GetGiveRecord.gameObject).onClick = function (go) self:OnButton_SelectTitle(go) end --

    self.mObj_SaveMoney = mTran:Find("Content/SaveMoney").gameObject;
    self.mObj_DrawMoney = mTran:Find("Content/DrawMoney").gameObject;
    self.mObj_ChangePassword = mTran:Find("Content/ChangePassword").gameObject;

    self.mInput_SaveMoney = mTran:Find("Content/SaveMoney/InputMoney/Input"):GetComponent(typeof(UIInput));
    local selectAction_SaveMoney = self.mInput_SaveMoney:GetComponent(typeof(UIInputSelectAction));
    selectAction_SaveMoney.onDeSelectAction = function() self:OnDeSelectAction_SaveMoney() end;
    self.mSlider_SaveMoney = mTran:Find("Content/SaveMoney/QuickeDrew/Slider"):GetComponent(typeof(UISlider));
    self.mButton_Save = mTran:Find("Content/SaveMoney/Button_Confirm").gameObject;
    self.mLabel_SaveProgress = mTran:Find("Content/SaveMoney/QuickeDrew/Slider/Thumb/Button_Jindu/Label"):GetComponent(typeof(UILabel))
    UIEventListener.Get(self.mButton_Save).onClick = function() self:OnButton_SaveMoney() end

    self.mButton_SaveClean = mTran:Find("Content/SaveMoney/Button_Clear").gameObject;
    UIEventListener.Get(self.mButton_SaveClean).onClick = function()
        self.mInput_SaveMoney.value = "" 
        self.mSlider_SaveMoney.value = 0
    end

    self.mSlider_SaveMoney.onDragFinished = function() self:OnDragFinish_SaveProgress() end
    EventDelegate.Add(self.mSlider_SaveMoney.onChange,function()
        local value = self.mSlider_SaveMoney.value
        local m,d = math.modf( value*100 )
        self.mLabel_SaveProgress.text = StringFormat("{0}%",m)
    end)
    self.mToggle_SaveAll = mTran:Find("Content/SaveMoney/Toggle_All"):GetComponent(typeof(UIToggle));
    UIEventListener.Get(self.mToggle_SaveAll.gameObject).onClick = function(go) self:OnButton_SaveAll(go) end

    -- //取钱界面的组件元素
    self.mInput_DrawMoney = mTran:Find("Content/DrawMoney/InputMoney/Input"):GetComponent(typeof(UIInput));
    local selectAction_DrawMOney = self.mInput_DrawMoney:GetComponent(typeof(UIInputSelectAction));
    selectAction_DrawMOney.onDeSelectAction = function() self:OnDeSelectAction_DrawMoney() end
    self.mSlider_DrawMoney = mTran:Find("Content/DrawMoney/QuickeDrew/Slider"):GetComponent(typeof(UISlider))
    self.mLabel_DrawProgress = mTran:Find("Content/DrawMoney/QuickeDrew/Slider/Thumb/Button_Jindu/Label"):GetComponent(typeof(UILabel))
    self.mSlider_DrawMoney.onDragFinished = function() self:OnDragFinish_DrawProgress() end
    self.mButton_Draw = mTran:Find("Content/DrawMoney/Button_Confirm").gameObject;
    UIEventListener.Get(self.mButton_Draw).onClick = function() self:OnButton_DrawMoney() end

    self.mButton_Clean = mTran:Find("Content/DrawMoney/Button_Clear").gameObject;
    UIEventListener.Get(self.mButton_Clean).onClick = function() 
        self.mInput_DrawMoney.value = ""
        self.mSlider_DrawMoney.value = 0
    end

    EventDelegate.Add(self.mSlider_DrawMoney.onChange,function()
        local value = self.mSlider_DrawMoney.value
        local m,d = math.modf( value*100 )
        self.mLabel_DrawProgress.text = StringFormat("{0}%",m)
    end)

    self.mToggle_DrawAll = mTran:Find("Content/DrawMoney/Toggle_All"):GetComponent(typeof(UIToggle));
    UIEventListener.Get(self.mToggle_DrawAll.gameObject).onClick = function(go) self:OnButton_DrawAll(go) end

    -- // 更改密码界面的组件元素
    self.mButton_ModifyPsd = mTran:Find("Content/ChangePassword/Button_Confirm").gameObject;
    UIEventListener.Get(self.mButton_ModifyPsd).onClick = function() self:OnButton_ModifyPsd() end


    self.mInput_OldPassword = mTran:Find("Content/ChangePassword/OldPassword/InputOldPassword"):GetComponent(typeof(UIInput));
    self.mInput_NewPassword = mTran:Find("Content/ChangePassword/NewPassword/InputOldPassword"):GetComponent(typeof(UIInput));
    self.mInput_ConfirmPassword = mTran:Find("Content/ChangePassword/ConfirmPassword/InputOldPassword"):GetComponent(typeof(UIInput));

    -- self.mInput_SaveMoney.inputType = HallDefine.NGUIInputType.Standard;
    -- self.mInput_SaveMoney.validation = HallDefine.NGUIValidation.Integer;
    -- self.mInput_SaveMoney.keyboardType = HallDefine.NGUIKeyboardType.NumberPad;

    -- self.mInput_DrawMoney.inputType = HallDefine.NGUIInputType.Standard;
    -- self.mInput_DrawMoney.validation = HallDefine.NGUIValidation.Integer;
    -- self.mInput_DrawMoney.keyboardType = HallDefine.NGUIKeyboardType.NumberPad;

	self.mInput_OldPassword.inputType = HallDefine.NGUIInputType.Password
	self.mInput_OldPassword.validation = HallDefine.NGUIValidation.Integer
	self.mInput_OldPassword.keyboardType = HallDefine.NGUIKeyboardType.NumberPad
	-- self.mInput_OldPassword.characterLimit = 密码长度
	-- self.mInput_OldPassword.label.text = StringFormatByLanguage("Pls_Input_Psd")	

	self.mInput_NewPassword.inputType = HallDefine.NGUIInputType.Password
	self.mInput_NewPassword.validation = HallDefine.NGUIValidation.Integer
	self.mInput_NewPassword.keyboardType = HallDefine.NGUIKeyboardType.NumberPad
	-- self.mInput_NewPassword.characterLimit = 密码长度
	-- self.mInput_NewPassword.label.text = StringFormatByLanguage("Pls_Input_Psd")

	self.mInput_ConfirmPassword.inputType = HallDefine.NGUIInputType.Password
	self.mInput_ConfirmPassword.validation = HallDefine.NGUIValidation.Integer
	self.mInput_ConfirmPassword.keyboardType = HallDefine.NGUIKeyboardType.NumberPad
	-- self.mInput_ConfirmPassword.characterLimit = 密码长度
	-- self.mInput_ConfirmPassword.label.text = StringFormatByLanguage("Pls_Input_Psd")


    self.TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))

    self.l50PercentValue = 0 --百分比按钮数值
    self.l20PercentValue = 0
    self.l10PercentValue = 0

    self.SetNewPassword = nil --设置后的新静态密码

    print("ppppppppppppppppppppp1111111111111111111111111")

    local PresentMoney = mTran:Find("Content/PresentMoney").gameObject
    self.UISendGiveView = UISendGiveView.New(PresentMoney)
    
    print("ppppppppppppppppppppp2222222222222222222222222222")

    local mObj_GiveSuccess = mTran:Find("Content/Content_2").gameObject
    self.GiveSuccessView = SendGiveSuccess.New(mObj_GiveSuccess)

   print("ppppppppppppppppppppp3333333333333333333333333")
    
    local Toggle_Transfer_in_record= mTran:Find("Content/Toggle_Transfer_in_record").gameObject
   
    self.UISendRecordView = UISendRecordView.New(Toggle_Transfer_in_record)

    print("ppppppppppppppppppppp444444444444444444444444444")
    LuaPanel.InitUI(self)

    PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
end

function BankPanel:UpdatePlayerInfo(context)
    print("更新玩家信息")
    if not context then return end
    local key=context[1]
    local newValue=context[2]

    if key=="iMoney" then
        SetNumberLabel(self.mLabel_CarryMoney,newValue)       
    end

end


--存钱界面的事件
--================================================================================================================================================================================
-- 存钱界面事件
function BankPanel:SaveMoneyInterface()
	self.mToggle_SaveMoney.value = true
	self.mObj_ChangePassword:SetActive(false);--//修改密码
    self.mObj_SaveMoney:SetActive(true);--//存钱
    self.mObj_DrawMoney:SetActive(false);--//取钱
    self.UISendRecordView:ShowOrHide(false,1)
    self.mInput_SaveMoney.value = "";
    self.mSlider_SaveMoney.value = 0;
    self.mToggle_SaveAll.value = false;
end


-- 存钱确认按钮事件
 function BankPanel:OnButton_SaveMoney()
    -- print("我点击了银行确认按钮")
    local strMoney = self.mInput_SaveMoney.value
    local lCarryMoney = PlayerInfoController:GetInstance().model.mainPlayer.iMoney -- 用户身上金钱数
    local lInputMoney = nil

    if strMoney == "" then
    	UIManager:GetInstance():ShowNoteMessage("Access_Balance_Null")
    	return
    end

    if tonumber(strMoney) ~= nil  then
    	lInputMoney = tonumber(strMoney)
        lInputMoney=HallGoldRateCToS(lInputMoney)
    	-- print(lInputMoney)
    	if lInputMoney > lCarryMoney then
    		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Money_Count_Out"))
            return 
    	elseif lInputMoney <= 0 then
    		UIManager:GetInstance():ShowNoteMessage("InfoInputError")
            return 
    	elseif lInputMoney <= lCarryMoney then
    		-- 调用接口 给服务器发信息
            local send = {}
            send.m_iSize = 0
            send.m_bCount = (lInputMoney) --发送客户端发送服务器的金钱要转换
            send.m_iUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
            send.m_iTime = os.time()
            send.m_sSourceAccountType = 2 --代表金币
            local md5 = CommonUtil.GenNewMd5SDyPasswd(CommonUtil.ReturnBankPsd(PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord), send.m_iTime, CommonUtil.mstate)
            send.m_szPassword = CommonUtil.StringToByteArrayTable(md5)
            for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
                if send.m_szPassword[i]==nil then
                    send.m_szPassword[i]=0
                end
            end
            -- print("send.m_szPassword: ", send.m_szPassword)
            Net_SendHallData(NetworkDefine.CReqSaveMoneyToBankMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_SAVE_MONEY, 0)
    		-- print("等待给服务器发送存钱协议", NetworkDefine.E_MSG_ID.MSG_ID_SAVE_MONEY)
            UIManager:GetInstance():ShowNetWorkMessage("In_Access",nil,2);
    	end
    else
        UIManager:GetInstance():ShowNoteMessage("Input_Format_Fault")
    end
end

--网络消息回调
function BankPanel:ReqGetMoneyToBank(msg)
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
    if msg.m_sResult == 0 then 
        if msg.m_iUin == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
            UIManager:GetInstance():ShowNoteMessage("Access_Money_Success")
            local vo={}
            vo.iMoney=msg.m_i64CoinBalance
            vo.iBank=msg.m_i64BankBalance
            PlayerInfoController:GetInstance().model.mainPlayer:UpdateVo(vo)
            self:SetPanelData()       
            self:BankSaveMoneyComplete()
        else
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Info_Wrong"))
            print("用户ID有误 :  "..msg.m_iUin) 
        end 
    else
        ServerBackPrompt(msg.m_sResult)
    end

end

function BankPanel:BankSaveMoneyComplete( ... )
    self.mInput_SaveMoney.value = "";
    self.mSlider_SaveMoney.value = 0;
    self.mToggle_SaveAll.value = false;
end

--================================================================================================================================================================================
--end

function BankPanel:OnButton_SaveAll( go )
    local toggle = go:GetComponent(typeof(UIToggle));
    if toggle.value then
        self.mInput_SaveMoney.value=HallGoldRateSToC(PlayerInfoController:GetInstance().model.mainPlayer.iMoney)
        self.mSlider_SaveMoney.value=1
    else
        self.mInput_SaveMoney.value="0"
        self.mSlider_SaveMoney.value=0
    end
end

function BankPanel:OnButton_DrawAll( go )
    local toggle = go:GetComponent(typeof(UIToggle));
    if toggle.value then
        self.mInput_DrawMoney.value=HallGoldRateSToC(PlayerInfoController:GetInstance().model.mainPlayer.iBank)
        self.mSlider_DrawMoney.value=1
    else
        self.mInput_DrawMoney.value="0"
        self.mSlider_DrawMoney.value=0
    end
end

function BankPanel:OnDragFinish_SaveProgress()
    local sliderVal = self.mSlider_SaveMoney.value;
    local moneyTotal = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
    local moneyVal = (moneyTotal*sliderVal)
    
    if sliderVal>=1 then
        moneyVal=moneyTotal
    end
    self.mInput_SaveMoney.value=HallGoldRateSToC(moneyVal)
end

function BankPanel:OnDragFinish_DrawProgress()
    local sliderVal = self.mSlider_DrawMoney.value;
    local moneyTotal = PlayerInfoController:GetInstance().model.mainPlayer.iBank
    local moneyVal = (moneyTotal*sliderVal);
    if sliderVal>=1 then
        moneyVal=moneyTotal
    end
    self.mInput_DrawMoney.value=HallGoldRateSToC(math.floor(moneyVal))
end

function BankPanel:OnDeSelectAction_SaveMoney()
    local moneyRatio = 0;
    local moneyVal = 0;
    local moneyTotal = PlayerInfoController:GetInstance().model.mainPlayer.iMoney
    local moneyValStr = self.mInput_SaveMoney.value
    if moneyValStr~="" and moneyValStr~=nil then
        moneyVal=tonumber(moneyValStr)
        moneyVal=HallGoldRateCToS(moneyVal)
        if moneyVal>moneyTotal then
            self.mSlider_SaveMoney.value=0
            self.mInput_SaveMoney.value=""
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Money_Count_Out"))
            return 
        end

        if moneyTotal~=0 then
            moneyRatio=moneyVal/moneyTotal
        else
            moneyRatio=0
        end
        moneyRatio=Mathf.Clamp01(moneyRatio)
        self.mSlider_SaveMoney.value=moneyRatio
    else
        self.mSlider_SaveMoney.value = 0;
        self.mInput_SaveMoney.value = "";
        UIManager:GetInstance():ShowNoteMessage("Input_Format_Fault")
    end
end

function BankPanel:OnDeSelectAction_DrawMoney()
    local moneyRatio = 0;
    local moneyVal = 0;
    local moneyTotal = PlayerInfoController:GetInstance().model.mainPlayer.iBank
    local moneyValStr = self.mInput_DrawMoney.value
    if moneyValStr~="" and moneyValStr~=nil then
        moneyVal=tonumber(moneyValStr)
        moneyVal=HallGoldRateCToS(moneyVal)
        if moneyVal>moneyTotal then
            self.mSlider_DrawMoney.value=0
            self.mInput_DrawMoney.value=""
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Money_Count_Out"))
            return 
        end

        if moneyTotal~=0 then
            moneyRatio=moneyVal/moneyTotal
        else
            moneyRatio=0
        end
        moneyRatio=Mathf.Clamp01(moneyRatio)
        self.mSlider_DrawMoney.value=moneyRatio
    else
        self.mSlider_DrawMoney.value = 0;
        self.mInput_DrawMoney.value = "";
        UIManager:GetInstance():ShowNoteMessage("Input_Format_Fault")
    end
end
--取钱界面的事件
--================================================================================================================================================================================
function BankPanel:DrawMoneyInterface()
	self.mToggle_DrawMoney.value = true
    self.mObj_ChangePassword:SetActive(false)--//修改密码
    self.mObj_SaveMoney:SetActive(false)--//存钱
    self.mObj_DrawMoney:SetActive(true)--//取钱
    self.mInput_DrawMoney.value = ""
    self.mSlider_DrawMoney.value = 0
    self.mToggle_DrawAll.value = false
    self.UISendRecordView:ShowOrHide(false,1)
end

function BankPanel:OnButton_DrawMoney()
    local strMoney = self.mInput_DrawMoney.value
    local lBankMoney = PlayerInfoController:GetInstance().model.mainPlayer.iBank -- 用户银行金钱数
    local lInputMoney = nil

    if strMoney == "" then
    	UIManager:GetInstance():ShowNoteMessage("Get_Balance_Null") --提现
    	return
    end

    if tonumber(strMoney) ~= nil  then
    	lInputMoney = tonumber(strMoney)
        lInputMoney=HallGoldRateCToS(lInputMoney)
    	-- print(lInputMoney)
    	if lInputMoney > lBankMoney then
    		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Input_Money_Count_Out"))
    	elseif lInputMoney <= 0 then
    		UIManager:GetInstance():ShowNoteMessage("InfoInputError")
    	elseif lInputMoney <= lBankMoney then
    		-- 调用接口 给服务器发信息
            local send = {}
            send.m_iSize = 0
            send.m_iUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
            send.m_bCount = (lInputMoney)--发送客户端发送服务器的金钱要转换
            send.m_sDstAccountType = 2 --代表金币
            send.m_iTime = os.time()
            local md5 = CommonUtil.GenNewMd5SDyPasswd(CommonUtil.ReturnBankPsd(PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord), send.m_iTime, CommonUtil.mstate)
            send.m_szPassword = CommonUtil.StringToByteArrayTable(md5)
            for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
                if send.m_szPassword[i]==nil then
                    send.m_szPassword[i]=0
                end
            end
            Net_SendHallData(NetworkDefine.CReqGetMoneyToBankMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_GET_MONEY, 0)
            UIManager:GetInstance():ShowNetWorkMessage("In_Access",nil,2);
    	end
    else
        UIManager:GetInstance():ShowNoteMessage("Input_Format_Fault")
    end
end

--网络消息回调
function BankPanel:HandleUserGetMoneyBack(msg)
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
    if msg.m_sResult == 0 then 
        if msg.m_iUin == PlayerInfoController:GetInstance().model.mainPlayer.uiUserID then
            UIManager:GetInstance():ShowNoteMessage("Successful_withdrawal")
            local vo={}
            vo.iMoney=msg.m_i64CoinBalance
            vo.iBank=msg.m_i64BankBalance
            PlayerInfoController:GetInstance().model.mainPlayer:UpdateVo(vo)
            self:SetPanelData()
            self:BankDrawMoneyComplete()
        else
            UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("User_Info_Wrong"))
            print("用户ID有误 :  "..msg.m_iUin) 
        end
    else
        ServerBackPrompt(msg.m_sResult)
    end
end

function BankPanel:BankDrawMoneyComplete()
    self.mInput_DrawMoney.value = "";
    self.mSlider_DrawMoney.value = 0;
    self.mToggle_DrawAll.value = false;
end

--================================================================================================================================================================================
--end

--修改密码界面的事件
--================================================================================================================================================================================

function BankPanel:ChangePasswordInterface()
	self.mToggle_ChangePassword.value = true;
    self.UISendRecordView:ShowOrHide(false,1)
    self.mObj_ChangePassword:SetActive(true);--//修改密码
    self.mObj_SaveMoney:SetActive(false);--//存钱
    self.mObj_DrawMoney:SetActive(false);--//取钱

    self.mInput_OldPassword.value = "";
    self.mInput_NewPassword.value = "";
    self.mInput_ConfirmPassword.value = "";
end

function BankPanel:OnButton_ModifyPsd()
	local strOldPass = TrimStr(self.mInput_OldPassword.value)
    local strNewPass = TrimStr(self.mInput_NewPassword.value)
    local strConfirmPass = TrimStr(self.mInput_ConfirmPassword.value)

    if strOldPass == "" then
    	UIManager:GetInstance():ShowNoteMessage("Old_password_cannot_empty")
    	return
    end

    if strNewPass == "" then
    	UIManager:GetInstance():ShowNoteMessage("New_Psd_Null")
    	return
    end

    if strConfirmPass == "" then
    	UIManager:GetInstance():ShowNoteMessage("password_blank")
    	return
    end

    if strConfirmPass ~= strNewPass then
    	UIManager:GetInstance():ShowNoteMessage("Inconsistent_passwords")
    	return
    end

    local psdLen = string.len(strConfirmPass)

    if psdLen < 6 or psdLen > 20 then   --总控设定的密码长度 测试用
    	UIManager:GetInstance():ShowNoteMessage("Pls_Input_6_20_Number")
    	return
    end

    -- 修改密码验证成功后 给服务器发送消息
    local send = {}
    send.m_iSize = 0
    send.m_iUin = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_sDstAccountType = 1 --账户类型：0支付,1是银行
    send.m_iTime = os.time()
    local md5 = CommonUtil.GenMd5SDyPasswd(send.m_iUin, send.m_iTime, strOldPass, CommonUtil.mstate)
    send.m_szOldPassword = CommonUtil.StringToByteArrayTable(md5)
    for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
        if send.m_szOldPassword[i]==nil then
            send.m_szOldPassword[i]=0
        end
    end
    local newMd5 = CommonUtil.GenMd5StaticPasswd(send.m_iUin, strConfirmPass, CommonUtil.mstate)
    send.m_szNewPassword = CommonUtil.StringToByteArrayTable(newMd5)
    for i=1,HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH do
        if send.m_szNewPassword[i]==nil then
            send.m_szNewPassword[i]=0
        end
    end
    local isHasPsd=PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord~=nil
    self.TempPsd=CommonUtil.KeepTempPsd(newMd5,isHasPsd,true)
    UIManager:GetInstance():ShowNetWorkMessage(StringFormatByLanguage("Updateing_Psd_Now"),StringFormatByLanguage("NetWorkOrrer"),2);
    Net_SendHallData(NetworkDefine.CReqSetPasswordMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_CHANGE_PASSWORD, 0)
end


--网络消息回调
function BankPanel:HandlerUserChangePassword(msg)
    if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
        UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    end
    if msg.m_sResult == 0 then
        UIManager:GetInstance():ShowNoteMessage("Modify_Psd_Success")
        PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord = self.TempPsd --保存缓存银行密码
        LuaEvent:DispatchEvent(EventName.REFRESHUSERDATA) --刷新用户数据 
        self:ModifyPsdComplete()
    else
        ServerBackPrompt(msg.m_sResult)
    end

end

--================================================================================================================================================================================
--end


--根据银行状态来决定显示页面
function BankPanel:SetPanelData()
	-- self:SetPanelUserData() --刷新用户数据
    local player=PlayerInfoController:GetInstance().model.mainPlayer
    self.mLabel_CarryMoney.text = NumberFormat(HallGoldRateSToC(player.iMoney))
    self.mLabel_BankMoney.text = NumberFormat(HallGoldRateSToC(player.iBank))
end

function BankPanel:ShowInterface()
    if self.mBankState==HallDefine.BankState.SaveMoney then
        self:SaveMoneyInterface()
        self.CarryMoneyObj:SetActive(true)
        self.Sprite_BG:SetActive(true)
         self.UISendGiveView:ShowOrHide(false)
        self.BankMoneyObj:SetActive(true)
        self.mObj_ChangePassword:SetActive(false)
    elseif self.mBankState==HallDefine.BankState.DrawMoney then
        self:DrawMoneyInterface()
        self.CarryMoneyObj:SetActive(true)
        self.Sprite_BG:SetActive(true)
        self.BankMoneyObj:SetActive(true)
         self.UISendGiveView:ShowOrHide(false)
         self.mObj_ChangePassword:SetActive(false)
    elseif self.mBankState==HallDefine.BankState.ChangePassword then
        self:ChangePasswordInterface()
        self.CarryMoneyObj:SetActive(true)
        self.BankMoneyObj:SetActive(true)
         self.Sprite_BG:SetActive(true)
          self.UISendGiveView:ShowOrHide(false)
    elseif self.mBankState==HallDefine.BankState.SendGive then
        self.UISendGiveView:ShowOrHide(true)
        self.mObj_SaveMoney:SetActive(false)
        self.mObj_DrawMoney:SetActive(false)
        self.UISendRecordView:ShowOrHide(false,1)
        self.CarryMoneyObj:SetActive(true)
        self.BankMoneyObj:SetActive(true)
         self.Sprite_BG:SetActive(true)
         self.mObj_ChangePassword:SetActive(false)

    elseif self.mBankState==HallDefine.BankState.SendGiveRecord then
        self.UISendRecordView:ShowOrHide(true,1)
        self.mObj_SaveMoney:SetActive(false)
        self.mObj_DrawMoney:SetActive(false)
        self.UISendGiveView:ShowOrHide(false)
        self.CarryMoneyObj:SetActive(false)
        self.BankMoneyObj:SetActive(false)
         self.Sprite_BG:SetActive(false)
         self.mObj_ChangePassword:SetActive(false)
    elseif self.mBankState==HallDefine.BankState.GetGiveRecord then
        self.UISendRecordView:ShowOrHide(true,2)
        self.mObj_SaveMoney:SetActive(false)
        self.mObj_DrawMoney:SetActive(false)
        self.UISendGiveView:ShowOrHide(false)
        self.CarryMoneyObj:SetActive(false)
        self.BankMoneyObj:SetActive(false)
         self.Sprite_BG:SetActive(false)
         self.mObj_ChangePassword:SetActive(false)
    end
end
--按钮响应事件
--================================================================================================================================================================================
function BankPanel:OnButton_SelectTitle(go)
   local mToggle=go:GetComponent(typeof(UIToggle))
   local currBankState=HallDefine.BankState.SaveMoney
   if mToggle==self.mToggle_SaveMoney then
        currBankState= HallDefine.BankState.SaveMoney
    elseif mToggle==self.mToggle_DrawMoney then
        currBankState= HallDefine.BankState.DrawMoney
    elseif mToggle==self.mToggle_ChangePassword then
        currBankState= HallDefine.BankState.ChangePassword
    elseif mToggle ==self.mToggle_SendGive then
        currBankState= HallDefine.BankState.SendGive
    elseif mToggle ==self.mToggle_SendGiveRecord then
        currBankState= HallDefine.BankState.SendGiveRecord
    elseif mToggle ==self.mToggle_GetGiveRecord then
        currBankState= HallDefine.BankState.GetGiveRecord
    end
    if currBankState~=self.mBankState then
        self.mBankState=currBankState
        self:ShowInterface()
    end
end

function BankPanel:clear( ... )
    self.UISendGiveView:clear()
end

--点击OnButtonClose按钮事件
function BankPanel:OnButtonClose( ... )
    self.mBankState = HallDefine.BankState.DrawMoney
    self:clear()
    UIManager:GetInstance():HidePanel(self.mPanelID)

    --SoundManager:GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_Bank)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
end
--================================================================================================================================================================================
--end

--刷新用户界面显示信息
function BankPanel:SetPanelUserData( )
   self:SetPanelData()
end


--外部调用银行显示页面
function BankPanel:SelectShowThePanel(showstate)
    if self.mBankState~=showstate then
        if showstate == HallDefine.BankState.SaveMoney then
            self.mToggle_SaveMoney.value = true
            self.mToggle_DrawMoney.value = false
            self.mToggle_ChangePassword.value = false
            self.mBankState = HallDefine.BankState.SaveMoney
        elseif showstate == HallDefine.BankState.DrawMoney then 
            self.mToggle_SaveMoney.value = false
            self.mToggle_DrawMoney.value = true
            self.mToggle_ChangePassword.value = false
            self.mBankState = HallDefine.BankState.DrawMoney
        elseif showstate == HallDefine.BankState.ChangePassword then
            self.mToggle_SaveMoney.value = false
            self.mToggle_DrawMoney.value = false
            self.mToggle_ChangePassword.value = true
            self.mBankState = HallDefine.BankState.ChangePassword
        end
        self.mBankState=showstate
        self:SetPanelData()
    end
    
end

function BankPanel:ModifyPsdComplete( ... )
    self.mInput_OldPassword.value = ""
    self.mInput_NewPassword.value = ""
    self.mInput_ConfirmPassword.value = ""
end

function BankPanel:SetChangePasswordVaule( ... )
    self.mInput_OldPassword.value = ""
    self.mInput_NewPassword.value = ""
    self.mInput_ConfirmPassword.value = ""
end

--复写父类 showpanel 方法
function BankPanel:ShowPanel(callBack)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self, callBack) --优先调用父类方法	
    self:SetPanelData() --刷新用户数据界面
	self:ShowInterface() --开启对应界面
    self:PlayOpenAni()
   -- SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.music_Bank)
end


function BankPanel:PlayOpenAni( ... )
    -- body
    self.TweenAn.enabled=true
    self.TweenAn:ResetToBeginning()
    self.TweenAn:PlayForward()
end

function BankPanel:__delete( )
	self.mBankState = nil
	self.mLabel_CarryMoneyName = nil
	self.mLabel_BankMoneyName = nil
	self.mLabel_CarryMoney = nil
	self.mLabel_BankMoney = nil
	self.mToggle_SaveMoney = nil
	self.mToggle_DrawMoney = nil
	self.mToggle_ChangePassword = nil
	self.mButton_All = nil
	self.mButton_50Percent = nil
	self.mButton_20Percent = nil
	self.mButton_10Percent = nil
	self.mLabel_50Percent = nil
	self.mLabel_20Percent = nil
	self.mLabel_10Percent = nil
	self.mButton_Confirm = nil
	self.mButton_Colse = nil
	self.mObj_SaveAndDrawMoney = nil
	self.mObj_ChangePassword = nil
	self.mLabel_LabelTips = nil
	self.mInput_Money = nil
	self.mInput_OldPasswordName = nil
	self.mInput_NewPasswordName = nil
	self.mInput_ConfirmPasswordName = nil
	self.mInput_OldPassword = nil
	self.mInput_NewPassword = nil
	self.mInput_ConfirmPassword = nil
	self.strSaveMoneyTipValue = nil
	self.strDrawMoneyTipValue = nil
	self.l50PercentValue = nil
    self.l20PercentValue = nil
    self.l10PercentValue = nil
    self.SetNewPassword = nil --设置后的新静态密码

end