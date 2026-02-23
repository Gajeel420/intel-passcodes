PlayerHeadPortainMgr = PlayerHeadPortainMgr or BaseClass()

function PlayerHeadPortainMgr:__init()
	self.mTextureURLDic={}--头像列表
	self:Init()
end

function PlayerHeadPortainMgr:GetInstance()
	if PlayerHeadPortainMgr.instance == nil then
		PlayerHeadPortainMgr.instance = PlayerHeadPortainMgr.New()	
	end
	return PlayerHeadPortainMgr.instance
end

function PlayerHeadPortainMgr:Init()
	if(self.HeadMark_Hall == nil) then
		local path = "Common/Materials/HeadMark_Hall.unity3d"
		local name=  "HeadMark_Hall"

		local cb = function (obj,assetName)
			if obj~=nil and obj[0]~=nil then
				self.HeadMark_Hall = obj[0]
			end
			resMgr:UnLoadAssetBundle(0,path,false)
		end

		resMgr:LoadMaterial(0,path,name,cb)
	end

	if(self.HeadMark_Game == nil) then
		local path = "Common/Materials/HeadMark_Game.unity3d"
		local name=  "HeadMark_Game"

		local cb = function (obj,assetName)
			if obj~=nil and obj[0]~=nil then
				self.HeadMark_Game = obj[0]				
			end
			resMgr:UnLoadAssetBundle(0,path,false)
		end

		resMgr:LoadMaterial(0,path,name,cb)

	end
	--CS事件调用
	LuaEvent:AddEventListener(EventName.CSTOLUASETHEAD,self.CacheBindHeadUserID,self)
end

---CS事件调用中转函数
---@param table context context.m_data[0] UITexture context.m_data[1] 用户ID context.m_data[2] 头像ID
function PlayerHeadPortainMgr:CacheBindHeadUserID(context)
	if context == nil then return end
	local go = context.m_data[0]
	local userID = context.m_data[1]
	local headID = context.m_data[2]
	self:BindHeadUserID(go, userID, headID)
end


--- 绑定用户头像
--- @param UITexture go
--- @param string url 头像下载地址
--- @param number headType  o 不做任何处理 1 圆形  2 游戏中圆形
--- @param int numberimgNo  头像下标
function PlayerHeadPortainMgr:BindHeadURL( go,url,headType,imgNo,isUseCache )

	local mUITexture = go:GetComponent(typeof(UITexture))
	if mUITexture ~= nil then
		imgNo = imgNo == nil and 1 or imgNo
		-- if headType == 1 then
		-- 	mUITexture.material = self.HeadMark_Hall
		-- elseif headType == 2 then
		-- 	mUITexture.material = self.HeadMark_Game
		-- end
	end
	local m_IsUseCache = true
	if isUseCache~=nil then
		m_IsUseCache = isUseCache
	end
	if self.mTextureURLDic[url] ~= nil and m_IsUseCache then
		mUITexture.mainTexture = self.mTextureURLDic[url]
		mUITexture = nil
	else
		mUITexture.mainTexture = UIPanelDefine.GetHeadTexturByIconIndex(imgNo)
		local OnComplete = function( wwwLoad )
			if(wwwLoad ~= nil) then
				self.mTextureURLDic[url] = wwwLoad.texture
				mUITexture.mainTexture = self.mTextureURLDic[url]
				mUITexture = nil
			end
		end
		DownLoadManager:BeginWWWRequest(url,OnComplete)
	end
end

--- 绑定用户头像
--- @param UITexture go
--- @param string url 头像下载地址
--- @param number headType  o 不做任何处理 1 圆形  2 游戏中圆形
--- @param int numberimgNo  头像下标
function PlayerHeadPortainMgr:BindHeadUserID( go,userID,headType,imgNo,isUseCache)
	headType = headType or 0
	local url = StringFormat("{0}{1}.png",ConfigInfoMgr.URL_HeadPortain,userID)
	if imgNo == nil or imgNo == 0 then
		imgNo = 1
	end
	local m_IsUseCache = false
	if isUseCache~=nil then
		m_IsUseCache = isUseCache
	end
	self:BindHeadURL(go,url,headType,imgNo,m_IsUseCache)
end

--- 根据头像ID绑定用户头像
--- @param UITexture go
--- @param string url 头像下载地址
--- @param number headType  o 不做任何处理 1 圆形  2 游戏中圆形
--- @param int numberimgNo  头像下标
function PlayerHeadPortainMgr:BindHeadByHeadNo(go,headType,imgNo)
	local mUITexture = go:GetComponent(typeof(UITexture))
	if mUITexture ~= nil then
		imgNo = imgNo == nil and 1 or imgNo
		if headType == 1 then
			mUITexture.material = self.HeadMark_Hall
		elseif headType == 2 then
			mUITexture.material = self.HeadMark_Game
		end
	end
	mUITexture.mainTexture = UIPanelDefine.GetHeadTexturByIconIndex(imgNo)
	mUITexture = nil	
end

--- 头像上传
---@param int userID
---@param string headUrl
---@param int imgNo
function PlayerHeadPortainMgr:HeadUpload( userID,headUrl,imgNo )
	--body
	-- DownLoadManager:BeginUploadHeadPortait(userID,headUrl,UIPanelDefine.GetHeadTexturByIconIndex(imgNo))
end


function PlayerHeadPortainMgr:__delete( ... )
	LuaEvent:RemoveEventListener(EventName.CSTOLUASETHEAD,self.CacheBindHeadUserID,self)
end