local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")


local Maid = require(SharedModules.Maid)

local ProgressBars = {
    Bars = {}
}
ProgressBars.__index = ProgressBars

function ProgressBars._new(frame, value, max)
    local NewProgressBar = {}
    setmetatable(NewProgressBar, ProgressBars)

    NewProgressBar.Frame = frame
    NewProgressBar.Fill = frame.Fill
    NewProgressBar.Maid = Maid.new()
    NewProgressBar.Max = max

    NewProgressBar:update(value.Value)

    NewProgressBar.Maid:GiveTask(value.Changed:Connect(function()
		NewProgressBar:update(value.Value)
	end))
    
    table.insert(ProgressBars, NewProgressBar)

    return NewProgressBar
end

function ProgressBars:update(value)
    if self.Fill.AnchorPoint.X == 0.5 then
        self.Fill.Size = UDim2.fromScale(.9, value / self.Max)
    else
        self.Fill.Size = UDim2.fromScale(value / self.Max, .9)
    end
end

function ProgressBars:destroy()
    self.Maid:DoCleaning()
end

return ProgressBars
