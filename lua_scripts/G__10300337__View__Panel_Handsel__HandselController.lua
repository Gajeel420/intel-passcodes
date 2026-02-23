HandselController=BaseClass()

local Instance=nil
function HandselController:__init(index,obj)
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

function HandselController:AddScripts()
	self.ScriptsPathList={
		"/View/Panel_Handsel/Handsel/HandselPanel",
		"/View/Panel_Handsel/Handsel/HandselItem",
		"/View/Panel_Handsel/Handsel/HandselManager",
	}
end


function HandselController:InitScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =self.controller:AddGameScripts(self.ScriptsPathList[i])
		CommonHelp.CreateScripts(LoadScripts)
	end
	
end


function HandselController:InitData()
	self.controller=GameController.GetInstance()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.GameData  
	
end



--初始化
function HandselController:InitInstance(obj)
	self.gameData.HandselPanel=HandselPanel.New(obj)
	self.gameData.HandselItem=HandselItem
	self.gameData.HandselManager=HandselManager.New()
end

function HandselController:InitViewData()
	self.gameData.HandselManager:InitHandselInstance()
	
end



function HandselController:InitView()
	self:IsShowPanel(true)
end

function HandselController:IsShowPanel(isdisplay)
	CommonHelp.SetActive(self.gameObject,isdisplay)
end


function HandselController:SetParent(parent)
	CommonHelp.AddToParentGameObject(self.gameObject,parent)
end


function HandselController.GetInstance()
	return Instance
end