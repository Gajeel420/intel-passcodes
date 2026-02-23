HeartManager = HeartManager or BaseClass(LuaController)

function HeartManager:__init( ... )
	-- body
	self.m_Frequency_Back = 7	--//多长时间没有收到心跳，重新连接
	self.m_TimeCount_Back = 0	--返回消息时间累加
	self.heartBeatCount = 0		--当前没收到心跳返回次数累加
	self.m_Frequency_Count = 5	-- 累加多少次没收到心跳 就弹出提示框
	self.m_TimeCount_DealNoNetWork = 14;--//连接服务器等待时长 2s
	self.send = {}
	
	self.LastSendTimes = 0

	self:RegistProto()
	self:AddEvent()
	RenderMgr.Add(function()
		self:NetUpdate()
	end,"HeartManager:NetUpdate")
end

function HeartManager:RegistProto( ... )
	-- body
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_HEARTBEAT,"RsqHeartTick")					--收到心跳返回				
end

function HeartManager:AddEvent( ... )
	-- body
	LuaEvent:AddEventListener(EventName.LOGIN_SUCCESS,self.LoginCompleted,self)						--登录成功
	LuaEvent:AddEventListener(EventName.BACK_TO_LOGIN,self.BackToLogin,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_ConnectServerSuccess,self.ConnectServerSuccess,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_ConnectingServer,self.ConnectingServer,self)
	LuaEvent:AddEventListener(EventName.PAYCHECKPAYMENT,self.OnApplicationFocus,self)					--后台切换到前台
	LuaEvent:AddEventListener(EventName.CSTOLUA_ScoketDisconnect,self.OnApplicationFocus,self)
	LuaEvent:AddEventListener(EventName.ReceiveServerMessage,self.RsqSendTick,self)
	LuaEvent:AddEventListener(EventName.GameNetDispatchData,self.HandleData,self)

	LuaEvent:AddEventListener(EventName.GameDataError_ForcedLoginReturn,self.GameDataErrorForcedLoginReturn,self)
end

function HeartManager:GameDataErrorForcedLoginReturn()
	local showBoxData ={}
	showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
	showBoxData.context = StringFormatByLanguage("GameDataError_ForcedLoginReturn")--内容；
	showBoxData.enterCB = function()
		SceneManager:GetInstance():BackToLoginScene()
	end--：点击确定返回；
	showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
	showBoxData.isHideAll = false--:隐藏所有按钮;
	showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function HeartManager:RsqHeartTick()
	local state = os.clock()*1000 - self.LastSendTimes
	state = state <= 20 and 10 or math.ceil( state / 2 )
	LuaEvent:DispatchEvent(EventName.GameSignalStrength,state)
end

function HeartManager:HandleData()
	self:RsqSendTick()
end

function HeartManager:OnApplicationFocus( ... )
	-- body
	RoomController.GetInstance().CanRequest = true
	self:ReqSendTick()
end
-- socket 断开连接
function HeartManager:ScoketDisconnect( ... )
	-- body
	
	self:CloseHeart()
	self:DealNoNetWork()
end

function HeartManager:ConnectingServer()
	
	Network.OnConnecting()
	RenderMgr.AddInterval(function()
			print("连接服务器超时")
			self:CloseHeart()
			self:DealNoNetWork()
		
		end,"HeartManager:DealNoNetWork",self.m_TimeCount_DealNoNetWork,self.m_TimeCount_DealNoNetWork+0.1)
end

function HeartManager:ConnectServerSuccess()
	print("链接成功")
	
	--self:RestAllTime()
	self.m_TimeCount_Back = 0
	Network.OnConnected()	
end

-- 登录成功
function HeartManager:LoginCompleted( ... )
	-- body
	RenderMgr.Remove("HeartManager:DealNoNetWork")
	Network.isLoginSuccessed=true
	self.m_Frequency_Back = 4
	self:RestAllTime()
	self:ReqSendTick()
	RenderMgr.AddInterval(function()
		self:ReqSendTick()
	end,"HeartManager:ReqSendTick",NetworkDefine.g_Frequency)

	RenderMgr.AddInterval(function()
		local  scene = SceneManager:GetInstance():GetCurrentSceneState()
		if(scene == SceneManager.SceneType.Hall or scene == SceneManager.SceneType.Room) then 
			PlayerInfoController:GetInstance():RequestGetUserMoney()		--一分钟查询一次用户金钱
		end
	end,"HeartManager:RequestGetUserMoney",60)
