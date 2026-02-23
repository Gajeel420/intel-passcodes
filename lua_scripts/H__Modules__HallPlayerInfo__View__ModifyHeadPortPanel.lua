ModifyHeadPortPanel = ModifyHeadPortPanel or BaseClass()

function ModifyHeadPortPanel:__init( obj )
	-- body
	self.obj = obj
	self.HeadOtherObjs = {}
	self.HeadOtherSelectObjs = {}
	self.HeadOtherLight = {}
	self.currentNo =1 
	self.mInt_HeadCount=10
	self:InitUI()
end


function ModifyHeadPortPanel:InitUI( ... )
	-- body
	local mTran = self.obj.transform
	local tranUI = mTran:Find("Button_Close")
	if tranUI ~= nil then
		UIEventListener.Get(tranUI.gameObject).onClick = function(obj) self:OnCloseBtn(obj) end
	end

	tranUI = mTran:Find("Button_ChangeInfo")
	if tranUI~= nil then
		UIEventListener.Get(tranUI.gameObject).onClick = function(obj) self:OnModifyHeadPortBtn(obj) end
	end
	tranUI = mTran:Find("Button_Cancel")
	if tranUI~= nil then
		UIEventListener.Get(tranUI.gameObject).onClick = function(obj) self:OnCloseBtn(obj) end
	end

	for i=1,10 do
		if i < 10 then
			tranUI = mTran:Find("HeadOther/Head_0"..i)
		else
			tranUI = mTran:Find("HeadOther/Head_"..i)
		end
		if tranUI~= nil then
			local headOtherObj = tranUI:Find("HeadPortait/Texture_HeadPortait").gameObject
			local headSelect = tranUI:Find("Sprite_Seclet").gameObject
			headSelect:SetActive(false)
			local headLight = tranUI:Find("Sprite_Light").gameObject
			headLight:SetActive(false)
			table.insert(self.HeadOtherObjs,headOtherObj)
			table.insert(self.HeadOtherSelectObjs,headSelect)
			table.insert(self.HeadOtherLight,headLight )
			headSelect:SetActive(false)
			UIEventListener.Get(headOtherObj).onClick = function(obj) self:OnHeadOtherClick(obj) end
		end
	end

end



function ModifyHeadPortPanel:SetModifyHeadPortPanelDisply( disply )
	-- body
	self.obj:SetActive(disply)
	self.currentNo = PlayerInfoController:GetInstance().model.mainPlayer.iImageNO
	for i = 1, #self.HeadOtherSelectObjs do
		self.HeadOtherSelectObjs[i]:SetActive(i== self.currentNo)
		self.HeadOtherLight[i]:SetActive(i== self.currentNo)
	end
	
end

function ModifyHeadPortPanel:OnCloseBtn( obj )
	-- body
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	self:SetModifyHeadPortPanelDisply(false)
end

function ModifyHeadPortPanel:OnModifyHeadPortBtn( obj )
	-- body
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	local send = {}
	send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
	send.m_unTime = CommonUtil.GetCurrentTimeStamp()
	send.m_unFieldTypeBits =HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Sex + HallDefine.E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_ImageNo  --用户个性签名 E_ACCOUNT_TABLE_FIELD_BIT.E_ACCOUNT_TABLE_FIELD_BIT_Signature
	local m_Sex= 0
	if self.currentNo <= 5 then
		--男
		m_Sex = 1
	else
		--女
		m_Sex = 0
	end
	local m_szInfo = tostring(m_Sex)..","..self.currentNo
	print("--------------------------------------    m_szInfo == ",m_szInfo)
	send.m_usInfoLen = string.len(m_szInfo)
	send.m_szInfo = CommonUtil.StringToByteArrayTable(m_szInfo)
	NetworkDefine.CReqUpdatePlayerInfoMsgPara={
		{"m_unUIN","Int32",0},--用户id
		{"m_unTime", "Int32", 0},--时间
		{"m_unFieldTypeBits", "Int64", 0},--要修改的字段位掩码
		{"m_usInfoLen","UInt16",0},--实际长度
		{"m_szInfo","Byte[]",string.len(m_szInfo)},--更新的内容, ","分隔各信息内容, 各信息内容以字符串的形式存入缓冲区
	}
	NetworkMgr:AddMsgStruct("NetworkDefine.CReqUpdatePlayerInfoMsgPara",NetworkDefine.CReqUpdatePlayerInfoMsgPara)
	Net_SendHallData(NetworkDefine.CReqUpdatePlayerInfoMsgPara, send, 0, NetworkDefine.E_MSG_ID.MSG_ID_UPDATE_USERINFO, 0)
end


function ModifyHeadPortPanel:OnHeadOtherClick( obj )
	-- body
	for i=1,self.mInt_HeadCount do
		if self.HeadOtherObjs[i] == obj then
			self.currentNo = i
			self.HeadOtherSelectObjs[i]:SetActive(true)
			self.HeadOtherLight[i]:SetActive(true)
		else
			self.HeadOtherSelectObjs[i]:SetActive(false)
			self.HeadOtherLight[i]:SetActive(false)
		end
	end
end






function ModifyHeadPortPanel:__delete( ... )
	-- body
	self.HeadOtherObjs = nil
	self.HeadOtherSelectObjs = nil
end