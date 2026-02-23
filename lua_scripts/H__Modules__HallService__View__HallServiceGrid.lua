HallServiceGrid = HallServiceGrid or BaseClass()

function HallServiceGrid:__init( go )
	-- body
	self.go = go
	self:InitUI()
end

--初始化ui界面  ----必须实现
function HallServiceGrid:InitUI()
	local mTran = self.go.transform
	local mTranUi = mTran:Find("Label_Content")
	mTranUi = mTran:Find("Button_CopyGo")
	if(mTranUi) then
		self.mBtn_CopyGo = mTranUi.gameObject
		UIEventListener.Get(self.mBtn_CopyGo).onClick = function() self:OnButtonCopyGo() end
	end
	mTranUi = nil
end

function HallServiceGrid:SetGridData( data )
	-- body
	self.webStr = data
end

function HallServiceGrid:OnButtonCopyGo( ... )
	-- body
	if(self.webStr) then
		Application.OpenURL(self.webStr)
	end
	
end

function HallServiceGrid:__delete( ... )
	-- body
	GameObjectDestroy(self.go)
	self.mBtn_CopyGo = nil
end
