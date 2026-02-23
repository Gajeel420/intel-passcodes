MinNiGame_CaiShenScoreItem=BaseClass()

function MinNiGame_CaiShenScoreItem:__init(gameObj)
	-- self.gameObject=gameObj	
	-- self:InitData()
	-- self:InitView()
end


-- function MinNiGame_CaiShenScoreItem:InitData()
-- 	self.Speed=2
-- 	self.IsRun=false
-- 	self.IsStop=false
-- 	self.CurrentValue=0
-- 	self.EndValue=0
-- 	self.Items={}	--数字表
-- 	self.StartLocalPos={}
-- 	self.MoveDirection=nil
-- 	self.IsLast=true
-- end


-- function MinNiGame_CaiShenScoreItem:InitView()
-- 	self:FindView()
-- 	self:InitUIViewData()
-- end

-- function MinNiGame_CaiShenScoreItem:FindView()
-- 	local tf=self.gameObject.transform
	
-- 	for i=1,2 do
-- 		local labelObj=tf:Find("Label_0"..i):GetComponent(typeof(UILabel))
-- 		table.insert(self.Items,labelObj)
-- 		table.insert(self.StartLocalPos,labelObj.gameObject.transform.localPosition)
-- 	end
	
-- end


-- function MinNiGame_CaiShenScoreItem:InitUIViewData()
-- 	self:SetDistance()
-- 	self:SetMoveDirection()
-- end


-- function MinNiGame_CaiShenScoreItem:InitScoreItem()
-- 	self:SetLabelValue(1,0)
-- 	self:SetLabelValue(2,0)
-- end


-- function MinNiGame_CaiShenScoreItem:SetMoveDirection()
-- 	self.MoveDirection=(self.StartLocalPos[2]-self.StartLocalPos[1]).normalized 
-- end

-- function MinNiGame_CaiShenScoreItem:SetDistance()
-- 	self.Distance=self.StartLocalPos[1].y-self.StartLocalPos[2].y
-- end


-- function MinNiGame_CaiShenScoreItem:SwapIndex(list)
-- 	local  tmpItem=list[2]
-- 	list[2]=list[1]
-- 	list[1]=tmpItem
-- end


-- function MinNiGame_CaiShenScoreItem:SwapItem()
-- 	self:SwapIndex(self.Items)			
-- 	self.Items[1].gameObject.transform.localPosition=Vector3(0,0,0)
-- end

-- function MinNiGame_CaiShenScoreItem:SetItemVlaue()
-- 	self.CurrentValue=self.CurrentValue+1
-- 	if self.CurrentValue>9 then
-- 		self.CurrentValue=0
-- 	end
-- 	self:SetLabelValue(1,self.CurrentValue)
-- end

-- function MinNiGame_CaiShenScoreItem:RunSwap()
-- 	self:SwapItem()
-- 	self:SetItemVlaue()
-- end

-- function MinNiGame_CaiShenScoreItem:SetLabelValue(index,value)
-- 	self.Items[index].text=value
-- end

-- function MinNiGame_CaiShenScoreItem:SetCurentValue(value)
-- 	self.CurrentValue=value
-- end

-- function MinNiGame_CaiShenScoreItem:GetCurrentValue()
-- 	return self.CurrentValue
-- end


-- function MinNiGame_CaiShenScoreItem:ResetPosition()

-- 	self.Items[1].gameObject.transform.localPosition=Vector3(0,-60,0)

-- end


-- function MinNiGame_CaiShenScoreItem:SetScoreItemRunProcess(value)
-- 	self.CurrentValue=0
-- 	self.EndValue=value
-- 	print("结束位置结果为：")
-- 	print(value)
-- 	self.IsRun=true
-- 	self.IsStop=false
-- 	--[[local DelayStopRunFunc=function ()
-- 		self.IsStop=true
-- 	end
-- 	CommonHelp.SetTimeBackCall(2,DelayStopRunFunc)--]]
-- end





-- function MinNiGame_CaiShenScoreItem:Rotation()
-- 	if self.IsRun then		
-- 		if self.Items==nil or #self.Items<1 then
-- 			return
-- 		end
		
-- 		for i=1,#self.Items  do
-- 			self.Items[i].gameObject.transform:Translate(Time.deltaTime*self.Speed*self.MoveDirection,CS.UnityEngine.Space.World)	
-- 		end
-- 		--print(self.Items[1].gameObject.transform.localPosition.y)
-- 		if self.Items[1].gameObject.transform.localPosition.y<=-60 then
-- 			if self.IsStop then		
-- 				if self.CurrentValue==self.EndValue then
-- 					self.IsRun=false
-- 					self.IsStop=false
-- 					self:ResetPosition()
-- 				else
-- 					self:RunSwap()
-- 				end
-- 			else					
-- 				self:RunSwap()
-- 			end
-- 		end
-- 	end
-- end



-- function MinNiGame_CaiShenScoreItem:Update()
-- 	self:Rotation()
-- end