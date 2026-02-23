HallRoomPanelController = HallRoomPanelController or BaseClass(LuaController)
require"H/Modules/HallRoomPanel/View/RoomView/Default/UIRoomGrid"
require"H/Modules/HallRoomPanel/View/RoomView/Default/RoomView_Default"
require"H/Modules/HallRoomPanel/View/RoomView/BuYu/RoomView_BuYu"
require"H/Modules/HallRoomPanel/View/RoomView/BuYu/Desk/SeatItem_BuYu"
require"H/Modules/HallRoomPanel/View/RoomView/BuYu/Desk/DeskItem_BuYu"
require"H/Modules/HallRoomPanel/View/RoomView/BuYu/RoomDeskView_BuYu"

require"H/Modules/HallRoomPanel/View/RoomView/LianXianJi/Desk/SeatItem_LianXianJi"
require"H/Modules/HallRoomPanel/View/RoomView/LianXianJi/Desk/DeskItem_LianXianJi"
require"H/Modules/HallRoomPanel/View/RoomView/LianXianJi/RoomDeskView_LianXianJi"
require"H/Modules/HallRoomPanel/View/RoomView/GameRoom/GameRoomview"
require"H/Modules/HallRoomPanel/View/RoomView/GameRoom/GameRoomItem"
require"H/Modules/HallRoomPanel/View/RoomView/GameRoomBuYu/GameRoomViewBuYu"
require"H/Modules/HallRoomPanel/View/RoomView/GameRoomBuYu/GameRoomBuYuItem"

require"H/Modules/HallRoomPanel/View/RoomView/Other/RoomView_Other"


require"H/Modules/HallRoomPanel/HallRoomPanelView"
require"H/Modules/HallRoomPanel/HallRoomPanelModel"
require"H/Modules/HallRoomPanel/Vo/LevelStruct"
require"H/Modules/HallRoomPanel/View/HallRoomPanelPanel"



function HallRoomPanelController:__init( ... )
	self.model = HallRoomPanelModel.GetInstance()
	self.view = HallRoomPanelView.New()
	self:RegistProto()
end

function HallRoomPanelController:RegistProto( )
	
	
end


function HallRoomPanelController:GetInstance()
	if HallRoomPanelController.instance == nil then
		HallRoomPanelController.instance = HallRoomPanelController.New()
	end
	return HallRoomPanelController.instance
end

function HallRoomPanelController:__delete( ... )
	print("bbbbbbbbbbbbbbbbbbbbbb11111111111111111111111111")
	self.view = nil
end
