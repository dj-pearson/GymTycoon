-- MultiServerCoordination UI component for DataExplorer
local MultiServerCoordinationUI = {}

function MultiServerCoordinationUI.initCoordinationUI(DataExplorer)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open multi-server coordination
    local coordinationButton = Instance.new("TextButton")
    coordinationButton.Size = UDim2.new(0, 150, 0, 30)
    coordinationButton.Position = UDim2.new(1, -320, 0, 50) -- Below other buttons
    coordinationButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
    coordinationButton.BorderSizePixel = 0
    coordinationButton.Text = "Server Coordination"
    coordinationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordinationButton.Font = Enum.Font.SourceSansBold
    coordinationButton.TextSize = 14
    coordinationButton.ZIndex = 5
    coordinationButton.Parent = mainFrame
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = coordinationButton
    
    -- Create the coordination container (initially invisible)
    local coordinationContainer = Instance.new("Frame")
    coordinationContainer.Size = UDim2.new(1, 0, 1, 0)
    coordinationContainer.Position = UDim2.new(0, 0, 0, 0)
    coordinationContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
    coordinationContainer.BorderSizePixel = 0
    coordinationContainer.Visible = false
    coordinationContainer.ZIndex = 10
    coordinationContainer.Parent = mainFrame
    
    -- Save reference to the container
    DataExplorer.coordinationContainer = coordinationContainer
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = coordinationContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Multi-Server Coordination"
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
    local closeButtonCorner = Instance.new("UICorner")
    closeButtonCorner.CornerRadius = UDim.new(0, 4)
    closeButtonCorner.Parent = closeButton
    
    -- Create content area
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, 0, 1, -40)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = coordinationContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    -- Server Status Section
    local statusSection = Instance.new("Frame")
    statusSection.Size = UDim2.new(0.9, 0, 0, 200)
    statusSection.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    statusSection.BorderSizePixel = 0
    statusSection.LayoutOrder = 1
    statusSection.Parent = contentArea
    
    -- Add rounded corners
    local statusSectionCorner = Instance.new("UICorner")
    statusSectionCorner.CornerRadius = UDim.new(0, 8)
    statusSectionCorner.Parent = statusSection
    
    local statusTitle = Instance.new("TextLabel")
    statusTitle.Size = UDim2.new(1, 0, 0, 30)
    statusTitle.Position = UDim2.new(0, 0, 0, 0)
    statusTitle.BackgroundTransparency = 1
    statusTitle.Text = "Server Status"
    statusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusTitle.Font = Enum.Font.SourceSansBold
    statusTitle.TextSize = 16
    statusTitle.Parent = statusSection
    
    local serverListFrame = Instance.new("Frame")
    serverListFrame.Size = UDim2.new(0.95, 0, 0, 160)
    serverListFrame.Position = UDim2.new(0.025, 0, 0, 35)
    serverListFrame.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
    serverListFrame.BorderSizePixel = 0
    serverListFrame.Parent = statusSection
    
    -- Add rounded corners
    local serverListFrameCorner = Instance.new("UICorner")
    serverListFrameCorner.CornerRadius = UDim.new(0, 4)
    serverListFrameCorner.Parent = serverListFrame
    
    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(1, -10, 1, -10)
    serverList.Position = UDim2.new(0, 5, 0, 5)
    serverList.BackgroundTransparency = 1
    serverList.BorderSizePixel = 0
    serverList.ScrollBarThickness = 6
    serverList.ScrollingDirection = Enum.ScrollingDirection.Y
    serverList.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
    serverList.Parent = serverListFrame
    
    local serverListLayout = Instance.new("UIListLayout")
    serverListLayout.Padding = UDim.new(0, 5)
    serverListLayout.Parent = serverList
    
    -- Data Coordination Section
    local coordinationSection = Instance.new("Frame")
    coordinationSection.Size = UDim2.new(0.9, 0, 0, 230)
    coordinationSection.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    coordinationSection.BorderSizePixel = 0
    coordinationSection.LayoutOrder = 2
    coordinationSection.Parent = contentArea
    
    -- Add rounded corners
    local coordinationSectionCorner = Instance.new("UICorner")
    coordinationSectionCorner.CornerRadius = UDim.new(0, 8)
    coordinationSectionCorner.Parent = coordinationSection
    
    local coordinationTitle = Instance.new("TextLabel")
    coordinationTitle.Size = UDim2.new(1, 0, 0, 30)
    coordinationTitle.Position = UDim2.new(0, 0, 0, 0)
    coordinationTitle.BackgroundTransparency = 1
    coordinationTitle.Text = "Data Coordination"
    coordinationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordinationTitle.Font = Enum.Font.SourceSansBold
    coordinationTitle.TextSize = 16
    coordinationTitle.Parent = coordinationSection
    
    local dataStoreLabel = Instance.new("TextLabel")
    dataStoreLabel.Size = UDim2.new(0.3, 0, 0, 24)
    dataStoreLabel.Position = UDim2.new(0, 10, 0, 35)
    dataStoreLabel.BackgroundTransparency = 1
    dataStoreLabel.Text = "DataStore Name:"
    dataStoreLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    dataStoreLabel.Font = Enum.Font.SourceSans
    dataStoreLabel.TextSize = 14
    dataStoreLabel.TextXAlignment = Enum.TextXAlignment.Left
    dataStoreLabel.Parent = coordinationSection
    
    local dataStoreInput = Instance.new("TextBox")
    dataStoreInput.Size = UDim2.new(0.65, 0, 0, 24)
    dataStoreInput.Position = UDim2.new(0.33, 0, 0, 35)
    dataStoreInput.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
    dataStoreInput.BorderSizePixel = 0
    dataStoreInput.PlaceholderText = "Enter DataStore name..."
    dataStoreInput.Text = ""
    dataStoreInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    dataStoreInput.Font = Enum.Font.SourceSans
    dataStoreInput.TextSize = 14
    dataStoreInput.ClearTextOnFocus = false
    dataStoreInput.Parent = coordinationSection
    
    -- Add rounded corners
    local dataStoreInputCorner = Instance.new("UICorner")
    dataStoreInputCorner.CornerRadius = UDim.new(0, 4)
    dataStoreInputCorner.Parent = dataStoreInput
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0.3, 0, 0, 24)
    keyLabel.Position = UDim2.new(0, 10, 0, 65)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "Key Name:"
    keyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    keyLabel.Font = Enum.Font.SourceSans
    keyLabel.TextSize = 14
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = coordinationSection
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0.65, 0, 0, 24)
    keyInput.Position = UDim2.new(0.33, 0, 0, 65)
    keyInput.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
    keyInput.BorderSizePixel = 0
    keyInput.PlaceholderText = "Enter key name..."
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.Font = Enum.Font.SourceSans
    keyInput.TextSize = 14
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = coordinationSection
    
    -- Add rounded corners
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 4)
    keyInputCorner.Parent = keyInput
    
    local broadcastTypeLabel = Instance.new("TextLabel")
    broadcastTypeLabel.Size = UDim2.new(0.3, 0, 0, 24)
    broadcastTypeLabel.Position = UDim2.new(0, 10, 0, 95)
    broadcastTypeLabel.BackgroundTransparency = 1
    broadcastTypeLabel.Text = "Broadcast Type:"
    broadcastTypeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    broadcastTypeLabel.Font = Enum.Font.SourceSans
    broadcastTypeLabel.TextSize = 14
    broadcastTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    broadcastTypeLabel.Parent = coordinationSection
    
    local broadcastTypeFrame = Instance.new("Frame")
    broadcastTypeFrame.Size = UDim2.new(0.65, 0, 0, 24)
    broadcastTypeFrame.Position = UDim2.new(0.33, 0, 0, 95)
    broadcastTypeFrame.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
    broadcastTypeFrame.BorderSizePixel = 0
    broadcastTypeFrame.Parent = coordinationSection
    
    -- Add rounded corners
    local broadcastTypeFrameCorner = Instance.new("UICorner")
    broadcastTypeFrameCorner.CornerRadius = UDim.new(0, 4)
    broadcastTypeFrameCorner.Parent = broadcastTypeFrame
    
    local broadcastTypeDropdown = Instance.new("TextButton")
    broadcastTypeDropdown.Size = UDim2.new(1, 0, 1, 0)
    broadcastTypeDropdown.Position = UDim2.new(0, 0, 0, 0)
    broadcastTypeDropdown.BackgroundTransparency = 1
    broadcastTypeDropdown.Text = "Select Broadcast Type"
    broadcastTypeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    broadcastTypeDropdown.Font = Enum.Font.SourceSans
    broadcastTypeDropdown.TextSize = 14
    broadcastTypeDropdown.Parent = broadcastTypeFrame
    
    local actionSection = Instance.new("Frame")
    actionSection.Size = UDim2.new(0.95, 0, 0, 90)
    actionSection.Position = UDim2.new(0.025, 0, 0, 130)
    actionSection.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
    actionSection.BorderSizePixel = 0
    actionSection.Parent = coordinationSection
    
    -- Add rounded corners
    local actionSectionCorner = Instance.new("UICorner")
    actionSectionCorner.CornerRadius = UDim.new(0, 4)
    actionSectionCorner.Parent = actionSection
    
    -- Buttons row for actions
    local actionButtons = Instance.new("Frame")
    actionButtons.Size = UDim2.new(1, -20, 0, 35)
    actionButtons.Position = UDim2.new(0, 10, 0, 10)
    actionButtons.BackgroundTransparency = 1
    actionButtons.Parent = actionSection
    
    local actionButtonsLayout = Instance.new("UIGridLayout")
    actionButtonsLayout.CellSize = UDim2.new(0.32, 0, 0, 30)
    actionButtonsLayout.CellPadding = UDim2.new(0.02, 0, 0, 5)
    actionButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    actionButtonsLayout.Parent = actionButtons
    
    local lockButton = Instance.new("TextButton")
    lockButton.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    lockButton.BorderSizePixel = 0
    lockButton.Text = "Lock Key"
    lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockButton.Font = Enum.Font.SourceSansSemibold
    lockButton.TextSize = 14
    lockButton.Parent = actionButtons
    
    -- Add rounded corners to button
    local lockButtonCorner = Instance.new("UICorner")
    lockButtonCorner.CornerRadius = UDim.new(0, 4)
    lockButtonCorner.Parent = lockButton
    
    local unlockButton = Instance.new("TextButton")
    unlockButton.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
    unlockButton.BorderSizePixel = 0
    unlockButton.Text = "Unlock Key"
    unlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    unlockButton.Font = Enum.Font.SourceSansSemibold
    unlockButton.TextSize = 14
    unlockButton.Parent = actionButtons
    
    -- Add rounded corners to button
    local unlockButtonCorner = Instance.new("UICorner")
    unlockButtonCorner.CornerRadius = UDim.new(0, 4)
    unlockButtonCorner.Parent = unlockButton
    
    local broadcastButton = Instance.new("TextButton")
    broadcastButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    broadcastButton.BorderSizePixel = 0
    broadcastButton.Text = "Broadcast Change"
    broadcastButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    broadcastButton.Font = Enum.Font.SourceSansSemibold
    broadcastButton.TextSize = 14
    broadcastButton.Parent = actionButtons
    
    -- Add rounded corners to button
    local broadcastButtonCorner = Instance.new("UICorner")
    broadcastButtonCorner.CornerRadius = UDim.new(0, 4)
    broadcastButtonCorner.Parent = broadcastButton
    
    local statusLabelFrame = Instance.new("Frame")
    statusLabelFrame.Size = UDim2.new(1, -20, 0, 24)
    statusLabelFrame.Position = UDim2.new(0, 10, 0, 55)
    statusLabelFrame.BackgroundTransparency = 1
    statusLabelFrame.Parent = actionSection
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Ready"
    statusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 14
    statusLabel.Parent = statusLabelFrame
    
    -- Connect close button
    closeButton.MouseButton1Click:Connect(function()
        coordinationContainer.Visible = false
    end)
    
    -- Connect coordination button
    coordinationButton.MouseButton1Click:Connect(function()
        coordinationContainer.Visible = true
        
        -- Hide other UI components
        if DataExplorer.bulkOperationsContainer and DataExplorer.bulkOperationsContainer.Visible then
            DataExplorer.bulkOperationsContainer.Visible = false
        end
        
        if DataExplorer.schemaBuilderContainer and DataExplorer.schemaBuilderContainer.Visible then
            DataExplorer.schemaBuilderContainer.Visible = false
        end
        
        if DataExplorer.dataMigrationContainer and DataExplorer.dataMigrationContainer.Visible then
            DataExplorer.dataMigrationContainer.Visible = false
        end
        
        -- Hide main panes
        DataExplorer.contentPane.Visible = false
        DataExplorer.navigationPane.Visible = false
    end)
    
    return coordinationContainer
end

return MultiServerCoordinationUI
