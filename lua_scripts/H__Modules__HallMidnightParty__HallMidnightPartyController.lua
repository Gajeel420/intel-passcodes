HallMidnightPartyController = HallMidnightPartyController or BaseClass(LuaController)

require"H/Modules/HallMidnightParty/HallMidnightPartyView"
require"H/Modules/HallMidnightParty/HallMidnightPartyModel"
require"H/Modules/HallMidnightParty/View/HallMidnightPartyPanel"

function HallMidnightPartyController:__init( ... )
	self.view = HallMidnightPartyView.New()
    self.model = HallMidnightPartyModel:GetInstance()

    self.updateName = "HallMidnightPartyController:Update"
    RenderMgr.Add(function () self:OnUpdate() end,self.updateName)
end

function HallMidnightPartyController:ClearData()
    self.model:ClearData()
end

function HallMidnightPartyController:OnUpdate()
    self.model:OnUpdate()
end

function HallMidnightPartyController:GetInstance()
	if HallMidnightPartyController.instance == nil then
		HallMidnightPartyController.instance = HallMidnightPartyController.New()
	end
	return HallMidnightPartyController.instance
end

function HallMidnightPartyController:__delete( ... )
	self.view = nil
    RenderMgr.Remove(self.updateName)
end