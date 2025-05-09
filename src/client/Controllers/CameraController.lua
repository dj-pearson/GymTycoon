local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Constants = require(ReplicatedStorage.shared.Constants)

local CameraController = {}
CameraController.__index = CameraController

-- Private variables
local isDragging = false
local lastMousePosition = Vector2.new()
local currentFloor = 1
local cameraOffset = Vector3.new(0, 20, 20)
local cameraAngle = CFrame.fromEulerAnglesXYZ(-math.pi/4, 0, 0)
local targetPosition = Vector3.new()
local isTransitioning = false

function CameraController.new()
    local self = setmetatable({}, CameraController)
    return self
end

function CameraController:Initialize()
    -- Set up input handling
    self:SetupInputHandling()
    
    -- Set up camera movement
    self:SetupCameraMovement()
    
    -- Set initial camera position
    self:UpdateCameraPosition()
    
    print("CameraController initialized")
end

function CameraController:SetupInputHandling()
    -- Handle mouse drag for camera rotation
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            isDragging = true
            lastMousePosition = UserInputService:GetMouseLocation()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            isDragging = false
        end
    end)
    
    -- Handle mouse wheel for zoom
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            self:HandleZoom(input.Position.Z)
        end
    end)
    
    -- Handle keyboard for floor switching
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.PageUp then
            self:SwitchFloor(currentFloor + 1)
        elseif input.KeyCode == Enum.KeyCode.PageDown then
            self:SwitchFloor(currentFloor - 1)
        end
    end)
end

function CameraController:SetupCameraMovement()
    RunService.RenderStepped:Connect(function()
        if isDragging then
            self:HandleRotation()
        end
        
        if not isTransitioning then
            self:UpdateCameraPosition()
        end
    end)
end

function CameraController:HandleRotation()
    local currentMousePosition = UserInputService:GetMouseLocation()
    local delta = currentMousePosition - lastMousePosition
    
    -- Update camera angle based on mouse movement
    cameraAngle = cameraAngle * CFrame.fromEulerAnglesXYZ(0, -delta.X * 0.01, 0)
    
    lastMousePosition = currentMousePosition
end

function CameraController:HandleZoom(direction)
    -- Adjust camera offset based on zoom direction
    local zoomSpeed = 2
    local minDistance = 10
    local maxDistance = 50
    
    local newY = cameraOffset.Y - direction * zoomSpeed
    local newZ = cameraOffset.Z - direction * zoomSpeed
    
    -- Clamp values
    newY = math.clamp(newY, minDistance, maxDistance)
    newZ = math.clamp(newZ, minDistance, maxDistance)
    
    cameraOffset = Vector3.new(cameraOffset.X, newY, newZ)
end

function CameraController:UpdateCameraPosition()
    -- Get current floor position
    local floor = workspace:FindFirstChild("Floors"):FindFirstChild("Floor" .. currentFloor)
    if not floor then return end
    
    targetPosition = floor.Position
    
    -- Calculate camera position
    local cameraPosition = targetPosition + cameraOffset
    local cameraCFrame = CFrame.new(cameraPosition) * cameraAngle
    
    -- Update camera
    Camera.CFrame = cameraCFrame
end

function CameraController:SwitchFloor(floor)
    -- Validate floor number
    local maxFloor = Constants.MAX_FLOORS
    floor = math.clamp(floor, 1, maxFloor)
    
    if floor == currentFloor then return end
    
    -- Start transition
    isTransitioning = true
    
    -- Get target floor
    local targetFloor = workspace:FindFirstChild("Floors"):FindFirstChild("Floor" .. floor)
    if not targetFloor then
        isTransitioning = false
        return
    end
    
    -- Create tween
    local targetPosition = targetFloor.Position + cameraOffset
    local targetCFrame = CFrame.new(targetPosition) * cameraAngle
    
    local tweenInfo = TweenInfo.new(
        1, -- Time
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(Camera, tweenInfo, {
        CFrame = targetCFrame
    })
    
    tween.Completed:Connect(function()
        currentFloor = floor
        isTransitioning = false
    end)
    
    tween:Play()
end

function CameraController:GetCurrentFloor()
    return currentFloor
end

function CameraController:Cleanup()
    -- Clean up any connections or temporary objects
    isDragging = false
    isTransitioning = false
end

return CameraController 