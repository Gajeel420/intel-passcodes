SceneManager = SceneManager or BaseClass()

SceneManager.SceneType = {
	Login = 1, --登录场景
	Hall = 2,	--大厅场景
	Game = 3,	--游戏场景
	Room=4,		--房间场景
	Main=5,		--初始场景
}

function SceneManager:__init( ... )
	self.mSceneType = SceneManager.SceneType.Main
	self.mOldSceneType=SceneManager.SceneType.Main
	self.mTabel_SceneChangeFunctionTabel={}
	self:InitChangeFunction()
	LuaEvent:AddEventListener(EventName.PRELOADER_COMPLETED,self.PreLoadToLoginScene,self)
end 

function SceneManager:__delete( ... )

end

function SceneManager:GetInstance()
	if SceneManager.instance == nil then
		SceneManager.instance = SceneManager.New()
	end
	return SceneManager.instance
end




------------------------------------------------公有函数---------------------------------------------

--只能通过此接口切换场景
function SceneManager:ChangeSceneToType(sceneType,...)
	local oldType=self.mSceneType
	local newType=sceneType
	local changeFunction= self:mGetSceneChangeFunction(oldType,newType)
	if changeFunction then
		changeFunction(...)
		self:mChangeSceneState(newType)
	end

end

--全局返回事件回调
function SceneManager:OnClickEscapeBack( ... )
	UIManager.GetInstance():Back()
end

--场景对全局返回事件的处理函数
function SceneManager:Back( ... )
	if self.mSceneType==SceneManager.SceneType.Hall then
		self:HallSceneBack()
	elseif self.mSceneType==SceneManager.SceneType.Room then
		self:ChangeSceneToType(SceneManager.SceneType.Hall)
	elseif self.mSceneType==SceneManager.SceneType.Login then
		--询问是否退出游戏
	end
	
end



--获取当前场景状态
function SceneManager:GetCurrentSceneState()
	return self.mSceneType 
end


--获取上一个场景状态
function SceneManager:GetLastSceneState()
	return self.mOldSceneType
end






function SceneManager:SetCurrentScreenOrientation(mScreenOrientationType)
	self.CurrentScreenOrientationType = mScreenOrientationType
end

--旋转屏幕
function SceneManager:SetScreenOrientation()
	if SceneManager.GetInstance().CurrentScreenOrientationType==SceneManager.ScreenOrientationType.Protrait or screenOrientationType==SceneManager.ScreenOrientationType.AutoProtrait then
		Screen.orientation = ScreenOrientation.Portrait

		if SceneManager.GetInstance().CurrentScreenOrientationType==SceneManager.ScreenOrientationType.AutoProtrait then
			Screen.autorotateToPortrait = true
			Screen.autorotateToPortraitUpsideDown = true
			Screen.autorotateToLandscapeLeft = false
			Screen.autorotateToLandscapeRight = false
			Screen.orientation = ScreenOrientation.AutoRotation
		end

	elseif SceneManager.GetInstance().CurrentScreenOrientationType==SceneManager.ScreenOrientationType.Landscape or screenOrientationType==SceneManager.ScreenOrientationType.AutoLandscape then 
		if CS.UnityEngine.Application.platform ~= CS.UnityEngine.RuntimePlatform.Android then
			Screen.orientation = ScreenOrientation.LandscapeRight
		else
			Screen.orientation = ScreenOrientation.Landscape
		end

		if SceneManager.GetInstance().CurrentScreenOrientationType==SceneManager.ScreenOrientationType.AutoLandscape then
			Screen.autorotateToPortrait = false
			Screen.autorotateToPortraitUpsideDown = false
			Screen.autorotateToLandscapeLeft = true
			Screen.autorotateToLandscapeRight = true
			Screen.orientation = ScreenOrientation.AutoRotation
		end
	end
end

 
SceneManager.ScreenOrientationType={
	Protrait=1,--竖屏
	AutoProtrait=2,--可以旋转方向的竖屏
	Landscape=3,--横屏
	AutoLandscape=4,--可以旋转方向的横屏
}



------------------------------------------------公有函数---------------------------------------------





-----------------------------私有函数-----------------------------------------
--預加載結束监听函数
function SceneManager:PreLoadToLoginScene()
	LuaEvent:AddEventListener(EventName.KEYCODE_ESCAPE,self.OnClickEscapeBack,self) 
