HallRegisteredGiftGoldController = HallRegisteredGiftGoldController or BaseClass(LuaController)

require"H/Modules/HallRegisteredGiftGold/HallRegisteredGiftGoldModel"
require"H/Modules/HallRegisteredGiftGold/HallRegisteredGiftGoldView"
require"H/Modules/HallRegisteredGiftGold/View/HallRegisteredGiftGoldPanel"


function HallRegisteredGiftGoldController:__init( ... )
	self.view = HallRegisteredGiftGoldView.New()
	self.model = HallRegisteredGiftGoldModel.GetInstance()
	self:AddEvent()
end

function HallRegisteredGiftGoldController:GetInstance()
	if HallRegisteredGiftGoldController.instance == nil then
		HallRegisteredGiftGoldController.instance = HallRegisteredGiftGoldController.New()
	end
	return HallRegisteredGiftGoldController.instance
end

--事件添加
function HallRegisteredGiftGoldController:AddEvent( )
	
end



function HallRegisteredGiftGoldController:RemoveEvent( )
	
end


function HallRegisteredGiftGoldController:__delete( ... )
	self.view = nil
	self:RemoveEvent()
end
