GameObjectPool=BaseClass()

local instance=nil
function GameObjectPool:__init()
	instance=self
	
	self:InitData()

end

--初始化数据
function GameObjectPool:InitData()
	self.gameObjectPoolList={}		--游戏对象池列表
	self.m_AllItem = {}
end

function GameObjectPool:InitGameObjectPoolData(gameObj,keyName)
	--print("添加到池中的名字：",gameObj.name)
	if keyName == nil then
		keyName=gameObj.name
	end

	if not self:FindIsHaveKey(keyName) then
		self.gameObjectPoolList[keyName]={}		
	end	

	self.m_AllItem[keyName] = gameObj
end

function GameObjectPool:InitGameObjectPool(count)
	for key, value in pairs(self.m_AllItem) do
		self:AddGameObjectPool(value,count,key)
	end
end

--添加到游戏对象池中
function GameObjectPool:AddGameObjectPool(gameObj,number,keyName)
	if keyName == nil then
		keyName=gameObj.name
	end
	
	for i=1,number do
		local tempObj=GameObject.Instantiate(gameObj)
		tempObj.name=keyName
		if tempObj.activeSelf == false then
			tempObj:SetActive(true)
		end
		CommonHelp.AddToParentGameObject(tempObj,GameUIManager.GetInstance().GameData.GameObjectInstanceParent,true)
		table.insert(self.gameObjectPoolList[keyName],tempObj)
	end
	
end

--获取可用的游戏对象
function GameObjectPool:GetGameObject(gameObjName)
	if self:FindIsHaveKey(gameObjName) then
		local tempObj=self:GetActiveGameObject(gameObjName)
		if tempObj~=nil then
			return tempObj
		else
			-- print("keyName值不够使用",gameObjName)
			local prefab = self:GetItemPrefabs(gameObjName)
			self:AddGameObjectPool(prefab,2,gameObjName)
			return self:GetActiveGameObject(gameObjName)
		end

	end
end

function GameObjectPool:GetItemPrefabs(gameObjName)
	if self.m_AllItem[gameObjName] ~= nil then
		return self.m_AllItem[gameObjName]
	end

	return nil
end

--查找是否包含Key
function GameObjectPool:FindIsHaveKey(keyName)
	return CommonHelp.IsHaveKeyForDic(keyName,self.gameObjectPoolList)
end


--将不用的回收到对象池中--将对象设置为false
function GameObjectPool:ReCycleToGameObject(gameObj)
	-- CommonHelp.SetActive(gameObj,false)
	CommonHelp.AddToParentGameObject(gameObj,GameUIManager.GetInstance().GameData.GameObjectInstanceParent,true)
	table.insert(self.gameObjectPoolList[gameObj.name],gameObj)
	
end


--查找池中是否包含还有未激活的游戏对象,有则返回
function GameObjectPool:GetActiveGameObject(keyName)
	if #self.gameObjectPoolList[keyName] > 0 then
		local go = self.gameObjectPoolList[keyName][1]
		table.remove(self.gameObjectPoolList[keyName],1)
		return go
	end
	return nil
end






function GameObjectPool:GetInstance()
	return instance
end


return GameObjectPool