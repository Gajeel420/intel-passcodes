GameIconManager=BaseClass()

function GameIconManager:__init()
	self:InitData()
	self:InitView()

end


function GameIconManager:InitData()
	self.gameData=GameUIManager.GetInstance().GameData  --游戏数据
	self.gameUIManager=GameUIManager.GetInstance()
	self.IconName="Item"								--游戏图标前缀
	self.IconSwapAnimName={"Ani_Jump04","Ani_Jump03","Ani_Jump02","Ani_Jump01"}
	
end



function GameIconManager:InitView()
	self:InitUIViewData()
	self:InitUIView()
	self:InitIconItemInstanceList()
end


function GameIconManager:InitUIViewData()
		
end



function GameIconManager:InitUIView()
	
end


function GameIconManager:InitIconItemInstanceList()
	for i=1,GameDefine.SHZ_CommonVar.ANI_COL do
		self.gameData.IconItemInstanceList[i]={}	
	end
end


function GameIconManager:InitRandomAllGameIcon()
	self:AddAllGameIcon()
end


function GameIconManager:InitAllGameIcon(num)
	self:AddAllGameIcon(num)
end



function GameIconManager:InstantiateGameObjectToPool(gameObj,number,keyName)
	GameObjectPool.GetInstance():AddGameObjectPool(gameObj,number,keyName)
end


function GameIconManager:GetRandomGameIcon()
	local num=CommonHelp.GetRandom()
	return self:GetIcom(num)
end


function GameIconManager:GetAllocateRandomGameIcon()
	local num=CommonHelp.GetRandomTwo(0,7)
	return self:GetIcom(num)
end


function GameIconManager:GetGameIcon(num)
	return self:GetIcom(num)
end


function GameIconManager:GetIcom(num,mask)
	local iconName=0
	if mask then
		iconName=self.IconName..num..mask
	else
		iconName=self.IconName..num
	end
	
	return GameObjectPool.GetInstance():GetGameObject(iconName)	
end


function GameIconManager:GetAllocateKeyIcom(keyName)
	return GameObjectPool.GetInstance():GetGameObject(keyName)	
end


function GameIconManager:AddAllGameIcon(num)
	local tempIconTable={}
	if num~=nil then
		for i=1,GameDefine.SHZ_CommonVar.ANI_ROW do
			table.insert(tempIconTable,num)
		end		
	end
	
	for i=1,#self.gameData.GameIconPosList do
		if num==nil then
			self:SetGameIconRowRondomInstanceList(i)	
		else		
			self:SetGameIconRowInstanceList(i,tempIconTable)
		end
	end
end


function GameIconManager:GetGameIconInstanceRowList(num)
	for i=1,#self.gameData.IconItemInstanceList do
		if i==num then
			return self.gameData.IconItemInstanceList[i]
		end
	end
end


function GameIconManager:GetAllocateGameIconInstance(rowNum,iconNum)
	local tempData=self:GetGameIconInstanceRowList(rowNum)
	for i=1,#tempData do
		if i==iconNum then
			return tempData[i]
		end
	end
end



function GameIconManager:GetAllocateGameIconInstanceCommonFunc(rowNum,iconNum,iconItemInsList)
	local tempData=self:GetRowGameIconInstance(rowNum,iconItemInsList)
	for i=1,#tempData do
		if i==iconNum then
			return tempData[i]
		end
	end
end


function GameIconManager:GetRowGameIconInstance(num,iconItemInsList)
	for i=1,#iconItemInsList do
		if i==num then
			return iconItemInsList[i]
		end
	end
	return false
end


function GameIconManager:GetGameIconIntanceObj(pos)
	local str=tostring(pos)
	local num1=string.sub(str,1,1)
	
	local num2=string.sub(str,2,2)
	
	num1=tonumber(num1)
	num2=tonumber(num2)
	return self:GetAllocateGameIconInstance(num1,num2)
end



