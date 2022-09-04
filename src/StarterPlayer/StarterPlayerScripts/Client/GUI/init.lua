local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Player = Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local GuiService = {
    ProgressBar = require(script.ProgressBar),
    GameScalingUtils = require(script.GameScalingUtils),
    Menu = require(script.Menu),
    Settings = require(script.Settings),
    Gamemodes = require(script.Gamemodes),
    Leaderboards = require(script.Leaderboards)
}
GuiService.__index = GuiService

function GuiService.__init()
    GuiService.Settings.__init()
    GuiService.Menu.__init()
    GuiService.Gamemodes.__init()
    GuiService.Leaderboards.__init()
end

RunService.RenderStepped:Connect(function(dt) 
    --local UIScale = GuiService.GameScalingUtils.getUIScale(UI.AbsoluteSize)
end)

return GuiService
