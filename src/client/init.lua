local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create UI folder
local ui = Instance.new("ScreenGui")
ui.Name = "UI"
ui.ResetOnSpawn = false
ui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create RemoteEvents folder
local remotes = Instance.new("Folder")
remotes.Name = "RemoteEvents"
remotes.Parent = ReplicatedStorage

-- Create remote events
local remoteEvents = {
    "PlaceTile",
    "CleanEquipment",
    "MaintainEquipment",
    "UseEquipment",
    "StopUsingEquipment",
    "UpdateChallengeProgress",
    "UnlockFloor",
    "UpdateMoney",
    "UpdateLevel"
}

for _, eventName in ipairs(remoteEvents) do
    local event = Instance.new("RemoteEvent")
    event.Name = eventName
    event.Parent = remotes
end

-- Load shared modules
local Constants = require(ReplicatedStorage.shared.Constants)

-- Load controllers
local UIController = require(script.Parent.Controllers.UIController)
local PlayerController = require(script.Parent.Controllers.PlayerController)
local CameraController = require(script.Parent.Controllers.CameraController)

-- Initialize controllers
local uiController = UIController.new()
local playerController = PlayerController.new()
local cameraController = CameraController.new()

uiController:Initialize()
playerController:Initialize()
cameraController:Initialize()

-- Connect remote events
remotes.PlaceTile.OnClientEvent:Connect(function(success, message)
    if success then
        uiController:ShowNotification("Success", "Tile placed successfully!")
    else
        uiController:ShowNotification("Error", message)
    end
end)

remotes.CleanEquipment.OnClientEvent:Connect(function(success, message)
    if success then
        uiController:ShowNotification("Success", "Equipment cleaned!")
    else
        uiController:ShowNotification("Error", message)
    end
end)

remotes.MaintainEquipment.OnClientEvent:Connect(function(success, message)
    if success then
        uiController:ShowNotification("Success", "Equipment maintained!")
    else
        uiController:ShowNotification("Error", message)
    end
end)

remotes.UseEquipment.OnClientEvent:Connect(function(success, message)
    if success then
        uiController:ShowNotification("Success", "Using equipment!")
    else
        uiController:ShowNotification("Error", message)
    end
end)

remotes.UpdateChallengeProgress.OnClientEvent:Connect(function(challengeType, progress)
    uiController:UpdateChallengeProgress(challengeType, progress)
end)

remotes.UnlockFloor.OnClientEvent:Connect(function(floor)
    uiController:ShowFloorUnlocked(floor)
    cameraController:SwitchFloor(floor)
end)

remotes.UpdateMoney.OnClientEvent:Connect(function(amount)
    uiController:UpdateMoney(amount)
end)

remotes.UpdateLevel.OnClientEvent:Connect(function(level)
    uiController:UpdateLevel(level)
end)

-- Connect camera and player controllers
cameraController.SwitchFloor:Connect(function(floor)
    playerController:SetCurrentFloor(floor)
end)

-- Cleanup on player leaving
LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if not parent then
        uiController:Cleanup()
        playerController:Cleanup()
        cameraController:Cleanup()
    end
end)

print("Client initialized") 