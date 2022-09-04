local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Maid = require(SharedModules.Maid)
local Camera = require(script.Camera)
local Utils = require(script.Utils)
local InputHandler = require(script.Parent.InputHandler)

local Character = {
    Grounded = false,
}


function Character._new()

    Character.Capsule = Assets.Capsule:Clone()
    Character.Camera = Camera._new(Character.Capsule)
    Character.Maid = Maid.new()

    --[[
    NewCharacter.Maid:GiveTask(RunService.RenderStepped:Connect(function(dt)
		NewCharacter:update(dt)
	end))
    ]]
end

function Character:update(dt)

end

function Character:destroy()
    self.Maid:DoCleaning()
    self.Camera:destroy()
end

return Character
