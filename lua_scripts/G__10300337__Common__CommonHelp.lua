CommonHelp={}

CommonHelp.IsEnterGame=false
CommonHelp.MaxPos = Vector3(10000,0,0)

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

--移除计时器
function CommonHelp.StopTimeBackCall(timer)
	timer:RemoveTimer() 
end

--判断是否在场景中激活
function CommonHelp.IsActive(gameObj)
	return gameObj.activeInHierarchy
end

--将对象添加到父物体下
function CommonHelp.AddToParentGameObject(targetObj,parentObj,IsMaxPos)
	targetObj.transform.parent=parentObj.transform
	if IsMaxPos ~= nil then
		targetObj.transform.localPosition=CommonHelp.MaxPos
	else
		targetObj.transform.localPosition=Vector3.zero
	end
	targetObj.transform.localScale=Vector3.one
end

function CommonHelp.IsShowPanel(index,PanelList,isdisplay,isGameObject,isMultiple)
	local show=isdisplay
	for i=1,#PanelList do
		if i==index then
			show=isdisplay
		else
			show=(not isdisplay)
		end
		
		local Obj=nil
		if isGameObject==false then
			Obj=PanelList[i].gameObject
		else
			Obj=PanelList[i]
		end
				
				
		if isMultiple  then
			if show==isdisplay then	
				Obj:SetActive(show)
				return	
			end
		else
			Obj:SetActive(show)
		end
		
	end
end



--获得随机数
function CommonHelp.GetRandom()
	return math.random(GameDefine.SHZ_CommonVar.ItemMin,GameDefine.SHZ_CommonVar.ItemMax-1)
end

function CommonHelp.GetRandomTwo(params1,params2)
	return math.random(params1,params2)
end

--查看表中是否包含指定的key
function CommonHelp.IsHaveKeyForDic(key,dic)
	for k,v in pairs(dic) do
		if k==key then
			return true		
		end
	end
	return false
end


--查看数组中是否包含相同的值
function CommonHelp.IsHaveValueForDic(targetObj,dic)
	if #dic<1 then
		return false
	end
	
	for i=1,#dic do
		if targetObj==dic[i] then
			return true
		end
	end
	return false
end

--根据key获取值
function CommonHelp.GetIndex(key,list)
	for k,v in pairs(list) do
		if key==k then
			return v
		end
	end
	return false

end


--添加更新
function CommonHelp.AddUpdate(self)
	RenderMgr.Add(function ()
		self:Update()
		end,self.updateName)
	--添加到移除列表中
	GameController.GetInstance():AddDeleteUpdateList(self.updateName)
end

function CommonHelp.RemoveUpdate(keyName)
	RenderMgr.Remove(keyName)
end


--根据服务端数据设置客户端的分数
function CommonHelp.SetScore(score)
	return NumberFormat(HallGoldRateSToC(score))
end

function CommonHelp.SetNumberFormatScore(score)
	return NumberFormat(HallGoldRateSToC(score))
end

function CommonHelp.SetNumberThousandsFormatScore(score)
	return NumberThousandsFormat(HallGoldRateSToC(score))
end


-----设置Sprite的三原色
function CommonHelp.SetSpriteColor(sprite,color )
	
	if sprite then
		sprite.color = color
	end
end

--重置UISpriteAnimation
function CommonHelp.ResetUISpriteAnimation(anim)
	anim.enabled = true
	anim:ResetToBeginning()
end


--倒序交换值
function CommonHelp.SwapIndex(list)
	local count=#list
	local count1,count2=math.modf(count/2)
	for i=1,count1 do
		local tempdata=list[i]
		list[i]=list[count+(1-i)]
		list[count+(1-i)]=tempdata
	end

	return list
end

function CommonHelp.ResumePlayBGAudio()
	AudioManager.GetInstance():ResumePlayBGAudio()
end

function CommonHelp.PlayAudio(audioInfo,isloop)
	AudioManager.GetInstance():PlayAudio(audioInfo,isloop)
end

function CommonHelp.StopAudio(audioInfo)
	AudioManager.GetInstance():StopAudio(audioInfo)
end

function CommonHelp.PlayBGAudio(audioInfo)
	AudioManager.GetInstance():PlayBGAudio(audioInfo)
end

function CommonHelp.PlayBGAudio1(audioInfo,isloop)
	AudioManager.GetInstance():PlayBGAudio1(audioInfo,isloop)
end

function CommonHelp.StopBgMusic()
	AudioManager.GetInstance():StopBgMusic()
end

function CommonHelp.StopAllAudio()
	AudioManager.GetInstance():StopAllAudio()
end


function CommonHelp.CreateScripts(scrpits)
	require(scrpits)
end


function CommonHelp.Instantiate(gameID,name,path,gameObject,panelName,callBackFunc)
	local cb = function ( obj )
		local isLoadSuccess=false
		if obj~=nil and obj.Length>0 and obj[0] ~=nil then
			local prefab = obj[0]
			obj = GameObject.Instantiate(prefab)
			obj.name=panelName
			obj.transform.parent = gameObject.transform
			obj.transform.localScale = Vector3.one
			obj.transform.localPosition = Vector3.zero
			obj:SetActive(false)
			prefab = nil
			Resources:UnloadUnusedAssets()
			isLoadSuccess=true
		else
			isLoadSuccess=false
			print("游戏资源加载出错："..path)
		end
		if callBackFunc then
			callBackFunc(obj,isLoadSuccess)
		end
	end
	resMgr:LoadPrefabEx(gameID,path,name,cb)	
end





return CommonHelp

