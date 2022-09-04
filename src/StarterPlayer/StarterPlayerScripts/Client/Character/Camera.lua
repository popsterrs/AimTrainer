local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local SharedModules = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local Maid = require(SharedModules.Maid)
local Spring = require(SharedModules.Spring)
local Settings = require(script.Parent.Parent.GUI.Settings)
local Animations = require(script.Parent.Parent.Animations)

local Player = game.Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local Camera = {
    Settings = {
        ["Sensitvity"] = 0.1,

        ["yMaxAngle"] = 70,
        ["xMaxAngle"] = 90,

        ["ViewmodelSwayMultiplier"] = 5,

        ["Frozen"] = false
    },

    ["xAngle"] = 0,
    ["yAngle"] = 0,

    ["SwaySpring"] = Spring.new(Vector3.new()),

    ["FOV"] = 50,
    ["MenuFOV"] = 30,
}
Camera.__index = Camera

Camera.SwaySpring.Damper = 0.75
Camera.SwaySpring.Speed = 10

function Camera._new(capsule)
    local NewCamera = {}
    setmetatable(NewCamera, Camera)

    NewCamera.Character = capsule
    NewCamera.CurrentCamera = game.Workspace.Camera
    NewCamera.Viewmodel = Assets.PistolViewmodel:Clone()
    NewCamera.Mode = "Menu"
    NewCamera.Maid = Maid.new()

    NewCamera.Maid:GiveTask(RunService.RenderStepped:Connect(function(dt)
		NewCamera:update(dt)
	end))

    return NewCamera
end

local function GunSway(a)
	local d, s = tick() * 6, 2 * (1.2 - a)
	return CFrame.new(math.cos(d / 8) * s / 128, -math.sin(d / 4) * s / 32, math.sin(d / 16) * s / 64)
end

function FromAxisAngles(x,y,z)
    if not y then
        x,y,z=x.x,x.y,x.z
    end
    local m=(x*x+y*y+z*z)^0.5
    if m>1e-5 then
        local si=math.sin(m/2)/m
        return CFrame.new(0,0,0,si*x,si*y,si*z,math.cos(m/2))
    else
        return CFrame.new()
    end
end

function Camera:update(dt)
    if self.Mode == "Menu" then
        UserInputService.MouseIconEnabled = true

        UI.MENU.Visible = true
        UI.HUD.Visible = false

        self.xAngle = 0
        self.yAngle = 0

        self.CurrentCamera.FieldOfView = self.MenuFOV
        self.CurrentCamera.CFrame = game.Workspace.MenuCameraPart.CFrame

        self.Viewmodel.Parent = nil
    else
        UserInputService.MouseIconEnabled = false

        UI.MENU.Visible = false
        UI.HUD.Visible = true

        self.CurrentCamera.FieldOfView = self.FOV

        local delta = UserInputService:GetMouseDelta() * (self.Settings.Sensitvity / 10)

        if self.Settings.Frozen then
            delta = Vector2.new(0, 0)
        else
            self.SwaySpring.Target = Vector3.new(delta.X / 150, delta.Y / 150, delta.Y / 150)
        end
    
        self.xAngle = math.clamp(self.xAngle - delta.X, -self.Settings.xMaxAngle, self.Settings.xMaxAngle)
        self.yAngle = math.clamp(self.yAngle - delta.Y, -self.Settings.yMaxAngle, self.Settings.yMaxAngle)
    
        --print("X, ", self.xAngle, ",  Y, ", self.yAngle)
    
        if self.Character then
            local RootPart = self.Character:FindFirstChild("RootPart")
            
            if RootPart then
                local StartPosition = game.Workspace.CameraPart.Position --[[RootPart.CameraAttachment.WorldPosition -- for a locked camera position]] 
                local StartOrientation = CFrame.Angles(0, math.rad(self.xAngle), 0) * CFrame.Angles(math.rad(self.yAngle), 0, 0) --[[* CFrame.Angles(math.rad(math.sin(tick())), 0, 0)]] + StartPosition 
                
                self.CurrentCamera.CFrame = StartOrientation
            end
        end

        if Settings.Default.Viewmodel.Value then
            self.Viewmodel.Parent = self.CurrentCamera
            self.Viewmodel:SetPrimaryPartCFrame(
                self.CurrentCamera.CFrame
                *CFrame.new(self.SwaySpring.Velocity)
                *GunSway(0.8)
            )
        else
            self.Viewmodel.Parent = nil
        end

    end
    

    self.FOV = Settings.Default.FOV.Value
    self.Settings.Sensitvity = Settings.Default.Sensitivity.Value
end

function Camera:destroy()
    self.Maid:DoCleaning()
end

return Camera
