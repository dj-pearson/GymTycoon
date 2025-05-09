local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Constants = require(ReplicatedStorage.shared.Constants)

local PlayerController = {}
PlayerController.__index = PlayerController

-- Private variables
local remotes = {}
local selectedTile = nil
local isPlacingTile = false
local tilePreview = nil
local currentFloor = 1
local selectedEquipment = nil

function PlayerController.new()
    local self = setmetatable({}, PlayerController)
    return self
end

function PlayerController:Initialize()
    -- Get remote events
    remotes = {
        placeTile = ReplicatedStorage:WaitForChild("PlaceTile"),
        placeEquipment = ReplicatedStorage:WaitForChild("PlaceEquipment"),
        removeEquipment = ReplicatedStorage:WaitForChild("RemoveEquipment"),
        useEquipment = ReplicatedStorage:WaitForChild("UseEquipment"),
        cleanEquipment = ReplicatedStorage:WaitForChild("CleanEquipment"),
        maintainEquipment = ReplicatedStorage:WaitForChild("MaintainEquipment")
    }
    
    -- Setup input handling
    self:SetupInputHandling()
    
    -- Setup mouse tracking
    self:SetupMouseTracking()
    
    print("PlayerController initialized")
end

function PlayerController:SetupInputHandling()
    -- Tile placement
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isPlacingTile then
                self:AttemptPlaceTile()
            else
                self:AttemptInteractWithEquipment()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            self:CancelTilePlacement()
        end
        
        -- Equipment interaction
        if input.KeyCode == Enum.KeyCode.E then
            self:UseEquipment()
        elseif input.KeyCode == Enum.KeyCode.C then
            self:CleanEquipment()
        elseif input.KeyCode == Enum.KeyCode.M then
            self:MaintainEquipment()
        end
    end)
end

function PlayerController:SetupMouseTracking()
    RunService.RenderStepped:Connect(function()
        if isPlacingTile and tilePreview then
            local hit = self:GetMouseHit()
            if hit then
                local position = self:RoundToGrid(hit.Position)
                tilePreview:SetPrimaryPartCFrame(CFrame.new(position))
                
                -- Update preview color based on placement validity
                local canPlace = self:CanPlaceTile(position)
                tilePreview.PrimaryPart.Color = canPlace and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    end)
end

function PlayerController:GetMouseHit()
    local mouse = Players.LocalPlayer:GetMouse()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000)
    return hit
end

function PlayerController:RoundToGrid(position)
    local gridSize = Constants.GRID_SIZE
    return Vector3.new(
        math.floor(position.X / gridSize) * gridSize,
        position.Y,
        math.floor(position.Z / gridSize) * gridSize
    )
end

function PlayerController:CanPlaceTile(position)
    -- Check if position is within floor bounds
    local floorBounds = Constants.FLOOR_BOUNDS[currentFloor]
    if not floorBounds then return false end
    
    if position.X < floorBounds.min.X or position.X > floorBounds.max.X or
       position.Z < floorBounds.min.Z or position.Z > floorBounds.max.Z then
        return false
    end
    
    -- Check if position is already occupied
    local existingTile = workspace.Tiles:FindFirstChild(string.format("Tile_%d_%d_%d", position.X, position.Y, position.Z))
    if existingTile then return false end
    
    return true
end

function PlayerController:AttemptPlaceTile()
    if not isPlacingTile or not tilePreview then return end
    
    local position = tilePreview.PrimaryPart.Position
    if not self:CanPlaceTile(position) then return end
    
    remotes.placeTile:FireServer(selectedTile, position, currentFloor)
    self:CancelTilePlacement()
end

function PlayerController:StartTilePlacement(tileType)
    if isPlacingTile then
        self:CancelTilePlacement()
    end
    
    selectedTile = tileType
    isPlacingTile = true
    
    -- Create preview model
    tilePreview = Instance.new("Model")
    local part = Instance.new("Part")
    part.Size = Vector3.new(Constants.GRID_SIZE, 0.5, Constants.GRID_SIZE)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.Parent = tilePreview
    tilePreview.PrimaryPart = part
    tilePreview.Parent = workspace
end

function PlayerController:CancelTilePlacement()
    if tilePreview then
        tilePreview:Destroy()
        tilePreview = nil
    end
    isPlacingTile = false
    selectedTile = nil
end

function PlayerController:AttemptInteractWithEquipment()
    local hit = self:GetMouseHit()
    if not hit then return end
    
    local equipment = hit.Instance:FindFirstAncestorOfClass("Model")
    if not equipment or not equipment:GetAttribute("EquipmentId") then return end
    
    selectedEquipment = equipment:GetAttribute("EquipmentId")
end

function PlayerController:UseEquipment()
    if not selectedEquipment then return end
    remotes.useEquipment:FireServer(selectedEquipment)
end

function PlayerController:CleanEquipment()
    if not selectedEquipment then return end
    remotes.cleanEquipment:FireServer(selectedEquipment)
end

function PlayerController:MaintainEquipment()
    if not selectedEquipment then return end
    remotes.maintainEquipment:FireServer(selectedEquipment)
end

function PlayerController:SetCurrentFloor(floor)
    currentFloor = floor
end

function PlayerController:Cleanup()
    self:CancelTilePlacement()
    selectedEquipment = nil
end

return PlayerController 