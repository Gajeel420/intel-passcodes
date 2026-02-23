HallWithdrawModel=HallWithdrawModel or BaseClass(LuaModel)

function HallWithdrawModel:__init( ... )
    self.m_BankCard_UserName = nil
    self.m_BankCard_Num = nil
    self.m_BankCard_BankName = nil
    self.m_BankCard_BankBranchName = nil
end

function HallWithdrawModel:GetInstance( ... )
	if not HallWithdrawModel.instance then
		HallWithdrawModel.instance=HallWithdrawModel.New()
	end
	return HallWithdrawModel.instance
end

function HallWithdrawModel:__delete( ... )
	-- body
end

function HallWithdrawModel:GetUserName()
    return self.m_BankCard_UserName
end

function HallWithdrawModel:GetCardNum()
    return self.m_BankCard_Num
end

function HallWithdrawModel:GetBankName()
    return self.m_BankCard_BankName
end

function HallWithdrawModel:CheckIsHasBindBankCard()
    if self.m_BankCard_UserName == nil or self.m_BankCard_Num == nil or self.m_BankCard_BankName == nil then
        return false
    end

    return true
end