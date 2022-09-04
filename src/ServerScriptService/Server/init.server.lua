local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local ServerModules = ServerStorage:WaitForChild("Modules")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DataManager = require(script.DataManager)
local GamemodeManager = require(script.GamemodeManager)

Players.PlayerAdded:Connect(function(player)
    player:LoadCharacter()
    player.Character:Destroy()
    DataManager.PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
    DataManager.PlayerRemoving(player)
end)