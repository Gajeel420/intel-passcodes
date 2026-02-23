GameData=BaseClass()

function GameData:__init()
	
	self:InitData()
	self.LanguageType=1
	local LanguageType=""
	self.LocalizationManager = CS.I2.Loc.LocalizationManager
	if SystemSetting:GetInstance() then
		LanguageType=SystemSetting:GetInstance():GetLanguage()
		if LanguageType and LanguageType=="English" then
			self.LanguageType=2
		end
	end
end


--初始化游戏数据
function GameData:InitData()

	--游戏基础数据
	self:InitGameData()
	
	--类实例
	self:GameObjectInstance()

	--游戏状态
	self:InitGameState()
end

--类实例
function GameData:GameObjectInstance()
	
end

--游戏状态
function GameData:InitGameState()
	self.GameStation=1   --主游戏状态  1 主游戏  2 免费游戏  3 彩金游戏 4 选龙
	self.bySubGameStation=1    --//游戏子状态 1 normal  2 bigwin  3 Jackpot  4 freeGame
	self.NexGameStation=1		--下一个游戏状态
	
	self.IsReciveServerData=false		--是否收到服务端返回的数据
	self.IsSendGameStart=false
	self.bAuto=false					--服务器是否自动
	self.IsOpenHelp=false
	
end

--游戏基础数据
function GameData:InitGameData()
	self:PlayerData()      --玩家数据
	self:YaZhuData()
	self:GameControlBtnData()
	self:GameItemData()
	self:GameResultData()
	self:GameIconRotioan()
	self:FreeGameData()
	self:TimerData()
	self:SelectDragonData()
	self:JackpotData()
	self:ZhuanPanData()
	self:ModuleData()
	self:ZXPanelData()
end




--计时器对象
function GameData:TimerData()
	self.StartBtnOnclickTimer=nil		--点击开始禁用按钮回调计时器
	self.StartBtnEnableTimer=nil
	self.CurrentStopRunTimmer=nil		--当前正在使用的计时器对象
	self.SelectDragonTimer=nil			--进入选龙计时器
	self.SendSelectDragonTimer=nil		--发送选龙计时器
	self.JackpotWaitEffectTimer=nil		--Jackpot等待特效计时器
	self.StateTimer=nil					--状态计时器
	self.ZhuanPanTimer=nil				--转盘触发计时器
end


--玩家数据
function GameData:PlayerData()
	self.UserInfo={}     --用户数据
	self.PlayerMoney=nil      --玩家身上的钱
	self.BeforePlayerMoney=0
	self.uiUserID=0
	self.ConfigData=nil			--配置数据表
end


--模块数据
function GameData:ModuleData()
	self.WinScoreEffectData={}			--赢分特效保存数据
end



--压注按钮数据
function GameData:YaZhuData()
	self.currentXiaZhuaValue=nil    --当前下注值
	self.CurrentIndex = 1    --- 当前下注下标
	self.TotalIndex=nil      --下注筹码下标总共长度
	self.BetGroups = {}    --可下注的砝码组
	self.LineCount=0
end

--游戏按钮控制数据
function GameData:GameControlBtnData()
	self.IsAuto=false         --是否是自动模式
	self.IsStart=false			--是否开始游戏
	self.IsStop=false			--是否是停止
	self.IsAllStop = false      --是否直接全部停止
	self.isQuick=false 			--是否是快速模式
	self.AutoCount = 0     		--自动次数
	self.CurrentAutoCount=1		--当前自动次数
	self.RemainAutoCount=0		--剩余自动次数
	self.StartTime=2			--开始长按2秒显示自动弹窗
	self.currentStartPressTime=0		--当前按下的时间
	self.IsStartTime=false		--是否开启开始按钮计时
	self.IsEnterStop=false		--是否可以点击停止游戏，必须要收到服务器消息并且自动停止没有使用的时候才能点击停止游戏
	self.IsEnterStart=false		--是否已经开始，没有停止之前不能点击开始
	self.StartOnclickCount=0
end





