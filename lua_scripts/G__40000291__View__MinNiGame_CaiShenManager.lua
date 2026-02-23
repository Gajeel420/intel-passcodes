MinNiGame_CaiShenManager=BaseClass()

function MinNiGame_CaiShenManager:__init(t)
	-- self.transform=t
	-- self.gameObject=t.gameObject
	-- self.JackpotSocreList={}
	-- self.ScoreInsList={}
	-- self:FindView()
	-- self:InitScoreItem()
end


-- function MinNiGame_CaiShenManager:FindView()
-- 	for i=4,1,-1 do
-- 		local socreObj=self.transform:Find("caishen_top/Score/wujian_0"..i).gameObject
-- 		table.insert(self.JackpotSocreList,socreObj)
-- 	end
-- end


-- function MinNiGame_CaiShenManager:InitScoreItem()
-- 	local scoreList=self.JackpotSocreList
-- 	if scoreList then
-- 		for i=1,#scoreList do
-- 			local ins=MinNiGame_CaiShenScoreItem.New(scoreList[i])
-- 			table.insert(self.ScoreInsList,ins)
-- 		end
-- 	end
-- end


-- function MinNiGame_CaiShenManager:InitScoreItemValue()
-- 	for i=1,#self.ScoreInsList do
-- 		self.ScoreInsList[i]:InitScoreItem()
-- 	end
-- end



-- function MinNiGame_CaiShenManager:SetScoreItemProcess(score)
-- 	GameController.GetInstance():PlayConinAudio(27)
-- 	print(score)
-- 	self.gameObject:SetActive(true)
-- 	self:InitScoreItemValue()
-- 	local valueT=self:MapValue(score)
-- 	pt(valueT)
-- 	local DelayPlayItemRunFunc=function ()
-- 		for i=#self.ScoreInsList,1,-1 do
-- 			self.ScoreInsList[i]:SetScoreItemRunProcess(valueT[5-i])
-- 			yield_return(WaitForSeconds(0.2))
-- 		end
-- 		--yield_return(WaitForSeconds(2))
-- 		for i=1,#self.ScoreInsList do
-- 			self.ScoreInsList[i].IsStop=true
-- 			GameController.GetInstance():PlayConinAudio(24)
-- 			yield_return(WaitForSeconds(0.05))
-- 		end
-- 		GameController.GetInstance():PlayConinAudio(33)
-- 		yield_return(WaitForSeconds(2))
-- 		GameController.GetInstance():PlayConinAudio(23)
-- 		self.gameObject:SetActive(false)

-- 	end
-- 	StartCoroutine(DelayPlayItemRunFunc)
	
-- end

-- function MinNiGame_CaiShenManager:CheckScoreValue(score)
-- 	local tempV={}
-- 	local tempScore=score
-- 	--print(tempScore)
-- 	tempScore=tostring(tempScore)
-- 	--print("aljsdflajsflaj: ",#tempScore)
-- 	--print(tempScore)
-- 	for i=1,#tempScore do
-- 		local v=string.sub(tempScore,i,i)
-- 		--print("V：",v)
-- 		if v=="." or v=="元" then
-- 			return tempV
-- 		else
-- 			print(v)
-- 			table.insert(tempV,v)
-- 		end
-- 	end
-- 	return tempV
-- end


-- function MinNiGame_CaiShenManager:MapValue(score)
-- 	local tempV={0,0,0,0}
-- 	local valueT =self:CheckScoreValue(score)
-- 	--pt(valueT)
-- 	local index=4
-- 	for i=#valueT,1,-1 do
-- 		tempV[index]=tonumber(valueT[i])
-- 		index=index-1
-- 	end
-- 	return tempV
-- end


-- function MinNiGame_CaiShenManager:Update()
-- 	if self.ScoreInsList then
-- 		for i=1,#self.ScoreInsList do
-- 			self.ScoreInsList[i]:Update()
-- 		end
-- 	end
-- end

-- function MinNiGame_CaiShenManager:__delete( ... )
-- 	GameController:GetInstance().view.m_poolFloatNum:Despawn(self.transform);
-- 	self.transform=nil
-- 	self.gameObject=nil
-- end