end
--初始化注册所有场景切换调用的函数
function SceneManager:InitChangeFunction()
	self:AddSceneChangeFunction(SceneManager.SceneType.Main,SceneManager.SceneType.Login,self.mMainToLogin)
	self:AddSceneChangeFunction(SceneManager.SceneType.Login,SceneManager.SceneType.Hall,self.mLoginToHall)
	self:AddSceneChangeFunction(SceneManager.SceneType.Hall,SceneManager.SceneType.Login,self.mHallToLogin)
	self:AddSceneChangeFunction(SceneManager.SceneType.Hall,SceneManager.SceneType.Room,self.mHallToRoom)
	self:AddSceneChangeFunction(SceneManager.SceneType.Hall,SceneManager.SceneType.Game,self.mHallToGame)
	self:AddSceneChangeFunction(SceneManager.SceneType.Room,SceneManager.SceneType.Hall,self.mRoomToHall)
	self:AddSceneChangeFunction(SceneManager.SceneType.Room,SceneManager.SceneType.Game,self.mRoomToGame)
	self:AddSceneChangeFunction(SceneManager.SceneType.Game,SceneManager.SceneType.Hall,self.mGameToHall)
	self:AddSceneChangeFunction(SceneManager.SceneType.Game,SceneManager.SceneType.Room,self.mGameToRoom)
	self:AddSceneChangeFunction(SceneManager.SceneType.Game,SceneManager.SceneType.Login,self.mGameToLogin)

end



--绑定场景切换调用的函数
function SceneManager:AddSceneChangeFunction(currentSceneType,nextSceneType,changeFunction)
	if self.mTabel_SceneChangeFunctionTabel[currentSceneType]==nil then
		self.mTabel_SceneChangeFunctionTabel[currentSceneType]={}
	end
	self.mTabel_SceneChangeFunctionTabel[currentSceneType][nextSceneType]=changeFunction
end

--获取切换场景调用的函数
function SceneManager:mGetSceneChangeFunction(currentSceneType,nextSceneType)
	if self.mTabel_SceneChangeFunctionTabel[currentSceneType]==nil or self.mTabel_SceneChangeFunctionTabel[currentSceneType][nextSceneType]==nil then
		return nil
	end

	local changeFunciton=function (...)
		self.mTabel_SceneChangeFunctionTabel[currentSceneType][nextSceneType](self,...)
	end

	return changeFunciton
end


--初始状态到登录
function SceneManager:mMainToLogin()
	--预加载UI
	PreloadManager:GetInstance():PreLoadRes(function( ... )
		-- 预加载完成
		print("aaaaaaaaaaaaaa55555555555555555555   ",Time.realtimeSinceStartup)
		LuaEvent:DispatchEvent(EventName.PRELOADER_COMPLETED) 
		LuaEvent:DispatchEvent(EventName.LOADER_ALL_COMPLETED) 
		HeartManager:GetInstance()
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginBG)
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Login)
		-- if not SoundManager:GetInstance():GetIsFindSoundManager() then
		-- end
	end)
end



--登录到大厅
function SceneManager:mLoginToHall()
	SoundManager:GetInstance():PrePlayBGMusic(0,SoundManager.BGSoundID.BGM_Hall)
	UIManager:GetInstance():HidePanelAll()--隐藏所有窗口
	LuaEvent:DispatchEvent(EventName.GameSceneNoNotifyMove,0,-80)
	RoomController.GetInstance().CanRequest = true
	--进入主界面
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)
	--初始化玩家收藏游戏的数据
	HallGameModel:GetInstance():InitPlayerLoveGameData()
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGame)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGroup)
	UIManager.GetInstance():DestroyPanelByID(UIPanelDefine.EWndID.Login)
	UIManager.GetInstance():DestroyPanelByID(UIPanelDefine.EWndID.LoginBG)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallSignalStrength)
	GameDownloadModel.GetInstance():StartAutoDownLoadGame()

	self:HandleFirstLoginTip()
end

