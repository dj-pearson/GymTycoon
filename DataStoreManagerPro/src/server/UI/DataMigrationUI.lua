-- DataMigration UI component for DataExplorer
local DataMigrationUI = {}

function DataMigrationUI.initDataMigrationUI(DataExplorer)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open data migration
    local dataMigrationButton = Instance.new("TextButton")
    dataMigrationButton.Size = UDim2.new(0, 150, 0, 30)
    dataMigrationButton.Position = UDim2.new(1, -320, 0, 10) -- To the left of other buttons
    dataMigrationButton.BackgroundColor3 = Color3.fromRGB(100, 100, 180)
    dataMigrationButton.BorderSizePixel = 0
    dataMigrationButton.Text = "Data Migration"
    dataMigrationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dataMigrationButton.Font = Enum.Font.SourceSansBold
    dataMigrationButton.TextSize = 14
    dataMigrationButton.ZIndex = 5
    dataMigrationButton.Parent = mainFrame
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = dataMigrationButton
    
    -- Create the data migration container (initially invisible)
    local dataMigrationContainer = Instance.new("Frame")
    dataMigrationContainer.Size = UDim2.new(1, 0, 1, 0)
    dataMigrationContainer.Position = UDim2.new(0, 0, 0, 0)
    dataMigrationContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    dataMigrationContainer.BorderSizePixel = 0
    dataMigrationContainer.Visible = false
    dataMigrationContainer.ZIndex = 10
    dataMigrationContainer.Parent = mainFrame
    
    -- Save reference to the container
    DataExplorer.dataMigrationContainer = dataMigrationContainer
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = dataMigrationContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Data Migration"
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
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = dataMigrationContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    -- Source Section
    local sourceSection = Instance.new("Frame")
    sourceSection.Size = UDim2.new(0.9, 0, 0, 150)
    sourceSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sourceSection.BorderSizePixel = 0
    sourceSection.LayoutOrder = 1
    sourceSection.Parent = contentArea
    
    -- Add rounded corners
    local sourceSectionCorner = Instance.new("UICorner")
    sourceSectionCorner.CornerRadius = UDim.new(0, 8)
    sourceSectionCorner.Parent = sourceSection
    
    local sourceTitle = Instance.new("TextLabel")
    sourceTitle.Size = UDim2.new(1, 0, 0, 30)
    sourceTitle.Position = UDim2.new(0, 0, 0, 0)
    sourceTitle.BackgroundTransparency = 1
    sourceTitle.Text = "Source DataStore"
    sourceTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sourceTitle.Font = Enum.Font.SourceSansBold
    sourceTitle.TextSize = 16
    sourceTitle.Parent = sourceSection
    
    local sourceNameLabel = Instance.new("TextLabel")
    sourceNameLabel.Size = UDim2.new(0.3, 0, 0, 24)
    sourceNameLabel.Position = UDim2.new(0, 10, 0, 35)
    sourceNameLabel.BackgroundTransparency = 1
    sourceNameLabel.Text = "DataStore Name:"
    sourceNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    sourceNameLabel.Font = Enum.Font.SourceSans
    sourceNameLabel.TextSize = 14
    sourceNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    sourceNameLabel.Parent = sourceSection
    
    local sourceNameInput = Instance.new("TextBox")
    sourceNameInput.Size = UDim2.new(0.65, 0, 0, 24)
    sourceNameInput.Position = UDim2.new(0.33, 0, 0, 35)
    sourceNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sourceNameInput.BorderSizePixel = 0
    sourceNameInput.PlaceholderText = "Enter source DataStore name..."
    sourceNameInput.Text = ""
    sourceNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    sourceNameInput.Font = Enum.Font.SourceSans
    sourceNameInput.TextSize = 14
    sourceNameInput.ClearTextOnFocus = false
    sourceNameInput.Parent = sourceSection
    
    -- Add rounded corners
    local sourceNameInputCorner = Instance.new("UICorner")
    sourceNameInputCorner.CornerRadius = UDim.new(0, 4)
    sourceNameInputCorner.Parent = sourceNameInput
    
    local sourceKeyPrefixLabel = Instance.new("TextLabel")
    sourceKeyPrefixLabel.Size = UDim2.new(0.3, 0, 0, 24)
    sourceKeyPrefixLabel.Position = UDim2.new(0, 10, 0, 65)
    sourceKeyPrefixLabel.BackgroundTransparency = 1
    sourceKeyPrefixLabel.Text = "Key Prefix Filter:"
    sourceKeyPrefixLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    sourceKeyPrefixLabel.Font = Enum.Font.SourceSans
    sourceKeyPrefixLabel.TextSize = 14
    sourceKeyPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
    sourceKeyPrefixLabel.Parent = sourceSection
    
    local sourceKeyPrefixInput = Instance.new("TextBox")
    sourceKeyPrefixInput.Size = UDim2.new(0.65, 0, 0, 24)
    sourceKeyPrefixInput.Position = UDim2.new(0.33, 0, 0, 65)
    sourceKeyPrefixInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sourceKeyPrefixInput.BorderSizePixel = 0
    sourceKeyPrefixInput.PlaceholderText = "Optional: Enter prefix to filter keys (e.g., 'Player_')..."
    sourceKeyPrefixInput.Text = ""
    sourceKeyPrefixInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    sourceKeyPrefixInput.Font = Enum.Font.SourceSans
    sourceKeyPrefixInput.TextSize = 14
    sourceKeyPrefixInput.ClearTextOnFocus = false
    sourceKeyPrefixInput.Parent = sourceSection
    
    -- Add rounded corners
    local sourceKeyPrefixInputCorner = Instance.new("UICorner")
    sourceKeyPrefixInputCorner.CornerRadius = UDim.new(0, 4)
    sourceKeyPrefixInputCorner.Parent = sourceKeyPrefixInput
    
    local scanSourceButton = Instance.new("TextButton")
    scanSourceButton.Size = UDim2.new(0.3, 0, 0, 30)
    scanSourceButton.Position = UDim2.new(0.35, 0, 0, 100)
    scanSourceButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    scanSourceButton.BorderSizePixel = 0
    scanSourceButton.Text = "Scan Source Keys"
    scanSourceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanSourceButton.Font = Enum.Font.SourceSansSemibold
    scanSourceButton.TextSize = 14
    scanSourceButton.Parent = sourceSection
    
    -- Add rounded corners to button
    local scanSourceButtonCorner = Instance.new("UICorner")
    scanSourceButtonCorner.CornerRadius = UDim.new(0, 4)
    scanSourceButtonCorner.Parent = scanSourceButton
    
    -- Destination Section
    local destSection = Instance.new("Frame")
    destSection.Size = UDim2.new(0.9, 0, 0, 150)
    destSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    destSection.BorderSizePixel = 0
    destSection.LayoutOrder = 2
    destSection.Parent = contentArea
    
    -- Add rounded corners
    local destSectionCorner = Instance.new("UICorner")
    destSectionCorner.CornerRadius = UDim.new(0, 8)
    destSectionCorner.Parent = destSection
    
    local destTitle = Instance.new("TextLabel")
    destTitle.Size = UDim2.new(1, 0, 0, 30)
    destTitle.Position = UDim2.new(0, 0, 0, 0)
    destTitle.BackgroundTransparency = 1
    destTitle.Text = "Destination DataStore"
    destTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    destTitle.Font = Enum.Font.SourceSansBold
    destTitle.TextSize = 16
    destTitle.Parent = destSection
    
    local destNameLabel = Instance.new("TextLabel")
    destNameLabel.Size = UDim2.new(0.3, 0, 0, 24)
    destNameLabel.Position = UDim2.new(0, 10, 0, 35)
    destNameLabel.BackgroundTransparency = 1
    destNameLabel.Text = "DataStore Name:"
    destNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    destNameLabel.Font = Enum.Font.SourceSans
    destNameLabel.TextSize = 14
    destNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    destNameLabel.Parent = destSection
    
    local destNameInput = Instance.new("TextBox")
    destNameInput.Size = UDim2.new(0.65, 0, 0, 24)
    destNameInput.Position = UDim2.new(0.33, 0, 0, 35)
    destNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    destNameInput.BorderSizePixel = 0
    destNameInput.PlaceholderText = "Enter destination DataStore name..."
    destNameInput.Text = ""
    destNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    destNameInput.Font = Enum.Font.SourceSans
    destNameInput.TextSize = 14
    destNameInput.ClearTextOnFocus = false
    destNameInput.Parent = destSection
    
    -- Add rounded corners
    local destNameInputCorner = Instance.new("UICorner")
    destNameInputCorner.CornerRadius = UDim.new(0, 4)
    destNameInputCorner.Parent = destNameInput
    
    local keyTransformLabel = Instance.new("TextLabel")
    keyTransformLabel.Size = UDim2.new(0.3, 0, 0, 24)
    keyTransformLabel.Position = UDim2.new(0, 10, 0, 65)
    keyTransformLabel.BackgroundTransparency = 1
    keyTransformLabel.Text = "Key Transform:"
    keyTransformLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    keyTransformLabel.Font = Enum.Font.SourceSans
    keyTransformLabel.TextSize = 14
    keyTransformLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyTransformLabel.Parent = destSection
    
    local keyTransformInput = Instance.new("TextBox")
    keyTransformInput.Size = UDim2.new(0.65, 0, 0, 24)
    keyTransformInput.Position = UDim2.new(0.33, 0, 0, 65)
    keyTransformInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    keyTransformInput.BorderSizePixel = 0
    keyTransformInput.PlaceholderText = "Optional: Transform key names (e.g., 'Player_' to 'User_')..."
    keyTransformInput.Text = ""
    keyTransformInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyTransformInput.Font = Enum.Font.SourceSans
    keyTransformInput.TextSize = 14
    keyTransformInput.ClearTextOnFocus = false
    keyTransformInput.Parent = destSection
    
    -- Add rounded corners
    local keyTransformInputCorner = Instance.new("UICorner")
    keyTransformInputCorner.CornerRadius = UDim.new(0, 4)
    keyTransformInputCorner.Parent = keyTransformInput
    
    local scanDestButton = Instance.new("TextButton")
    scanDestButton.Size = UDim2.new(0.3, 0, 0, 30)
    scanDestButton.Position = UDim2.new(0.35, 0, 0, 100)
    scanDestButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    scanDestButton.BorderSizePixel = 0
    scanDestButton.Text = "Scan Destination Keys"
    scanDestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanDestButton.Font = Enum.Font.SourceSansSemibold
    scanDestButton.TextSize = 14
    scanDestButton.Parent = destSection
    
    -- Add rounded corners to button
    local scanDestButtonCorner = Instance.new("UICorner")
    scanDestButtonCorner.CornerRadius = UDim.new(0, 4)
    scanDestButtonCorner.Parent = scanDestButton
    
    -- Migration Options Section
    local optionsSection = Instance.new("Frame")
    optionsSection.Size = UDim2.new(0.9, 0, 0, 200)
    optionsSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    optionsSection.BorderSizePixel = 0
    optionsSection.LayoutOrder = 3
    optionsSection.Parent = contentArea
    
    -- Add rounded corners
    local optionsSectionCorner = Instance.new("UICorner")
    optionsSectionCorner.CornerRadius = UDim.new(0, 8)
    optionsSectionCorner.Parent = optionsSection
    
    local optionsTitle = Instance.new("TextLabel")
    optionsTitle.Size = UDim2.new(1, 0, 0, 30)
    optionsTitle.Position = UDim2.new(0, 0, 0, 0)
    optionsTitle.BackgroundTransparency = 1
    optionsTitle.Text = "Migration Options"
    optionsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionsTitle.Font = Enum.Font.SourceSansBold
    optionsTitle.TextSize = 16
    optionsTitle.Parent = optionsSection
    
    -- Connect close button
    closeButton.MouseButton1Click:Connect(function()
        dataMigrationContainer.Visible = false
    end)
    
    -- Connect data migration button
    dataMigrationButton.MouseButton1Click:Connect(function()
        dataMigrationContainer.Visible = true
        
        -- Hide other UI components
        if DataExplorer.bulkOperationsContainer and DataExplorer.bulkOperationsContainer.Visible then
            DataExplorer.bulkOperationsContainer.Visible = false
            DataExplorer.bulkOperationsButton.Text = "Bulk Operations"
            DataExplorer.bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        end
        
        if DataExplorer.schemaBuilderContainer and DataExplorer.schemaBuilderContainer.Visible then
            DataExplorer.schemaBuilderContainer.Visible = false
            DataExplorer.schemaBuilderButton.Text = "Schema Builder"
            DataExplorer.schemaBuilderButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
        end
        
        -- Hide main panes
        DataExplorer.contentPane.Visible = false
        DataExplorer.navigationPane.Visible = false
    end)
    
    return dataMigrationContainer
end

return DataMigrationUI
