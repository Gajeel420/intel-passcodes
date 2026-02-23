PayItemVo=PayItemVo or BaseClass(LuaModel)

function PayItemVo:__init( ... )
	self.iID=0
	self.iType=0
	self.iGoodNum=0
	self.iGiveGold=0
	self.iRmbNum=0
	self.iIndex=0
end
function PayItemVo:InitVo(vo)
	if vo then
		for k,v in pairs(vo) do
			self[k]=v
		end
	end
end
function PayItemVo:__delete( ... )
	-- body
end