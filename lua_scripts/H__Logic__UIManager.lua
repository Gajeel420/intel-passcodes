UIManager = UIManager or BaseClass(InnerEvent)

function UIManager:__init()
	self.mShowUIPanel = {}
	self.mAllUIPanel = {}

	self:AddEvent()
end
--uiPanelCtrl Panel控制器
--显示面板
function UIManager:ShowPanel( panelID,callBack,isPlayTween )
	self:ReadUIPanel(panelID,function (uiPanelCtrl,pId)
							if uiPanelCtrl == nil then
									return nil 
								end
								self.mShowUIPanel[pId] = uiPanelCtrl
								uiPanelCtrl.view:ShowPanel(callBack,isPlayTween)
 
								self:DispatchEvent(UIManager.EventType.UIChange,uiPanelCtrl.view.panel.mPanelType,UIManager.UIState.Open)
							end
	)
end

function UIManager:ReadUIPanel(panelID,callBack)
	local uiPanelTemp = nil

	uiPanelTemp =  self.mAllUIPanel[panelID]
	if uiPanelTemp == nil then
		--创建生成panel

		GameConstDefine.PanelCtrl[panelID]:GetInstance().view:CreatePanel(function (pId)
			self.mAllUIPanel[pId] = GameConstDefine.PanelCtrl[pId]:GetInstance()
			uiPanelTemp = self.mAllUIPanel[pId]
			if uiPanelTemp ~=nil then
				self:SetPanelDepth(uiPanelTemp)
			end
			pcall(callBack,uiPanelTemp,pId)
			return
		end)
	else
		self:SetPanelDepth(uiPanelTemp)
		pcall(callBack,uiPanelTemp,panelID)
	end
end

function UIManager:PreLoadUIPanel(panelID,callBack)
	local uiPanelTemp = nil
	uiPanelTemp =  self.mAllUIPanel[panelID]
	if uiPanelTemp == nil then
		--创建生成panel
		GameConstDefine.PanelCtrl[panelID]:GetInstance().view:CreatePanel(function (pId)
			self.mAllUIPanel[pId] = GameConstDefine.PanelCtrl[pId]:GetInstance()
			uiPanelTemp = self.mAllUIPanel[pId]
			pcall(callBack,uiPanelTemp)
		end)
	else
		pcall(callBack,uiPanelTemp)
	end
end

--隐藏面板
function UIManager:HidePanel(panelID,callBack,...)
	if self:IsShowPanel(panelID) == true then
		local uiPanelCtrl = self.mShowUIPanel[panelID]
		uiPanelCtrl.view:HidePanel(callBack,...)
		self.mShowUIPanel[panelID] = nil
		self:DispatchEvent(UIManager.EventType.UIChange,uiPanelCtrl.view.panel.mPanelType,UIManager.UIState.Close)
		if callBack then
			callBack()
		end
	else
		if callBack then
			callBack()
		end
	end
	
end

function UIManager:SetPanelDepth( uiPanelCtrl )
	if uiPanelCtrl == nil then print("SetPanelDepth:uiPanelCtrl is nil") return end
	local depth = self:GetPanelMaxDepth(uiPanelCtrl)
	uiPanelCtrl.view.panel:SetPanelDepth(depth + 10)
end

function UIManager:GetPanelMaxDepth( uiPanelCtrl )
	local depth = 0
	local depthTemp = 0
	local isExist = false
	if	self.mShowUIPanel ~=nil then
		for _,ctrl in pairs(self.mShowUIPanel) do
			if ctrl.view ~=nil and ctrl.view.panel and ctrl.view.panel.isInited then
				if ctrl.view.panel.mPanelType == uiPanelCtrl.view.panel.mPanelType and ctrl ~= uiPanelCtrl then
					isExist = true
					depthTemp = ctrl.view.panel:GetPanelDepth()
					if depthTemp>depth then
						depth = depthTemp
					end
				end
			end
		end
	end

	local uiPanel = uiPanelCtrl.view.panel
	local startDepth = 0
	if uiPanel.mPanelType == UIPanelDefine.PanelType.Normal then
		startDepth = UIPanelDefine.NormalPanelStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.HallGame then
        startDepth = UIPanelDefine.HallGamePanelStart
    elseif uiPanel.mPanelType == UIPanelDefine.PanelType.NormalTop then
		startDepth = UIPanelDefine.NormalTopPanelStart
    elseif uiPanel.mPanelType == UIPanelDefine.PanelType.SecondLevel  then
		startDepth = UIPanelDefine.SecondLevelPanelStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.FullScreenSecondLevel then
		startDepth = UIPanelDefine.FullScreenSecondLevelPanelStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.TopPnael then
		startDepth = UIPanelDefine.TopPanelStart
    elseif uiPanel.mPanelType == UIPanelDefine.PanelType.Prompt then
		startDepth = UIPanelDefine.PromptPanelStart
    elseif uiPanel.mPanelType == UIPanelDefine.PanelType.Notify then
		startDepth = UIPanelDefine.NotifyPanelStart
    elseif uiPanel.mPanelType == UIPanelDefine.PanelType.WindowLoading then
		startDepth = UIPanelDefine.WindowLoadingStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.ThirdLevel then
		startDepth = UIPanelDefine.ThreeLevelPanelStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.FourLevel then
		startDepth = UIPanelDefine.FourLevelPanelStart
	elseif uiPanel.mPanelType == UIPanelDefine.PanelType.SelectBox then
		startDepth = UIPanelDefine.SelectBoxPanelStart
    end
	if isExist == false then
        depth = depth+startDepth
	end
    return depth
