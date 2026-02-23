BigWinController=BaseClass()

local Instance=nil
function BigWinController:__init(index,obj)
	Instance=self
	self.ModuleIndex=index
	self.gameObject=obj
	self.ScriptsPathList={}
	self.LoadScriptsList={}
	self:AddScripts()
	self:InitData()
	self:InitScripts()
	self:InitInstance(obj)
	self:InitViewData()
	self:InitView()

end

function BigWinController:AddScripts()
	self.ScriptsPathList={
		"/View/Panel_BigWin/BigWin/BigWinPanel",
	}
end


function BigWinController:InitScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =self.controller:AddGameScripts(self.ScriptsPathList[i])
		CommonHelp.CreateScripts(LoadScripts)
	end
	
end


function BigWinController:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
end



--初始化
function BigWinController:InitInstance(obj)
	self.gameData.BigWinPanel=BigWinPanel.New(obj)
	
end

function BigWinController:InitViewData()

end


function BigWinController:InitView()
	self:IsShowPanel(false)
	--local winScoreData=self.gameData.WinScoreEffectData
	--self.gameData.BigWinPanel:SetWinScoreEffect(winScoreData[1],winScoreData[2],winScoreData[3],winScoreData[4])
end

function BigWinController:IsShowPanel(isdisplay)
	CommonHelp.SetActive(self.gameObject,isdisplay)
end



function BigWinController.GetInstance()
	return Instance
end