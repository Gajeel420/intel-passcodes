HallTopInfoView = HallTopInfoView or BaseClass()

function HallTopInfoView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function HallTopInfoView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = HallTopInfoPanel.New(callBack)
	end
end

----必须实现
function HallTopInfoView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end


----必须实现
function HallTopInfoView:HidePanel(callBack,...)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel(callBack,...)
	end
end



-- 跳转到下一个界面
function HallTopInfoView:GoToNextHallPanel(sourPanelID,dstPanelID)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:GoToNextHallPanel(sourPanelID,dstPanelID)
	end
end

function HallTopInfoView:GetCurHallPanelTypeID( )
	if self.panel ~=nil and self.panel.isInited then
		return self.panel:GetCurHallPanelTypeID( )
	end
end

-- ResetAnimation
function HallTopInfoView:ResetAnimation()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ResetAnimation()
	end
end













----必须实现
function HallTopInfoView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end
function HallTopInfoView:OnDestroyPanel()
	self.panel:Destroy()
	self.panel=nil
end


function HallTopInfoView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end