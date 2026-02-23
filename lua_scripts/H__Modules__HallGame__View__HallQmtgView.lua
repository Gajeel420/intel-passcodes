HallQmtgView = BaseClass()

function HallQmtgView:__init(go)
   
    self.obj = go
    self:InitView()
end

function HallQmtgView:InitView()
    self.IsInit = false
    self.mWebUrl= ""
    self.texture = nil
    local mTran = self.obj.transform
    self.mCurrentLeftScrollGridItemIndex =1
    self.mCenterList = {}
    self.mLeftDotItems = {}
    self.mLeftSelectDotItems = {}
    self.mScrollView = mTran:Find("Content").gameObject:GetComponent(typeof(UIScrollView))
    self.mDotPanel = mTran:Find("Bottom").gameObject:GetComponent(typeof(UIPanel))

    self.mTexture_Link = mTran:Find("Content/Grid/1/quanmindaili_1/ErWeiMa").gameObject:GetComponent(typeof(UITexture))
    self.mLabel_Rabet =  mTran:Find("Content/Grid/4/quanmindaili_4/Label").gameObject:GetComponent(typeof(UILabel))
    self.mCenterOnChild=mTran:Find("Content/Grid"):GetComponent(typeof(UICenterOnChild))

    for i = 1, 5 do
        local path = StringFormat("Bottom/Dot/{0}/Sprite02",i)
        local item=mTran:Find(path).gameObject
        item:SetActive(true)
        item.transform:SetSiblingIndex(i)
        table.insert(self.mLeftDotItems, item)

        local path = StringFormat("Bottom/Dot/{0}/Sprite01",i)
        local item=mTran:Find(path).gameObject
        table.insert(self.mLeftSelectDotItems, item)
       

        path = StringFormat("Content/Grid/{0}",i)
        item = mTran:Find(path).gameObject
        UIEventListener.Get(item).onClick = function(go) self:OnCenterClick(go)  end
        table.insert(self.mCenterList,item )
 
    end

    self.mCenterOnChild.onFinished=function() self:OnLeftScrollGridCenter() end
    self.mAgentRabet = nil
    LuaEvent:AddEventListener(EventName.RefreshQRCode,self.RefreshQRCodeFun,self)
end

function HallQmtgView:RefreshQRCodeFun(content)
   
    if content.m_data[0] ~= nil then
        self.mTexture_Link.mainTexture = content.m_data[0]
    end
end


function HallQmtgView:ShowPanel()
    if self.texture == nil then
        if ConfigModuleModel.GetInstance().IsShowTuiGuang then
            HallPromotionModel.GetInstance():ReqShareLinks(function(data)
                if data then
                    self.mWebUrl = data.weblink
                    self:LoadErWeiMaTexture(data.imglink) 
                end
            end,false)
        else
            self.mWebUrl = ConfigModuleModel.GetInstance().BannerURL
            self:LoadErWeiMaTexture(ConfigInfoMgr.URL_ErWeiMa)
        end
    end
       
    if self.mAgentRabet == nil then
        StoreModuleController.GetInstance():RequiredPayMoneyList(function()
            self.mAgentRabet = StoreModuleModel:GetInstance().Corner["61"]
            self.mLabel_Rabet.text = StringFormat("{0}%",self.mAgentRabet)
        end,false)
    end
end

function HallQmtgView:OnCenterClick(go)
    if go.name == "3" then
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPromotion)
    elseif go.name == "5" then
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallSaveGame)
    elseif go.name == "2" then
        if self.mWebUrl~= "" then
            PhoneManager:MyClipDataToClipboard(self.mWebUrl)
            UIManager:GetInstance():ShowNoteMessage("Copy_successfully")
        end
        --PhoneManager:MyStartWeiXin()
    elseif go.name == "1" then
        UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.HallPromotionCode)
    end
end

function HallQmtgView:LoadErWeiMaTexture( url )
	-- body
	local OnComplete = function( wwwLoad )
		if(wwwLoad ~= nil) then
			local tex = wwwLoad.texture
			self.texture = tex
            self.mTexture_Link.mainTexture = tex
            tex = nil
			--Resources:UnloadUnusedAssets()
		end
	end
	DownLoadManager:BeginWWWRequest(url,OnComplete)
end


function HallQmtgView:OnLeftScrollGridCenter()
    for i = 1, #self.mCenterList do
        if self.mCenterList[i]== self.mCenterOnChild.centeredObject then
           
            self.mCurrentLeftScrollGridItemIndex=i
            --self.mLeftDotItems[i]:SetActive(false)
            self.mLeftSelectDotItems[i]:SetActive(true)
        else
            --self.mLeftDotItems[i]:SetActive(true)
            self.mLeftSelectDotItems[i]:SetActive(false)
        end
    end

    RenderMgr.AddInterval(function() 
        RenderMgr.Remove("HallQmtgView:UpdateLeftScroll")
        if self.mCurrentLeftScrollGridItemIndex+1> #self.mCenterList then
            self.mCenterOnChild:CenterOn(self.mCenterList[1].transform)
        else
            self.mCenterOnChild:CenterOn(self.mCenterList[self.mCurrentLeftScrollGridItemIndex+1].transform)
        end
        end,"HallQmtgView:UpdateLeftScroll",5,0)
end



function HallQmtgView:SetDepth(depth)
    -- self.mScrollView:GetComponent(typeof(UIPanel)).depth = depth + 1
    -- self.mDotPanel.depth = depth +2
    SetPanelstartingRenderQueue(self.mScrollView.gameObject,3356)
    SetPanelstartingRenderQueue(self.mDotPanel.gameObject,3360)
   
end

function HallQmtgView:__delete()
    LuaEvent:RemoveEventListener(EventName.RefreshQRCode,self.RefreshQRCodeFun,self)
end