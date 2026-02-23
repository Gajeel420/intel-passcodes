GameIconPanel=BaseClass()

function GameIconPanel:__init(gameObj)
	self.gameObject=gameObj
	
	self:InitData()
	self:InitView()

end

--初始化数据
function GameIconPanel:InitData()
	self.gameData=GameUIManager.GetInstance().GameData  
	self.ItemIcontCount=GameDefine.SHZ_CommonVar.ItemCount					
	self.ItemIcontListCount_H=GameDefine.SHZ_CommonVar.ANI_COL						
	self.ItemIcontListCount_V=GameDefine.SHZ_CommonVar.ANI_ROW+1						
	self.MaskName="mask"
end


--初始化界面
function GameIconPanel:InitView()
	self:InitUIViewData()
	self:FindView()		
end

--初始化UI数据
function GameIconPanel:InitUIViewData()
		
end

function GameIconPanel:FindView()
	local tf=self.gameObject.transform
	self.gameData.GameObjectInstanceParent=tf:Find("com/InstantiateGameObject").gameObject  
	self.TextTrueMask=tf:Find("com/GunDong/WuJian"):GetComponent(typeof(UIPanel))
	self:FindItemIcon(tf)
	self:FindIconPosList(tf)
	self.KAnim=tf:Find("com/GunDong"):GetComponent(typeof(Animation))
	--self.IconSwapAnim=tf:Find("com/GunDong/WuJianMask/WuJian_Down"):GetComponent(typeof(Animation))
	self.MaskBG=tf:Find("com/GunDong/WuJian/Mask").gameObject
	CommonHelp.SetActive(self.MaskBG,false)
	--self:FindIconMaskPosList(tf)
	
end


function GameIconPanel:FindItemIcon(tf)
	local itemIcon=0
	for i=1,self.ItemIcontCount do
		itemIcon=tf:Find("com/GunDong/ItemGroup/Item"..(i-1)).gameObject
		table.insert(self.gameData.ItemIconList,itemIcon)	
		GameObjectPool.GetInstance():InitGameObjectPoolData(itemIcon)	
	end

	itemIcon=tf:Find("com/GunDong/ItemGroup/Item127").gameObject
	table.insert(self.gameData.ItemIconList,itemIcon)	
	GameObjectPool.GetInstance():InitGameObjectPoolData(itemIcon)

	GameObjectPool.GetInstance():InitGameObjectPool(2)
end

function GameIconPanel:FindIconPosList(tf)
	for i=1,self.ItemIcontListCount_H do	
		local itemIconPos_H=tf:Find("com/GunDong/WuJian/WuJian_Down/WuJian_"..i).gameObject
		table.insert(self.gameData.GameIconParentList,itemIconPos_H)	
		self.gameData.GameIconPosList[i]={}			
		for j=1,self.ItemIcontListCount_V do
			local itemIconPos_V=tf:Find("com/GunDong/WuJian/WuJian_Down/WuJian_"..i.."/WuJian_"..j).gameObject
			table.insert(self.gameData.GameIconPosList[i],itemIconPos_V)
		end
	end
end


function GameIconPanel:FindIconMaskPosList(tf)
	for i=1,self.ItemIcontListCount_H do
		local itemIconPos_H=tf:Find("com/GunDong/WuJianMask/WuJian_Down/WuJian_"..i).gameObject
		table.insert(self.gameData.GameIconParentList2,itemIconPos_H)		
		self.gameData.GameIconPosList2[i]={}			
		for j=1,self.ItemIcontListCount_V-1 do
			local itemIconPos_V=tf:Find("com/GunDong/WuJianMask/WuJian_Down/WuJian_"..i.."/WuJian_"..j).gameObject
			table.insert(self.gameData.GameIconPosList2[i],itemIconPos_V)
		end
	end
end



function GameIconPanel:FindBg(tf)
	local Bg=nil
	for i=1,2 do
		Bg=tf:Find("com/Game_BG/Game_BG0"..i).gameObject
		table.insert(self.gameData.GameBgGroup,Bg)
	end
end



return GameIconPanel