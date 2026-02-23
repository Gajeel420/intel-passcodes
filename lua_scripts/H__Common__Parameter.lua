Parameter = Parameter or BaseClass()

function Parameter:__init( ... )
	self.paramList = {}
end

function Parameter:__delete( ... )
	-- body
end

function Parameter:Add( key,val )
	self.paramList[key] = val
end

function Parameter:ToStringUrl()
	local strVal=""
	for k,v in pairs(self.paramList) do
		strVal =StringFormat("{0}{1}/{2}/",strVal,k,v)
	end
	--self.paramList = nil
	return strVal
end

function Parameter:ToNomalStringUrl()
	local strVal=""
	for k,v in pairs(self.paramList) do
		strVal =StringFormat("{0}{1}={2}&",strVal,k,v)
	end
	self.paramList = nil
	return strVal
end