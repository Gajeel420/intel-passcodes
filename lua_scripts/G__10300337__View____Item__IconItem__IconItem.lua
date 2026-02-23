IconItem=BaseClass()

function IconItem:__init(gameObj)

	self.gameObject=gameObj
	self:InitData()
	self:InitView()

end

--初始化数据
function IconItem:InitData()
	self.gameData=GameUIManager.GetInstance().GameData  --游戏数据
	self.itemSpriteRandomName="FKDHZ_Icon_"				--随机图标前缀
	self.ItemNum=0									--图标的编号
end


--初始化界面
function IconItem:InitView()
	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
	
end

--初始化UI数据
function IconItem:InitUIViewData()
	self.ItemSpriteObj=nil 				--图片
	self.ItemSprite=nil					--精灵
	self.itemSpriteObjRandom=nil		--旋转的时候使用的随机图标  可以减少性能开销
	self.itemSpriteRandom=nil			--旋转精灵
	self.ItemAnimtainObj=nil				--动画
	self.ItemAnimtain=nil					
	self.ItemBoundObj=nil					--边框
	self.ItemBoundAnimation=nil				--边框动画
	self.WildEffectWin=nil
	
end

function IconItem:FindView()
	local tf=self.gameObject.transform
	self.ItemSpriteObj=tf:Find("Item/Sprite")--.gameObject
	self.ItemSprite=self.ItemSpriteObj:GetComponent(typeof(UISprite))
	self.ItemSpriteAnim=tf:Find("Item/Anim").gameObject
	
	self.itemSpriteObjRandom=tf:Find("SpriteRandom").gameObject
	self.itemSpriteRandom=self.itemSpriteObjRandom:GetComponent(typeof(UISprite))
	
	self.EffectWin=tf:Find("Effect").gameObject
	local EffectAnim11=tf:Find("Effect/Item11")
	if EffectAnim11 then
		self.EffectAnim=EffectAnim11:GetComponent(typeof(Animation))
	end

	self.m_Icon_Kuang = tf:Find("Effect/Item/Kuang"):GetComponent(typeof(UISprite))
end

--初始化UI界面
function IconItem:InitUIView()
	self:SetItemSpriteObj(false)	
	self:SetItemSpriteRandomObj(false)
	self:SetItemSpriteObj(true)
	self:SetWinEffectPanel(false)
end


function IconItem:ReCycleItem()
	GameObjectPool:GetInstance():ReCycleToGameObject(self.gameObject)
end


function IconItem:IsShowIconPanel(IsDisplay)
	CommonHelp.SetActive(self.gameObject,IsDisplay)
end

function IconItem:IsShowItemAnimaPanel(IsDisplay)
	CommonHelp.SetActive(self.ItemSpriteAnim,IsDisplay)
end

function IconItem:SetIconPanelPosition(pos)
	self.gameObject.transform.localPosition=pos
end


function IconItem:IsShowSpritePanel(IsDisplay)
	CommonHelp.SetActive(self.ItemSpriteObj.gameObject,IsDisplay)
end

function IconItem:SetItemSpriteObj(IsDisplay)
	CommonHelp.SetActive(self.ItemSpriteObj.parent.gameObject,IsDisplay)
end


function IconItem:SetItemSpriteRandomObj(IsDisplay)
	CommonHelp.SetActive(self.itemSpriteObjRandom,IsDisplay)
end


function IconItem:SetWinEffectPanel(IsDisplay)
	CommonHelp.SetActive(self.EffectWin,IsDisplay)
end

function IconItem:SetItemScale(IsDisplay)
	if IsDisplay then
		self.gameObject.transform.localScale = Vector3(0.85,0.85,0)
	else
		self.gameObject.transform.localScale = Vector3.one
	end
end


function IconItem:SetItemSpriteAndRandomSpriteObj(IsDisplay)
	self:SetItemSpriteObj(IsDisplay)
	self:SetWinEffectPanel(IsDisplay)
	self:SetItemSpriteRandomObj(not IsDisplay)
end


function IconItem:SetitemSpriteName(num)
	if num<10 then
		num="0"..num
	end
	local tempName=self.itemSpriteRandomName..num
	self.ItemSprite.spriteName=tempName
end


function IconItem:SetitemSpriteObjRandomName(num,isDim)
	if num==127 then
		num = math.random(0,5)
	end
	if num<10 then
		num="0"..num
	end
	local tempName=self.itemSpriteRandomName..num
	if isDim then
		tempName=tempName.."_dim"
	end
	
	self.itemSpriteRandom.spriteName=tempName
end


function IconItem:StartIconItemAnimation()
	self:SetWinEffectPanel(true)
	self:SetItemSpriteObj(false)
	if self.ItemNum==5 then
		self:SetSprite02Show(true)
	end
end

function IconItem:StopIconItemAnimation()
	self:SetItemSpriteObj(true)
	self:SetWinEffectPanel(false)
end


function IconItem:SetIconNum(num)
	self.ItemNum=num
end


function IconItem:GetIconNum()
	return self.ItemNum
end

function IconItem:SetItemSpriteAndRandomSpriteObj1(IsDisplay)
	self:SetitemSpriteObjRandomName(math.random(0,2))
	self:SetItemSpriteObj(IsDisplay)
	self:SetItemSpriteRandomObj(not IsDisplay)
end

function IconItem:SetSprite02Show(IsDisplay)
	self.Sprite02 = self.gameObject.transform:Find("Item/Sprite02").gameObject
	self.Sprite02:SetActive(IsDisplay)
end

return IconItem