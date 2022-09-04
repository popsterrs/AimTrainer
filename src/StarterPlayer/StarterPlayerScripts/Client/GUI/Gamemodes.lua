local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local Character = require(script.Parent.Parent.Character)
local InputHandler = require(script.Parent.Parent.InputHandler)
local Gizmo = require(script.Parent.Parent.Gizmo)
local Raycast = require(script.Parent.Parent.RaycastHandler)
local Sounds = require(script.Parent.Parent.Sounds)
local Leaderboards = require(script.Parent.Leaderboards)
local Animations = require(script.Parent.Parent.Animations)
local Settings = require(script.Parent.Settings)

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local GameModes = {}
GameModes.Time = 0
GameModes.Missed = 0
GameModes.Hits = 0

GameModes.CurrentGameMode = nil

function GameModes.StartTimer(action, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        UI.HUD.SpaceToStart.Visible = false
        Character.Camera.Settings.Frozen = false

        while #game.Workspace.Targets:GetChildren() > 0 do
            task.wait(0.01)
            GameModes.Time = ((GameModes.Time * 1000) + (1 * 1000)) / 1000
            UI.HUD.Score.Number.Text = string.format("%02i:%02i",  GameModes.Time / 60 % 60, GameModes.Time % 100)

            if #game.Workspace.Targets:GetChildren() == 0 then
                Character.Camera.Mode = "Menu"

                Remotes.UpdateScore:FireServer(GameModes.CurrentGameMode, math.floor(GameModes.Score / (GameModes.Time / 60) * 10))

                UI.HUD.Score.Number.Text = "00:00"

                UI.RESULTS.Visible = true
                UI.RESULTS.Holder.Time.Value.Text = string.format("%02i:%02i",  GameModes.Time / 60 % 60, GameModes.Time % 100)
                UI.RESULTS.Holder.TargetsMissed.Value.Text = GameModes.Missed
                UI.RESULTS.Holder.Accuracy.Value.Text = ""..(math.floor((100 - ((GameModes.Missed / (GameModes.Hits + GameModes.Missed)) * 100)) * 10) / 10).."%"
                UI.RESULTS.Holder.HitsPerSecond.Value.Text = math.floor(GameModes.Hits / (GameModes.Time / 60) * 10) / 10 
                UI.RESULTS.Holder.Score.Value.Text = math.floor(GameModes.Score)
                UI.RESULTS.Holder.ScorePerSecond.Value.Text = math.floor(GameModes.Score / (GameModes.Time / 60) * 10) / 10 
            end
        end
    end
end

function GameModes:__init()
    local GameModeSelection = Remotes.GetGameModeModules:InvokeServer()

    for _, module in pairs(GameModeSelection) do
        local template = Assets.GUI.GamemodeTemplate:Clone()
        template.Parent = UI.MENU.GamemodeSelection.Holder
        template.Name = module.Name
        template.GamemodeName.Text = module.Name
        template.GamemodeDescription.Text = module.Description
        template.Image.Image = module.ImageId

        template.Play.MouseButton1Down:Connect(function()
            Remotes.SetupTargets:FireServer(module.Name)

            GameModes.Time = 0
            GameModes.Missed = 0
            GameModes.Hits = 0
            GameModes.Score = 0

            GameModes.CurrentGameMode = module.Name

            UI.RESULTS.Holder.Time.Value.Text = "00:00"
            UI.MENU.GamemodeSelection.Visible = false
            UI.HUD.SpaceToStart.Visible = true

            Character.Camera.Mode = "Gameplay"
            Character.Camera.Settings.Frozen = true

            if Settings.Default.Viewmodel.Value then
                task.wait(0.01)
                
                local equip = Animations.play("Equip", Character.Camera.Viewmodel)
                equip.Stopped:Connect(function()
                    Animations.play("Idle", Character.Camera.Viewmodel)
                end)
            end

        end)

        template.Leaderboards.MouseButton1Down:Connect(function()
            Leaderboards.LoadLeaderboard(module.Name)

            UI.MENU.GamemodeSelection.Visible = false
            UI.MENU.Leaderboards.Visible = true
        end)
        

        UI.RESULTS.Menu.MouseButton1Down:Connect(function()
            UI.RESULTS.Visible = false
            UI.MENU.Main.Visible = true
        end)
    end

    
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Whitelist

    local function Click(action, inputState, inputObject)
        if inputState == Enum.UserInputState.Begin then
            if GameModes.Time > 0 then
                Params.FilterDescendantsInstances = {game.Workspace.Targets:GetChildren(), game.Workspace.Base}
                local raycastResult = Raycast.RaycastCenterOfScreen(Params)

                if not Character.Camera.Frozen then
                    if Character.Camera.Mode == "Gameplay" then
                        if Settings.Default.Viewmodel.Value then
                            task.spawn(function()
                                Animations.play("Fire", Character.Camera.Viewmodel)
                                Sounds.play("PistolFire", 0.25, math.random(9, 12) / 10)
                            end)
                        end
                    end
                end
        
                if raycastResult then
                    local success = CollectionService:HasTag(raycastResult.Instance, "Target")
        
                    if success then
                        raycastResult.Instance:Destroy()

                        GameModes.Hits += 1

                        local vector = Character.Camera.CurrentCamera:WorldToScreenPoint(raycastResult.Instance.Position)
                        local targetScreenPosition = Vector2.new(vector.X, vector.Y)
                        local mousePosition = Vector2.new(Mouse.X, Mouse.Y)

                        local distance = (targetScreenPosition - mousePosition).Magnitude
                        GameModes.Score += -((distance ^ 0.5) / (math.pi / 184)) + 500

                        if not Settings.Default.Viewmodel.Value then
                            Sounds.play("TargetHit", 0.1 , 1)
                        end
                    else
                        GameModes.Missed += 1
                    end
                end
            end
        end
    end

    InputHandler.BindAction("StartTimer", GameModes.StartTimer, Enum.KeyCode.Space)
    InputHandler.BindAction("Click", Click, Enum.UserInputType.MouseButton1)

    Sounds.addToLibrary("PistolFire", 9119298326--[[, 9119295764, 9119295844]])
end


return GameModes