--处理首次登陆提示
function SceneManager:HandleFirstLoginTip()
	-- ActivityModuleController:GetInstance():AddActivityEvent(function ()
	-- 	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallAlert)
	-- end)

	if PlayerInfoController:GetInstance().model.mainPlayer.isSetPasswordFlag == false then --设置银行密码
		ActivityModuleController:GetInstance():AddActivityEvent(function ()
			-- 强制修改密码
			UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallModifyPassword,function (panel)
				panel:SetCloseBtnView(false)
			end)
		end)
	end

	-- 新手引导界面
	if HallGuideController:GetInstance():GetIsHasGuideGame() == false then
		ActivityModuleController:GetInstance():AddActivityEvent(function ()
			UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGuide)
			HallGuideController:GetInstance():SetIsHasGuideGame()
		end)
	end

	ActivityModuleController:GetInstance():AddActivityEvent(function ()
		--打码返利
		print("-----------------打码返利  ")
		HallCashBackModel:GetInstance():SetClameState(true)
		ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_BetRebate)
	end)

	-- 请求活动信息
	ActivityModuleController:GetInstance():AddActivityEvent(function ()
		ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus)

		RenderMgr.AddInterval(function()
			-- 请求是否有参与的活动
			local send = {}
			send.type = 1
			ActivityModuleController:GetInstance():CActivityOperateReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_WagerBonus, send)
		end,"SceneManager:CActivityOperateReq", 0.5, 0.6)
	end)

	

	ConfigModuleModel:GetInstance():ClientCommonConfig(function()
		if ConfigModuleModel:GetInstance().adPopStatus then
			ActivityModuleController:GetInstance():AddActivityEvent(function ()
				HallAdPopModel:GetInstance():GetAd()
				PrintLog("event弹窗功能---------------")
			end)
			
		end

		-- FortuneCookie 活动
		ActivityModuleController:GetInstance():AddActivityEvent(function ()
			ActivityModuleController:GetInstance():CGetActivityConfigReq(NetworkDefine.ACTIVITY_ID.E_ACTIVITY_ID_FortuneCookie)
		end)
	end)

	-- ActivityModuleController:GetInstance():AddActivityEvent(function ()
	-- 	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRank)
	-- end)
	-- -- local key = HallWinnerController:GetInstance().model:GetWinneKeyValue()
	-- -- if key then
	-- -- 	ActivityModuleController:GetInstance():AddActivityEvent(function ()
	-- -- 		UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallWinner)
	-- -- 	end)
	-- -- end
end

--大厅到登录
function SceneManager:mHallToLogin()
	UIManager:GetInstance():HidePanelAll(false)--隐藏所有窗口
	LuaEvent:DispatchEvent(EventName.BACK_TO_LOGIN)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginBG)
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Login)
	--发布返回登陆的消息
	self.mSceneType = SceneManager.SceneType.Login
end

--游戏到登录
function SceneManager:mGameToLogin()
	UIManager:GetInstance():HidePanelAll()--隐藏所有窗口
	LuaEvent:DispatchEvent(EventName.BACK_TO_LOGIN)
	--进入主界面
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.Landscape)
		SceneManager.GetInstance():SetScreenOrientation()
		StartCoroutine(function()
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginBG)
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Login)
			RoomController:GetInstance():DestroyGameRes()
		end)
	else
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginBG)
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.Login)
		RoomController:GetInstance():DestroyGameRes()
	end
end



--大厅到房间
function SceneManager:mHallToRoom( dataList )
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRoom,function (panel)
		if  dataList then
			print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr11111111111111111   ")
			panel:CreateRoomList(dataList)
		end
	end)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallGroup,nil,false)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallGame,nil,false)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallTopInfo,nil,false)
end

--房间到大厅
function SceneManager:mRoomToHall()
	RoomController.GetInstance().CanRequest = true
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGame)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo)
	UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGroup)
	UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallRoom)
		
end



--房间到游戏
function SceneManager:mRoomToGame(  )
	RoomController.GetInstance().model.IsEnterGame = true
	UIManager:GetInstance():HidePanelAll()
	UIManager:GetInstance():DestroyAllPanel()
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		SceneManager.GetInstance():SetScreenOrientation()
		StartCoroutine(function()
			WaitForSeconds(0.2)
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginLoad,function(loadingPanel)
				loadingPanel:SetBG("Hall_bg")
				loadingPanel:StartPreLoad()
			end)
		end)
	else
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginLoad,function(loadingPanel)
			loadingPanel:SetBG("Hall_bg")
			loadingPanel:StartPreLoad()
		end)
	end
end



--大厅到游戏
function SceneManager:mHallToGame(  )
	
	UIManager:GetInstance():HidePanelAll()--隐藏所有窗口
	UIManager:GetInstance():DestroyAllPanel()
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		SceneManager.GetInstance():SetScreenOrientation()
		StartCoroutine(function()
			WaitForSeconds(0.2)
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginLoad,function(loadingPanel)
				loadingPanel:SetBG("Hall_bg")
				loadingPanel:StartPreLoad()
			end)
		end)
	else
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.LoginLoad,function(loadingPanel)
			loadingPanel:SetBG("Hall_bg")
			loadingPanel:StartPreLoad()
		end)
	end
end




--游戏到房间
function SceneManager:mGameToRoom()
	UIManager:GetInstance():HidePanelAll()--隐藏所有窗口
	HallNotifyModel.GetInstance().IsShowTopScorePanel = true
	LuaEvent:DispatchEvent(EventName.GameSceneNoNotifyMove,0,-80)
	RoomController.GetInstance().CanRequest = true
	--进入主界面
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.Landscape)
		SceneManager.GetInstance():SetScreenOrientation()
		StartCoroutine(function()
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)--
			--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo)--
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRoom)

		
		end)
	else
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)--
		--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo)--
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRoom)

	end
