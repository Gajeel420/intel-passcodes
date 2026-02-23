TimerManager=BaseClass()

timerCount=0	--区别不同的计时器key

function TimerManager:__init(delayTime,fun,object)
	--PrintLog("初始化计时器",delayTime,fun,object)
	if object~=nil then
		self.Self=object		--调用方自己
	end
	self.delayTime = delayTime
	self.BackFun = fun
	self.time = 0
	self.IsStart=true			--	开始计时
	
	timerCount=timerCount+1
	self.updateName="TimerManager.Update"..timerCount

	CommonHelp.AddUpdate(self)
end


--移除计时器
function TimerManager:RemoveTimer()
	RenderMgr.Remove(self.updateName)
	if self~=nil and self.time<self.delayTime then
		self.time=0
		self=nil
	end
end


function TimerManager:Update()
	if self.IsStart then
		self.time = self.time + Time.deltaTime
		if self.time >= self.delayTime then
			self.IsStart=false
			--self.time=0
			self:StopTimer()
		end
	end
 	
end

function TimerManager:StopTimer()
	RenderMgr.Remove(self.updateName)
	if self.BackFun ~= nil then
		self.BackFun(self.Self)
		self=nil
	end
end