end

-- 隐藏所有的panel
function UIManager:HidePanelAll(...)
	if self.mAllUIPanel~=nil then
		for paneId,v in pairs(self.mAllUIPanel) do
			if paneId ~= UIPanelDefine.EWndID.HallSignalStrength then
				self:HidePanel(paneId,nil,...)
			end
		end
	end
end

function UIManager:IsShowPanel( panelID )
	if self.mShowUIPanel ~= nil then
		for k,v in pairs(self.mShowUIPanel) do
			if k == panelID and v~=nil then
				return true
			end
		end
	end
	return false
end

function UIManager:DestroyAllPanel()
	if self.mAllUIPanel then
		local destroyList={}
		for k,uiPanelCtrl in pairs(self.mAllUIPanel) do
			if uiPanelCtrl.view:IsPanelDestroy() then
				table.insert(destroyList,k)
			end
		end
		for k,v in pairs(destroyList) do
			self:DestroyPanelByID(v)
		end
	end
end
function UIManager:DestroyPanelByID(panelID)
	local tmpPanel=self.mAllUIPanel[panelID]
	if tmpPanel then
		tmpPanel.view:OnDestroyPanel()
		self.mAllUIPanel[panelID]=nil
		if self.mShowUIPanel[panelID] then
			self.mShowUIPanel[panelID]=nil
		end
	end
end
function UIManager:GetInstance()
	if UIManager.instance == nil then
		UIManager.instance = UIManager.New()
	end
	return UIManager.instance
end

function UIManager:__delete()
	
end





function UIManager:ShowNetWorkMessage(msg,noteMessage,showingTime,action)
	if not self:IsShowPanel(UIPanelDefine.EWndID.NetWorkMsg) then
		self:ShowPanel(UIPanelDefine.EWndID.NetWorkMsg,function( ... )
			HallNetWorkMsgController:GetInstance():ShowNotMsg(msg,noteMessage,showingTime,action)
		end)
	else
		HallNetWorkMsgController:GetInstance():ShowNotMsg(msg,noteMessage,showingTime,action)
	end

end

--供其他Panel调用ShowNoteMessagePanel 的接口
function UIManager:ShowNoteMessage(msg, showingTime, isCenter,isForce)
	local cb = function ()
		HallNoteMsgController:GetInstance():ShowNotMsg(msg,showingTime,isCenter,isForce)
	end
	self:ShowPanel(UIPanelDefine.EWndID.NoteMsg, cb)
end

--供其他Panel调用打开银行的接口 check 是否检查是否有银行密码, 执行的回调函数
function UIManager:OpenHallBankPanel()
	
	if PlayerInfoController:GetInstance().model.mainPlayer.isSetPasswordFlag == true then --设置银行密码
        if not PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord then
            self:ShowPanel(UIPanelDefine.EWndID.HallBankPassword)
        else
            self:ShowPanel(UIPanelDefine.EWndID.Bank)
        end
    else
        self:ShowPanel(UIPanelDefine.EWndID.HallBankSetPassword)
	end
end

--其他panel检查银行密码状态设置后的回调 callback = 回调函数
function UIManager:CheckHallBankPassword( callBack )
	if PlayerInfoController:GetInstance().model.mainPlayer.isSetPasswordFlag == true then --设置银行密码
		if not PlayerInfoController:GetInstance().model.mainPlayer.szBankPassWord then
			local cb = function ( )
				HallBankPasswordController:GetInstance():SetCheckUpCallBack(callBack)
			end
            self:ShowPanel(UIPanelDefine.EWndID.HallBankPassword, cb)
        else
            pcall(callBack)
        end
	else
		local cb = function ( )
				HallBankSetPasswordController:GetInstance():SetCheckUpCallBack(callBack)
		end
		self:ShowPanel(UIPanelDefine.EWndID.HallBankSetPassword, cb)
	end
end

--通用提示框
function UIManager:ShowMessageBox(showData)
	local cb = function ()
		HallShowMsgBoxController:GetInstance():ShowMessage(showData)
	end
	self:ShowPanel(UIPanelDefine.EWndID.MessageBox, cb)
end

--通用弹窗
function UIManager:ShowCommonPromptPanel(showData)
	local cb = function ()
		CommonPromptController:GetInstance():ShowCommonPrompt(showData)
	end
	self:ShowPanel(UIPanelDefine.EWndID.CommonPrompt, cb)
end

--金币游戏加载界面
function UIManager:ShowLoadGlodPanel(gameID,callback)
	local cb = function()
		GameLoadController:GetInstance():SetBG(gameID)
		if callback then
			callback()
		end
	end
	self:ShowPanel(UIPanelDefine.EWndID.GameLoad, cb)
