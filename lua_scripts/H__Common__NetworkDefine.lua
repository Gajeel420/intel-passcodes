NetworkDefine = {}
NetworkDefine.g_Frequency=3
NetworkDefine.DataType={
    Byte=1,
    Int16=2,
    UInt16=2,
    Int32=4,
    UInt32=4,
    Int64=8,
}

---后台想客户端发送赠送奖励类型
NetworkDefine.BonusType = 
{
    E_GIFT_TYPE_RED_PACKET = 1,    --红包彩金
}

NetworkDefine.E_ACCOUNT_TYPE = {
	E_ACCOUNT_TYPE_ROBOT = 0,      -- //机器人账户
    E_ACCOUNT_TYPE_AUTO = 1,       --//自动登陆，免注册，游客登陆
    E_ACCOUNT_TYPE_NORMAL = 2,       --//常规用户，用户名密码登陆，注册用户
    E_ACCOUNT_TYPE_THIRD_QQ = 3,       --//第三方登陆用户, QQ
    E_ACCOUNT_TYPE_THIRD_WEIXIN = 4,       --//第三方登陆用户, 微信
    E_ACCOUNT_TYPE_THIRD_ALIPAY = 5,       --//第三方登陆用户, 支付宝
    E_ACCOUNT_TYPE_VISUAL = 6,       --//虚拟账户，绑定账户
    E_ACCOUNT_TYPE_GM = 7,       --//GM账户，运营管理账户
    E_ACCOUNT_TYPE_AUTO_WITH_INVITE_CODE = 101, --//带邀请码的自动登陆
    E_ACCOUNT_TYPE_NORMAL_WITH_INVITE_CODE = 102,  --//带邀请
    E_ACCOUNT_TYPE_THIRD_QQ_WITH_INVITE_CODE = 103, --//带邀请码的第三方QQ登陆
    E_ACCOUNT_TYPE_THIRD_WEIXIN_WITH_INVITE_CODE = 104, --//带邀请码的第三方微信登陆
    E_ACCOUNT_TYPE_THIRD_ALIPAY_WITH_INVITE_CODE = 105, --//带邀请码的第三方支付宝登陆
}

NetworkDefine.E_WIN_RANK_TYPE = 
{
	DAY  = 0,  -- 盈利日排行榜
	WEEK = 1,  -- 盈利周排行榜
	WEEK_TOTAL_WIN = 2,  -- 赢分周排行榜
}

-- 活动长度
NetworkDefine.ACTIVITY_LEN =
{ 
	E_ACTIVITY_LEN_activity_name	 = 64,   -- 活动名称
	E_ACTIVITY_LEN_activity_schedule = 5048, -- 活动方案 （根据实际长度解析）
    E_ACTIVITY_LEN_timeZone	         = 64,   -- 时区 
};

-- 活动 ID 
NetworkDefine.ACTIVITY_ID =
{ 
    E_ACTIVITY_ID_WagerBonus = 1, -- 活动ID=1:WagerBonus 
    E_ACTIVITY_ID_FirstRecharge = 2, -- 活动ID=2:FirstRecharge
    E_ACTIVITY_ID_BetRank = 3, -- 活动ID=3:BetRank 押注排行
    E_ACTIVITY_ID_BetRebate = 4, -- 活动ID=4:BetRebate 打码量返利活动
    E_ACTIVITY_ID_AllSaintsDay = 5, -- 活动ID=5:万圣节抽奖活动
    E_ACTIVITY_ID_FortuneCookie = 8, -- 活动ID=8:饼干奖励活动
};

