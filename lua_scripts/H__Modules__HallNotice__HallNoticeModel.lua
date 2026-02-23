HallNoticeModel = HallNoticeModel or BaseClass(LuaModel)

function HallNoticeModel:__init( ... )
	self.NoticeMsg = ""
end

function HallNoticeModel:GetNoticeFromService()
	local param = Parameter.New()
 	local itime = os.time()
 	local str = ConfigInfoMgr.WEB_SERVICE_URL 
 	param:Add("itime",itime)
	 local szTem = StringFormat("{0}|{1}",itime,ConfigModuleModel.GetInstance().ClientKey)
 	param:Add("code",CommonUtil.GenMd5CheckCode(szTem))
 	local web = string.gsub(str,"Pay/","")
	local webStr = StringFormat("{0}API/get_msglink/{1}",web,param:ToStringUrl())
	UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","",5)
 	local sucFunc = function(www)
		 local webText = www.text
		 UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		print("GetNoticeFromService ",webText)
		local datas=Json.decode(webText)
		if datas then
			if(datas.retcode==0 and datas.msg=="success") then
				if datas.content then
					HallNoticeController.GetInstance().model.NoticeMsg = datas.content
					UIManager.GetInstance():ShowPanel(UIPanelDefine.EWndID.Notice)
				end
			else
				UIManager:GetInstance():ShowNoteMessage(datas.msg)
				--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRagistMoney)
				
			end
		end
 	end
 	local failFunc = function()
		UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
		
		--UIManager:GetInstance():ShowPanel(UIPanelDefine.EWndID.HallRagistMoney)
		print("获取公告信息失败")
    	--UIManager:GetInstance():ShowNoteMessage(StringFormatByLanguage(""))
	end
	WebDataManager:BeginLuaReqWebURL(webStr,sucFunc,failFunc)
end


function HallNoticeModel:__delete( ... )
	self.mNoticeContentList = nil
end