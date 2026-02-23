LuaController = LuaController or BaseClass()

function LuaController:__init( )
	
end

function LuaController:RegistProtocal(protocal,handleName)
	if handleName then 
		if not self[handleName] then 
			print(StringFormat("没有初始化协议处理器---------------->>>>>>>>>>>>>>>>>>>>>: function Ctrl:%s(buffer)"),handleName)
			return
		end
		local function handle(buffer)
			self[handleName](self,buffer)
		end
		Network.RegistProtocal(protocal,handle)
	end
end

function LuaController:RemoveProtocal(protocal,handleName)
	Network.RemoveProtocal(protocal,handleName)
end

function LuaController:ParseMsg(msgStruct,buffer)
	return Network.ParseMsg(msgStruct,buffer)
end

function LuaController:__delete( )

	Resources:UnloadUnusedAssets()
end