function GameIconManager:GetGameIconInstanceByLineData(LineDatas)
	
	local IconObj={}
	for i=1,#LineDatas.Column do
		local Xpos=LineDatas.Column[i]
		local Ypos=LineDatas.Row[i]
		local tempData=self:GetAllocateGameIconInstance(Xpos,Ypos)
		table.insert(IconObj,tempData)	
	end
	return IconObj
	
end


function GameIconManager:GetGameIconRowlist(num)
	for i=1,#self.gameData.GameIconPosList do
		if i==num then
			return self.gameData.GameIconPosList[i]
		end
	end
end


--获取指定的图标
function GameIconManager:GetGameIconRowInstanceList(iconItemNumberList)
	local tempData={}
	for i=1,#iconItemNumberList do
		local iconObj=self:GetGameIcon(iconItemNumberList[i])
		table.insert(tempData,iconObj)
	end
	return tempData
end


function GameIconManager:GetGameIconRowInstanceListByRandom(num)
	if num==nil then
		num=GameDefine.SHZ_CommonVar.ANI_ROW+1	--默认四个
	end
	local tempData={}
	for i=1,num do
		local iconObj=self:GetRandomGameIcon()
		table.insert(tempData,iconObj)
	end
	return tempData
end



function GameIconManager:SetGameIconToTargetPosition(targetPosList,IconItemList)	
	for i=1,#targetPosList do
		CommonHelp.AddToParentGameObject(IconItemList[i],targetPosList[i])
	end	
end


function GameIconManager:SetGameIconRowInstancePostion(tempList)
	for i=1,#tempList do
		tempList[i].gameObject.transform.localPosition=Vector3.zero
	end
end


function GameIconManager:SetGameIconInstanceObjList(num,gameIconList)
	
	for i=1,#gameIconList do
		local iconItem=self.gameData.IconItem.New(gameIconList[i])	
		self.gameData.IconItemInstanceList[num][i]=iconItem
	end
end


function GameIconManager:SetGameIconRowInstanceList(num,iconItemNumberList)
	local tempIconList=self:GetGameIconRowInstanceList(iconItemNumberList)		
	self:SetGameIconRowList(num,tempIconList)
end



function GameIconManager:SetGameIconRowRondomInstanceList(num)
	local tempIconList=self:GetGameIconRowInstanceListByRandom()		
	self:SetGameIconRowList(num,tempIconList)
end



function GameIconManager:SetGameIconRowList(num,iconList)
	local tempData=self:GetGameIconRowlist(num)	
	self:SetGameIconToTargetPosition(tempData,iconList)		
	self:SetGameIconInstanceObjList(num,iconList)			
end


function GameIconManager:StopAllIconAnimation()
	for i=1,#self.gameData.IconItemInstanceList do
		for j=1,#self.gameData.IconItemInstanceList[i] do
			self.gameData.IconItemInstanceList[i][j]:StopIconItemAnimation()
		end
	end
end


function GameIconManager:PlayAssignAnim(IconInstanceList,WinLineData,IsDisplay)
	local posTab = {1,2,3}
	for i=1,#IconInstanceList do
		if self.gameData.IsOpenHelp==false then
			IconInstanceList[i]:StartIconItemAnimation()
			if IconInstanceList[i].ItemNum==5 then
				self:RemovePosTab(posTab,i)
			end
		end
	end
	self.gameData.LineManager:ShowAllocateLine(WinLineData.nPrizeLineID,true)
	if not IsDisplay then
		return
	end
	if #posTab==2 then
		if IconInstanceList[posTab[1]].ItemNum~=IconInstanceList[posTab[2]].ItemNum then
			self.gameUIManager:ShowBetWin(1)
		else
			self.gameUIManager:ShowBetWin(WinLineData.nGameItemID+2)
		end
	elseif #posTab==3 then
		if IconInstanceList[1].ItemNum~=IconInstanceList[2].ItemNum or IconInstanceList[1].ItemNum~=IconInstanceList[3].ItemNum then
			self.gameUIManager:ShowBetWin(1)
		else
			self.gameUIManager:ShowBetWin(WinLineData.nGameItemID+2)
		end
	else
		self.gameUIManager:ShowBetWin(WinLineData.nGameItemID+2)
	end
