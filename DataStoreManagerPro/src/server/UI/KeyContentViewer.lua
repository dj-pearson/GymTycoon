-- KeyContentViewer.lua
-- Responsible for displaying and editing key content with various view modes

local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

local KeyContentViewer = {}

-- Function to create a text label with consistent styling
local function createLabel(text, parent)
    local label = Instance.new("TextButton")
    label.BorderSizePixel = 0
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.AutoButtonColor = false
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Parent = parent
    return label
end

function KeyContentViewer.displayKeyContent(DataExplorer, dataStoreName, keyName, SchemaManager, SessionManager, CacheManager, PerformanceMonitor)
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
            DataExplorer.displayKeyContent(dataStoreName, keyName) -- Refresh
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
            if tab:IsA("TextButton") and tab.Name:match("^Tab_") then
                local isSelected = tab.Name == "Tab_" .. selectedTabName
                tab.BackgroundColor3 = isSelected and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
                tab.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            end
        end
        
        for _, view in ipairs(contentArea:GetChildren()) do
            if view:IsA("Frame") and view.Name:match("^View_") then
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
            "GetAsync",
            function() return pcall(dataStore.GetAsync, dataStore, keyName) end,
            dataStoreName,
            keyName
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
        validationMessageFrame.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        validationMessageFrame.BackgroundTransparency = 0.7
        validationMessage.Text = "Error fetching data: " .. (not success and tostring(data) or "No data found")
        return
    end
    
    -- Convert data to a JSON-encoded string for editing
    local encodedData = HttpService:JSONEncode(data)
    
    -- Save function
    local function saveData(dataToSave)
        if not lockAcquired then
            validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
            validationMessageFrame.Visible = true
            validationMessageFrame.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            validationMessageFrame.BackgroundTransparency = 0.7
            validationMessage.Text = "Cannot save: Key is locked by another session"
            return false
        end
        
        -- Validate data before saving
        if currentSchema then
            local isValid, validationResult = SchemaManager.validateData(dataToSave, currentSchema)
            if not isValid then
                validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
                validationMessageFrame.Visible = true
                validationMessageFrame.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
                validationMessageFrame.BackgroundTransparency = 0.7
                validationMessage.Text = "Data validation failed: " .. validationResult
                return false
            end
        end
        
        -- Save the data
        local success2, result, operationDuration2 = PerformanceMonitor.timeOperation(
            "SetAsync",
            function() return pcall(dataStore.SetAsync, dataStore, keyName, dataToSave) end,
            dataStoreName,
            keyName
        )
        print("Operation: SetAsync, Duration:", operationDuration2)
        
        if success2 then
            -- Update cache
            CacheManager.set(dataStoreName, keyName, dataToSave, 300)
            
            -- Show success message
            validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
            validationMessageFrame.Visible = true
            validationMessageFrame.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            validationMessageFrame.BackgroundTransparency = 0.7
            validationMessage.Text = "Data saved successfully"
            validationMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Hide the message after 3 seconds
            task.delay(3, function()
                validationMessageFrame.Visible = false
            end)
            
            return true
        else
            -- Show error message
            validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
            validationMessageFrame.Visible = true
            validationMessageFrame.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            validationMessageFrame.BackgroundTransparency = 0.7
            validationMessage.Text = "Error saving data: " .. tostring(result)
            validationMessage.TextColor3 = Color3.fromRGB(255, 100, 100)
            return false
        end
    end
    
    -- Create and populate the JSON Editor view
    KeyContentViewer.createJsonEditorView(viewJsonEditor, encodedData, data, lockAcquired, saveData)
    
    -- Create and populate the Tree View
    KeyContentViewer.createTreeView(viewTreeView, data, lockAcquired)
    
    -- Create and populate the Raw View
    KeyContentViewer.createRawView(viewRawView, encodedData)
    
    -- Create and populate the Visualizer View
    KeyContentViewer.createVisualizerView(viewVisualizer, data)
    
    -- Create and populate the Schema View
    KeyContentViewer.createSchemaView(viewSchema, dataStoreName, keyName, data, currentSchema, SchemaManager)
