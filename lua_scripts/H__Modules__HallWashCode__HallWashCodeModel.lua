HallWashCodeModel  = BaseClass(LuaModel)

function HallWashCodeModel:__init(bj)
    
end

---获取戏码信息
---back 回调方法
function HallWashCodeModel:GetGiftInfo(back)
    local param = Parameter.New()
    local itime = os.time()
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    param:Add("time",itime)
    param:Add("uid",uiUserID)
    param:Add("code",GetRequestCode({uiUserID,itime},"|"))
    local sucFunc = function(datas)

        if(datas.retcode==0 or datas.retcode == -9) then
            if back then
                back(datas) 
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
 	end
    WebRequestByGet(WebDataRequestManager.RequestInterface.GetGiftInfo,param,sucFunc,nil)
end


--- 领取礼金
---type 领取类型
---callBack 回调方法
function HallWashCodeModel:AddGift(type,callBack)

    local itime = os.time()
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    local tb = {
        {"time",itime},
        {"uid",uiUserID},
        {"code",GetRequestCode({uiUserID,itime},"|")},
        {"type",type },
    }
    local sucFunc = function(datas)
        if datas.retcode==0  then
            if callBack then
                callBack(type)
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
    end

    local failFunc = function()
        UIManager:GetInstance():ShowNoteMessage("领取失败")
    end
    WebRequestByPost(WebDataRequestManager.RequestInterface.ReceiveWashCode,tb,sucFunc,failFunc,"领取中...")
   
end

---获取洗码列表
---type 类型
---callBack 回调
function HallWashCodeModel:GetWashList(type,callBack)
    local param = Parameter.New()
    local itime = os.time()
    local uiUserID = (PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
    param:Add("time",itime)
    param:Add("uid",uiUserID)
    param:Add("type",type)
    param:Add("code",GetRequestCode({uiUserID,itime},"|"))
    local sucFunc = function(datas)
        if(datas.retcode==0) then
            if callBack then
                callBack(datas) 
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
 	end
 	WebRequestByGet(WebDataRequestManager.RequestInterface.GetWashList,param,sucFunc,nil)
end

HallWashCodeModel.WashListType = 
{
    washcode = 1,
    giftMoney = 2,
}

HallWashCodeModel.GetGiftType =
{
    washCode=1,
    week=2,
    month=3,
}

HallWashCodeModel.ButtonType = 
{
	[0] = "Hall_Btn_Receive",
	[1] = "Hall_Btn_Picked",
	[2] = "Hall_Btn_NoReceive",
}

function HallWashCodeModel:__delete()

end