end


--游戏到大厅
function SceneManager:mGameToHall()
	--SceneManager.GetInstance():SetScreenOrientation(SceneManager.ScreenOrientationType.Landscape)
	UIManager:GetInstance():HidePanelAll()--隐藏所有窗口
	LuaEvent:DispatchEvent(EventName.GameSceneNoNotifyMove,0,-80)
	HallNotifyModel.GetInstance().IsShowTopScorePanel = true
	RoomController.GetInstance().CanRequest = true
	--进入主界面
	if SceneManager.GetInstance().CurrentScreenOrientationType == SceneManager.ScreenOrientationType.Protrait then
		SceneManager.GetInstance():SetCurrentScreenOrientation(SceneManager.ScreenOrientationType.Landscape)
		SceneManager.GetInstance():SetScreenOrientation()
		StartCoroutine(function()
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)--
			--UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.SceneSwitching)
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo,nil,false)--
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGame,nil,false)--
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGroup,nil,false)
		end)
	else
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallBg)--
		--UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.SceneSwitching)
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallTopInfo,nil,false)--
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGame,nil,false)--
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallGroup,nil,false)
	end

end



--修改场景状态
function SceneManager:mChangeSceneState(newType)
	if newType==nil or self.mSceneType==nil or  newType== self.mSceneType then
		return 
	end
	self.mOldSceneType=self.mSceneType
	print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr   ",newType)
	self.mSceneType=newType
end





--弹出请求返回登录界面的函数
function SceneManager:RequestReturnToScene(titleText,contextText,btnName,sceneType,...)
	local showBoxData ={}
	showBoxData.title = tostring(titleText)--:标签，
	showBoxData.context = tostring(contextText)--内容；
	showBoxData.btnEnterName = tostring(btnName)--确定按钮；
	showBoxData.enterCB = function() 
		self:ChangeSceneToType(sceneType)
	end--：点击确定返回；
	
	-- showBoxData.cancelCB = function() end--：点击取消返回，
	showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
	showBoxData.isHideAll = false--:隐藏所有按钮; 
	showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end


--二级游戏界面切换到一级游戏界面的函数
function SceneManager:SecondGmaeViewToFirstGameView()
	--HallGameController.GetInstance():BackToFirstView()
end

--在大厅调用返回按钮时触发的函数
function SceneManager:HallSceneBack()
	self:RequestReturnToScene("提示","Lobby_backup_tips","确定",SceneManager.SceneType.Login)
end




-----------------------------私有函数--------------------------------------------


--------------------------------------------------已弃用--------------------------------------------------------

function SceneManager:MainToLoginScene()
	self:ChangeSceneToType(self.SceneType.Login)
end



--登录跳转到大厅场景
function SceneManager:LoginToHallScene()

	self:ChangeSceneToType(self.SceneType.Hall)

end

--如果有转盘的话就跳转到大厅
function SceneManager:HallZhuanPanToScene()
	
	self:ChangeSceneToType(self.SceneType.Hall)
end

--大厅跳转到登录
function SceneManager:BackToLoginScene()
	
	self:ChangeSceneToType(self.SceneType.Login)
end



--大厅到房间
function SceneManager:HallToRoom( dataList )
	
	self:ChangeSceneToType(self.SceneType.Room,dataList)
end

--房间到大厅
function SceneManager:RoomToHall( ... )

	self:ChangeSceneToType(self.SceneType.Hall)
end




--大厅跳转到游戏场景
function SceneManager:HallToGameScene( ... )
	
	self:ChangeSceneToType(self.SceneType.Game)

end

--游戏返回大厅 即将弃用
function SceneManager:GameToHallScene(gameId)
	
	-- if self.mOldSceneType==SceneManager.SceneType.Room then
	-- 	self:ChangeSceneToType(self.SceneType.Room)
	-- else
		
	-- 	resMgr:UnloadGameAssetBundle(gameId)
	-- 	if ConfigInfoMgr.useHotFunction ~= false then
	-- 		LuaManager:RemoveLuaBundle(gameId)
	-- 	end
	-- 	Resources:UnloadUnusedAssets()	
	-- 	self:ChangeSceneToType(self.SceneType.Hall)
	-- end

	resMgr:UnloadGameAssetBundle(gameId)
	if ConfigInfoMgr.useHotFunction ~= false then
		LuaManager:RemoveLuaBundle(gameId)
	end
	Resources:UnloadUnusedAssets()	
	self:ChangeSceneToType(self.SceneType.Hall)

end
