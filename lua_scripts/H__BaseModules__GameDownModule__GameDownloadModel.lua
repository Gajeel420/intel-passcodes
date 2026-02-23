GameDownloadModel=GameDownloadModel or BaseClass(LuaModel)

function GameDownloadModel:__init()
	--正在下载的游戏列表
	self.m_nMaxDownload=3 --最大同时下载游戏最大数量
	self.m_tbGameDownloading={}
	self.m_tbCheckGameResApplying={}
	self.m_tbCheckGameResExtracting={} --游戏是否在解压中
	self.LastAutoDownLoadGameID = 0
	self:AddEvent()
end

function GameDownloadModel:AddEvent()
	LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED,self.UpdateAllCompeleted,self)
	LuaEvent:AddEventListener(EventName.UPDATE_PROGRESS,self.OnProgress,self)
	LuaEvent:AddEventListener(EventName.UPDATE_EXTRACT,self.OnExtract,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_CheckGameResCB,self.CSCheckGameResCallBack,self)
	LuaEvent:AddEventListener(EventName.CSTOLUA_DownLoadGameResCB,self.CSDownLoadGameResCallBack,self)
	self:AddEventListener(EventName.APPLY_GAMEDOWNLOAD,self.ApplyGameDownload,self)
	self:AddEventListener(EventName.APPLY_CHECKGAME_RES,self.ApplyCheckGameRes,self)
end

function GameDownloadModel:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.UPDATE_ALL_COMPLETED,self.UpdateAllCompeleted,self)
	LuaEvent:RemoveEventListener(EventName.UPDATE_PROGRESS,self.OnProgress,self)
	LuaEvent:RemoveEventListener(EventName.UPDATE_EXTRACT,self.OnExtract,self)
	LuaEvent:RemoveEventListener(EventName.CSTOLUA_CheckGameResCB,self.CSCheckGameResCallBack,self)
	LuaEvent:RemoveEventListener(EventName.CSTOLUA_DownLoadGameResCB,self.CSDownLoadGameResCallBack,self)
	self:RemoveEventListener(EventName.APPLY_GAMEDOWNLOAD,self.ApplyGameDownload,self)
	self:RemoveEventListener(EventName.APPLY_CHECKGAME_RES,self.ApplyCheckGameRes,self)
end

function GameDownloadModel:ApplyCheckGameRes(context)
	if context then
		local nApplyGameID=context[1]
		if self:CheckGameResApplying(nApplyGameID) then	return end
		if self:CheckGameDownloadApplying(nApplyGameID) then return end
		table.insert(self.m_tbCheckGameResApplying,nApplyGameID)
		VersionUpdateManager:StartCheckGameRes(nApplyGameID)
	end
end

function GameDownloadModel:CSCheckGameResCallBack( context )
	if context and context.m_data then
		local nGameID=context.m_data[0]
		local nState=context.m_data[1]
		self:RemoveGameResApplying(nGameID)
		self:DispatchEvent(EventName.APPLY_CHECKGAME_RES_CB,{nGameID,nState})
		-- if nSate==0 or nSate==1 then--需要下载
		-- 	DownLoadManager:StartDownloadGameRes(self.vo.gameID)
		-- elseif nSate==2 then--不用更新

		-- elseif nSate==110 then  --检测失败

		-- end	
	end
end

function GameDownloadModel:ApplyGameDownload(context)
	if context then
		local nApplyGameID=context[1]
		if self:CheckGameDownloadApplying(nApplyGameID) then
			local gameConfig=ConfigModuleModel:GetInstance():GetGameConfigByCID(nApplyGameID)
			local gameName=nApplyGameID
			local cc = ""
			if gameConfig then
				if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
					cc = "游戏下载中"
					gameName=gameConfig.strGameName
				else
					cc = " Game_Downloading"
					gameName = gameConfig.Ename
				end
			end
			UIManager:GetInstance():ShowNoteMessage(gameName..cc,nil,nil,1)
			return
		end
		if self:GetGameDownloadApplyingNum()<self.m_nMaxDownload then
			table.insert(self.m_tbGameDownloading,nApplyGameID)
			VersionUpdateManager:StartDownloadGameRes(nApplyGameID)
		else
			--提示超过最大下载
			UIManager:GetInstance():ShowNoteMessage("MoreZhenThreeGame");
		end
	end
end

