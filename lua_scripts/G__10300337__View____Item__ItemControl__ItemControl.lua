ItemControl=BaseClass()

ItemControlCount=0	

function ItemControl:__init(gameObj)
	self.gameObject=gameObj
	self:InitData()
	self:InitView()
	CommonHelp.AddUpdate(self)
end


function ItemControl:InitData()
	self.gameData=GameUIManager.GetInstance().GameData
	ItemControlCount=ItemControlCount+1
	self.updateName="ItemControl.Update"..ItemControlCount
end



function ItemControl:InitView()

	self:InitUIViewData()
	self:FindView()
	self:InitUIView()
end


function ItemControl:InitUIViewData()
	self.IsBonusRun=false			--是否是Bonus图标滚动，默认是普通滚动
	self.IconItemList={}			--游戏图标对象		--用于在转动的时候设置旋转图标
	self.Result={}					--服务器传的结果值
	self.StartLocalPos={}			--保存每一列每个图标的父物体初始位置
	self.Items={}					--可以旋转的图标父位置列表 按每列来排序
	self.Run = false     			--是否正在转动
	self.Stop=false					--是否停止转动
	self.Distance = 0    			--两个Item之间的距离
	self.MoveDirection=nil			--移动方向
	self.Tween=nil					--动画
	self.Speed=5					--转动速度
	self.IsUseDimIcon=false			--是否使用模糊图标
	self.IsLast=true
	self.IsHasRun=true				--是否可以滚动 默认
	self.IsReciveCallBack=false		--是否接收回调
	self.m_colIndex = 0             --当前列索引
	self.m_colIndexTab = {0,1,2,3,4,5,6,7,8,9,11}  --模糊图标索引
	self.totalTime = 4
	self.m_IsReduce=false
end

--给列赋值
function ItemControl:SetColIndex(col)
	self.m_colIndex=col
end

function ItemControl:FindView()
	local tf=self.gameObject.transform
	for i=1,GameDefine.SHZ_CommonVar.ANI_ROW+1 do
		local itemObj=tf:Find("WuJian_"..i).gameObject
		table.insert(self.StartLocalPos,itemObj.transform.localPosition)	
		table.insert(self.Items,itemObj)
	end
	self.Tween=tf:GetComponents(typeof(TweenPosition))
	-- self.Tween[0]:SetOnFinished(function ()
	-- 	if self.m_colIndex==3 then
	-- 		CommonHelp.StopAudio(GameAudioPath.StartRoll[self.gameData.GameControlManager.StartRollIndex])
	-- 	end
	-- end)
end


function ItemControl:InitUIView()
	self:SetDistance()
	self:SetMoveDirection()
	self:InitSetFristItem()
end


function ItemControl:IsShowColmunPanel(isdisplay)
	CommonHelp.SetActive(self.gameObject,isdisplay)
end


function ItemControl:InitSetFristItem()
	CommonHelp.SetActive(self.Items[1],false)		--目的是让第一个图标不显示
end

function ItemControl:SetIconParentStartPos(startPos)
	self.StartLocalPos=startPos
end


function ItemControl:SetMoveDirection()
	self.Distance=self.StartLocalPos[1].y-self.StartLocalPos[2].y
end

function ItemControl:SetDistance()
	self.MoveDirection=(self.StartLocalPos[2]-self.StartLocalPos[1]).normalized 
end


function ItemControl:SetItemList(iconPosList)
	self.Items=iconPosList
end

function ItemControl:SetIconItemList(iconItemList)
	self.IconItemList=iconItemList
end


function ItemControl:GetIconItemList()
	return self.IconItemList
end


function ItemControl:GetTweenTime()
	return self.Tween.duration
end

function ItemControl:SetTweenPos(pos)
	for i=0,1 do
		self.Tween[i].from=pos
		self.Tween[i].to=Vector3(pos.x,pos.y-10,pos.z)
	end
	
end


function ItemControl:SetStartTweenAnim()
	local pos=self.Tween[1].from
	self.Tween[1].to=Vector3(pos.x,pos.y+40,pos.z)
	self.Tween[1].duration=0.5
	self:PlayTween(self.Tween[1])
end


