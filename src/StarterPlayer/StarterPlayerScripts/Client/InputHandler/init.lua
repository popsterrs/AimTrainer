local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local InputHandler = {
    BoundActions = {},
    KeysDown = {},
    PreviousKeysDown = {},
    Typing = false,

    Settings = require(script.InputSettings),
}

function InputHandler.BindAction(name, actionFunction, keycode)
    ContextActionService:BindAction(name, actionFunction, false, keycode)

    for i, data in pairs(InputHandler.BoundActions) do
      if data.Name == name then
        table.remove(InputHandler.BoundActions, i)
      end
    end

    table.insert(InputHandler.BoundActions, {Name = name, Function = actionFunction})
end

function InputHandler.UnBindAction(name)
    ContextActionService:UnbindAction(name)

    for i, data in pairs(InputHandler.BoundActions) do
        if data.Name == name then
          table.remove(InputHandler.BoundActions, i)
        end
    end
end

UserInputService.TextBoxFocused:Connect(function()
	InputHandler.Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
	InputHandler.Typing = false
end)

UserInputService.InputBegan:Connect(function(inputObject)
  if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
    return
  end

  InputHandler.KeysDown[inputObject.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(inputObject)
  if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
    return
  end

  InputHandler.KeysDown[inputObject.KeyCode] = nil
end)

RunService.RenderStepped:Connect(function()
  local newKeysDown = {}

	for key, value in pairs(InputHandler.KeysDown) do
		newKeysDown[key] = value
	end

	InputHandler.PreviousKeysDown = InputHandler.KeysDown
	InputHandler.KeysDown = newKeysDown
end)




return InputHandler