end

---返回登录
function HeartManager:BackToLogin( context )
	-- body
	RenderMgr.Remove("HeartManager:RequestGetUserMoney")
	Network.isLoginSuccessed = false
	Network.isConnected = false
	self:CloseHeart()
end

function HeartManager:NotifyUserOffLine(  )
	-- body
	Network.isLoginSuccessed = false
	Network.isConnected = false
	self:CloseHeart()
end

-- 发送心跳包
function HeartManager:ReqSendTick( )
	
	--print("发送心跳")
	self.send.m_TimeStamep=os.time()
	self.LastSendTimes = os.clock()*1000
	Net_SendHallData(NetworkDefine.CReqHeartBeatGamePara,self.send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_HEARTBEAT,0)
end

--收到心跳返回
function HeartManager:RsqSendTick(  )
	-- body
	self:RestAllTime()
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallSignal)
end

function HeartManager:RestAllTime( ... )
	-- body
	self.m_TimeCount_Back = 0
	self.heartBeatCount = 0
end

--update
function HeartManager:NetUpdate()
	-- body
	if Network.isLoginSuccessed  then
		if not NetworkMgr:IsConnect()  then
			print("网络断开")
			self:HandleNetworkDisconnect()
		end
		
		if self.m_TimeCount_Back >= self.m_Frequency_Back then
			self.m_TimeCount_Back = 0
			self.heartBeatCount = self.heartBeatCount + 1
			
			if self.heartBeatCount > self.m_Frequency_Count then
				self:CloseHeart()
				self:DealNoNetWork()
			else
				if self.heartBeatCount > 3 then
					print("心跳超时主动断开连接")
					self.m_Frequency_Back = 7
					self:HandleNetworkDisconnect()
				else
					print("显示弱网标志",self.heartBeatCount)
				
					if(SceneManager:GetInstance():GetCurrentSceneState() == SceneManager.SceneType.Game) then 
						UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallSignal)
					end
				end
			end
		else
			self.m_TimeCount_Back = self.m_TimeCount_Back+Time.deltaTime
		end
	end
end

function HeartManager:HandleNetworkDisconnect( ... )
	-- body
	Network.isConnected = false
	Network.isLoginSuccessed = false
	self:RemoveAllTime()
	NetworkMgr:Connect() 
end

function HeartManager:RemoveAllTime( ... )
	-- body
	RenderMgr.Remove("HeartManager:ReqSendTick")
	self.m_TimeCount_Back = 0
end


function HeartManager:DealNoNetWork( ... )
	-- body
	Network.isLoginSuccessed = false
	if SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Hall or
	 SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Room or
	 SceneManager:GetInstance():GetCurrentSceneState()==SceneManager.SceneType.Game then
		LuaEvent:DispatchEvent(EventName.HallToGameNetWorkFile)
		if not(UIManager.GetInstance():IsShowPanel(UIPanelDefine.EWndID.MessageBox)) then
			local showData={}
			local showBoxData ={}
			showBoxData.title = StringFormatByLanguage("Prompt")--:标签，
			showBoxData.context = StringFormatByLanguage("LoginFailTryAgain")--内容；
			showBoxData.enterCB = function()
				self:HandleNetworkDisconnect()
			end--：点击确定返回；

			showBoxData.cancelCB = function()
				SceneManager:GetInstance():BackToLoginScene()
			end--：点击取消返回，
			showBoxData.isShowCancel = true--：true显示两个，fasle--显示一个确定按钮；
			showBoxData.isHideAll = false--:隐藏所有按钮;
			showBoxData.isShowBtnClose = false--:界面的关闭按钮
			UIManager:GetInstance():ShowMessageBox(showBoxData)
		end
	end

end

--关闭心跳
function HeartManager:CloseHeart( ... )
	-- body
	--Network.isLoginSuccessed = false
	--self.heartBeatCount = 0
	self:RemoveAllTime()
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallSignal)
	NetworkMgr:DisConnect()
end


function HeartManager:GetInstance( ... )
	-- body
	if HeartManager.instance == nil then
		HeartManager.instance = HeartManager.New()
	end
	return HeartManager.instance
end

function HeartManager:__delete( ... )
	-- body
	RenderMgr.Remove("HeartManager:NetUpdate")
end