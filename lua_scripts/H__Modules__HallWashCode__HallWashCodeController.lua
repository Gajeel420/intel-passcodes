HallWashCodeController = HallWashCodeController or BaseClass(LuaController)
require"H/Modules/HallWashCode/HallWashCodeView"
require"H/Modules/HallWashCode/View/HallWashCodePanel"
require"H/Modules/HallWashCode/HallWashCodeModel"
require"H/Modules/HallWashCode/View/GiftComparisonTableView"
require"H/Modules/HallWashCode/View/GiftCommparisonTableItem"
require"H/Modules/HallWashCode/View/CodeComparisonTableView"
require"H/Modules/HallWashCode/View/CodeCommparisonTableItem"



function HallWashCodeController:__init( ... )
	self.view = HallWashCodeView.New()
	self.model = HallWashCodeModel.New()
end

function HallWashCodeController:GetInstance()
	if HallWashCodeController.instance == nil then
		HallWashCodeController.instance = HallWashCodeController.New()
	end
	return HallWashCodeController.instance
end

function HallWashCodeController:__delete( ... )
	HallWashCodeController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
end