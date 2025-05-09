local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Constants = require(ReplicatedStorage.shared.Constants)

local UIController = {}
UIController.__index = UIController

-- Private variables
local ui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UI")
local notifications = {}
local activeScreens = {}

function UIController.new()
    local self = setmetatable({}, UIController)
    return self
end

function UIController:Initialize()
    -- Create UI folders
    self:CreateUIFolders()
    
    -- Create HUD
    self:CreateHUD()
    
    -- Create notification system
    self:CreateNotificationSystem()
    
    print("UIController initialized")
end

function UIController:CreateUIFolders()
    local folders = {
        "HUD",
        "Screens",
        "Components",
        "Notifications"
    }
    
    for _, folderName in ipairs(folders) do
        local folder = Instance.new("Folder")
        folder.Name = folderName
        folder.Parent = ui
    end
end

function UIController:CreateHUD()
    local hud = Instance.new("ScreenGui")
    hud.Name = "HUD"
    hud.ResetOnSpawn = false
    hud.Parent = ui.HUD
    
    -- Money display
    local moneyFrame = Instance.new("Frame")
    moneyFrame.Name = "MoneyFrame"
    moneyFrame.Size = UDim2.new(0, 200, 0, 50)
    moneyFrame.Position = UDim2.new(0, 10, 0, 10)
    moneyFrame.BackgroundTransparency = 0.5
    moneyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    moneyFrame.Parent = hud
    
    local moneyLabel = Instance.new("TextLabel")
    moneyLabel.Name = "MoneyLabel"
    moneyLabel.Size = UDim2.new(1, 0, 1, 0)
    moneyLabel.BackgroundTransparency = 1
    moneyLabel.Text = "Money: $0"
    moneyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    moneyLabel.TextSize = 24
    moneyLabel.Parent = moneyFrame
    
    -- Level display
    local levelFrame = Instance.new("Frame")
    levelFrame.Name = "LevelFrame"
    levelFrame.Size = UDim2.new(0, 200, 0, 50)
    levelFrame.Position = UDim2.new(0, 10, 0, 70)
    levelFrame.BackgroundTransparency = 0.5
    levelFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    levelFrame.Parent = hud
    
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(1, 0, 1, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: 1"
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.TextSize = 24
    levelLabel.Parent = levelFrame
    
    -- Challenge display
    local challengeFrame = Instance.new("Frame")
    challengeFrame.Name = "ChallengeFrame"
    challengeFrame.Size = UDim2.new(0, 300, 0, 100)
    challengeFrame.Position = UDim2.new(1, -310, 0, 10)
    challengeFrame.BackgroundTransparency = 0.5
    challengeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    challengeFrame.Parent = hud
    
    local challengeLabel = Instance.new("TextLabel")
    challengeLabel.Name = "ChallengeLabel"
    challengeLabel.Size = UDim2.new(1, 0, 0.3, 0)
    challengeLabel.BackgroundTransparency = 1
    challengeLabel.Text = "Current Challenge"
    challengeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    challengeLabel.TextSize = 20
    challengeLabel.Parent = challengeFrame
    
    local challengeProgress = Instance.new("TextLabel")
    challengeProgress.Name = "ChallengeProgress"
    challengeProgress.Size = UDim2.new(1, 0, 0.7, 0)
    challengeProgress.Position = UDim2.new(0, 0, 0.3, 0)
    challengeProgress.BackgroundTransparency = 1
    challengeProgress.Text = "0/0"
    challengeProgress.TextColor3 = Color3.fromRGB(255, 255, 255)
    challengeProgress.TextSize = 18
    challengeProgress.Parent = challengeFrame
end

function UIController:CreateNotificationSystem()
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "Notifications"
    notificationGui.ResetOnSpawn = false
    notificationGui.Parent = ui.Notifications
    
    -- Create notification template
    local template = Instance.new("Frame")
    template.Name = "NotificationTemplate"
    template.Size = UDim2.new(0, 300, 0, 50)
    template.BackgroundTransparency = 0.5
    template.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    template.Visible = false
    template.Parent = notificationGui
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0.4, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Parent = template
    
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, 0, 0.6, 0)
    message.Position = UDim2.new(0, 0, 0.4, 0)
    message.BackgroundTransparency = 1
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 16
    message.Parent = template
end

function UIController:ShowNotification(title, message)
    local notificationGui = ui.Notifications:WaitForChild("Notifications")
    local template = notificationGui:WaitForChild("NotificationTemplate")
    
    -- Create new notification
    local notification = template:Clone()
    notification.Name = "Notification_" .. os.time()
    notification.Visible = true
    
    -- Set position based on existing notifications
    local yOffset = #notifications * 60
    notification.Position = UDim2.new(1, -310, 0, 10 + yOffset)
    
    -- Set content
    notification.Title.Text = title
    notification.Message.Text = message
    
    -- Add to notifications list
    table.insert(notifications, notification)
    notification.Parent = notificationGui
    
    -- Animate in
    notification.Position = UDim2.new(1, 10, 0, 10 + yOffset)
    notification:TweenPosition(
        UDim2.new(1, -310, 0, 10 + yOffset),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.5
    )
    
    -- Remove after delay
    task.delay(5, function()
        if notification and notification.Parent then
            notification:TweenPosition(
                UDim2.new(1, 10, 0, 10 + yOffset),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Quad,
                0.5,
                true,
                function()
                    notification:Destroy()
                    table.remove(notifications, table.find(notifications, notification))
                    self:UpdateNotificationPositions()
                end
            )
        end
    end)
end

function UIController:UpdateNotificationPositions()
    for i, notification in ipairs(notifications) do
        local yOffset = (i - 1) * 60
        notification.Position = UDim2.new(1, -310, 0, 10 + yOffset)
    end
end

function UIController:UpdateChallengeProgress(challengeType, progress)
    local challengeFrame = ui.HUD.HUD:WaitForChild("ChallengeFrame")
    local challengeProgress = challengeFrame:WaitForChild("ChallengeProgress")
    
    -- Update progress display
    challengeProgress.Text = string.format("%d/%d", progress.current, progress.required)
end

function UIController:ShowFloorUnlocked(floor)
    self:ShowNotification(
        "New Floor Unlocked!",
        string.format("Floor %d is now available!", floor)
    )
end

function UIController:UpdateMoney(amount)
    local moneyLabel = ui.HUD.HUD:WaitForChild("MoneyFrame"):WaitForChild("MoneyLabel")
    moneyLabel.Text = string.format("Money: $%d", amount)
end

function UIController:UpdateLevel(level)
    local levelLabel = ui.HUD.HUD:WaitForChild("LevelFrame"):WaitForChild("LevelLabel")
    levelLabel.Text = string.format("Level: %d", level)
end

function UIController:Cleanup()
    -- Clean up any UI elements or connections
    for _, screen in pairs(activeScreens) do
        if screen and screen.Parent then
            screen:Destroy()
        end
    end
end

return UIController 