HallWechatServiceGrid = HallWechatServiceGrid or BaseClass()
function HallWechatServiceGrid:__init( go )
	-- body
	self.go = go
	self:InitUI()
end

--初始化ui界面  ----必须实现
function HallWechatServiceGrid:InitUI()
	local mTran = self.go.transform
	local mTranUi = mTran:Find("Label_Content")
	if(mTranUi) then
		self.mLabel_content = mTranUi.gameObject:GetComponent(typeof(UILabel))
	end
	mTranUi = mTran:Find("Button_Copy")
	if (mTranUi) then
		self.mBtn_Copy = mTranUi.gameObject
		UIEventListener.Get(self.mBtn_Copy).onClick = function() self:OnButtonCopy() end
	end
	mTranUi = mTran:Find("Button_CopyGo")
	if(mTranUi) then
		self.mBtn_CopyGo = mTranUi.gameObject
		UIEventListener.Get(self.mBtn_CopyGo).onClick = function() self:OnButtonCopyGo() end
	end
	mTranUi = nil
end


function HallWechatServiceGrid:SetGridData( data )
	-- body
	self.vo = data
	self.mLabel_content.text = data
end

function HallWechatServiceGrid:OnButtonCopy( ... )
	-- body
	PhoneManager:MyClipDataToClipboard(self.mLabel_content.text)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end

function HallWechatServiceGrid:OnButtonCopyGo( ... )
	-- body
	PhoneManager:MyClipDataToClipboard(self.mLabel_content.text)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
	PhoneManager:MyStartWeiXin()
	
end

function HallWechatServiceGrid:__delete( ... )
	-- body
	GameObjectDestroy(self.go)
	self.mLabel_Content = nil
	self.mBtn_Copy = nil
	self.mBtn_CopyGo = nil
end