local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local Player = Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local Leaderboard = {}

function Leaderboard.LoadLeaderboard(name)
    local data = Remotes.GetLeaderboardData:InvokeServer(name)

    for _,v in pairs(UI.MENU.Leaderboards.Holder:GetChildren()) do
        if v:IsA("Frame") then
            if v.Name ~= "TopBar" then
                v:Destroy()
            end
        end
    end
    
    for rank, values in ipairs(data) do
        local template = Assets.GUI.LeaderboardTemplate:Clone()
        template.Parent = UI.MENU.Leaderboards.Holder
        template.Name = values.key
        template.Player.Text = values.key
        template.Rank.Text = rank
        template.Score.Text = values.value / 10
    end
end

function Leaderboard:__init()

    UI.MENU.Leaderboards.Back.MouseButton1Down:Connect(function()
        UI.MENU.Leaderboards.Visible = false
        UI.MENU.GamemodeSelection.Visible = true
    end)
end


return Leaderboard