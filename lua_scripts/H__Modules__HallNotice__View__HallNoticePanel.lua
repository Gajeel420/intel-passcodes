HallNoticePanel = HallNoticePanel or BaseClass(LuaPanel)

function HallNoticePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.Notice].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.Notice].path
	self.mPanelID = UIPanelDefine.EWndID.Notice
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel--页面层级
	self:CreatePanel(0)----必须实现
	
end
--初始化ui界面  ----必须实现
function HallNoticePanel:InitUI()
	local mTran = self.obj.transform
	self.mLabel_TextContent = mTran:Find("Content/ScrollView/Label_Msg"):GetComponent(typeof(UILabel))
	self.mScrollView_TextContent = mTran:Find("Content/ScrollView"):GetComponent(typeof(UIScrollView))
	local mButtonClose = mTran:Find("Content/Button_Close").gameObject
	local mbuttonSure = mTran:Find("Content/Button_OK").gameObject
	UIEventListener.Get(mButtonClose).onClick = function () self:OnButtonClose() end
	UIEventListener.Get(mbuttonSure).onClick = function () self:OnButtonSure() end

	local list_tweenList={}
    local tweenPosition_bottom=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenPosition_bottom)
	self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	LuaPanel.InitUI(self)
end

function HallNoticePanel:OnButtonClose( )
	UIManager:GetInstance():HidePanel(self.mPanelID)
	
end

function HallNoticePanel:OnButtonSure(go)
	UIManager:GetInstance():HidePanel(self.mPanelID)
end

function HallNoticePanel:HidePanel()
	LuaPanel.HidePanel(self)
	HallRedEnvelopesController.GetInstance().model:CClientQueryNotDrawedRedPacketGiftReq()
end


--设置子panel的深度
 function HallNoticePanel:SetPanelDepth(depth)
	self.mScrollView_TextContent:GetComponent(typeof(UIPanel)).depth = depth + 1
	LuaPanel.SetPanelDepth(self,depth)
end

function HallNoticePanel:ShowPanel(callBack)
	self.mLabel_TextContent.text = HallNoticeController.GetInstance().model.NoticeMsg
	StartCoroutine(function()
		yield_return(WaitForSeconds(0.1)) 
		self.mScrollView_TextContent:ResetPosition()
	end)
	LuaPanel.ShowPanel(self, callBack)
	self.mTweenPlayer:ParallelPlay(false)
end


function HallNoticePanel:__delete( ... )

end