--游戏图标数据
function GameData:GameItemData()
	self.ItemIconList={}		--游戏图标列表
	self.GameIconParentList={}	--每列游戏图标父物体列表
	self.GameIconParentList2={}
	self.GameIconPosList={}		--游戏图标位置列表
	self.GameIconPosList2={}
	self.GameObjectInstanceParent=nil		--游戏对象实例挂载点
	self.IconItemInstanceList={}			--所有游戏图标位置下的游戏图标对象列表
	self.IconItemInstanceList2={}
	self.TextureMaskGroup={}				--遮挡层图片
	self.GameBgGroup={}						--游戏背景图标
end

--游戏图标转动数据
function GameData:GameIconRotioan()
	self.RowItemList={}				--游戏旋转列对象列表
end

--游戏结果数据
function GameData:GameResultData()
	self.GameTotalWinScore=0			--游戏总得分结果
	self.GameResult={}			--游戏15个位置的结果值
	self.WinLineCount=0			--赢线数量
	self.WinLinDataList={}			--赢线中的中奖位置坐标数据列表，根据二维坐标位置可以控制每个ItemIcon对象
	self.AllWinLinDataList = {}    --所有中奖线结果
	self.WinLineDataScoreList={}	--9条线获得分数表
	self.ResultBetMultiple=0		--结果下注倍数
	self.StopAnim=false		--是否停止动画
	self.StopAnimCount=1	--停止动画计数
	self.StoneOrLightningCoordinate={}	--滚石和闪电替换图标的坐标
	self.StoneOrLightningResult=0		--滚石和闪电的中奖结果
	self.IsStone=false				--是否是滚石
	self.IsLightning=false			--是否是闪电
	self.FreeGameIconCount=0		--免费游戏图标数量
	self.IsEnableLightningOrStoneState=false		--是否启用闪电和滚石状态
	self.FreeGameWildState={}			--免费游戏中wild的列数
	--self.WinLineTotalMultiple=0			--赢线总倍数
	self.IsFiveKindOnLineState=false		--是否是五连状态
	self.IsJackpot=false
	self.JackpotScore=0
	self.GameResultSeq=0
	self.ClientReqSeq=0
	self.SignalState=0
	self.IsNormalSever=true
	self.SignalStateTime=460
	self.LastSendGameStartTime=0
	self.LastReciveResultTime=0
	self.IntervalTime=5
end


function GameData:ZhuanPanData()
	self.ZhuanPanItemGroup=nil		--转盘每个位置数据
	self.IsHasFragment=false		--当前局是否包含有效碎片
	self.FragmentIconInsList={}			--有效碎片线上的图标实例
	self.FragmentCount=0			--有效碎片的总数
	self.CurrentFragmentState={}	--当前局新中奖的碎片id
	self.IsEnabledZhuanPanGameState=false		--是否触发小游戏状态
end

--免费游戏数据
function GameData:FreeGameData()
	
	self.FreeGameTotalCount=0			--免费游戏总次数
	self.FreeGameRemainCount=5		--免费游戏剩余次数
	self.nCurPlayMiniGameCnt=0       --免费游戏当前次数
	self.BeforeIsAuto=false			--之前是否是自动状态
	self.FreeGameTotalScore=0		--免费游戏总赢分
	
	self.IsEnableZXModel=false		--是否开启紫霞模式
	self.FreeIconPosGroup={}		--免费游戏图标位置
	self.FreeGameState=0			--0 为玩法1，1 为玩法2
	self.IsFreeGameing = false      --是否在免费游戏中
end


--选龙数据
function GameData:SelectDragonData()
	--self.IsReciveSelectDragonData=false		--是否收到选龙数据
	self.SelectDragonIndex=0		--选择免费游戏图标索引
end


function GameData:JackpotData()
	self.CaiChiInstanceList={}		
	self.CaiChiTypeDataList={}
	self.JackpotInstanceList={}
end


function GameData:ZXPanelData()
	self.StartFreeGame=false		--是否是触发免费游戏结束后开始免费游戏
	self.ZXModelState={}			--紫霞模式状态
	self.currentZXStatePos=5		--当前紫霞状态位置
	self.currentZXModelState={}		--当前紫霞模式状态
	self.currentZXPos=5				--当前紫霞链接边界位置
end




