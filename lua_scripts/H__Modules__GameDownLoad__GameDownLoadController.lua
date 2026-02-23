GameDownLoadController = GameDownLoadController or BaseClass(LuaController)

require"H/Modules/GameDownLoad/GameDownLoadView"
require"H/Modules/GameDownLoad/View/GameDownLoadPanel"

function GameDownLoadController:__init( ... )
	self.view = GameDownLoadView.New()
	self:AddEvent()
end

function GameDownLoadController:AddEvent()
	LuaEvent:AddEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self);
	LuaEvent:AddEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self);
end

function GameDownLoadController:RemoveEvent()
	LuaEvent:RemoveEventListener(EventName.UPDATE_PROGRESS, self.OnProgress,self);
	LuaEvent:RemoveEventListener(EventName.UPDATE_ALL_COMPLETED, self.OnDownCompleted,self);
end

function GameDownLoadController:SetPanelData(gameID,Text)
	if self.view == nil then return end
	self.view:SetPanelData(gameID,Text)
end

function GameDownLoadController:OnDownCompleted()
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.GameDownLoad)
end

function GameDownLoadController:OnProgress(context)
	if context==nil or context.m_data== nil then return end
	local left = context.m_data[0]
	local total = context.m_data[1]
	if self.view == nil then return end
	self.view:OnProgress(left,total)
end

function GameDownLoadController:GetInstance()
	if GameDownLoadController.instance == nil then
		GameDownLoadController.instance = GameDownLoadController.New()
	end
	return GameDownLoadController.instance
end

function GameDownLoadController:__delete( ... )
	self.view = nil
end
