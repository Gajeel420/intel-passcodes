BeiKeGameTimeManager=BaseClass()

timerCount=0	--区别不同的计时器key

local timerList={}
function BeiKeGameTimeManager:__init(delayTime,fun,object)
	--PrintLog("初始化计时器",delayTime,fun,object)
	-- if object~=nil then
	-- 	self.Self=object		--调用方自己
	-- end
	-- self.delayTime = delayTime
	-- self.BackFun = fun
	-- self.time = 0
	-- self.IsStart=true			--	开始计时
	
	-- timerCount=timerCount+1
	-- self.updateName="BeiKeGameTimeManager.Update"..timerCount
	-- table.insert(timerList,self.updateName )
	-- RenderMgr.Add(function ()
	-- 	self:Update()
	-- 	GameController:GetInstance():AddDeleteUpdateList(self.updateName)
	-- 	end,self.updateName)
end


-- function BeiKeGameTimeManager.RemoveAllTimer()
-- 	for k, v in pairs(timerList) do
-- 		RenderMgr.Remove(v)
-- 	end
-- end

-- --移除计时器
-- function BeiKeGameTimeManager:RemoveTimer()
-- 	RenderMgr.Remove(self.updateName)
-- 	if self~=nil and self.time<self.delayTime then
-- 		self.time=0
-- 		self=nil
-- 	end
-- end


-- function BeiKeGameTimeManager:Update()
-- 	if self.IsStart then
-- 		self.time = self.time + Time.deltaTime
-- 		if self.time >= self.delayTime then
-- 			self.IsStart=false
-- 			self.time=0
-- 			self:StopTimer()
-- 		end
-- 	end
-- end

-- function BeiKeGameTimeManager:StopTimer()
-- 	RenderMgr.Remove(self.updateName)
-- 	if self.BackFun ~= nil then
-- 		self.BackFun(self.Self)
-- 		self=nil
-- 	end
-- end