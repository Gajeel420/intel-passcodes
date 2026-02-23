HallSaveGamePanel = HallSaveGamePanel or BaseClass(LuaPanel)

function HallSaveGamePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSaveGame].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallSaveGame].path
	self.mPanelID = UIPanelDefine.EWndID.HallSaveGame
	self.createPanelCallBack = self.InitUI----必须实现
	self.mPanelType = UIPanelDefine.PanelType.SecondLevel --页面层级
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallSaveGamePanel:InitUI()
	local mTran = self.obj.transform
	self.mBtn_Save = mTran:Find("Content/Button_Save").gameObject
	UIEventListener.Get(self.mBtn_Save).onClick = function(go)self:OnSaveGameButton(go)	end
	self.mBtn_Clsoe = mTran:Find("Content/Button_Close").gameObject
	UIEventListener.Get(self.mBtn_Clsoe).onClick = function(go)self:OnButtonClose(go)	end

	local list_tweenList = {}
	local tweenScale=mTran:Find("Content"):GetComponent(typeof(TweenScale))
    table.insert(list_tweenList, tweenScale)
    self.mTweenPlayer=TweenPlayer.CreateTweenPlayer(list_tweenList)
	LuaPanel.InitUI(self)
end


function HallSaveGamePanel:OnSaveGameButton(go)
	local url =  StringFormat("{0}{1}",ConfigModuleModel.GetInstance().BannerURL,ConfigModuleModel.GetInstance().SaveGameSuffix) 
	Application.OpenURL(url)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallSaveGamePanel:OnButtonClose(go)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end

function HallSaveGamePanel:ShowPanel(callBack)
	LuaPanel.ShowPanel(self,callBack)
	self.mTweenPlayer:ParallelPlay(false)
end

function HallSaveGamePanel:__delete( ... )
	
end
