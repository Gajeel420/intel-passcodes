RecordItem = RecordItem or BaseClass()

function RecordItem:__init( obj )
	-- body
	self.obj = obj
	self:InitData()
	self:InitView()
end

function RecordItem:InitData( ... )
	-- body
end

function RecordItem:InitView( ... )
	-- body
	local mTran = self.obj.transform
	self.TypeLabel = mTran:Find("Label_02/Label").gameObject:GetComponent(typeof(UILabel))
	self.NumberingLabel = mTran:Find("Label_01/Label").gameObject:GetComponent(typeof(UILabel))
	self.AmountLabel = mTran:Find("Label_03/Label").gameObject:GetComponent(typeof(UILabel))
	self.TimeLabel = mTran:Find("Label_04/Label").gameObject:GetComponent(typeof(UILabel))
	self.StateLabel = mTran:Find("Label_05/Label").gameObject:GetComponent(typeof(UILabel))
	self.mObjTips = mTran:Find("Label_05/Tips").gameObject
	self.mObjTips:SetActive(false)
	self.mBg = mTran:Find("Tex").gameObject
	UIEventListener.Get(self.obj).onClick = function(obj)
		self:OnItemClick()
	end
	self.mBox = self.obj:GetComponent(typeof(BoxCollider))

end


function RecordItem:OnItemClick(obj)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local showBoxData ={}
	showBoxData.title = "温馨提示"
	showBoxData.context =  StringFormat("{0}",self.resultData.beizhu)
	showBoxData.enterCB = function() 
		
	end--：点击确定返回；
	showBoxData.isShowCancel = false--：true显示两个，fasle--显示一个确定按钮；
	showBoxData.isHideAll = false--:隐藏所有按钮; 
	showBoxData.isShowBtnClose = false--:界面的关闭按钮
	UIManager:GetInstance():ShowMessageBox(showBoxData)
end

function RecordItem:SetData( resultData,index )
	-- body
	if resultData ~= nil then
		self.resultData = resultData
		local n,i = math.modf( index / 2 )
		self.mBg:SetActive(i ~= 0)
		self.NumberingLabel.text = resultData.orderId
		self.TypeLabel.text = resultData.tx_type
		self.AmountLabel.text =  NumberFormat(HallGoldRateSToC(tonumber(resultData.amount)))
		self.TimeLabel.text = resultData.time
		if resultData.tx_status == "审核不通过" then
			self.StateLabel.text = StringFormat("[FF0000FF]{0}[-]",resultData.tx_status)
			self.mBox.enabled = true
			self.mObjTips:SetActive(true)
		else
			self.mBox.enabled = false
			self.mObjTips:SetActive(false)
			self.StateLabel.text =  StringFormat("[20FF00FF]{0}[-]",resultData.tx_status) 
		end
	end
end


function RecordItem:SetDisPlay( disPlay )
	-- body
	self.obj:SetActive(disPlay)
end

function RecordItem:__delete( ... )
	-- body
	self.NumberingLabel = nil
	self.TypeLabel = nil
	self.AmountLabel = nil
	self.TimeLabel = nil
	self.StateLabel = nil
end