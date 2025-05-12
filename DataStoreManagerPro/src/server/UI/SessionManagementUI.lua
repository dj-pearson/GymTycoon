-- Session Management UI component for DataExplorer
local SessionManagementUI = {}

function SessionManagementUI.initSessionManagementUI(DataExplorer, SessionManager)
    -- Create the session management UI container (initially invisible)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    local sessionContainer = Instance.new("Frame")
    sessionContainer.Size = UDim2.new(1, 0, 1, 0)
    sessionContainer.Position = UDim2.new(0, 0, 0, 0)
    sessionContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sessionContainer.BorderSizePixel = 0
    sessionContainer.Visible = false
    sessionContainer.ZIndex = 10
    sessionContainer.Parent = mainFrame
    
    DataExplorer.sessionManagementUI = sessionContainer
    
    -- Create the session management UI
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = sessionContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Session Management"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Font = Enum.Font.SourceSansBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 80, 0, 30)
    closeButton.Position = UDim2.new(1, -90, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "Close"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        sessionContainer.Visible = false
    end)
    
    -- Create content for session management
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, 0, 1, -40)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = sessionContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    -- Session Info Section
    local sessionInfoCard = Instance.new("Frame")
    sessionInfoCard.Size = UDim2.new(0.9, 0, 0, 100)
    sessionInfoCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sessionInfoCard.BorderSizePixel = 0
    sessionInfoCard.LayoutOrder = 1
    sessionInfoCard.Parent = contentArea
    
    -- Add rounded corners
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = sessionInfoCard
    
    local sessionTitle = Instance.new("TextLabel")
    sessionTitle.Size = UDim2.new(1, 0, 0, 30)
    sessionTitle.Position = UDim2.new(0, 0, 0, 0)
    sessionTitle.BackgroundTransparency = 1
    sessionTitle.Text = "Current Session"
    sessionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sessionTitle.Font = Enum.Font.SourceSansBold
    sessionTitle.TextSize = 16
    sessionTitle.Parent = sessionInfoCard
    
    local sessionIdLabel = Instance.new("TextLabel")
    sessionIdLabel.Size = UDim2.new(1, -20, 0, 20)
    sessionIdLabel.Position = UDim2.new(0, 10, 0, 30)
    sessionIdLabel.BackgroundTransparency = 1
    sessionIdLabel.Text = "Session ID: " .. DataExplorer.sessionId
    sessionIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    sessionIdLabel.Font = Enum.Font.SourceSans
    sessionIdLabel.TextSize = 14
    sessionIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    sessionIdLabel.Parent = sessionInfoCard
    
    local serverIdLabel = Instance.new("TextLabel")
    serverIdLabel.Size = UDim2.new(1, -20, 0, 20)
    serverIdLabel.Position = UDim2.new(0, 10, 0, 50)
    serverIdLabel.BackgroundTransparency = 1
    serverIdLabel.Text = "Server ID: " .. tostring(game.JobId)
    serverIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    serverIdLabel.Font = Enum.Font.SourceSans
    serverIdLabel.TextSize = 14
    serverIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    serverIdLabel.Parent = sessionInfoCard
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -20, 0, 20)
    timeLabel.Position = UDim2.new(0, 10, 0, 70)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Session Started: " .. os.date("%Y-%m-%d %H:%M:%S")
    timeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    timeLabel.Font = Enum.Font.SourceSans
    timeLabel.TextSize = 14
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = sessionInfoCard
    
    -- Active Locks Section
    local locksCard = Instance.new("Frame")
    locksCard.Size = UDim2.new(0.9, 0, 0, 300)
    locksCard.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    locksCard.BorderSizePixel = 0
    locksCard.LayoutOrder = 2
    locksCard.Parent = contentArea
    
    -- Add rounded corners
    local locksCardCorner = Instance.new("UICorner")
    locksCardCorner.CornerRadius = UDim.new(0, 8)
    locksCardCorner.Parent = locksCard
    
    local locksTitle = Instance.new("TextLabel")
    locksTitle.Size = UDim2.new(1, 0, 0, 30)
    locksTitle.Position = UDim2.new(0, 0, 0, 0)
    locksTitle.BackgroundTransparency = 1
    locksTitle.Text = "Active Locks"
    locksTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    locksTitle.Font = Enum.Font.SourceSansBold
    locksTitle.TextSize = 16
    locksTitle.Parent = locksCard
    
    local refreshButton = Instance.new("TextButton")
    refreshButton.Size = UDim2.new(0, 80, 0, 24)
    refreshButton.Position = UDim2.new(1, -90, 0, 3)
    refreshButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "Refresh"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.Font = Enum.Font.SourceSans
    refreshButton.TextSize = 14
    refreshButton.Parent = locksCard
    
    -- Add rounded corners to button
    local refreshButtonCorner = Instance.new("UICorner")
    refreshButtonCorner.CornerRadius = UDim.new(0, 4)
    refreshButtonCorner.Parent = refreshButton
    
    local locksContainer = Instance.new("ScrollingFrame")
    locksContainer.Size = UDim2.new(1, -20, 1, -40)
    locksContainer.Position = UDim2.new(0, 10, 0, 35)
    locksContainer.BackgroundTransparency = 1
    locksContainer.BorderSizePixel = 0
    locksContainer.ScrollBarThickness = 6
    locksContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    locksContainer.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    locksContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    locksContainer.Parent = locksCard
    
    local locksLayout = Instance.new("UIListLayout")
    locksLayout.Padding = UDim.new(0, 5)
    locksLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    locksLayout.Parent = locksContainer
    
    -- Function to update the locks list
    local function updateLocksList()
        -- Clear existing items
        for _, child in ipairs(locksContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Get active locks from SessionManager
        local activeLocks = SessionManager.getActiveLocks()
        
        if #activeLocks > 0 then
            for i, lockInfo in ipairs(activeLocks) do
                local lockItem = Instance.new("Frame")
                lockItem.Size = UDim2.new(1, 0, 0, 60)
                lockItem.BackgroundColor3 = lockInfo.isExpired and Color3.fromRGB(70, 30, 30) or Color3.fromRGB(50, 50, 60)
                lockItem.BorderSizePixel = 0
                lockItem.Name = "LockItem_" .. i
                lockItem.Parent = locksContainer
                
                -- Add rounded corners
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 6)
                itemCorner.Parent = lockItem
                
                -- Status indicator
                local statusIndicator = Instance.new("Frame")
                statusIndicator.Size = UDim2.new(0, 4, 1, -10)
                statusIndicator.Position = UDim2.new(0, 5, 0, 5)
                statusIndicator.BackgroundColor3 = lockInfo.isExpired and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 180, 80)
                statusIndicator.BorderSizePixel = 0
                statusIndicator.Parent = lockItem
                
                -- Add rounded corners to indicator
                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0, 2)
                indicatorCorner.Parent = statusIndicator
                
                -- DataStore name
                local dsNameLabel = Instance.new("TextLabel")
                dsNameLabel.Size = UDim2.new(1, -80, 0, 20)
                dsNameLabel.Position = UDim2.new(0, 15, 0, 5)
                dsNameLabel.BackgroundTransparency = 1
                dsNameLabel.Text = "DataStore: " .. lockInfo.dataStoreName
                dsNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                dsNameLabel.Font = Enum.Font.SourceSansSemibold
                dsNameLabel.TextSize = 14
                dsNameLabel.TextXAlignment = Enum.TextXAlignment.Left
                dsNameLabel.Parent = lockItem
                
                -- Key name
                local keyNameLabel = Instance.new("TextLabel")
                keyNameLabel.Size = UDim2.new(1, -80, 0, 20)
                keyNameLabel.Position = UDim2.new(0, 15, 0, 25)
                keyNameLabel.BackgroundTransparency = 1
                keyNameLabel.Text = "Key: " .. lockInfo.keyName
                keyNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                keyNameLabel.Font = Enum.Font.SourceSans
                keyNameLabel.TextSize = 14
                keyNameLabel.TextXAlignment = Enum.TextXAlignment.Left
                keyNameLabel.Parent = lockItem
                
                -- Session ID (truncated for UI)
                local sessionIdText = lockInfo.sessionId
                if #sessionIdText > 20 then
                    sessionIdText = sessionIdText:sub(1, 17) .. "..."
                end
                
                local sessionLabel = Instance.new("TextLabel")
                sessionLabel.Size = UDim2.new(1, -160, 0, 20)
                sessionLabel.Position = UDim2.new(0, 15, 0, 45)
                sessionLabel.BackgroundTransparency = 1
                sessionLabel.Text = "Session: " .. sessionIdText
                sessionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                sessionLabel.Font = Enum.Font.SourceSans
                sessionLabel.TextSize = 12
                sessionLabel.TextXAlignment = Enum.TextXAlignment.Left
                sessionLabel.Parent = lockItem
                
                -- Force unlock button
                local unlockButton = Instance.new("TextButton")
                unlockButton.Size = UDim2.new(0, 70, 0, 24)
                unlockButton.Position = UDim2.new(1, -75, 0.5, -12)
                unlockButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
                unlockButton.BorderSizePixel = 0
                unlockButton.Text = "Force Unlock"
                unlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                unlockButton.Font = Enum.Font.SourceSans
                unlockButton.TextSize = 12
                unlockButton.Parent = lockItem
                
                -- Add rounded corners to button
                local unlockButtonCorner = Instance.new("UICorner")
                unlockButtonCorner.CornerRadius = UDim.new(0, 4)
                unlockButtonCorner.Parent = unlockButton
                
                -- Connect unlock button
                unlockButton.MouseButton1Click:Connect(function()
                    -- Call force release on the session manager
                    SessionManager.forceReleaseLock(lockInfo.dataStoreName, lockInfo.keyName)
                    -- Update the locks list
                    updateLocksList()
                    -- Also update the main UI lock status
                    DataExplorer.updateLockStatusUI()
                end)
            end
        else
            -- No locks message
            local noLocksLabel = Instance.new("TextLabel")
            noLocksLabel.Size = UDim2.new(1, 0, 0, 40)
            noLocksLabel.BackgroundTransparency = 1
            noLocksLabel.Text = "No active locks"
            noLocksLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            noLocksLabel.Font = Enum.Font.SourceSans
            noLocksLabel.TextSize = 14
            noLocksLabel.Parent = locksContainer
        end
    end
    
    -- Connect refresh button
    refreshButton.MouseButton1Click:Connect(updateLocksList)
    
    -- Initial update of locks list
    updateLocksList()
    
    -- Connect the session management button in the lock status pane
    if DataExplorer.lockStatusPane then
        local sessionManagementButton = DataExplorer.lockStatusPane:FindFirstChild("SessionManagementButton")
        if sessionManagementButton then
            sessionManagementButton.MouseButton1Click:Connect(function()
                -- Update locks list and show the session management UI
                updateLocksList()
                sessionContainer.Visible = true
            end)
        end
    end
    
    return sessionContainer
end

return SessionManagementUI
