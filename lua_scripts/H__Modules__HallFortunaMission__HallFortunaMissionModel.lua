HallFortunaMissionModel = BaseClass(LuaModel)

function HallFortunaMissionModel:__init()
    self.TASK_TITLE_MAX_LEN = 64
    self.TASK_COMMENT_MAX_LEN = 128
    self.TaskGeneralTypeData = nil
    self.TaskListData = nil
    self.DrawTaskPrizeData = nil
    self:RegistProto()
end

function HallFortunaMissionModel:RegistProto()
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_GENERAL_TYPE_LIST,"CClientQueryTaskGeneralTypeResp")
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_LIST_BY_GENERAL_TYPE_ID,"CClientQueryTaskListRsp")
    self:RegistProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_DRAW_ONE_TASK_PRIZE,"CClientDrawTaskPrizeResp") 
end

function HallFortunaMissionModel:RemoveProto()
    self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_GENERAL_TYPE_LIST,"CClientQueryTaskGeneralTypeResp")
    self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_LIST_BY_GENERAL_TYPE_ID,"CClientQueryTaskListRsp")
    self:RemoveProtocal(NetworkDefine.E_MSG_ID.MSG_ID_CS_DRAW_ONE_TASK_PRIZE,"CClientDrawTaskPrizeResp")     
end
----------------------------------------------------------------任务大类型（标题）-----------------------------------------
---客户端查询任务大类型   MSG_ID_CS_QUERY_TASK_GENERAL_TYPE_LIST
function HallFortunaMissionModel:CClientQueryTaskGeneralTypeReq()
    local send  = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","Load timeout",15)
    Net_SendHallData(NetworkDefine.CReqTaskGeneralType,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_GENERAL_TYPE_LIST,20)
    send = nil
end
---客户端查询任务大类型返回
function HallFortunaMissionModel:CClientQueryTaskGeneralTypeResp(buffer)
    print("查询任务大类型返回")
    UIManager:GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    self:DecodetQueryTaskGeneralType(buffer)
    if self.TaskGeneralTypeData.m_sResultId == 0 then
        HallFortunaMissionController.GetInstance().view.panel:QueryTaskGeneralTypeResp(self.TaskGeneralTypeData)
    else
        ServerBackPrompt(msg.m_sResultId)
       self.TaskGeneralTypeData = nil
    end
end
---解析客户端查询任务大类型
function HallFortunaMissionModel:DecodetQueryTaskGeneralType(szBuffer)
 	if szBuffer==nil then return end
	local iStartLength=0
	self.TaskGeneralTypeData={}
	self.TaskGeneralTypeData.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
	iStartLength=iStartLength+NetworkDefine.DataType.Int16

	self.TaskGeneralTypeData.m_ucTypeCount=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)--邮件发送时间
    iStartLength=iStartLength+NetworkDefine.DataType.Byte
	
	self.TaskGeneralTypeData.TaskGenealTypeList={}
	if self.TaskGeneralTypeData.m_ucTypeCount>0 then
		for i=1,self.TaskGeneralTypeData.m_ucTypeCount do
			self.TaskGeneralTypeData.TaskGenealTypeList[i]={}
            local tmp=self.TaskGeneralTypeData.TaskGenealTypeList[i]
            
			tmp.m_GeneralTypeId=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)---ID
            iStartLength=iStartLength+NetworkDefine.DataType.Byte
            
			tmp.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,self.TASK_TITLE_MAX_LEN)--任务标题标题
			iStartLength=iStartLength+self.TASK_TITLE_MAX_LEN
		end
	end
end
----------------------------------------------------------------任务大类型（标题）-----------------------------------------
----------------------------------------------------------------客户端查询指定任务大类型下面的任务列表-----------------------------------------
---查询指定任务大类型下面的任务列表
function HallFortunaMissionModel:CClientQueryTaskListReq(taskID)
    local send  = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_ucGeneralTypeID = taskID
    UIManager.GetInstance():ShowNetWorkMessage("Loading_tips","Load timeout",15)
    Net_SendHallData(NetworkDefine.CReqTaskList,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_QUERY_TASK_LIST_BY_GENERAL_TYPE_ID,20)
    send = nil
