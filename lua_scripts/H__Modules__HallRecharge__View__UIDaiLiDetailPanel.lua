UIDaiLiDetailPanel = UIDaiLiDetailPanel or BaseClass()

function UIDaiLiDetailPanel:__init( obj )
	-- body
	self.obj = obj
	self:InitUI()
end

function UIDaiLiDetailPanel:InitUI( ... )
	-- body
	local mTrans = self.obj.transform
	self.wxLable = mTrans:Find("Content/WeiXin/Sprite_Label/Label").gameObject:GetComponent(typeof(UILabel))
	self.wxBtn =mTrans:Find("Content/WeiXin/Button_WeiXinCopy").gameObject
	self.ObWX = mTrans:Find("Content/WeiXin").gameObject
	self.ObQQ = mTrans:Find("Content/QQ").gameObject
	self.qqLabel = mTrans:Find("Content/QQ/Sprite_Label/Label").gameObject:GetComponent(typeof(UILabel))
	self.qqBtn = mTrans:Find("Content/QQ/Button_QQCopy").gameObject
	self.titleName = mTrans:Find("Content/Label_Name").gameObject:GetComponent(typeof(UILabel))
	self.closeBtn = mTrans:Find("Content/Button_Close").gameObject

	UIEventListener.Get(self.closeBtn).onClick=function() self:OnCloseBtn() end
	UIEventListener.Get(self.wxBtn).onClick=function() self:OnWeiXinCopy() end
	UIEventListener.Get(self.qqBtn).onClick=function() self:OnQQCopy() end
end

function UIDaiLiDetailPanel:ShowUI( vo )
	-- body
	self.vo = vo
	
	if vo.weburl~= nil and vo.weburl ~= ""  then
		Application.OpenURL(GetServiceUrl(vo.weburl))
	else
		if vo.weixin == nil or vo.weixin == "" then
			self.ObWX:SetActive(false)
		else
			self.ObWX:SetActive(true)
			self:SetLabelValue(self.wxLable,vo.weixin)
		end
		if vo.qq == nil or vo.qq == "" then
			self.ObQQ:SetActive(false)
		else
			self.ObQQ:SetActive(true)
			self:SetLabelValue(self.qqLabel,vo.qq)
		end
		
		--self:SetLabelValue(self.titleName,vo.title)
		
		self.obj:SetActive(true)
	end

end

function UIDaiLiDetailPanel:SetLabelValue(mLabel,value)
	value = value == nil and "" or value
	mLabel.text = value
end

function UIDaiLiDetailPanel:OnCloseBtn( ... )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	-- body
	self.obj:SetActive(false)
end

function UIDaiLiDetailPanel:OnWeiXinCopy( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- body
	PhoneManager:MyClipDataToClipboard(self.vo.weixin)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
	PhoneManager:MyStartWeiXin()
end

function UIDaiLiDetailPanel:OnQQCopy( ... )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

	-- body
	PhoneManager:MyClipDataToClipboard(self.vo.qq)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
	PhoneManager:MyStartQQ(self.vo.qq)
end

function UIDaiLiDetailPanel:__delete( ... )
	-- body
end