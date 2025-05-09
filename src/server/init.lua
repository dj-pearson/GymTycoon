local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Don't create folders that Rojo is managing
-- Commented out to avoid conflicts with Rojo
--[[ 
local shared = Instance.new("Folder")
shared.Name = "Shared"
shared.Parent = ReplicatedStorage

local core = Instance.new("Folder")
core.Name = "Core"
core.Parent = ServerScriptService
--]]

-- Load and register core systems
local CoreRegistry = require(script.Parent.server.Core.CoreRegistry)

-- Load all core systems
local systems = {
    DataManager = require(script.Parent.server.Core.DataManager),    TileSystem = require(script.Parent.server.Core.TileSystem),
    MembershipSystem = require(script.Parent.server.Core.MembershipSystem),
    EquipmentSystem = require(script.Parent.server.Core.EquipmentSystem),
    ChallengeSystem = require(script.Parent.server.Core.ChallengeSystem),
    ProgressionSystem = require(script.Parent.server.Core.ProgressionSystem)
}

-- Register all systems
for systemName, system in pairs(systems) do
    CoreRegistry:Register(systemName, system)
end

-- Initialize all systems
CoreRegistry:Initialize()

-- Handle player joining
game.Players.PlayerAdded:Connect(function(player)
    -- Load player data
    local dataManager = CoreRegistry:GetSystem("DataManager")
    if dataManager then
        dataManager:LoadPlayerData(player)
    end
end)

-- Handle player leaving
game.Players.PlayerRemoving:Connect(function(player)
    -- Save player data
    local dataManager = CoreRegistry:GetSystem("DataManager")
    if dataManager then
        dataManager:SavePlayerData(player)
    end
end) 