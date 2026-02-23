TipsAnimPanle=BaseClass()

function TipsAnimPanle:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
end


function TipsAnimPanle:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  

	self.MonkeyAnimList={}
	self.FlowerAnimList={}
end


function TipsAnimPanle:InitView()

	self:FindView()
	self:InitUIViewData()

end

function TipsAnimPanle:FindView()
	local tf=self.gameObject.transform
	
	self:FindMonkeyView(tf)
	self:FindFlowerView(tf)
end


function TipsAnimPanle:FindMonkeyView(tf)
	for i=1,3 do
		local monkeyObj=tf:Find("AnimGroup/HouTou_Anim0"..(i-1)).gameObject
		table.insert(self.MonkeyAnimList,monkeyObj)
	end
end


function TipsAnimPanle:FindFlowerView(tf)
	for i=1,2 do
		local FlowerObj=tf:Find("AnimGroup/Flower_"..i).gameObject
		table.insert(self.FlowerAnimList,FlowerObj)
	end
end


function TipsAnimPanle:InitUIViewData()
	
end


function TipsAnimPanle:PlayMonkeyAnim(index)
	CommonHelp.IsShowPanel(index,self.MonkeyAnimList,true,true,true)
end


function TipsAnimPanle:PlayFlowerAnim(index)
	CommonHelp.IsShowPanel(0,self.FlowerAnimList,true,true,false)
	CommonHelp.IsShowPanel(index,self.FlowerAnimList,true,true,false)
end