end

function KeyContentViewer.createJsonEditorView(viewContainer, encodedData, originalData, editable, saveCallback)
    -- Create JSON editor
    local editorFrame = Instance.new("Frame")
    editorFrame.Size = UDim2.new(1, 0, 1, -60) -- Leave space for buttons at bottom
    editorFrame.BackgroundTransparency = 1
    editorFrame.Parent = viewContainer
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    scrollFrame.Parent = editorFrame
    
    local jsonEdit = Instance.new("TextBox")
    jsonEdit.Size = UDim2.new(1, -20, 1, 0)
    jsonEdit.Position = UDim2.new(0, 10, 0, 0)
    jsonEdit.ClearTextOnFocus = false
    jsonEdit.MultiLine = true
    jsonEdit.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    jsonEdit.PlaceholderText = "JSON Data"
    jsonEdit.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    jsonEdit.BorderSizePixel = 0
    jsonEdit.Font = Enum.Font.Code
    jsonEdit.TextSize = 14
    jsonEdit.TextColor3 = Color3.fromRGB(230, 230, 230)
    jsonEdit.TextXAlignment = Enum.TextXAlignment.Left
    jsonEdit.TextYAlignment = Enum.TextYAlignment.Top
    jsonEdit.Text = encodedData
    jsonEdit.Parent = scrollFrame
    
    -- Pretty print button
    local buttonPanel = Instance.new("Frame")
    buttonPanel.Size = UDim2.new(1, 0, 0, 50)
    buttonPanel.Position = UDim2.new(0, 0, 1, -50)
    buttonPanel.BackgroundTransparency = 1
    buttonPanel.Parent = viewContainer
    
    local prettyPrintBtn = Instance.new("TextButton")
    prettyPrintBtn.Size = UDim2.new(0, 120, 0, 30)
    prettyPrintBtn.Position = UDim2.new(0, 10, 0, 10)
    prettyPrintBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    prettyPrintBtn.BorderSizePixel = 0
    prettyPrintBtn.Text = "Format JSON"
    prettyPrintBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    prettyPrintBtn.Font = Enum.Font.SourceSansSemibold
    prettyPrintBtn.TextSize = 14
    prettyPrintBtn.Parent = buttonPanel
    
    -- Add rounded corners
    local prettyBtnCorner = Instance.new("UICorner")
    prettyBtnCorner.CornerRadius = UDim.new(0, 4)
    prettyBtnCorner.Parent = prettyPrintBtn
    
    -- Save button
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0, 100, 0, 30)
    saveBtn.Position = UDim2.new(1, -110, 0, 10)
    saveBtn.BackgroundColor3 = editable and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(100, 100, 100)
    saveBtn.BorderSizePixel = 0
    saveBtn.Text = "Save"
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.Font = Enum.Font.SourceSansBold
    saveBtn.TextSize = 14
    saveBtn.Enabled = editable
    saveBtn.Parent = buttonPanel
    
    -- Add rounded corners
    local saveBtnCorner = Instance.new("UICorner")
    saveBtnCorner.CornerRadius = UDim.new(0, 4)
    saveBtnCorner.Parent = saveBtn
    
    -- Pretty print function
    prettyPrintBtn.MouseButton1Click:Connect(function()
        local success, data = pcall(function()
            return HttpService:JSONDecode(jsonEdit.Text)
        end)
        
        if success then
            jsonEdit.Text = HttpService:JSONEncode(data)
        end
    end)
    
    -- Save function
    saveBtn.MouseButton1Click:Connect(function()
        local success, jsonData = pcall(function()
            return HttpService:JSONDecode(jsonEdit.Text)
        end)
        
        if success then
            saveCallback(jsonData)
        else
            -- Show error
            local parent = viewContainer.Parent.Parent
            local validationMessageFrame = parent:FindFirstChild("ValidationMessageFrame")
            if validationMessageFrame then
                validationMessageFrame.Size = UDim2.new(1, 0, 0, 40)
                validationMessageFrame.Visible = true
                validationMessageFrame.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
                validationMessageFrame.BackgroundTransparency = 0.7
                local validationMessage = validationMessageFrame:FindFirstChild("ValidationMessage")
                if validationMessage then
                    validationMessage.Text = "Invalid JSON: " .. tostring(jsonData)
                end
            end
        end
    end)
