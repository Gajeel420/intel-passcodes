HallGameVo = HallGameVo or BaseClass()
function HallGameVo:__init( data )
	self:InitVo(data)
end

--金币游戏数据
function HallGameVo:InitVo( data )
	if (data == nil) then return end
    self.gameID = data["gameID"] --游戏ID
    self.gameName = data["gameName"] --游戏名字
    self.gameVersion = data["gameVersion"] --游戏版本号
    self.gameType = data["gameType"] --游戏类型 1 捕鱼 2 压分 3 棋牌
    self.packesize = data["packesize"] --包的大小   
end


function HallGameVo:__delete()
	self.gameID = nil
	self.gameName = nil
	self.gameVersion = nil
	self.gameType = nil
	self.packesize = nil
end