end

function GameIconManager:RemovePosTab(tab,index)
	for i = 1, #tab, 1 do
		if tab[i]==index then
			table.remove(tab,i)
			break
		end
	end
end

function GameIconManager:StopPlayAssignAnim(IconInstanceList)
	for i=1,#IconInstanceList do
		IconInstanceList[i]:StopIconItemAnimation()
	end
end


function GameIconManager:StopAnim(IconInstanceList)
	
end


function GameIconManager:IsShowAllItemAnim(isdisplay)
	for i=1,#self.gameData.IconItemInstanceList do
		for j=1,#self.gameData.IconItemInstanceList[i] do
			self.gameData.IconItemInstanceList[i][j]:IsShowItemAimaPanel(isdisplay)
		end
	end
end

function GameIconManager:IsShowAllocateItemAnim(index,isdisplay,itemInsList)
	local tempIns=itemInsList[index]
	if tempIns then
		for i=1,#tempIns do
			tempIns[i]:IsShowItemAimaPanel(isdisplay)
		end
	end
end


function GameIconManager:IsShowAllocateIconPanel(index,itemInsList,isdisplay)
	if itemInsList then
		for i=1,#itemInsList[index] do
			itemInsList[index][i]:IsShowIconPanel(isdisplay)
		end
	end
end


function GameIconManager:IsShowAllocateIconParentPanel(index,iconParent,isdisplay)
	local tempIconP=iconParent[index]
	if tempIconP then
		for i=1,#tempIconP do
			CommonHelp.SetActive(tempIconP[i],isdisplay)
		end
	end
end





--替换图标
function GameIconManager:ChangeItem(iconResult,itemId)
	local iconParent=iconResult.IconIns.gameObject.transform.parent
	GameObjectPool.GetInstance():ReCycleToGameObject(iconParent:GetChild(0).gameObject)
	local tempIcon=self:GetGameIcon(itemId)		
	CommonHelp.AddToParentGameObject(tempIcon,iconParent)
	local IconIns=self.gameData.IconItem.New(tempIcon)
	self.gameData.IconItemInstanceList[iconResult.Result[1]][iconResult.Result[2]]=IconIns
end



--设置游戏界面的图片显示状态
function GameIconManager:SetGameViewShowData(index,isdisplay)
	self:SetIconParentPos(GameDefine.GameIconPos[index])
	self:SetIconMaskParentPos(GameDefine.GameIconPos[index])
	self:SetShowBG(index,isdisplay)
	self:SetAllIconPanelMask(index)
end



--设置图标父物体位置
function GameIconManager:SetIconParentPos(posList)
	for i=1,#self.gameData.GameIconParentList do
		self.gameData.GameIconParentList[i].transform.localPosition=posList[i]
		self.gameData.RowItemList[i]:SetTweenPos(posList[i])
	end
end


function GameIconManager:SetIconMaskParentPos(posList)
	for i=1,#self.gameData.GameIconParentList2 do
		self.gameData.GameIconParentList2[i].transform.localPosition=posList[i]
	end
end


function GameIconManager:SetShowBG(index,isdisplay)
	for i=1,#self.gameData.GameBgGroup do
		if i==index then
			CommonHelp.SetActive(self.gameData.GameBgGroup[i],isdisplay)
		else
			CommonHelp.SetActive(self.gameData.GameBgGroup[i],not isdisplay)
		end
	end
end


function GameIconManager:SetIconMask(index,isdisplay)
	for i=1,#self.gameData.TextureMaskGroup do
		if i==index then
			CommonHelp.SetActive(self.gameData.TextureMaskGroup[i].gameObject,isdisplay)
		else
			CommonHelp.SetActive(self.gameData.TextureMaskGroup[i].gameObject,not isdisplay)
		end
	end
end


function GameIconManager:SetAllIconPanelMask(index)
	local textTure=self.gameData.TextureMaskGroup[index].mainTexture
	self.gameData.GameIconPanel.TextTrueMask.clipTexture=textTure
	self.gameData.GameIconPanel.TextTureMask2.clipTexture=textTure
