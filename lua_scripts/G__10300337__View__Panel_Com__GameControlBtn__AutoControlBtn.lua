AutoControlBtn=BaseClass()

function AutoControlBtn:__init(gameObj)
	self.gameObject=gameObj
	
	self:InitData()
	self:InitView()
	
end

--初始化数据
function AutoControlBtn:InitData()
	self.gameData=GameUIManager.GetInstance().GameData  --游戏数据
	self.first=10
	self.second=20
	self.third=50
	self.fourth=100
	self.level5=200
	self.level6=500
	self.max=10000
	self.maxLabel="∞"
	self.AutoAnimList={"Choose_Num_Open","Choose_Num_Close"}
end


--初始化界面
function AutoControlBtn:InitView()
	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
	self:AddBtnEventListener()
end

--初始化UI数据
function AutoControlBtn:InitUIViewData()
	self.AutoPanel=nil                                  --自动面板
	self.FirstAutoBtn=nil 								--第一档次
	self.FirstAutoLabel=nil 
	self.SecondAutoBtn=nil 								--第二档次
	self.SecondAutoLabel=nil 
	self.ThirdAutoBtn=nil 								--第三档次
	self.ThirdAutoLabel=nil 
	self.FourthAutoBtn=nil 								--第四档次
	self.FourthAutoLabel=nil 
	self.MaxAutoBtn=nil 								--无穷档次
	self.MaxAutoLabel=nil 	
	self.QuikBtn=nil									--快速模式
	self.QuikSpriteObj=nil 								--快速图标
	
end

function AutoControlBtn:FindView()
	local tf=self.gameObject.transform
	self.AutoPanel=tf:Find("Bottom/Btn_Choose").gameObject	
	self.AutoAnim=self.AutoPanel:GetComponent(typeof(Animation))
	self.FirstAutoBtn=tf:Find("Bottom/Btn_Choose/Btn_1").gameObject
	self.SecondAutoBtn=tf:Find("Bottom/Btn_Choose/Btn_2").gameObject
	self.ThirdAutoBtn=tf:Find("Bottom/Btn_Choose/Btn_3").gameObject
	self.FourthAutoBtn=tf:Find("Bottom/Btn_Choose/Btn_4").gameObject
	self.AutoBtn5=tf:Find("Bottom/Btn_Choose/Btn_5").gameObject
	self.AutoBtn6=tf:Find("Bottom/Btn_Choose/Btn_6").gameObject
	self.MaxAutoBtn=tf:Find("Bottom/Btn_Choose/Btn_7").gameObject
	
	self.AutoBox=tf:Find("Bottom/Btn_Choose/Mask_Black").gameObject
end

--初始化UI界面
function AutoControlBtn:InitUIView()
end

--设置是否显示自动面板
function AutoControlBtn:SetAutoPanelDisplay(isDisplay)
	CommonHelp.SetActive(self.AutoPanel,isDisplay)
end


function AutoControlBtn:PlayAutoAnim(index)
	if index==1 then
		self:SetAutoPanelDisplay(true)
	else
		local DelayHideAutoPanelFunc=function ()
			self:SetAutoPanelDisplay(false)
		end
		CommonHelp.SetTimeBackCall(0.6,DelayHideAutoPanelFunc)
	end
	self.AutoAnim:Play(self.AutoAnimList[index])
end


function AutoControlBtn:IsActiveAuto()
	return CommonHelp.IsActive(self.AutoPanel)
end



function AutoControlBtn:AddBtnEventListener()
	UIEventListener.Get(self.FirstAutoBtn).onClick=function () self:FirstAutoBtnOnclick() end
	UIEventListener.Get(self.SecondAutoBtn).onClick=function () self:SecondAutoBtnOnclick() end
	UIEventListener.Get(self.ThirdAutoBtn).onClick=function () self:ThirdAutoBtnOnclick() end
	UIEventListener.Get(self.FourthAutoBtn).onClick=function () self:FourthAutoBtnOnclick() end
	UIEventListener.Get(self.AutoBtn5).onClick=function () self:OnclickAutoBtn5() end
	UIEventListener.Get(self.AutoBtn6).onClick=function () self:OnclickAutoBtn6() end
	UIEventListener.Get(self.MaxAutoBtn).onClick=function () self:MaxAutoBtnOnclick() end
	UIEventListener.Get(self.AutoBox).onClick=function () self:AutoBoxBtnOnclick() end
