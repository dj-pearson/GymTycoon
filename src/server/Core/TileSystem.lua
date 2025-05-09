local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(ReplicatedStorage.shared.Constants)

local TileSystem = {}
TileSystem.__index = TileSystem

-- Private variables
local tileData = {}
local tileTemplates = {}

function TileSystem.new()
    local self = setmetatable({}, TileSystem)
    return self
end

function TileSystem:Initialize()
    -- Load tile templates
    self:LoadTileTemplates()
    
    print("TileSystem initialized")
end

function TileSystem:LoadTileTemplates()
    -- Define tile templates with their attributes
    tileTemplates = {
        FLOOR = {
            name = "Floor",
            category = "Basic",
            baseCost = 100,
            canPlaceEquipment = false,
            walkable = true
        },
        CARDIO_AREA = {
            name = "Cardio Area",
            category = "Cardio",
            baseCost = 500,
            canPlaceEquipment = true,
            equipmentTypes = {"TREADMILL", "ELLIPTICAL"},
            walkable = true
        },
        STRENGTH_AREA = {
            name = "Strength Area",
            category = "Strength",
            baseCost = 500,
            canPlaceEquipment = true,
            equipmentTypes = {"WEIGHT_BENCH"},
            walkable = true
        },
        WALL = {
            name = "Wall",
            category = "Basic",
            baseCost = 200,
            canPlaceEquipment = false,
            walkable = false
        }
    }
end

function TileSystem:CreateTile(tileType, position, floor)
    local template = tileTemplates[tileType]
    if not template then return nil end
    
    -- Create tile instance
    local tile = {
        id = #tileData + 1,
        type = tileType,
        position = position,
        floor = floor,
        equipment = nil
    }
    
    -- Store tile data
    tileData[tile.id] = tile
    
    -- Create physical tile in workspace
    self:CreatePhysicalTile(tile)
    
    return tile
end

function TileSystem:CreatePhysicalTile(tile)
    local tilesFolder = workspace:FindFirstChild("Tiles")
    if not tilesFolder then
        tilesFolder = Instance.new("Folder")
        tilesFolder.Name = "Tiles"
        tilesFolder.Parent = workspace
    end
    
    -- Create tile model
    local model = Instance.new("Model")
    model.Name = string.format("Tile_%d_%d_%d", tile.position.X, tile.position.Y, tile.position.Z)
    
    -- Create base part
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(Constants.GRID_SIZE, 0.5, Constants.GRID_SIZE)
    base.Position = tile.position
    base.Anchored = true
    base.CanCollide = true
    base.Parent = model
    
    -- Set material and color based on tile type
    local template = tileTemplates[tile.type]
    if template then
        if template.category == "Cardio" then
            base.Color = Color3.fromRGB(255, 200, 200) -- Light red
        elseif template.category == "Strength" then
            base.Color = Color3.fromRGB(200, 200, 255) -- Light blue
        else
            base.Color = Color3.fromRGB(200, 200, 200) -- Light gray
        end
    end
    
    -- Add to workspace
    model.Parent = tilesFolder
    
    -- Store reference
    tile.model = model
end

function TileSystem:PlaceEquipment(tileId, equipmentType)
    local tile = tileData[tileId]
    if not tile then return false, "Tile not found" end
    
    -- Check if tile can have equipment
    local template = tileTemplates[tile.type]
    if not template.canPlaceEquipment then
        return false, "This tile type cannot have equipment"
    end
    
    -- Check if equipment type is allowed
    if template.equipmentTypes and not table.find(template.equipmentTypes, equipmentType) then
        return false, "This equipment type is not allowed on this tile"
    end
    
    -- Check if tile already has equipment
    if tile.equipment then
        return false, "Tile already has equipment"
    end
    
    -- Create equipment
    local equipmentSystem = self:GetSystem("EquipmentSystem")
    local equipment = equipmentSystem:CreateEquipment(equipmentType, tile.position, tile.floor)
    
    if not equipment then
        return false, "Failed to create equipment"
    end
    
    -- Link equipment to tile
    tile.equipment = equipment.id
    
    return true, "Equipment placed successfully"
end

function TileSystem:RemoveEquipment(tileId)
    local tile = tileData[tileId]
    if not tile or not tile.equipment then return false, "No equipment to remove" end
    
    -- Remove physical equipment
    local equipmentSystem = self:GetSystem("EquipmentSystem")
    local equipment = equipmentSystem:GetEquipmentData(tile.equipment)
    
    if equipment and equipment.model then
        equipment.model:Destroy()
    end
    
    -- Clear equipment reference
    tile.equipment = nil
    
    return true, "Equipment removed successfully"
end

function TileSystem:GetTileData(tileId)
    return tileData[tileId]
end

function TileSystem:GetTileTemplate(tileType)
    return tileTemplates[tileType]
end

function TileSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return TileSystem 