end



function GameIconManager:IsShowMainIconPanel(isdisplay,sortOrder)
	if isdisplay then
		self.gameData.GameIconPanel.TextTrueMask.sortingOrder=sortOrder
	end
	CommonHelp.SetActive(self.gameData.GameIconPanel.TextTrueMask.gameObject,isdisplay)
end



function GameIconManager:RestDrawCall()
	NGUITools.MarkParentAsChanged(self.gameData.GameIconPanel.TextTrueMask.gameObject)	
	
end





--生成单列图标和实例并放到指定位置
function GameIconManager:BuildSingleColumnIcon(itemList,ParentPosList)
	--pt("itemList:",itemList)
	--pt("ParentPosList:",ParentPosList)
	local ItemList=self:BuildItem(itemList)
	self:SetGameIconToTargetPosition(ParentPosList,ItemList)
	local ItemInsList=self:BuildItemIns(ItemList)
	return ItemInsList
end


function GameIconManager:BuildItem(itemList)
	local tempData={}
	for i=1,#itemList do
		local tempItem=self:GetIcom(itemList[i],self.gameData.GameIconPanel.MaskName)
		table.insert(tempData,tempItem)
	end
	return tempData
end


function GameIconManager:BuildItemIns(itemList)
	local tempData={}
	for i=1,#itemList do
		local tempItemIns=self.gameData.IconItem.New(itemList[i])
		table.insert(tempData,tempItemIns)
	end
	return tempData
end


function GameIconManager:InitIconMask()
	self:BuildIconMask()
	self:HideAllIconMaskParent()
	--self:IsShowAllMaskItemAnim(false)
end

--生成遮挡的图标和实例
function GameIconManager:BuildIconMask()
	for i=1,5 do
		self.gameData.IconItemInstanceList2[i]={}
		local ItemList=self:BuildRandomItemID(3,0,8)
		local ParentPosList=self.gameData.GameIconPosList2[i]
		self.gameData.IconItemInstanceList2[i]=self:BuildSingleColumnIcon(ItemList,ParentPosList)
	end
end


function GameIconManager:BuildRandomItemID(count,startPos,endPos)
	local tempData={}
	for i=1,count do
		local data=CommonHelp.GetRandomTwo(startPos,endPos)
		table.insert(tempData,data)
	end
	return tempData
end



function GameIconManager:IsHideAllocateIconMaskParent(index,isdisplay)
	CommonHelp.SetActive(self.gameData.GameIconParentList2[index],isdisplay)
end


function GameIconManager:HideAllIconMaskParent(index)
	for i=1,#self.gameData.GameIconParentList2 do
		if i~=index then
			CommonHelp.SetActive(self.gameData.GameIconParentList2[i],false)
		end
	end
end



function GameIconManager:IsShowAllMaskItemAnim(isdisplay)
	for i=1,#self.gameData.IconItemInstanceList2 do
		for j=1,#self.gameData.IconItemInstanceList2[i] do
			self.gameData.IconItemInstanceList2[i][j]:IsShowItemAimaPanel(isdisplay)
		end
	end
end




function GameIconManager:HideAllIconMask()
	for i=1,#self.gameData.IconItemInstanceList2 do
		for j=1,#self.gameData.IconItemInstanceList2[i] do
			self.gameData.IconItemInstanceList2[i][j]:IsShowIconPanel(false)
		end
	end
end



function GameIconManager:ReCycleItemInstance(iconItemInsList)
	if iconItemInsList then
		for i=1,#iconItemInsList do
			iconItemInsList[i]:ReCycleItem()
		end
	end
end


function GameIconManager:SetMaskIconChangeProcess(ColumnList,ResultList)
	local isShow=false
	for i=1,#self.gameData.IconItemInstanceList2 do
		if ColumnList[i] then
			isShow=true
			self:ReCycleItemInstance(self.gameData.IconItemInstanceList2[i])
			self.gameData.IconItemInstanceList2[i]=self:BuildSingleColumnIcon(ResultList[i],self.gameData.GameIconPosList2[i])
			self:SetWildIconLocalPosition(ResultList[i],self.gameData.IconItemInstanceList2[i])
		else
			isShow=false
		end
		CommonHelp.SetActive(self.gameData.GameIconParentList2[i],isShow)
	end
