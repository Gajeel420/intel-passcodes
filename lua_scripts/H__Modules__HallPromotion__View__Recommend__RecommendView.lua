RecommendView = RecommendView or BaseClass()

function RecommendView:__init( obj )
    self.obj=obj
    self:Init()
end

function RecommendView:Init( )
    local mTran = self.obj.transform
    self.mInput_Code=mTran:Find("Input"):GetComponent(typeof(UIInput))
    self.mObj_SubmissionButton=mTran:Find("Button_Submit").gameObject
    UIEventListener.Get(self.mObj_SubmissionButton).onClick = function() self:OnClickSubmissionButton() end

end

function RecommendView:AddEvent( )

end

function RecommendView:RemoveEvent( )

end


function RecommendView:OnClickSubmissionButton( )
	SoundManager:GetInstance():PrePlaySound(0,SoundManager.SoundID.ButtonClick)

    local codeString=self.mInput_Code.value
    if codeString==nil or codeString=="" then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Recommend_Null"))
        return
    end
    local codeNumber=tonumber(codeString)
    if codeNumber==nil or codeNumber==0 then
        UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage("Recommend_Error"))
        return
    end

    HallPromotionModel:GetInstance():ReqBindRecommend(codeNumber)
end


function RecommendView:ShowView( )
    self.obj:SetActive(true)
end
function RecommendView:HideView( )
    self.obj:SetActive(false)
end

function RecommendView:SetPanelDepth(depth)

end

function RecommendView:__delete(  )

end