end

function KeyContentViewer.createTreeView(viewContainer, data, editable)
    -- Create tree view container
    local treeContainer = Instance.new("ScrollingFrame")
    treeContainer.Size = UDim2.new(1, 0, 1, 0)
    treeContainer.BackgroundTransparency = 1
    treeContainer.BorderSizePixel = 0
    treeContainer.ScrollBarThickness = 8
    treeContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    treeContainer.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    treeContainer.Parent = viewContainer
    
    local treeLayout = Instance.new("UIListLayout")
    treeLayout.FillDirection = Enum.FillDirection.Vertical
    treeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    treeLayout.Padding = UDim.new(0, 2)
    treeLayout.Parent = treeContainer
    
    -- Function to recursively build tree view
    local function buildTreeNode(parent, key, value, depth, index)
        local nodeFrame = Instance.new("Frame")
        nodeFrame.Size = UDim2.new(1, -20, 0, 24)
        nodeFrame.Position = UDim2.new(0, depth * 20, 0, 0)
        nodeFrame.BackgroundTransparency = 1
        nodeFrame.LayoutOrder = index
        nodeFrame.Parent = parent
        
        local expandBtn = Instance.new("TextButton")
        expandBtn.Size = UDim2.new(0, 20, 0, 20)
        expandBtn.Position = UDim2.new(0, 0, 0, 2)
        expandBtn.BackgroundTransparency = 1
        expandBtn.Text = "+"
        expandBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
        expandBtn.Font = Enum.Font.SourceSansBold
        expandBtn.TextSize = 16
        expandBtn.Visible = typeof(value) == "table"
        expandBtn.Parent = nodeFrame
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0.5, -30, 1, 0)
        keyLabel.Position = UDim2.new(0, 25, 0, 0)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Text = tostring(key) .. ":"
        keyLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
        keyLabel.Font = Enum.Font.Code
        keyLabel.TextSize = 14
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.Parent = nodeFrame
        
        local valueContainer = Instance.new("Frame")
        valueContainer.Size = UDim2.new(0.5, 0, 1, 0)
        valueContainer.Position = UDim2.new(0.5, 0, 0, 0)
        valueContainer.BackgroundTransparency = 1
        valueContainer.Parent = nodeFrame
        
        local valueDisplay
        
        if typeof(value) == "table" then
            -- For tables, show a placeholder
            valueDisplay = Instance.new("TextLabel")
            valueDisplay.Size = UDim2.new(1, 0, 1, 0)
            valueDisplay.BackgroundTransparency = 1
            valueDisplay.Text = "{...}" -- Placeholder for table
            valueDisplay.TextColor3 = Color3.fromRGB(120, 180, 120)
            valueDisplay.Font = Enum.Font.Code
            valueDisplay.TextSize = 14
            valueDisplay.TextXAlignment = Enum.TextXAlignment.Left
            valueDisplay.Parent = valueContainer
            
            -- Create container for children (initially hidden)
            local childrenContainer = Instance.new("Frame")
            childrenContainer.Size = UDim2.new(1, 0, 0, 0) -- Will grow as children are added
            childrenContainer.Position = UDim2.new(0, 0, 1, 2)
            childrenContainer.BackgroundTransparency = 1
            childrenContainer.Visible = false
            childrenContainer.Parent = nodeFrame
            
            local childLayout = Instance.new("UIListLayout")
            childLayout.FillDirection = Enum.FillDirection.Vertical
            childLayout.SortOrder = Enum.SortOrder.LayoutOrder
            childLayout.Padding = UDim.new(0, 2)
            childLayout.Parent = childrenContainer
            
            -- Toggle children visibility when expand button is clicked
            expandBtn.MouseButton1Click:Connect(function()
                childrenContainer.Visible = not childrenContainer.Visible
                expandBtn.Text = childrenContainer.Visible and "-" or "+"
                
                -- Lazy-load children if not already loaded
                if childrenContainer.Visible and #childrenContainer:GetChildren() <= 1 then
                    local childIndex = 1
                    for k, v in pairs(value) do
                        buildTreeNode(childrenContainer, k, v, depth + 1, childIndex)
                        childIndex = childIndex + 1
                    end
                end
            end)
        else
            -- For primitive values, show the value
            valueDisplay = Instance.new("TextBox")
            valueDisplay.Size = UDim2.new(1, 0, 1, 0)
            valueDisplay.BackgroundTransparency = 0.9
            valueDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            valueDisplay.BorderSizePixel = 0
            valueDisplay.Text = typeof(value) == "string" and '"'..tostring(value)..'"' or tostring(value)
            valueDisplay.TextColor3 = typeof(value) == "string" and Color3.fromRGB(220, 180, 120) or 
                                      typeof(value) == "number" and Color3.fromRGB(120, 220, 180) or
                                      typeof(value) == "boolean" and Color3.fromRGB(220, 120, 180) or
                                      Color3.fromRGB(180, 180, 180)
            valueDisplay.Font = Enum.Font.Code
            valueDisplay.TextSize = 14
            valueDisplay.TextXAlignment = Enum.TextXAlignment.Left
            valueDisplay.ClearTextOnFocus = false
            valueDisplay.ClipsDescendants = true
            valueDisplay.TextTruncate = Enum.TextTruncate.AtEnd
            valueDisplay.Parent = valueContainer
            valueDisplay.Enabled = editable
        end
    end
    
    -- Build the tree view from the root data
    if typeof(data) == "table" then
        local index = 1
        for key, value in pairs(data) do
            buildTreeNode(treeContainer, key, value, 0, index)
            index = index + 1
        end
    else
        -- For non-table data, show directly
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, -20, 0, 24)
        valueLabel.Position = UDim2.new(0, 10, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(data)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.Font = Enum.Font.Code
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.Parent = treeContainer
    end
end

function KeyContentViewer.createRawView(viewContainer, encodedData)
    -- Create raw view display
    local rawScrollFrame = Instance.new("ScrollingFrame")
    rawScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    rawScrollFrame.BackgroundTransparency = 1
    rawScrollFrame.BorderSizePixel = 0
    rawScrollFrame.ScrollBarThickness = 8
    rawScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    rawScrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    rawScrollFrame.Parent = viewContainer
    
    local rawTextLabel = Instance.new("TextLabel")
    rawTextLabel.Size = UDim2.new(1, -20, 0, 0) -- Height will be adjusted
    rawTextLabel.Position = UDim2.new(0, 10, 0, 0)
    rawTextLabel.BackgroundTransparency = 1
    rawTextLabel.Text = encodedData
    rawTextLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    rawTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    rawTextLabel.TextYAlignment = Enum.TextYAlignment.Top
    rawTextLabel.TextWrapped = true
    rawTextLabel.Font = Enum.Font.Code
    rawTextLabel.TextSize = 14
    rawTextLabel.AutomaticSize = Enum.AutomaticSize.Y
    rawTextLabel.Parent = rawScrollFrame
end

function KeyContentViewer.createVisualizerView(viewContainer, data)
    -- Create visualizer container
    local visualizerFrame = Instance.new("Frame")
    visualizerFrame.Size = UDim2.new(1, 0, 1, 0)
    visualizerFrame.BackgroundTransparency = 1
    visualizerFrame.Parent = viewContainer
    
    -- Create info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 30)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Visualization of data structure"
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 16
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = visualizerFrame
    
    -- Implement basic data visualization based on data type
    if typeof(data) == "table" then
        -- Create a container for the visualization
        local vizContainer = Instance.new("Frame")
        vizContainer.Size = UDim2.new(1, -20, 1, -50)
        vizContainer.Position = UDim2.new(0, 10, 0, 40)
        vizContainer.BackgroundTransparency = 1
        vizContainer.Parent = visualizerFrame
        
        -- Determine what kind of visualization to create based on data structure
        local dataType = "generic"
        
        -- Check if it's an array
        local isArray = true
        local maxIndex = 0
        for k in pairs(data) do
            if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
                isArray = false
                break
            end
            maxIndex = math.max(maxIndex, k)
        end
        if isArray and maxIndex > 0 and maxIndex <= 1000 then
            dataType = "array"
        end
        
        if dataType == "array" then
            -- Create array visualization
            local arrayLayout = Instance.new("UIListLayout")
            arrayLayout.FillDirection = Enum.FillDirection.Horizontal
            arrayLayout.SortOrder = Enum.SortOrder.LayoutOrder
            arrayLayout.Padding = UDim.new(0, 5)
            arrayLayout.Parent = vizContainer
            
            for i = 1, maxIndex do
                local itemValue = data[i]
                
                local itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(0, 100, 0, 100)
                itemFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                itemFrame.BorderSizePixel = 0
                itemFrame.LayoutOrder = i
                itemFrame.Parent = vizContainer
                
                local cornerRadius = Instance.new("UICorner")
                cornerRadius.CornerRadius = UDim.new(0, 8)
                cornerRadius.Parent = itemFrame
                
                local indexLabel = Instance.new("TextLabel")
                indexLabel.Size = UDim2.new(1, 0, 0, 24)
                indexLabel.Position = UDim2.new(0, 0, 0, 5)
                indexLabel.BackgroundTransparency = 1
                indexLabel.Text = tostring(i)
                indexLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
                indexLabel.Font = Enum.Font.SourceSansSemibold
                indexLabel.TextSize = 16
                indexLabel.Parent = itemFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(1, -10, 1, -34)
                valueLabel.Position = UDim2.new(0, 5, 0, 34)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = typeof(itemValue) == "table" and "{...}" or tostring(itemValue)
                valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                valueLabel.Font = Enum.Font.Code
                valueLabel.TextSize = 14
                valueLabel.TextWrapped = true
                valueLabel.Parent = itemFrame
            end
        else
            -- Generic object visualization
            local objectLayout = Instance.new("UIGridLayout")
            objectLayout.CellSize = UDim2.new(0, 150, 0, 120)
            objectLayout.CellPadding = UDim2.new(0, 10, 0, 10)
            objectLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            objectLayout.StartCorner = Enum.StartCorner.TopLeft
            objectLayout.SortOrder = Enum.SortOrder.Name
            objectLayout.Parent = vizContainer
            
            for key, value in pairs(data) do
                local propertyFrame = Instance.new("Frame")
                propertyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                propertyFrame.BorderSizePixel = 0
                propertyFrame.Name = tostring(key)
                propertyFrame.Parent = vizContainer
                
                local cornerRadius = Instance.new("UICorner")
                cornerRadius.CornerRadius = UDim.new(0, 8)
                cornerRadius.Parent = propertyFrame
                
                local keyLabel = Instance.new("TextLabel")
                keyLabel.Size = UDim2.new(1, -10, 0, 24)
                keyLabel.Position = UDim2.new(0, 5, 0, 5)
                keyLabel.BackgroundTransparency = 1
                keyLabel.Text = tostring(key)
                keyLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
                keyLabel.Font = Enum.Font.SourceSansSemibold
                keyLabel.TextSize = 16
                keyLabel.TextWrapped = true
                keyLabel.Parent = propertyFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(1, -10, 1, -34)
                valueLabel.Position = UDim2.new(0, 5, 0, 34)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = typeof(value) == "table" and "{...}" or tostring(value)
                valueLabel.TextColor3 = typeof(value) == "string" and Color3.fromRGB(220, 180, 120) or 
                                     typeof(value) == "number" and Color3.fromRGB(120, 220, 180) or
                                     typeof(value) == "boolean" and Color3.fromRGB(220, 120, 180) or
                                     Color3.fromRGB(200, 200, 200)
                valueLabel.Font = Enum.Font.Code
                valueLabel.TextSize = 14
                valueLabel.TextWrapped = true
                valueLabel.Parent = propertyFrame
            end
        end
    else
        -- Simple visualization for primitive types
        local valueFrame = Instance.new("Frame")
        valueFrame.Size = UDim2.new(1, -20, 0, 100)
        valueFrame.Position = UDim2.new(0, 10, 0, 50)
        valueFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
        valueFrame.BorderSizePixel = 0
        valueFrame.Parent = visualizerFrame
        
        local cornerRadius = Instance.new("UICorner")
        cornerRadius.CornerRadius = UDim.new(0, 8)
        cornerRadius.Parent = valueFrame
        
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Size = UDim2.new(1, -20, 0, 24)
        typeLabel.Position = UDim2.new(0, 10, 0, 10)
        typeLabel.BackgroundTransparency = 1
        typeLabel.Text = "Type: " .. typeof(data)
        typeLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        typeLabel.Font = Enum.Font.SourceSansSemibold
        typeLabel.TextSize = 16
        typeLabel.TextXAlignment = Enum.TextXAlignment.Left
        typeLabel.Parent = valueFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, -20, 0, 24)
        valueLabel.Position = UDim2.new(0, 10, 0, 40)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = "Value: " .. tostring(data)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.Font = Enum.Font.Code
        valueLabel.TextSize = 16
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextWrapped = true
        valueLabel.Parent = valueFrame
    end
