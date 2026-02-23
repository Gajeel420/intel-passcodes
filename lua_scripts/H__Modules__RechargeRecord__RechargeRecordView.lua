RechargeRecordView = BaseClass(LuaUI)
require"H/Modules/RechargeRecord/RechargeRecordModel"
require"H/Modules/RechargeRecord/RechargeRecordItem"


function RechargeRecordView:__init(parent,initCallBack)
    self.parent=parent
    self.initCallBack=initCallBack
	self.assetName = "RechargeRecordView"--资源名称
	self.resPath = "Phone/Prefabs/View/RechargeRecordView.unity3d"--资源路径
	self.createCallBack = self.InitUI	
    self.mBool_IsShowNetWorkMessage=false
	self:CreateUI(0)
end

function RechargeRecordView:InitUI()
    local mTran = self.obj.transform
    self.UpdateName = "RechargeRecordView:OnUpdate"
    mTran.parent =  self.parent
    mTran.localScale = Vector3.one
    mTran.localPosition = Vector3.zero
    self.model = RechargeRecordModel.New()
    self.ItemCount = 11
    self.CurrentDataIndex = 1
    self.MoveSpeed = 0.05

    self.ItemParentTransList = {}   --父物体transform列表
    self.ItemParentLocalPositionList = {}   --存父物体初始化位置
    self.ItemViewList = {}

    self.MoveDirection = nil  ---移动方向

    self.IsRun = false

    self.itemObj = mTran:Find("Content/Item").gameObject
    self.itemObj:SetActive(false)

    self.mPanel_ScrollView = mTran:Find("Content/ScrollView").gameObject:GetComponent(typeof(UIPanel))

   

    for i = 1, self.ItemCount do
        local path = StringFormat("Content/ScrollView/Grid/Item{0}",i)
        local mParent = mTran:Find(path)
        local itemView = self:CreateRecordItem(mParent)

        table.insert(self.ItemParentTransList,mParent )
        table.insert(self.ItemParentLocalPositionList,mParent.localPosition)
        table.insert(self.ItemViewList,itemView )
    end
    self:SetMoveDirection()
    if self.initCallBack then 
        self.initCallBack()
    end
end


----计算位移方向
function RechargeRecordView:SetMoveDirection(  )
	-- body
	self.MoveDirection = (self.ItemParentLocalPositionList[1]-self.ItemParentLocalPositionList[2]).normalized 
end


function RechargeRecordView:OnUpdate()
    if self.IsRun then
        for i = 1, self.ItemCount do
            self.ItemParentTransList[i]:Translate(Time.deltaTime*self.MoveSpeed*self.MoveDirection,CS.UnityEngine.Space.World)
        end

        if self.ItemParentTransList[self.ItemCount].localPosition.y >= self.ItemParentLocalPositionList[self.ItemCount-1].y then
                self:SwapItem()
        end
    end
end


function RechargeRecordView:RefreshData(datas)
    self.datas = datas
    if datas == nil then
        return 
    end
    local count = #self.datas
    local datacount = count < self.ItemCount and count or self.ItemCount
    for i = 1, datacount do
        local data = self:GetRechargeData()
        self.ItemViewList[i]:SetData(data,i)
        self.ItemViewList[i]:SetDisplay(true)
    end
   
    self.IsRun =  count >= self.ItemCount
   
end


function RechargeRecordView:GetRechargeData()
    local count = #self.datas
    self.CurrentDataIndex = self.CurrentDataIndex + 1
    self.CurrentDataIndex = self.CurrentDataIndex <= count and self.CurrentDataIndex or 1
    return self.datas[self.CurrentDataIndex]
end

function RechargeRecordView:CloseAllItem()
    
    for i = 1,self.ItemCount do
        self.ItemViewList[i]:SetDisplay(false)
    end
    self.CurrentDataIndex = 0
end

---交换item数据
function RechargeRecordView:SwapItem()
    local tempParent = self.ItemParentTransList[1]
    local tempItem = self.ItemViewList[1]
    for i = 1, (self.ItemCount-1) do
        self.ItemParentTransList[i] = self.ItemParentTransList[i+1]
        self.ItemViewList[i] = self.ItemViewList[i+1]
    end
    self.ItemParentTransList[self.ItemCount] = tempParent
    self.ItemViewList[self.ItemCount] = tempItem
    self.ItemViewList[self.ItemCount]:SetData(self:GetRechargeData(),self.CurrentDataIndex)
    ---归位最后一个父物体
    self.ItemParentTransList[self.ItemCount].localPosition = self.ItemParentLocalPositionList[self.ItemCount]
end




function RechargeRecordView:CreateRecordItem(mParent)
    local item =GameObject.Instantiate(self.itemObj,mParent)
    item.transform.localPosition = Vector3.zero
    item.transform.localScale = Vector3.one
    item:SetActive(false)
    return RechargeRecordItem.New(item)
end





function RechargeRecordView:ShowView()
    RenderMgr.Add(function() self:OnUpdate() end,self.UpdateName)
    self:CloseAllItem()
    self.model:GetSlidMoney(function(data)
        self:RefreshData(data)
    end) 
    self.obj:SetActive(true)
    
    
end

function RechargeRecordView:HideView()
    self.IsRun = false
    self.CurrentDataIndex = 0
    RenderMgr.Remove(self.UpdateName)
    self.obj:SetActive(false)
end


function RechargeRecordView:SetDepth(depth)
    self.mPanel_ScrollView.depth = depth+1
end


function RechargeRecordView:__delete()

end