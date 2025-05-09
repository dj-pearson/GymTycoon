local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataManager = {}
DataManager.__index = DataManager

-- Constants
local DATA_STORE_NAME = "GymTycoonData_v1"
local DEFAULT_DATA = {
    money = 1000,
    level = 1,
    experience = 0,
    ownedTiles = {},
    equipment = {},
    membershipCount = 0,
    unlockedFloors = {1},
    challenges = {},
    lastSave = 0
}

-- Private variables
local dataStore = DataStoreService:GetDataStore(DATA_STORE_NAME)
local playerData = {}

function DataManager.new()
    local self = setmetatable({}, DataManager)
    return self
end

function DataManager:Initialize()
    -- Set up any necessary initialization
    print("DataManager initialized")
end

function DataManager:LoadPlayerData(player)
    local success, data = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        playerData[player.UserId] = data
    else
        -- Use default data if loading fails
        playerData[player.UserId] = table.clone(DEFAULT_DATA)
    end
    
    -- Set up auto-save
    task.spawn(function()
        while player and player.Parent do
            task.wait(300) -- Auto-save every 5 minutes
            self:SavePlayerData(player)
        end
    end)
    
    return playerData[player.UserId]
end

function DataManager:SavePlayerData(player)
    if not playerData[player.UserId] then return end
    
    local success, err = pcall(function()
        dataStore:SetAsync(player.UserId, playerData[player.UserId])
    end)
    
    if not success then
        warn("Failed to save data for player", player.Name, ":", err)
    end
end

function DataManager:GetPlayerData(player)
    return playerData[player.UserId]
end

function DataManager:UpdateValue(player, key, value)
    if not playerData[player.UserId] then return end
    
    playerData[player.UserId][key] = value
    playerData[player.UserId].lastSave = os.time()
end

function DataManager:IncrementValue(player, key, amount)
    if not playerData[player.UserId] then return end
    
    playerData[player.UserId][key] = (playerData[player.UserId][key] or 0) + amount
    playerData[player.UserId].lastSave = os.time()
end

return DataManager 