end

function KeyContentViewer.createSchemaView(viewContainer, dataStoreName, keyName, data, currentSchema, SchemaManager)
    -- Create schema container
    local schemaFrame = Instance.new("Frame")
    schemaFrame.Size = UDim2.new(1, 0, 1, 0)
    schemaFrame.BackgroundTransparency = 1
    schemaFrame.Parent = viewContainer
    
    -- Schema status section
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 60)
    statusFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = schemaFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusIcon = Instance.new("ImageLabel")
    statusIcon.Size = UDim2.new(0, 32, 0, 32)
    statusIcon.Position = UDim2.new(0, 10, 0.5, -16)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Image = currentSchema and "rbxassetid://6031068430" or "rbxassetid://6031068433" -- Check or X icon
    statusIcon.Parent = statusFrame
    
    local statusTitle = Instance.new("TextLabel")
    statusTitle.Size = UDim2.new(1, -60, 0, 24)
    statusTitle.Position = UDim2.new(0, 50, 0, 5)
    statusTitle.BackgroundTransparency = 1
    statusTitle.Text = currentSchema and "Schema Found" or "No Schema Defined"
    statusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusTitle.Font = Enum.Font.SourceSansBold
    statusTitle.TextSize = 16
    statusTitle.TextXAlignment = Enum.TextXAlignment.Left
    statusTitle.Parent = statusFrame
    
    local statusDesc = Instance.new("TextLabel")
    statusDesc.Size = UDim2.new(1, -60, 0, 20)
    statusDesc.Position = UDim2.new(0, 50, 0, 30)
    statusDesc.BackgroundTransparency = 1
    statusDesc.Text = currentSchema and "This key has a defined schema" or "Create a schema to enforce data structure"
    statusDesc.TextColor3 = Color3.fromRGB(180, 180, 200)
    statusDesc.Font = Enum.Font.SourceSans
    statusDesc.TextSize = 14
    statusDesc.TextXAlignment = Enum.TextXAlignment.Left
    statusDesc.Parent = statusFrame
    
    -- Schema actions
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Size = UDim2.new(1, 0, 0, 50)
    actionsFrame.Position = UDim2.new(0, 0, 0, 70)
    actionsFrame.BackgroundTransparency = 1
    actionsFrame.Parent = schemaFrame
    
    local actionsLayout = Instance.new("UIListLayout")
    actionsLayout.FillDirection = Enum.FillDirection.Horizontal
    actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    actionsLayout.Padding = UDim.new(0, 10)
    actionsLayout.Parent = actionsFrame
    
    -- Generate Schema button
    local generateBtn = Instance.new("TextButton")
    generateBtn.Size = UDim2.new(0, 160, 0, 40)
    generateBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    generateBtn.BorderSizePixel = 0
    generateBtn.Text = "Generate From Data"
    generateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    generateBtn.Font = Enum.Font.SourceSansSemibold
    generateBtn.TextSize = 14
    generateBtn.Parent = actionsFrame
    
    local generateBtnCorner = Instance.new("UICorner")
    generateBtnCorner.CornerRadius = UDim.new(0, 6)
    generateBtnCorner.Parent = generateBtn
    
    -- Edit Schema button
    local editBtn = Instance.new("TextButton")
    editBtn.Size = UDim2.new(0, 120, 0, 40)
    editBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
    editBtn.BorderSizePixel = 0
    editBtn.Text = currentSchema and "Edit Schema" or "Create Schema"
    editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    editBtn.Font = Enum.Font.SourceSansSemibold
    editBtn.TextSize = 14
    editBtn.Parent = actionsFrame
    
    local editBtnCorner = Instance.new("UICorner")
    editBtnCorner.CornerRadius = UDim.new(0, 6)
    editBtnCorner.Parent = editBtn
    
    -- Display Schema section
    local schemaDisplay = Instance.new("ScrollingFrame")
    schemaDisplay.Size = UDim2.new(1, 0, 1, -130)
    schemaDisplay.Position = UDim2.new(0, 0, 0, 130)
    schemaDisplay.BackgroundTransparency = 1
    schemaDisplay.BorderSizePixel = 0
    schemaDisplay.ScrollBarThickness = 8
    schemaDisplay.CanvasSize = UDim2.new(0, 0, 0, 0)
    schemaDisplay.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    schemaDisplay.Parent = schemaFrame
    
    local schemaContent
    
    if currentSchema then
        -- Create schema content display
        schemaContent = Instance.new("TextLabel")
        schemaContent.Size = UDim2.new(1, -20, 0, 0)
        schemaContent.Position = UDim2.new(0, 10, 0, 0)
        schemaContent.BackgroundTransparency = 1
        schemaContent.Text = HttpService:JSONEncode(currentSchema)
        schemaContent.TextColor3 = Color3.fromRGB(230, 230, 230)
        schemaContent.TextXAlignment = Enum.TextXAlignment.Left
        schemaContent.TextYAlignment = Enum.TextYAlignment.Top
        schemaContent.TextWrapped = true
        schemaContent.Font = Enum.Font.Code
        schemaContent.TextSize = 14
        schemaContent.AutomaticSize = Enum.AutomaticSize.Y
        schemaContent.Parent = schemaDisplay
    else
        -- Create "No schema" message
        schemaContent = Instance.new("TextLabel")
        schemaContent.Size = UDim2.new(1, -20, 0, 30)
        schemaContent.Position = UDim2.new(0, 10, 0, 0)
        schemaContent.BackgroundTransparency = 1
        schemaContent.Text = "No schema defined for this key."
        schemaContent.TextColor3 = Color3.fromRGB(180, 180, 200)
        schemaContent.TextXAlignment = Enum.TextXAlignment.Center
        schemaContent.Font = Enum.Font.SourceSans
        schemaContent.TextSize = 16
        schemaContent.Parent = schemaDisplay
    end
    
    -- Connect button actions
    generateBtn.MouseButton1Click:Connect(function()
        -- Generate schema from current data
        local success, generatedSchema = pcall(function()
            return SchemaManager.generateSchemaFromData(data)
        end)
        
        if success and generatedSchema then
            -- Update the schema display
            if schemaContent then
                schemaContent:Destroy()
            end
            
            schemaContent = Instance.new("TextLabel")
            schemaContent.Size = UDim2.new(1, -20, 0, 0)
            schemaContent.Position = UDim2.new(0, 10, 0, 0)
            schemaContent.BackgroundTransparency = 1
            schemaContent.Text = HttpService:JSONEncode(generatedSchema)
            schemaContent.TextColor3 = Color3.fromRGB(230, 230, 230)
            schemaContent.TextXAlignment = Enum.TextXAlignment.Left
            schemaContent.TextYAlignment = Enum.TextYAlignment.Top
            schemaContent.TextWrapped = true
            schemaContent.Font = Enum.Font.Code
            schemaContent.TextSize = 14
            schemaContent.AutomaticSize = Enum.AutomaticSize.Y
            schemaContent.Parent = schemaDisplay
            
            -- Update schema status
            statusTitle.Text = "Generated Schema (Not Saved)"
            statusDesc.Text = "Click 'Save Schema' to save this schema"
            
            -- Create save button
            local saveSchemaBtn = actionsFrame:FindFirstChild("SaveSchemaBtn")
            if not saveSchemaBtn then
                saveSchemaBtn = Instance.new("TextButton")
                saveSchemaBtn.Size = UDim2.new(0, 120, 0, 40)
                saveSchemaBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
                saveSchemaBtn.BorderSizePixel = 0
                saveSchemaBtn.Text = "Save Schema"
                saveSchemaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                saveSchemaBtn.Font = Enum.Font.SourceSansSemibold
                saveSchemaBtn.TextSize = 14
                saveSchemaBtn.Name = "SaveSchemaBtn"
                saveSchemaBtn.Parent = actionsFrame
                
                local saveSchemaBtnCorner = Instance.new("UICorner")
                saveSchemaBtnCorner.CornerRadius = UDim.new(0, 6)
                saveSchemaBtnCorner.Parent = saveSchemaBtn
                
                saveSchemaBtn.MouseButton1Click:Connect(function()
                    -- Save the generated schema
                    SchemaManager.saveSchema(dataStoreName, keyName, generatedSchema)
                    
                    -- Update UI to reflect changes
                    statusTitle.Text = "Schema Saved"
                    statusDesc.Text = "This key now has a defined schema"
                    statusIcon.Image = "rbxassetid://6031068430" -- Check icon
                    
                    -- Update button
                    editBtn.Text = "Edit Schema"
                    saveSchemaBtn.Visible = false
                end)
            else
                saveSchemaBtn.Visible = true
            end
        end
    end)
    
    editBtn.MouseButton1Click:Connect(function()
        -- Open schema editor
        -- This would typically open a separate UI for editing the schema
        -- For this implementation, we'll just show a placeholder message
        
        if schemaContent then
            schemaContent:Destroy()
        end
        
        local editorPlaceholder = Instance.new("TextLabel")
        editorPlaceholder.Size = UDim2.new(1, -20, 0, 60)
        editorPlaceholder.Position = UDim2.new(0, 10, 0, 0)
        editorPlaceholder.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        editorPlaceholder.BorderSizePixel = 0
        editorPlaceholder.Text = "Schema Editor would open here.\n(Implementation pending)"
        editorPlaceholder.TextColor3 = Color3.fromRGB(180, 180, 200)
        editorPlaceholder.TextXAlignment = Enum.TextXAlignment.Center
        editorPlaceholder.Font = Enum.Font.SourceSans
        editorPlaceholder.TextSize = 16
        editorPlaceholder.Parent = schemaDisplay
        
        local editorCorner = Instance.new("UICorner")
        editorCorner.CornerRadius = UDim.new(0, 6)
        editorCorner.Parent = editorPlaceholder
    end)
end

return KeyContentViewer
