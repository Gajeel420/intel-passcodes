HallBankPasswordController = HallBankPasswordController or BaseClass(LuaController)

require"H/Modules/HallBankPassword/HallBankPasswordView"
require"H/Modules/HallBankPassword/View/HallBankPasswordPanel"

function HallBankPasswordController:__init( ... )
	self.view = HallBankPasswordView.New()
	self:RegistProto()
end


--监听验证银行密码返回
function HallBankPasswordController:RegistProto( )
	self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_PAYMENT_CHECK_BANK_PASSWD,"RspVerifyBankPassword")
end

function HallBankPasswordController:RspVerifyBankPassword(buffer)
	local msg = self:ParseMsg(NetworkDefine.RspVerifyBankPassword, buffer)
 	if msg.m_sResult == 0 then 
		if self.view then 
			self.view.panel:RspVerifyBankPassword()
		end
	else
		--密码失败		 
	    ServerBackPrompt(msg.m_sResult)
	end
end


function HallBankPasswordController:SetCheckUpCallBack( callBack )
	if self.view then
		self.view.panel:SetCheckUpCallBack( callBack )
	end
end


function HallBankPasswordController:GetInstance()
	if HallBankPasswordController.instance == nil then
		HallBankPasswordController.instance = HallBankPasswordController.New()
	end
	return HallBankPasswordController.instance
end

function HallBankPasswordController:__delete( ... )
	self.view = nil
end
