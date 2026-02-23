LinePanelController=BaseClass()

local Instance=nil
function LinePanelController:__init(index,obj)
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

function LinePanelController:AddScripts()
	self.ScriptsPathList={
		"/View/Panel_Line/Line/LinePanel",
		"/View/Panel_Line/Line/LineItem",
		"/View/Panel_Line/Line/LineManager",
	}
end


function LinePanelController:InitScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =self.controller:AddGameScripts(self.ScriptsPathList[i])
		CommonHelp.CreateScripts(LoadScripts)
	end
	
end


function LinePanelController:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	
end



--初始化
function LinePanelController:InitInstance(obj)
	self.gameData.LineItem=LineItem
	self.gameData.LineManager=LineManager.New()
	self.gameData.LinePanel=LinePanel.New(obj)
	
end

function LinePanelController:InitViewData()
	
end


function LinePanelController:InitView()
	self.gameData.LineManager:CreateLineIns()
	self:IsShowPanel(true)
end

function LinePanelController:IsShowPanel(isdisplay)
	CommonHelp.SetActive(self.gameObject,isdisplay)
end




function LinePanelController.GetInstance()
	return Instance
end