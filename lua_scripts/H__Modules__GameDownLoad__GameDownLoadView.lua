GameDownLoadView = GameDownLoadView or BaseClass()

function GameDownLoadView:__init(  )
	self.panel = nil
	if self.isInited then return end 
	self.isInited = true
end

----必须实现
function GameDownLoadView:CreatePanel(callBack)
	if	self.panel == nil or not self.panel.isInited then
		self.panel = GameDownLoadPanel.New(callBack)
	end
end


function GameDownLoadView:OnProgress(left,total)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:OnProgress(left,total)
	end
end

function GameDownLoadView:SetPanelData(gameID,Text)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:SetPanelData(gameID,Text)
	end
end

----必须实现
function GameDownLoadView:ShowPanel(callBack)
	if self.panel ~=nil and self.panel.isInited then
		self.panel:ShowPanel(callBack)
	end
end

----必须实现
function GameDownLoadView:HidePanel()
	if self.panel ~=nil and self.panel.isInited then
		self.panel:HidePanel()
	end
end

----必须实现
function GameDownLoadView:IsPanelDestroy()
	return self.panel:IsPanelDestroy()
end

function GameDownLoadView:__delete( ... )
	if	self.panel ~=nil then
		self.panel:Destroy()
	end
	self.panel = nil
	self.isInited = false
end
