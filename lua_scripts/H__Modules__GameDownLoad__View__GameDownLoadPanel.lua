GameDownLoadPanel = GameDownLoadPanel or BaseClass(LuaPanel)

function GameDownLoadPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.GameDownLoad].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.GameDownLoad].path
	self.mPanelID = UIPanelDefine.EWndID.GameDownLoad
	self.mPanelType = UIPanelDefine.PanelType.Prompt
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function GameDownLoadPanel:InitUI()
	local mTran = self.obj.transform
 	self.mSlider_Download = mTran:Find("Content/GameItem/Slider_Download"):GetComponent(typeof(UISlider));
	self.mSlider_Download.value = 1;
	self.mLabel_Prompt = mTran:Find("Content/Label_Msg"):GetComponent(typeof(UILabel));
	LuaPanel.InitUI(self)
end

function GameDownLoadPanel:OnProgress(left,total)
	if total == 0 then
		self.mSliderProgress.value = 0;
	else
		local left=left
		self.mSlider_Download.value = 1-left/total
	end
end

function GameDownLoadPanel:SetPanelData(gameID,Text)
	self.mLabel_Prompt.text = Text
end

--设置子panel的深度
 function GameDownLoadPanel:SetPanelDepth(depth)
	LuaPanel.SetPanelDepth(self,depth)
end
--创建排行榜列表


function GameDownLoadPanel:__delete( ... )
	self.mSlider_Download = nil
	self.mLabel_Prompt = nil
end
