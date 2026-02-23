LinePanel=BaseClass()

function LinePanel:__init(gameObj)
	self.gameObject=gameObj	
	self:InitData()
	self:InitView()
end


function LinePanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.LineCount=9
	self.LineGroup={}
end


function LinePanel:InitView()
	self:FindView()
	self:InitUIViewData()
end

function LinePanel:FindView()
	local tf=self.gameObject.transform
	local num = nil
	for i=1,self.LineCount do
		num=i
		if i<10 then
			num="0"..i
		end
		local line=tf:Find("Line_"..num).gameObject
		table.insert(self.LineGroup,line)
	end

end


function LinePanel:InitUIViewData()
	
end