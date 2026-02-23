LuaPanel = LuaPanel or BaseClass(InnerEvent)
function LuaPanel:__init(...)
	self.obj = nil
	self.isInited = true
	self.mPanelType = UIPanelDefine.PanelType.Normal
	self.mPanelHideType = UIPanelDefine.PanelHideType.Normal
	self.mPanelDestroyType=UIPanelDefine.PanelDestroyType.NoDestroy
	self.mPanelID = 0
	self.assetName = ""--资源名称
	self.resPath = ""--资源路径
	self.createPanelCallBack = nil
	self.callBack = nil
	self.mIsVisible = false
	self.isOpen=false
	self.depth=nil
end

function LuaPanel:CreatePanel(gameId)
	--实例化panel prefab	
	self:LoadPanelPrefab(gameId)
end

function LuaPanel:LoadPanelPrefab( gameId )
	local cb = function (obj)
		local prefab = obj[0]
		if prefab ~=nil then
			self.obj = GameObject.Instantiate(prefab)
			self.obj.transform.parent = layMgr:GetRoot().transform
			self.obj.transform.localScale = Vector3.one
			if self.mPanelID==UIPanelDefine.EWndID.HallWealthList or self.mPanelID==UIPanelDefine.EWndID.HallMail or self.mPanelID==UIPanelDefine.EWndID.HallPlayerInfo or self.mPanelID==UIPanelDefine.EWndID.HallVIP then
				if GameConst.ScreenScale>2 then
					self.obj.transform.localScale = Vector3(0.8,0.8,1)
				end
			end
			self.obj.transform.localPosition = Vector3.zero
			self.obj:SetActive(false)
		end
		if self:IsPanelDestroy() then
			UIResources.mAssetBundles[self.assetName]=self.resPath
		end
		prefab = nil
		if self.obj ~=nil and self.createPanelCallBack ~=nil then
			pcall(self.createPanelCallBack,self)
		elseif self.obj ==nil then
			error("prefab:"..self.assetName.."  is nil!!!!!!!")
		elseif self.createPanelCallBack ==nil then
			error("prefab:"..self.assetName.."  createPanelCallBack is nil!!!!!")
		end
	end
	resMgr:LoadPrefabEx(gameId,self.resPath,self.assetName,cb)

end



function LuaPanel:InitUI( )	
	if self.callBack ~=nil then
		pcall(self.callBack,self.mPanelID)
	end
end

function LuaPanel:IsPanelDestroy( )
	return self.mPanelDestroyType == UIPanelDefine.PanelDestroyType.Destroy
end

function LuaPanel:HidePanel( )
	self:SetVisible(false)
end

function LuaPanel:ResetPanel(callBack)
	-- body
end

function LuaPanel:SetVisible( isVisible )
	self.isOpen=isVisible
	self.mIsVisible = isVisible
	if self.obj.activeSelf ~= isVisible then 
		self.obj:SetActive(isVisible)
	end
end

function LuaPanel:ShowPanel(callBack)
	self:SetVisible(true)
	if callBack ~= nil then
		pcall(callBack,self)
	end
end

function LuaPanel:SetPanelstartingRenderQueue(value)
	self.obj:GetComponent(typeof(UIPanel)).renderQueue = UIPanel.RenderQueue.StartAt
	self.obj:GetComponent(typeof(UIPanel)).startingRenderQueue = value
end


function LuaPanel:GetPanelstartingRenderQueue()
	return self.obj:GetComponent(typeof(UIPanel)).startingRenderQueue
end

function LuaPanel:__delete( )
	if self.obj then
		GameObjectDestroy(self.obj)
	end
	self.obj = nil
	self.isInited = false
	self.mPanelType = 0
	self.mPanelHideType = UIPanelDefine.PanelHideType.Normal
	self.mPanelID = 0
	self.assetName = ""--资源名称
	self.resPath = ""--资源路径
	self.createPanelCallBack = nil
	self.callBack = nil
	self.mIsVisible = false
	
end

-----
function LuaPanel:GetPanelDepth( )
	return self.obj:GetComponent(typeof(UIPanel)).depth
end

function LuaPanel:SetPanelDepth(depth)
	self.obj:GetComponent(typeof(UIPanel)).depth = depth
	if depth > 3000 then
		self:SetPanelstartingRenderQueue(depth)
	end
	self.depth=depth
end
