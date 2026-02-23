HallFortuneCookieController = HallFortuneCookieController or BaseClass(LuaController)

require"H/Modules/HallFortuneCookie/HallFortuneCookieView"
require"H/Modules/HallFortuneCookie/HallFortuneCookieModel"
require"H/Modules/HallFortuneCookie/HallFortuneCookieConst"
require"H/Modules/HallFortuneCookie/View/HallFortuneCookiePanel"

function HallFortuneCookieController:__init( ... )
	self.view = HallFortuneCookieView.New()
    self.model = HallFortuneCookieModel:GetInstance()

    self.updateName = "HallFortuneCookieController:Update"
    RenderMgr.Add(function () self:OnUpdate() end,self.updateName)
end

function HallFortuneCookieController:ClearData()
    self.model:ClearData()
end

function HallFortuneCookieController:OnUpdate()
    self.model:OnUpdate()
end

function HallFortuneCookieController:GetInstance()
	if HallFortuneCookieController.instance == nil then
		HallFortuneCookieController.instance = HallFortuneCookieController.New()
	end
	return HallFortuneCookieController.instance
end

function HallFortuneCookieController:__delete( ... )
	self.view = nil
    RenderMgr.Remove(self.updateName)
end