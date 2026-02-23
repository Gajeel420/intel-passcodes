CoinPanel = CoinPanel or BaseClass()

function CoinPanel:__init( obj )
    self.obj = obj
    self:InitUI()
    self:InitData()
end

function CoinPanel:InitUI()
    local mTran = self.obj.transform
    self.m_Anim = mTran:Find("Effect/Item"):GetComponent(typeof(Animator))
end

function CoinPanel:InitData()
    self.isTails = true
    self.AnimName = {[1]={[1]={"situation1","situation1F"},[2]={"situation3","situation3F"}},[2]={[1]={"situation2","situation2F"},[2]={"situation4","situation4F"}}}
    self.AnimTime = {[1]={[1]={2.7,2.7},[2]={2.1,2.1}},[2]={[1]={3,2.4},[2]={1.8,1.7}}}
end

function CoinPanel:HandelOpenData(data)
    local StartFun = function ()
        GameController:GetInstance().view.m_BtnViewPanel:IsShowTipHeads()
        local index = math.random(1,2)
        GameSoundController:GetInstance():PlayGameAudio(GameLuaDefine.SoundID.Rotation,true)
        if data.n64WinCoin>0 then
            if data.byPrizeFaceIndex==1 then
                if self.isTails then
                    self:PlayCoinAnim(1,1,index)
                else
                    self.isTails=not self.isTails
                    self:PlayCoinAnim(2,2,index)
                end
            else
                if self.isTails then
                    self.isTails=not self.isTails
                    self:PlayCoinAnim(2,1,index)
                else
                    self:PlayCoinAnim(1,2,index)
                end
            end
        else
            if self.isTails then
                if data.byPrizeFaceIndex==1 then
                    self:PlayCoinAnim(1,1,index)
                else
                    self.isTails = not self.isTails
                    self:PlayCoinAnim(2,1,index)
                end
            elseif not self.isTails then
                if data.byPrizeFaceIndex==1 then
                    self.isTails = not self.isTails
                    self:PlayCoinAnim(2,2,index)
                else
                    self:PlayCoinAnim(1,2,index)
                end
            end
        end
        GameSoundController:GetInstance():StopSound(GameLuaDefine.SoundID.Rotation)
        GameSoundController:GetInstance():PlaySound(GameLuaDefine.SoundID.Stop)
        yield_return(WaitForSeconds(0.5))
        GameController:GetInstance().view.m_BtnViewPanel:SetOpenDataView(data)
    end
    StartCoroutine(StartFun)
end

function CoinPanel:PlayCoinAnim(index,index1,index2)
    self.m_Anim:Play(self.AnimName[index][index1][index2],0,0)
    yield_return(WaitForSeconds(self.AnimTime[index][index1][index2]))
end

function CoinPanel:__delete( ... )

end