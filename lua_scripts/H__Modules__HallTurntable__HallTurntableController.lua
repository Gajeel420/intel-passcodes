HallTurntableController =  BaseClass(LuaController)
require"H/Modules/HallTurntable/HallTurntableView"
require"H/Modules/HallTurntable/HallTurnTableModel"
require"H/Modules/HallTurntable/View/HallTurntablePanel"

function HallTurntableController:__init( ... )
	self.view = HallTurntableView.New()
end


function HallTurntableController:ReqestLuckyWhellResult()
	LuaEvent:AddEventListener(EventName.LuckyWhellCallBack,self.ReuestLuckyWhellBack,self)
	HallTurnTableModel:GetInstance():RequestLuckyWheel(1)
end

function HallTurntableController:ReuestLuckyWhellBack()
	LuaEvent:RemoveEventListener(EventName.LuckyWhellCallBack,self.ReuestLuckyWhellBack,self)
	self.view.panel:RequestLuckyWhelBack()
end

function HallTurntableController:GetInstance()
	if HallTurntableController.instance == nil then
		HallTurntableController.instance = HallTurntableController.New()
	end
	return HallTurntableController.instance
end

function HallTurntableController:__delete( ... )
	HallTurntableController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end