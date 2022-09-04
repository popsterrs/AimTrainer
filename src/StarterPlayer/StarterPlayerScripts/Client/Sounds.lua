local Sounds = {Library = {}}
Sounds.__index = Sounds

--[[
    
    Sounds.addToLibrary("Name", {Table Containing variations})
    Sounds.play(name, volume, pitch)  

]]

function Sounds.addToLibrary(name, ...)
    if not Sounds.Library[name] then
        local varying = {...}

        for i = 1, #varying do
            varying[i] = "rbxassetid://"..varying[i]
        end

        Sounds.Library[name] = varying
    end
end

function Sounds.play(name, volume, pitch)
    local SoundObject = Instance.new("Sound")
    SoundObject.Parent = game.Workspace

    local sound = Sounds.Library[name]

    if sound then
        SoundObject.SoundId = sound[math.random(1, #sound)]
        SoundObject.Volume = volume
        SoundObject.Pitch = pitch
        SoundObject:Play()
    else
        print("[Sounds] - Cant find sound "..name)
    end

    SoundObject.Ended:Wait()
    SoundObject:Destroy()
end

return Sounds
