local _printer_ = "tper"
function _debug_( ... )
	if not GameConst.PrintDebug then return end 
	pt(...)
end

function tper( ... )
	if _printer_ == "tper" then 
		_debug_(...)
	end
end

function _printt(lua_table,limit,indent__,step__)
	step__ = step__ or 0
	indent__ = indent__ or 0
	local content__ = ""
	if limit~=nil then
		if step__ > limit then 
			return "..."
		end
	end
	if step__ > 8 then
		return content__.."..."
	end
	if lua_table ==nil then 
		return "nil"
	end
	if type(lua_table) == "userdata" or type(lua_table) == "lightuserdata" or type(lua_table) == "thread" then
		return tostring(lua_table)
	end

	if type(lua_table) == "string" or type(lua_table) == "number" then
		return "[No-Table]:"..lua_table
	end

	for k,v in pairs(lua_table) do
		if k~="_class_type" then
			local szSuffix = ""
			TypeV = type(v)
			if	TypeV == "table" then
				szSuffix = "{"
			end
			local szPrefix = string.rep("  ",indent__)
			if TypeV == "table"and v._fields then
				local kk,vv = next(v._fields) 
				if type(vv) == "table" then
					content__ = content__.."\n\t"..kk.name.."={".._printt(vv._fields,5,indent__+1,step__+1).."}"
				else
					content__=content__.."\n\t"..kk.name.."="..vv
				end
			else
				if type(k) == "table" then
					if k.name then
						if type(v)~="table"then
							content__=content__.."\n"..k.name.." = "..v
						else
							content__ = content__.."\n"..k.name.." = list:"
							local tmp="\n"
							for ka,va in ipairs(v) do
								tmp=tmp.."#"..ka.."-"..tostring(va)
							end
							content__=content__..tmp
						end
					end
				elseif type(k) == "function" then
					content__=content__.."\n fun=function"
				else
					formatting=szPrefix..tostring(k).." = "..szSuffix
					if TypeV=="table" then
						content__=content__.."\n"..formatting
						content__=content__.._printt(v,limit,indent__+1,step__+1)
						content__=content__.."\n"..szPrefix.."},"
					else
						local szValue = ""
						if TypeV=="string"then
							szValue = string.format("%q",v)
						else
							szValue = tostring(v)
						end
						content__=content__.."\n"..formatting..(szValue or "nil")..","
					end
				end
			end
		end
	end
	return content__
end

function  pt( ... ) 
	if GameConst.PrintDebug then	
		local arg = {...}
		local has = false
		for _,v in pairs(arg) do
			if v and type(v) ==  "table" then
				has = true
				break
			end
		end
		if not has then 
			print(...)
		end
		local content__ = ""
		for _,v in pairs(arg) do
			if v == "table" then
				content__ = content__..tostring(v).."\n"
			else
				content__=content__.."=>>[T]:".._printt(v,limit),debug.traceback().."\n"
			end
			print(content__)
		end
	end
end

function PrintLog( ... )	
	if GameConst.PrintDebug then		
		local arg={...}
		local logStr=""	
		for i=1,#arg do
            local str=tostring(arg[i])
            if(str==nil) then
                str="nil"
            end
			if(i==1) then
				logStr=str
			else
				logStr=logStr .. " " .. str
			end		
		end		
		print(logStr)		
	end
end

function PrintLog_WithStack( ... )	
	if GameConst.PrintDebug then		
		local arg={...}
		local logStr=""	
		for i=1,#arg do
            local str=tostring(arg[i])
            if(str==nil) then
                str="nil"
            end
			if(i==1) then
				logStr=str
			else
				logStr=logStr .. " " .. str
			end		
		end		
		print(logStr .. debug.traceback())		
	end
end

function PrintErrorLog( ... )
	local arg={...}
	local logStr=""
	for i=1,#arg do
		if(i==1) then
			logStr=tostring(arg[i])
		else
			logStr=logStr .. " " .. tostring(arg[i])
		end		
	end
	error(logStr)
end