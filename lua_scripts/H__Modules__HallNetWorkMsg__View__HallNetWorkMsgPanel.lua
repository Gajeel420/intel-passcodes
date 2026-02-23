HallNetWorkMsgPanel = HallNetWorkMsgPanel or BaseClass(LuaPanel)

function HallNetWorkMsgPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.NetWorkMsg].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.NetWorkMsg].path
	self.mPanelID = UIPanelDefine.EWndID.NetWorkMsg
	self.mPanelType= UIPanelDefine.PanelType.Prompt;
	self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallNetWorkMsgPanel:InitUI()
	local mTran = self.obj.transform
	self.lab_Msg = mTran:Find("Content/TipBg/LabelTips"):GetComponent(typeof(UILabel))
	--self.lab_Msg.text = "";
	
	-- self.mAniObj = mTran:Find("Content/Btn_CZ/Label_CZ")
	-- if self.mAniObj ~= nil then
		
    --     self.mUIRenderQueue = SZUIRenderQueue.New(self.mAniObj.gameObject)
    -- end

    self.lblLocalize = mTran:Find("Content/TipBg/LabelTips"):GetComponent(typeof(Localize))
    self.LocalizationManager = CS.I2.Loc.LocalizationManager

	LuaPanel.InitUI(self)
	
end
 -- /// <param name="msg">要显示的消息</param>
 --    /// <param name="showingTime">显示的时间，小于0时，要手动关闭 大于0时，表示连接网络，超时时显示系统提示</param>   
function HallNetWorkMsgPanel:ShowNotMsg(msg,noteMessage,showingTime,action)
	RenderMgr.Remove("HallNetWorkMsgPanel:Update")
	print("aaaaaaaaa22222222333333333333333  ",msg)
   	if self.LocalizationManager.GetTranslation(msg) == nil then
        self.lab_Msg.text = msg

    else
        self.lblLocalize:SetTerm(msg)
    end 
	
	--self.lab_Msg.text=msg
	--local rand = math.random(101,110)
	--self.lblLocalize:SetTerm("E_ERROR_"..rand)
	self.showTime=showingTime or 10
    self.countTime = 0;
    self.mNoteMessage = noteMessage;
    self.DoAction=action
    RenderMgr.Add(function()
    	self:Update()
    end,"HallNetWorkMsgPanel:Update")
end

function HallNetWorkMsgPanel:Update()
	self.countTime=self.countTime+Time.deltaTime
	if self.showTime>0 and self.countTime>self.showTime then
		if self.mNoteMessage~=nil and self.mNoteMessage~="" then
			UIManager:GetInstance():ShowNoteMessage(self.mNoteMessage)
		end
		if self.DoAction~=nil then
			pcall(self.DoAction)
		end
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
	end
end

function HallNetWorkMsgPanel:HidePanel()
	RenderMgr.Remove("HallNetWorkMsgPanel:Update")
    --self.lab_Msg.text = "";

    self.mNoteMessage = nil;
    self.DoAction=nil
    self.countTime = 0
	self.showTime= 0
	LuaPanel.HidePanel(self)
end

-- 事件添加
--===========================================================================================================

function HallNetWorkMsgPanel:OUTAGE( )
	UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.NetWorkMsg)
end


function HallNetWorkMsgPanel:ONLINE( )
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
end

--===========================================================================================================
-- end


--设置子panel的深度
 function HallNetWorkMsgPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	-- if self.mUIRenderQueue ~= nil then
    --     self.mUIRenderQueue:SetShaderRenderQueue(depth + 12)
    -- end
end
--创建排行榜列表


function HallNetWorkMsgPanel:__delete( ... )
	--self.lab_Msg = nil
end
