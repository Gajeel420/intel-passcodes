# GameVault Reverse Engineering - Complete Findings

## Games Analyzed

| Game | ID | Type | Status |
|------|-----|------|--------|
| Fish Shooting | 40000291 | Fishing | Fully analyzed |
| Coin Flip | 10300335 | 50/50 Bet | Fully analyzed |
| Slots/Monkey Madness | 10300337 | Reel Spin | Fully analyzed |
| Card Game/Blackjack | 10900500 | Card Room | Identified, Lua not yet captured |

## Architecture: Server Controls Everything

All three games follow the same pattern: **server decides outcome, client renders animation**.

### Fish Shooting (40000291)
- Client sends: bulletID, fishID, screen coordinates
- Server responds: `iFishScore` (pre-calculated payout) + `iLuckMul` (hidden house edge multiplier)
- Fish config: Normal 2x-100x, Special 150x+ variable
- Chain-kill bonuses server-controlled

### Coin Flip (10300335)
- Client sends: `byBetFaceIndex` (0=Heads, 1=Tails) + bet tier
- Server responds: `byPrizeFaceIndex` (pre-decided outcome) + `n64WinCoin` (pre-calculated)
- Animation plays AFTER server decision
- Default odds: 1.01x (`unPrizeOdds`)

### Slots (10300337)
- 4 states: Normal spin, Free games, Jackpot, Dragon reward
- Server sends complete reel grid (100 bytes at offset 4)
- Win lines include per-line multiplier `nWinLineBase` (house edge)
- `nTotalWinScore` at offset 120 = final payout (Int64)
- Bonus triggers (`byNewTriMiniGameID`) server-controlled

## Payment System - Critical Vulnerabilities

### Signing: MD5 with Hardcoded Secret
```
ClientKey = "our-secret"   (ConfigModuleModel.lua line 78)

H5 Pay:     MD5(loginState + "1" + userID + "1" + timestamp + "1" + ClientKey)
App Pay:    MD5(userID + "|" + timestamp + "|" + "our-secret")
Apple IAP:  MD5(appleOrderID + "|" + timestamp + "|" + "our-secret")
Google Pay: MD5(orderid + "|" + userID + "|" + timestamp + "|" + tOrderid)
```

### Vulnerabilities
| Issue | Severity |
|-------|----------|
| MD5 only (no HMAC-SHA256) | CRITICAL |
| Hardcoded `"our-secret"` | CRITICAL |
| Prepaid card sends creds in URL | CRITICAL |
| No certificate pinning in Lua | HIGH |
| Username hardcoded "test" | MEDIUM |

### Payment Channels
Alipay, WeChat, Google Play IAP, Apple IAP, UnionPay, JD Pay, Bank Transfer, Prepaid Cards, Agent rates

### API Endpoints
```
/Pay/create_pay_order/
/validate_ios_pay
/Pay/cardpay/cardno/{val}/cardpwd/{val}/...
/RequestDonomination
/GooglePayOrder
/GooglePayNotify
/PostTxCashWithdraw
/PostTXBindingInfo
/GetTXWithdrawList
```

### Withdrawal System
- Minimum 100 coins, 1.5% fee (min 1.5 yuan)
- Requires bound bank card
- Dual-code signing (code + code2)

### First-Charge Bonus
- Daily tiered wagering bonus (3 levels)
- Must wager threshold to unlock each tier
- Must recharge next day to claim
- Re-engagement trap

## Extraction Method

Frida 17.7.3 hooking XLua runtime on rooted Android (HD65 Ultra):
1. Hook `luaL_loadbufferx`, `xluaL_loadbuffer`, `luaL_loadstring` in libxlua.so
2. Write captured Lua to app's cache dir via Java FileOutputStream
3. `su -c cp` to /data/local/tmp, then `adb pull`
4. 6 iterations to bypass Android scoped storage restrictions

## Data Captured
- 498 Lua source files (~2.4 MB)
- All plain-text source code
- Complete protocol definitions
- Payment signing secrets
