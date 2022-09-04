local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local SharedConfig = require(SharedModules.SharedConfig)

local InputHandler = require(script.InputHandler)
local GUI = require(script.GUI)
local Character = require(script.Character)
local Sounds = require(script.Sounds)
local Animations = require(script.Animations)

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()

local UI = Player.PlayerGui:WaitForChild("UserInterface")
GUI.__init()

Character._new()

local function IncreaseSensitivity()
    Character.Camera.Settings.Sensitvity += 0.1
    print(Character.Camera.Settings.Sensitvity)
end

local function DecreaseSensitivity()
    Character.Camera.Settings.Sensitvity -= 0.1
    print(Character.Camera.Settings.Sensitvity)
end

workspace:SetAttribute("GizmosEnabled", true)

InputHandler.BindAction("IncreaseSensitivity", IncreaseSensitivity, Enum.KeyCode.RightBracket)
InputHandler.BindAction("DecreaseSensitivity", DecreaseSensitivity, Enum.KeyCode.LeftBracket)

Sounds.addToLibrary("TargetHit", 9113568125, 9113568235, 9113575001)


Remotes.Data.OnClientEvent:Connect(function(data)
    
end)
