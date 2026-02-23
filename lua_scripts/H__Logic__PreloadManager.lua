PreloadManager=PreloadManager or BaseClass()

function PreloadManager:__init()
	
end

--预加载
function PreloadManager:PreLoadRes(callBack)
	self:PreLoadTexture(callBack)
end

--预加载必要的texture
function PreloadManager:PreLoadTexture(callBack)

	local tt=0
	local count=#UIPanelDefine.PreLoadTex
	if count==0 then
		self:PreLoadAtlas(callBack)
		return
	end
	for i=1,count do
		local texName1 = UIPanelDefine.PreLoadTex[i]
		local tex = UIResources.mUITextureDic[texName1]
		if tex == nil then 
			if	UIPanelDefine.UITexture[texName1] ~=nil then
				local path = UIPanelDefine.UITexture[texName1].path
				local name=  UIPanelDefine.UITexture[texName1].name
				local cb = function (obj,texName)
					print(obj)
					if obj~=nil and obj[0]~=nil then
						UIResources.mUITextureDic[texName] = obj[0]
					end
					local path2 = UIPanelDefine.UITexture[texName].path
					UIResources.mAssetBundles[texName]=path2
					tt=tt+1
				 	if tt==count then --当最后一个返回之后表示贴图加载完毕
				 		self:PreLoadAtlas(callBack)
				 	end
				end
				resMgr:LoadUITexture(0,path,name,cb)
			else
				error(texName1.."     ==nil")
			end
		else
			tt=tt+1
			if tt==count then
				self:PreLoadAtlas(callBack)
			end
		end
	end
end

function PreloadManager:PreLoadAtlas(callBack)
	print("预加载必要的Atlas")
	local tt=0
	local count=#UIPanelDefine.PreLoadAtlas
	if count==0 then
		self:PreLoadFont(callBack)
		return
	end

	for i=1,count do
		local atlasName1 = UIPanelDefine.PreLoadAtlas[i]
		local atlas = UIResources.mAtlasDic[atlasName1]
		if atlas == nil then 
			if	UIPanelDefine.UIAltas[atlasName1] ~=nil then
				local path = UIPanelDefine.UIAltas[atlasName1].path
				local name=  UIPanelDefine.UIAltas[atlasName1].name
				
				local cb = function (obj,fontName)
					if obj~=nil and obj[0]~=nil then
						UIResources.mAtlasDic[fontName] = obj[0]:GetComponent(typeof(UIAtlas))
					end
					local path2 = UIPanelDefine.UIAltas[fontName].path
					tt=tt+1
					UIResources.mAssetBundles[fontName]=path2
					print("-------------------  PreLoadAtlas  tt == ",tt)
					if tt==count then
						self:PreLoadFont(callBack)
					end
				end
				resMgr:LoadUIAtlas(0,path,name,cb)
			else
				UDebug.Log(atlasName1.."     ==nil")
			end
		else
			tt=tt+1
			if tt==count then
				self:PreLoadFont(callBack)
			end
		end
	end
end
function PreloadManager:PreLoadFont(callBack)
	print("预加载必要的Font")
	local tt=0
	local count=#UIPanelDefine.PreLoadFont
	if count==0 then
		self:PreLoadUIPanel(callBack)
		return
	end
	for i=1,count do
		local fontName1 = UIPanelDefine.PreLoadFont[i]
		
		local font = UIResources.mFontDic[fontName1]
		if font == nil then 
			if	UIPanelDefine.UIFont[fontName1] ~=nil then
				local path = UIPanelDefine.UIFont[fontName1].path
				local name=  UIPanelDefine.UIFont[fontName1].name
				local cb = function (obj,fontName)
					if obj~=nil and obj[0]~=nil then
						UIResources.mFontDic[fontName] = obj[0]:GetComponent(typeof(UIFont))
					end
					local path2 = UIPanelDefine.UIFont[fontName].path
					tt=tt+1
					UIResources.mAssetBundles[fontName]=path2
					if tt==count then
						self:PreLoadUIPanel(callBack)
					end
				end
		
				resMgr:LoadUIAtlas(0,path,name,cb)
			else
				UDebug.Log(fontName1.."     ==nil")
			end
		else
			tt=tt+1
			if tt==count then
				self:PreLoadUIPanel(callBack)
			end
		end
	end
end

function PreloadManager:PreLoadUIPanel(callBack)
	print("加载UI")
	if UIPanelDefine.PreLoad ~=nil then
		local  totalNum = #UIPanelDefine.PreLoad
		if totalNum==0 then
			pcall(callBack,self)
			return
		end

		local t=0
		for _,v in ipairs(UIPanelDefine.PreLoad) do
			local id = UIPanelDefine.EWndID[v]
		
			if id==nil then
				UDebug.Log("PreloadManager:PreLoadUIPanel:id==nil")
			end

			if	GameConstDefine.PanelCtrl[id] ==nil then
				print("ID"..id.."==nil","请检查预加载的数量")
				return
			end
			local cb2 = function ()
				t=t+1
				if t==totalNum then
					if callBack then
						pcall(callBack,self)
					end
				end
			end
			UIManager:GetInstance():PreLoadUIPanel(id,cb2)
		end
	end
end


function PreloadManager:GetInstance()
	if PreloadManager.instance == nil then
		PreloadManager.instance = PreloadManager.New()
	end
	return PreloadManager.instance
end

function PreloadManager:__delete()
	
end