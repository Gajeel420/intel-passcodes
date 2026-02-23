HallSecondarGameView = BaseClass()

function HallSecondarGameView:__init(obj,gameItem)
    self.obj = obj
    self.gameItem = gameItem
    self:InitUI()
end

function HallSecondarGameView:InitUI()
    self.gameType = 1
    self.CurrentLoadIndex = 0
    self.mItemGameList = {}
    local mTran = self.obj.transform
    local mObj_Back = mTran:Find("Btn_Back").gameObject
    UIEventListener.Get(mObj_Back).onClick = function(obj) self:OnBackButtonClick(obj) end
    self.mPanel = self.obj:GetComponent(typeof(UIPanel))
    local mTranUI = mTran:Find("SecordGamePanel")
    if mTranUI ~= nil then
        self.mPanel_GameList = mTranUI:GetComponent(typeof(UIPanel))
        self.mScrollView = mTranUI:GetComponent(typeof(UIScrollView))
    end
    mTranUI = mTran:Find("SecordGamePanel/Grid")
    if mTranUI ~= nil then
        self.mParent = mTranUI
        self.mScondGame = mTranUI:GetComponent(typeof(UIGrid))
    end
    
end


function HallSecondarGameView:OnBackButtonClick(obj)
    SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)
    self:SetViewDisplay(false)
end


function HallSecondarGameView:ShowView(gameType)
    self.gameType = gameType
    self:SetViewDisplay(true)
    if #self.mItemGameList == 0 then
        self:CreateTypeGameList()
    end
end






function HallSecondarGameView:CreateTypeGameList()
    local itemIntiDelay=0.05
    local gameConfigList=ConfigModuleModel:GetInstance():GetGameConfigList()
    --new
    local total =#gameConfigList
  
    for i = 1, total do
        local gameConfig=gameConfigList[i]
        if gameConfig.iGameType == self.gameType then
            local vo={
                gameID=gameConfig.iGameCID,
                gameType=gameConfig.iGameType,
                gameName=gameConfig.strGameName,
                isShowBig=gameConfig.iStatus>=10,
                status=gameConfig.iStatus,
                isOpen=gameConfig.iOpen==1,
                index = i,
            }
            vo.callBack=function()
                self:StartLoadNextItemUis()
            end

            local go = GameObject.Instantiate(self.gameItem,self.mParent)
            go:SetActive(true)
            go.name =  tostring(vo.gameID)
            go.transform.localPosition = Vector3.zero
            go.transform.localScale = Vector3.one
            go.transform.localEulerAngles = Vector3.zero
            local grid = HallGameBaseGrid.New(go,vo,itemIntiDelay*i)
            grid:InitUI()
            table.insert(self.mItemGameList,grid )
        end
    end
    self.mScondGame:Reposition()
    StartCoroutine(function()
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        yield_return(CS.UnityEngine.WaitForEndOfFrame())
        self.mScrollView:ResetPosition()
    end)
    self:StartLoadItemUis()
  
end


function HallSecondarGameView:StartLoadItemUis()
    self.CurrentLoadIndex=1
    self:StartLoadNextItemUis()
end

function HallSecondarGameView:StartLoadNextItemUis()
    --print("StartLoadNextItemUi")
    local item = self.mItemGameList[self.CurrentLoadIndex]
    
    if item ~= nil then
        item:StartLoadItemUI()
    end
    self.CurrentLoadIndex = self.CurrentLoadIndex + 1
end


--设置层级
function HallSecondarGameView:SetViewDepth(depth)
    SetPanelstartingRenderQueue(self.mPanel.gameObject,depth+10)
    SetPanelstartingRenderQueue(self.mPanel_GameList.gameObject,depth+12)
end

--设置view的显隐
function HallSecondarGameView:SetViewDisplay(disPlay)
    self.obj:SetActive(disPlay)
end

function HallSecondarGameView:__delete()
end