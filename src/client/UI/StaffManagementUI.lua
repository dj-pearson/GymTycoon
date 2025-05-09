local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Constants = require(ReplicatedStorage.shared.Constants)
local UIUtils = require(script.Parent.UIUtils)

local StaffManagementUI = {}
StaffManagementUI.__index = StaffManagementUI

-- Private variables
local screenGui
local staffList
local staffDetails
local hirePanel
local selectedStaff

function StaffManagementUI.new()
    local self = setmetatable({}, StaffManagementUI)
    return self
end

function StaffManagementUI:Initialize()
    -- Create main screen GUI
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StaffManagementUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Create title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    title.BorderSizePixel = 0
    title.Text = "Staff Management"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Create staff list
    staffList = Instance.new("ScrollingFrame")
    staffList.Name = "StaffList"
    staffList.Size = UDim2.new(0.3, 0, 0.8, 0)
    staffList.Position = UDim2.new(0, 0, 0.1, 0)
    staffList.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    staffList.BorderSizePixel = 0
    staffList.ScrollBarThickness = 6
    staffList.Parent = mainFrame
    
    -- Create staff details panel
    staffDetails = Instance.new("Frame")
    staffDetails.Name = "StaffDetails"
    staffDetails.Size = UDim2.new(0.4, 0, 0.8, 0)
    staffDetails.Position = UDim2.new(0.3, 0, 0.1, 0)
    staffDetails.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    staffDetails.BorderSizePixel = 0
    staffDetails.Parent = mainFrame
    
    -- Create hire panel
    hirePanel = Instance.new("Frame")
    hirePanel.Name = "HirePanel"
    hirePanel.Size = UDim2.new(0.3, 0, 0.8, 0)
    hirePanel.Position = UDim2.new(0.7, 0, 0.1, 0)
    hirePanel.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    hirePanel.BorderSizePixel = 0
    hirePanel.Parent = mainFrame
    
    -- Create hire button
    local hireButton = Instance.new("TextButton")
    hireButton.Name = "HireButton"
    hireButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    hireButton.Position = UDim2.new(0.1, 0, 0.85, 0)
    hireButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    hireButton.BorderSizePixel = 0
    hireButton.Text = "Hire New Staff"
    hireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hireButton.TextScaled = true
    hireButton.Font = Enum.Font.GothamBold
    hireButton.Parent = mainFrame
    
    -- Create close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.95, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    -- Set up event handlers
    hireButton.MouseButton1Click:Connect(function()
        self:ShowHirePanel()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    -- Initialize panels
    self:InitializeStaffList()
    self:InitializeStaffDetails()
    self:InitializeHirePanel()
    
    -- Hide UI initially
    self:Hide()
end

function StaffManagementUI:InitializeStaffList()
    -- Create list layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = staffList
    
    -- Create staff item template
    local function createStaffItem(staff)
        local item = Instance.new("TextButton")
        item.Name = "Staff_" .. staff.id
        item.Size = UDim2.new(1, -10, 0, 50)
        item.Position = UDim2.new(0, 5, 0, 0)
        item.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        item.BorderSizePixel = 0
        item.Text = staff.name
        item.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.TextScaled = true
        item.Font = Enum.Font.GothamSemibold
        item.Parent = staffList
        
        -- Add click handler
        item.MouseButton1Click:Connect(function()
            self:SelectStaff(staff)
        end)
        
        return item
    end
    
    -- Update staff list
    self.UpdateStaffList = function(staffData)
        -- Clear existing items
        for _, child in pairs(staffList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Add staff items
        for _, staff in pairs(staffData) do
            createStaffItem(staff)
        end
    end
end

function StaffManagementUI:InitializeStaffDetails()
    -- Create details layout
    local detailsLayout = Instance.new("UIGridLayout")
    detailsLayout.CellSize = UDim2.new(1, -20, 0, 30)
    detailsLayout.CellPadding = UDim2.new(0, 0, 0, 10)
    detailsLayout.Parent = staffDetails
    
    -- Create detail labels
    local labels = {
        "Name",
        "Type",
        "Experience",
        "Efficiency",
        "Energy",
        "Current Task"
    }
    
    for _, label in ipairs(labels) do
        local labelFrame = Instance.new("Frame")
        labelFrame.Size = UDim2.new(1, 0, 0, 30)
        labelFrame.BackgroundTransparency = 1
        labelFrame.Parent = staffDetails
        
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.4, 0, 1, 0)
        labelText.Position = UDim2.new(0, 0, 0, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label .. ":"
        labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.TextScaled = true
        labelText.Font = Enum.Font.GothamSemibold
        labelText.Parent = labelFrame
        
        local valueText = Instance.new("TextLabel")
        valueText.Name = "Value"
        valueText.Size = UDim2.new(0.6, 0, 1, 0)
        valueText.Position = UDim2.new(0.4, 0, 0, 0)
        valueText.BackgroundTransparency = 1
        valueText.Text = "-"
        valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueText.TextXAlignment = Enum.TextXAlignment.Left
        valueText.TextScaled = true
        valueText.Font = Enum.Font.GothamSemibold
        valueText.Parent = labelFrame
    end
    
    -- Create fire button
    local fireButton = Instance.new("TextButton")
    fireButton.Name = "FireButton"
    fireButton.Size = UDim2.new(0.8, 0, 0, 40)
    fireButton.Position = UDim2.new(0.1, 0, 0.9, 0)
    fireButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fireButton.BorderSizePixel = 0
    fireButton.Text = "Fire Staff"
    fireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fireButton.TextScaled = true
    fireButton.Font = Enum.Font.GothamBold
    fireButton.Parent = staffDetails
    
    fireButton.MouseButton1Click:Connect(function()
        if selectedStaff then
            self:FireStaff(selectedStaff.id)
        end
    end)
end

function StaffManagementUI:InitializeHirePanel()
    -- Create hire options
    local hireOptions = Instance.new("ScrollingFrame")
    hireOptions.Name = "HireOptions"
    hireOptions.Size = UDim2.new(1, -20, 0.8, 0)
    hireOptions.Position = UDim2.new(0, 10, 0, 10)
    hireOptions.BackgroundTransparency = 1
    hireOptions.ScrollBarThickness = 6
    hireOptions.Parent = hirePanel
    
    -- Create options layout
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 10)
    optionsLayout.Parent = hireOptions
    
    -- Create hire option buttons
    for staffType, staffData in pairs(Constants.STAFF) do
        local option = Instance.new("TextButton")
        option.Name = staffType
        option.Size = UDim2.new(1, 0, 0, 100)
        option.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        option.BorderSizePixel = 0
        option.Text = ""
        option.Parent = hireOptions
        
        -- Add staff info
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = staffData.name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = option
        
        local costLabel = Instance.new("TextLabel")
        costLabel.Size = UDim2.new(1, 0, 0.3, 0)
        costLabel.Position = UDim2.new(0, 0, 0.4, 0)
        costLabel.BackgroundTransparency = 1
        costLabel.Text = "Cost: $" .. staffData.hireCost
        costLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        costLabel.TextScaled = true
        costLabel.Font = Enum.Font.GothamSemibold
        costLabel.Parent = option
        
        local salaryLabel = Instance.new("TextLabel")
        salaryLabel.Size = UDim2.new(1, 0, 0.3, 0)
        salaryLabel.Position = UDim2.new(0, 0, 0.7, 0)
        salaryLabel.BackgroundTransparency = 1
        salaryLabel.Text = "Salary: $" .. staffData.salary .. "/day"
        salaryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        salaryLabel.TextScaled = true
        salaryLabel.Font = Enum.Font.GothamSemibold
        salaryLabel.Parent = option
        
        -- Add click handler
        option.MouseButton1Click:Connect(function()
            self:HireStaff(staffType)
        end)
    end
end

function StaffManagementUI:Show()
    screenGui.Enabled = true
    
    -- Animate in
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(screenGui.MainFrame, tweenInfo, {
        Position = UDim2.new(0.1, 0, 0.1, 0),
        Size = UDim2.new(0.8, 0, 0.8, 0)
    })
    tween:Play()
end

function StaffManagementUI:Hide()
    -- Animate out
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(screenGui.MainFrame, tweenInfo, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    
    task.delay(0.3, function()
        screenGui.Enabled = false
    end)
end

function StaffManagementUI:SelectStaff(staff)
    selectedStaff = staff
    
    -- Update details panel
    local details = staffDetails:GetChildren()
    for _, detail in ipairs(details) do
        if detail:IsA("Frame") then
            local valueLabel = detail:FindFirstChild("Value")
            if valueLabel then
                local label = detail:FindFirstChild("TextLabel")
                if label then
                    if label.Text == "Name:" then
                        valueLabel.Text = staff.name
                    elseif label.Text == "Type:" then
                        valueLabel.Text = staff.type
                    elseif label.Text == "Experience:" then
                        valueLabel.Text = string.format("%.1f", staff.experience)
                    elseif label.Text == "Efficiency:" then
                        valueLabel.Text = string.format("%.1f", staff.efficiency)
                    elseif label.Text == "Energy:" then
                        valueLabel.Text = string.format("%.0f%%", staff.energy)
                    elseif label.Text == "Current Task:" then
                        valueLabel.Text = staff.currentTask and staff.currentTask.type or "None"
                    end
                end
            end
        end
    end
end

function StaffManagementUI:ShowHirePanel()
    hirePanel.Visible = true
    staffDetails.Visible = false
end

function StaffManagementUI:HireStaff(staffType)
    -- Send hire request to server
    local remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("HireStaff")
    remote:FireServer(staffType)
    
    -- Hide hire panel
    hirePanel.Visible = false
    staffDetails.Visible = true
end

function StaffManagementUI:FireStaff(staffId)
    -- Send fire request to server
    local remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("FireStaff")
    remote:FireServer(staffId)
    
    -- Clear selection
    selectedStaff = nil
end

function StaffManagementUI:UpdateStaffList(staffData)
    self.UpdateStaffList(staffData)
end

return StaffManagementUI 