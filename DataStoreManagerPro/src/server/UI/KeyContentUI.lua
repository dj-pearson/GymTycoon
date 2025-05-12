-- Key Content Display for DataExplorer
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

local KeyContentUI = {}

function KeyContentUI.displayKeyContent(DataExplorer, dataStoreName, keyName, SchemaManager, SessionManager, CacheManager, PerformanceMonitor)
    local contentPane = DataExplorer.contentPane
    if not contentPane then return end
    
    -- Clear the content pane
    for _, child in ipairs(contentPane:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    -- Attempt to acquire a lock for reading/editing
    local lockAcquired = SessionManager.acquireLock(dataStoreName, keyName, DataExplorer.sessionId)
    if not lockAcquired then
        -- Create a locked notification
        local lockNotification = Instance.new("Frame")
        lockNotification.Size = UDim2.new(1, 0, 0, 40)
        lockNotification.Position = UDim2.new(0, 0, 0, 0)
        lockNotification.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        lockNotification.BackgroundTransparency = 0.2
        lockNotification.BorderSizePixel = 0
        lockNotification.Parent = contentPane
        
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 24, 0, 24)
        lockIcon.Position = UDim2.new(0, 10, 0.5, -12)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://6031225819" -- Lock icon
        lockIcon.Parent = lockNotification
        
        local lockText = Instance.new("TextLabel")
        lockText.Size = UDim2.new(1, -50, 1, 0)
        lockText.Position = UDim2.new(0, 40, 0, 0)
        lockText.BackgroundTransparency = 1
        lockText.Text = "This key is currently locked by another session. Read-only mode enabled."
        lockText.TextColor3 = Color3.fromRGB(255, 255, 255)
        lockText.TextXAlignment = Enum.TextXAlignment.Left
        lockText.Font = Enum.Font.SourceSansBold
        lockText.TextSize = 14
        lockText.Parent = lockNotification
        
        local forceUnlockBtn = Instance.new("TextButton")
        forceUnlockBtn.Size = UDim2.new(0, 120, 0, 28)
        forceUnlockBtn.Position = UDim2.new(1, -130, 0.5, -14)
        forceUnlockBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        forceUnlockBtn.BorderSizePixel = 0
        forceUnlockBtn.Text = "Force Unlock"
        forceUnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        forceUnlockBtn.Parent = lockNotification
        
        forceUnlockBtn.MouseButton1Click:Connect(function()
            SessionManager.forceReleaseLock(dataStoreName, keyName)
            KeyContentUI.displayKeyContent(DataExplorer, dataStoreName, keyName, SchemaManager, SessionManager, CacheManager, PerformanceMonitor) -- Refresh
        end)
    end
    
    -- Retrieve schema if exists for current datastore/key
    local currentSchema = SchemaManager.loadSchema(dataStoreName, keyName)
    
    -- Create header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 60)
    headerFrame.Position = UDim2.new(0, 0, 0, lockAcquired and 0 or 50)
    headerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = contentPane
    
    -- Display the key name and datastore
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, -20, 0, 24)
    keyTitle.Position = UDim2.new(0, 10, 0, 5)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = keyName
    keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyTitle.TextXAlignment = Enum.TextXAlignment.Left
    keyTitle.Font = Enum.Font.SourceSansBold
    keyTitle.TextSize = 18
    keyTitle.Parent = headerFrame
    
    local datastoreSubtitle = Instance.new("TextLabel")
    datastoreSubtitle.Size = UDim2.new(1, -20, 0, 18)
    datastoreSubtitle.Position = UDim2.new(0, 10, 0, 30)
    datastoreSubtitle.BackgroundTransparency = 1
    datastoreSubtitle.Text = "DataStore: " .. dataStoreName
    datastoreSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    datastoreSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    datastoreSubtitle.Font = Enum.Font.SourceSans
    datastoreSubtitle.TextSize = 14
    datastoreSubtitle.Parent = headerFrame
    
    -- Add button panel for actions
    local actionPanel = Instance.new("Frame")
    actionPanel.Size = UDim2.new(0, 300, 0, 50)
    actionPanel.Position = UDim2.new(1, -310, 0, 5)
    actionPanel.BackgroundTransparency = 1
    actionPanel.Parent = headerFrame
    
    local panelLayout = Instance.new("UIListLayout")
    panelLayout.FillDirection = Enum.FillDirection.Horizontal
    panelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    panelLayout.Padding = UDim.new(0, 10)
    panelLayout.Parent = actionPanel
    
    -- Create validation message area
    local validationMessageFrame = Instance.new("Frame")
    validationMessageFrame.Size = UDim2.new(1, 0, 0, 0) -- Will auto-expand if needed
    validationMessageFrame.Position = UDim2.new(0, 0, 0, headerFrame.Position.Y.Offset + headerFrame.Size.Y.Offset)
    validationMessageFrame.BackgroundTransparency = 1
    validationMessageFrame.Visible = false
    validationMessageFrame.Name = "ValidationMessageFrame"
    validationMessageFrame.Parent = contentPane
    
    local validationMessage = Instance.new("TextLabel")
    validationMessage.Size = UDim2.new(1, -20, 1, 0)
    validationMessage.Position = UDim2.new(0, 10, 0, 0)
    validationMessage.BackgroundTransparency = 1
    validationMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
    validationMessage.TextXAlignment = Enum.TextXAlignment.Left
    validationMessage.TextWrapped = true
    validationMessage.Font = Enum.Font.SourceSans
    validationMessage.TextSize = 14
    validationMessage.Name = "ValidationMessage"
    validationMessage.Parent = validationMessageFrame
    
    -- Add a tab system for different views
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabsFrame.Position = UDim2.new(0, 0, 0, headerFrame.Position.Y.Offset + headerFrame.Size.Y.Offset)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = contentPane
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 2)
    tabsLayout.Parent = tabsFrame
    
    -- Create content area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 1, -(tabsFrame.Position.Y.Offset + tabsFrame.Size.Y.Offset + 10))
    contentArea.Position = UDim2.new(0, 0, 0, tabsFrame.Position.Y.Offset + tabsFrame.Size.Y.Offset + 5)
    contentArea.BackgroundTransparency = 1
    contentArea.Name = "ContentArea"
    contentArea.Parent = contentPane
    
    -- Function to create a tab
    local function createTab(name, selected)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(0, 100, 1, 0)
        tab.BackgroundColor3 = selected and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
        tab.BorderSizePixel = 0
        tab.Text = name
        tab.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        tab.Font = Enum.Font.SourceSansSemibold
        tab.Name = "Tab_" .. name
        tab.Parent = tabsFrame
        
        return tab
    end
    
    -- Function to create a view container
    local function createViewContainer(name)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Visible = false
        container.Name = "View_" .. name
        container.Parent = contentArea
        
        return container
    end
    
    -- Create tabs and view containers
    local tabJsonEditor = createTab("JSON Editor", true)
    local tabTreeView = createTab("Tree View", false)
    local tabRawView = createTab("Raw View", false)
    local tabVisualizer = createTab("Visualizer", false)
    local tabSchema = createTab("Schema", false)
    
    local viewJsonEditor = createViewContainer("JSON Editor")
    local viewTreeView = createViewContainer("Tree View")
    local viewRawView = createViewContainer("Raw View")
    local viewVisualizer = createViewContainer("Visualizer")
    local viewSchema = createViewContainer("Schema")
    
    -- Make JSON Editor visible by default
    viewJsonEditor.Visible = true
    
    -- Function to switch tabs
    local function switchTab(selectedTabName)
        for _, tab in ipairs(tabsFrame:GetChildren()) do
            if tab:IsA("TextButton") then
                local isSelected = tab.Name == "Tab_" .. selectedTabName
                tab.BackgroundColor3 = isSelected and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
                tab.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            end
        end
        
        for _, view in ipairs(contentArea:GetChildren()) do
            if view:IsA("Frame") then
                view.Visible = view.Name == "View_" .. selectedTabName
            end
        end
    end
    
    -- Connect tab click events
    tabJsonEditor.MouseButton1Click:Connect(function() switchTab("JSON Editor") end)
    tabTreeView.MouseButton1Click:Connect(function() switchTab("Tree View") end)
    tabRawView.MouseButton1Click:Connect(function() switchTab("Raw View") end)
    tabVisualizer.MouseButton1Click:Connect(function() switchTab("Visualizer") end)
    tabSchema.MouseButton1Click:Connect(function() switchTab("Schema") end)
    
    -- Fetch the data from DataStore
    local dataStore = DataStoreService:GetDataStore(dataStoreName)
    
    -- Check cache first before fetching from DataStore
    local cachedData = CacheManager.get(dataStoreName, keyName)
    local success, data, operationDuration
    
    if cachedData then
        success, data = true, cachedData
        print("DataExplorer: Retrieved data from cache for", dataStoreName .. ":" .. keyName)
    else
        success, data, operationDuration = PerformanceMonitor.timeOperation(
            function()
                return pcall(function() return dataStore:GetAsync(keyName) end)
            end,
            "GetAsync", dataStoreName, keyName
        )
        print("Operation: GetAsync, Duration:", operationDuration)
        
        -- Cache the data if retrieved successfully
        if success and data then
            CacheManager.set(dataStoreName, keyName, data, 300) -- Cache for 5 minutes
        end
    end
    
    if not success or not data then
        -- Show error
        validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
        validationMessageFrame.Visible = true
        validationMessage.Text = "Error loading data: " .. tostring(data or "Data not found")
        return
    end
    
    -- Convert data to a JSON-encoded string for editing
    local encodedData = HttpService:JSONEncode(data)
    
    -- TODO: Implement each view's specific content population logic here
    
    -- For debugging - display raw JSON in the JSON Editor view
    local jsonTextBox = Instance.new("TextBox")
    jsonTextBox.Size = UDim2.new(1, -20, 1, -20)
    jsonTextBox.Position = UDim2.new(0, 10, 0, 10)
    jsonTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    jsonTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    jsonTextBox.Font = Enum.Font.Code
    jsonTextBox.TextSize = 14
    jsonTextBox.ClearTextOnFocus = false
    jsonTextBox.TextXAlignment = Enum.TextXAlignment.Left
    jsonTextBox.TextYAlignment = Enum.TextYAlignment.Top
    jsonTextBox.TextWrapped = false
    jsonTextBox.Text = encodedData
    jsonTextBox.MultiLine = true
    jsonTextBox.Parent = viewJsonEditor
end

return KeyContentUI