end



function AutoControlBtn:AutoBoxBtnOnclick()
	
end



function AutoControlBtn:FirstAutoBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.first)
	self:SetAutoCountLabelState()
end

function AutoControlBtn:SecondAutoBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.second)
	self:SetAutoCountLabelState()
end

function AutoControlBtn:ThirdAutoBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.third)
	self:SetAutoCountLabelState()
end

function AutoControlBtn:FourthAutoBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.fourth)
	self:SetAutoCountLabelState()
end

function AutoControlBtn:OnclickAutoBtn5()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.level5)
	self:SetAutoCountLabelState()
end

function AutoControlBtn:OnclickAutoBtn6()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.level6)
	self:SetAutoCountLabelState()
end


function AutoControlBtn:MaxAutoBtnOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self:SetAutoCount(self.max)
	self:SetAutoCountLabelState()
end

--设置自动次数
function AutoControlBtn:SetAutoCount(count)
	self.gameData.AutoCount=count
	self.gameData.IsAuto=true	--开启自动标记
	self.gameData.CurrentAutoCount=0
end

--获取自动次数
function AutoControlBtn:GetRemainAutoCount()
	return self.gameData.AutoCount
end

--设置剩余自动次数	count 为当前已自动运行的次数
function AutoControlBtn:SetRemainAutoCount(count)
	self.gameData.RemainAutoCount=self.gameData.AutoCount-count
	if self.gameData.RemainAutoCount>1000 then  --无限次的label处理
		self.gameData.StartControlBtn:SetAutoCountLabel(self.maxLabel)
		self.gameData.StartControlBtn:SetMaxLevelStateDisplay(true)
	elseif self.gameData.RemainAutoCount==0	then	--剩余次数为0则停止
		self:AutoEndStation()
	elseif self.gameData.RemainAutoCount>0 then
		self.gameData.StartControlBtn:SetAutoCountLabel(self.gameData.RemainAutoCount)
		self.gameData.StartControlBtn:SetMaxLevelStateDisplay(false)
	end
	
end

--获取剩余自动次数
function AutoControlBtn:GetRemainAutoCount()
	return self.gameData.RemainAutoCount
end

--设置当前自动次数
function AutoControlBtn:SetCurrentAutoCount()
	self.gameData.CurrentAutoCount=self.gameData.CurrentAutoCount+1
end

--自动结束配置
function AutoControlBtn:AutoEndStation()
	self.gameData.IsAuto=false
	self.gameData.CurrentAutoCount=0
	
	--PrintLog("自动结束配置",self.gameData.IsAuto)
	
	--自动模式下点击停止后重新显示开始按钮
	--self.gameData.StartControlBtn:SetStopRunBtnStation()
	--self.gameData.StartControlBtn:SetStartBtnIsEnabled(false)

	
end

--点击后显示自动次数面板及停止按钮显示
function AutoControlBtn:SetAutoCountLabelState()
	--self:SetAutoPanelDisplay(false)
	self:AutoBoxBtnOnclick()
	local startControlBtn=self.gameData.StartControlBtn
	startControlBtn:SetStopPanelDisplay(true)	
	--自动开始游戏
	self:AutoStartGame()
end


--自动开始游戏
function AutoControlBtn:AutoStartGame()
	if self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame then
		self:SetRemainAutoCount(self.gameData.CurrentAutoCount)	--设置剩余自动次数
		self:SetCurrentAutoCount()	--设置当前自动次数
		if self.gameData.PlayerMoney<self.gameData.BetGroups[self.gameData.CurrentIndex]*self.gameData.LineCount  and self.gameData.bySubGameStation~=GameDefine.SubGameState.FreeGame then
			UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("CurrentBetMoneyInsufficient"),10)
			self.gameData.IsAuto=false
			self.gameData.StartControlBtn:SetStopRunBtnStation()
			self:IsEnableBetState()
			return
		end
	end
	--开始转动
	self.gameData.GameControlManager:StartGame()
	
end



return AutoControlBtn