end
---查询指定任务大类型下面的任务列表返回
function HallFortunaMissionModel:CClientQueryTaskListRsp(buffer)
    self:DecodetQueryTaskList(buffer)
    pt(self.TaskListData)
    local temp = nil
    for i = 1, self.TaskListData.m_ucTaskCount - 1 do
        
        if self.TaskListData.TaskItemList[i].m_DrawPrizeStatus > self.TaskListData.TaskItemList[i+1].m_DrawPrizeStatus then
            temp = nil
            temp = self.TaskListData.TaskItemList[i+1]
            self.TaskListData.TaskItemList[i+1] =self.TaskListData.TaskItemList[i]
            self.TaskListData.TaskItemList[i] = temp
        end
    end
    temp = nil
    -- table.sort(self.TaskListData.TaskItemList,function(a,b) 
	-- 	if a["m_DrawPrizeStatus"]<=b["m_DrawPrizeStatus"] then
	-- 		return true
	-- 	else
	-- 		return false
	-- 	end
	-- end)
    UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    if self.TaskListData.m_sResultId == 0 then
        HallFortunaMissionController.GetInstance().view.panel:QueryTaskListresp(self.TaskListData)
    else
        ServerBackPrompt(self.TaskListData.m_sResultId)
    end
end

---解析查询指定任务大类型下面的任务列表
function HallFortunaMissionModel:DecodetQueryTaskList(szBuffer)
    if szBuffer==nil then return end
    local iStartLength=0
    self.TaskListData={}
    self.TaskListData.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
    iStartLength=iStartLength+NetworkDefine.DataType.Int16

    self.TaskListData.m_ucGeneralTypeId=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)   --任务ID
    iStartLength=iStartLength+NetworkDefine.DataType.Byte

    self.TaskListData.m_ucTaskCount=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)       --任务个数
    iStartLength=iStartLength+NetworkDefine.DataType.Byte

    self.TaskListData.TaskItemList={}
    if self.TaskListData.m_ucTaskCount>0 then
        for i=1,self.TaskListData.m_ucTaskCount do
            self.TaskListData.TaskItemList[i]={}
            self.TaskListData.TaskItemList[i].m_Id=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)     --任务id
            iStartLength=iStartLength+NetworkDefine.DataType.Int32

            self.TaskListData.TaskItemList[i].m_PrizeValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --任务奖励
            iStartLength=iStartLength+NetworkDefine.DataType.Int32
            
            self.TaskListData.TaskItemList[i].m_Title=DataParse.BytesToString2(szBuffer,iStartLength,self.TASK_TITLE_MAX_LEN)--任务标题标题
            iStartLength=iStartLength+self.TASK_TITLE_MAX_LEN

            self.TaskListData.TaskItemList[i].m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,self.TASK_COMMENT_MAX_LEN)--任务说明
            iStartLength=iStartLength+self.TASK_COMMENT_MAX_LEN
            
            self.TaskListData.TaskItemList[i].m_ThresholdValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --阀值
            iStartLength=iStartLength+NetworkDefine.DataType.Int32

            self.TaskListData.TaskItemList[i].m_CurrentValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --当前完成进度
            iStartLength=iStartLength+NetworkDefine.DataType.Int32

            self.TaskListData.TaskItemList[i].m_DrawPrizeStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)       --是否可领取奖励, 0: 可领取, 1: 不可领取, 2: 已经领取, 见 task_prize_draw_status_e
            iStartLength=iStartLength+NetworkDefine.DataType.Byte

        end
    end
end
----------------------------------------------------------------客户端查询指定任务大类型下面的任务列表-----------------------------------------

----------------------------------------------------------------领取任务奖励-----------------------------------------

