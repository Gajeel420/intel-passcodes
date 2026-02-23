LoginPanel = LoginPanel or BaseClass(LuaPanel)

function LoginPanel:__init(callBack)
    self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.Login].name
    self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.Login].path  --资源路径
    self.mPanelID = UIPanelDefine.EWndID.Login
    self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
    self.createPanelCallBack = self.InitUI----必须实现
    self.callBack = callBack----必须实现
    self:CreatePanel(0)----必须实现
end

--初始化ui界面
function LoginPanel:InitUI()
    local mTran = self.obj.transform
    local mTranUI = mTran:Find("Content/LoginType/LoginTypes/Button_WeiXing")
    if mTranUI~=nil then
        self.mButton_WeiXin = mTranUI.gameObject
         UIEventListener.Get(self.mButton_WeiXin).onClick = LoginPanel.OnButton_WeXin
    end
    mTranUI = mTran:Find("Content/LoginType/LoginTypes/Buton_Account")
    if mTranUI ~= nil then
        self.mButton_Account = mTranUI.gameObject
        UIEventListener.Get(self.mButton_Account).onClick = LoginPanel.OnButton_Account
        self.mButton_Account:SetActive(false)
    end
    --Facebook登录
    mTranUI = mTran:Find("Content/LoginType/LoginTypes/Buton_Facebook")
    if mTranUI ~= nil then
        self.mButton_Facebook = mTranUI.gameObject
        UIEventListener.Get(self.mButton_Facebook).onClick = LoginPanel.OnButton_Facebook
        self.mButton_Facebook:SetActive(false)
    end

    mTranUI = mTran:Find("Content/LoginType/LoginTypes/Button_Guest")
    if mTranUI ~= nil then
        self.mButton_Quick = mTranUI.gameObject
        UIEventListener.Get(self.mButton_Quick).onClick = function() self:OnButton_Guest() end
    end

    mTranUI = mTran:Find("Content/KeFuBtn")
    if mTranUI ~= nil then
        self.mObj_ServiceButton = mTranUI.gameObject
        UIEventListener.Get(self.mObj_ServiceButton).onClick = function() self:OnClickServiceButton() end
    end

    mTranUI = mTran:Find("Content/AutoRepair")
    if mTranUI ~= nil then
        self.mObj_AutoRepair = mTranUI.gameObject
        UIEventListener.Get(self.mObj_AutoRepair).onClick = function() self:OnButtonAutoRepair() end
    end

    mTranUI = mTran:Find("Content/AppVersion")
    if mTranUI~= nil then 
        if ConfigInfoMgr.ResourceVersion == nil then
            mTranUI.gameObject:GetComponent(typeof(UILabel)).text = StringFormat("APP版本号：v1.0.0.{0}",PhoneManager:GetApplicationVersion()) 
        else
            mTranUI.gameObject:GetComponent(typeof(UILabel)).text = StringFormat("APP版本号：v1.0.0.{0}       资源版本号：v1.0.0.{1}",PhoneManager:GetApplicationVersion(),ConfigInfoMgr.ResourceVersion)
        end
    end
    
    self:UIFuncitionSwitch()
    LuaPanel.InitUI(self)
end

--根据配置显示UI
function LoginPanel:UIFuncitionSwitch( )
    if self.mButton_Quick then self.mButton_Quick:SetActive(ConfigModuleModel.GetInstance().IsEnableGuest or false) end
    if self.mButton_WeiXin then self.mButton_WeiXin:SetActive(ConfigModuleModel.GetInstance().IsEnableWeiXin or false) end
    if self.mButton_Account then self.mButton_Account:SetActive(ConfigModuleModel.GetInstance().IsEnableAccount or false) end
    if self.mButton_Facebook then self.mButton_Facebook:SetActive(ConfigModuleModel.GetInstance().IsOpenFacebookLogin or false) end
end

--复写父类 showpanel 方法
function LoginPanel:ShowPanel(callBack)
    LuaPanel.ShowPanel(self, callBack) --优先调用父类方法
    --LoginPanelModel:GetInstance():AutoLogin() 
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallAccountLogin) 
end

--按钮响应
-- =============================================================================================================

function LoginPanel:OnClickServiceButton(  )
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallService)
end

function LoginPanel:OnButtonAutoRepair(  )
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    
    local showBoxData ={}
    showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
    showBoxData.context ="修复完成，点击确定将退出游戏，请在退出后重启"--内容；
    showBoxData.enterCB = function()
        local dirPath = StringFormat("{0}", PathDefine.AssetBundlePath())
        print("删除文件夹路径:",dirPath)
        if Directory.Exists(dirPath) then
            Directory.Delete(dirPath,true)
        end
        Application.Quit()
    end--：点击确定返回；

    showBoxData.cancelCB = nil
    showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
    showBoxData.isHideAll = false--:隐藏所有按钮;
    showBoxData.isShowBtnClose = false--:界面的关闭按钮
    UIManager:GetInstance():ShowMessageBox(showBoxData)
end


function LoginPanel:OnButton_WeXin( ... )
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    if ConfigInfoMgr.LoginFailTips ~= "" then
        local showData={}
		local showBoxData ={}
        showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
        showBoxData.context = ConfigInfoMgr.LoginFailTips--内容；
        showBoxData.enterCB = function()
        	
        end--：点击确定返回；

        showBoxData.cancelCB = function()
        	Application.Quit()
         end--：点击取消返回，
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮;
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
        return 
    end
    LoginPanelModel:GetInstance():WechatLogin()
end

function LoginPanel:OnButton_Account( )
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    if ConfigInfoMgr.LoginFailTips ~= "" then
        local showData={}
		local showBoxData ={}
        showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
        showBoxData.context = ConfigInfoMgr.LoginFailTips--内容；
        showBoxData.enterCB = function()
        	
        end--：点击确定返回；

        showBoxData.cancelCB = function()
        	Application.Quit()
         end--：点击取消返回，
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；   
        showBoxData.isHideAll = false--:隐藏所有按钮;
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
        return 
    end
	
    UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallAccountLogin) 
end

--调用Facebook 登录
function LoginPanel:OnButton_Facebook()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
    LoginPanelModel:GetInstance():FacebookLogin()
end

function LoginPanel:OnButton_Guest()
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    if ConfigInfoMgr.LoginFailTips ~= "" then
        local showData={}
		local showBoxData ={}
        showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
        showBoxData.context = ConfigInfoMgr.LoginFailTips--内容；
        showBoxData.enterCB = function()
        	
        end--：点击确定返回；

        showBoxData.cancelCB = function()
        	Application.Quit()
         end--：点击取消返回，
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮;
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
        return 
    end
    LoginPanelModel:GetInstance():GuestLogin()
end


-- ===============================================================================================================

function LoginPanel:__delete( )
    self.mButton_WeiXin = nil
    self.mButton_QQ = nil
    self.mButton_Account = nil
    self.mButton_Quick = nil
    self.mButton_Service = nil
end