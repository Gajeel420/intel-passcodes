HallServiceVo = HallServiceVo or BaseClass()
function HallServiceVo:__init( data )
	self:InitVo(data)
end

--更新数据
function HallServiceVo:InitVo( data )
	if (data == nil) then return end
	
    self.strServiceName = data["strServiceName"] --信息名称
    self.strServiceText = data["strServiceText"] --信息内容
end

function HallServiceVo:__delete()
	self.strServiceName = nil
	self.strServiceText = nil
end