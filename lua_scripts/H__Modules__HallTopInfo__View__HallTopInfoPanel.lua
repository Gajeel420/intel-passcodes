 HallTopInfoPanel = HallTopInfoPanel or BaseClass(LuaPanel)

function HallTopInfoPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTopInfo].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallTopInfo].path
	self.mPanelID = UIPanelDefine.EWndID.HallTopInfo
	self.mPanelType = UIPanelDefine.PanelType.TopPnael
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallTopInfoPanel:InitUI()
	local mTran = self.obj.transform
	-- self.Localize = CS.I2.Loc.Localize
	self.IsDisplay = false
	self.mTex_HeadPortait = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Info/Info/HeadPortait/Texture_HeadPortait"):GetComponent(typeof(UITexture))
	self.mTex_HeadPortaitButton = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Info/Info/HeadPortait").gameObject
	UIEventListener.Get(self.mTex_HeadPortaitButton).onClick = function() self:OnButton_HeadPortait() end
	self.mLabel_NickName = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Info/Info/Label_Name"):GetComponent(typeof(UILabel))
	self.mLabel_ID= mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Info/Info/Label_ID"):GetComponent(typeof(UILabel))
	self.mLabel_Money = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Money/Money/Label_Value"):GetComponent(typeof(UILabel))
	self.mButton_PlusMoney = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_Money/Money").gameObject
	UIEventListener.Get(self.mButton_PlusMoney).onClick = function() self:OnButton_PlusMoney() end

	self.mLabel_Vip =  mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_VIP/Money/Label_Value"):GetComponent(typeof(UILabel))
	self.mLabel_Vip.text = StringFormat("VIP{}",0)

	-- self.mLabelSprite =  mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_VIP/Money/Sprite"):GetComponent(typeof(self.Localize))
	-- self.mLabelSprite:SetTerm("Click_copy")
	-- self.maxEmailLimitLocalize = mTran:Find("Content/TopGroup/TweenTop/UserInfo/Player_VIP/Money/Label_Value"):GetComponent(typeof(self.Localize))
	-- self.maxEmailLimitLocalize:SetTerm("Account1")

	-- StartCoroutine(function ()
	-- 	yield_return(WaitForSeconds(10.1))
	-- 	print("aaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbb11111111111111111122222222222222222")
 --       self.mLabelSprite:SetTerm("forget_password2")
 --    end)

	--初始化动画
	local list_tweenList={}
    local tweenPosition_bottom=mTran:Find("Content/TopGroup/TweenTop"):GetComponent(typeof(TweenPosition))
    table.insert(list_tweenList, tweenPosition_bottom)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	LuaPanel.InitUI(self)
end

--打开个人信息页面
function HallTopInfoPanel:OnButton_HeadPortait( )
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	if ConfigModuleModel.GetInstance().IsShowPlayerInfo then
		UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPlayerInfo)
	end
end

--OnButton_PlusMoney按钮点击事件
function HallTopInfoPanel:OnButton_PlusMoney( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRecharge)
	PlayerInfoController:GetInstance():RequestGetUserMoney()
end


--添加事件监听
function HallTopInfoPanel:AddEvent()
	PlayerInfoController:GetInstance().model.mainPlayer:AddEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
	LuaEvent:AddEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
end
--移除事件监听
function HallTopInfoPanel:RemoveEvent()
	PlayerInfoController:GetInstance().model.mainPlayer:RemoveEventListener(PlayerInfoConst.EventName_UpdatePlayerInfo,self.UpdatePlayerInfo,self)
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
	LuaEvent:RemoveEventListener(EventName.REFRESHUSERDATA,self.RefreshPanelData,self)
end

--更新玩家信息
function HallTopInfoPanel:UpdatePlayerInfo(context)
	if not context then return end
	local key=context[1]
	local newValue=context[2]
	local oldValue=context[3]
	print("更新玩家信息",key,newValue,oldValue)
	if key=="iVipLevel" then
		self.mLabel_VIP.text= StringFormat("VIP{}",tostring(newValue))
	end
	if key=="iMoney" then
		self:SetNumberLabel( self.mLabel_Money,newValue )
		if (tonumber(newValue) - tonumber(oldValue)) > 0 then
			HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
		end
		if HallRechargeController:GetInstance().view.panel then
			HallRechargeController:GetInstance().view.panel:UpdatePlayerVoNew(newValue)
		end
	end
	if key == "iImageNO" then

		local texture=UIPanelDefine.GetHeadTexturByIconIndex(newValue)
		if texture then
			self.mTex_HeadPortait.mainTexture=texture
		end

		PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.mTex_HeadPortait,ConfigInfoMgr.ThirdPlatformHeadURL,1,newValue)
	end
	if key == "szNickName" then
		if oldValue ~= newValue then
			local name = newValue or ""
			self.mLabel_NickName.text =GetUserNickNameUnique(name) 
		end
	end
end


function HallTopInfoPanel:SetNumberLabel(comlabel,value)
	if not comlabel then return end
	value=value or 0
	comlabel.text=NumberFormat(HallGoldRateSToC(value))
end


function HallTopInfoPanel:SetPlayerInfo()
	local mainPlayer = PlayerInfoController:GetInstance().model.mainPlayer
	local name = mainPlayer.szNickName or ""
	self.mLabel_NickName.text =GetUserNickNameUnique(name) 
	self.mLabel_ID.text = StringFormat("[FFFFFFFF]ID：[-][FFFE00FF]{0}[-]",mainPlayer.uiUserID ) 
	self.mLabel_Vip.text =StringFormat("VIP{0}",mainPlayer.iVipLevel)
	self:SetNumberLabel( self.mLabel_Money,mainPlayer.iMoney )
	PlayerHeadPortainMgr:GetInstance():BindHeadURL(self.mTex_HeadPortait,ConfigInfoMgr.ThirdPlatformHeadURL,1,mainPlayer.iImageNO)
end


--显示窗口
function HallTopInfoPanel:ShowPanel(callBack)
	if not self.IsDisplay then
		self.IsDisplay = true
		self:SetPlayerInfo()
		self:AddEvent()
	end
	LuaPanel.ShowPanel(self,callBack)
	StartCoroutine(function ()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mTweenPlayer:ParallelPlay(false)
    end)

end

function HallTopInfoPanel:HidePanel( callBack,isPlayTween )
    if isPlayTween==nil or isPlayTween==true then
		self.mTweenPlayer:ParallelPlay(true,function ()
			self:SetVisible(false)
			if callBack then
				callBack()
			end
		end)
    else
		self:SetVisible(false)
		if callBack then
			callBack()
		end
    end

end

function HallTopInfoPanel:RefreshPanelData( ... )
	-- body
	self:SetNumberLabel( self.mLabel_Money,PlayerInfoController:GetInstance().model.mainPlayer.iMoney )
end

function HallTopInfoPanel:ResetPanel()
	self.IsDisplay = false
	ConfigInfoMgr.ThirdPlatformHeadURL = ""
	PlayerHeadPortainMgr:GetInstance().mTextureURLDic= nil
	PlayerHeadPortainMgr:GetInstance().mTextureURLDic= {}
	self:RemoveEvent()
end

function HallTopInfoPanel:__delete( ... )
	self:RemoveEvent()
	GameObjectDestroy(self.obj)
end