NetworkDefine.E_MSG_ID= {
        -- //#########################################################################
        -- //大厅功能 消息ID
        -- //#########################################################################
        -- //登陆类
MSG_ID_CS_OPEN_LOGIN = 1101,        --//自动登陆,登陆1
MSG_ID_SC_USER_INFO = 1136,         --//获取用户信息
MSG_ID_CS_NOTIFY_USER_OFFLINE = 1107,   --//通知客户端下线
MSG_ID_CS_HEARTBEAT = 1108,   --//客户端和Lotus的心跳消息
MSG_ID_CS_AUTO_USER_SET_USERNAME_PASSWD = 1111,  --//以游客身份登陆的用户, 自己设置一个帐户和密码
MSG_ID_CS_AUTO_USER_SET_USERNAME_PASSWD_WW= 1130, --//旺旺版以游客身份登陆的用户, 自己设置一个帐户、密码和手机号--
MSG_ID_CS_USER_CHANGE_ACCOUNT_PASSWD = 1112,  --//用户修改帐号密码
MSG_ID_UPDATE_USERINFO = 1191, -- //更新用户信息
MSG_ID_CS_GET_RICH_RANKING = 1105, --//客户端查询财富排行榜
MSG_ID_CS_QUERY_WIN_RANKING_LIST= 1839, -- //客户端查询赢钱排行榜
MSG_ID_CS_QUERY_RECHARGE_RANKING_LIST= 1840, -- //客户端查询充值排行榜

MSG_ID_CS_PAYMENT_QUEERY_REAL_SPURIOUS_RECHARGE_RANKING_LIST= 1844, --客户端查询充值排行榜(真假掺和的)

MSG_ID_CS_PAYMENT_QUERY_REAL_SPURIOUS_WIN_RANKING_LIST = 1845, --客户端查询赢钱排行榜(真假掺和的)

-- MSG_ID_CS_GET_RICH_RANKING_WW= 1129, --//旺旺版客户端根据条件查询用户信息 
MSG_ID_CS_FUZZY_QUERY_USER_INFO = 1109,   --//客户端根据条件查询用户信息 
MSG_ID_CS_FUZZY_QUERY_USER_INFO_WW= 1129, --//旺旺版客户端根据条件查询用户信息 
MSG_ID_SS_USER_QUERY_AWARD_INFO = 1113,                 --//用户查询奖项设置及用户当天抽奖情况
MSG_ID_SS_USER_DO_LOTTERY = 1114,                       --//用户执行抽奖动作
MSG_ID_CS_QUERY_USER_GAME_ROOM_DESK = 1115,--//查询用户所在游戏，房间桌子信息
MSG_ID_CS_QUERY_EXPERIENCE_ROOM_LEFT_TIME = 1117,  --//客户端查询玩家体验场剩余体验时间
MSG_ID_CS_NOTIFY_USER_APPLY_CANVASSER_FINISHED = 1119, --//自动代理系统, 通知客户端, 申请成为推广员成功
MSG_ID_CS_QUERY_LATEST_SHARED_FRIEND = 1121, --//查询最近分享的好友列表
MSG_ID_CS_MAKE_FRIEND = 1301,   --//添加好友
MSG_ID_CS_MAKE_SURE_FRIEND = 1302,--//同意添加好友
MSG_ID_CS_MAKE_FRIEND_NOTIFY = 1303, --//添加好友结果通知, 服务器发送给被添加用户的消息
MSG_ID_CS_GET_FRIEND = 1304,--//查询好友列表，显示在线状态
MSG_ID_CS_DELETE_FRIENDS = 1305, --//删除好友
MSG_ID_CS_DELETE_FRIEND_NOTIFY = 1306, --//服务器通知客户端你被别人删除好友了, 客户端不需要回响应
MSG_ID_CS_NOTIFY_CLIENT_FRIEND_OFFLINE = 1307, --//服务器通知客户端你的某个朋友离线了
MSG_ID_CS_NOTIFY_CLIENT_FRIEND_ONLINE = 1319, --//服务器通知客户端你的某个朋友上线了
MSG_ID_CS_USER_QUERY_QQ_NEW_USER_GIFT_PACKET = 1639,-- //用户查询QQ新手礼包
MSG_ID_CS_USER_DRAW_QQ_NEW_USER_GIFT_PACKET = 1640, --//用户领取QQ新手礼包
MSG_ID_CS_CREATEROOM = 2001,--//创建房间
MSG_ID_CS_QUERY_ROOMCARD = 2002,--//查询房间房卡
MSG_ID_CS_GET_USER_TOTAL_SCORE = 2004,--//房卡结算
MSG_ID_CS_REFILL_CARDROOM = 2005,--//续房卡
MSG_ID_CS_GAME_MNG_COIN_CREATECARD = 2018,          --//金币开房卡功能，创建房间
MSG_ID_CS_PLAY_COIN_NORMAL_GET_GAME_LIST = 2015, --//金币场玩法,查询游戏列表
MSG_ID_CS_PLAY_COIN_NORMAL_JOIN_GAME = 2016, --//金币场玩法, 加入游戏,快速加入游戏，客户端选择一个金币场，搓桌进入（取消搓桌）,加入游戏，快速加入游戏
MSG_ID_CS_PLAY_COIN_NORMAL_GET_CARD_RULE = 2017,  --//根据cardid获取规则信息
MSG_ID_SS_QUERY_JACKPOT_INFO = 2021,  --//根据cardid获取规则信息
MSG_ID_CS_NOTIFY_CLIENT_NOTIFICATION = 2102, --//给客户端广播通告
MSG_ID_CS_QUERY_NOTIFICATION = 2103,-- //客户端查询公告
MSG_ID_CS_NOTIFY_CLIENT_EMAIL = 2104, --//给客户端发送邮件
MSG_ID_CS_OPERATE_EMAIL = 2105, --//客户端通知服务器邮件操作类型, 读了邮件, 删除邮件等
MSG_ID_CS_QUERY_EMAIL_LIST = 2106, --//客户端指定查询条件查询邮件列表
MSG_ID_CS_QUERY_EMAIL_DETAIL = 2107, --//客户端查询单个邮件的详情
MSG_ID_CS_SVR_BROADCAST_LOTTERY_POOL = 2130, ----广播奖池信息
MSG_ID_SS_QUERY_USER_GAME_BILL = 2012,   --//房卡游戏，查询游戏账单
MSG_ID_CS_QUERY_TASK_LIST = 2801,       --//用户查询任务列表
MSG_ID_CS_REPORT_WE_CHAT_SHARE = 2804,   --//用户上报微信分享
MSG_ID_CS_DRAW_TASK_PRIZE = 2803,       --//用户领取任务奖励

MSG_ID_SAVE_MONEY = 1801,           --//存钱
MSG_ID_GET_MONEY = 1802,           --//取钱
MSG_ID_TRANSFER_MONEY = 1803,      -- //转账
MSG_ID_CS_QUERY_TRANSFER_MONEY_REVOKE = 1838, --转帐撤销
MSG_ID_MONEY_CHANGE = 1810,        -- //用户数据变更通知   
MSG_ID_MONEY_REQUEST_CHANGE = 1808,  --//请求用户金钱数据 , //用户数据变更通知   
MSG_ID_CHANGE_PASSWORD = 1811,
MSG_ID_CHANGE_PayMent = 1807,
MSG_ID_CS_PAYMENT_CHECK_BANK_PASSWD = 1825,-- //校验银行密码
MSG_ID_CS_PAYMENT_QUERY_RECHARGE_VIP = 1826,-- //查询充值vip等级信息

MSG_ID_SEND_CHAT_MSG = 1201,

MSG_ID_GET_CHAT_MSG = 1202,

MSG_ID_CS_GAME_MNG_CREATE_GUILD_GAME = 2007,        --//会长创建公会游戏
MSG_ID_CS_GAME_MNG_GET_GUILD_GAMELIST = 2008,       --//查询公会游戏列表
MSG_ID_CS_GAME_MNG_JOIN_GUILD_GAME = 2009,      --//加入公会游戏，查询房间id及游戏规则

MSG_ID_CS_CREATE_GUILD = 1308, --//创建公会
MSG_ID_CS_DISMISS_GUILD = 1309, --//解散公会
MSG_ID_CS_QUERY_GUILD_LIST = 1311,-- //查询公会列表
MSG_ID_CS_QUERY_GUILD_BY_ID = 1312, --//根据公会ID查询公会信息
MSG_ID_CS_REQ_JOIN_GUILD = 1313, --//申请加入公会
MSG_ID_CS_REQ_QUIT_GUILD = 1314, --//退出公会
MSG_ID_CS_NOTIFY_JOIN_GUILD_RESULT = 1316, --//通知申请加入公会结果

MSG_ID_CS_USER_APPLY_TO_BE_AGENT_USER_BY_INVITE_CODE = 1122, --//用户通过输入推荐码成为代理下线
MSG_ID_CS_GUILD_GAME_UPDATE_NOTIFY = 2011,-- //公会游戏规则更新(新创建或删除), 通知公会成员
MSG_ID_CS_NOTIFY_DISMISS_GUILD = 1317, --//公会解散通知
MSG_ID_CS_USER_FEEDBACK_INFO = 1123, --//用户反馈信息

MSG_ID_CS_USER_QUERY_RELIF_FUND = 1632, --//用户查询救济金
MSG_ID_CS_USER_DRAW_RELIF_FUND = 1633, --//用户领取救济金
MSG_ID_CS_USER_QQ_EVERY_DAY_GIFT_QUERY_LOTTERY_PRIZE_INFO = 1634, --//用户QQ每天登陆幸运转盘, 查询抽奖奖品信息
MSG_ID_CS_USER_QQ_EVERY_DAY_GIFT_LOTTERY = 1635, --//用户QQ每天登陆幸运转盘抽奖
--//MSG_ID_CS_QUERY_QQ_SIGN_PRIZE_CFG = 2804, //查询QQ签到奖励配置
--//MSG_ID_CS_DRAW_QQ_SIGN_PRIZE = 2805,      //领取QQ签到奖励

MSG_ID_CS_REPORT_EVERYDAY_LOGIN_COMMERCE = 2805, --//用户上报每日登陆奖励
MSG_ID_CS_GET_EVERYDAY_LOGIN = 2806, --用户查询每日登陆奖励

MSG_ID_CS_USER_QUERY_COMMODITY_LIST = 1616, --//用户查询商城中商品列表
MSG_ID_CS_USER_QUERY_PROP_LIST = 1617, --//用户查询道具列表
MSG_ID_CS_USER_QUERY_LOTTERY_LIST = 1618, --//用户查询抽奖列表
MSG_ID_CS_USER_QUERY_CASH_CFG_LIST = 1619, --//用户查询兑换物列表
MSG_ID_CS_USER_QUERY_GAME_PRIZE_LIST = 1620, --//用户查询游戏奖品
MSG_ID_CS_USER_QUERY_BACKPACK_PROP_LIST = 1621, --//用户查询背包中道具列表
MSG_ID_CS_USER_DRAW_GAME_PRIZE = 1622, --//用户领取游戏奖品
MSG_ID_CS_USER_CALASSIC_DO_LOTTERY = 1623, --//精品斗地主用户抽奖
MSG_ID_CS_USER_BUY_COMMODITY = 1624, --//用户购买商品
MSG_ID_CS_USER_DO_CASH = 1625, --//用户兑换申请
MSG_ID_CS_USER_QUERY_CASH_RECORD = 1626, --//用户查询兑换记录
MSG_ID_CS_USER_DONATE_PROP = 1627, --//用户转赠道具
MSG_ID_CS_USER_QUERY_DONATE_PROP_RECORD = 1628, --//用户查询赠送道具记录
MSG_ID_CS_USER_BANKRUPT_GIFT_QUERY_LOTTERY_PRIZE_INFO = 1629, --//用户破产赠送查询抽奖奖品信息
MSG_ID_CS_USER_BANKRUPT_LOTTERY = 1630, --//用户破产赠送抽奖
MSG_ID_CS_USER_USE_PROP = 1631, --//用户使用道具
MSG_ID_CS_USER_HEART_RATIO_FOR_LOTTERY = 1641,--//幸运转盘爱心消耗比率消息
MSG_ID_CS_USER_QUERY_DONATE_PROP_RECORD_PINPAI=1644,----品牌电玩, 用户查询道具赠送记录
MSG_ID_CS_QUERY_EMAIL_LIST_COMMERCE = 2122, --//商务电玩客户端指定查询条件查询邮逮列表
MSG_ID_CS_QUERY_QUERY_POPUP_NOTIFICATION_LIST_CLENT = 2123, --//商务电玩客户端查询弹出式公告列表
MSG_ID_CS_PAYMENT_CROSS_TRANSFER_MONEY = 1827, --//两个玩家帐户交叉转帐
MSG_ID_CS_PAYMENT_QUERY_AIXIN_RATIO = 1828, --//查询爱心比率

MSG_ID_CS_SVR_BROADCAST_GET_LOTTERY_LIST = 2131;    -- 客户端获取彩金列表

MSG_ID_CS_SVR_BROADCAST_LOTTERY = 2129, ----游戏服务器发布中彩金公告

MSG_ID_CS_USER_REVOKE_DONATE_PROP = 1650, -- 用户撤销转赠道具

MSG_ID_CS_QUERY_TRANSFER_MONEY_RECORD         = 1834, --查询转帐记录
MSG_ID_CS_QUERY_TRANSFER_SUMMARY              = 1835, --查询转帐汇总

MSG_ID_CS_MGR_GAME_END = 2025,

MSG_ID_CS_LOGIN_BROAD_TRANSER = 3501,   --登录广告服务器


MSG_ID_CS_NOTIFY_RED_PACKET_GIFT              = 1841, --后台给客户端赠送彩金红包(还可以扩充其它类型的赠送), 服务器通知客户端
MSG_ID_CS_QUERY_RED_PACKET_GIFT               = 1842, --客户端查询未领取的彩金红包
MSG_ID_CS_DRAW_RED_PACKET_GIFT                = 1843, --客户端领取彩金红包

MSG_ID_CS_PAYMENT_QUERY_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PROGRESS = 1846,  --查询每日首充打码赠送活动进度

MSG_ID_CS_PAYMENT_DRAW_DAY_FIRST_RECHARGE_DA_MA_SEND_ACTIVITY_PRIZE = 1847,    ---领取每日首充打码赠送奖励

MSG_ID_CS_QUERY_DOMAIN_CFG_BY_VIP = 1138,                                       ---根据玩家的VIP等级查询域名配置

MSG_ID_CS_QUERY_TASK_GENERAL_TYPE_LIST       = 2801, --查询任务大类型列表
MSG_ID_CS_QUERY_TASK_LIST_BY_GENERAL_TYPE_ID = 2802, --根据任务大类型查询任务列表
MSG_ID_CS_DRAW_ONE_TASK_PRIZE                = 2803, --用户领取任务奖励

MSG_ID_CS_OPERATE_USER_DETAIL_INFO           = 2814, --获取上报用户详细信息

MSG_ID_CS_QUERY_SCORE_RANK              = 2132, --客户端查询爆分榜

MSG_ID_CS_OPERATE_LUCKY_WHEEL = 2810,       ----客户端获取幸运转盘任务
MSG_ID_CS_GET_WIN_COIN_RANK = 2811,       ----客户端获取幸运转盘任务
MSG_ID_CS_GET_ACTIVITY_CONFIG                = 2817, -- 获取通用活动配置 "获取活动名称："WagerBonus"
MSG_ID_CS_ACTIVITY_OPERATE                = 2818,    -- 通用活动交互操作


-- //#########################################################################
-- //游戏消息ID
-- //游戏解析通用消息
MSG_ID_CS_GAME_GET_RoomLevel = 1,          --   //查询房间等级信息
MSG_ID_CS_GAME_LOGIN_ROOMList = 2,         --   //获取房间列表   
MSG_ID_CS_GAME_LOGINOUT_ROOM = 3,          --   //房间返回 
MSG_ID_CS_GAME_GET_DESKLIST = 4,           --   // 查询桌子列表
MSG_ID_CS_GAME_DOWN_DESK = 5,              -- // 进入桌子
MSG_ID_CS_GAME_GET_GAME_INFO = 6,          --   // 请求进入游戏           
MSG_ID_SS_GAME_LOGOUT = 7,                 --   // 退出游戏用
MSG_ID_CS_OTHERPLAYER_ENTERROOM = 8,       --      //其他用户进入游戏
MSG_ID_CS_OTHERPLAYER_LEAVEROOM = 9,       --      //其他用户退出游戏
MSG_ID_CS_CHECK_GAME_STATE = 13,           --  //获取玩家上次玩的游戏状态
MSG_ID_CS_BROCAST_GAME_USER_AGREE_GAME = 15,--//用户同意操作，结果广播给同桌的其他用户
MSG_ID_CS_RUB_TABLE = 16,             --//挫桌
MSG_ID_Dissolve_Card_Room = 17,--//解散房间
MSG_ID_ReFillRoomCard = 19,--//续房卡
MSG_ID_BROCAST_GAME_USER_AGARE_GAME = 20,--//广播用户同意操作
MSG_ID_BROCAST_DISSOLVE_CARD_ROOM = 21,--//广播解散房间
MSG_ID_CS_GAME_CHANGE_DESK_ROOM = 22,  --//换桌消息
MSG_ID_CS_GAME_CHECKOUT_GAME_COIN = 25, --进入游戏中，需要先上分，然后才能玩
MSG_ID_CS_GAME_ACCOUNT_CHANGES_NOTIFY = 14, --游戏中玩家金额变更通知
MSG_ID_CS_GAME_LOGOUT_DESK_4_AUTO_JOIN  = 27,       --自动坐桌，只离开游戏桌子，但不离开游戏房间。用于客户端自主离开桌子，但是游戏场景不消失
MSG_ID_CS_QUERY_GPS = 28,                           --请求玩家Gprs地址

MSG_ID_SS_GAME_BROD_USER_INFO = 29,                 --   // 服务器推送进入游戏玩家头像信息
MSG_ID_CS_GAME_GET_DESKLIST_RSP_EXT     = 30,       --//获取房间桌位信息，玩家列表 分包模式扩展

MSG_ID_CS_GAME_UPDATE_JACKPOT_INFO=1107,--更新奖池消息(S->C)
MSG_ID_CS_SRV_NOT_IN_USE        = 204,      --通知客户端，所请求的服务不可用


-- //###//######################################################################
-- //----------摇钱树游戏：101---------------------------
MSG_ID_CS_GAME_101_GET_RoomLevel = 10101,         --    //查询房间等级信息
MSG_ID_CS_GAME_101_LOGIN_ROOMList = 10102,        --    //获取房间列表   
MSG_ID_CS_GAME_101_LOGINOUT_ROOM = 10103,         --    //房间返回 
MSG_ID_CS_GAME_101_GET_DESKLIST = 10104,          --    // 查询桌子列表
MSG_ID_CS_GAME_101_DOWN_DESK = 10105,             --  // 进入桌子
MSG_ID_CS_GAME_101_GET_GAME_INFO = 10106,         --    // 请求进入游戏           
MSG_ID_SS_GAME_101_LOGOUT = 10107,                --    // 退出游戏用
MSG_ID_CS_OTHERPLAYER_ENTER_ROOM = 10108,         --    //其他用户进入游戏
MSG_ID_CS_OTHERPLAYER_LEAVE_ROOM = 10109,         --    //其他用户退出游戏
MSG_ID_CS_GAME_101_LOGIC_GAME = 10110,            --    // 游戏逻辑用的ID ,跳转游戏解析数据
MSG_ID_CS_GAME_101_CHECK_PLAYER_STATE = 10113,    --     // 获取玩家上次玩的游戏状态
}
--解析模板
-- NetworkDefine.GameSeatState = {
--     {"bStation","Byte",0},   --1、变量名，2、变量类型，3、数组长度（0表示非数组）
--     {"iVersion" ,"Byte",0},
--     {"iVersion2","Byte",0},
--     {"curRound","Byte",0},
--     {"iTotalRound","Byte",0},
--     {"RoundOfThisOne","Byte",0},
--     {"MaxRound","Byte",0},
--     {"UserMoney","Long[]",5},
--     {"byAgree","Byte[]",5},
-- }
NetworkDefine.CGetActivityConfigReq  =
{
    {"uin","UInt32",0},
    {"activeId","Int32",0},
}
--仅仅用做获取服务器相应结果
NetworkDefine.OnlyResult={
    {"m_sResultID","Int16",0},--
}

