HallActiveCenterModel =  HallActiveCenterModel or  BaseClass(LuaModel)

function HallActiveCenterModel:__init( ... )
    self.ActiveCenterDataList = {}
    self.HotSpriteName = 
    {
        [1] = "Hall_Tips_New",
        [2] = "Hall_Tips_Recommend",
        [3] = "Hall_Tips_Hot",
    }
end

---获取活动信息
function HallActiveCenterModel:GetActiveData(needNetWorkMessage)
    local time = os.time()
    local uid = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    local code=GetRequestCode({uid,time},"|")
    local languageid = SystemSetting:GetInstance():GetLanguage()
    if languageid == SystemSetting:GetInstance().LanguageType[2] then
        languageid = "1"
    else
        languageid = "0"
    end
    
    local tb = 
    {
        {"itime",time},
        {"uid",uid},
        {"code",code},
        {"languageid",languageid},
    }

    --print("eeeeeeeeeeeeeewwwwwwwwwwwwwwwww   ",languageid)

    local sucFunc = function (datas) 
        self.ActiveCenterDataList = {}
        if datas.retcode==0 then
            local list = datas.data
            local count = #list
            for i = 1, count do
                local data = {}
                local t = list[i]
                data.ID = t.ID
                data.url = t.url
                data.type = t.type
                data.Title = t.Title
                data.url2 = t.url2
                table.insert(self.ActiveCenterDataList,data )
            end
            UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallActiveCenter)
        end
    end

    local failFunc = function ()
        UIManager:GetInstance():ShowNoteMessage("获取活动信息失败")  --Request_Share_Failure
    end
    WebRequestByPost(WebDataRequestManager.RequestInterface.GetActiveCenterList,tb,sucFunc,failFunc,"Actvity_tips",needNetWorkMessage)
end



function HallActiveCenterModel:__delete()
end