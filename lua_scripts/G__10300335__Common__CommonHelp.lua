CommonHelp={}

--是否打印日志
function CommonHelp.ConfigLog(isPrint)
	CS.Debuger.IsEnableLog=isPrint
	-- CS.Debuger.IsEnableLog=true
end

--设置游戏对象显隐
function  CommonHelp.SetActive(gameObj,isDisplay)
	gameObj:SetActive(isDisplay)
end

--计时器回调函数
function CommonHelp.SetTimeBackCall(delayTime,BackCallFunc,self)	
	return TimerManager.New(delayTime,BackCallFunc,self)
end

--添加更新
function CommonHelp.AddUpdate(self)
	RenderMgr.Add(function ()
		self:Update()
		end,self.updateName)
	--添加到移除列表中
	--GameController.GetInstance():AddDeleteUpdateList(self.updateName)
end

function CommonHelp.SetNumberThousandsFormatScore(score)
	return NumberThousandsFormat(HallGoldRateSToC(score))
end

return CommonHelp

