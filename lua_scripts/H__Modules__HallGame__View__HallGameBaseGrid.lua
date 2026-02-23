HallGameBaseGrid=HallGameBaseGrid or BaseClass()
 --101游戏正在检测中
 --102检测不到版本文件 version
 --103游戏正在下载中
function HallGameBaseGrid:__init( obj,vo,initDelay )
	self.obj=obj
	self.vo=vo
	self.iTotalScore=0
	self.iSpeed=0
	self.curScore=0
	self.initDelay=initDelay --为了减缓集中初始化时造成的卡顿，所有分批初始化
	self.UIVo=nil --UI数据
end

function HallGameBaseGrid:InitUI()
	self.m_index_Effect = 1
	self.mVector = Vector3.zero
	self.mBoxSize = Vector3.zero
	local mTran = self.obj.transform
	self.IsScrollViewDrag = false
	self.tranGameViewParent=mTran:Find("GameView")
	self.objDownloadTag=mTran:Find("Bottom/Unready").gameObject
	self.labelProgress=mTran:Find("Bottom/Unready/Progress/Label"):GetComponent(typeof(UILabel))
	self.objDown = mTran:Find("Bottom/Unready/DownLoad").gameObject
	self.mTran_Expect = mTran:Find("Bottom/Expect")
	self.mTran_Expect.gameObject:SetActive(true)
	self.mSprite_Expect=mTran:Find("Bottom/Expect/Bg"):GetComponent(typeof(UISprite))		---更新图标
	self.mSprite_Expect.gameObject:SetActive(false)
	self.labelProgress.text=StringFormat("0%")
	self.spProgress=mTran:Find("Bottom/Unready/Progress").gameObject
	self.spProgress:SetActive(false)
	self.mProgressBar = mTran:Find("Bottom/Unready/Slider_Ani"):GetComponent(typeof(UISlider))
	local mTranUI = mTran:Find("Bottom/Expect/HotNode/Effects")
	if mTranUI ~= nil then
		self.mEffects = mTranUI.gameObject
	end
	--Hot New
	self.mObj_Hot=mTran:Find("Bottom/Expect/HotNode/HOT").gameObject
	self.mObj_Hot:SetActive(false)
	self.mObj_New=mTran:Find("Bottom/Expect/HotNode/New").gameObject
	self.mObj_New:SetActive(false)
	self.mObj_ExperienceField = mTran:Find("Bottom/Expect/HotNode/ExperienceField").gameObject
	self.mObj_ExperienceField:SetActive(false)

	--收藏
	self.m_DelayCloseAniName = "HallGameBaseGrid:DelayCloseAniName"..self.vo.gameID
	self.m_Go_Love = mTran:Find("Bottom/Expect/HotNode/Btn_Love").gameObject
	self.m_Go_BgLove = mTran:Find("Bottom/Expect/HotNode/Btn_Love/Background").gameObject
	self.m_Go_BgUnLove = mTran:Find("Bottom/Expect/HotNode/Btn_Love/Background_N").gameObject
	self.m_LoveState = false
	self.m_Go_Quan = mTran:Find("Bottom/Expect/HotNode/Btn_Love/Background/quan").gameObject
	self.m_Go_Quan:SetActive(false)
	self.m_Tween_Quan = self.m_Go_Quan:GetComponent(typeof(TweenTransform))
	self.m_Tween_Quan:SetOnFinished(function ()
		RenderMgr.Remove(self.m_DelayCloseAniName)
		HallGameController:GetInstance().view.panel:ShowLoveBtnAni(true)
		RenderMgr.AddInterval(function ()
			self.m_Go_Quan:SetActive(false)
		end,self.m_DelayCloseAniName,0.5,0.55)
	end)

	if self.vo.isOpen then
		self.labelProgress.gameObject:SetActive(false)
		self.mProgressBar.gameObject:SetActive(false)
		self.objDownloadTag:SetActive(true)
		self.objDown:SetActive(false)
		self.mSprite_Expect.gameObject:SetActive(false)
		local status=math.fmod( self.vo.status,10 )
		if self.mEffects ~= nil then 
			self.mEffects:SetActive(false)
		end
		if math.floor( status+0.5 )==0 then
		
		elseif math.floor( status+0.5 ) ==1 then
			self.mObj_Hot:SetActive(true)
		elseif math.floor( status+0.5 )==2 then
			self.mObj_New:SetActive(true)
		elseif math.floor( status+0.5 )==3 then
			self.mObj_ExperienceField:SetActive(true)
		else

		end
		self.CanEnterGame = false
	else
		self.objDownloadTag:SetActive(false)
		self.labelProgress.gameObject:SetActive(false)
		self.mProgressBar.gameObject:SetActive(false)
		self.objDown:SetActive(false)
		self.mObj_Hot:SetActive(false)
		self.mObj_New:SetActive(false)
		self.mObj_ExperienceField:SetActive(false)
		self.mSprite_Expect.gameObject:SetActive(true)
	end
	self.UIVo={}
	self.UIVo.parent=self.tranGameViewParent
	self.UIVo.gameID=self.vo.gameID
	self.UIVo.isShowBig=self.vo.isShowBig

	self.mBoxSize.x = 282
	self.mBoxSize.z = 1
	self.mBoxSize.y = 230
	-- if self.vo.isShowBig then
	-- 	self.mVector.y = 116
	-- 	self.mBoxSize.y = 406
	-- else
	-- 	self.mBoxSize.y = 450
	-- 	self.mVector.y = 2
	-- end
	self.obj:GetComponent(typeof(BoxCollider)).size = self.mBoxSize
	--self.mTran_Expect.localPosition = self.mVector
	self.UIVo.callBack=function()
		if self.vo.callBack then
			pcall(self.vo.callBack,self)
		end
	end
	-- self:StartLoadItemUI()

	--特效处理
	self.m_EffectList = {}
	for i = 1, 4 do
		self.m_EffectList[i] = mTran:Find("GameView/Effect_0"..i).gameObject
		self.m_EffectList[i]:SetActive(false)
	end
	self:AddEvent()
