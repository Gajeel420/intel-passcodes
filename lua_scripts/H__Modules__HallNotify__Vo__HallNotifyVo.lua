HallNotifyVo = HallNotifyVo or BaseClass()
function HallNotifyVo:__init( data )
	self:InitVo(data)
end

--更新数据
function HallNotifyVo:InitVo( data )
	if (data == nil) then return end
    self.m_unId = data["m_unId"] --公告ID
    self.m_unTime = data["m_unTime"] --公告发布时间
    self.m_ucType = data["m_ucType"] --公告类型
    self.m_usLength = data["m_usLength"] --公告长度
    self.m_szContent = data["m_szContent"] --公告内容
end


function HallNotifyVo:__delete()
	self.m_unId = nil
	self.m_unTime = nil
	self.m_ucType = nil
	self.m_usLength = nil
	self.m_szContent = nil
end