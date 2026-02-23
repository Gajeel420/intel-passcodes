LineItem=BaseClass()

function LineItem:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
end


function LineItem:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.LineInex={}
	
end


function LineItem:InitView()

	self:FindView()
	self:InitUIViewData()

end

function LineItem:FindView()
	local tf=self.gameObject.transform
	
	self:FindLineView(tf)

end


function LineItem:FindLineView(tf)

end


function LineItem:InitUIViewData()
	self:HideAllLine()
end



function LineItem:IsShowLine(isDisplay)
	CommonHelp.SetActive(self.gameObject,isDisplay)
end

function LineItem:HideAllLine()
	self:IsShowLine(false)
end


function LineItem:ShowWinLine()
	self:IsShowLine(true)
end