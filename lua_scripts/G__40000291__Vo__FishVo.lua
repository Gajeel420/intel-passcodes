FishVo=BaseClass(LuaModel)

function FishVo:__init(index)
	self.fishKind=0
	self.uid=0
	self.FishKindGroup1=0
	self.FishKindGroup2=0
	self.FishKindGroup3=0
	self.FishKindGroup4=0
	self.FishKindGroup5=0
	self.TraceId = 0
	self.StartPointIndex = 0
	self.OffsetIndex = 0
	self.fishConfig={}
	self.showTime=0
	self.eulerAngles=Vector3.zero
	self.localEulerAngles=Vector3.zero
end

function FishVo:InitVo(vo)
	if vo then
		for k,v in pairs(vo) do
			self[k]=v
		end
	end
end

function FishVo:UpdateVo(data)
	for k,v in pairs(data) do
		if type(v)~="function" and k~="_class_type" then
			if type(v)=="boolean" then
				self:SetValue(k,v,self[k])
			else
				if self[k] then
					self:SetValue(k,v,self[k])
				end
			end
		end
	end
end

function FishVo:SetValue(k,v,old)
	if self[k] ~=v then
		self[k]= v
		-- self:DispatchEvent(GameLuaConst.EventName_UpdateFishVo,{k,v,old})
	end
end

function FishVo:__delete()
	self.fishKind=nil
	self.uid=nil
	self.FishKindGroup1=nil
	self.FishKindGroup2=nil
	self.FishKindGroup3=nil
	self.FishKindGroup4=nil
	self.FishKindGroup5=nil
	self.TraceId = nil
	self.StartPointIndex = nil
	self.OffsetIndex = nil
	self.fishConfig=nil
	self.showTime=nil

end