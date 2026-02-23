HallNotifyScrollPanel = HallNotifyScrollPanel or BaseClass()

function HallNotifyScrollPanel:__init( obj )
	-- body
	self.obj = obj
	self:InitData()
	self:InitView()
end

function HallNotifyScrollPanel:InitData( ... )
	-- body
	self.mIsNotifying = false --是否正在播放
	self.mMoveSpeed = 150 --移动速度
	self.mBaseFrom = 800	--开始位置
	self.mBaseTo = -100		--结束位置
	self.mMoveDis = 0		--当前位置
	self.mTo = 0
	self.starY = -26
	self.starX = 65
	self.stepY = 40
	self.UpdateName = "HallNotifyScrollPanel:Update"
	self.moveendBack = nil
end

function HallNotifyScrollPanel:InitView( ... )
	-- body
	local mTran = self.obj.transform
	self.mPanel_Notify = self.obj:GetComponent(typeof(UIPanel))
	self.mLabel = mTran:Find("Label").gameObject
	self.Label = mTran:Find("Label/Label"):GetComponent(typeof(UILabel))
	self.mVercotor =  Vector3.zero
end

function HallNotifyScrollPanel:SetIndex( index )
	-- body
	self.UpdateName = self.UpdateName .. index
	self.index = index
	self.obj.transform.localPosition = Vector3(self.starX,self.starY-(index-1)*self.stepY,0)
	self.obj.transform.localScale = Vector3(1,1,1)
end

function HallNotifyScrollPanel:SetPanelDepth( depth )
	-- body
	self.mPanel_Notify.depth = depth + 1
end

function HallNotifyScrollPanel:SetNotyData(data,moveEndBack )
	-- body
	self.moveendBack = moveEndBack
	if data ~= nil then
		
		self.mLabel.transform.localPosition = Vector3(self.mBaseFrom, 0, 0)
		self.mMoveDis = 0
		self.obj:SetActive(true)
		self.mIsNotifying = true
		self:SpritNotify(data.m_szContent)
		RenderMgr.Add(function () self:Update() end,self.UpdateName)
	end
end

--恭喜玩家$【机器人2】$ 在 $五人牛牛$ （大众场） 赢得 $5940000$ 游戏币，大赚特赚
function HallNotifyScrollPanel:SpritNotify( text )
	-- body
	--print("+++++++++++++++++",text)
	local data = StringSplit(text,"$")
	local result = ""
	if #data == 7 then
		if (CheckServiceJsonDataIsNullOrEmpty(data[6]) ~= nil) then
			local x = ""
			x = StringFormat("{0}{1}{2}",data[1],GetStringNotFull(data[2]),data[3])..StringFormat("{0}",data[4])..data[5]..StringFormat("{0}",NumberThousandsFormat(HallGoldRateSToC(tonumber(data[6])),1))..data[7]
			self.Label.text = x
			local lenth = self.Label.width
			self.mTo = self.mBaseTo - lenth
		else
			self:MoveEnd()
		end
	elseif #data == 5 then
		if (CheckServiceJsonDataIsNullOrEmpty(data[4]) ~= nil) then
			local x = ""
			x = data[1]..StringFormat("{0}",data[2])..data[3]..StringFormat("{0}",NumberThousandsFormat(HallGoldRateSToC(tonumber(data[4])),1))..data[5]
			self.Label.text = x
			local lenth = self.Label.width
			self.mTo = self.mBaseTo - lenth
		else
			self:MoveEnd()
		end
	elseif #data == 3 then
		if (CheckServiceJsonDataIsNullOrEmpty(data[2]) ~= nil) then
			result = StringFormat("{0}{1}{2}",data[1],NumberThousandsFormat(HallGoldRateSToC(tonumber(data[2])),1),data[3])
			local x = ""
			x = data[1]..NumberThousandsFormat(HallGoldRateSToC(tonumber(data[2])),1)..data[3]
			self.Label.text = x
			local lenth = self.Label.width
			self.mTo = self.mBaseTo - lenth
		else
			self:MoveEnd()
		end
	else
		self.Label.text = data[1]
		self.mTo = self.mBaseTo - self.Label.width
	end
	return result
end


function HallNotifyScrollPanel:Update( ... )
	-- body
	if self.mBaseFrom + self.mMoveDis > self.mTo then
		self.mMoveDis = self.mMoveDis - Time.deltaTime * self.mMoveSpeed
		self.mVercotor.x = self.mBaseFrom + self.mMoveDis
		self.mLabel.transform.localPosition = self.mVercotor
	else
		self:MoveEnd()
	end
end


function HallNotifyScrollPanel:MoveEnd( ... )
	-- body
	RenderMgr.Remove(self.UpdateName)
	
	self.obj:SetActive(false)
	if self.moveendBack ~= nil then
		self.moveendBack(self.index)
	end
end

function HallNotifyScrollPanel:ResetPanel( ... )
	-- body
	self.mIsNotifying = false --是否正在播放
	self.obj:SetActive(false)
	--self.obj.transform.localPosition = Vector3(self.starX,self.starY,0)
	--self.mIsNotifying
	RenderMgr.Remove(self.UpdateName)
end

function HallNotifyScrollPanel:__delete( ... )
	-- body
	self.mPanel_Notify = nil
	self.obj.localPosition = nil
	self.mIsNotifying = nil
	self.mMoveSpeed = nil
	self.mBaseFrom = nil
	self.mBaseTo = nil
	self.mMoveDis = nil
	self.mTo = nil
	self.starY = nil
	self.starX = nil
	self.stepY = nil
	self.UpdateName = nil
	self.obj = nil
end