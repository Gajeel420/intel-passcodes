StoreModuleConst = {}

StoreModuleConst.EventName_StartReqWebInfo="StoreStartReqWebInfo" --开始请求web端数据
StoreModuleConst.EventName_ReqWebInfoError="StoreReqWebInfoError" --请求web端数据失败
StoreModuleConst.EventName_ReqWebInfoCallBack="StoreReqWebInfoCallBack" --请求web端数据成功 面额数据返回
StoreModuleConst.EventName_ClearWebInfoCallBack="ClearWebInfoCallBack" --清楚Web端数据
StoreModuleConst.EventName_RequiredPayMoneyListCallBack="RequiredPayMoneyListCallBack" --拉取面额信息返回
StoreModuleConst.PayType = {
    agent = 0, --代理
    dianka = 0, --点卡
    alipay = 1, --支付宝
    weixin = 2, --微信
    qq = 3, --QQ
    jd = 4, --京东
    wy = 5, --网银
    yl = 6, --银联
    ios = 8, --苹果支付
}