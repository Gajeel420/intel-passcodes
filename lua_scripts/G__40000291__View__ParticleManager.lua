ParticleManager=BaseClass()

function ParticleManager:__init( ... )
	self.pssObjList={}
	self.destroyList=nil
	--self.isAlive=false
end
function ParticleManager:Update()
	if(self.destroyList~=nil) then
		for k,obj in pairs(self.destroyList) do
			self:RemoveParticleObj(obj)		
		end

		self.destroyList=nil
	end	
	
	for i=1,#self.pssObjList do
		local obj=self.pssObjList[i]
		local childList=obj:GetComponentsInChildren(typeof(ParticleSystem),true)
		local isAlive=false
		for i=0,childList.Length-1 do
			isAlive=childList[i]:IsAlive()
		end
		if not isAlive then
			if(self.destroyList==nil) then
				self.destroyList={}
			end
			table.insert(self.destroyList,obj) 
		end
	end
end
function ParticleManager:AddParticleObj(obj)
	table.insert(self.pssObjList,obj)
end
function ParticleManager:RemoveParticleObj(obj)
	for i=1,#self.pssObjList do
		if(self.pssObjList[i]==obj) then
			table.remove(self.pssObjList,i)
			break
		end
	end
	print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD")
	GameController:GetInstance().view:RecycleExplosive(obj.transform)
end
function ParticleManager:GetInstance( ... )
	if not self.instance then
		self.instance=ParticleManager.New()
	end
	return self.instance
end
function ParticleManager:__delete( ... )
	
end