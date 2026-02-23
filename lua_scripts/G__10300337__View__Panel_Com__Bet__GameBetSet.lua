GameBetSet=BaseClass()

function GameBetSet:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
	self:AddBtnEventListener()
end


function GameBetSet:InitData()
	self.gameData=GameUIManager.GetInstance().GameData   
	self.gameUIManager = GameUIManager.GetInstance()
	self.QuickSpriteEnableName="Game_UI_Btn_Quick"
	self.QuickSpriteDidableName="Game_UI_Btn_Quick_N"
	self.XZNameList={"Game_UI_Label_Bet01_CH","Game_UI_Label_Bet01_EN","Game_UI_Label_Bet_CH","Game_UI_Label_Bet_EN"}
end


function GameBetSet:InitView()

	self:FindView()
	self:InitUIViewData()
end

function GameBetSet:FindView()
	local tf=self.gameObject.transform
	self.Btn_Quick=tf:Find("Bottom/Btn_Fast").gameObject   --快速模式
	self.QuickSprite=tf:Find("Bottom/Btn_Fast/Background"):GetComponent(typeof(UISprite))
	self.Btn_Max=tf:Find("Bottom/Btn_BigBet").gameObject   --最大下注
	self.Btn_Add=tf:Find("Bottom/Bet/Btn_Add").gameObject   --添加下注
	self.Btn_Minus=tf:Find("Bottom/Bet/Btn_Minus").gameObject   --减小下注
	self.XiaZhu_Label=tf:Find("Bottom/Bet/Label"):GetComponent(typeof(UILabel))    --下注金额
	self.XiaZhu_Label10=tf:Find("Bottom/Bet/Label_Line"):GetComponent(typeof(UILabel))    --下注金额 * 10
	self.XiaZhu_Sprite=tf:Find("Bottom/Bet/Back/Sprite_Label"):GetComponent(typeof(UISprite))

	self.AddEnable=self.Btn_Add:GetComponent(typeof(UIButton))
	self.MinusEnable=self.Btn_Minus:GetComponent(typeof(UIButton))
	self.MaxEnable=self.Btn_Max:GetComponent(typeof(UIButton))
	
	self.m_MaxBetEffect = tf:Find("Bottom/Bet/MaxBetEffect").gameObject
end


function GameBetSet:InitUIViewData()
	self.LineCount=60
	if self.gameData.LanguageType==1 then
		self:SetMaxBetSprite(1)
	else
		self:SetMaxBetSprite(2)
	end
	CommonHelp.SetActive(self.QuickSprite.gameObject,false)
end


function GameBetSet:AddBtnEventListener()
	UIEventListener.Get(self.Btn_Quick).onClick=function () self:QuickBtnOnclick() end
	UIEventListener.Get(self.Btn_Max).onClick=function () self:MaxOnclick() end
	UIEventListener.Get(self.Btn_Add).onClick=function () self:AddOnclick() end
	UIEventListener.Get(self.Btn_Minus).onClick=function () self:MinusOnclick() end
	
end


function GameBetSet:SetMaxBetSprite(index)
	self.XiaZhu_Sprite.spriteName=self.XZNameList[index]
end


function GameBetSet:IsEnableBtn(btnEnable,isEnable)
	btnEnable.isEnabled=isEnable
end

function GameBetSet:IsEnableBetBtn(isEnable)
	self:IsEnableBtn(self.AddEnable,isEnable)
	self:IsEnableBtn(self.MinusEnable,isEnable)
	self.gameData.GameSetPanel:IsEnableLineBtn(isEnable)
	if isEnable and self.gameData.CurrentIndex==self.gameData.TotalIndex then
		return
	end
	self:IsEnableBtn(self.MaxEnable,isEnable)
end

function GameBetSet:QuickBtnOnclick()
	self.gameData.isQuick=not self.gameData.isQuick
	if self.gameData.isQuick then
		CommonHelp.SetActive(self.QuickSprite.gameObject,true)
		--self.QuickSprite.spriteName=self.QuickSpriteDidableName 
	else
		CommonHelp.SetActive(self.QuickSprite.gameObject,false)
		--self.QuickSprite.spriteName=self.QuickSpriteEnableName
	end
	
end


