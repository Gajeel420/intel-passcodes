RenderMgr = {}

local this = RenderMgr
function UpdateBeat()
  RenderMgr.Update()
end

function LateUpdateBeat( )
	-- body
end

function FixedUpdateBeat( )
	-- body
end

function RenderMgr.Init()
	this.map = {}
	this.timeMap = {}
	this.intervalMap = {}
	this.cacheTimemap = {}
	this.isPause = false
	this.isStop = true
	LuaLooper.UpdateBeat=function( ... )
		this.Update()
	end
end

function RenderMgr.Start()
	if this.isStop then
		this.isStop = false
	elseif this.isPause then
		this.isPause = false
	end
end

function RenderMgr.Add(exec,key,livingTime)
	if key ==nil then
		key = exec
	end
	if livingTime and livingTime>0 then
		this.timeMap[key] = livingTime
	end
	this.map[key] = exec
	return key
end

function RenderMgr.AddInterval(exec,key,intervalTime,livingTime)
	key = this.Add(exec,key,livingTime)
	if intervalTime and intervalTime >0 then
		this.intervalMap[key] = intervalTime
		this.cacheTimemap[key] = 0
	else
		key = RenderMgr.DoNextFrame(exec)
	end
	return key
end

function RenderMgr.DoNextFrame(exec)
	return RenderMgr.AddInterval(exec,nil,0.025,0.025)
end

function RenderMgr.Remove(key)
	if key and this.map[key] then
		if this.intervalMap[key] then
			if this.cacheTimemap[key] ~= 0 and this.map[key] then
				-- this.map[key]()
			end
			this.intervalMap[key] = nil
			this.cacheTimemap[key] = nil
		end
		if this.timeMap[key] then
			this.timeMap[key] = nil
		end
		this.map[key] = false
	end
end

function RenderMgr.Update()
	if this.isPause or this.isStop then return end
	if not this.map then return end
	for key,exec in pairs(this.map) do
		if exec then
			local t = this.cacheTimemap[key]
			if t then
				if t>=this.intervalMap[key] then
					this.cacheTimemap[key] = 0
					exec()
				else
					this.cacheTimemap[key] = t + Time.deltaTime
				end
			else
				exec()
			end
			t = this.timeMap[key]
			if t and t>0 then
				t=t-Time.deltaTime
				this.timeMap[key] =t
				if t<=0 then
					this.Remove(key)
				end
			end
		else
			this.map[key] = nil
		end
	end
end

function RenderMgr.Pause()
	this.isPause = true
end

function RenderMgr.Stop()
	this.isStop = true
	UpdateBeat:Remove(this.Update,this)
end

function RenderMgr.Reset()
	if not this.isStop then
		UpdateBeat:Remove(this.Update,this)
	end
	for key,_ in pairs(this.map) do
		this.Remove(key)
	end
	this.Init()
end