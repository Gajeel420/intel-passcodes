HallBankSetPasswordController = HallBankSetPasswordController or BaseClass(LuaController)

require"H/Modules/HallBankSetPassword/HallBankSetPasswordView"
require"H/Modules/HallBankSetPassword/View/HallBankSetPasswordPanel"

function HallBankSetPasswordController:__init( ... )
	self.view = HallBankSetPasswordView.New()
end


--用户修改密码后返回函数
function HallBankSetPasswordController:UserChangeBankPassword()	
	if self.view then 
		self.view.panel:UserChangeBankPassword()
	end
end

function HallBankSetPasswordController:SetCheckUpCallBack( callBack )
	if self.view then
		self.view.panel:SetCheckUpCallBack( callBack )
	end
end


function HallBankSetPasswordController:GetInstance()
	if HallBankSetPasswordController.instance == nil then
		HallBankSetPasswordController.instance = HallBankSetPasswordController.New()
	end
	return HallBankSetPasswordController.instance
end

function HallBankSetPasswordController:__delete( ... )
	self.view = nil
end
