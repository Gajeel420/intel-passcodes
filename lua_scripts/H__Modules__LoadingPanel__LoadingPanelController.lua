LoadingPanelController = LoadingPanelController or BaseClass(LuaController)

-- require"Modules/LoadingPanel/LoginPanelModel"
require"H/Modules/LoadingPanel/LoadingPanelView"
require"H/Modules/LoadingPanel/View/LoadingPanel"

function LoadingPanelController:__init( )
	self.view = LoadingPanelView.New()
	self:AddEvent()

end

function LoadingPanelController:AddEvent()
	-- LuaEvent:AddEventListener(EventName.LOADER_START_PRELOAD,self.StartPreLoad,self) --
	LuaEvent:AddEventListener(EventName.PRELOADER_COMPLETED,self.PreLoadCompleted,self) --
	LuaEvent:AddEventListener(EventName.SetGameStateCompeleted,self.PreLoadCompleted,self) --
	LuaEvent:AddEventListener(EventName.LoadingPanelProgress ,self.LoaingPanleProgressVale,self) --
	-- LuaEvent:AddEventListener(EventName.LOADER_ALL_COMPLETED, self.OnAllCompleted,self)
end

function LoadingPanelController:RemoveEvent()
	-- LuaEvent:RemoveEventListener(EventName.LOADER_START_PRELOAD,self.StartPreLoad,self) --
	LuaEvent:RemoveEventListener(EventName.PRELOADER_COMPLETED,self.PreLoadCompleted,self) --
	LuaEvent:RemoveEventListener(EventName.SetGameStateCompeleted,self.PreLoadCompleted,self) --
	LuaEvent:RemoveEventListener(EventName.LoadingPanelProgress ,self.LoaingPanleProgressVale,self) --
	-- LuaEvent:RemoveEventListener(EventName.LOADER_START_PRELOAD,self.StartPreLoad,self) --
end

function LoadingPanelController:LoaingPanleProgressVale(value)
	if self.view and self.view.panel ~=nil and self.view.panel.isInited then
		self.view.panel:LoadingProgressValue(value.m_data[0])
	end
end

function LoadingPanelController:StartPreLoad(context)
	if self.view and self.view.panel ~=nil and self.view.panel.isInited then
		self.view.panel:StartPreLoad(context)
	end
end

function LoadingPanelController:PreLoadCompleted()

	if self.view and self.view.panel ~=nil and self.view.panel.isInited then
		self.view.panel:PreLoadCompleted()
	end
end

function LoadingPanelController:OnAllCompleted( ... )
	if self.view then
		self.view:HidePanel()
	end
end

function LoadingPanelController:GetInstance()
	if LoadingPanelController.instance == nil then
		LoadingPanelController.instance = LoadingPanelController.New()
	end
	return LoadingPanelController.instance
end

function LoadingPanelController:__delete( ... )
	LoadingPanelController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
	self:RemoveEvent()
end