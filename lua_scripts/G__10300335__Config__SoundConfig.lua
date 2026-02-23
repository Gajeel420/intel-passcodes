SoundConfig = {}

SoundConfig.Data = {
    [1] = { id = 1, sound = "bgm", soundPath = "Common/Audio/BGM/music.unity3d", soundVol = 1, soundName = "背景音乐", },
    [2] = { id = 2, sound = "rotation", soundPath = "Common/Audio/Sound/rotation.unity3d", soundVol = 1, soundName = "翻转", },
    [3] = { id = 3, sound = "stop", soundPath = "Common/Audio/Sound/stop.unity3d", soundVol = 1, soundName = "停止", },
    [4] = { id = 4, sound = "win", soundPath = "Common/Audio/Sound/win.unity3d", soundVol = 1, soundName = "得分", },
}

function SoundConfig.GetData_id( id )
    local data = {}
    for i = 1, #SoundConfig.Data do
        local item = SoundConfig.Data[i]
        if item.id == id then
            table.insert( data, item )
        end
    end

    return data
end

function SoundConfig.GetData_sound( sound )
    local data = {}
    for i = 1, #SoundConfig.Data do
        local item = SoundConfig.Data[i]
        if item.sound == sound then
            table.insert( data, item )
        end
    end

    return data
end

function SoundConfig.GetData_soundPath( soundPath )
    local data = {}
    for i = 1, #SoundConfig.Data do
        local item = SoundConfig.Data[i]
        if item.soundPath == soundPath then
            table.insert( data, item )
        end
    end

    return data
end

function SoundConfig.GetData_soundVol( soundVol )
    local data = {}
    for i = 1, #SoundConfig.Data do
        local item = SoundConfig.Data[i]
        if item.soundVol == soundVol then
            table.insert( data, item )
        end
    end

    return data
end

function SoundConfig.GetData_soundName( soundName )
    local data = {}
    for i = 1, #SoundConfig.Data do
        local item = SoundConfig.Data[i]
        if item.soundName == soundName then
            table.insert( data, item )
        end
    end

    return data
end