end

function UIManager:Back()
	local  scene = SceneManager:GetInstance():GetCurrentSceneState()

	if(scene == SceneManager.SceneType.Game) then return end

	if scene == SceneManager.SceneType.Login then
		local showBoxData ={}
        showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
        showBoxData.context = StringFormatByLanguage("Tip_QuitGame")--"你确定要离开游戏吗？"--内容；
        showBoxData.enterCB = function()
        	Application.Quit()
        end--：点击确定返回；

        showBoxData.cancelCB = function()
        	
         end--：点击取消返回，
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮;
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
		return
	end

	if scene == SceneManager.SceneType.Room then
		HallRoomPanelController.GetInstance().view.panel.IsDestroyGameResource = true
		SceneManager:GetInstance():ChangeSceneToType(SceneManager.SceneType.Hall)
		return
	end

	local promptList = {}
	local secondList = {}
	local FullSecondList={}

	local pType 

	for panelID,panelCtl in pairs(self.mShowUIPanel) do
		if(panelID == UIPanelDefine.EWndID.NetWorkMsg) then return end --遇到网络提示存在就返回
		
		if panelID == UIPanelDefine.EWndID.HallWithdraw then
			panelCtl.view.panel:SystemBack()
			return
		end

		if panelID == UIPanelDefine.EWndID.HallTurntable then
			if not HallTurntableController:GetInstance().view.panel.CanClose then
				return 
			end
		end
		
		pType = panelCtl.view.panel.mPanelType
		if(pType == UIPanelDefine.PanelType.Prompt) then
			if(panelID == UIPanelDefine.EWndID.MessageBox or panelID == UIPanelDefine.EWndID.CommonPrompt) then
				if(not NetworkMgr:IsConnect()) then --网络断开时候断线重连提示
					return
				else
					promptList[#promptList + 1] = panelID
				end
			end
		elseif(pType == UIPanelDefine.PanelType.SecondLevel) then
			secondList[#secondList + 1] = panelID
		elseif(pType == UIPanelDefine.PanelType.FullScreenSecondLevel) then
			table.insert(FullSecondList,panelID)
		end
	end

	if(#promptList > 0) then
		self:HidePanel(promptList[#promptList])
	elseif(#secondList > 0) then
		self:HidePanel(secondList[#secondList])
	elseif(#FullSecondList > 0) then
		self:HidePanel(FullSecondList[#FullSecondList])
	else
		SceneManager.GetInstance():Back()
	end

	
	

end

function UIManager:AddEvent( ... )
	LuaEvent:AddEventListener(EventName.CSTOLUA_HIDEPANEL,self.CSToLuaHidePanel,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_SHOWNETWORK,self.CSTOLUA_ShowNetworkMessage,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_SURENOTE,self.CSToLuaMassage,self) --通用确认弹窗
	LuaEvent:AddEventListener(EventName.CSTOLUA_NOTEMESSAGE,self.CSToLuaShowNotMsg,self)--通用提示
	LuaEvent:AddEventListener(EventName.CSTOLUA_OPENSTORE,self.CSToLuaOpenStore,self)--打开商城
end

function UIManager:CSToLuaHidePanel( context )
	if context and context.m_data then
		local strContext=context.m_data[0]
		UIManager:GetInstance():HidePanel(strContext)
	end
end

function UIManager:CSTOLUA_ShowNetworkMessage(context)
	if context and context.m_data then
		--msg,noteMessage,showingTime,action

		local msg=context.m_data[0]
		local noteMessage=context.m_data[1]
		local showingTime=context.m_data[2]

		UIManager:GetInstance():ShowNetWorkMessage(msg,noteMessage,showingTime,nil)
	end
end

function UIManager:CSToLuaMassage( context )
	if context and context.m_data then
		local strTitle=context.m_data[0]
		local strContext=context.m_data[1]
		local actionYes=context.m_data[2]
		local showBoxData ={}
        showBoxData.title = strTitle--:标签，
        showBoxData.context = strContext--内容；
        showBoxData.enterCB = function() 
           actionYes()
        end--：点击确定返回；
        showBoxData.cancelCB = function() self:HidePanel(UIPanelDefine.EWndID.MessageBox) end--：点击取消返回，
        showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
        showBoxData.isHideAll = false--:隐藏所有按钮; 
        showBoxData.isShowBtnClose = false--:界面的关闭按钮
		UIManager:GetInstance():ShowMessageBox(showBoxData)
	end
end

function UIManager:CSToLuaShowNotMsg( context )
	if context and context.m_data then
		local strContext=context.m_data[0] or ""
		local fTime=context.m_data[1] or 1
		UIManager:GetInstance():ShowNoteMessage(strContext, fTime)
	end
end

function UIManager:CSToLuaOpenStore( context)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallStore)
end







----------------------------------------------NEW--------------------------------------------------------------------

UIManager.EventType={
	UIChange="UIManager.EventType.UIChange",
}


UIManager.UIState={
	Open="UIManager.UIState.Open",
	Close="UIManager.UIState.Close",
}


----------------------------------------------NEW--------------------------------------------------------------------
