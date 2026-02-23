HallAdPopModel = HallAdPopModel or BaseClass(LuaModel)

function HallAdPopModel:__init( ... )
	self:InitData()
end


function HallAdPopModel:InitData( ... )
	-- body
	self.adData = {}
end

function HallAdPopModel:GetInstance()
	if HallAdPopModel.instance == nil then
		HallAdPopModel.instance = HallAdPopModel.New()
	end
	return HallAdPopModel.instance
end

---callBack
function HallAdPopModel:GetAd( callBack )
	local uTime = os.time()
	local uAgenID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uAgencyID)
	local uiUserID = tostring(PlayerInfoController:GetInstance().model.mainPlayer.uiUserID)
	local code = GetRequestCode({uAgenID,uiUserID,uTime},"|")
	local postTable = {
		{"uid",uiUserID},
		{"agentid",uAgenID},
		{"time",uTime},
		{"code",code},
	}

	local sucFunc = function ( datas )
		PrintLog("GetAd====================")
		pt(datas)
		if datas.retcode==0  then
			self.adData = datas.data
			UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallAdPop,function (panel)
				panel:RefreshPanel()
			end)
            if callBack then
                callBack()
            end
        else
            UIManager:GetInstance():ShowNoteMessage(datas.msg)
        end
	end
	WebRequestByPost(WebDataRequestManager.RequestInterface.AdPop,postTable,sucFunc,nil,nil,false)
end

function HallAdPopModel:__delete( ... )
end


