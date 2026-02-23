HallGiftRecordController = HallGiftRecordController or BaseClass(LuaController)
require"H/Modules/HallGiftRecord/HallGiftRecordView"
require"H/Modules/HallGiftRecord/View/HallGiftRecordPanel"
require"H/Modules/HallGiftRecord/HallGiftRecordModel"
require"H/Modules/HallGiftRecord/View/UIRecordGrid"



function HallGiftRecordController:__init( ... )
	self.view = HallGiftRecordView.New()
	self.model = HallGiftRecordModel.New()
end

function HallGiftRecordController:GetInstance()
	if HallGiftRecordController.instance == nil then
		HallGiftRecordController.instance = HallGiftRecordController.New()
	end
	return HallGiftRecordController.instance
end

function HallGiftRecordController:__delete( ... )
	HallGiftRecordController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end