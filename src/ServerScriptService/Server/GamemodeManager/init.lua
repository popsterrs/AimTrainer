local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local GamemodeManager = {}

function GamemodeManager.__init()

end

Remotes.GetGameModeModules.OnServerInvoke = function(player)
    local x = {}

    for _,v in pairs(script:GetChildren()) do
        local z = require(v)
        table.insert(x, z.Info)
    end

    return x
end

Remotes.SetupTargets.OnServerEvent:Connect(function(player, gameMode)
    for _,x in pairs(game.Workspace.Targets:GetChildren()) do
        x:Destroy()
    end

    local module = nil

    for _, v in pairs(script:GetChildren()) do
        if string.lower(gameMode) == string.lower(v.Name) then
            module = require(v)
        end
    end

    local function CreateTarget(position)
        local Target = Assets.Target:Clone()
        Target.Parent = game.Workspace.Targets
        Target.Position = position
        Target.Size = module.Info.TargetSize
        Target.Color = module.Info.TargetColour
    end
    
    for _, pos in pairs(module.GeneratePositions()) do
        CreateTarget(pos)
    end
end)

return GamemodeManager
