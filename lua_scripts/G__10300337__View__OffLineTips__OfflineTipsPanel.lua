OfflineTipsPanel=BaseClass()

function OfflineTipsPanel:__init(gameObj)

	self.gameObject=gameObj
	self:InitData()
	self:InitView()
	
end


function OfflineTipsPanel:InitData()
	self.gameData=GameUIManager.GetInstance().GameData  
	
end



function OfflineTipsPanel:InitView()
	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
	
end


function OfflineTipsPanel:InitUIViewData()

	
	
end

function OfflineTipsPanel:FindView()
	local tf=self.gameObject.transform
	
end


function OfflineTipsPanel:InitUIView()
	CommonHelp.SetActive(self.gameObject,false)
end


function OfflineTipsPanel:IsShowOffLineTips(isDisplay)
	if isDisplay then
		if UIManager:GetInstance():IsShowPanel(UIPanelDefine.EWndID.MessageBox) then
			return
		end
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.NetWorkMsg)
	else
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	end
end