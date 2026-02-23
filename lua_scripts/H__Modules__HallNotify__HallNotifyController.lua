HallNotifyController = HallNotifyController or BaseClass(LuaController)

require"H/Modules/HallNotify/HallNotifyView"
require"H/Modules/HallNotify/HallNotifyModel"
require"H/Modules/HallNotify/View/HallNotifyPanel"
require"H/Modules/HallNotify/Vo/HallNotifyVo"
require"H/Modules/HallNotify/View/HallNotifyScrollPanel"
require"H/Modules/HallNotify/View/HallTopScoreView"
require"H/Modules/HallNotify/View/HallTopScoreItem"

function HallNotifyController:__init( ... )
	self.model = HallNotifyModel:GetInstance()
	self:GetNotifyDisPlayCount()
	self.view = HallNotifyView.New()
	self:AddEvent()
end

--公告（跑马灯）信息返回（服务器自动推送不需发送请求）
function HallNotifyController:AddEvent( )
	NotifyModuleModel:GetInstance():AddEventListener(NotifyModuleConst.EventName_AddNotify,self.AddNotify,self)
	LuaEvent:AddEventListener(EventName.GameNotRunMarquee,self.GameNotRunMarquee,self)
end

function HallNotifyController:RemoveEvent( )
	NotifyModuleModel:GetInstance():RemoveEventListener(NotifyModuleConst.EventName_AddNotify,self.AddNotify,self)
	LuaEvent:RemoveEventListener(EventName.GameNotRunMarquee,self.GameNotRunMarquee,self)
end

function HallNotifyController:GameNotRunMarquee(content)
	if content.m_data[0] ~= nil then
		ConfigModuleModel.GetInstance().GameSceneDisplayHallNotify = tonumber(content.m_data[0]) == 1
		if not ConfigModuleModel.GetInstance().GameSceneDisplayHallNotify then
			self.model.mNotifyList = {}
			
			UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.HallNotify)
		end
    end
end

function HallNotifyController:AddNotify(list)

	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa跑马灯    ")
	pt(list)
	if (not (ConfigModuleModel.GetInstance().GameSceneDisplayHallNotify)) then
		
		return 
	end

	if list.m_unTime > 0 and ConfigInfoMgr.ChannelID ~= list.m_unTime then
		print("渠道号不一样",ConfigInfoMgr.ChannelID,list.m_unTime)
		
		return
	end

	local msg = list
	if not msg then
	
		return 
	end
	local tempStr = list.m_szContent
	local list = StringSplit(tempStr, "|")
	
	if #list == 2 then
		if self:HasThisGame(tonumber(list[1])) then
			
			msg.m_szContent = list[2]
			self.model:AddNotifyList(msg)
			if self.view then
				self.view.panel:OpenHallNotifyPanel()
			end
		end
	else
		
		self.model:AddNotifyList(msg)
		if self.view then
			self.view.panel:OpenHallNotifyPanel()
		end
	end	
end

function HallNotifyController:HasThisGame(gameID)
	local data = ConfigModuleModel.GetInstance().ListGameServiceID[gameID]
	return data ~= nil 
end

function HallNotifyController:GetNotifyDisPlayCount( ... )
	-- body
	self.model.disPlayCount = ConfigModuleModel.GetInstance().PaoMaDengDisplayCount
end


function HallNotifyController:GetInstance()
	if HallNotifyController.instance == nil then
		HallNotifyController.instance = HallNotifyController.New()
	end
	return HallNotifyController.instance
end


function HallNotifyController:__delete( ... )

end
