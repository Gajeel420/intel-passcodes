HallCashBackController = HallCashBackController or BaseClass(LuaController)

require"H/Modules/HallCashBack/HallCashBackView"
require"H/Modules/HallCashBack/HallCashBackModel"
require"H/Modules/HallCashBack/View/HallCashBackPanel"
require"H/Modules/HallCashBack/View/CashBackRecordItem"
require"H/Modules/HallCashBack/View/CashBackRecordView"
require"H/Modules/HallCashBack/View/CashBackItem"



function HallCashBackController:__init( ... )
	self.view = HallCashBackView.New()
    self.model = HallCashBackModel:GetInstance()

    self.updateName = "HallCashBackController:Update"
    RenderMgr.Add(function () self:OnUpdate() end,self.updateName)
end

function HallCashBackController:ClearData()
    self.model:ClearData()
end

function HallCashBackController:OnUpdate()
    self.model:OnUpdate()
end

function HallCashBackController:GetInstance()
	if HallCashBackController.instance == nil then
		HallCashBackController.instance = HallCashBackController.New()
	end
	return HallCashBackController.instance
end

function HallCashBackController:__delete( ... )
	self.view = nil
    RenderMgr.Remove(self.updateName)
end