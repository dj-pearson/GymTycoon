local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(ReplicatedStorage.shared.Constants)

local ChallengeSystem = {}
ChallengeSystem.__index = ChallengeSystem

-- Private variables
local activeChallenges = {}
local challengeTemplates = {}

function ChallengeSystem.new()
    local self = setmetatable({}, ChallengeSystem)
    return self
end

function ChallengeSystem:Initialize()
    -- Load challenge templates
    self:LoadChallengeTemplates()
    
    -- Start challenge update loop
    task.spawn(function()
        while true do
            task.wait(60) -- Check challenges every minute
            self:UpdateChallenges()
        end
    end)
    
    print("ChallengeSystem initialized")
end

function ChallengeSystem:LoadChallengeTemplates()
    -- Daily challenges
    challengeTemplates[Constants.CHALLENGE_TYPES.DAILY] = {
        {
            id = "clean_equipment",
            name = "Clean Sweep",
            description = "Clean 5 pieces of equipment",
            requirement = 5,
            reward = {
                money = 100,
                xp = 50
            },
            progress = 0,
            type = "equipment_cleaned"
        },
        {
            id = "earn_money",
            name = "Money Maker",
            description = "Earn 500 money from memberships",
            requirement = 500,
            reward = {
                money = 200,
                xp = 100
            },
            progress = 0,
            type = "money_earned"
        },
        {
            id = "place_equipment",
            name = "Expansion",
            description = "Place 3 new pieces of equipment",
            requirement = 3,
            reward = {
                money = 150,
                xp = 75
            },
            progress = 0,
            type = "equipment_placed"
        }
    }
    
    -- Weekly challenges
    challengeTemplates[Constants.CHALLENGE_TYPES.WEEKLY] = {
        {
            id = "reach_members",
            name = "Popular Gym",
            description = "Reach 100 total members",
            requirement = 100,
            reward = {
                money = 1000,
                xp = 500
            },
            progress = 0,
            type = "membership_count"
        },
        {
            id = "maintain_equipment",
            name = "Well Maintained",
            description = "Maintain 10 pieces of equipment",
            requirement = 10,
            reward = {
                money = 800,
                xp = 400
            },
            progress = 0,
            type = "equipment_maintained"
        }
    }
    
    -- Achievement challenges
    challengeTemplates[Constants.CHALLENGE_TYPES.ACHIEVEMENT] = {
        {
            id = "first_floor",
            name = "First Floor Complete",
            description = "Place equipment on every tile of the first floor",
            requirement = 1,
            reward = {
                money = 5000,
                xp = 2000
            },
            progress = 0,
            type = "floor_complete"
        },
        {
            id = "millionaire",
            name = "Millionaire",
            description = "Accumulate 1,000,000 money",
            requirement = 1000000,
            reward = {
                money = 10000,
                xp = 5000
            },
            progress = 0,
            type = "total_money"
        }
    }
end

function ChallengeSystem:GenerateDailyChallenges(player)
    if not activeChallenges[player.UserId] then
        activeChallenges[player.UserId] = {}
    end
    
    -- Clear expired daily challenges
    local currentTime = os.time()
    for i = #activeChallenges[player.UserId], 1, -1 do
        local challenge = activeChallenges[player.UserId][i]
        if challenge.type == Constants.CHALLENGE_TYPES.DAILY and 
           currentTime - challenge.startTime > 86400 then -- 24 hours
            table.remove(activeChallenges[player.UserId], i)
        end
    end
    
    -- Generate new daily challenges
    local dailyTemplates = challengeTemplates[Constants.CHALLENGE_TYPES.DAILY]
    local selectedChallenges = {}
    
    -- Select 3 random daily challenges
    for i = 1, 3 do
        local template = dailyTemplates[math.random(1, #dailyTemplates)]
        local challenge = table.clone(template)
        challenge.startTime = currentTime
        table.insert(selectedChallenges, challenge)
    end
    
    -- Add to active challenges
    for _, challenge in ipairs(selectedChallenges) do
        table.insert(activeChallenges[player.UserId], challenge)
    end
    
    -- Save to player data
    local dataManager = self:GetSystem("DataManager")
    dataManager:UpdateValue(player, "challenges", activeChallenges[player.UserId])
end

function ChallengeSystem:UpdateChallengeProgress(player, challengeType, amount)
    if not activeChallenges[player.UserId] then return end
    
    local updated = false
    for _, challenge in ipairs(activeChallenges[player.UserId]) do
        if challenge.type == challengeType then
            challenge.progress = challenge.progress + amount
            updated = true
            
            -- Check if challenge is complete
            if challenge.progress >= challenge.requirement then
                self:CompleteChallenge(player, challenge)
            end
        end
    end
    
    if updated then
        -- Save progress
        local dataManager = self:GetSystem("DataManager")
        dataManager:UpdateValue(player, "challenges", activeChallenges[player.UserId])
    end
end

function ChallengeSystem:CompleteChallenge(player, challenge)
    -- Award rewards
    local dataManager = self:GetSystem("DataManager")
    
    if challenge.reward.money then
        dataManager:IncrementValue(player, "money", challenge.reward.money)
    end
    
    if challenge.reward.xp then
        self:AwardXP(player, challenge.reward.xp)
    end
    
    -- Mark challenge as complete
    challenge.completed = true
    challenge.completedAt = os.time()
    
    -- TODO: Implement challenge completion notification
end

function ChallengeSystem:UpdateChallenges()
    for userId, challenges in pairs(activeChallenges) do
        local player = game.Players:GetPlayerByUserId(userId)
        if player then
            -- Check for expired challenges
            local currentTime = os.time()
            for i = #challenges, 1, -1 do
                local challenge = challenges[i]
                if challenge.type == Constants.CHALLENGE_TYPES.DAILY and 
                   currentTime - challenge.startTime > 86400 then -- 24 hours
                    table.remove(challenges, i)
                end
            end
            
            -- Generate new daily challenges if needed
            local hasDailyChallenges = false
            for _, challenge in ipairs(challenges) do
                if challenge.type == Constants.CHALLENGE_TYPES.DAILY then
                    hasDailyChallenges = true
                    break
                end
            end
            
            if not hasDailyChallenges then
                self:GenerateDailyChallenges(player)
            end
        end
    end
end

function ChallengeSystem:AwardXP(player, amount)
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
            
            -- TODO: Implement level up rewards
        end
        
        dataManager:UpdateValue(player, "experience", currentXP)
        dataManager:UpdateValue(player, "level", playerData.level)
    end
end

function ChallengeSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return ChallengeSystem 