function ItemControl:SetEndTweenAnim()
	local pos=self.Tween[0].from
	self.Tween[0].to=Vector3(pos.x,pos.y-5,pos.z)
	self.Tween[0].duration=0.3
	if self.m_colIndex==3 then
		CommonHelp.StopAudio(GameAudioPath.StartRoll[self.gameData.GameControlManager.StartRollIndex])
	end
	for i = 1, #self.IconItemList, 1 do
		self.IconItemList[i]:SetItemSpriteAndRandomSpriteObj1(true)
	end
end



function ItemControl:GetIsHasRun()
	return self.IsHasRun
end

function ItemControl:SetHasRun(isRun)
	self.IsHasRun=isRun
end



function ItemControl:HideIcon(index,isdisplay)
	for i=1,#self.IconItemList do
		if index==i then
			self.IconItemList[i]:IsShowIconPanel(isdisplay)
		else
			self.IconItemList[i]:IsShowIconPanel(not isdisplay)
		end
	end
end



function ItemControl:Rotation()
	if self.Run and self.IsHasRun then		
		if self.Items==nil or #self.Items<1 then
			return
		end
		
		for i=1,#self.Items  do
			self.Items[i].transform:Translate(Time.deltaTime*self.Speed*self.MoveDirection,CS.UnityEngine.Space.World)	
		end
		
		if self.Items[1].transform.localPosition.y<=0 then
			if self.Stop then		
				if self.IsLast then
					self.IsLast=false
					self:RunNew()
					self:AssignmentResult()
					self:ResetPosition()
					-- self.Speed=3									--设置最后一圈的速度=
					self.m_IsReduce=true
					self.m_CurrentTime = 0
				elseif self.m_IsReduce then
					self:RunNew()
					if self.m_CurrentTime~=0 then
						self.IconItemList[1]:SetItemSpriteAndRandomSpriteObj1(true)
					end
					self.m_CurrentTime = self.m_CurrentTime + 1
					if self.m_CurrentTime >= self.totalTime then
						self.m_CurrentTime = self.totalTime
						self.m_IsReduce = false
						CommonHelp.PlayAudio(GameAudioPath.SymbolFallDown)
					end
				else
					self.Stop = false
					self.Run = false
					self.IsLast=true
					self:ResetRunEndPosition()
					self:SetEndTweenAnim()
					self:PlayTween(self.Tween[0])
					--self:PlayTween()
					--self:EndRunCallBack()
				end
				
			else					
				self:ResetActiveIconIns()
				self:RunNew()
				self:SetIconItemSprite()

			end
		end
	end
end

function ItemControl:QuickStop()
	if self.Run and not self.Stop then
		self.Run = false
		self:RunNew()
		self:AssignmentResult()
		self:ResetPosition()
		self:ResetRunEndPosition()
		self:SetEndTweenAnim()
		self:PlayTween(self.Tween[0])
		if self.m_colIndex==3 then
			CommonHelp.PlayAudio(GameAudioPath.SymbolFallDown)
		end
	end
end