end

function HallGameBaseGrid:InitLoveState()
	local isLove = HallGameModel:GetInstance():CheckIsLoveGame(self.vo.gameID)
	self:SetLoveState(isLove)
end

--开始加载并初始化Icon
function HallGameBaseGrid:StartLoadItemUI()
	if self.UIVo then
		HallGameGrid.New(self.UIVo)
	end
end

function HallGameBaseGrid:AddEvent()
	---UIEventListener.Get(self.obj).onClick = function () self:OnClickItem() end
	
	GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self)
	GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_EXTRACT, self.OnExtract,self)
	GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	--GameDownloadModel:GetInstance():AddEventListener(EventName.APPLY_CHECKGAME_CB,self.ApplyCheckGameCallBack,self)
	GameDownloadModel:GetInstance():AddEventListener(EventName.UPDATE_ERROR, self.OnUpdateError,self)
	UIEventListener.Get(self.obj).onDragStart = function()  self.IsScrollViewDrag = true end
	UIEventListener.Get(self.obj).onPress = function (ogj,isPressed) self:OnGamePress(isPressed) end
	LuaEvent:AddEventListener(EventName.StartAutoDownLoadByGameID,self.AutoDownLoadListener,self)

	UIEventListener.Get(self.m_Go_Love).onClick = function ()
		self:OnClickLoveGame()
	end
end

function HallGameBaseGrid:OnGamePress(isPressed)
	self.IsLongPress = false 
	if isPressed then
		self.LastPressTime = os.time()
		self.IsScrollViewDrag = false
	else
		if not (self.IsScrollViewDrag) then
			local times = os.time()
			if (times - self.LastPressTime) < 3 then
				self:OnClickItem()
				self.IsLongPress = false 
			-- else
			-- 	self.IsLongPress = true
			-- 	local showBoxData ={}
			-- 	showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
			-- 	local str = StringFormat("您确定要清除[00F0FFFF]{0}[-]的游戏资源",ConfigModuleModel.GetInstance().listGameName[ConfigModuleModel.GetInstance():GameIDChange(self.vo.gameID)])
			-- 	showBoxData.context = str
			-- 	showBoxData.enterCB = function() 
			-- 		local dirPath = StringFormat("{0}{1}", PathDefine.AssetBundlePath(),PathDefine.GetRelativeResPath(self.vo.gameID))
			-- 		--print("删除文件夹路径:",dirPath)
			-- 		if Directory.Exists(dirPath) then
			-- 			Directory.Delete(dirPath,true)
			-- 		end
			-- 		self:CleanGameData()
			-- 	end--：点击确定返回；
			-- 	showBoxData.cancelCB = nil
			-- 	showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
			-- 	showBoxData.isHideAll = false--:隐藏所有按钮; 
			-- 	showBoxData.isShowBtnClose = false--:界面的关闭按钮
			-- 	UIManager:GetInstance():ShowMessageBox(showBoxData)
			end
		end
	end
end 

function HallGameBaseGrid:AutoDownLoadListener(context)
	if context and context.m_data then
		if context.m_data[0] == self.vo.gameID then
			---self:OnClickItem()
		end
	end
