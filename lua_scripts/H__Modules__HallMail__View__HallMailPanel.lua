HallMailPanel = HallMailPanel or BaseClass(LuaPanel)

function HallMailPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallMail].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallMail].path
	self.mPanelID = UIPanelDefine.EWndID.HallMail
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallMailPanel:InitUI()
	self.IsFirst = true
	local mTran = self.obj.transform
	self.objNoMail = mTran:Find("Content/Tip_Label_NoMail").gameObject
	self.objNoMail:SetActive(false)
	self.panelMail = mTran:Find("Content/MailTitleView/ScrollView"):GetComponent(typeof(UIPanel))
	self.svMail = mTran:Find("Content/MailTitleView/ScrollView"):GetComponent(typeof(UIScrollView))
	self.objMailItem = mTran:Find("Content/MailTitleView/Item").gameObject
	self.objMailItem:SetActive(false)
	self.gridMailItemGrid = mTran:Find("Content/MailTitleView/ScrollView/Grid"):GetComponent(typeof(UIGrid))
	self.objCloseBtn = mTran:Find("Content/Common/Btn_Back/Background").gameObject
    UIEventListener.Get(self.objCloseBtn).onClick = self.OnButtonClose
    --邮件的详细信息面板
	self.panelMailInfo=mTran:Find("Content/MailShowMsg")
	self.panelMailTitle = mTran:Find("Content/MailTitleView").gameObject
    self.panelMailInfo.gameObject:SetActive(false)
	self.labelMailInfoContent=mTran:Find("Content/MailShowMsg/ScrollView/Label_Content"):GetComponent(typeof(UILabel))
	self.ScrollViewMailInfoContent=mTran:Find("Content/MailShowMsg/ScrollView"):GetComponent(typeof(UIScrollView))
    self.labelMailInfoTime=mTran:Find("Content/MailShowMsg/Label_Time"):GetComponent(typeof(UILabel))
    self.labelMailInfoTitle=mTran:Find("Content/MailShowMsg/Label_Title"):GetComponent(typeof(UILabel))
    
    self.model=HallMailModel:GetInstance()
    self.mGridList={}
	self:InitPool()
	

	local list_tweenList={}
    local TweenAn = mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, TweenAn)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)

    LuaPanel.InitUI(self)
end

function HallMailPanel:AddEvent()
	self.model:AddEventListener(HallMailConst.EventName_RefreshMail,self.Refresh,self)
	LuaEvent:AddEventListener(EventName.ResetPanel,self.ResetPanel,self)
end

function HallMailPanel:RemoveEvent( ... )
	self.model:RemoveEventListener(HallMailConst.EventName_RefreshMail,self.Refresh,self)
	LuaEvent:RemoveEventListener(EventName.ResetPanel,self.ResetPanel,self)
end

function HallMailPanel:InitPool()
	-- for i=1,10 do
	-- 	table.insert(self.mGridList,self:CreateItem(i) ) 
	-- end
end

--刷新邮件列表
function HallMailPanel:Refresh()
	local mMailDic = HallMailModel.GetInstance():GetMailList()
	for i=1,#self.mGridList do
		local item=self.mGridList[i]
		item:Recycle()
	end
	self:HaveMail(#mMailDic > 0)
	
	HallMailPanel.SortTableBy2Key(mMailDic,"iEmailStatus","iTime")
	for i,mailVo in ipairs(mMailDic) do
		
		local item=self.mGridList[i]
		
		if item == nil then
			item = self:CreateItem(i)
		end
		mailVo.onClick=function(item1) self:OnClickItem(item1) end
		item:SetGridData(mailVo)
	end

	if self.mGridList[1].obj.activeSelf then
		self:RefreshItem(self.mGridList[1])
	end

	self.gridMailItemGrid:Reposition()
	StartCoroutine(function()
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		yield_return(CS.UnityEngine.WaitForEndOfFrame())
		self.svMail:ResetPosition()
	end)
end

function HallMailPanel:CreateItem(i)
	local go = GameObject.Instantiate(self.objMailItem,self.gridMailItemGrid.transform)
	go.transform.parent = self.gridMailItemGrid.transform
	go:SetActive(true)
	go.name=tostring(i)
	local item=HallMailGrid.New(go)
	table.insert(self.mGridList,item)
	return item
end


--判断是否有邮件
function HallMailPanel:HaveMail( isHave )
	self.objNoMail:SetActive(not isHave)
	self.panelMailInfo.gameObject:SetActive(isHave)
	self.panelMailTitle:SetActive(isHave)
end

---排序邮件列表
function HallMailPanel.SortTableBy2Key(list,key1,key2,up)
	table.sort(list,function(a,b) 
		if a[key1]<b[key1] then
			return true
		elseif a[key1]==b[key1] then
			if a[key2]>b[key2] then
				return true
			else
				return false
			end
		end
	end)
end

---邮件标题点击事件
function HallMailPanel:OnClickItem( item )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	self:RefreshItem(item)
end

function HallMailPanel:RefreshItem(item)
	if not item or not item.vo then return end
	self.labelMailInfoTitle.text = item.vo.strTitle
	self.labelMailInfoTime.text = TimeStampToTime(item.vo.iTime)
	local tmp=StringSplit(item.vo.strContent,"|")
	local str=""
	for i,v in ipairs(tmp) do
		if i==2 then --金币需要转换
			v=HallGoldRateSToC(v)
		end
		str=StringFormat("{0}{1}",str,v)
	end
	self.labelMailInfoContent.text = str
	self.panelMailInfo.gameObject:SetActive(true)

	for i = 1, #self.mGridList do
		local button=self.mGridList[i]
		button:SetUpButton(button == item)
	end
	StartCoroutine(function()
		yield_return(WaitForSeconds(0.1)) 
		self.ScrollViewMailInfoContent:ResetPosition()
	end)
end

--关闭按钮点击事件
function HallMailPanel:OnButtonClose()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.HallMail)
	--SoundManager.GetInstance():StopPrePlaySound(true,SoundManager.SoundID.music_mail)
end

function HallMailPanel:ResetPanel( context )
	self:RemoveEvent()
	self.IsFirst = true
	--self.model:CleanMail()
end

--panel 显示的时候调用
function HallMailPanel:ShowPanel(callBack)
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.OpenWin)
	LuaPanel.ShowPanel(self,callBack)
	if (self.IsFirst) then
		self.IsFirst = false
		self:AddEvent()
	end
	self:Refresh()
	self.mTweenPlayer:ParallelPlay(false)
end




--设置子panel的深度
function HallMailPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
	self.panelMail.depth = depth+1
	self.ScrollViewMailInfoContent:GetComponent(typeof(UIPanel)).depth = depth + 2
end

function HallMailPanel:__delete( ... )
	self:RemoveEvent()
	self.objNoMail = nil
	self.panelMail = nil
	self.svMail = nil
	self.objMailItem = nil
	self.gridMailItemGrid = nil
	self.objCloseBtn = nil
	self.panelMailInfo = nil
	self.objOnCloseMailInfoBtn = nil
	self.labelMailInfoContent = nil
	self.labelMailInfoTime = nil
	self.labelMailInfoTitle = nil
	self.model = nil
	self.mGridList = nil
end
