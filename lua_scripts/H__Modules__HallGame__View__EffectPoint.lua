EffectPoint=EffectPoint or BaseClass()

EffectPointIndex = 0

function EffectPoint:__init( obj)
	self.obj=obj
end

function EffectPoint:Play(pos)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.outRoom)
    self.obj.transform.position  = pos
    self:SetObjActive(true)
    EffectPointIndex = EffectPointIndex + 1
    if EffectPointIndex > 10000 then
        EffectPointIndex = 1
    end
    RenderMgr.AddInterval(function ()
        self:Stop()
    end,"EffectPoint:EffectPointIndex"..EffectPointIndex,1,1.1)
end

function EffectPoint:Stop()
    self:SetObjActive(false)
    HallGameController:GetInstance().view.panel:CallBackEffectPoint(self)
end

function EffectPoint:SetObjActive(bol)
    self.obj:SetActive(bol)
end

function EffectPoint:__delete( )
    self.obj = nil
end