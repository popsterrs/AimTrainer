local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local AnimationData = require(script.AnimationData)

local Animations = {
    Library = {}
}
Animations.__index = Animations

function Animations.play(name, model)
    local animation

    if  Animations.Library[model.Name.."_"..name] then
        animation = Animations.Library[model.Name.."_"..name]
    else
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..AnimationData[model.name][name]
        anim.Parent = model
        anim.Name = name

        animation = model.AnimationController.Animator:LoadAnimation(anim)
        Animations.Library[model.Name.."_"..name] = animation
    end

    animation:Play()

    return animation
end

function Animations.stop(name, gun)
    for _, anim in pairs(Animations.Library) do
        if gun.Name..name == anim.Name then
            anim:Stop()
        end
    end
end

return Animations