end

function GameIconManager:SetWildIconLocalPosition(Result,IconItemList)
	local IconInfoList=self:CaculateWildIconPos(Result,9)
	if IconInfoList then
		for i=1,#IconInfoList do
			local wildPos=IconInfoList[i].Num
			IconItemList[wildPos]:SetIconPanelPosition(IconInfoList[i].Pos)
			local hideIcon=IconInfoList[i].Hide
			if hideIcon then
				local hideCount=#hideIcon
				if hideCount>=2 then
					IconItemList[wildPos]:SetWildEffectPanel()
				end
				for j=1,hideCount do
					CommonHelp.SetActive(IconItemList[hideIcon[j]].gameObject.transform.parent.gameObject,false)
				end
			end
		end
	end
end


function GameIconManager:CaculateWildIconPos(Result,iconNum)
	local tempResult={}
	for i=1,#Result do
		if Result[i]==iconNum then
			table.insert(tempResult,i)
		end 
	end
	local IconInfoList={}
	if #tempResult==1 then
		local IconInfo={}
		IconInfo.Num=tempResult[1]
		if tempResult[1]==1 then
			IconInfo.Pos=Vector3(0,160,0)
		elseif tempResult[1]==3 then
			IconInfo.Pos=Vector3(0,-160,0)
		else
			print("Error：wild不能单独存在于2位置")
			return nil
		end
		table.insert(IconInfoList,IconInfo)
		return  IconInfoList
	elseif #tempResult==2 then
		local value=tempResult[2]-tempResult[1]
		if value==1 then
			local IconInfo={}
			IconInfo.Num=tempResult[2]
			
			if tempResult[2]==2 then
				IconInfo.Pos=Vector3(0,160,0)
				IconInfo.Hide={1}
			else
				IconInfo.Pos=Vector3(0,0,0)
				IconInfo.Hide={2}
			end
			table.insert(IconInfoList,IconInfo)
		else
			for i=1,2 do
				local IconInfo={}
				IconInfo.Num=tempResult[i]
				local Pos=nil
				if i==1 then
					Pos=Vector3(0,160,0)
				else
					Pos=Vector3(0,-160,0)
				end
				IconInfo.Pos=Pos
				table.insert(IconInfoList,IconInfo)
			end
			
		end
		return  IconInfoList
	elseif #tempResult==3 then
		print("进入第三列设置")
		local IconInfo={}
		IconInfo.Num=tempResult[3]
		IconInfo.Pos=Vector3(0,160,0)
		IconInfo.Hide={1,2}
		table.insert(IconInfoList,IconInfo)
		return  IconInfoList
	end
	return nil
end


function GameIconManager:SetMaskIconPos(iconPos)
	for i=1,#self.gameData.GameIconParentList2 do
		self.gameData.GameIconParentList2[i].transform.localPosition=iconPos[i]
	end
end

function GameIconManager:SetItemIconPos(iconPos)
	for i=1,#self.gameData.GameIconParentList do
		self.gameData.GameIconParentList[i].transform.localPosition=iconPos[i]
	end
end



--交换动画
function GameIconManager:IsShowIconSwap(isdisplay)
	CommonHelp.SetActive(self.gameData.GameIconPanel.IconSwapAnim.gameObject,isdisplay)
end

function GameIconManager:PlayIconSwapAnim(index)
	self:IsShowIconSwap(false)
	self:IsShowIconSwap(true)
	self.gameData.GameIconPanel.IconSwapAnim:Play(self.IconSwapAnimName[index])
end




function GameIconManager:IsShowIconMask(isdisplay)
	CommonHelp.SetActive(self.gameData.GameIconPanel.MaskBG,isdisplay)
end


function GameIconManager:PlayShakeAnim()
	self.gameData.GameIconPanel.KAnim:Play("RunPanel_doudong")
end


return GameIconManager