HallPlayerInfoController = HallPlayerInfoController or BaseClass(LuaController)

require"H/Modules/HallPlayerInfo/HallPlayerInfoView"
require"H/Modules/HallPlayerInfo/View/HallPlayerInfoPanel"
require"H/Modules/HallPlayerInfo/View/ModifyHeadPortPanel"

function HallPlayerInfoController:__init( ... )
	self.view = HallPlayerInfoView.New()
	self:AddEvent()
end



--事件监听
function HallPlayerInfoController:AddEvent( )
	LuaEvent:AddEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
end

function HallPlayerInfoController:RemoveEvent( )
	LuaEvent:RemoveEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
end


function HallPlayerInfoController:RefreshPanelData( )
	print("这里要刷新一下个人信息",self.view.panel)
	if self.view and self.view.panel then
		self.view.panel:SetUserData()
	end
end


function HallPlayerInfoController:GetInstance()
	if HallPlayerInfoController.instance == nil then
		HallPlayerInfoController.instance = HallPlayerInfoController.New()
	end
	return HallPlayerInfoController.instance
end

function HallPlayerInfoController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end