--心跳
NetworkDefine.CReqHeartBeatGamePara={
    {"m_TimeStamep","Int32",0},--时间戳
}
-- CRspOpenLoginMsgPara
--登陆返回
NetworkDefine.CRspOpenLoginMsgPara={
    {"m_sResultID","Int16",0},---//消息返回结果
    {"m_unUin","Int32",0},--//用户UIN 
    
    {"m_ucSex","Byte",0},--//性别, 1: 男, 0: 女
    {"m_ucImageNo","Byte",0},--//头像编号, 默认为1
    {"m_szSignature","Byte[]",HallDefine.ConstDefine.MAX_SIGNATURE_LENGTH},--/个性签名
    {"m_szNickName","Byte[]",HallDefine.ConstDefine.MAX_NICK_NAME_LENGTH},--/昵称


    {"m_unExperience","Int32",0},--//经验值 
    {"m_unWalletMoney","Int64",0},--//身上钱 【开放卡项目 表示房卡数量】
    {"m_unBankMoney","Int64",0},--//银行钱
    {"m_unYuanbao","Int64",0},--//元宝  钻石
    {"m_unJiangquan","Int32",0},--//奖券 爱心
  
  
    {"m_szAccountName","Byte[]",HallDefine.ConstDefine.E_MAX_NICK_LEN},--/用户设置账号密码后的账号，空代表没有设置账号
    {"m_ucBindFlag","Byte",0},--//绑定微信标志，0 ： 未绑定 1 绑定

    {"m_usGameID","UInt16",0},--//真在玩的游戏ID
    {"m_usRoomID","UInt16",0},--//房间ID
    {"m_usDeskIndex","UInt16",0},--//房间索引
    {"m_usDeskStation","Byte",0},--//座位号



    {"m_unVIPLevel","Int32",0},--//VIP等级   1 1级代理 2 1及代理下面的普通用户 3 二级代理 4 二级代理下面的普通用户 5 三级代理 6 三级代理下面的普通用户  7 平台普通用户
    {"m_unUserType","Int32",0},--///用户类型  1 审核中 0 不在审核中
    {"m_ucCertificateCellPhone","Byte",0},--//是否已经认证手机号码
    {"m_ucCertificate","Byte",0},--//是否已经认证身份证号
    {"m_usAreaID","UInt16",0},--//运营商ID
    {"m_usAgentID","UInt16",0},--//代理商
    {"m_unTransFlag","Int32",0},--///0: 关闭转帐功能, 1: 开启转帐功能 (房卡总代id）
    {"m_unTransMin","Int32",0},--///每次转帐的最低金额 //兑奖码赠送房卡数量
    {"m_unTransMax","Int32",0},--///每次转帐的最高金额
    {"m_unTransTax","Int32",0},--//转帐抽水额度  【开放卡项目 ，此字段表示自己创建的房间房卡号，如果为0表示没有创建房间】  
    {"m_ucSetBankPasswordFlag","Byte",0},--//是否设置银行密码
    {"m_ucRechargeFlag","Byte",0},--//是否首冲
 

    {"m_szLoginState","Byte[]",HallDefine.ConstDefine.MAX_LOGINSTATE_LENGTH},--//登陆态 
    {"m_Reserve","Int32",0},--//拓展字段
}
NetworkDefine.CReqGetGameLevelMsgPara={
    {"m_uGameID","Int16",0}
}



NetworkDefine.CRspGetGameLevelMsgPara={
     {"m_sResult","Int16",0},---//消息返回结果
     {"m_usGameID","UInt16",0},---//游戏id
     {"m_usLevelCount","UInt16",0},---//游戏房间类型
     {"m_szLevelCnf","NetworkDefine.LevelStruct",32},--//游戏房间类型
}

NetworkDefine.CReqFriendListMsgPara={
    {"m_unUIN","Int32",0},---//消息返回结果
    {"m_usIndex","Int16",0},---//好友序号，本次请求的好友索引, 从1开始
    {"m_usCount","Int16",0},---//本次请求的好友数量
}

NetworkDefine.LevelStruct = {
    {"m_nLevelID","Int32",0},--//等级ID
    {"m_unMinMoney","Int64",0},--//最少带入金额
    {"m_unMaxMoney","Int64",0},--//最大带入金额
    {"m_unStartCoins","Int64",0},--//体验场带入金币
    {"m_nFlag","Int32",0},--//标志，是体验场还是普通场 1是体验场 0是普通场
    {"m_szName","Byte[]",32},--//可以存储第三方的openid，或者存储用户名;//等级名称
}

NetworkDefine.CReqQueryRechargeListPara={
    {"m_unUIN","Int32",0}, 
    {"m_usAgentId","UInt16",0},
    {"m_ucDataType","Byte",0},
    {"m_ucMoneyType","Byte",0},
    {"m_usReqUserCount","Int16",0},
}

--赢钱榜
NetworkDefine.CReqQueryWinRankListPara = {
    {"m_unUIN","Int32",0},                      --用户id
}





NetworkDefine.T_RoomCnf={
    {"m_nRoomID","Int32",0},--//房间ID
    {"m_nRoomType","Int32",0},--//房间类型
    {"m_nLevel","Int32",0},--//房间等级
    {"m_nDeskCount","Int32",0},--//房间桌子数量
    {"m_nSiteNum","Int32",0},--//每个桌子的位置数
    {"m_nMaxPeople","Int32",0},--//最大人数
    {"m_nBasePoint","Int32",0},--//倍率
    {"m_nLessPoint","Int32",0},--//底分
    {"m_nMoneyPoint","Int32",0},--//底分
    {"m_nTax","Int32",0},--//底分
    {"m_szName","Byte[]",32},--//可以存储第三方的openid，或者存储用户名;//等级名称
}

-- 商城商品数据请求
NetworkDefine.DataRequestShopData={
    {"m_userID", "Int32", 0}--用户ID
}

-- 商城商品数据返回
NetworkDefine.DataParseShopData={
    {"m_sResult", "Int16", 0},--返回结果
    {"m_unCommodityCount", "Int32", 0},--返回的商城中商品个数
    {"m_CommodityInfo", "NetworkDefine.T_CommodityInfo", 128},--返回东西
}


--请求排行榜数据
NetworkDefine.DataReqQueryRankList = {
    {"m_unUIN","Int32",0}, --请求用户的UIN
    {"m_usAgentId","UInt16",0}, --代理ID
    {"m_ucDataType","Byte",0}, --数据类型, 0: 配置的数据, 1: 统计的数据
    {"m_ucMoneyType","Byte",0}, --钱类型, 0: 银行钱, 1: 元宝, 2: 金币
    {"m_usReqUserCount","Int16",0}, --请求排行榜人数, 最多不超过MAX_RICH_RANKING_LIST_NUM = 50人
}



--请求邮件列表
NetworkDefine.DataRequestGlodEmail = {
    {"m_unUIN","Int32",0}, ----用户自己的ID
    {"m_usAreaId","UInt16",0}, --运营商id
    {"m_ucEmailType","Byte",0}, --请求的邮件类型, 见user_req_email_type_e
    {"m_usDayRange","UInt16",0}, --请求的时间范围, 从当前往前推多少天, 默认15天
    {"m_usThisReqStartIndex","UInt16",0}, --考虑在有很多邮件的情况下, 本次请求的邮件索引, 比如第1次startindex = 1, count = 100, 第2次startindex = 101, count = 100
    {"m_usThisReqCount","Int16",0}, --本次请求的邮件个数
}


-- 钻石购买金币
NetworkDefine.ReqDiamondBuyGold={
    {"m_userID", "Int32", 0},--用户ID
    {"m_unCommodityID", "Int32", 0},--商品ID
    {"m_unCommodityAmount", "Int32", 0},--商品数量
}

-- 钻石购买金币数据返回
NetworkDefine.RspUSERBUYCOMMODITY={
    {"m_sResult", "Int16", 0},--结果情况     0：成功   <0：失败
}

NetworkDefine.RspMailNote = {
    {"m_unUIN","Int32",0},
    {"m_unEmailId","Int32",0},
}


--主动请求用户数据协议
NetworkDefine.CReqGetUserMoneyDataMsgPara={
    {"m_iSize", "UInt32", 0},--size
    {"m_unUin", "UInt32", 0},--用户ID
}

--用户数据变更服务器自动推送
NetworkDefine.CRspReFlushMoneyMsgPara={
    {"m_iSize", "UInt32", 0},--size
    {"m_sResult", "Int16", 0},--结果情况     0：成功   <0：失败
    {"m_unUin", "UInt32", 0},--用户ID
    {"m_i64BankBalance", "Int64", 0},--银行账户余额
    {"m_i64TreasureBalance", "Int64", 0},--钻石余额
    {"m_i64CoinBalance", "Int64", 0},--金币余额
    {"m_i64LuckyBomb", "Int64", 0},--道具炸弹余额
    {"m_i64Card", "Int64", 0},--房卡
    {"m_i64WinMatches", "Int64", 0},--累积赢局
    {"m_i64WinPoints", "Int64", 0},--累积赢分
    {"m_i64LossPoints", "Int64", 0},--爱心数
}

--请求用户好友列表
NetworkDefine.DataRequestFriendsList = {
    {"m_unUIN","Int32",0},      -- 用户id
    {"m_usIndex","Int16",0},       --好友序号，本次请求的好友索引, 从1开始
    {"m_usCount","Int16",0},    --本次请求的好友数量
}

--用户修改银行密码
NetworkDefine.CReqSetPasswordMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_iUin", "Int32", 0},--用户Uin 
    {"m_sDstAccountType", "Int16", 0},--账户类型：0支付,1是银行
    {"m_iTime", "Int32", 0},--加密时间
    {"m_szOldPassword", "Byte[]", 32},--旧密码
    {"m_szNewPassword", "Byte[]", 32},--新密码
}

--用户修改银行密码结果返回
NetworkDefine.CRspSetPasswordMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_sResult", "Int16", 0},--结果情况 
    {"m_iUin", "Int32", 0},--用户Uin
}


--用户请求验证银行密码
NetworkDefine.ReqVerifyBankPassword={
    {"m_iUin", "Int32", 0},--用户Uin 
    {"m_iTime", "Int32", 0},--加密时间
    {"m_szPassword", "Byte[]", 32},--密码
}


--用户请求验证银行密码返回
NetworkDefine.RspVerifyBankPassword={
    {"m_sResult", "Int16", 0},--结果情况 
}

NetworkDefine.CNotifyGetLotteryListReqPara=
{
    {"time", "Byte", 0},--结果情况 
}


----------------------进入游戏相关----------------------
--创建房间
NetworkDefine.CReqCreateGameCard2={
    {"m_usMsgLen", "Int16", 0},--size
    {"m_stCardInfo", "NetworkDefine.T_CARD_GAME_INFO", 0},--size
}
--创建房间返回
NetworkDefine.CRspCreateGameCard={
    {"m_usMsgLen", "Int16", 0},--size
    {"m_sResultID", "Int16", 0},--size
    {"m_unCardID", "Int32", 0},--size
    {"m_usRoomID", "Int16", 0},--size房间id
    {"m_usOptID", "Int16", 0},--size预留
}
--发送查询房卡
NetworkDefine.CReqGetGameCard={
    {"m_usMsgLen", "Int16", 0},--size
    {"m_unUin", "Int32", 0},--size
    {"m_unCardID", "Int32", 0},--size房卡id
}

--查询房卡返回
NetworkDefine.CRspGetGameCard = {
    {"m_usMsgLen", "Int16", 0},--size
    {"m_sResultID", "Int16", 0},--size
    {"m_unUin", "Int32", 0},--size
    {"m_unCardID", "Int32", 0},--size//房卡id
    {"m_unScore", "Int64", 0},--size//房卡id
    {"m_stCardInfo", "NetworkDefine.T_CARD_GAME_INFO", 0},--size//房卡id
    {"m_unType", "Byte", 0},--房间类型 0 普通房间 1 公会房间
}

--CReqEnterGameMsgPara
NetworkDefine.CReqEnterGameMsgPara={
    {"m_unUin", "Int32", 0},--size用户Uin
    {"m_usGameID", "UInt16", 0},--size游戏ID
    {"m_usRoomID", "UInt16", 0},--size房间ID
    {"m_usDeskIndex", "UInt16", 0},--size桌子索引
    {"m_bDeskStation", "UInt16", 0},--座位号 
    {"m_iMoney", "Int64", 0},--身上的金币数量 
    {"m_bFlag", "Int32", 0},--预留 
    {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--/昵称 
    {"m_usSex", "UInt16", 0},--性别 
}

NetworkDefine.CRspEnterGameMsgPara={
    {"m_sResult", "Int16", 0},--size结果返回
    {"m_sFlag", "UInt16", 0},--size该桌子的规则，比如该房间禁言，不可使用道具等等。默认0
    {"m_unUin", "UInt32", 0},--size
    {"m_usGameID", "UInt16", 0},--size//房卡id
    {"m_usRoomID", "UInt16", 0},--size//房卡id
    {"m_usDeskIndex", "UInt16", 0},--size//桌子索引
    {"m_usDeskStation", "UInt16", 0},--座位号
}
--用户存钱协议
NetworkDefine.CReqSaveMoneyToBankMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_iUin", "Int32", 0},--用户Uin 
    {"m_sSourceAccountType", "Int16", 0},--目标账户类型： 1元宝，2游戏币
    {"m_bCount", "Int64", 0},--数额
    {"m_iTime", "Int32", 0},--时间加密
    {"m_szPassword", "Byte[]", 32},--存钱密码
}