function ItemControl:GetRandom()
	local tempResult={}
	if self.gameData.IsReciveServerData then
		for i = 1, 2 do
			table.insert(tempResult,self.gameData.GameResult[self.m_colIndex][i])
		end
	end
	
	for i=1,2 do
		table.insert(tempResult,CommonHelp.GetRandomTwo(0,5))
	end
	
	return tempResult[CommonHelp.GetRandomTwo(1,#tempResult)]
end


function ItemControl:EndRunCallBack()
	if self.IsReciveCallBack then
		self:IsEnableTween(false)
		self.gameData.GameControlManager:SingleRunEndCallBack(self.m_colIndex)
	end
end


function ItemControl:RunNew(num)
	self:SwapItem()
	self:SwapIconItem()
end


function ItemControl:PlayTween(Tween)
	Tween.enabled = true
	Tween:ResetToBeginning()
	Tween:PlayForward()
end


function ItemControl:IsEnableTween(isEnabled)
	self.Tween.enabled=isEnabled
end


function ItemControl:ResetPosition()
	for i=1,GameDefine.SHZ_CommonVar.ANI_ROW+1 do
		self.Items[i].transform.localPosition=self.StartLocalPos[i]
	end
end

function ItemControl:ResetRunEndPosition()
	for i=1,GameDefine.SHZ_CommonVar.ANI_ROW+1 do
		if self:IsNeedTran() then
			if i==1 then
				self.Items[i].transform.localPosition=Vector3(0,(self.StartLocalPos[i].y-self.Distance-155),0)
			elseif i==3 then
				self.Items[i].transform.localPosition=Vector3(0,(self.StartLocalPos[i].y-self.Distance+155),0)
			else
				self.Items[i].transform.localPosition=Vector3(0,(self.StartLocalPos[i].y-self.Distance),0)
			end
		else
			self.Items[i].transform.localPosition=Vector3(0,(self.StartLocalPos[i].y-self.Distance),0)
		end
	end	
end


function ItemControl:SwapIndex(list)

	local  tmpItem=list[GameDefine.SHZ_CommonVar.ANI_ROW+1]
	for i=GameDefine.SHZ_CommonVar.ANI_ROW+1,2,-1 do
		list[i]=list[i-1]
	end
	list[1]=tmpItem
end


function ItemControl:SwapItem()
	self:SwapIndex(self.Items)
	if self.Items[1].transform.childCount==0 then
		local tempIcon=self.gameData.GameIconManager:GetRandomGameIcon()
		CommonHelp.AddToParentGameObject(tempIcon,self.Items[1])
		self.IconItemList[1]=self.gameData.IconItem.New(tempIcon)
		self.IconItemList[1]:InitUIView()
	end
	self.Items[1].transform.localPosition=Vector3(0,self.Distance,0)
end


function ItemControl:SwapIconItem()
	self:SwapIndex(self.IconItemList)		
	self.gameData.GameIconManager:SetGameIconRowInstancePostion(self.IconItemList)		
end



function ItemControl:SetIconItemSprite()
	local tempIcon=self.IconItemList[1]
	if self.IsUseDimIcon then
		local randomNum=self:GetRandom()--CommonHelp.GetRandomTwo(GameDefine.SHZ_CommonVar.ItemMin,GameDefine.SHZ_CommonVar.ItemMax)
		tempIcon:SetitemSpriteObjRandomName(randomNum,true)
	else
		tempIcon:SetitemSpriteObjRandomName(self:GetRandom())--CommonHelp.GetRandomTwo(GameDefine.SHZ_CommonVar.ItemMin,GameDefine.SHZ_CommonVar.ItemMax))
	end
	
	tempIcon:SetItemSpriteAndRandomSpriteObj(false)		
end


function ItemControl:AssignmentResult()
	local tempIcon=nil
	if #self.Result>0 then
		for i=1,GameDefine.SHZ_CommonVar.ANI_ROW+1 do
			if self.Items[i].transform.childCount>0 then
				GameObjectPool.GetInstance():ReCycleToGameObject(self.Items[i].transform:GetChild(0).gameObject)	
			end
			if i==(#self.Items) then
				tempIcon=self.gameData.GameIconManager:GetRandomGameIcon()
			else
				tempIcon=self.gameData.GameIconManager:GetGameIcon(self.Result[i])
			end
			CommonHelp.AddToParentGameObject(tempIcon,self.Items[i])
			self.IconItemList[i]=self.gameData.IconItem.New(tempIcon)
			self.IconItemList[i]:InitUIView()
			self.IconItemList[i]:SetItemScale(self:IsNeedTran())
			if not self.gameData.IsAllStop and not self.gameData.isQuick then
				self.IconItemList[i]:SetItemSpriteAndRandomSpriteObj1(false)
			end
			if self.Result[i]==5 then
				self.IconItemList[i]:SetSprite02Show(false)
			end
			if i<GameDefine.SHZ_CommonVar.ANI_ROW+1 then
				self.IconItemList[i]:SetIconNum(self.Result[i])
			else
				self.IconItemList[i]:SetIconNum(0)
			end
		end
	end
end

function ItemControl:IsNeedTran()
	if self.Result[2]==127 then
		return true
	end
	return false
end

function ItemControl:ResetActiveIconIns()
	for i=1,#self.Items do
		CommonHelp.SetActive(self.Items[i],true)
	end
end

function ItemControl:Update()
	self:Rotation()
end

function ItemControl:GetWinLine(index)
	self.IconItemList[index]:SetSprite02Show(false)
	for i = 1, #self.gameData.WinLinDataList, 1 do
		for j = 1, #self.gameData.WinLinDataList[i].Row, 1 do
			if self.gameData.WinLinDataList[i].Row[j]==index then
				self.IconItemList[index]:SetSprite02Show(true)
				break
			end
		end
	end
end


return ItemControl