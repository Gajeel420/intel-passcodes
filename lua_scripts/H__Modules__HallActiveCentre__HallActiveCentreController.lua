HallActiveCentreController = HallActiveCentreController or BaseClass(LuaController)

require"H/Modules/HallActiveCentre/HallActiveCentreView"
require"H/Modules/HallActiveCentre/View/HallActiveCentrePanel"
require"H/Modules/HallActiveCentre/HallActiveCenterModel"
require"H/Modules/HallActiveCentre/View/HallActiveCenterItem"



function HallActiveCentreController:__init( ... )
	self.view = HallActiveCentreView.New()
	self.model = HallActiveCenterModel.New()
end

function HallActiveCentreController:GetInstance()
	if HallActiveCentreController.instance == nil then
		HallActiveCentreController.instance = HallActiveCentreController.New()
	end
	return HallActiveCentreController.instance
end




function HallActiveCentreController:ShowActiveCenterPanel(needNetWorkMessage)
	--self.model:GetActiveData(needNetWorkMessage)
end

function HallActiveCentreController:__delete( ... )
	self.view = nil
end