end

function HallGameBaseGrid:RemoveEvent()
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self)
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.UPDATE_EXTRACT, self.OnExtract,self)
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self)
	--GameDownloadModel:GetInstance():RemoveEventListener(EventName.APPLY_CHECKGAME_CB,self.ApplyCheckGameCallBack,self)
	
	if self.vo.caijinVo then
		self.vo.caijinVo:RemoveEventListener(CaijinModuleConst.EventName_UpdateCaijinVo,self.UpdateCaijinVo,self)
	end
end

function HallGameBaseGrid:UpdateCaijinVo(context)
	if not context then return end
	local key=context[1]
	local newValue=context[2]
	local oldValue=context[3]
	if key=="iCaijin" then
		self.iTotalScore=newValue
		self.iSpeed=(newValue-self.curScore)/11
	end
end

function HallGameBaseGrid:OnUpdate( deltaTime )
	if self.vo and self.vo.caijinVo then
		if self.curScore< self.iTotalScore then
			self.curScore=self.curScore+self.iSpeed*deltaTime
		else
			self.curScore=self.iTotalScore 
		end

		self.labelCaijin.text=GoldNumberThousandsFormat(HallGoldRateSToC(self.curScore))
	end
end

function HallGameBaseGrid:CheckGameResCallBack(context)
	GameDownloadModel:GetInstance():RemoveEventListener(EventName.APPLY_CHECKGAME_RES_CB,self.CheckGameResCallBack,self)
	if context then
		local nGameID=context[1]
		local nSate=context[2]
		if nGameID==self.vo.gameID then
			if nSate==0 or nSate==1 then--下载
				--这里可以加入是否需要弹出窗口提示
				GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_GAMEDOWNLOAD,{self.vo.gameID}) --申请下载
				
			elseif nSate==2 then--不用更新
				if self.CanEnterGame then
					RoomController:GetInstance():ReqGetRoomLevel(self.vo.gameID)  --进入列表
					self.CanEnterGame = false
				end
			elseif nSate==102 then  --检测失败
				print("检测版本文件version失败")
				self:CleanGameData()
				UIManager:GetInstance():ShowNoteMessage(self.vo.gameName..StringFormatByLanguage("Game_Download_Failed"),nil,nil,1)
			end
		end
	end
end

function HallGameBaseGrid:OnProgress( context )
	if context==nil then return end
	local left = context[1]
	local total = context[2]
	local nGameID = context[3]
	if nGameID==self.vo.gameID then
		self.objDownloadTag:SetActive(true)
		self.spProgress:SetActive(true)
		self.mProgressBar.gameObject:SetActive(true)
		if total>0 then
			local factor=left/total
			if factor>1 then
				factor=1
			end
			--self.spProgress.fillAmount=1-factor
			self.mProgressBar.value = 1-factor
			if not self.labelProgress.activeSelf then
				self.labelProgress.gameObject:SetActive(true)
				self.objDown:SetActive(false)
			end
			self.labelProgress.text=StringFormat("{0}%",Mathf.Floor(factor*100))
		end
	end
end
function HallGameBaseGrid:OnExtract( context )
	if context==nil then return end
	local left = context[1]
	local total = context[2]
	local nGameID = context[3]
	if nGameID==self.vo.gameID then
		self.objDownloadTag:SetActive(true)
		self.spProgress:SetActive(true)
		self.mProgressBar.gameObject:SetActive(true)
		if total>0 then
			local factor=left/total
			if factor>1 then
				factor=1
			end
			--self.spProgress.fillAmount=1-factor
			self.mProgressBar.value = 1-factor
			if not self.labelProgress.activeSelf then
				self.labelProgress.gameObject:SetActive(true)
				self.objDown:SetActive(false)
			end
			self.labelProgress.text=StringFormat("{0}%",Mathf.Floor(factor*100))
		end
	end
end


function HallGameBaseGrid:OnUpdateError(context)
	local gameID = 0
	if context~=nil then
		gameID=context[1]
	end
	if gameID == self.vo.gameID then
		self:CleanGameData()
		--self.objDownloadTag:SetActive(false)
	end
end


function HallGameBaseGrid:CleanGameData()
	self.objDownloadTag:SetActive(false)
	self.spProgress:SetActive(false)
	self.mProgressBar.gameObject:SetActive(false)
end



function HallGameBaseGrid:OnDownCompleted(context)
	local gameID=0
	if context~=nil then
		gameID=context[1]
	end
	if gameID==self.vo.gameID then
		self:CleanGameData()
	end
end

