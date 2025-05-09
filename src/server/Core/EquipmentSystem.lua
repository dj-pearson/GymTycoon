local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(ReplicatedStorage.shared.Constants)

local EquipmentSystem = {}
EquipmentSystem.__index = EquipmentSystem

-- Private variables
local equipmentData = {}
local equipmentTemplates = {}

function EquipmentSystem.new()
    local self = setmetatable({}, EquipmentSystem)
    return self
end

function EquipmentSystem:Initialize()
    -- Load equipment templates
    self:LoadEquipmentTemplates()
    
    -- Start maintenance check loop
    task.spawn(function()
        while true do
            task.wait(60) -- Check equipment every minute
            self:CheckEquipmentStatus()
        end
    end)
    
    print("EquipmentSystem initialized")
end

function EquipmentSystem:LoadEquipmentTemplates()
    -- Define equipment templates with their attributes
    equipmentTemplates = {
        TREADMILL = {
            name = "Treadmill",
            category = "Cardio",
            baseCost = 1000,
            maintenanceCost = 100,
            durability = 100,
            cleanliness = 100,
            popularity = 0.8,
            usageTime = 30, -- seconds
            satisfaction = 0.7,
            maintenanceInterval = 300, -- 5 minutes
            decayRate = 0.1, -- per minute
            maxUsers = 1
        },
        WEIGHT_BENCH = {
            name = "Weight Bench",
            category = "Strength",
            baseCost = 800,
            maintenanceCost = 80,
            durability = 100,
            cleanliness = 100,
            popularity = 0.6,
            usageTime = 45,
            satisfaction = 0.6,
            maintenanceInterval = 400,
            decayRate = 0.08,
            maxUsers = 1
        },
        ELLIPTICAL = {
            name = "Elliptical",
            category = "Cardio",
            baseCost = 1200,
            maintenanceCost = 120,
            durability = 100,
            cleanliness = 100,
            popularity = 0.7,
            usageTime = 35,
            satisfaction = 0.75,
            maintenanceInterval = 350,
            decayRate = 0.09,
            maxUsers = 1
        }
    }
end

function EquipmentSystem:CreateEquipment(equipmentType, position, floor)
    local template = equipmentTemplates[equipmentType]
    if not template then return nil end
    
    -- Create equipment instance
    local equipment = {
        id = #equipmentData + 1,
        type = equipmentType,
        position = position,
        floor = floor,
        attributes = {
            durability = template.durability,
            cleanliness = template.cleanliness,
            popularity = template.popularity,
            lastMaintenance = os.time(),
            lastCleaning = os.time(),
            currentUsers = 0
        },
        template = template
    }
    
    -- Store equipment data
    equipmentData[equipment.id] = equipment
    
    -- Create physical equipment in workspace
    self:CreatePhysicalEquipment(equipment)
    
    return equipment
end

function EquipmentSystem:CreatePhysicalEquipment(equipment)
    local equipmentFolder = workspace:FindFirstChild("Equipment")
    if not equipmentFolder then
        equipmentFolder = Instance.new("Folder")
        equipmentFolder.Name = "Equipment"
        equipmentFolder.Parent = workspace
    end
    
    -- Create equipment model
    local model = Instance.new("Model")
    model.Name = string.format("%s_%d", equipment.type, equipment.id)
    
    -- Create base part
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(4, 0.5, 4)
    base.Position = equipment.position
    base.Anchored = true
    base.CanCollide = true
    base.Parent = model
    
    -- Create equipment part
    local equipmentPart = Instance.new("Part")
    equipmentPart.Name = "Equipment"
    equipmentPart.Size = Vector3.new(3, 2, 3)
    equipmentPart.Position = equipment.position + Vector3.new(0, 1.25, 0)
    equipmentPart.Anchored = true
    equipmentPart.CanCollide = true
    equipmentPart.Parent = model
    
    -- Add status indicators
    local durabilityIndicator = Instance.new("BillboardGui")
    durabilityIndicator.Name = "DurabilityIndicator"
    durabilityIndicator.Size = UDim2.new(0, 50, 0, 10)
    durabilityIndicator.StudsOffset = Vector3.new(0, 2.5, 0)
    durabilityIndicator.Parent = equipmentPart
    
    local durabilityBar = Instance.new("Frame")
    durabilityBar.Name = "DurabilityBar"
    durabilityBar.Size = UDim2.new(1, 0, 1, 0)
    durabilityBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    durabilityBar.Parent = durabilityIndicator
    
    -- Add to workspace
    model.Parent = equipmentFolder
    
    -- Store reference
    equipment.model = model
