HallPromotionCodePanel = HallPromotionCodePanel or BaseClass(LuaPanel)

function HallPromotionCodePanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPromotionCode].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.HallPromotionCode].path
	self.mPanelID = UIPanelDefine.EWndID.HallPromotionCode
	self.mPanelType = UIPanelDefine.PanelType.FourLevel
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self:CreatePanel(0)----必须实现
end

--初始化ui界面  ----必须实现
function HallPromotionCodePanel:InitUI()
	local mTran = self.obj.transform
	self.texture = nil 
	self.mText = mTran:Find("Content/QrCodeBG/QRCode").gameObject:GetComponent(typeof(UITexture))
    local mCloseBtn = mTran:Find("Content/Button_Close").gameObject
    UIEventListener.Get(mCloseBtn).onClick = function() self:OnButtonClost() end
	LuaPanel.InitUI(self)
end


function HallPromotionCodePanel:OnButtonClost()
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.CloseButtonClick)
	--SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
	UIManager.GetInstance():HidePanel(self.mPanelID)
end


function HallPromotionCodePanel:ShowPanel(back)
	LuaPanel.ShowPanel(self,back)
	if self.texture == nil then
		if ConfigModuleModel.GetInstance().IsShowTuiGuang then
			
			HallPromotionModel.GetInstance():ReqShareLinks(function(data)
                if data then
                    self:LoadErWeiMaTexture(data.imglink) 
                end
            end)
        else
            self:LoadErWeiMaTexture(ConfigInfoMgr.URL_ErWeiMa)
        end
	end
	
end


function HallPromotionCodePanel:LoadErWeiMaTexture( url )
	-- body
	local OnComplete = function( wwwLoad )
		if(wwwLoad ~= nil) then
			local tex = wwwLoad.texture
			self.texture = tex
			self.mText.mainTexture = tex
			LuaEvent:DispatchEvent(EventName.RefreshQRCode,self.texture)
			tex = nil
			--Resources:UnloadUnusedAssets()
		end
	end
	DownLoadManager:BeginWWWRequest(url,OnComplete)
end

function HallPromotionCodePanel:__delete( ... )
	
end
