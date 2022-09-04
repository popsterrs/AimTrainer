local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Player = Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local Settings = {
    ["Default"] = {
        ["Sensitivity"] = {
            Name = "sensitivity",
            Default = 1,
            Value = 1,
            Increment = 0.1,

            LayoutOrder = 1,
        },
        
        ["FOV"] = {
            Name = "field of view",
            Default = 70,
            Value = 70,
            Increment = 10,

            LayoutOrder = 2,
        },

        ["UploadScore"] = {
            Name = "upload scores",
            Default = true,
            Value = true,

            LayoutOrder = 3,
        },

        ["Viewmodel"] = {
            Name = "show viewmodel",
            Default = true,
            Value = true,

            LayoutOrder = 4,
        },
    }
}

function Settings.AddSetting(i, setting)
    local template = Assets.GUI.SettingsTemplate:Clone()
    template.Parent = UI.MENU.Settings.Holder
    template.LayoutOrder = setting.LayoutOrder
    template.SettingName.Text = setting.Name
    template.Name = i

    if type(setting.Default) == "string" then
        local valueDecider = Assets.GUI.String:Clone()
        valueDecider.Parent = template
    elseif type(setting.Default) == "boolean" then
        local valueDecider = Assets.GUI.Bool:Clone()
        valueDecider.Parent = template

        if setting.Value then
            valueDecider.Toggle.Image = "rbxassetid://3944680095"
        else
            valueDecider.Toggle.Image = "rbxassetid://3944676352"
        end

        valueDecider.Toggle.MouseButton1Down:Connect(function()
            if setting.Value then
                setting.Value = false
                valueDecider.Toggle.Image = "rbxassetid://3944676352"
            else
                setting.Value = true
                valueDecider.Toggle.Image = "rbxassetid://3944680095"
            end

            Remotes.UpdateSetting:FireServer(i, setting.Value)
        end)

    elseif type(setting.Default) == "number" then
        local valueDecider = Assets.GUI.Number:Clone()
        valueDecider.Parent = template

        valueDecider.Input.Text = setting.Value

        valueDecider.Input:GetPropertyChangedSignal("Text"):Connect(function()
            setting.Value = valueDecider.Input.Text

            Remotes.UpdateSetting:FireServer(i, setting.Value)
        end)

        valueDecider.Increase.MouseButton1Down:Connect(function()
            setting.Value = ((setting.Value * 10 ) + (setting.Increment * 10)) / 10
            valueDecider.Input.Text = setting.Value
        end)

        valueDecider.Decrease.MouseButton1Down:Connect(function()
            setting.Value = ((setting.Value * 10 ) - (setting.Increment * 10)) / 10
            valueDecider.Input.Text = setting.Value
        end)
    end
end

function Settings:__init()
    local data = Remotes.GetData:InvokeServer()

    for i, setting in pairs(Settings.Default) do
        setting.Value = data.Settings[i]
        Settings.AddSetting(i, setting)
    end
end

return Settings