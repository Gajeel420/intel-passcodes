CMDSGuessSizeResult={}

--[[struct Game_GuessSize_Item
{

	byte byItemID;					                    // 猜大小 选项
	byte byItemBase;					                // 猜大小 选项倍数
};

struct CMD_S_Guess_Size_Game_Config_Ret
{
	int nDeskStation;
	byte byResultCnt;										// 结果数量
	Game_GuessSize_Item objItem[BONUS_ITEM_NUM];			// 10个 结果
	byte bySelBase[BONUS_ITEM_NUM];       					//可以选择的倍数
	
};--]]



function CMDSGuessSizeResult.Decode(szBuffer)  --解码
 	if szBuffer==nil then return end
	local iStartLength=0
	local t={}
	t.nDeskStation=DataParse.NetworkToHostOrderToInt32(szBuffer,iStartLength)
	iStartLength=iStartLength+4
	t.byResultCnt=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
	--print("结果个数为：",t.byResultCnt)
	iStartLength=iStartLength+1
	if t.byResultCnt>0 then
		t.Guess_Size_Item={}
		for i=1,10 do
			if i<=t.byResultCnt then
				t.Guess_Size_Item[i]={}
				local itemInfo=t.Guess_Size_Item[i]	
				itemInfo.byItemID=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+1
				itemInfo.byItemBase=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
				iStartLength=iStartLength+1
			else
				iStartLength=iStartLength+2
			end
			
		end
	end
	t.bySelBase={}
	for i=1,10 do
		local num=DataParse.NetworkToHostOrderToByte(szBuffer,iStartLength)
		--print("下注倍数为：",num)
		iStartLength=iStartLength+1
		if num~=-1 or num~=255 then
			table.insert(t.bySelBase,num)
		end
	end
	
	return t
	
 end

return  CMDSGuessSizeResult