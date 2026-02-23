UIDailiGrid=UIDailiGrid or BaseClass()

function UIDailiGrid:__init(obj)
	self.obj=obj
	local mTran=self.obj.transform
	--self.labelName=mTran:Find("Button/Label"):GetComponent(typeof(UILabel))
	--local mButton_Recharge = mTran:Find("Button").gameObject
	--self.labelWechat=mTran:Find("WeiXin/Name_Label"):GetComponent(typeof(UILabel))
	UIEventListener.Get(self.obj).onClick=function() HallRechargeController:GetInstance().view.panel:OnDailItemClick(self.vo) end
end

function UIDailiGrid:SetItem(vo)
	self.vo=vo
	--SetStringLabel(self.labelName,vo.title)
end



function UIDailiGrid:Show()
	self.obj:SetActive(true)
end
function UIDailiGrid:Hide()
	self.obj:SetActive(false)
end
function UIDailiGrid:__delete( ... )
	self.labelName = nil
	self.labelWechat = nil
end