function HallGameBaseGrid:LowVersionPrompt()
	local showBoxData ={}
	showBoxData.title = "提示"
	showBoxData.context ="当前版本过低，请升级最新版本，即可体验 \n 如若不清楚，请点击【确认】联系客服。"
	showBoxData.enterCB = function() 
		UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallService)
	end--：点击确定返回；
	showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
	showBoxData.isHideAll = false--:隐藏所有按钮; 
	showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function HallGameBaseGrid:OnClickItem()
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	-- SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.enterRoom)
	if self.IsLongPress  then return end

	if self.vo.gameID == 40000310 then
		if ConfigInfoMgr.ApkCheckVersion == nil or ConfigInfoMgr.ApkCheckVersion < 1 then
			self:LowVersionPrompt()
			return
		end
	end

	if self.vo.gameID == 20600203 then
		if ConfigInfoMgr.ApkCheckVersion == nil or ConfigInfoMgr.ApkCheckVersion < 3 then
			self:LowVersionPrompt()
			return
		end
	end
	
	GameDownloadModel:GetInstance():AddEventListener(EventName.APPLY_CHECKGAME_RES_CB,self.CheckGameResCallBack,self)
	if self.vo == nil then return end
	if not self.vo.isOpen then 
		UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Game_IS_LOCK_TIP"),3);
		return 
	end
	self.CanEnterGame = true
	if ConfigInfoMgr.useHotFunction == true then
		if not self:CheckGameInstall() then
			GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_GAMEDOWNLOAD,{self.vo.gameID}) --申请下载
		else
			
			if GameDownloadModel:GetInstance():CheckGameResApplying(self.vo.gameID) then 
				print("正在检测版本")
				RenderMgr.AddInterval(function()
					GameDownloadModel:GetInstance():RemoveGameResApplying(self.vo.gameID)
				end,"HallGameBaseGrid:RemoveCheckGameResApplying",3,3.1)
				return 
			end
			if GameDownloadModel:GetInstance():CheckGameDownloadApplying(self.vo.gameID) then return end
			
			GameDownloadModel:GetInstance():DispatchEvent(EventName.APPLY_CHECKGAME_RES,{self.vo.gameID}) --检测
		end
	else
		RoomController:GetInstance():ReqGetRoomLevel(self.vo.gameID)
	end
end

--检查游戏是否安装
function HallGameBaseGrid:CheckGameInstall(  )
	local fileName = StringFormat("{0}{1}/version.xml",PathDefine.AssetBundlePath(),self.vo.gameID)
	local isExits = false
	isExits = LuaHelperUtil.FileExits(fileName)
	-- self.mGo_NoInstallSign:SetActive(not isExits)
	-- self.m_goNoInstallSpriteSign:SetActive(not isExits)
	return isExits
end

function HallGameBaseGrid:SetLocalPosition(vec3)
	self.obj.transform.localPosition= vec3
	--self:SetDisplay(false)
	--self.obj:SetActive(false)
end

--设置收藏状态
function HallGameBaseGrid:SetLoveState(isShow)
	self.m_LoveState = isShow
	self.m_Go_BgLove:SetActive(isShow)
	self.m_Go_BgUnLove:SetActive(not isShow)
end

function HallGameBaseGrid:OnClickLoveGame()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	self:SetLoveState(not self.m_LoveState)
	if self.m_LoveState then
		self:PlayLoveAni()
		HallGameModel:GetInstance():AddPlayerLoveGameList(self.vo.gameID)
	else
		self.m_Go_Quan:SetActive(false)
		HallGameModel:GetInstance():RemovePlayerLoveGameList(self.vo.gameID)
	end

	HallGameController:GetInstance().view.panel:RefreshLoveView()
end

function HallGameBaseGrid:PlayLoveAni()
	if self.m_Go_Quan then
		self.m_Go_Quan:SetActive(true)
		self.m_Tween_Quan:ResetToBeginning()
		self.m_Tween_Quan:PlayForward()
	end
end

function HallGameBaseGrid:SetDisplay(display)
	self.obj:SetActive(display)
end

function HallGameBaseGrid:SetParent(parentTrans)
	self.obj.transform:SetParent(parentTrans)
end

function HallGameBaseGrid:SetEffectData(index)
	self.m_index_Effect = index
	self.m_EffectList[index]:SetActive(true)
end

function HallGameBaseGrid:CloseEffect()
	self.m_EffectList[self.m_index_Effect]:SetActive(false)
end

function HallGameBaseGrid:OpenEffect()
	self.m_EffectList[self.m_index_Effect]:SetActive(true)
end

function HallGameBaseGrid:__delete( )
	self:RemoveEvent()
end