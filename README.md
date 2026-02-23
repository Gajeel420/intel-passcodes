# GameVault APK - Reverse Engineering

Reverse engineering of GameVault gambling application. Includes complete Lua source extraction, protocol documentation, payment system security audit, and Frida hooking scripts.

## Contents

```
lua_scripts/          498 Lua source files (~2.4 MB)
frida_hooks/          Frida JavaScript hooking scripts
reports/              Analysis findings and protocol reference
```

## Games Analyzed

| Game | ID | Key Finding |
|------|-----|-------------|
| Fish Shooting | 40000291 | Hidden `iLuckMul` multiplier controls house edge |
| Coin Flip | 10300335 | Server pre-decides outcome before animation |
| Slots | 10300337 | Server sends complete reel grid + pre-calculated payout |
| Card Game | 10900500 | Identified but Lua not yet captured |

## Critical Findings

- **All outcomes server-determined** - client has zero game logic
- **Payment signing**: MD5 with hardcoded secret `"our-secret"`
- **No certificate pinning** in Lua network layer
- **Prepaid card credentials sent in URL path**

## Key Files

| File | Contents |
|------|----------|
| `lua_scripts/H__Logic__RechargeManager.lua` | Payment orchestration |
| `lua_scripts/H__Common__NetworkDefine.lua` | All protocol definitions |
| `lua_scripts/H__BaseModules__ConfigModule__ConfigModuleModel.lua` | Hardcoded secrets |
| `lua_scripts/G__40000291__Msg__CMD_S_HitFish.lua` | Fish hit protocol |
| `lua_scripts/G__40000291__Config__FishConfig.lua` | Fish payout ratios |
| `lua_scripts/G__10300335__GameController.lua` | Coin flip game logic |
| `lua_scripts/G__10300335__View__Coin__CoinPanel.lua` | Coin flip animation |
| `lua_scripts/G__10300337__Msg__ASSGMGameStation.lua` | Slots protocol |
| `lua_scripts/G__10300337__Msg__CMDOpenPrizeResultWithSeq.lua` | Spin result format |

## Extraction Method

Frida 17.7.3 on rooted Android, hooking XLua runtime (`luaL_loadbufferx`, `xluaL_loadbuffer`) in `libxlua.so`. Scripts written to app cache via Java FileOutputStream, then pulled via adb.

## Status

- Fish Shooting: Complete
- Coin Flip: Complete
- Slots: Complete
- Card Game/Blackjack (10900500): Identified, needs further analysis
