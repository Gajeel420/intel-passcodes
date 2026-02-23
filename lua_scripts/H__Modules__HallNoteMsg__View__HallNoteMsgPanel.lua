HallNoteMsgPanel = HallNoteMsgPanel or BaseClass(LuaPanel)

function HallNoteMsgPanel:__init(callBack)
	self.assetName = UIPanelDefine.Panel[UIPanelDefine.EWndID.NoteMsg].name
	self.resPath = UIPanelDefine.Panel[UIPanelDefine.EWndID.NoteMsg].path
	self.mPanelID = UIPanelDefine.EWndID.NoteMsg
	self.createPanelCallBack = self.InitUI----必须实现
	self.callBack = callBack----必须实现
	self.mPanelType = UIPanelDefine.PanelType.Prompt --- 页面层级
    self.mPanelDestroyType = UIPanelDefine.PanelDestroyType.NoDestroy
	self:CreatePanel(0)----必须实现
	
end

--初始化ui界面  ----必须实现
function HallNoteMsgPanel:InitUI()
	local mTran = self.obj.transform
	local mTranUI = mTran:Find("Label_Msg")
    if mTranUI ~= nil then
    	self.mLabel_Msg = mTranUI.gameObject:GetComponent(typeof(UILabel))
        self.lblLocalize = mTranUI.gameObject:GetComponent(typeof(Localize))
    end
    mTranUI = mTran:Find("Sprite_Bg")
    if mTranUI ~= nil then    	
    	self.mSprite_BG = mTranUI.gameObject
    end
    self.isShowed = true -- 是否已经显示
    self.showTime = 1 -- 窗体显示时间
    self.position = Vector3.zero -- 窗体显示位置
    self.countTime = 0 -- 当前倒数时间
    self.LocalizationManager = CS.I2.Loc.LocalizationManager
	LuaPanel.InitUI(self)
end


--显示信息
--==================================================================
function HallNoteMsgPanel:Update()
	if self.isShowed then
		self.countTime = self.countTime + Time.deltaTime
		if self.countTime > self.showTime then
			UIManager:GetInstance():HidePanel(self.mPanelID) -- 隐藏自己
		end
	end
	
end

-- 显示窗体 msg = 显示信息   showingTime = 显示时间 默认0.5秒   isCenter = 是否居中显示
function HallNoteMsgPanel:ShowNotMsg(msg, showingTime, isCenter,isForce)    
    --self.mLabel_Msg.text = msg
    --print("aaaaaaaaaeeeeeeeeeeeeeeeeeee  ",self.LocalizationManager.GetTranslation(msg))
  
    if isForce then
        self.mLabel_Msg.text = msg
    else
        if self.LocalizationManager.GetTranslation(msg) == nil then
            self.mLabel_Msg.text = msg

        else
            self.lblLocalize:SetTerm(msg)
        end 
            
    end
     print("aaaaaaaaaaaaaa111111122222222333333444444444     ",msg)
    if showingTime ~= nil and type(showingTime) == "number" then
    	self.showTime = showingTime
    else
    	self.showTime = 1
    end

    -- if isCenter == true or isCenter == nil then
    -- 	self.position = Vector3.zero -- 窗体显示位置
    -- else
    -- 	self.position = Vector3(0, 14, 0) -- 窗体显示位置
    -- end

    self.isShowed = true
    self.countTime = 0

    --self.mLabel_Msg.gameObject.transform.localPosition = self.position
    --self.mSprite_BG.transform.localPosition = self.position

    RenderMgr.Add(function ( )
		self:Update()
	end,"HallNoteMsgPanel:Update")
end
--==================================================================
--end


--当窗体隐藏时候的操作
--==================================================================
function HallNoteMsgPanel:HidePanel( ... )
	
	RenderMgr.Remove("HallNoteMsgPanel:Update")

    --self.mLabel_Msg.text = ""
    self.isShowed = false
    self.showTime = 0

	LuaPanel.HidePanel(self)
end


--==================================================================
--end



-- --设置子panel的深度
--  function HallNoteMsgPanel:SetPanelDepth(depth)
-- 	LuaPanel.SetPanelDepth(self,depth)
-- end


function HallNoteMsgPanel:__delete( ... )

	self.mLabel_Msg = nil
	self.mSprite_BG = nil

	self.isShowed = nil
    self.showTime = nil
    self.position = nil
    self.countTime = nil
end
