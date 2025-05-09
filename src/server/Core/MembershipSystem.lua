local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(ReplicatedStorage.shared.Constants)

local MembershipSystem = {}
MembershipSystem.__index = MembershipSystem

-- Private variables
local memberData = {}
local activeMembers = {}

function MembershipSystem.new()
    local self = setmetatable({}, MembershipSystem)
    return self
end

function MembershipSystem:Initialize()
    -- Start member generation loop
    task.spawn(function()
        while true do
            task.wait(60) -- Check every minute
            self:UpdateMembers()
        end
    end)
    
    print("MembershipSystem initialized")
end

function MembershipSystem:GenerateMember(player)
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(player)
    if not playerData then return nil end
    
    -- Calculate gym attractiveness based on equipment and cleanliness
    local attractiveness = self:CalculateGymAttractiveness(player)
    
    -- Determine membership type based on attractiveness
    local membershipType = self:DetermineMembershipType(attractiveness)
    
    -- Create member instance
    local member = {
        id = #memberData + 1,
        playerId = player.UserId,
        membershipType = membershipType,
        joinDate = os.time(),
        lastVisit = os.time(),
        satisfaction = 1.0,
        loyalty = 0.0,
        preferences = self:GeneratePreferences(),
        currentActivity = nil,
        equipmentUsage = {}
    }
    
    -- Store member data
    memberData[member.id] = member
    activeMembers[player.UserId] = activeMembers[player.UserId] or {}
    table.insert(activeMembers[player.UserId], member.id)
    
    -- Update player data
    playerData.memberCount = (playerData.memberCount or 0) + 1
    playerData.members = playerData.members or {}
    table.insert(playerData.members, member.id)
    
    -- Create physical member in workspace
    self:CreatePhysicalMember(member)
    
    return member
end

function MembershipSystem:CalculateGymAttractiveness(player)
    local equipmentSystem = self:GetSystem("EquipmentSystem")
    local tileSystem = self:GetSystem("TileSystem")
    local attractiveness = 0.5 -- Base attractiveness
    
    -- Check equipment variety and condition
    local equipment = equipmentSystem:GetAllEquipment()
    if equipment then
        local totalEquipment = 0
        local totalCondition = 0
        
        for _, eq in pairs(equipment) do
            totalEquipment = totalEquipment + 1
            totalCondition = totalCondition + (eq.attributes.durability + eq.attributes.cleanliness) / 2
        end
        
        if totalEquipment > 0 then
            attractiveness = attractiveness + (totalCondition / totalEquipment) * 0.3
        end
    end
    
    -- Check floor space and organization
    local tiles = tileSystem:GetAllTiles()
    if tiles then
        local totalTiles = 0
        local organizedTiles = 0
        
        for _, tile in pairs(tiles) do
            totalTiles = totalTiles + 1
            if tile.equipment then
                organizedTiles = organizedTiles + 1
            end
        end
        
        if totalTiles > 0 then
            attractiveness = attractiveness + (organizedTiles / totalTiles) * 0.2
        end
    end
    
    return math.min(1.0, attractiveness)
end

function MembershipSystem:DetermineMembershipType(attractiveness)
    local membershipTypes = Constants.MEMBERSHIP
    local random = math.random()
    
    if attractiveness > 0.8 and random > 0.7 then
        return "VIP"
    elseif attractiveness > 0.6 and random > 0.5 then
        return "PREMIUM"
    else
        return "BASIC"
    end
end

function MembershipSystem:GeneratePreferences()
    return {
        preferredEquipment = self:GetRandomEquipmentPreferences(),
        preferredTime = math.random(1, 24), -- Hour of day
        workoutDuration = math.random(30, 120), -- Minutes
        frequency = math.random(2, 6) -- Times per week
    }
end

