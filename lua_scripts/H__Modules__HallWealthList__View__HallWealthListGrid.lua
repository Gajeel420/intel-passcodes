HallWealthListGrid=HallWealthListGrid or BaseClass()

function HallWealthListGrid:__init(go)
	self.obj=go
	self:InitUI()
end

function HallWealthListGrid:InitUI( ... )
	local mTran=self.obj.transform
	self.texHead = mTran:Find("HeadPortait/Texture_HeadPortait"):GetComponent(typeof(UITexture));

    self.lableNickName = mTran:Find("Label_Name"):GetComponent(typeof(UILabel))
    self.labelSignature = mTran:Find("Label_Sign"):GetComponent(typeof(UILabel))

    self.sprCrown = mTran:Find("Num_Rank/Label_Rank"):GetComponent(typeof(UISprite))

	
    self.labelRankNum= mTran:Find("Num_Rank/Label_RankH"):GetComponent(typeof(UILabel))
    self.labelMoney = mTran:Find("Label_Money"):GetComponent(typeof(UILabel))

	self.labelTips = mTran:Find("Lable_Tips/Label_Tips2"):GetComponent(typeof(UILabel))

end

function HallWealthListGrid:SetGridData( m_RspUser,nIndex,rankListType )
	--print("rankListType",rankListType)
	self.mUserInfo = m_RspUser;
    self.nNumber = nIndex;  
	PlayerHeadPortainMgr:GetInstance():BindHeadUserID(self.texHead.gameObject,m_RspUser.m_unUIN,0,m_RspUser.iImageNO)
	self.labelTips.text = HallWealthListModel.RankeLisTypeConst[rankListType]
	--
	if nIndex<=3 then
		self.sprCrown.gameObject:SetActive(true);
		self.sprCrown.spriteName= "Hall_BT_Crown"..nIndex
		self.labelRankNum.gameObject:SetActive(false)
	else
		self.labelRankNum.text = (nIndex)

		self.sprCrown.gameObject:SetActive(false);
		self.labelRankNum.gameObject:SetActive(true)
	end

	
	self.lableNickName.text = GetStringNotFull(m_RspUser.m_szNickName);

	local tmpMoney = 0
	if rankListType == HallWealthListPanel.RankeListType.WinRankingList then
		tmpMoney=HallGoldRateSToC(m_RspUser.m_un64Coins)
	elseif rankListType == HallWealthListPanel.RankeListType.RechargeRankingList then
		tmpMoney = m_RspUser.m_un64Amount
	elseif HallWealthListPanel.RankeListType.SupremeRankingList== rankListType then
		tmpMoney=HallGoldRateSToC(m_RspUser.m_unWalletMoney)
	elseif HallWealthListPanel.RankeListType.CommissionList == rankListType then
		tmpMoney=m_RspUser.money
		if m_RspUser.type == 1 then
			self.labelTips.text = "昨日佣金"
		else
			self.labelTips.text = "今日佣金"
		end
	end

	self.labelMoney.text = StringFormat("{0}", NumberThousandsFormat(tmpMoney));
end




function HallWealthListGrid:OnVisible(isVisible)
	self.obj:SetActive(isVisible)
end




function HallWealthListGrid:__delete( ... )
    self.texHead = nil
	self.lableNickName = nil
	self.labelSignature = nil
	self.sprCrown = nil

	self.labelRankNum = nil
	self.labelMoney = nil
	self.mObjAdd = nil
	self.objGiveBtn = nil
	self.labelTip = nil
	GameObject.Destroy(self.obj)
	self.obj=nil
end

