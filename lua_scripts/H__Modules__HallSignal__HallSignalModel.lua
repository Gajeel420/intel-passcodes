HallSignalModel = HallSignalModel or BaseClass(LuaModel)

function HallSignalModel:__init( ... )
	
end

function HallSignalModel:GetInstance()
	if HallSignalModel.instance == nil then
		HallSignalModel.instance = HallSignalModel.New()
	end
	return HallSignalModel.instance
end

function HallSignalModel:__delete( ... )
end
