LineManager=BaseClass()

function LineManager:__init()
	self:InitData()
end


function LineManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.LineInsGroup={}
end


function LineManager:CreateLineIns()
	local LinesGroup=self.gameData.LinePanel.LineGroup
	local count=#LinesGroup
	for i=1,count do
		local lineIns=self.gameData.LineItem.New(LinesGroup[i])
		table.insert(self.LineInsGroup,lineIns)
	end
end


function LineManager:GetLineIns(LineInsIndex)
	return self.LineInsGroup[LineInsIndex]
end


function LineManager:ShowAllocateLine(LineInsIndex,isdisplay)
	local lineIns=self:GetLineIns(LineInsIndex+1)
	if lineIns then
		lineIns:ShowWinLine(isdisplay)
	end
end

function LineManager:HideAllocateLine(LineInsIndex)
	local lineIns=self:GetLineIns(LineInsIndex+1)
	if lineIns then
		lineIns:HideAllLine()
	end
end


function LineManager:HideAllLine()
	self.gameData.GameSetPanel:ResetLineBtnState()
	for i=1,#self.LineInsGroup do
		self:GetLineIns(i):HideAllLine()
	end
end

function LineManager:ShowAllLine()
	for i=1,#self.LineInsGroup do
		self:GetLineIns(i):ShowWinLine(true)
	end
end