---领取任务
function HallFortunaMissionModel:CClientDrawTaskPrizeReq(m_ucGeneralTypeId,m_unId)
    local send  = {}
    send.m_unUIN = PlayerInfoController:GetInstance().model.mainPlayer.uiUserID
    send.m_ucGeneralTypeID = m_ucGeneralTypeId
    send.m_unId = m_unId
    UIManager.GetInstance():ShowNetWorkMessage("领取中","领取超时。。",15)
    Net_SendHallData(NetworkDefine.CReqDrawTaskPrize,send,0,NetworkDefine.E_MSG_ID.MSG_ID_CS_DRAW_ONE_TASK_PRIZE,20)
    send = nil
end
---领取任务返回
function HallFortunaMissionModel:CClientDrawTaskPrizeResp(buffer)
    UIManager.GetInstance():HidePanel(UIPanelDefine.EWndID.NetWorkMsg)
    self:DecodeDrawTaskPrize(buffer)
    if  self.DrawTaskPrizeData.m_sResultId == 0 then
        self:DispatchEvent(EventName.ClientDrawTaskPrizeResp,self.DrawTaskPrizeData)
    else
        print("领取任务奖励错误：",self.DrawTaskPrizeData.m_sResultId)
        ServerBackPrompt(self.DrawTaskPrizeData.m_sResultId)
        self.DrawTaskPrizeData = nil
    end
end

----解析领取奖励返回
function HallFortunaMissionModel:DecodeDrawTaskPrize(szBuffer)
    if szBuffer==nil then return end
    local iStartLength=0
    self.DrawTaskPrizeData={}
    self.DrawTaskPrizeData.m_sResultId=DataParse.NetworkToHostOrderToInt16(szBuffer,iStartLength)
    iStartLength=iStartLength+NetworkDefine.DataType.Int16

    self.DrawTaskPrizeData.m_unUIN=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
    iStartLength=iStartLength+NetworkDefine.DataType.Int32

    self.DrawTaskPrizeData.m_ucGeneralTypeId=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)   --任务ID
    iStartLength=iStartLength+NetworkDefine.DataType.Byte

    self.DrawTaskPrizeData.TaskItem={}

    self.DrawTaskPrizeData.TaskItem.m_Id=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)     --任务id
    iStartLength=iStartLength+NetworkDefine.DataType.Int32

    self.DrawTaskPrizeData.TaskItem.m_PrizeValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --任务奖励
    iStartLength=iStartLength+NetworkDefine.DataType.Int32
    
    self.DrawTaskPrizeData.TaskItem.m_Title=DataParse.BytesToString2(szBuffer,iStartLength,self.TASK_TITLE_MAX_LEN)--任务标题标题
    iStartLength=iStartLength+self.TASK_TITLE_MAX_LEN

    self.DrawTaskPrizeData.TaskItem.m_szContent=DataParse.BytesToString2(szBuffer,iStartLength,self.TASK_COMMENT_MAX_LEN)--任务说明
    iStartLength=iStartLength+self.TASK_COMMENT_MAX_LEN
    
    self.DrawTaskPrizeData.TaskItem.m_ThresholdValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --阀值
    iStartLength=iStartLength+NetworkDefine.DataType.Int32

    self.DrawTaskPrizeData.TaskItem.m_CurrentValue=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength) --当前完成进度
    iStartLength=iStartLength+NetworkDefine.DataType.Int32

    self.DrawTaskPrizeData.TaskItem.m_DrawPrizeStatus=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)       --是否可领取奖励, 0: 不可领取, 1: 可领取, 2: 已经领取, 见 task_prize_draw_status_e
    iStartLength=iStartLength+NetworkDefine.DataType.Byte
end

----------------------------------------------------------------领取任务奖励-----------------------------------------

function HallFortunaMissionModel:GetInstance()
	if HallFortunaMissionModel.instance==nil then 
		HallFortunaMissionModel.instance=HallFortunaMissionModel.New()
	end
	return HallFortunaMissionModel.instance
end

function HallFortunaMissionModel:CleanAllData()
    self.TaskListData = nil
    self.TaskGeneralTypeData = nil
    self.DrawTaskPrizeData = nil
end

function HallFortunaMissionModel:__delete()
    self:CleanAllData()
    self:RemoveProto()
    self.TASK_TITLE_MAX_LEN = nil
    self.TASK_COMMENT_MAX_LEN = nil
    
end