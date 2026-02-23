LoadModuleManager=BaseClass()

function LoadModuleManager:__init()
	self:InitData()
	self:InitView()

end


function LoadModuleManager:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	self.PrabEndName="prefab"
	self.ABEndName=".unity3d"
	self.ABPath="Phone/Prefab/Game/"

	
	self.IsPrecedeLoadAsset=true
	
	self.PrecedeLoadAsset={						--预加载列表
		GameDefine.ModuleName.Panel_Com,
		GameDefine.ModuleName.Panel_Line,
		GameDefine.ModuleName.Panel_Handsel,
		GameDefine.ModuleName.Panel_Tips,
		GameDefine.ModuleName.Panel_BigWin,
	}
	self.PrecedeLoadAssetCount=#self.PrecedeLoadAsset	--预加载资源总数
	
	self.ModuleList={							--模块列表
		[1]={IsLoad=false,IsLoading=false,Path="PanelComController"},
		[2]={IsLoad=false,IsLoading=false,Path="HelpPanelController"},
		[3]={IsLoad=false,IsLoading=false,Path="GameSetPanelController"},
		[4]={IsLoad=false,IsLoading=false,Path="HandselController"},
		[5]={IsLoad=false,IsLoading=false,Path="JackpotController"},
		[6]={IsLoad=false,IsLoading=false,Path="BigWinController"},
		[7]={IsLoad=false,IsLoading=false,Path="TriggerFreeGameController"},
		[8]={IsLoad=false,IsLoading=false,Path="TriggerFreeGameEffectController"},
		[9]={IsLoad=false,IsLoading=false,Path="FreeGamePanelController"},
		[10]={IsLoad=false,IsLoading=false,Path="SmallWinController"},
		[12]={IsLoad=false,IsLoading=false,Path="LinePanelController"},
		[13]={IsLoad=false,IsLoading=false,Path="TipsPanelController"},
		
	}
	
	self.ModuleLuaPath={
		[1]="/View/Panel_Com/PanelComController",
		[2]="/View/Panel_Help/HelpPanelController",
		[3]="/View/Panel_GameSet/GameSetPanelController",
		[4]="/View/Panel_Handsel/HandselController",
		[5]="/View/Panel_Jackpot/JackpotController",
		[6]="/View/Panel_BigWin/BigWinController",
		[7]="/View/Panel_TriggerFreeGame/TriggerFreeGameController",
		[8]="/View/Panel_TriggerFreeGameRun/TriggerFreeGameEffectController",
		[9]="/View/Panel_FreeGame/FreeGamePanelController",
		[10]="/View/Panel_SmallWin/SmallWinController",
		[12]="/View/Panel_Line/LinePanelController",
		[13]="/View/Panel_Tips/TipsPanelController",
	}
	
end


function LoadModuleManager:InitView()

end



function LoadModuleManager:InitPrecedeLoadModule()
	local count=#self.PrecedeLoadAsset
	if count>0 then
		for i=1,count do
			self:LoadAllocateModule(self.PrecedeLoadAsset[i])
		end
	end
end


function LoadModuleManager:LoadAllocateModule(index)
	local isLoad=self.ModuleList[index].IsLoad
	local isLoading=self.ModuleList[index].IsLoading
	if isLoad==false and isLoading==false then
		self.ModuleList[index].IsLoading=true
		local panelName=GameDefine.ModulePath[index]
		local name=panelName
		local path=self.ABPath..GameDefine.ModulePath[index]..self.ABEndName
		local ParentObj=self.gameUIManager.gameObject
		local gameId=self.controller.gameID
		local callBack=function (obj,isLoadSuccess)
			if isLoadSuccess then
				self:loadResourcesComplete(index,obj)
			else
				self.ModuleList[index].IsLoading=false
			end
			
		end
		CommonHelp.Instantiate(gameId,name,path,ParentObj,panelName,callBack)
	else
		print(GameDefine.ModulePath[index].."：模块以加载")
	end
	
end


function LoadModuleManager:loadResourcesComplete(index,obj)
	print("加载完成：",GameDefine.ModulePath[index])
	self:LoadModuleScripts(index,obj)
end


function LoadModuleManager:LoadModuleScripts(index,obj)
	local ModulePath=self.ModuleLuaPath[index]
	ModulePath=self.controller:AddGameScripts(ModulePath)
	CommonHelp.CreateScripts(ModulePath)
	_G[self.ModuleList[index].Path].New(index,obj)
	self.ModuleList[index].IsLoad=true
	
	self:PrecedeLoadAssetComplete()
end


function LoadModuleManager:PrecedeLoadAssetComplete()
	
	if self.IsPrecedeLoadAsset then
		self.PrecedeLoadAssetCount=self.PrecedeLoadAssetCount-1
		print(self.PrecedeLoadAssetCount)
		if self.PrecedeLoadAssetCount<=0 then
			print("资源加载完成开始游戏")
			self.IsPrecedeLoadAsset=false
			GameController.GetInstance():SendLoadResourceComplete()
		end
	end
	
	

	
end
