TipsPanelController=BaseClass()

local Instance=nil
function TipsPanelController:__init(index,obj)
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

function TipsPanelController:AddScripts()
	self.ScriptsPathList={
		"/View/Panel_Tips/TipsAnim/TipsAnimPanle",
	}
end


function TipsPanelController:InitScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =self.controller:AddGameScripts(self.ScriptsPathList[i])
		CommonHelp.CreateScripts(LoadScripts)
	end
	
end


function TipsPanelController:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	
end



--初始化
function TipsPanelController:InitInstance(obj)
	self.gameData.TipsAnimPanle=TipsAnimPanle.New(obj)
end

function TipsPanelController:InitViewData()
	
end


function TipsPanelController:InitView()
	self:IsShowPanel(true)
end

function TipsPanelController:IsShowPanel(isdisplay)
	CommonHelp.SetActive(self.gameObject,isdisplay)
end




function TipsPanelController.GetInstance()
	return Instance
end