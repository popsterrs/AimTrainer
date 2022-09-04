local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local DataManager = {}

local ProfileTemplate = {
	Settings = {
        Sensitivity  = 1,
        UploadScore = true,
		Viewmodel = true,
		FOV = 70,
    }
}

----- Loaded Modules -----

local ProfileService = require(script.Parent.ProfileService)

----- Private Variables -----

local Players = game:GetService("Players")

local GameProfileStore = ProfileService.GetProfileStore(
	"PlayerData_5",
	ProfileTemplate
)

DataManager.Profiles = {} -- [player] = profile
DataManager.Leaderboards = {
	["Easy"] = DataStoreService:GetOrderedDataStore("Easy_5"),
	["Medium"] = DataStoreService:GetOrderedDataStore("Medium_5"),
	["Hard"] = DataStoreService:GetOrderedDataStore("Hard_5"),
}

----- Private Functions -----

local function PlayerAdded(player)
	local profile = GameProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			DataManager.Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			DataManager.Profiles[player] = profile
			-- A profile has been successfully loaded:
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

----- Initialize -----

-- In case Players have joined the server earlier than this script ran:
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, player)
end



----- Connections -----

function DataManager.PlayerAdded(player)
    PlayerAdded(player)
end

function DataManager.PlayerRemoving(player)
    local profile = DataManager.Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end

----- Public Functions -----

function DataManager.GetPlayerProfileAsync(player) --> [Profile] / nil
	-- Yields until a Profile linked to a player is loaded or the player leaves
	local profile = DataManager.Profiles[player]
	while profile == nil and player:IsDescendantOf(Players) == true do
		RunService.Heartbeat:Wait()
		profile = DataManager.Profiles[player]
	end
	return profile
end

function DataManager.Set(player, value, set)
	if game.Players:FindFirstChild(player.Name) then
		local data = DataManager.GetPlayerProfileAsync(player).Data
		data[value] = data[value] + set

		Remotes.Data:FireClient(player, data)
	end
end

Remotes.UpdateSetting.OnServerEvent:Connect(function(player, setting, value)
    if game.Players:FindFirstChild(player.Name) then
        local data = DataManager.GetPlayerProfileAsync(player).Data
        data.Settings[setting] = value

        Remotes.Data:FireClient(player, data)
    end
end)

Remotes.GetData.OnServerInvoke = function(player)
    return DataManager.GetPlayerProfileAsync(player).Data
end

Remotes.GetLeaderboardData.OnServerInvoke = function(player, gameMode)
	local pages = DataManager.Leaderboards[gameMode]:GetSortedAsync(true, 50)
    return pages:GetCurrentPage()
end

Remotes.UpdateScore.OnServerEvent:Connect(function(player, gameMode, score)
    if game.Players:FindFirstChild(player.Name) then
		local data = DataManager.GetPlayerProfileAsync(player).Data

		if data.Settings.UploadScore then
			local playerScore = DataManager.Leaderboards[gameMode]:GetAsync(player.Name)

			if not playerScore then
				DataManager.Leaderboards[gameMode]:SetAsync(player.Name, score)
				return
			end
	
			if score > playerScore then
				DataManager.Leaderboards[gameMode]:SetAsync(player.Name, score)
			end
		end
	end
end)

return DataManager