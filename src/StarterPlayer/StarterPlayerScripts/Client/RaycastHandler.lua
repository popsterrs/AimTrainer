local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local RaycastHandler = {}

function RaycastHandler.DefaultRaycast()

end

function RaycastHandler.RaycastCenterOfScreen(params)
    local Camera = game.Workspace.CurrentCamera
    return game.Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 100, params) 
end

return RaycastHandler