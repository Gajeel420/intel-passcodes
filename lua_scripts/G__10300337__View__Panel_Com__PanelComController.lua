PanelComController=BaseClass()

local Instance=nil
function PanelComController:__init(index,obj)
	print("创建PanelComController")
	Instance=self
	self.ModuleIndex=index
	self.gameObject=obj
	self.ScriptsPathList={}
	self.LoadScriptsList={}
	--print(obj)
	self:AddScripts()
	self:InitData()
	self:InitScripts()
	self:InitInstance(obj)
	self:InitViewData()
	self:InitView()

end

function PanelComController:AddScripts()
	self.ScriptsPathList={
		"/View/Panel_Com/PlayerInfo/PlayerInfoPanel",
		"/View/Panel_Com/Bet/GameBetSet",
		"/View/Panel_Com/Score/PlayerScorePanel",
		"/View/Panel_Com/GameSet/GameSetPanel",
		"/View/Panel_Com/GameControlBtn/StartControlBtn",
		"/View/Panel_Com/GameControlBtn/AutoControlBtn",
		"/View/Panel_Com/GameControl/GameControlManager",
	}
end


function PanelComController:InitScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =self.controller:AddGameScripts(self.ScriptsPathList[i])
		CommonHelp.CreateScripts(LoadScripts)
	end
	
end


function PanelComController:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	
end



--初始化
function PanelComController:InitInstance(obj)
	self.gameData.PlayerInfoPanel=PlayerInfoPanel.New(obj)
	self.gameData.GameBetSet=GameBetSet.New(obj)
	self.gameData.PlayerScorePanel=PlayerScorePanel.New(obj)
	self.gameData.GameSetPanel=GameSetPanel.New(obj)
	self.gameData.StartControlBtn=StartControlBtn.New(obj)
	self.gameData.AutoControlBtn=AutoControlBtn.New(obj)
	self.gameData.GameControlManager=GameControlManager.New()
	
end

function PanelComController:InitViewData()
	
end


function PanelComController:InitView()
	CommonHelp.SetActive(self.gameObject,true)
end


function PanelComController.GetInstance()
	return Instance
end