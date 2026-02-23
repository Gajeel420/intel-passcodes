SystemSetting = SystemSetting or BaseClass()

function SystemSetting:__init( ... )
	self.Key_BGMusic = "Key_BGMusic"
	self.Key_BGMusicVolume = "Key_BGMusicVolume"

	self.Key_Sound = "Key_Sound"
	self.Key_SoundVolume = "Key_SoundVolume"

	self.Key_ZhenDong = "Key_ZhenDong"

	self.IsBGMusicOn = true
	self.BGMusicVolume = 1

	self.IsSoundOn = true
	self.SoundVolume = 1

	self.IsZhenDongOn=true


	--登录过的账号和密码
	self.Key_AccountList="Key_AccountList"
	self.accountAndPasswordTableList=nil

	self.Key_Language = "Key_Language"

	self.LanguageType = {"Chinese","English"}

	self.CurrentLanguage = self.LanguageType[2]

	self.LocalizationManager = CS.I2.Loc.LocalizationManager

	self:SystemSettingInitilize()
end


function SystemSetting.Split(str,reps)
	local resultStrList={}
	string.gsub(str,'[^'..reps..']+',function (w)
		table.insert(resultStrList,w )
	end )
	return resultStrList
end

function SystemSetting:GetAccountAndPasswordTableList()
	if self.accountAndPasswordTableList==nil then
		self.accountAndPasswordTableList={}
		local allAccountAndPasswordString= PlayerPrefs.GetString(self.Key_AccountList,"")
		local accountAndPasswordStringList=SystemSetting.Split(allAccountAndPasswordString,";")
		for i = 1, #accountAndPasswordStringList do
			local strTable= SystemSetting.Split(accountAndPasswordStringList[i],",")
			local accountAndPasswordTableL={}
			accountAndPasswordTableL.account=strTable[1]
			accountAndPasswordTableL.password=strTable[2]
			table.insert(self.accountAndPasswordTableList,accountAndPasswordTableL )
		end
	end
 

	return self.accountAndPasswordTableList
end

function SystemSetting:WriteAccountAndPasswordTableList()
	if  self.accountAndPasswordTableList==nil then

		return
	end

	local allString=""
	for i = 1, #self.accountAndPasswordTableList do

		allString=allString..self.accountAndPasswordTableList[i].account..","..self.accountAndPasswordTableList[i].password..";"
	end

	PlayerPrefs.SetString(self.Key_AccountList,allString)

end

function SystemSetting:AddAccountAndPasswordTable(addTable)
	if self.accountAndPasswordTableList==nil then
		self:GetAccountAndPasswordTableList()
	end

	for i = 1, #self.accountAndPasswordTableList do
		if self.accountAndPasswordTableList[i].account== addTable.account then
			table.remove(self.accountAndPasswordTableList,i )
			break
		end
	end
	table.insert(self.accountAndPasswordTableList, addTable)
	self:WriteAccountAndPasswordTableList()
end



function SystemSetting:DeleteAccountAndPasswordTable(deleteAccount)
	if self.accountAndPasswordTableList==nil then
		self:GetAccountAndPasswordTableList()
	end
	for i = 1, #self.accountAndPasswordTableList do
		if self.accountAndPasswordTableList[i].account== deleteAccount then
			table.remove(self.accountAndPasswordTableList,i )
			self:WriteAccountAndPasswordTableList()
			return
		end
	end

end


function SystemSetting:__delete( ... )

end

function SystemSetting:GetInstance()
	if SystemSetting.instance == nil then
		SystemSetting.instance = SystemSetting.New()
	end
	return SystemSetting.instance
end

function SystemSetting:SystemSettingInitilize( ... )
	self.IsBGMusicOn = PlayerPrefs.GetInt(self.Key_BGMusic,1) == 1
	self.BGMusicVolume = PlayerPrefs.GetFloat(self.Key_BGMusicVolume,1)
	
	self.IsSoundOn = PlayerPrefs.GetInt(self.Key_Sound,1) == 1
	self.SoundVolume = PlayerPrefs.GetFloat(self.Key_SoundVolume,1)
	LuaToCSBridge.g_nSysSoundVolume=self.SoundVolume
	LuaToCSBridge.g_nSysBGMusicVolume=self.BGMusicVolume

	self.IsZhenDongOn = PlayerPrefs.GetInt(self.Key_ZhenDong,1) == 1

	
	-- if PlayerPrefs.GetString(self.Key_Language)~="" then
		
	-- 	self.CurrentLanguage = PlayerPrefs.GetString(self.Key_Language)
	-- end

	self:SetLanguage(self.CurrentLanguage)

	print("系统设置初始化成功")
end

function SystemSetting:GetIsBGMusicOn()
	return self.IsBGMusicOn
end

function SystemSetting:SetBGMusicOn( val )
	self.IsBGMusicOn = val
	if(val) then
		self.BGMusicVolume = 1
	else 
		self.BGMusicVolume = 0
	end
	
	LuaToCSBridge.g_nSysBGMusicVolume=self.BGMusicVolume
	local volumeVal = 1
	
	if(val) then
		volumeVal = 1
	else
		volumeVal = 0
	end
	
	PlayerPrefs.SetInt(self.Key_BGMusic,volumeVal)
	PlayerPrefs.SetFloat(self.Key_BGMusicVolume,self.BGMusicVolume)
	print("IsBGMusicOn ",self.IsBGMusicOn,"BGMusicVolume",self.BGMusicVolume)
end


function SystemSetting:GetIsSoundOn()
	return self.IsSoundOn
end

function SystemSetting:SetSoundOn( val )
	self.IsSoundOn = val
	if(val) then
		self.SoundVolume = 1
	else 
		self.SoundVolume = 0
	end
	LuaToCSBridge.g_nSysSoundVolume=self.SoundVolume

	local volumeVal = 1

	if(val) then
		volumeVal = 1
	else
		volumeVal = 0
	end

	PlayerPrefs.SetInt(self.Key_Sound,volumeVal)
	PlayerPrefs.SetFloat(self.Key_SoundVolume,self.SoundVolume)

	print("IsSoundOn ",self.IsSoundOn,"SoundVolume",self.SoundVolume)
end

function SystemSetting:GetIsZhenDongOn()
	return self.IsZhenDongOn
end

function SystemSetting:SetZhenDongOn(val)
	self.IsZhenDongOn=val
	if val then
		val=1
	else
		val=0
	end
	PlayerPrefs.SetInt(self.Key_ZhenDong,val)
end

function SystemSetting:SetBGMusicVolume(volume)
	self.BGMusicVolume=volume
	PlayerPrefs.SetFloat(self.Key_BGMusicVolume,self.BGMusicVolume)
end

function SystemSetting:SetSoundVolume(volume)
	self.SoundVolume=volume
	PlayerPrefs.SetFloat(self.Key_SoundVolume,self.SoundVolume)
end

function SystemSetting:GetBGMusicVolume()
	return self.BGMusicVolume
end

function SystemSetting:GetSoundVolume()
	return self.SoundVolume
end

function SystemSetting:SetLanguage(language)
	if self.LocalizationManager.HasLanguage(language) then
		self.LocalizationManager.CurrentLanguage =  language
		self.CurrentLanguage = language
		PlayerPrefs.SetString(self.Key_Language,self.CurrentLanguage)
	end
end

function SystemSetting:GetLanguage()
	return self.CurrentLanguage
end