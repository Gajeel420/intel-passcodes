SUserDetailInfo = SUserDetailInfo or BaseClass(LuaModel)

function SUserDetailInfo:__init( ... )
	self.iExperience=0										-- // 用户经验
    self.iMoney=0                                          --/ 用户金币								
    self.iBank=0											--// 用户财富								
    self.iTreasure=0										--// 钻石   
    self.iLuckyBomb=0                                      --/ 道具炸弹
    self.m_i64Card=0				                        -- //房卡
    self.m_i64WinMatches=0
    self.m_i64WinPoints=0
    self.m_i64LossPoints=0									--//爱心
    self.iMatchTicket=0									--// 参赛劵
    self.iExchangeBill=0                                   -- // 兑换券

	self.uiUserID = 0 -- 用户 ID 
    self.uiAge = 0     -- 年龄	
    self.bBoy = true --性别
    self.dwBirthday = 0										-- 生日
    self.StarTag = 0											    -- 星座
    self.BornTag = 0											    -- 生肖
    self.BloodTag = 0										    -- 血型	
    self.iGameLevel = 0                                          -- 游戏等级
    -- //public string iImageURL                                       ////头像URL地址
    self.iImageNO= 0 	    									--// 个人形象图片文件名
    self.iUserType= 0                                          --//用户类型
    self.szLoginID = ""      --// 登录名 
    self.szNickName = ""   --// 昵称 
    self.szAccountName = ""--//用户设置账号密码后的账号，空代表没有设置账号
    self.m_ucBindFlag = false--//绑定微信标志，0 ： 未绑定 1 绑定
    self.szCountry = ""    --// 国家
    self.szProvince = ""    --// 玩家所在的省
    self.szCity = ""    --// 玩家所在的市
    self.szGameSign = ""   --// 备注  
    self.szTitle = ""   --// 头衔
    self.isSetPasswordFlag = false                                      --//是否设置银行密码
    self.isRechargeFlag = false                                      --//是否首冲
    -- // 当前的桌子信息，如果没有坐下就返回255号桌子号
    self.iGameID=0                                              --游戏ID
    self.iDeskNO= 0											    --// 游戏桌号   
    self.iDeskStation= 0										--// 桌子位置
    self.iRoomID= 0
    self.iUserState= 0											--// 用户状态   
    self.iFascination= 0											    --// 会员等级
    self.iMasterPower= 0										    --// 管理等级
    self.iWinCount = 0										   -- // 胜利		
    self.iLostCount=0										   -- // 输数	数目	
    self.iDrawCount=0										    --// 和局	目	
    self.iPoint=0											   -- // 积分	数目	
    self.iShowLevel=0										    --// 显示优先级		
    self.byNeedCertifyCellPhone=0				                --// 是否需要认证手机   0不需要，1需要 
    self.nMedalID=0
    -- //转账功能
    self.iTransFlag = 0  -- //0: 关闭转帐功能, 1: 开启转帐功能  (房卡总代id)
    self.iTransMin = 0  -- //每次转帐的最低金额 //兑奖码赠送房卡数量
    self.iTransMax = 0  -- //每次转帐的最高金额
    self.iTransTax = 0  -- //转帐抽水额度  【开放卡项目 ，此字段表示自己创建的房间房卡号，如果为0表示没有创建房间】  
    -- //[MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
    self.arrShowID={}
    self.iActiveVal=0                                          --// 活力值
    self.iSunshineVal=0                                        --// 阳光值
    -- //[MarshalAs(UnmanagedType.ByValArray, SizeConst = 20)]
    self.arrPerformaceInLevel = {}                              --// 玩家在各等级的表现次数
    -- //[MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
    self.szSignature = ""                              --// 玩家个性签名
    -- // time_t tmAvoidWar
    self.tmAvoidWar=0
    self.iCutRoomID=0
    self.iCertificateCellPhone=false                              --// //是否已经认证手机号码
    self.iCertificate=false                              --// //是否已经认证身份证号
    self.byCeritfiyFlag=0                                    --// 是否需要认证身份   0不需要，1需要   sean.yang 20120522
    -- //byte		byNeedCertifyCellPhone				               // 是否需要认证手机   0不需要，1需要 
    self.iUserCertifyMoney=0                                  --// 玩家认证可以得到的赠送 sean.yang 20120524
    self.iMaxExpVal=0                                         --// 最多的经验值 主要用于个人等级界面中显示超过多少人用到 add li
    -- // 新增VIP字段
    self.iVipLevel=0				                           --// vip等级
    self.iVipFace=0                                           --// Vip表情 有1， 无0                                               
    self.iVipAnimation=0                                      --// 动一下动画  有1， 无0 
    self.iVipTotalRecharge=0                                    --//累计充值额度
     
    -- ///////////////增比赛字段
    self.iSignupMatchID=0                                     --// 已报名的比赛ID
    self.iSignupRoomID=0                                      --// 已报名的比赛对应的房间ID
    self.iCurMatchID=0                                        --// 当前正在的比赛ID
    self.byIsYouke=0     --//是否是游客登陆
    self.iCurUseCarLevel=0       --//vip当前使用的车等级          新增2015.01.14
    -- //public int iViewDirection                                     //相对桌子的位置
    self.iTotalGiveMoney=0                                           --//总的赠币数量
    self.iUnlockGiveMoney=0                                          --//可提取赠币数量

	self.szMD5PassWord = {}
	self.szPassWord = ""
	self.szUserName = ""
	self.TML_SN = ""
	self.szBankPassWord = nil
	self.uAreaID = 0
	self.uAgencyID = 0
	self.uRemain = 0
	self.uPlayerScore = 0

    self.SendHeartRatio = 0 --//发送一个爱心能得到多少金币的比率(献出)
    self.ExpendHeartRatio = 0 --//消耗一个爱心能得到多少金币的比率(转盘)

    self.mShareTitle = ""      --//配置到位才能使用分享功能   
    self.mShareText = "" --//分享内容
    self.mShareImageUrl = ""  --//图片logo地址
    self.mShareWebUrl = "" --//推广页地址
    self.mShareContent = "" --//分享界面显示内容
    self.desk=nil
    self.UserAgentLevel = 0  --    用户等级
    self.UserAgentCheckSign = 0 --审核标记
end

function SUserDetailInfo:UpdateVo(data)
    for k,v in pairs(data) do
        if type(v)~="function" and k~="_class_type" then
            if type(v)=="boolean" then
                self:SetValue(k,v,self[k])
            else
                if self[k] then
                    self:SetValue(k,v,self[k])
                end
            end
        end
    end
end

function SUserDetailInfo:SetValue(k,v,old)
    if self[k] ~=v then
        self[k]= v
        self:DispatchEvent(PlayerInfoConst.EventName_UpdatePlayerInfo,{k,v,old})
    end
end

function SUserDetailInfo:__delete( ... )
	
end