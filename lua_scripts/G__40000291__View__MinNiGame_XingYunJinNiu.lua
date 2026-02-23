MinNiGame_XingYunJinNiu=BaseClass()

function MinNiGame_XingYunJinNiu:__init(t)
	-- self.transform=t
	-- self.gameObject=t.gameObject
	-- self.ItemObjInsList={}
	-- self.mulValue = 0
	-- self.start = false
	-- self.timeIntervale = 10
	-- self.callBack = nil
	-- self.mulTableList = {100,150,200,250,300,350,100,150,200,250,300,350,100,150,200,250,300}
	-- self.spTableList = {"jinbi_01","jinbi_02","jinbi_03","jinbi_04","jinbi_05","jinbi_06","jinbi_01","jinbi_02","jinbi_03","jinbi_04","jinbi_05","jinbi_06","jinbi_01","jinbi_02","jinbi_03","jinbi_04","jinbi_05"}
	-- self:FindView()
end


-- function MinNiGame_XingYunJinNiu:FindView()
-- 	self.Effect_xingyunjinniu_defen = self.transform:Find("Effect_xingyunjinniu_defen").gameObject
-- 	self.Effect_xingyunjinniu_defen:SetActive(false)
	
-- 	self.xingyunjinniuObj = self.transform:Find("xingyunjinniu").gameObject
-- 	self.xingyunjinniuObj:SetActive(true)

-- 	self.KuangEffect = self.transform:Find("xingyunjinniu/Effect").gameObject
-- 	self.KuangEffect:SetActive(false)

-- 	self.Effect_zhongjiang = self.transform:Find("xingyunjinniu/Effect_zhongjiang").gameObject
-- 	self.Effect_zhongjiang:SetActive(false)
-- 	self.Effect_Sprite = self.transform:Find("xingyunjinniu/Effect_zhongjiang/Sprite"):GetComponent(typeof(UISprite))
-- 	self.Effect_Label = self.transform:Find("xingyunjinniu/Effect_zhongjiang/Sprite/Label"):GetComponent(typeof(UILabel))


-- 	self.ChouJiangBtn=self.transform:Find("xingyunjinniu/Button").gameObject
-- 	UIEventListener.Get(self.ChouJiangBtn).onClick=function() self:OnClickChouJiangBtn() end
-- 	self.btmLabel = self.transform:Find("xingyunjinniu/Button/Label_Time"):GetComponent(typeof(UILabel))

-- 	self.GunDongAnimator = self.transform:Find("xingyunjinniu/GunDong"):GetComponent(typeof(Animator))

-- 	for i = 1,17 do
-- 		local itemObj=self.transform:Find("xingyunjinniu/GunDong/ItemGroup_1/Item"..i)
-- 		local sp = itemObj:Find("Item/Sprite"):GetComponent(typeof(UISprite))
-- 		sp.spriteName = self.spTableList[i]
-- 		local label = itemObj:Find("Item/Label"):GetComponent(typeof(UILabel))
-- 		label.text = self.mulTableList[i]
-- 		table.insert(self.ItemObjInsList,itemObj)	
-- 	end
-- end

-- function MinNiGame_XingYunJinNiu:BeginXingYunJinNiu(mul,cb)
-- 	self.callBack  = cb
-- 	self.gameObject:SetActive(true)
-- 	self.start = true
-- 	self.mulValue = mul
-- 	self.timeIntervale  = 10
-- 	self.xingyunjinniuObj:SetActive(true)
-- 	self.GunDongAnimator:Play("Xingyunjinniu_Idel",0,0)
-- 	self:SetChouJiangResult()
-- 	self.ChouJiangBtn:SetActive(true)
-- end

-- function MinNiGame_XingYunJinNiu:OnClickChouJiangBtn()
-- 	self.start = false
-- 	self.ChouJiangBtn:SetActive(false)
-- 	self.GunDongAnimator:Play("Xingyunjinniu",0,0)
-- 	local DelayXingYunJinNiuFunc=function ()
-- 		yield_return(WaitForSeconds(2))
-- 		self.KuangEffect:SetActive(true)
-- 		yield_return(WaitForSeconds(0.3))
-- 		self.KuangEffect:SetActive(false)
-- 		self.Effect_zhongjiang:SetActive(true)
-- 		yield_return(WaitForSeconds(1.2))
-- 		self.Effect_zhongjiang:SetActive(false)
-- 		self.xingyunjinniuObj:SetActive(false)
-- 		self.Effect_xingyunjinniu_defen:SetActive(true)
-- 		yield_return(WaitForSeconds(1))
-- 		self.Effect_xingyunjinniu_defen:SetActive(false)
-- 		self.gameObject:SetActive(false)
-- 		if self.callBack ~= nil then
-- 			self.callBack()
-- 		end
-- 	end
-- 	StartCoroutine(DelayXingYunJinNiuFunc)
-- end

-- function MinNiGame_XingYunJinNiu:SetChouJiangResult()
-- 	local index  =  1
-- 	for i =1,6 do
-- 		if self.mulTableList[i] == self.mulValue then
-- 			index = i
-- 			break
-- 		end
-- 	end
-- 	local itemObj =  self.ItemObjInsList[14]
-- 	local sp = itemObj:Find("Item/Sprite"):GetComponent(typeof(UISprite))
-- 	sp.spriteName = self.spTableList[index]
-- 	local label = itemObj:Find("Item/Label"):GetComponent(typeof(UILabel))
-- 	label.text = self.mulTableList[index]

-- 	self.Effect_Sprite.spriteName =self.spTableList[index]
-- 	self.Effect_Label.text = self.mulTableList[index]
-- end


-- function MinNiGame_XingYunJinNiu:Update()
-- 	if self.start == true then
-- 		self.timeIntervale  = self.timeIntervale - Time.deltaTime
-- 		self.btmLabel.text = math.floor( self.timeIntervale )
-- 		if self.timeIntervale <= 0 then
-- 			self:OnClickChouJiangBtn()
-- 		end
-- 	end
-- end

-- function MinNiGame_XingYunJinNiu:__delete( ... )
-- 	self.transform=nil
-- 	self.gameObject=nil
-- end