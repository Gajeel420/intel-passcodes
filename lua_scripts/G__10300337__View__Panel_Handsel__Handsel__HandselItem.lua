HandselItem=BaseClass()

function HandselItem:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
	CommonHelp.AddUpdate(self)
end

CaiChiCount=0
function HandselItem:InitData()
	
	CaiChiCount=CaiChiCount+1
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.updateName="HandselItem.Update"..CaiChiCount
	self.IsStartUpdateCaiChi=false						--是否可以更新彩池
	self.CaiChiChangeTime=0								--彩池增长时间
	self.currentCaiChiValue=0							--当前彩池值
	self.CaiChiChangeValue=0							--彩池改变值
	self.currentCaiChiChangeTime=0						--当前彩池增长时间
end


function HandselItem:InitView()

	self:FindView()
	self:InitUIViewData()
	
	
end

function HandselItem:FindView()
	local tf=self.gameObject.transform
	self.CaiChiLabel=tf:Find("Label"):GetComponent(typeof(UILabel))
end



function HandselItem:InitUIViewData()
	self:SetCaiChiResult(0)
end


function HandselItem:SetCaiChiResult(values)
	self.CaiChiLabel.text=CommonHelp.SetNumberThousandsFormatScore(values)--CommonHelp.SetScore(values)
end


function HandselItem:UpdateCaiChi(data,times)
	if times==nil then
		self.CaiChiChangeTime=1
	else
		self.CaiChiChangeTime=data.nTime/1000
	end
	self.currentCaiChiValue=data.nJackpotPreTotal
	self.CaiChiChangeValue=data.nJackpotIncrea
	self.currentCaiChiChangeTime=0
	self.IsStartUpdateCaiChi=true
end


function HandselItem:ChangeCaiChiValue()
	if self.IsStartUpdateCaiChi then
		self.currentCaiChiChangeTime=self.currentCaiChiChangeTime+Time.deltaTime
		local result=math.ceil(self.currentCaiChiValue+self.CaiChiChangeValue*(self.currentCaiChiChangeTime/self.CaiChiChangeTime))
		self:SetCaiChiResult(result)
		if self.currentCaiChiChangeTime>=self.CaiChiChangeTime then
			self.IsStartUpdateCaiChi=false
			self.currentCaiChiChangeTime=0
			self:SetCaiChiResult(self.currentCaiChiValue+self.CaiChiChangeValue)
		end
	end
end


function HandselItem:Update()
	self:ChangeCaiChiValue()
end