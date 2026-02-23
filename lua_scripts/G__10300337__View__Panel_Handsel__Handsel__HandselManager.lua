HandselManager=BaseClass()

function HandselManager:__init()
	self:InitData()
	self:InitView()
end


function HandselManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.HandselInsGroup={}
end


function HandselManager:InitView()

end



function HandselManager:InitHandselInstance()
	local handselObjList=self.gameData.HandselPanel.CaiJinGroup
	if handselObjList then
		for i=1,#handselObjList do
			local ins=self.gameData.HandselItem.New(handselObjList[i])
			table.insert(self.HandselInsGroup,ins)
		end
	end
end

function HandselManager:UpdateHandselValue(data,times,index)
	if self.HandselInsGroup[index] then
		self.HandselInsGroup[index]:UpdateCaiChi(data,times)
	end
end