function GameBetSet:IsEnableMaxBet(isEnable)
	self:IsEnableBtn(self.MaxEnable,isEnable)
	if isEnable then
		if self.gameData.LanguageType==1 then
			self:SetMaxBetSprite(1)
		else
			self:SetMaxBetSprite(2)
		end
		
	else
		if self.gameData.LanguageType==1 then
			self:SetMaxBetSprite(3)
		else
			self:SetMaxBetSprite(4)
		end
		
	end
end


  
function GameBetSet:InitXiaZhuaConfig(data)
	if data==nil then return end
	for i = 1,#data.nBetNum do
		if data.nBetNum[i] <= 0 then
			--print("服务器押注索引"..i.."值为：空")
			--break
		else
			self.gameData.BetGroups[i] = data.nBetNum[i]
			--print("服务器押注索引"..i.."值为：",data.nBetNum[i])
		end
	end
	self.LineCount=data.nDefaultSelPrizeLineCnt
	self.gameData.LineCount=self.LineCount
	--print("线数为：",self.LineCount)
	self.gameData.CurrentIndex =data.betindex+1   
	self.gameData.TotalIndex=#self.gameData.BetGroups  
	self:SetXiaZhuValue(self.gameData.BetGroups[self.gameData.CurrentIndex]) 
end


function GameBetSet:SetXiaZhuValue(score)
	if(score == nil) then
		score = self.gameData.BetGroups[self.gameData.CurrentIndex]*self.LineCount
	else
		score=score*self.LineCount
	end
	self.gameUIManager:ShowBetLabel(score / self.LineCount)
	self:SetXiaZhuScore(score)
	self:SetCurrentXiaZhuValue(score)
end



function GameBetSet:SetXiaZhuScore(score)	
	self.XiaZhu_Label.text=CommonHelp.SetNumberThousandsFormatScore(score / self.LineCount)
	self.XiaZhu_Label10.text=CommonHelp.SetNumberThousandsFormatScore(score)
	self.gameUIManager:ShowLineScoreValue(CommonHelp.SetNumberThousandsFormatScore(score/self.LineCount))
end



function GameBetSet:SetXiaZhuTanChangScore(score)
	self.Bet_Label.text=CommonHelp.SetScore(score)
end


function GameBetSet:SetCurrentXiaZhuValue(score)
	self.gameData.currentXiaZhuaValue=score
end


function GameBetSet:GetCurrentXiaZhuValue()
	return self.gameData.currentXiaZhuaValue
end

function GameBetSet:GetCurrentSingleXiaZhuValue()
	return self.gameData.currentXiaZhuaValue/self.LineCount
end


function GameBetSet:GetCurrentXiaZhuIndex()
	return self.gameData.CurrentIndex
end

function GameBetSet:ShowMaxBetEffect()
	self.m_MaxBetEffect:SetActive(false)
	self.m_MaxBetEffect:SetActive(true)
end


function GameBetSet:MaxOnclick()
	self:ShowMaxBetEffect()
	self.gameData.CurrentIndex=self.gameData.TotalIndex		
	self:SetXiaZhuValue(self.gameData.BetGroups[self.gameData.CurrentIndex])
	self:IsEnableMaxBet(false)
end


function GameBetSet:AddOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	self.gameData.CurrentIndex=(self.gameData.CurrentIndex+1)%self.gameData.TotalIndex
	if self.gameData.CurrentIndex==0 then
		self:ShowMaxBetEffect()
		self.gameData.CurrentIndex=self.gameData.TotalIndex
		self:IsEnableMaxBet(false)
	else
		self:IsEnableMaxBet(true)
	end
	self:SetXiaZhuValue(self.gameData.BetGroups[self.gameData.CurrentIndex])
 
	
end


function GameBetSet:MinusOnclick()
	CommonHelp.PlayAudio(GameAudioPath.BtnCommon)
	local index=self.gameData.CurrentIndex-1
	if index>0 then
		self:IsEnableMaxBet(true)
		self.gameData.CurrentIndex=index%self.gameData.TotalIndex	
	else
		self:IsEnableMaxBet(false)
		self.gameData.CurrentIndex=self.gameData.TotalIndex
		self:ShowMaxBetEffect()
	end
	self:SetXiaZhuValue(self.gameData.BetGroups[self.gameData.CurrentIndex])
 
end





return GameBetSet