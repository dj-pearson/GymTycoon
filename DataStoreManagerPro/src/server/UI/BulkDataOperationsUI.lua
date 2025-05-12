-- BulkDataOperations UI component for DataExplorer
local BulkDataOperationsUI = {}

function BulkDataOperationsUI.initBulkDataOperations(DataExplorer, BulkOperationsManager)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open bulk data operations
    local bulkDataButton = Instance.new("TextButton")
    bulkDataButton.Size = UDim2.new(0, 150, 0, 30)
    bulkDataButton.Position = UDim2.new(1, -160, 0, 50) -- Below other buttons
    bulkDataButton.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    bulkDataButton.BorderSizePixel = 0
    bulkDataButton.Text = "Bulk Data Operations"
    bulkDataButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    bulkDataButton.Font = Enum.Font.SourceSansBold
    bulkDataButton.TextSize = 14
    bulkDataButton.ZIndex = 5
    bulkDataButton.Parent = mainFrame
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = bulkDataButton
    
    -- Create the bulk data operations container (initially invisible)
    local bulkDataContainer = Instance.new("Frame")
    bulkDataContainer.Size = UDim2.new(1, 0, 1, 0)
    bulkDataContainer.Position = UDim2.new(0, 0, 0, 0)
    bulkDataContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    bulkDataContainer.BorderSizePixel = 0
    bulkDataContainer.Visible = false
    bulkDataContainer.ZIndex = 10
    bulkDataContainer.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = bulkDataContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Bulk Data Operations"
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
    
    -- Create content area with tabs
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 1, -40)
    contentArea.Position = UDim2.new(0, 0, 0, 40)
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    contentArea.BorderSizePixel = 0
    contentArea.Parent = bulkDataContainer
    
    -- Create tabs bar
    local tabsBar = Instance.new("Frame")
    tabsBar.Size = UDim2.new(1, 0, 0, 30)
    tabsBar.Position = UDim2.new(0, 0, 0, 0)
    tabsBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabsBar.BorderSizePixel = 0
    tabsBar.Parent = contentArea
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 2)
    tabsLayout.Parent = tabsBar
    
    -- Create tab content container
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, -30)
    tabContent.Position = UDim2.new(0, 0, 0, 30)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = contentArea
    
    -- Function to create a tab
    local function createTab(name, selected)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(0, 120, 1, 0)
        tab.BackgroundColor3 = selected and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
        tab.BorderSizePixel = 0
        tab.Text = name
        tab.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        tab.Font = Enum.Font.SourceSansSemibold
        tab.Name = "Tab_" .. name
        tab.Parent = tabsBar
        
        return tab
    end
    
    -- Function to create a view container
    local function createViewContainer(name)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.Name = "View_" .. name
        container.Parent = tabContent
        
        return container
    end
    
    -- Create tabs
    local tabExport = createTab("Export", true)
    local tabImport = createTab("Import", false)
    local tabBatchEdit = createTab("Batch Edit", false)
    local tabBackup = createTab("Backup", false)
    
    -- Create view containers
    local viewExport = createViewContainer("Export")
    local viewImport = createViewContainer("Import")
    local viewBatchEdit = createViewContainer("Batch Edit")
    local viewBackup = createViewContainer("Backup")
    
    -- Make export view visible by default
    viewExport.Visible = true
    
    -- Function to switch tabs
    local function switchTab(selectedTabName)
        for _, tab in ipairs(tabsBar:GetChildren()) do
            if tab:IsA("TextButton") then
                local isSelected = tab.Name == "Tab_" .. selectedTabName
                tab.BackgroundColor3 = isSelected and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
                tab.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            end
        end
        
        for _, view in ipairs(tabContent:GetChildren()) do
            if view:IsA("Frame") then
                view.Visible = view.Name == "View_" .. selectedTabName
            end
        end
    end
    
    -- Connect tab click events
    tabExport.MouseButton1Click:Connect(function() switchTab("Export") end)
    tabImport.MouseButton1Click:Connect(function() switchTab("Import") end)
    tabBatchEdit.MouseButton1Click:Connect(function() switchTab("Batch Edit") end)
    tabBackup.MouseButton1Click:Connect(function() switchTab("Backup") end)
    
    -- Create Export View Content
    local exportScrollFrame = Instance.new("ScrollingFrame")
    exportScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    exportScrollFrame.BackgroundTransparency = 1
    exportScrollFrame.BorderSizePixel = 0
    exportScrollFrame.ScrollBarThickness = 6
    exportScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    exportScrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    exportScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    exportScrollFrame.Parent = viewExport
    
    local exportLayout = Instance.new("UIListLayout")
    exportLayout.Padding = UDim.new(0, 10)
    exportLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    exportLayout.Parent = exportScrollFrame
    
    -- DataStore Selection Section
    local dsSelectSection = Instance.new("Frame")
    dsSelectSection.Size = UDim2.new(0.9, 0, 0, 80)
    dsSelectSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    dsSelectSection.BorderSizePixel = 0
    dsSelectSection.LayoutOrder = 1
    dsSelectSection.Parent = exportScrollFrame
    
    -- Add rounded corners
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = dsSelectSection
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.Position = UDim2.new(0, 0, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = "Select DataStore"
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.Font = Enum.Font.SourceSansBold
    sectionTitle.TextSize = 16
    sectionTitle.Parent = dsSelectSection
    
    local dsNameInput = Instance.new("TextBox")
    dsNameInput.Size = UDim2.new(0.7, 0, 0, 30)
    dsNameInput.Position = UDim2.new(0, 10, 0, 35)
    dsNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dsNameInput.BorderSizePixel = 0
    dsNameInput.PlaceholderText = "Enter DataStore name..."
    dsNameInput.Text = ""
    dsNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    dsNameInput.Font = Enum.Font.SourceSans
    dsNameInput.TextSize = 14
    dsNameInput.ClearTextOnFocus = false
    dsNameInput.Parent = dsSelectSection
    
    -- Add rounded corners
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = dsNameInput
    
    local refreshDsButton = Instance.new("TextButton")
    refreshDsButton.Size = UDim2.new(0.25, 0, 0, 30)
    refreshDsButton.Position = UDim2.new(0.73, 0, 0, 35)
    refreshDsButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    refreshDsButton.BorderSizePixel = 0
    refreshDsButton.Text = "List Stores"
    refreshDsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshDsButton.Font = Enum.Font.SourceSans
    refreshDsButton.TextSize = 14
    refreshDsButton.Parent = dsSelectSection
    
    -- Add rounded corners to button
    local refreshBtnCorner = Instance.new("UICorner")
    refreshBtnCorner.CornerRadius = UDim.new(0, 4)
    refreshBtnCorner.Parent = refreshDsButton
    
    -- Key Selection Section
    local keySelectSection = Instance.new("Frame")
    keySelectSection.Size = UDim2.new(0.9, 0, 0, 200)
    keySelectSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    keySelectSection.BorderSizePixel = 0
    keySelectSection.LayoutOrder = 2
    keySelectSection.Parent = exportScrollFrame
    
    -- Add rounded corners
    local keySectionCorner = Instance.new("UICorner")
    keySectionCorner.CornerRadius = UDim.new(0, 8)
    keySectionCorner.Parent = keySelectSection
    
    local keySectionTitle = Instance.new("TextLabel")
    keySectionTitle.Size = UDim2.new(1, 0, 0, 30)
    keySectionTitle.Position = UDim2.new(0, 0, 0, 0)
    keySectionTitle.BackgroundTransparency = 1
    keySectionTitle.Text = "Select Keys"
    keySectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    keySectionTitle.Font = Enum.Font.SourceSansBold
    keySectionTitle.TextSize = 16
    keySectionTitle.Parent = keySelectSection
    
    local keyPatternInput = Instance.new("TextBox")
    keyPatternInput.Size = UDim2.new(0.7, 0, 0, 30)
    keyPatternInput.Position = UDim2.new(0, 10, 0, 35)
    keyPatternInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    keyPatternInput.BorderSizePixel = 0
    keyPatternInput.PlaceholderText = "Filter keys (leave empty for all)..."
    keyPatternInput.Text = ""
    keyPatternInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyPatternInput.Font = Enum.Font.SourceSans
    keyPatternInput.TextSize = 14
    keyPatternInput.ClearTextOnFocus = false
    keyPatternInput.Parent = keySelectSection
    
    -- Add rounded corners
    local keyInputCorner = Instance.new("UICorner")
    keyInputCorner.CornerRadius = UDim.new(0, 4)
    keyInputCorner.Parent = keyPatternInput
    
    local searchKeysButton = Instance.new("TextButton")
    searchKeysButton.Size = UDim2.new(0.25, 0, 0, 30)
    searchKeysButton.Position = UDim2.new(0.73, 0, 0, 35)
    searchKeysButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    searchKeysButton.BorderSizePixel = 0
    searchKeysButton.Text = "Search Keys"
    searchKeysButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchKeysButton.Font = Enum.Font.SourceSans
    searchKeysButton.TextSize = 14
    searchKeysButton.Parent = keySelectSection
    
    -- Add rounded corners to button
    local searchBtnCorner = Instance.new("UICorner")
    searchBtnCorner.CornerRadius = UDim.new(0, 4)
    searchBtnCorner.Parent = searchKeysButton
    
    -- Keys list container
    local keysListContainer = Instance.new("ScrollingFrame")
    keysListContainer.Size = UDim2.new(1, -20, 0, 120)
    keysListContainer.Position = UDim2.new(0, 10, 0, 70)
    keysListContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    keysListContainer.BorderSizePixel = 0
    keysListContainer.ScrollBarThickness = 6
    keysListContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    keysListContainer.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    keysListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    keysListContainer.Parent = keySelectSection
    
    local keysListLayout = Instance.new("UIListLayout")
    keysListLayout.Padding = UDim.new(0, 2)
    keysListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    keysListLayout.Parent = keysListContainer
    
    -- Export Options Section
    local exportOptionsSection = Instance.new("Frame")
    exportOptionsSection.Size = UDim2.new(0.9, 0, 0, 120)
    exportOptionsSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    exportOptionsSection.BorderSizePixel = 0
    exportOptionsSection.LayoutOrder = 3
    exportOptionsSection.Parent = exportScrollFrame
    
    -- Add rounded corners
    local optionsSectionCorner = Instance.new("UICorner")
    optionsSectionCorner.CornerRadius = UDim.new(0, 8)
    optionsSectionCorner.Parent = exportOptionsSection
    
    local optionsSectionTitle = Instance.new("TextLabel")
    optionsSectionTitle.Size = UDim2.new(1, 0, 0, 30)
    optionsSectionTitle.Position = UDim2.new(0, 0, 0, 0)
    optionsSectionTitle.BackgroundTransparency = 1
    optionsSectionTitle.Text = "Export Options"
    optionsSectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionsSectionTitle.Font = Enum.Font.SourceSansBold
    optionsSectionTitle.TextSize = 16
    optionsSectionTitle.Parent = exportOptionsSection
    
    -- Format selection
    local formatLabel = Instance.new("TextLabel")
    formatLabel.Size = UDim2.new(0.3, 0, 0, 24)
    formatLabel.Position = UDim2.new(0, 10, 0, 35)
    formatLabel.BackgroundTransparency = 1
    formatLabel.Text = "Format:"
    formatLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    formatLabel.Font = Enum.Font.SourceSans
    formatLabel.TextSize = 14
    formatLabel.TextXAlignment = Enum.TextXAlignment.Left
    formatLabel.Parent = exportOptionsSection
    
    local formatSelection = Instance.new("Frame")
    formatSelection.Size = UDim2.new(0.65, 0, 0, 24)
    formatSelection.Position = UDim2.new(0.33, 0, 0, 35)
    formatSelection.BackgroundTransparency = 1
    formatSelection.Parent = exportOptionsSection
    
    local formatLayout = Instance.new("UIListLayout")
    formatLayout.FillDirection = Enum.FillDirection.Horizontal
    formatLayout.Padding = UDim.new(0, 15)
    formatLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    formatLayout.Parent = formatSelection
    
    -- JSON format option
    local jsonOption = Instance.new("Frame")
    jsonOption.Size = UDim2.new(0, 80, 1, 0)
    jsonOption.BackgroundTransparency = 1
    jsonOption.Parent = formatSelection
    
    local jsonRadio = Instance.new("ImageLabel")
    jsonRadio.Size = UDim2.new(0, 16, 0, 16)
    jsonRadio.Position = UDim2.new(0, 0, 0.5, -8)
    jsonRadio.BackgroundTransparency = 1
    jsonRadio.Image = "rbxassetid://3926309567"
    jsonRadio.ImageRectOffset = Vector2.new(628, 420)
    jsonRadio.ImageRectSize = Vector2.new(48, 48)
    jsonRadio.Parent = jsonOption
    
    local jsonLabel = Instance.new("TextLabel")
    jsonLabel.Size = UDim2.new(1, -25, 1, 0)
    jsonLabel.Position = UDim2.new(0, 25, 0, 0)
    jsonLabel.BackgroundTransparency = 1
    jsonLabel.Text = "JSON"
    jsonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jsonLabel.Font = Enum.Font.SourceSans
    jsonLabel.TextSize = 14
    jsonLabel.TextXAlignment = Enum.TextXAlignment.Left
    jsonLabel.Parent = jsonOption
    
    -- CSV format option
    local csvOption = Instance.new("Frame")
    csvOption.Size = UDim2.new(0, 80, 1, 0)
    csvOption.BackgroundTransparency = 1
    csvOption.Parent = formatSelection
    
    local csvRadio = Instance.new("ImageLabel")
    csvRadio.Size = UDim2.new(0, 16, 0, 16)
    csvRadio.Position = UDim2.new(0, 0, 0.5, -8)
    csvRadio.BackgroundTransparency = 1
    csvRadio.Image = "rbxassetid://3926309567"
    csvRadio.ImageRectOffset = Vector2.new(784, 420)
    csvRadio.ImageRectSize = Vector2.new(48, 48)
    csvRadio.Parent = csvOption
    
    local csvLabel = Instance.new("TextLabel")
    csvLabel.Size = UDim2.new(1, -25, 1, 0)
    csvLabel.Position = UDim2.new(0, 25, 0, 0)
    csvLabel.BackgroundTransparency = 1
    csvLabel.Text = "CSV"
    csvLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    csvLabel.Font = Enum.Font.SourceSans
    csvLabel.TextSize = 14
    csvLabel.TextXAlignment = Enum.TextXAlignment.Left
    csvLabel.Parent = csvOption
    
    -- Batch size option
    local batchSizeLabel = Instance.new("TextLabel")
    batchSizeLabel.Size = UDim2.new(0.3, 0, 0, 24)
    batchSizeLabel.Position = UDim2.new(0, 10, 0, 65)
    batchSizeLabel.BackgroundTransparency = 1
    batchSizeLabel.Text = "Batch Size:"
    batchSizeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    batchSizeLabel.Font = Enum.Font.SourceSans
    batchSizeLabel.TextSize = 14
    batchSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    batchSizeLabel.Parent = exportOptionsSection
    
    local batchSizeInput = Instance.new("TextBox")
    batchSizeInput.Size = UDim2.new(0.15, 0, 0, 24)
    batchSizeInput.Position = UDim2.new(0.33, 0, 0, 65)
    batchSizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    batchSizeInput.BorderSizePixel = 0
    batchSizeInput.Text = "10"
    batchSizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    batchSizeInput.Font = Enum.Font.SourceSans
    batchSizeInput.TextSize = 14
    batchSizeInput.ClearTextOnFocus = false
    batchSizeInput.Parent = exportOptionsSection
    
    -- Add rounded corners
    local batchInputCorner = Instance.new("UICorner")
    batchInputCorner.CornerRadius = UDim.new(0, 4)
    batchInputCorner.Parent = batchSizeInput
    
    -- Export button
    local exportButton = Instance.new("TextButton")
    exportButton.Size = UDim2.new(0.4, 0, 0, 35)
    exportButton.Position = UDim2.new(0.5, -80, 0, 80)
    exportButton.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
    exportButton.BorderSizePixel = 0
    exportButton.Text = "Export Data"
    exportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    exportButton.Font = Enum.Font.SourceSansBold
    exportButton.TextSize = 16
    exportButton.Parent = exportOptionsSection
    
    -- Add rounded corners to button
    local exportBtnCorner = Instance.new("UICorner")
    exportBtnCorner.CornerRadius = UDim.new(0, 6)
    exportBtnCorner.Parent = exportButton
    
    -- Connect the close button
    closeButton.MouseButton1Click:Connect(function()
        bulkDataContainer.Visible = false
    end)
    
    -- Connect the bulk data button
    bulkDataButton.MouseButton1Click:Connect(function()
        bulkDataContainer.Visible = true
    end)
    
    -- Store container in DataExplorer
    DataExplorer.bulkDataContainer = bulkDataContainer
    
    return bulkDataContainer
end

return BulkDataOperationsUI
