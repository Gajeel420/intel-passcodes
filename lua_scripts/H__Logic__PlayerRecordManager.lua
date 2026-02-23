PlayerRecordManager = PlayerRecordManager or BaseClass()

function PlayerRecordManager:__init()
	self.RoomCardDataFileName = "roomcardlist.fghy";--//房卡记录文件名称
    self.RoomCardResultDataFileName = "roomcardresult.fghy";--//汇总记录文件名称
    self.RoomCardGameResultDataFileName = "gameresultrecord.fghy";--/-/单局游戏记录文件名称
    self.mRoomCardDataList={}   --房卡记录
    self.mRoomCardResultDic={}  --汇总记录
    self.mRoomCardGameResultDic={}  --单局游戏记录
    self.RecordAalidTime=24 --记录有效时间（小时）
    self.RecordMaxCount=10	--记录条数显示

end

--保存房卡列表
function PlayerRecordManager:SaveRoomCardData(roomCardData)
	local targetDir=StringFormat("{0}/recorddata/{1}",PathDefine.GetPersistentDataPath,PlayerInfoController:GetInstance().model.mainPlayer)
	-- local targetDir = PathDefine.GetPersistentDataPath.."/recorddata/"..PlayerInfoController:GetInstance().model.mainPlayer
	if not FileMgr.FileExists(targetDir) then
		LuaHelperUtil.CreateDir(targetDir)
	end
	local path=StringFormat("{0}/{1}",targetDir,"roomcardlist.fghy")
	local roomCardData = {}
	roomCardData.roomcardid=22334
	roomCardData.createtime = os.time()
	roomCardData.ownid = 0
	roomCardData.gameid = 0
	roomCardData.roomid = 0
	roomCardData.deskid = 0
	self:AddRoomCardData(roomCardData)
	local roomCardData1 = {}
	roomCardData1.createtime = os.time()
	roomCardData1.ownid = 0
	roomCardData1.gameid = 0
	roomCardData1.roomid = 0
	roomCardData1.deskid = 0
	roomCardData1.roomcardid = 22335
	self:AddRoomCardData(roomCardData1)
	local roomCardData2 = {}
	roomCardData2.createtime = os.time()
	roomCardData2.ownid = 0
	roomCardData2.gameid = 0
	roomCardData2.roomid = 0
	roomCardData2.deskid = 0
	roomCardData2.roomcardid = 22337
	self:AddRoomCardData(roomCardData2)

	self:SaveRoomCard(path)
	-- FileMgr.WriteFileLine( path,roomCardData )
	if FileMgr.FileExists(path) then
		
	else

	end
end


function PlayerRecordManager:AddRoomCardData(data)
	-- body
	if(self.mRoomCardDataList == nil) then
		self.mRoomCardDataList = {}
	end 
	self.mRoomCardDataList[data.roomcardid] = data
end

function PlayerRecordManager:SaveRoomCard(path)
	-- body
	if(self.mRoomCardDataList ~= nil and path ~= nil) then
		FileMgr.WriteFileLine( path,self.mRoomCardDataList )
	end
end

function PlayerRecordManager:GetRoomCardData(fielPath)
	-- body
	local str = FileMgr.ReadFile(fielPath)
	if(str ~= nil) then
		return StringToTable(str)
	end
end

--创建roomcarddata条目
function PlayerRecordManager:CreateRoomCardElement(roomCardData)
	local roomcardid=roomCardData.roomcardid or 0
	local createtime = roomCardData.createtime or 0
	local ownid = roomCardData.ownid or 0
	local gameid = roomCardData.gameid or 0
	local roomid = roomCardData.roomid or 0
	local deskid = roomCardData.deskid or 0
end
-- PlayerRecordManager.SaveRoomCardData(PlayerRecordManager)
function PlayerRecordManager:SaveGameSingleResult()
	
end

function PlayerRecordManager:__delete()
	-- body
end

function PlayerRecordManager:GetInstance()
	if PlayerRecordManager.instance == nil then
		PlayerRecordManager.instance = PlayerRecordManager.New()
	end
	return PlayerRecordManager.instance
end
-- [385241]={createtime=0,ownid=0,gameid=0,roomid=0,deskid=0}     --roomcardlist