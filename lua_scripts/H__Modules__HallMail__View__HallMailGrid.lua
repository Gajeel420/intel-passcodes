HallMailGrid = HallMailGrid or BaseClass()

function HallMailGrid:__init(go)
	self.obj = go
	self:InitUI()
end

--初始化ui界面  ----必须实现
function HallMailGrid:InitUI()
	local mTran = self.obj.transform
	UIEventListener.Get(self.obj).onClick=function() self:OnClickItem() end
	self.mObj_Up=mTran:Find("Up").gameObject
	self.mObj_Up:SetActive(false)
	self.mLabel_Up=mTran:Find("Up/Label"):GetComponent(typeof(UILabel))
	self.mObj_Normal=mTran:Find("Normal").gameObject
	self.mLabel_Normal=mTran:Find("Normal/Label"):GetComponent(typeof(UILabel))

end

function HallMailGrid:OnClickItem()
	--被点击了，表示邮件已经被读取
	if self.vo.onClick then self.vo.onClick(self) end
end


function HallMailGrid:SetUpButton(isUp)
	
	if isUp then
		self.mObj_Up:SetActive(true)
		self.mObj_Normal:SetActive(false)
	else
		self.mObj_Up:SetActive(false)
		self.mObj_Normal:SetActive(true)
	end
end



-- 设置值
function HallMailGrid:SetGridData(data)
	self.vo = data
	self.mLabel_Up.text = data.strTitle
	self.mLabel_Normal.text = data.strTitle
	self.obj:SetActive(true)
end

function HallMailGrid:SetPosition(vec3)
	self.obj.transform.localPosition=vec3
	
end

function HallMailGrid:Recycle()
	self.obj:SetActive(false)
	self.vo=nil
end

function HallMailGrid:__delete( ... )
	self.labelTitle = nil
	self.labelTime = nil
	self.labelContent = nil
	if self.obj then
		GameObjectDestroy(self.obj)
	end
	self.obj=nil
	self.vo=nil
end
