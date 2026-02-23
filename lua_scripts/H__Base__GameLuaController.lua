
GameLuaController= GameLuaController or BaseClass(LuaController)

function GameLuaController:__init( )
	self.RequireList = {}
	self.model=nil
	self.view=nil
	self.gameID=0
	self.desk=nil
end

function GameLuaController:Init(obj )
	for i=1,#self.RequireList do
		require(self.RequireList[i])
	end
	-- self:AddEvent()
end

function GameLuaController:GameControllerUnRequire()
	local count = #self.RequireList
	for i=1, count do
		package.preload[self.RequireList[i]]=nil
		package.loaded[self.RequireList[i]]=nil
		local name = string.gsub(self.RequireList[i],"[%w]*/","")
		_G[name] = nil
	end
	
end

function GameLuaController:SendGameData( templetTable,dataTable, mainId,assistantID )
	local m_usGameID=self.desk.m_usGameID
	local m_usRoomID=self.desk.m_usRoomID
	local m_usDeskIndex=self.desk.m_usDeskIndex
	Net_SendGameData(templetTable, dataTable, mainId,assistantID, m_usGameID,m_usRoomID, m_usDeskIndex)
end

function GameLuaController:__delete( )
	print("GameLuaController:__delete( )")
	LuaManager:StopCoroutineLua()
	-- local name=StringFormat("G/{0}/GameController",self.gameID)
	-- print("name",name)
	-- package.loaded[name] = nil
	if self.view~=nil then
		self.view:Destroy()
	end
	self.view=nil
	if self.model~=nil then
		self.model:Destroy()
	end
	self.model=nil
	if GameModel then
		GameModel.instance=nil
	end
	self.gameID=0
	self:GameControllerUnRequire()
end