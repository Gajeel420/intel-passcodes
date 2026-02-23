UIDaili=UIDaili or BaseClass()
function UIDaili:__init(obj)
	self.obj=obj
	self:InitUI()
end

function UIDaili:InitUI()
	local mTran=self.obj.transform
	self.GridParent=mTran:Find("VIPView/ScrollView/Grid")
	self.mGrid_GridParent=mTran:Find("VIPView/ScrollView/Grid"):GetComponent(typeof(UIGrid))
	self.mScrollView_ScrollView=mTran:Find("VIPView/ScrollView"):GetComponent(typeof(UIScrollView))
	self.GridTrans=mTran:Find("VIPView/Item").gameObject
	self.GridTrans:SetActive(false)
	self.listItem={}
	self.mLabel_MyID = mTran:Find("Label").gameObject:GetComponent(typeof(UILabel))
	self.obj_Copy = mTran:Find("Button_Copy").gameObject
	self.mLabel_Money = mTran:Find("UserMoney/Label").gameObject:GetComponent(typeof(UILabel))
	self.mLabel_Tips =  mTran:Find("VIPView/Label_02").gameObject:GetComponent(typeof(UILabel))
	UIEventListener.Get(self.obj_Copy).onClick = function() self:OnButton_CopyID() end
end


function UIDaili:OnButton_CopyID( )
	PhoneManager:MyClipDataToClipboard(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
end

function UIDaili:SetUserMoney(money)
	self.mLabel_Money.text = NumberFormat(HallGoldRateSToC(money))
end

function UIDaili:ShowUI()
	self.obj:SetActive(true)
end
--生产排序商品Grid
function UIDaili:SpawnGrid(item, grid)
	if item == nil or grid == nil then return end
	local go = GameObject.Instantiate(item, grid)
    return go
end
function UIDaili:SetUI(list)
	self:RecycleItem()
	self.mLabel_MyID.text = StringFormat("用户ID:{0}", PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	if CheckServiceJsonDataIsNullOrEmpty(StoreModuleModel:GetInstance().Payprompt["61"]) then
		--self.mLabel_Tips.text = StoreModuleModel:GetInstance().Payprompt["61"]
	end
	if not list then return end
	local count=#list
	for i,itemVo in ipairs(list) do
		local item=self.listItem[i]
		if not item then
			local go=self:SpawnGrid(self.GridTrans, self.GridParent)
			item = UIDailiGrid.New(go)

			table.insert(self.listItem,item)
		end
		item:SetItem(itemVo)
		item:Show()
	end
	self.mGrid_GridParent:Reposition()
	self.mScrollView_ScrollView:ResetPosition()
	self:SetUserMoney(PlayerInfoController:GetInstance().model.mainPlayer.iMoney)
end
function UIDaili:RecycleItem( ... )
	if self.listItem then
		for i,item in ipairs(self.listItem) do
			item:Hide()
		end
	end
end

function UIDaili:SetPanelDepth(depth )
	self.mScrollView_ScrollView:GetComponent(typeof(UIPanel)).depth=depth
end
function UIDaili:HideUI()
	self.obj:SetActive(false)
end

function UIDaili:__delete()
	self.GridParent = nil
	self.GridTrans = nil
	self.listItem = nil
end