HallGameGrid = HallGameGrid or BaseClass(LuaUI)

function HallGameGrid:__init(vo)
	self.vo=vo
	self.assetName = vo.gameID--资源名称

	self.resPath = "Phone/Prefabs/Game/"..vo.gameID..".unity3d"--资源路径
	if self.vo.isShowBig then
		self.resPath = "Phone/Prefabs/Game_Big/"..vo.gameID..".unity3d"--资源路径
	end

	self.createCallBack = self.InitUI	

	self:CreateUI(0)
	
end
--初始化ui界面  ----必须实现
function HallGameGrid:InitUI()
	local mTran = self.obj.transform
	self.obj.transform.parent=self.vo.parent
	self.obj.transform.localPosition = Vector3.zero
    self.obj.transform.localScale = Vector3.one
	self.obj.transform.localEulerAngles = Vector3.zero
	local mTranUI = mTran:Find("BG/Effect/Particle System")
	local mUiRend = nil
	if mTranUI ~= nil then
		mTranUI.gameObject:SetActive(false)
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/Effect/Particle System (1)")
	if mTranUI ~= nil then
		mTranUI.gameObject:SetActive(false)
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end
	mTranUI = mTran:Find("BG/Effect/Particle System (2)")
	if mTranUI ~= nil then
		mTranUI.gameObject:SetActive(false)
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end
	mTranUI = mTran:Find("BG/Effect/Particle System (3)")
	if mTranUI ~= nil then
		mTranUI.gameObject:SetActive(false)
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/icon_02/Particle System")
	if mTranUI ~= nil then
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/icon_01/icon_00/08/icon_011/06/Particle System (1)")
	if mTranUI ~= nil then
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/icon_01/icon_00/08/icon_011/06/Particle System")
	if mTranUI ~= nil then
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/icon_01/02/Particle System")
	if mTranUI ~= nil then
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	mTranUI = mTran:Find("BG/Icon/icon_01/02/Particle System")
	if mTranUI ~= nil then
		mUiRend = mTranUI:GetComponent(typeof(UIRenderClip_TextureOffsetXY_Panel))
		if mUiRend ~= nil then
			mUiRend.mRenderQueueOffsetStart = 7
		end
	end

	self.obj:SetActive(true)
	mUiRend = nil 
	mTranUI = nil 
	mTran = nil
	if self.vo.callBack then
		pcall(self.vo.callBack,self)
	end
end

function HallGameGrid:__delete( ... )
	self.vo = nil
end
