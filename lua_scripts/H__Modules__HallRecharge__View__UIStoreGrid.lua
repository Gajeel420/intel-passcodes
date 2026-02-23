UIStoreGrid=UIStoreGrid or BaseClass()

function UIStoreGrid:__init( obj )
	self.obj=obj
	local mTran=self.obj.transform
	self.labelMoney=mTran:Find("Money"):GetComponent(typeof(UILabel))
	self.labelGive=mTran:Find("Give/Label"):GetComponent(typeof(UILabel))
	self.labelY=mTran:Find("Y_Label"):GetComponent(typeof(UILabel))
	self.spIcon=mTran:Find("Icon"):GetComponent(typeof(UISprite))
	UIEventListener.Get(self.obj).onClick=function() self:OnClickItem() end
end

function UIStoreGrid:SetItem(vo)
	self.vo=vo
	self.labelY.text = vo.iRmbNum
	SetNumberLabel(self.labelMoney,vo.iGoodNum)
	local index=vo.iIndex
	index = index > 8 and 8 or index
	self.spIcon.spriteName="UI_JInBi" .. index
	if vo.iGiveGold>0 then
		self.labelGive.transform.parent.gameObject:SetActive(true)
		SetNumberLabel(self.labelGive,vo.iGiveGold)
	else
		self.labelGive.transform.parent.gameObject:SetActive(false)
	end
end

function UIStoreGrid:Show()
	self.obj:SetActive(true)
end

function UIStoreGrid:Hide()
	self.obj:SetActive(false)
end

function UIStoreGrid:OnClickItem()
	if self.vo.eOnClickItem then
		self.vo.eOnClickItem(self.vo)
	end
end

function UIStoreGrid:__delete( ... )
	-- body
	self.labelMoney = nil
	self.labelGive = nil
	self.labelY = nil
	self.spIcon = nil
end