--获取桌子信息
NetworkDefine.CReqGetRoomPlayerListMsgPara={
    {"RoomID","UInt16",0}, --房间ID
    {"DeskIndex","UInt16",0},--游戏房间索引
    {"DeskCount","Byte",0},--查询桌子数量     
}

NetworkDefine.CRspGetRoomPlayerListMsgPara={
    {"m_sResult","Int16",0}, --
    {"m_sRoomID","UInt16",0},--房间ID
    {"m_uDeskIndex","UInt16",0},--查询桌子数量     
    {"m_bDeskCount","Byte",0},--桌子数量        
    {"m_DeskUserInfo","NetworkDefine.DeskUserInfo",256},--桌子数量        
}

--请求房间列表
NetworkDefine.CReqGetRoomListMsgPara={
    {"m_usGameID","UInt16",0}, --游戏id
    {"m_usRoomIndex","UInt16",0},--游戏房间索引
    {"m_usRoomCount","UInt16",0},--查询游戏房间数量
}

--请求房间列表返回
NetworkDefine.CRspGetRoomListMsgPara={
    {"m_sResult","Int16",0}, --返回结果
    {"m_usGameID","UInt16",0},--游戏id
    {"m_usRoomIndex","UInt16",0},--房间开始索引
    {"m_usRoomCount","UInt16",0},--房间个数
    {"m_szRoomCnf","NetworkDefine.T_RoomCnf",256},--
}
---------------------------------------------------------------------
--用户存钱返回
NetworkDefine.CRspSaveMoneyToBankMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_sResult", "Int16", 0},--结果返回
    {"m_iUin", "Int32", 0},--用户Uin
    {"m_i64BankBalance", "Int64", 0},--银行余额
    {"m_i64TreasureBalance", "Int64", 0},--元宝余额
    {"m_i64CoinBalance", "Int64", 0},--游戏币余额
}

--房卡结算汇总
NetworkDefine.CReqGetUserTotalScore={
    {"m_usMsgLen","Int16",0}, --
    {"m_unCardID","Int32",0},--房卡id
    {"m_unCreateTime","Int32",0},--创建时间
    {"m_unReqType","Int32",0},--请求类型
}