end

function EquipmentSystem:CheckEquipmentStatus()
    local currentTime = os.time()
    
    for id, equipment in pairs(equipmentData) do
        -- Update durability and cleanliness
        local timeSinceMaintenance = currentTime - equipment.attributes.lastMaintenance
        local timeSinceCleaning = currentTime - equipment.attributes.lastCleaning
        
        -- Calculate decay
        local maintenanceDecay = (timeSinceMaintenance / 60) * equipment.template.decayRate
        local cleaningDecay = (timeSinceCleaning / 60) * (equipment.template.decayRate * 0.5)
        
        -- Apply decay
        equipment.attributes.durability = math.max(0, equipment.attributes.durability - maintenanceDecay)
        equipment.attributes.cleanliness = math.max(0, equipment.attributes.cleanliness - cleaningDecay)
        
        -- Update visual indicators
        self:UpdateEquipmentVisuals(equipment)
    end
end

function EquipmentSystem:UpdateEquipmentVisuals(equipment)
    if not equipment.model then return end
    
    local durabilityBar = equipment.model.Equipment.DurabilityIndicator.DurabilityBar
    if durabilityBar then
        -- Update durability bar color and size
        local durability = equipment.attributes.durability
        durabilityBar.Size = UDim2.new(durability / 100, 0, 1, 0)
        
        -- Update color based on durability
        if durability > 70 then
            durabilityBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif durability > 30 then
            durabilityBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            durabilityBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

function EquipmentSystem:MaintainEquipment(equipmentId)
    local equipment = equipmentData[equipmentId]
    if not equipment then return false end
    
    -- Check if maintenance is needed
    local currentTime = os.time()
    local timeSinceMaintenance = currentTime - equipment.attributes.lastMaintenance
    
    if timeSinceMaintenance < equipment.template.maintenanceInterval then
        return false, "Equipment doesn't need maintenance yet"
    end
    
    -- Perform maintenance
    equipment.attributes.durability = 100
    equipment.attributes.lastMaintenance = currentTime
    
    -- Update visuals
    self:UpdateEquipmentVisuals(equipment)
    
    return true, "Equipment maintained successfully"
end

function EquipmentSystem:CleanEquipment(equipmentId)
    local equipment = equipmentData[equipmentId]
    if not equipment then return false end
    
    -- Perform cleaning
    equipment.attributes.cleanliness = 100
    equipment.attributes.lastCleaning = os.time()
    
    -- Update visuals
    self:UpdateEquipmentVisuals(equipment)
    
    return true, "Equipment cleaned successfully"
end

function EquipmentSystem:UseEquipment(equipmentId, userId)
    local equipment = equipmentData[equipmentId]
    if not equipment then return false end
    
    -- Check if equipment is available
    if equipment.attributes.currentUsers >= equipment.template.maxUsers then
        return false, "Equipment is currently in use"
    end
    
    -- Check if equipment is in good condition
    if equipment.attributes.durability < 20 or equipment.attributes.cleanliness < 20 then
        return false, "Equipment needs maintenance or cleaning"
    end
    
    -- Start usage
    equipment.attributes.currentUsers = equipment.attributes.currentUsers + 1
    
    -- Schedule usage completion
    task.delay(equipment.template.usageTime, function()
        if equipmentData[equipmentId] then
            equipment.attributes.currentUsers = equipment.attributes.currentUsers - 1
        end
    end)
    
    return true, "Started using equipment"
end

function EquipmentSystem:GetEquipmentData(equipmentId)
    return equipmentData[equipmentId]
end

function EquipmentSystem:GetEquipmentTemplate(equipmentType)
    return equipmentTemplates[equipmentType]
end

function EquipmentSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return EquipmentSystem 