HallTopInfoController = HallTopInfoController or BaseClass(LuaController)

require"H/Modules/HallTopInfo/HallTopInfoView"
require"H/Modules/HallTopInfo/View/HallTopInfoPanel"

function HallTopInfoController:__init( ... )
	self.view = HallTopInfoView.New()
	self:AddEvent()
end

-- 跳转到下一个界面
function HallTopInfoController:GoToNextHallPanel(sourPanelID,dstPanelID)
	if self.view then
		self.view:GoToNextHallPanel(sourPanelID,dstPanelID)
	end
end

-- ResetAnimation
function HallTopInfoController:ResetAnimation()
	if self.view then
		self.view:ResetAnimation()
	end
end

function HallTopInfoController:GetInstance()
	if HallTopInfoController.instance == nil then
		HallTopInfoController.instance = HallTopInfoController.New()
	end
	return HallTopInfoController.instance
end

function HallTopInfoController:GetCurHallPanelTypeID( )
	if self.view~=nil then
		return self.view:GetCurHallPanelTypeID( )
	end
end

--事件监听
function HallTopInfoController:AddEvent( )
	
end

function HallTopInfoController:RemoveEvent( )
	
end



function HallTopInfoController:__delete( ... )
	HallTopInfoController.instance = nil
	if	self.view then
		self.view:Destroy()
	end
	self.view = nil
	self:RemoveEvent()
end