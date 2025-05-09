local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(ReplicatedStorage.shared.Constants)

local ProgressionSystem = {}
ProgressionSystem.__index = ProgressionSystem

-- Private variables
local playerProgress = {}
local floorMilestones = {}

function ProgressionSystem.new()
    local self = setmetatable({}, ProgressionSystem)
    return self
end

function ProgressionSystem:Initialize()
    -- Initialize floor milestones
    self:InitializeFloorMilestones()
    
    -- Start progression check loop
    task.spawn(function()
        while true do
            task.wait(60) -- Check progression every minute
            self:CheckProgression()
        end
    end)
    
    print("ProgressionSystem initialized")
end

function ProgressionSystem:InitializeFloorMilestones()
    -- Define milestones for each floor
    floorMilestones = {
        [2] = {
            requiredTiles = 10,
            requiredMembers = 50,
            requiredLevel = 5,
            cost = 50000,
            rewards = {
                money = 10000,
                xp = 5000
            }
        },
        [3] = {
            requiredTiles = 20,
            requiredMembers = 100,
            requiredLevel = 10,
            cost = 100000,
            rewards = {
                money = 20000,
                xp = 10000
            }
        }
    }
end

function ProgressionSystem:CheckProgression()
    for userId, progress in pairs(playerProgress) do
        local player = game.Players:GetPlayerByUserId(userId)
        if player then
            self:UpdatePlayerProgress(player)
        end
    end
end

function ProgressionSystem:UpdatePlayerProgress(player)
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(player)
    
    if not playerData then return end
    
    -- Initialize progress tracking if needed
    if not playerProgress[player.UserId] then
        playerProgress[player.UserId] = {
            lastChecked = os.time(),
            milestones = {}
        }
    end
    
    -- Check floor unlock conditions
    for floor, requirements in pairs(floorMilestones) do
        if not table.find(playerData.unlockedFloors, floor) then
            local canUnlock = self:CanUnlockFloor(player, floor)
            if canUnlock then
                self:UnlockFloor(player, floor)
            end
        end
    end
    
    -- Update progress tracking
    playerProgress[player.UserId].lastChecked = os.time()
end

function ProgressionSystem:CanUnlockFloor(player, floor)
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(player)
    
    if not playerData then return false end
    
    local requirements = floorMilestones[floor]
    if not requirements then return false end
    
    -- Check if player meets all requirements
    local ownedTiles = #playerData.ownedTiles
    local memberCount = playerData.membershipCount
    local playerLevel = playerData.level
    local playerMoney = playerData.money
    
    return ownedTiles >= requirements.requiredTiles
        and memberCount >= requirements.requiredMembers
        and playerLevel >= requirements.requiredLevel
        and playerMoney >= requirements.cost
end

function ProgressionSystem:UnlockFloor(player, floor)
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(player)
    
    if not playerData then return false end
    
    local requirements = floorMilestones[floor]
    if not requirements then return false end
    
    -- Deduct cost
    dataManager:IncrementValue(player, "money", -requirements.cost)
    
    -- Add floor to unlocked floors
    table.insert(playerData.unlockedFloors, floor)
    dataManager:UpdateValue(player, "unlockedFloors", playerData.unlockedFloors)
    
    -- Award rewards
    if requirements.rewards then
        if requirements.rewards.money then
            dataManager:IncrementValue(player, "money", requirements.rewards.money)
        end
        
        if requirements.rewards.xp then
            self:AwardXP(player, requirements.rewards.xp)
        end
    end
    
    -- Trigger floor unlock event
    self:OnFloorUnlocked(player, floor)
    
    return true
end

function ProgressionSystem:OnFloorUnlocked(player, floor)
    -- Update challenge system
    local challengeSystem = self:GetSystem("ChallengeSystem")
    if challengeSystem then
        challengeSystem:UpdateChallengeProgress(player, "floor_unlocked", 1)
    end
    
    -- TODO: Implement floor unlock notification
    -- TODO: Implement floor unlock effects
    -- TODO: Implement floor unlock tutorial
end

function ProgressionSystem:GetFloorRequirements(floor)
    return floorMilestones[floor]
end

function ProgressionSystem:GetPlayerProgress(player)
    return playerProgress[player.UserId]
end

function ProgressionSystem:AwardXP(player, amount)
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(player)
    
    if playerData then
        -- Calculate level up
        local currentXP = playerData.experience + amount
        local baseLevelUp = Constants.EXPERIENCE.BASE_LEVEL_UP
        local levelMultiplier = Constants.EXPERIENCE.LEVEL_MULTIPLIER
        
        while currentXP >= baseLevelUp do
            currentXP = currentXP - baseLevelUp
            playerData.level = playerData.level + 1
            baseLevelUp = baseLevelUp * levelMultiplier
            
            -- Trigger level up event
            self:OnLevelUp(player, playerData.level)
        end
        
        dataManager:UpdateValue(player, "experience", currentXP)
        dataManager:UpdateValue(player, "level", playerData.level)
    end
end

function ProgressionSystem:OnLevelUp(player, newLevel)
    -- Update challenge system
    local challengeSystem = self:GetSystem("ChallengeSystem")
    if challengeSystem then
        challengeSystem:UpdateChallengeProgress(player, "level_up", 1)
    end
    
    -- TODO: Implement level up notification
    -- TODO: Implement level up rewards
    -- TODO: Implement level up effects
end

function ProgressionSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return ProgressionSystem 