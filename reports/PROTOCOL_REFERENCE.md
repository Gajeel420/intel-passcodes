# GameVault Protocol Reference

## Fish Shooting (40000291)

### CMD_C_HitFish (Client → Server)
```
dwBulletID   (UInt16) — bullet that hit
dwFishID     (UInt32) — fish targeted
```

### CMD_S_HitFish (Server → Client)
```
wChairID       (UInt16) — player seat
dwBulletID     (UInt16) — bullet that hit
dwFishID       (UInt32) — fish hit
btFishKind     (Byte)   — fish type
iFishScore     (Int64)  — PAYOUT (server-decided)
sBaseMul       (UInt16) — base multiplier
uTotalScore    (Int64)  — balance after
iLuckMul       (Int32)  — HIDDEN HOUSE EDGE MULTIPLIER
nFloatFishCount (Int16) — chain kills
  Per chain-kill: dwFishID, btFishKind, iFishScore, sBaseMul, iLuckMul, dwIsKilled
```

## Coin Flip (10300335)

### MSG_BetDataApply (Client → Server)
```
byChipIndex    (Byte) — bet tier (0-based)
byBetFaceIndex (Byte) — 0=Heads, 1=Tails
```

### MSG_BetDataRes (Server → Client)
```
byErrorCode      (Byte)  — 0=success
byChipIndex      (Byte)  — chip tier
byPrizeFaceIndex (Byte)  — PRE-DECIDED OUTCOME
n64WinCoin       (Int64) — payout (0 if loss)
n64BalanceCoin   (Int64) — new balance
```

### MSG_GameStationDataRes (Game State)
```
byGameState     (Byte)
byChipCnt       (Byte)
vecChipAmounts  (Int64[]) — available bet tiers
byChipIndex     (Byte)    — remembered bet selection
n64BalanceCoin  (Int64)   — balance
unPrizeOdds     (Int32)   — odds x100 (101 = 1.01x)
```

## Slots (10300337)

### ASSGMGameStation State=0 (Normal Spin)
```
Offset 0:    bStation (Byte) — game state (0=normal, 1=free, 3=jackpot, 4=dragon)
Offset 1-3:  Version bytes
Offset 4:    byGameResult[100] — COMPLETE REEL GRID (server pre-spun)
Offset 104:  nBetLineCount (Int32)
Offset 108:  nPlayerBet (Int32)
Offset 112:  n64PlayerMoney (Int64)
Offset 120:  nWinScore (Int64) — TOTAL PAYOUT
```

### CMDOpenPrizeResultWithSeq (Spin Result)
```
nDeskStation          (Int32)
byCurMiniGameID       (Byte)
nClientReqSeq         (Int32)
nSrvCurMsgSeq         (Int32)
strGameCode           (20 bytes)
byGameResult[100]     (Byte[]) — reel grid
n64PlayerMoney        (Int64)  — balance
nTotalWinScore        (Int64)  — payout
byNewTriMiniGameID    (Byte)   — bonus trigger (0=none)
byNewTriMiniGameCnt   (Byte)   — bonus plays
byCurMiniGameCurPlayCnt  (Byte)
byCurMiniGameTotalPlayCnt (Byte)
nWinPrizeLineCnt      (Int32)  — number of winning lines
  Per line:
    nPrizeLineID  (Int32)
    nXPos[10]     (Int32[]) — column positions
    nYPos[10]     (Int32[]) — row positions
    nWinLineBase  (Int32)   — HOUSE EDGE MULTIPLIER
    nWinLineScore (Int64)   — line payout
    nGameItemID   (Int32)   — winning symbol
```

### ASSGMGameStation State=1 (Free Games)
```
Offset 4:   nTotalMiniGameCnt (Int32)
Offset 8:   nCurPlayMiniGameCnt (Int32)
Offset 12:  nTotalWinScore (Int64)
Offset 20:  nSelectLineCount (Int32)
Offset 24:  nPlayerBet (Int32)
Offset 28:  byGameResult[100]
```

### ASSGMGameStation State=4 (Dragon Selection)
```
nDeskStation, nTotalMiniGameCnt, nCurPlayMiniGameCnt, nAcumulateCount
byItemCnt (Byte)
Per item (10 max):
  byResult, byPrizeIndex, byPirziType (Bytes)
  n64PrizeVal (Int64)
```

## Network Message IDs
```
MDM_GM_GAME_FRAME  = 150  — game state request
MDM_GM_GAME_NOTIFY = 180  — game logic messages
ASS_GM_GAME_STATION = 2   — game state response
ASS_GAME_BET_APPLY  = 50  — bet request
ASS_GAME_BET_RES    = 150 — bet response
```

## Payment Signing Reference
```lua
-- H5 Payment
MD5(loginState .. "1" .. userID .. "1" .. timestamp .. "1" .. "our-secret")

-- App Payment / Apple Receipt
MD5(userID .. "|" .. timestamp .. "|" .. "our-secret")

-- Google Pay
MD5(orderid .. "|" .. userID .. "|" .. timestamp .. "|" .. tOrderid)

-- Prepaid Card
MD5(userID, timestamp)  -- sent via GenMd5CheckCode(uid, time)
```