--房卡结算汇总返回
NetworkDefine.CRspGetUserTotalScore={
    {"m_usMsgLen","Int16",0}, --
    {"m_sResultID","Int16",0}, --!<响应消息的结果；0：成功；1：一部分成功；-1：全部失败；
    {"m_unCardID","Int32",0},--房卡id
    {"m_unCreateTime","Int32",0},--创建时间
    {"m_unReqType","Int32",0},--请求类型  1 显示汇总结算  2 战绩请求
    {"m_usUsedNum","Int16",0}, --使用过的局数
    {"m_usTotalNum","Int16",0}, --总局数
    {"m_usUserCount","Int16",0}, --用户数
    {"mGameDataList","NetworkDefine.Result_GAME_DATA",0}, --用户信息
}
---------------------------结构--------------------------------
NetworkDefine.Result_GAME_DATA={
    {"unUserID","Int32",0}, --结算玩家id
    {"usPlayedNum","Int16",0},--玩过的局数
    {"n64AfterScore","Int64",0},--结算后积分
    {"n64ChangeScore","Int64",0},--变化积分，输赢
    {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--名称
    {"mDataLen", "Int32", 0},--名称
    {"mGameTypeData", "NetworkDefine.GameTypeData", 0},--名称
}

NetworkDefine.GameTypeData={
    {"mType","Int32",0}, --游戏类型
    {"nNum","Int32",0}, --/数量
}

--好友上下线通知
NetworkDefine.CReqNotifyFriendOffline = {
    {"m_unOfflineFriendUIN","Int32",0},
}

NetworkDefine.T_CARD_GAME_INFO={
    {"unOwnerID", "Int32", 0},           --//房主id
    {"unCreateTime", "Int32", 0},        --//创建时间
    {"unEndTime", "Int32", 0},           --//到期时间
    {"usGameID", "Int16", 0},         -- //服务器游戏id（123） 金币玩法 房卡玩法
    {"usGameNum", "Int16", 0},     --// 已经结算过的次数  （当前游戏局数 - 1）
    {"usNumCount", "Int16", 0},        --//游戏总局数
    {"usCardNum", "Int16", 0},         --//消耗的房卡数
    {"usUserCount", "Int16", 0},       --//人数（最大值）
    {"usGameRoomID", "Int16", 0}, -- //gamedb分配的游戏房间id  金币玩法 房卡玩法
    {"unPlayStyle", "Int32", 0},         --//玩法，按位bitmap
    {"unOpt1", "Int32", 0},              --//选项1，按位
    {"unOpt2", "Int32", 0},              --//选项2，按位bitmap
    {"unOpt3", "Int32", 0},              --//选项3，按位bitmap
    {"unOpt4", "Int32", 0},              --//选项4，按位bitmap
    {"szOpt", "Byte[]", HallDefine.ConstDefine.MAX_OPT_LEN},              --//选项4，按位bitmap
}

NetworkDefine.DissolveRoomUserInfo={
    {"m_unUin", "Int32", 0},           --
    {"m_usAgreeFlag", "Int16", 0},           --
    {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--
}

NetworkDefine.CReqUserAgreeGame={
    {"m_unUin", "Int32", 0},           --用户uin
    {"m_usGameID", "Int16", 0},           --游戏id
    {"m_usType", "Int16", 0},           --统一操作类型  0 无类型   1 开始游戏   2 解散房间
    {"m_usAgreeFlag", "Int16", 0},           --同意标志 1 同意 2 不同意
    {"m_usRoomID", "Int16", 0},           --房间id
    {"m_usDeskIndex", "Int16", 0},           --桌子索引
    {"m_usDeskStation", "Int16", 0},           --座位号
}

NetworkDefine.CRspUserAgreeGame={
    {"m_sResultID", "Int16", 0},           --<响应消息的结果；0：成功
    {"m_unUin", "Int32", 0},           --用户uin
    {"m_usGameID", "Int16", 0},           --游戏id
    {"m_usType", "Int16", 0},           --统一操作类型  0 无类型   1 开始游戏   2 解散房间
    {"m_usAgreeFlag", "Int16", 0},           --同意标志 1 同意 2 不同意
    {"m_usRoomID", "Int16", 0},           --房间id
    {"m_usDeskIndex", "Int16", 0},           --桌子索引
    {"m_usDeskStation", "Int16", 0},           --座位号
}

--用户银行取钱协议
NetworkDefine.CReqGetMoneyToBankMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_iUin", "Int32", 0},--用户Uin
    {"m_sDstAccountType", "Int16", 0},--账户类型：0银行，1元宝，2游戏币
    {"m_bCount", "Int64", 0},--金额
    {"m_iTime", "Int32", 0},--加密时间m_szNicmName
    {"m_szPassword", "Byte[]", 32},--取钱密码
}

--用户银行取钱回调
NetworkDefine.CRspGetMoneyToBankMsgPara={
    {"m_iSize", "Int32", 0},--size
    {"m_sResult", "Int16", 0},--结果返回
    {"m_iUin", "Int32", 0},--用户Uin
    {"m_i64BankBalance", "Int64", 0},--银行余额
    {"m_i64TreasureBalance", "Int64", 0},--元宝余额
    {"m_i64CoinBalance", "Int64", 0},--游戏币余额
}


--查询爱心比率协议
NetworkDefine.CReqQueryAiXinRatioMsgPara={
    {"m_unUIN", "Int32", 0},--用户Uin
    {"m_sType", "Int16", 0},--查询类型 1、查询送爱心比率 2、查询爱心转盘比率
}

--爱心比率查询回调
NetworkDefine.CRspQueryAiXinRatioMsgPara={
    {"m_sResult", "Int16", 0},--结果返回
    {"m_unRatio", "Int64", 0},--反馈的爱心比率
    {"m_sType", "Int16", 0},--查询类型 1、查询送爱心比率 2、查询爱心转盘比率
}


--发送幸运转盘消息
NetworkDefine.CReqHeartRatioForLotteryMsgPara={
    {"m_unUIN", "Int32", 0},--用户Uin
    {"m_unAiXinNum", "Int32", 0},--消耗的爱心数量
    {"m_unAiXinRation", "Int64", 0},--爱心兑换金币比率
    {"m_iTime", "Int32", 0},--时间
}

--幸运转盘消息回调
NetworkDefine.CRspHeartRatioForLotteryMsgPara={
    {"m_sResult", "Int16", 0},--结果返回
    {"m_unUIN", "Int32", 0},--用户Uin
    {"m_un64CoinNum", "Int64", 0},--身上的金币数
    {"m_unNowAiXinNum", "Int32", 0},--当前的爱心数
    {"m_un64AddCoinNum", "Int64", 0},--中奖金额
}

--请求添加删除好友
NetworkDefine.CReqAddFriendMsgPara = {
     {"m_unSrcUIN", "Int32", 0},
     {"m_unDstUIN", "Int32", 0},
     {"m_unTime", "Int32", 0},
     {"m_ucType", "Byte", 0},  ---好友操作类型， 1: 添加好友, 2: 删除好友
}

-- 相应添加删除好友
NetworkDefine.CRspAddFriendMsgPara = {
     {"m_sResultId", "Int16", 0},
     {"m_unDstUIN", "Int32", 0},
     {"m_ucType", "Byte", 0},  ---好友操作类型， 1: 添加好友, 2: 删除好友
}
--用户献出爱心消息
NetworkDefine.CReqCrossTransferMoneyMsgPara={
    {"m_unUin", "Int32", 0},--用户Uin
    {"m_unDstUin", "Int32", 0},--目标用户ID
    {"m_ucSrcAccountType", "Byte", 0},--源帐户类型
    {"m_ucDstAccountType", "Byte", 0},--目标帐户类型
    {"m_ucTransferReason", "Byte", 0},--转账原因
    {"m_unActionID", "Int32", 0},--动作ID：比如游戏ID，红包流水号ID等等
    {"m_un64SrcCount", "Int64", 0},--这次交易 我消耗了多少金币
    {"m_un64DstCount", "Int64", 0},--这次交易 对方能得到的爱心数 
    {"m_iTime", "Int32", 0},--加密时间
    {"m_szPasswd", "Byte[]", 32},--密码
}
-- 请求转账
NetworkDefine.CReqTransferMoneyToOtherMsgPara={
    {"m_iSize", "Int32", 0},--
    {"m_iUin", "Int32", 0},--用户Uin
    {"m_iDstUin", "Int32", 0},--目标账户
    {"m_iDstAccountType", "Int16", 0},--账户类型：0银行，1元宝，2游戏币 3 辅助帐号类型(幸运炸弹等) 4 房卡 999 总账户类型
    {"m_UseType", "Int16", 0},--转账类型或者转账用途 0 用户主动转账 1 系统个自动触发 2 游戏需要触发 3 发红包需要触发 4 发离线红包 5 赠送炸弹 6 赠送离线炸弹 7 赠送房卡
    {"m_unSequence", "Int32", 0},--消息id或者转账流水序号
    {"m_iCount", "Int64", 0},--金额
    {"m_iTime", "Int32", 0},--加密时间(整型)
    {"m_szPassword", "Byte[]", HallDefine.ConstDefine.MAX_MD5_ARRAY_LENGTH},--加密时间(整型)
}

--转账成功返回
NetworkDefine.CRspTransferMoneyToOtherMsgPara={
    {"m_iSize", "Int32", 0},--
    {"m_sResult", "Int16", 0},--
    {"m_iUin", "Int32", 0},--用户Uin
    {"m_iDstUin", "Int32", 0},--目标账户
    {"m_UseType", "Int16", 0},--转账类型或者转账用途 0 用户主动转账 1 系统个自动触发 2 游戏需要触发 3 发红包需要触发  7 赠送房卡
    {"m_unSequence", "Int32", 0},--消息id或者转账流水序号
    {"m_i64BankBalance", "Int64", 0},--银行账户余额
    {"m_i64TreasureBalance", "Int64", 0},--元宝
    {"m_i64CoinBalance", "Int64", 0},--钱包
}

NetworkDefine.CReqFuzzyQueryUserInfo = {
    {"m_unQueryType", "Int32", 0}, --模糊查询类型
    {"m_szQueryCondition", "Byte[]", 64}, --模拟查询条件
    {"m_unPageIndex", "Int32", 0}, ---第几页, 从第1页开始
    {"m_unPageSize", "Int32", 0}, --页大小
}

--献出爱心消息回调
NetworkDefine.CRspCrossTransferMoneyMsgPara={
    {"m_sResultId", "Int16", 0},--结果返回
    {"m_unUin", "Int32", 0},--用户Uin
    {"m_unDstUin", "Int32", 0},--目标用户ID
    {"m_ucSrcAccountType", "Byte", 0},--源帐户类型
    {"m_ucDstAccountType", "Byte", 0},--目标帐户类型
    {"m_ucTransferReason", "Byte", 0},--转账原因
    {"m_un64BankBalance", "Int64", 0},--银行账号余额
    {"m_un64TreasureBalance", "Int64", 0},--元宝账号余额 
    {"m_un64CoinBalance", "Int64", 0},--游戏币账号余额
    {"m_un64AuxiliaryBalance", "Int64", 0},--辅助帐号(幸运炸弹)
    {"m_un64Card", "Int64", 0},--房卡
    {"m_un64WinMatches", "Int64", 0},--累积赢局
    {"m_un64WinPoints", "Int64", 0},--累积赢分
    {"m_un64LossPoints", "Int64", 0},--累积输分(2SSSSS的爱心) 
}



NetworkDefine.T_CommodityInfo={
    {"m_unID","UInt32",0},--商品ID
    {"m_unType","UInt32",0},--商品类型, 0: 金币, 1: 钻石 2: 道具
    {"m_unBuyNeedMoneyType","UInt32",0},--购买该商品所需的金钱类型, 1: 钻石, 2: 金币, 与二代货币类型保持一致
    {"m_unBuyNeedMoneyAmount","UInt32",0},--购买该商品所需的金钱的数量
    {"m_ucFirstRechargeMultiple","Byte",0},--该商品首充双倍, 0: 不是首充双倍, 1: 首充双倍
    {"m_ucIsRecommend","Byte",0},--是否推荐0: 不是推荐, 1: 推荐
    {"m_ucIsNew","Byte",0},--是否新品, 0: 不是新品, 1: 是新品
    {"m_ucIsHot","Byte",0},--是否热卖, 0: 不是热卖, 1: 是热卖
    {"m_unPropID","UInt32",0},--当商品类型为道具时, 表示道具ID; 当商品类型为金币或钻石时, 填0
    {"m_unCount","UInt32",0},--金币或者钻石或者道具的数量
}

NetworkDefine.DeskUserInfo={
    {"m_sDeskNo","UInt16",0},--
    {"m_bMaxUser","UInt16",0},--
    {"m_szPassword","Byte[]",64},--
    {"m_bUserCount","Byte",0},--
    {"m_szUserInfoStruct","NetworkDefine.UserInfoStruct",255},--
}

NetworkDefine.UserInfoStruct={
    {"m_bDeskStation","Byte",0},--
    {"m_iUserID","Int32",0},--
    {"m_iMoney","Int64",0},--
    {"m_iVipLevel","Int32",0},--
    {"m_szNickName","Byte[]",64},--
    {"m_szImageAddr","Byte[]",128},--
    {"m_sSex","UInt16",0},--
}

NetworkDefine.CReqMakeSureFriend = {
    {"m_unRequestUIN","Int32",0},--请求者的UID
    {"m_unResponseUIN","Int32",0},--回应者的UID
     {"m_ucReply","Byte",0},--是否答应被添加好友, 1: 答应, 0: 拒绝,
}

NetworkDefine.CRspMakeSureFriend = {
    {"m_ReqUserInfo","NetworkDefine.TUserInfo",0},--请求者的UID
}

NetworkDefine.CRspNotifyMakeFriendResult={
    {"m_sResultId","Int16",0},--添加好友结果
    {"m_ucYourRole","Byte",0},--在添加好友操作中, 你的角色, 1: 你是主动发起方, 2: 你是被添加方, 见friend_role_type_e
    {"m_stOppositeUserInfo","NetworkDefine.TUserInfo",0},--对方的信息
}

--申请解散房间
NetworkDefine.CReqDelGameCard={
    {"m_usMsgLen","Int16",0},--
    {"m_usOwnerID","Int32",0},--ID
    {"m_usCardID","Int32",0},--房卡ID
    {"m_usTime","Int32",0},--计时描述
}
--广播通知其他玩家申请解散房间
NetworkDefine.CRequserDissolveGameBrocard={
    {"m_usResultID","Int16",0},--结果
    {"m_unOprUIn","Int32",0},--申请者id    
    {"m_unCardID","Int32",0},--房间id    
    {"m_unSeconds","Int32",0},--时间  
    {"m_usNumber","Int16",0},--/数量 
    {"m_szDissolveUserInfo","NetworkDefine.DissolveRoomUserInfo",0},--/数量 
}














NetworkDefine.CRspLogoutGamePlatformPara={
    {"m_unTime", "UInt32", 0},--消息时间戳
    {"m_unResult", "Int32", 0},--返回消息ID 
}

-- 用户信息反馈回调
NetworkDefine.CRspUserFeedbackPara={
    {"m_sResultId", "Int16", 0},--结果返回
    
}


-- 服务器广播公告(走马灯)
NetworkDefine.CNotifyNotificationMsg={
    {"m_NotificationInfo","NetworkDefine.TNotificationInfo",0} --公告内容
}

NetworkDefine.TNotificationInfo={
    {"m_unId", "Int32", 0},--公告ID
    {"m_unTime", "Int32", 0},--公告发布时间
    {"m_ucType", "Byte", 0},--公告类型
    {"m_usLength", "Int16", 0},--公告长度
    {"m_szContent", "Int16", 0},--公告内容
}


--请求公告面板信息
NetworkDefine.CReqNotificationListMsgPara={
    {"m_unUIN", "Int32", 0},--用户id
    {"m_usAreaId", "UInt16", 0},--运营商id
    {"m_unAgentId", "UInt16", 0},--代理ID
    {"m_usThisReqStartIndex", "Int16", 0},--考虑在有很多公告的情况下, 本次请求的公告索引, 比如第1次startindex = 1, count = 100, 第2次startindex = 101, count = 100
    {"m_usThisReqCount", "Int16", 0},--本次请求的公告个数（一次10条）
}

--其他玩家进入游戏返回
NetworkDefine.CRspOtherPlayerEnterRoom={
     {"m_unUin", "Int32", 0},--
     {"m_usGameID", "Int16", 0},--
     {"m_usRoomID", "Int16", 0},--房间id
     {"m_usDeskIndex", "Int16", 0},--桌子索引,从0开始
     {"m_usDeskStation", "Int16", 0},--座位号
     {"m_unMoney", "Int64", 0},--身上的钱
     {"m_unFlag", "Int32", 0},--坐下游戏的标志
     {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--坐下游戏的标志
     {"m_usSex", "UInt16", 0},--性别
     {"m_usVIPLevel", "UInt32", 0},--Ip
}

--其他玩家进入游戏返回 --金币场
NetworkDefine.CRspOtherPlayerEnterRoom2={
     {"m_unUin", "Int32", 0},--
     {"m_usGameID", "Int16", 0},--
     {"m_usRoomID", "Int16", 0},--房间id
     {"m_usDeskIndex", "Int16", 0},--桌子索引,从0开始
     {"m_usDeskStation", "Int16", 0},--座位号
     {"m_unMoney", "Int64", 0},--身上的钱
     {"m_unFlag", "Int32", 0},--坐下游戏的标志
     {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--坐下游戏的标志
     {"m_usSex", "UInt16", 0},--性别
     -- {"m_usVIPLevel", "UInt32", 0},--Ip
}

--其他玩家离开游戏返回
NetworkDefine.CRspOtherPlayerLeaveRoom={
     {"m_unUin", "Int32", 0},--
     {"m_usGameID", "UInt16", 0},--
     {"m_usRoomID", "UInt16", 0},--房间id
     {"m_usDeskIndex", "UInt16", 0},--桌子索引,从0开始
     {"m_usDeskStation", "UInt16", 0},--座位号
     {"m_unMoney", "Int64", 0},--身上的钱
     {"m_unFlag", "Int32", 0},--坐下游戏的标志
     {"m_szNickName", "Byte[]", HallDefine.ConstDefine.MAX_NICK_LEN},--坐下游戏的标志
     {"m_usSex", "UInt16", 0},--性别
}

--绑定手机
NetworkDefine.CReqAutoUserSetAccountInfo=
{

    {"m_szLoginName", "Byte[]", HallDefine.ConstDefine.E_MAX_NICK_LEN},--账号
    {"m_szLoginPassword", "Byte[]", HallDefine.ConstDefine.MAX_MD5_ARRAY},--密码
}



NetworkDefine.CRspAutoUserSetAccountInfo={
    {"m_sResultId", "Int16", 0},--结果返回
}

--请求检测是否在游戏中
NetworkDefine.CReqCheckUserPlayingMsgPara={
    {"m_unUin", "Int32", 0},--用户id
    {"m_unGameID", "Int16", 0},--游戏ID
    {"m_unRoomID", "Int16", 0},--房间ID
    {"m_unDeskIndex", "Int16", 0},--桌子索引
    {"m_unDeskStation", "Int16", 0},--座位号
}

NetworkDefine.CRspCheckUserPlayingMsgPara={
    {"m_sResult", "Int16", 0},--返回结果
    {"m_usIsPlaying", "Int16", 0},--正在游戏标准
    {"m_unUin", "Int32", 0},--用户uin
    {"m_unGameID", "Int16", 0},--游戏ID
    {"m_unRoomID", "Int16", 0},--房间ID
    {"m_unDeskIndex", "Int16", 0},--桌子索引
    {"m_usDeskStation", "Int16", 0},--座位号
    {"m_usRoomCardID", "Int32", 0},--房卡id
}

NetworkDefine.CReqCheckPaymentMsgPara={
    {"m_unSize", "Int32", 0},--size
    {"m_unUin", "Int32", 0},--用户uin
    {"m_unOrderID", "Int32", 0},--系统内部订单号ID
    {"m_unAmount", "Int32", 0},--充值面额
}

NetworkDefine.CRspCheckPaymentMsgPara={
    {"m_unSize", "Int32", 0},--size
    {"m_sResult", "Int16", 0},--返回结果
    {"m_unUin", "Int32", 0},--用户uin
    {"m_un64BankBalance", "Int64", 0},--银行账号余额
    {"m_un64TreasureBalance", "Int64", 0},--元宝账号余额
    {"m_un64CoinBalance", "Int64", 0},--游戏币账号余额
}

NetworkDefine.CReqAccountChangesNotifyMsgPara={
    {"m_unUin", "Int32", 0},--用户uin
}

NetworkDefine.TUserInfo={
    {"m_unUIN", "Int32", 0},--用户的UIN
    {"m_unExperience", "Int32", 0},--经验值
    {"m_unWalletMoney", "Int64", 0},--身上钱
    {"m_ucSex", "Byte", 0},--性别, 1: 男, 0: 女
    {"m_ucImageNo", "Byte", 0},--头像编号
    {"m_ucNickLen", "Byte", 0},
    {"m_szNickName", "Byte[]", HallDefine.ConstDefine.E_MAX_NICK_LEN},--昵称
    {"m_ucSignatureLen", "Byte",0},
    {"m_szSignature", "Byte[]",HallDefine.ConstDefine.E_MAX_SIGNATURE_LEN},--个性签名
    {"m_unVIPLevel", "Int32",0},--VIP等级
    {"m_ucCertificateCellPhone", "Byte",0},--是否已经认证手机号码
    {"m_ucCertificate", "Byte",0},--是否已经认证身份证号
    {"m_ucOnlineStatus", "Byte",0},--是否在线, 1: 在线, 0:　离线
}


NetworkDefine.TEveryDayReward={
    {"rewardState", "Int16", 0},--每日登陆奖励是否已领取  0 未领取，1 已领取
    {"m_un64Coin", "Int64", 0},--每日登陆奖励金额
}

NetworkDefine.CUserGetEverydayLogin={
    {"m_unUin", "Int32", 0},--用户的ID
}

NetworkDefine.CUserGetEverydayLoginRsp={
    {"m_sResultId", "Int16", 0},--结果 2 还未送 3 查询失败 4 没开启每日登陆 5 游戏时间已经超过每日登陆奖励时间
    {"m_unToday", "Int32", 0},--当前是第几天
    {"EveryDayRewardList", "NetworkDefine.TEveryDayReward", 7},--当前是第几天
}

NetworkDefine.CReqDailyCJResultMsgPara={
    {"m_unTime", "Int32", 0},--系统时间
}

NetworkDefine.CReqDailyCJMsgPara={
    {"m_unTime", "Int32", 0},--系统时间
}

NetworkDefine.CRspDailyCJMsgPara={
    {"m_sResultId", "Int16", 0},--查询结果错误码, 0: 查询成功, 其它: 查询失败
    {"m_iLotteryResult", "Int32", 0},--用户抽奖结果, 见枚举 LotteryResult
    {"m_iAwardId", "Int32", 0},--用户抽到的奖项ID(如果抽到奖了)
    {"m_iAwardCount", "Int32", 0},--奖项设置个数
    {"m_AwardList", "NetworkDefine.TAwardInfo", "m_iAwardCount"},--奖项设置列表 
}

NetworkDefine.TAwardInfo={
    {"m_iAwardId", "Int32", 0},--奖项ID
    {"m_iAwardType", "Int32", 0},--奖励类型, 1: 游戏币
    {"m_un64Amount", "Int64", 0},--数额
    {"m_szAwardDesc", "Byte[]", 64},--数额
}

NetworkDefine.CRspDailyCJMsgPara11={
    {"m_sResultId", "Int16", 0},--查询结果错误码, 0: 查询成功, 其它: 查询失败
    {"m_iLotteryResult", "Int32", 0},--用户抽奖结果, 见枚举 LotteryResult
    {"m_iAwardId", "Int32", 0},--用户抽到的奖项ID(如果抽到奖了)
    {"m_iAwardCount", "Int32", 0},--奖项设置个数
    {"m_AwardList", 
        {   
            {"m_iAwardId", "Int32", 0},--奖项ID
            {"m_iAwardType", "Int32", 0},--奖励类型, 1: 游戏币
            {"m_un64Amount", "Int64", 0},--数额
            {"m_szAwardDesc", "Byte[]", 64},--数额
        },
        "m_iAwardCount"},--奖项设置列表 
}

NetworkDefine.CRspDailyCJResultMsgPara={
    {"m_sResultId", "Int16", 0},--结果
}

NetworkDefine.CReqUserReportWeChatShareMsgPara={
    {"m_unUIN", "Int32", 0},--自己的id
}

--修改用户密码
NetworkDefine.CReqUserChangeAccountPassword={
    {"m_szLoginName", "Byte[]", HallDefine.ConstDefine.E_MAX_NICK_LEN},--数额
    {"m_szOldLoginPassword", "Byte[]", HallDefine.ConstDefine.MAX_MD5_ARRAY},--
    {"m_szNewLoginPassword", "Byte[]", HallDefine.ConstDefine.MAX_MD5_ARRAY},--
    {"m_unCheckTime", "Int32",0},--时间戳
}

NetworkDefine.CRspUserChangeAccountPassword={
    {"m_sResultId", "Int16", 0},--结果
}
--请求VIP数据
NetworkDefine.CReqDataRequestVip=
{    
    {"m_unUIN","UInt32",0},   --
}
--VIP数据返回
NetworkDefine.CRspDataParseVip=
{
    {"m_sResultId","Int16",0},   --0 成功, 不为0 失败
    {"m_ucRechargeVip","Byte",0},   --充值vip等级
    {"m_unTotalRecharge","Int32",0},   --累计充值额度
    {"m_unRechargeVipConfigNum","Int32",0},   --充值vip等级设置个数
    {"m_unRechargeVipConfig","Int32[]",HallDefine.ConstDefine.VIP_LEVEL_MAX},    --充值vip等级，每一级的充值额度
}

--商店
--购买操作
NetworkDefine.DataRequestBuy=
{
    {"m_unUin","UInt32",0},   --userID
    {"m_unCommodityID","Int32",0},   --商品ID
    {"m_unCommodityAmount","Int32",0},   --商品数量
}
--购买返回
NetworkDefine.DataParseBuy=
{
    {"ResultCode","Int16",0},   --结果情况     0：成功   <0：失败
}

--道具赠送
NetworkDefine.CReqUserDonatePropMsgPara=
{
    {"m_unUIN","UInt32",0},
    {"m_unDstUIN","UInt32",0},
    {"m_unPropID","UInt32",0},
    {"m_un64PropCount","Int64",0},
}

--道具赠送返回
NetworkDefine.CRspUserDonatePropMsgPara=
{
    {"m_sResultId","Int16",0},
}

NetworkDefine.DataRequestItemTemplate=
{
    {"m_unUin","UInt32",0}, --
}

--请求背包数据
NetworkDefine.DataRequestBagData=
{
    {"m_unUin","UInt32",0},   --
}

--赠送弹头 - 记录
NetworkDefine.DataRequestGiveJiLuData=
{
    {"m_unUIN","UInt32",0},
}
--请求使用物品
NetworkDefine.DataRequestItemUse={
    {"m_unUin","UInt32",0},   --userID
    {"m_unPropID","Int32",0},   --道具ID
    {"m_unPropCount","Int32",0},   --道具数量
}
--使用物品返回
NetworkDefine.DataParseItemUse={
    {"ResultCode","Int16",0},   --结果情况     0：成功   <0：失败
    {"ItemId","Int32",0},   --物品ID
    {"ItemCount","Int32",0},   --物品数量
}

NetworkDefine.DataRequestCaiJinHall=
{
    {"m_usGameId","UInt16",0},   --游戏ID
    {"m_usRoomId","UInt16",0},   --房间ID
}


NetworkDefine.CMD_S_CaiJinHall={
    {"m_nGameID","UInt16",0},   --游戏ID
    {"m_nIncreaseFlag","UInt16",0},   --增长标识，0增长，1发放
    {"m_n64JackpotCurMoney","Int64[]",5},   --五个奖池    
}


NetworkDefine.GameJackPotNoty = 
{
    {"m_unUIN","UInt32",0},         --用户id
    {"m_szNickName","Byte[]",64},   --用户昵称
    {"m_usGameId","UInt16",0},        --游戏ID
    {"m_iLotteryType","Int32",0},     --彩金类型
    {"m_un64Profit","Int64",0},       --彩金收益
}

--撤回赠送礼物
NetworkDefine.WithdrawGift = 
{
    {"m_unUIN","Int32",0},       --用户id
    {"m_unID","Int32",0},       --记录id
}
--撤回赠送礼物相应
NetworkDefine.WithdrawGiftResult = 
{
    {"m_sResultId","Int16",0},  --响应结果
    {"m_unID","Int32",0},
}

--上分结构
NetworkDefine.ReqUserCheckOutGameCoinPara = 
{
    {"m_unUin","Int32",0},                   --用户ID
    {"m_un64CheckoutGameCoin","Int64",0},    --上分金额
    {"m_byCheckFlag","Byte",0},             --存取标志 0 存 1 取
}

--上分结果返回
NetworkDefine.CRspUserCheckOutGameCoinPara = 
{
    {"m_usResultID","Int16",0},
    {"m_unUin","Int32",0},
    {"m_un64CheckoutGameCoin","Int64",0},
    {"m_byCheckFlag","Byte",0},             --存取标志 0 存 1 取
}

NetworkDefine.AccountChangeNotify = 
{
    {"m_unUin","Int32",0},                   --用户ID
}



--礼物系统---------------------------------------------------------



----转账
NetworkDefine.ReqTransferAccounts = 
{
    {"m_unSize","Int32",0},                --写0
    {"m_unID","Int32",0},                 --用户uin
    {"m_unDstUin","Int32",0},              --目标用户uin
    {"m_sAccountType","Int16",0},           --账户类型： 0银行，1元宝，2游戏币, 3辅助帐号(幸运炸弹),   写2
    {"m_sTransferReason","Int16",0},        --转账原因：0用户主动转   写8
    {"m_unActionID","Int32",0},             --动作ID：比如游戏ID，红包流水号ID等等  写 time+1000随机数
    {"m_un64Count","Int64",0},              --数额
    {"m_iTime","Int32",0},                  --加密时间(整型)
    {"m_szPassword","Byte[]", 32},         --存钱密码    使用银行静态加密密码   
}

----转账返回
NetworkDefine.RspTransferAccounts = 
{
    {"m_unSize","Int32",0},
    {"m_sResult","Int16",0},                --返回结果
    {"m_unID","Int32",0},                  --用户uin
    {"m_unDstUin","Int32",0},              --目标用户uin
    {"m_sTransferReason","Int16",0},        --转账原因：0用户主动转   8
    {"m_unActionID","Int32",0},             --动作ID：比如游戏ID，红包流水号ID等等
    {"m_un64BankBalance","Int64",0},        --数银行账号余额
    {"m_un64TreasureBalance","Int64",0},    --元宝账号余额
    {"m_un64CoinBalance","Int64",0},        --游戏币账号余额
    {"m_un64Auxiliary","Int64",0},          --
}





--查询转账记录
NetworkDefine.ReqQueryTransferRecord=
{
    {"m_unID","UInt32",0}, --用户ID
    {"m_ucType","Byte",0},  --查询类型, 0: 查询赠送和接收记录, 1: 只查赠送记录, 2: 只查接收记录
    {"m_unPageIndex","UInt32",0},--分页查询索引, 从1开始
    {"m_unPageSize","UInt32",0},--分页查询一次查询的记录条数
}

--查询转账记录返回记录结构体
NetworkDefine.TTransferRecord=
{
    {"m_unTime","UInt32",0},--赠送或接收的时间
    {"m_ucType","Byte",0},--类型, 1: 赠送, 2: 接收
    {"m_un64Count","Int64",0},--赠送或接收数量
    {"m_unUIN","UInt32",0},--对方的玩家ID
    {"m_szNickName","Byte[]",HallDefine.ConstDefine.E_MAX_NICK_LEN},--对方的昵称
    {"m_unID","UInt32",0},--唯一标识
    {"m_ucSucceed","Byte",0},-- 0失败,1成功,2表示已被撤回
}


--查询转账记录返回
NetworkDefine.RspQueryTransferRecord=
{
    {"m_sResultId","Int16",0},
    {"m_unPageIndex","UInt32",0},
    {"m_unPageSize","UInt32",0},
    {"m_unThisReturnCount","UInt32",0},
    {"m_TransferRecordArray","NetworkDefine.TTransferRecord",HallDefine.ConstDefine.ONE_QUERY_MAX_TRANSFER_RECORD_COUNT},

}


--请求撤销转账
NetworkDefine.ReqCancellationOfTransfer=
{
    {"m_unUIN","UInt32",0}, --用户ID
    {"m_unID","UInt32",0}, --转账标识
}

--请求撤销转账返回
NetworkDefine.RspCancellationOfTransfer=
{
    {"m_sResultId","Int16",0},--错误码 0: 成功, 其它: 出错
    {"m_TransferRecord","NetworkDefine.TTransferRecord",0}, --转账记录消息体
}




--查询转账汇总
NetworkDefine.ReqQueryTransferSummary=
{
    {"m_unID","UInt32",0}, --用户ID
    {"m_unStartTime","UInt32",0},--开始时间
    {"m_unEndTime","UInt32",0},--结束时间
}

--查询转账汇总返回记录结构体
NetworkDefine.TTransferDaySummary=
{
    {"m_szDay","Byte[]",16},--2019-03-19这样的字符串
    {"m_un64TotalSend","Int64",0},--总共送出去多少
    {"m_un64TotalRecv","Int64",0},--总共收到多少
}



--查询转账汇总返回
NetworkDefine.RspQueryTransferSummary=
{
    {"m_sResultId","Int16",0},
    {"m_unReturnCount","UInt32",0},
    {"m_DaySummaryArray","NetworkDefine.TTransferDaySummary",HallDefine.ConstDefine.ONE_QUERY_MAX_TRANSFER_RECORD_COUNT},
}


---登录广播服务器
NetworkDefine.CReqLoginBroadTransferPara = 
{
    {"m_unUin","Int32",0},          --用户id
    {"m_unCheckTime","Int32",0},    --时间戳
    {"m_szSalt","Byte[]",16},
    {"m_szLoginCheckCode","Byte[]",32},
    
    
}
---响应登录广播服务器
NetworkDefine.CRspLoginBroadTransferPara = 
{
    {"m_sResultID","Int16",0},          --用户id
    {"m_unUin","Int32",0},          --用户id
}


--礼物系统------------------------------------------------------------------



---游戏结束状态消息
---m_unType 1 /赢钱 3/BigWin 4/MAGEWIn 5/SupeWin 6/JackPot 7/freeGAme
NetworkDefine.CRspGameEndStatePara = 
{
    {"m_unUIN","Int32",0},              --用户id
    {"m_usGameId","Int16",0},           --游戏ID
    {"m_ullBetsMoney","Int64",0},       --押注的钱
    {"m_ullGetMoney","Int64",0},        --获得的钱
    {"m_unType","Int32",0},             --操作类型
    {"m_unMoney","Int64",0},            --身上的钱
}



--请求离开房间
NetworkDefine.CReqLogoutRoomPara = 
{
    {"m_usGameID", "UInt16", 0},         --游戏ID
    {"m_usRoomID","UInt16",0},          --//房间ID
    {"m_unUin","UInt32",0},            --用户id
}


--请求离开房间返回
NetworkDefine.CRspLogoutRoomPara = 
{
    {"m_sResultID","Int16",0},---//消息返回结果
}




--更新彩金消息(S->C)
NetworkDefine.CRspUpdateJackpot = 
{
    {"nJackpotType","Int32",0},---奖池类型
    {"nIncreaseTime","Int32",0},---增长时间
    {"n64InitJackpotToal","Int64",0},---奖池的初始值
    {"n64IncreaseJackpot","Int64",0},---奖池的增长金币数
}

--服务器通知：服务不可用
NetworkDefine.CNotifyGameSrvNotInUse2App=
{
    {"m_unUin","UInt32",0},          --用户id
    {"m_usGameID","UInt16",0},          --游戏ID
    {"m_usRoomID","UInt16",0},        --房间Id
}



---后台赠送彩金红包给客户端, 服务器通知客户端
NetworkDefine.CMgrSendRedPacketGiftNotify = 
{
    {"m_unId","Int32",0},--本次赠送的记录ID
    {"m_ucGiftType","Byte",0},--赠送的彩金类型(红包彩金, ...等)
    {"m_un64SendCoins","Int64",0},--赠送的游戏币数量
}

---客户端查询未领取的彩金红包
NetworkDefine.CClientQueryNotDrawedRedPacketGiftReq=
{
    {"m_unUIN","Int32",0},--玩家ID
    {"m_ucGiftType","Byte",0},--要查询的彩金类型
}

---客户端查询未领取的彩金红包 回包
NetworkDefine.CClientQueryNotDrawedRedPacketGiftRsp =
{
    {"m_sResultId","Int16",0},--错误码
    {"m_unId","Int32",0},--赠送记录ID(如果返回0, 表示没有该类型的彩金可领取)
    {"m_ucGiftType","Byte",0},--赠送的彩金类型(红包彩金, ...等)
    {"m_un64SendCoins","Int64",0},--赠送的游戏币数量
}

---客户端领取彩金红包
NetworkDefine.CClientDrawRedPacketGiftReq = 
{
    {"m_unUIN","Int32",0},--玩家ID
    {"m_unId","Int32",0},--要领取的赠送的记录ID
}

----客户端领取彩金红包
NetworkDefine.CClientDrawRedPacketGiftRsp =
{
    {"m_sResultId","Int16",0},--错误码
    {"m_unId","Int32",0},     --领取成功的记录ID
    {"m_ucGiftType","Byte",0},     --领取成功的彩金类型
    {"m_un64SendCoins","Int64",0},     --领取成功增加的游戏币
    {"m_un64BankBalance","Int64",0},     --银行账号余额
    {"m_un64TreasureBalance","Int64",0},     --元宝账号余额
    {"m_un64CoinBalance","Int64",0},     --游戏币账号余额
    {"m_un64Auxiliary","Int64",0},     --辅助帐号(幸运炸弹)
    {"m_un64Card","Int64",0},     --房卡
    {"m_un64WinMatches","Int64",0},     --累积赢局数
    {"m_un64WinPoints","Int64",0},     --累积赢分数
    {"m_un64LossPoints","Int64",0},     --累积输分数

    {"m_iMsgLen","Int32",0},     --长度
    {"m_szMsgBuff","Byte[]","m_iMsgLen"},     --长度

}


NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeReq = 
{
    {"m_unUIN","Int32",0},     --用户ID
}

NetworkDefine.CQueryDayFirstRechargeDaMaSendActivityProgressRsp = 
{
    {"m_sResultId","Int16",0},     --返回状态
    {"m_ucStatus","Byte",0},     --当前参与活动的状态
    {"m_unFirstRechargeAmount","Int32",0},     --首充金额
    {"m_un64Grade1NeedDaMa","Int64",0},     --第一等级需要打码量
    {"m_un64Grade1SendCount","Int64",0},     --第一等级赠送游戏币数量
    {"m_un64Grade2NeedDaMa","Int64",0},     --第二等级需要打码量
    {"m_un64Grade2SendCount","Int64",0},     --第二等级赠送游戏币数量
    {"m_un64Grade3NeedDaMa","Int64",0},     --第三等级需要打码量
    {"m_un64Grade3SendCount","Int64",0},     --第三等级赠送游戏币数量
    {"m_un64CurrentDaMa","Int64",0},     --本次首充活动的累积打码量
    
}
NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeRsp = 
{
    {"m_sResultId","Int16",0},     --返回状态
    {"m_un64PrizeCount","Int64",0},     --领取的游戏币数量
    {"m_un64Bank","Int64",0},     --领取后银行钱
    {"m_un64Coin","Int64",0},     --领取后身上钱
}

NetworkDefine.CQueryDomainCfgByVipReq=
{
    {"m_unUIN","Int32",0},     --返回状态
    {"m_unNewFlag","Int32",0},     --返回状态
}

NetworkDefine.CQueryDomainCfgByVipRsp=
{
    {"m_sResultId","Int16",0},            --返回状态
    {"m_iUseShieldFlag","Int32",0},     --是否使用游戏盾, 0: 不使用, 1: 使用游戏盾
    {"m_szDomain4Web","Byte[]",1024},     --web域名
    {"m_szDomain4Download","Byte[]",1024},     --下载域名
    {"m_szDomain4Activity","Byte[]",1024},     --活动图域名
    {"m_szDomain4Broadcast","Byte[]",1024},     --广播服域名
    {"m_szDomain4Login","Byte[]",1024},     --广播服域名
}


----请求任务大类型
NetworkDefine.CReqTaskGeneralType =
{
    {"m_unUIN","Int32",0},--用户ID
}
--查询指定任务大类型下面的任务列表
NetworkDefine.CReqTaskList =
{
    {"m_unUIN","Int32",0},--用户ID
    {"m_ucGeneralTypeID","Byte",0},--用户ID
}
---领取任务
NetworkDefine.CReqDrawTaskPrize =
{
    {"m_unUIN","Int32",0},--用户ID
    {"m_ucGeneralTypeID","Byte",0},--用户ID
    {"m_unId","Int32",0},--用户ID
}


NetworkDefine.CQueryScoreRankReq =
{
    {"m_unUIN","Int32",0},--用户ID
    {"m_usReqCount","Int16",0},--请求条数
}


NetworkDefine.CRespBrodGameUserInfo = 
{
    {"m_unUIN","Int32",0},--用户ID
    {"m_byUserImgID","Byte",0},--头像
    {"m_byRobotFlag","Byte",0},--机器人标识
    {"m_byExtern1","Byte",0},--拓展字段
    {"m_byExtern2","Byte",0},--拓展字段
    {"m_byExtern3","Byte",0},--拓展字段
    {"m_byExtern4","Byte",0},--拓展字段
    {"m_byExtern5","Byte",0},--拓展字段
    {"m_byExtern6","Byte",0},--拓展字段
    {"m_byExtern7","Byte",0},--拓展字段
    {"m_byExtern8","Byte",0},--拓展字段
}

--修改账号密码
NetworkDefine.CUserChangeAccountPasswdReq  =
{
    {"m_szLoginName","Byte[]",64},--账号名称
    {"m_szOldLoginPasswd","Byte[]",32},--旧密码, 经过MD5加密
    {"m_szNewLoginPasswd","Byte[]",32},--设置的新的帐户密码, 经过MD5加密
    {"m_unCheckTime","UInt32",0},--动态密码校验时间戳
}

--修改账号密码返回
NetworkDefine.CUserChangeAccountPasswdSvrRsp   =
{
    {"m_sResultId","Int16",0},--返回设置结果错误码
}

------- 查询转盘任务
NetworkDefine.COperLuckyWheelTaskReq  =
{
    {"m_unUIN","Int32",0},
    {"m_ucOperType","Byte",0}, --操作类型 0 查询转盘信息 1=转动转盘获取幸运奖项
}

NetworkDefine.CGetUserWinCoinRankReq  =
{
    {"m_unUIN","Int32",0},
    {"m_ucOperType","Byte",0}, --操作类型 0=当日排行榜 ，1=本周排行榜
}

----------------------------------------------------------------
NetworkDefine.All={
    {"NetworkDefine.CGetUserWinCoinRankReq",NetworkDefine.CGetUserWinCoinRankReq},

    {"NetworkDefine.COperLuckyWheelTaskReq",NetworkDefine.COperLuckyWheelTaskReq},

    {"NetworkDefine.CUserChangeAccountPasswdReq",NetworkDefine.CUserChangeAccountPasswdReq},
    {"NetworkDefine.CUserChangeAccountPasswdSvrRsp",NetworkDefine.CUserChangeAccountPasswdSvrRsp},

    {"NetworkDefine.CQueryDomainCfgByVipRsp",NetworkDefine.CQueryDomainCfgByVipRsp},
    {"NetworkDefine.CQueryDomainCfgByVipReq",NetworkDefine.CQueryDomainCfgByVipReq},

    {"NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeReq",NetworkDefine.CDrawDayFirstRechargeDaMaSendActivityPrizeReq},
    {"NetworkDefine.CQueryDayFirstRechargeDaMaSendActivityProgressRsp",NetworkDefine.CQueryDayFirstRechargeDaMaSendActivityProgressRsp},

    {"NetworkDefine.CMgrSendRedPacketGiftNotify",NetworkDefine.CMgrSendRedPacketGiftNotify},
    {"NetworkDefine.CClientQueryNotDrawedRedPacketGiftReq",NetworkDefine.CClientQueryNotDrawedRedPacketGiftReq},
    {"NetworkDefine.CClientQueryNotDrawedRedPacketGiftRsp",NetworkDefine.CClientQueryNotDrawedRedPacketGiftRsp},
    {"NetworkDefine.CClientDrawRedPacketGiftRsp",NetworkDefine.CClientDrawRedPacketGiftRsp},
    {"NetworkDefine.CClientDrawRedPacketGiftReq",NetworkDefine.CClientDrawRedPacketGiftReq},
    
    {"NetworkDefine.CReqQueryWinRankListPara",NetworkDefine.CReqQueryWinRankListPara},

    {"NetworkDefine.CNotifyGameSrvNotInUse2App",NetworkDefine.CNotifyGameSrvNotInUse2App},
    {"NetworkDefine.CReqLogoutRoomPara",NetworkDefine.CReqLogoutRoomPara},
    {"NetworkDefine.CRspLogoutRoomPara",NetworkDefine.CRspLogoutRoomPara},

    {"NetworkDefine.RspCancellationOfTransfer",NetworkDefine.RspCancellationOfTransfer},
    {"NetworkDefine.ReqCancellationOfTransfer",NetworkDefine.ReqCancellationOfTransfer},
    {"NetworkDefine.ReqQueryTransferRecord",NetworkDefine.ReqQueryTransferRecord},
    {"NetworkDefine.TTransferRecord",NetworkDefine.TTransferRecord},
    {"NetworkDefine.RspQueryTransferRecord",NetworkDefine.RspQueryTransferRecord},

    {"NetworkDefine.ReqTransferAccounts",NetworkDefine.ReqTransferAccounts},
    {"NetworkDefine.TTransferDaySummary",NetworkDefine.TTransferDaySummary},
    {"NetworkDefine.RspTransferAccounts",NetworkDefine.RspTransferAccounts},

    {"NetworkDefine.CReqQueryRechargeListPara",NetworkDefine.CReqQueryRechargeListPara},
    {"NetworkDefine.CReqGetGameLevelMsgPara",NetworkDefine.CReqGetGameLevelMsgPara},
    {"NetworkDefine.CRspGetGameLevelMsgPara",NetworkDefine.CRspGetGameLevelMsgPara},
    {"NetworkDefine.CReqGetRoomListMsgPara",NetworkDefine.CReqGetRoomListMsgPara},
    {"NetworkDefine.CRspOpenLoginMsgPara",NetworkDefine.CRspOpenLoginMsgPara},
    {"NetworkDefine.DataRequestShopData",NetworkDefine.DataRequestShopData},
    {"NetworkDefine.DataParseShopData",NetworkDefine.DataParseShopData},
    {"NetworkDefine.DataReqQueryRankList",NetworkDefine.DataReqQueryRankList},
    {"NetworkDefine.ReqDiamondBuyGold",NetworkDefine.ReqDiamondBuyGold},    
    {"NetworkDefine.RspUSERBUYCOMMODITY",NetworkDefine.RspUSERBUYCOMMODITY},
    {"NetworkDefine.DataQueryGlodEmail",NetworkDefine.DataQueryGlodEmail},
    {"NetworkDefine.RspMailNote",NetworkDefine.RspMailNote},
    {"NetworkDefine.CRspReFlushMoneyMsgPara",NetworkDefine.CRspReFlushMoneyMsgPara},
    {"NetworkDefine.DataRequestFriendsList",NetworkDefine.DataRequestFriendsList},
    {"NetworkDefine.CRspGetGameCard",NetworkDefine.CRspGetGameCard},
    -- {"NetworkDefine.DataQueryGlodEmail",NetworkDefine.DataQueryGlodEmail},NetworkDefine.CRspCreateGameCard
    {"NetworkDefine.CReqCreateGameCard2",NetworkDefine.CReqCreateGameCard2},
    {"NetworkDefine.CRspCreateGameCard",NetworkDefine.CRspCreateGameCard},    --
    {"NetworkDefine.CReqEnterGameMsgPara",NetworkDefine.CReqEnterGameMsgPara}, --选择桌子进入游戏    --
    {"NetworkDefine.CReqSetPasswordMsgPara",NetworkDefine.CReqSetPasswordMsgPara},
    {"NetworkDefine.CRspSetPasswordMsgPara",NetworkDefine.CRspSetPasswordMsgPara},    --
    {"NetworkDefine.ReqVerifyBankPassword",NetworkDefine.ReqVerifyBankPassword},
    {"NetworkDefine.RspVerifyBankPassword",NetworkDefine.RspVerifyBankPassword},    --
    {"NetworkDefine.CRspEnterGameMsgPara",NetworkDefine.CRspEnterGameMsgPara},
    {"NetworkDefine.CReqGetRoomPlayerListMsgPara",NetworkDefine.CReqGetRoomPlayerListMsgPara},
    -- {"NetworkDefine.CRspGetRoomPlayerListMsgPara",NetworkDefine.CRspGetRoomPlayerListMsgPara},
    {"NetworkDefine.CReqSaveMoneyToBankMsgPara",NetworkDefine.CReqSaveMoneyToBankMsgPara},
    {"NetworkDefine.CRspSaveMoneyToBankMsgPara",NetworkDefine.CRspSaveMoneyToBankMsgPara},
    {"NetworkDefine.CReqNotifyFriendOffline",NetworkDefine.CReqNotifyFriendOffline},
    {"NetworkDefine.CReqGetMoneyToBankMsgPara",NetworkDefine.CReqGetMoneyToBankMsgPara},
    {"NetworkDefine.CRspGetMoneyToBankMsgPara",NetworkDefine.CRspGetMoneyToBankMsgPara},
    {"NetworkDefine.CReqQueryAiXinRatioMsgPara",NetworkDefine.CReqQueryAiXinRatioMsgPara},
    {"NetworkDefine.CRspQueryAiXinRatioMsgPara",NetworkDefine.CRspQueryAiXinRatioMsgPara},
    {"NetworkDefine.CReqHeartRatioForLotteryMsgPara",NetworkDefine.CReqHeartRatioForLotteryMsgPara},
    {"NetworkDefine.CRspHeartRatioForLotteryMsgPara",NetworkDefine.CRspHeartRatioForLotteryMsgPara},
    {"NetworkDefine.CReqAddFriendMsgPara",NetworkDefine.CReqAddFriendMsgPara},
    {"NetworkDefine.CRspAddFriendMsgPara",NetworkDefine.CRspAddFriendMsgPara},
    {"NetworkDefine.CReqFuzzyQueryUserInfo ",NetworkDefine.CReqFuzzyQueryUserInfo},
    {"NetworkDefine.CReqCrossTransferMoneyMsgPara",NetworkDefine.CReqCrossTransferMoneyMsgPara},
    {"NetworkDefine.CRspCrossTransferMoneyMsgPara",NetworkDefine.CRspCrossTransferMoneyMsgPara},
    -- {"NetworkDefine.CReqUpdatePlayerInfoMsgPara",NetworkDefine.CReqUpdatePlayerInfoMsgPara},
    -- {"NetworkDefine.CRspUpdatePlayerInfoMsgPara",NetworkDefine.CRspUpdatePlayerInfoMsgPara},
    -- {"NetworkDefine.CReqUserFeedbackPara",NetworkDefine.CReqUserFeedbackPara},
    {"NetworkDefine.CRspUserFeedbackPara",NetworkDefine.CRspUserFeedbackPara},
    {"NetworkDefine.CNotifyNotificationMsg",NetworkDefine.CNotifyNotificationMsg},
    {"NetworkDefine.CReqNotificationListMsgPara",NetworkDefine.CReqNotificationListMsgPara},
    {"NetworkDefine.CReqAutoUserSetAccountInfo",NetworkDefine.CReqAutoUserSetAccountInfo},
    {"NetworkDefine.CRspAutoUserSetAccountInfo",NetworkDefine.CRspAutoUserSetAccountInfo},
    -- 
    {"NetworkDefine.CRspOtherPlayerEnterRoom",NetworkDefine.CRspOtherPlayerEnterRoom},  --玩家进入
    {"NetworkDefine.CRspOtherPlayerLeaveRoom",NetworkDefine.CRspOtherPlayerLeaveRoom}, --玩家离开
    {"NetworkDefine.CRspOtherPlayerEnterRoom2",NetworkDefine.CRspOtherPlayerEnterRoom2}, --玩家离开

    {"NetworkDefine.CReqDelGameCard",NetworkDefine.CReqDelGameCard}, --申请解散房间
    {"NetworkDefine.CRequserDissolveGameBrocard",NetworkDefine.CRequserDissolveGameBrocard}, --申请解散房间广播
    --
    {"NetworkDefine.CReqGetUserTotalScore",NetworkDefine.CReqGetUserTotalScore}, --申请房卡汇总
    {"NetworkDefine.CRspGetUserTotalScore",NetworkDefine.CRspGetUserTotalScore}, --返回房卡汇总

    {"NetworkDefine.CReqUserAgreeGame",NetworkDefine.CReqUserAgreeGame}, --玩家同意解散房间
    {"NetworkDefine.CRspUserAgreeGame",NetworkDefine.CRspUserAgreeGame}, --玩家同意解散房间

    {"NetworkDefine.CReqHeartBeatGamePara",NetworkDefine.CReqHeartBeatGamePara}, --心跳

    {"NetworkDefine.CReqCheckUserPlayingMsgPara",NetworkDefine.CReqCheckUserPlayingMsgPara}, --请求登陆检测游戏状态
    {"NetworkDefine.CRspCheckUserPlayingMsgPara",NetworkDefine.CRspCheckUserPlayingMsgPara}, --请求登陆检测游戏状态返回

    
    {"NetworkDefine.CReqCheckPaymentMsgPara",NetworkDefine.CReqCheckPaymentMsgPara}, --请求充值验单
    {"NetworkDefine.CReqFriendListMsgPara",NetworkDefine.CReqFriendListMsgPara}, --请求好友列表
    {"NetworkDefine.CRspCheckPaymentMsgPara",NetworkDefine.CRspCheckPaymentMsgPara}, --请求充值验单返回

    {"NetworkDefine.CReqAccountChangesNotifyMsgPara",NetworkDefine.CReqAccountChangesNotifyMsgPara}, --请求充值验单返回 游戏金币变化通知消息

    {"NetworkDefine.CRspTransferMoneyToOtherMsgPara",NetworkDefine.CRspTransferMoneyToOtherMsgPara},--转账返回
    {"NetworkDefine.CReqTransferMoneyToOtherMsgPara",NetworkDefine.CReqTransferMoneyToOtherMsgPara},--申请转账

    {"NetworkDefine.CReqMakeSureFriend",NetworkDefine.CReqMakeSureFriend},
    {"NetworkDefine.CRspMakeSureFriend",NetworkDefine.CRspMakeSureFriend},


    {"NetworkDefine.TEveryDayReward",NetworkDefine.TEveryDayReward},
    {"NetworkDefine.CUserGetEverydayLogin",NetworkDefine.CUserGetEverydayLogin},
    {"NetworkDefine.CUserGetEverydayLoginRsp",NetworkDefine.CUserGetEverydayLoginRsp},

    {"NetworkDefine.CReqDailyCJResultMsgPara",NetworkDefine.CReqDailyCJResultMsgPara},
    {"NetworkDefine.CRspDailyCJResultMsgPara",NetworkDefine.CRspDailyCJResultMsgPara},

    {"NetworkDefine.CReqDailyCJMsgPara",NetworkDefine.CReqDailyCJMsgPara},
    {"NetworkDefine.CRspDailyCJMsgPara",NetworkDefine.CRspDailyCJMsgPara},
    
    {"NetworkDefine.CRspLogoutGamePlatformPara",NetworkDefine.CRspLogoutGamePlatformPara},

    {"NetworkDefine.CRspUserChangeAccountPassword",NetworkDefine.CRspUserChangeAccountPassword},
    
    {"NetworkDefine.CReqDataRequestVip",NetworkDefine.CReqDataRequestVip},
    {"NetworkDefine.CRspDataParseVip",NetworkDefine.CRspDataParseVip},
    --
    {"NetworkDefine.DataRequestBuy",NetworkDefine.DataRequestBuy},
    {"NetworkDefine.DataParseBuy",NetworkDefine.DataParseBuy},

    {"NetworkDefine.CReqUserDonatePropMsgPara",NetworkDefine.CReqUserDonatePropMsgPara},
    {"NetworkDefine.CRspUserDonatePropMsgPara",NetworkDefine.CRspUserDonatePropMsgPara},
    --请求背包数据
    {"NetworkDefine.DataRequestBagData",NetworkDefine.DataRequestBagData},
    {"NetworkDefine.DataRequestItemTemplate",NetworkDefine.DataRequestItemTemplate},

    {"NetworkDefine.DataRequestGiveJiLuData",NetworkDefine.DataRequestGiveJiLuData},

    {"NetworkDefine.DataRequestItemUse",NetworkDefine.DataRequestItemUse},
    {"NetworkDefine.DataParseItemUse",NetworkDefine.DataParseItemUse},

    {"NetworkDefine.DataRequestCaiJinHall",NetworkDefine.DataRequestCaiJinHall},
    {"NetworkDefine.CMD_S_CaiJinHall",NetworkDefine.CMD_S_CaiJinHall},

    {"NetworkDefine.WithdrawGiftResult",NetworkDefine.WithdrawGiftResult},

    {"NetworkDefine.CRspGameEndStatePara",NetworkDefine.CRspGameEndStatePara},
    
    
    --------------------------自定义结构----------------------------------------------------
    {"NetworkDefine.T_CommodityInfo",NetworkDefine.T_CommodityInfo},
    {"NetworkDefine.T_RoomCnf",NetworkDefine.T_RoomCnf},
    {"NetworkDefine.LevelStruct",NetworkDefine.LevelStruct},
    {"NetworkDefine.DeskUserInfo",NetworkDefine.DeskUserInfo},
    {"NetworkDefine.UserInfoStruct",NetworkDefine.UserInfoStruct},
    {"NetworkDefine.T_CARD_GAME_INFO",NetworkDefine.T_CARD_GAME_INFO},
    {"NetworkDefine.TNotificationInfo",NetworkDefine.TNotificationInfo},
    {"NetworkDefine.DissolveRoomUserInfo",NetworkDefine.DissolveRoomUserInfo},
    {"NetworkDefine.Result_GAME_DATA",NetworkDefine.Result_GAME_DATA},
    {"NetworkDefine.GameTypeData",NetworkDefine.GameTypeData},
    {"NetworkDefine.TUserInfo",NetworkDefine.TUserInfo},
    {"NetworkDefine.TAwardInfo",NetworkDefine.TAwardInfo},

    {"NetworkDefine.ReqUserCheckOutGameCoinPara",NetworkDefine.ReqUserCheckOutGameCoinPara},
    {"NetworkDefine.CRspUserCheckOutGameCoinPara",NetworkDefine.CRspUserCheckOutGameCoinPara},
    {"NetworkDefine.AccountChangeNotify",NetworkDefine.AccountChangeNotify},

    {"NetworkDefine.CReqLoginBroadTransferPara",NetworkDefine.CReqLoginBroadTransferPara},
    {"NetworkDefine.CRspLoginBroadTransferPara",NetworkDefine.CRspLoginBroadTransferPara},
}

function AddStruct( )
	for k,v in pairs(NetworkDefine.All) do
		local name = v[1]
		local tb = v[2]
		NetworkMgr:AddMsgStruct(name,tb)
	end
end
AddStruct()