function GameDownloadModel:CSDownLoadGameResCallBack(context)
	if context and context.m_data then
		local nGameID=context.m_data[0]
		self:RemoveGameDownloadApplying(nGameID)
	
		self:RemoveGameResApplying(nGameID)
		local gameConfig=ConfigModuleModel:GetInstance():GetGameConfigByCID(nGameID)
		local gameName=nGameID
		local cc = ""
		if gameConfig then
			if SystemSetting:GetInstance().CurrentLanguage == SystemSetting:GetInstance().LanguageType[1] then
				cc = "游戏下载失败"
				gameName=gameConfig.strGameName
			else
				cc = " Game_Download failed"
				gameName = gameConfig.Ename
			end
		end
		-- if gameConfig then
		-- 	gameName=gameConfig.strGameName
		-- end
		UIManager:GetInstance():ShowNoteMessage(gameName..cc,1,nil,1)
		self:DispatchEvent(EventName.UPDATE_ERROR,{nGameID})
		DownLoadFileManager.Instance:StopDownLoad(nGameID)--//清除下载
	end
end

--游戏资源下载完成
function GameDownloadModel:UpdateAllCompeleted(context)
	if context and context.m_data then
		local nGameID=context.m_data[0]
		self:RemoveGameDownloadApplying(nGameID)
		--广播消息
		print("游戏下载完成",nGameID)
		self:RemoveGameResApplying(nGameID)
		self:DispatchEvent(EventName.UPDATE_ALL_COMPLETED,{nGameID})
		if self.LastAutoDownLoadGameID == nGameID then
			self:StartAutoDownLoadGame()
		end
	end
end

--更新游戏下载进度
function GameDownloadModel:OnProgress(context)
	if context and context.m_data then
		local nGameID=context.m_data[2]
		local nTotal=context.m_data[1]
		local nDownCount=context.m_data[0]
		--广播消息
		self:DispatchEvent(EventName.UPDATE_PROGRESS,{nDownCount,nTotal,nGameID})
	end
end

--更新游戏解压进度
function GameDownloadModel:OnExtract(context)
	if context and context.m_data then
		local nGameID=context.m_data[2]
		local nTotal=context.m_data[1]
		local nDownCount=context.m_data[0]
		--广播消息
		self:DispatchEvent(EventName.UPDATE_EXTRACT,{nDownCount,nTotal,nGameID})
	end
end

function GameDownloadModel:CheckGameResApplying( gameID )
	if self.m_tbCheckGameResApplying then
		for k,v in pairs(self.m_tbCheckGameResApplying) do
			if v then
				if tonumber(v)==tonumber(gameID) then
					return true
				end
			end
			
		end
	end
	return false
end

function GameDownloadModel:RemoveGameResApplying( gameID )
	if self.m_tbCheckGameResApplying then
		for k,v in pairs(self.m_tbCheckGameResApplying) do
			if tonumber(v)==tonumber(gameID) then
				self.m_tbCheckGameResApplying[k]=nil
				return
			end
		end
	end
end

function GameDownloadModel:GetGameDownloadApplyingNum()
	local nNum=0
	if self.m_tbGameDownloading then
		for k,v in pairs(self.m_tbGameDownloading) do
			if v then
				nNum=nNum+1
			end
		end
	end
	return nNum
end

function GameDownloadModel:CheckGameDownloadApplying( gameID )
	if self.m_tbGameDownloading then
		for k,v in pairs(self.m_tbGameDownloading) do
			if tonumber(v)==tonumber(gameID) then
				UIManager:GetInstance():ShowNoteMessage("GameIsDownloading");
				return true
			end
		end
	end
	return false
end

function GameDownloadModel:RemoveGameDownloadApplying( gameID )
	if self.m_tbGameDownloading then
		for k,v in pairs(self.m_tbGameDownloading) do
			if tonumber(v)==tonumber(gameID) then
				self.m_tbGameDownloading[k]=nil
				return
			end
		end
	end
end

--检测是否正在安装中
function GameDownloadModel:CheckGameResExtracting( gameID )
	return self.m_tbCheckGameResExtracting[gameID]~=nil
end
function GameDownloadModel:RemoveGameResExtracting( gameID )
	self.m_tbCheckGameResExtracting[gameID]=nil
end

---自动下载游戏
function GameDownloadModel:StartAutoDownLoadGame()
	local count = #ConfigModuleModel:GetInstance().ListAutoDownLoadID
	if count > 0 then
		self.LastAutoDownLoadGameID = ConfigModuleModel:GetInstance().ListAutoDownLoadID[1]
		table.remove(ConfigModuleModel:GetInstance().ListAutoDownLoadID,1 )
		local fileName = StringFormat("{0}{1}/version.xml",PathDefine.AssetBundlePath(),self.LastAutoDownLoadGameID)
		if not  LuaHelperUtil.FileExits(fileName) then
			LuaEvent:DispatchEvent(EventName.StartAutoDownLoadByGameID,self.LastAutoDownLoadGameID)
		end
	end
end

function GameDownloadModel:GetInstance()
	if GameDownloadModel.instance==nil then 
		GameDownloadModel.instance=GameDownloadModel.New()
	end
	return GameDownloadModel.instance
end

function GameDownloadModel:__delete()
	self:RemoveEvent()
end