function MembershipSystem:GetRandomEquipmentPreferences()
    local equipmentTypes = {"TREADMILL", "WEIGHT_BENCH", "ELLIPTICAL"}
    local preferences = {}
    local count = math.random(1, #equipmentTypes)
    
    for i = 1, count do
        local index = math.random(1, #equipmentTypes)
        table.insert(preferences, equipmentTypes[index])
        table.remove(equipmentTypes, index)
    end
    
    return preferences
end

function MembershipSystem:CreatePhysicalMember(member)
    local membersFolder = workspace:FindFirstChild("Members")
    if not membersFolder then
        membersFolder = Instance.new("Folder")
        membersFolder.Name = "Members"
        membersFolder.Parent = workspace
    end
    
    -- Create member model
    local model = Instance.new("Model")
    model.Name = string.format("Member_%d", member.id)
    
    -- Create character
    local character = Instance.new("Part")
    character.Name = "Character"
    character.Size = Vector3.new(1, 4, 1)
    character.Anchored = true
    character.CanCollide = true
    character.Parent = model
    
    -- Add membership indicator
    local indicator = Instance.new("BillboardGui")
    indicator.Name = "MembershipIndicator"
    indicator.Size = UDim2.new(0, 50, 0, 10)
    indicator.StudsOffset = Vector3.new(0, 2.5, 0)
    indicator.Parent = character
    
    local bar = Instance.new("Frame")
    bar.Name = "SatisfactionBar"
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.Parent = indicator
    
    -- Add to workspace
    model.Parent = membersFolder
    
    -- Store reference
    member.model = model
end

function MembershipSystem:UpdateMembers()
    local currentTime = os.time()
    
    for playerId, memberIds in pairs(activeMembers) do
        for _, memberId in ipairs(memberIds) do
            local member = memberData[memberId]
            if member then
                -- Update member satisfaction
                self:UpdateMemberSatisfaction(member)
                
                -- Handle member activities
                if not member.currentActivity then
                    self:AssignMemberActivity(member)
                else
                    self:UpdateMemberActivity(member)
                end
                
                -- Check for member departure
                if self:ShouldMemberLeave(member) then
                    self:RemoveMember(member)
                end
            end
        end
    end
end

function MembershipSystem:UpdateMemberSatisfaction(member)
    local equipmentSystem = self:GetSystem("EquipmentSystem")
    local satisfaction = 1.0
    
    -- Check equipment condition
    for equipmentType, usage in pairs(member.equipmentUsage) do
        local equipment = equipmentSystem:GetEquipmentByType(equipmentType)
        if equipment then
            local condition = (equipment.attributes.durability + equipment.attributes.cleanliness) / 2
            satisfaction = satisfaction * (0.5 + condition / 200) -- 0.5-1.5 range
        end
    end
    
    -- Apply membership type satisfaction threshold
    local membershipType = Constants.MEMBERSHIP[member.membershipType]
    if satisfaction < membershipType.satisfactionThreshold then
        member.loyalty = math.max(0, member.loyalty - 0.1)
    else
        member.loyalty = math.min(1.0, member.loyalty + 0.05)
    end
    
    member.satisfaction = satisfaction
    
    -- Update visual indicator
    if member.model then
        local bar = member.model.Character.MembershipIndicator.SatisfactionBar
        if bar then
            bar.Size = UDim2.new(satisfaction, 0, 1, 0)
            bar.BackgroundColor3 = self:GetSatisfactionColor(satisfaction)
        end
    end
end

function MembershipSystem:GetSatisfactionColor(satisfaction)
    if satisfaction > 0.7 then
        return Color3.fromRGB(0, 255, 0)
    elseif satisfaction > 0.4 then
        return Color3.fromRGB(255, 255, 0)
    else
        return Color3.fromRGB(255, 0, 0)
    end
end

function MembershipSystem:AssignMemberActivity(member)
    -- Check if member should visit based on preferences
    local currentHour = os.date("*t").hour
    if math.abs(currentHour - member.preferences.preferredTime) > 2 then
        return
    end
    
    -- Find available equipment
    local equipmentSystem = self:GetSystem("EquipmentSystem")
    local availableEquipment = equipmentSystem:GetAvailableEquipment(member.preferences.preferredEquipment)
    
    if #availableEquipment > 0 then
        local selectedEquipment = availableEquipment[math.random(1, #availableEquipment)]
        member.currentActivity = {
            equipmentId = selectedEquipment.id,
            startTime = os.time(),
            duration = member.preferences.workoutDuration * 60
        }
        
        -- Start using equipment
        equipmentSystem:UseEquipment(selectedEquipment.id, member.id)
    end
end

function MembershipSystem:UpdateMemberActivity(member)
    if not member.currentActivity then return end
    
    local currentTime = os.time()
    local activityDuration = currentTime - member.currentActivity.startTime
    
    if activityDuration >= member.currentActivity.duration then
        -- Activity complete
        local equipmentSystem = self:GetSystem("EquipmentSystem")
        local equipment = equipmentSystem:GetEquipmentData(member.currentActivity.equipmentId)
        
        if equipment then
            member.equipmentUsage[equipment.type] = (member.equipmentUsage[equipment.type] or 0) + 1
        end
        
        member.currentActivity = nil
    end
end

function MembershipSystem:ShouldMemberLeave(member)
    -- Check satisfaction and loyalty
    if member.satisfaction < 0.3 and member.loyalty < 0.2 then
        return true
    end
    
    -- Check if member hasn't visited in a while
    local daysSinceLastVisit = (os.time() - member.lastVisit) / (24 * 3600)
    if daysSinceLastVisit > 7 then
        return true
    end
    
    return false
end

function MembershipSystem:RemoveMember(member)
    -- Remove physical member
    if member.model then
        member.model:Destroy()
    end
    
    -- Update player data
    local dataManager = self:GetSystem("DataManager")
    local playerData = dataManager:GetPlayerData(member.playerId)
    if playerData then
        playerData.memberCount = (playerData.memberCount or 1) - 1
        playerData.members = playerData.members or {}
        
        -- Remove member from player's list
        for i, memberId in ipairs(playerData.members) do
            if memberId == member.id then
                table.remove(playerData.members, i)
                break
            end
        end
    end
    
    -- Remove from active members
    if activeMembers[member.playerId] then
        for i, memberId in ipairs(activeMembers[member.playerId]) do
            if memberId == member.id then
                table.remove(activeMembers[member.playerId], i)
                break
            end
        end
    end
    
    -- Remove member data
    memberData[member.id] = nil
end

function MembershipSystem:GetMemberData(memberId)
    return memberData[memberId]
end

function MembershipSystem:GetActiveMembers(playerId)
    return activeMembers[playerId] or {}
end

function MembershipSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return MembershipSystem 