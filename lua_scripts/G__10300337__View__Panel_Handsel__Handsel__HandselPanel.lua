HandselPanel=BaseClass()

function HandselPanel:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
end


function HandselPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.CaiJinGroup={}
end


function HandselPanel:InitView()

	self:FindView()
	self:InitUIViewData()
	
	
end

function HandselPanel:FindView()
	local tf=self.gameObject.transform
	for i=1,1 do
		local caiJinObj=tf:Find("Jackpot/Jackpot_0"..i).gameObject
		table.insert(self.CaiJinGroup,caiJinObj)
	end
end




function HandselPanel:InitUIViewData()
	
end