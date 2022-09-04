local Players = game:GetService("Players")

local Character = require(script.Parent.Parent.Character)
local InputHandler = require(script.Parent.Parent.InputHandler)

local Player = Players.LocalPlayer

local UI = Player.PlayerGui:WaitForChild("UserInterface")

local Menu = {}

function Menu.ShowMenu(action, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        Character.Camera.Mode = "Menu"
        UI.MENU.Main.Visible = true 
    end
end

function Menu:__init()
--#Main buttons
    UI.MENU.Main.Start.MouseButton1Down:Connect(function()
        --Character.Camera.Mode = "Gameplay"
        UI.MENU.Main.Visible = false 
        UI.MENU.GamemodeSelection.Visible = true 
    end)

    UI.MENU.Main.Settings.MouseButton1Down:Connect(function()
        UI.MENU.Main.Visible = false 
        UI.MENU.Settings.Visible = true
    end)

    UI.MENU.Main.Credits.MouseButton1Down:Connect(function()
        UI.MENU.Main.Visible = false 
        UI.MENU.Credits.Visible = true
    end)

--#Back buttons


    UI.MENU.Settings.Back.MouseButton1Down:Connect(function()
        UI.MENU.Settings.Visible = false
        UI.MENU.Main.Visible = true
    end)

    UI.MENU.Credits.Back.MouseButton1Down:Connect(function()
        UI.MENU.Credits.Visible = false
        UI.MENU.Main.Visible = true
    end)

    UI.MENU.GamemodeSelection.Back.MouseButton1Down:Connect(function()
        UI.MENU.GamemodeSelection.Visible = false
        UI.MENU.Main.Visible = true
    end)

--#Logo visibility

    UI.MENU.Main:GetPropertyChangedSignal("Visible"):Connect(function()
        UI.MENU.Logo.Visible = UI.MENU.Main.Visible
    end)

    InputHandler.BindAction("ShowMenu", Menu.ShowMenu, Enum.KeyCode.M)
end

return Menu