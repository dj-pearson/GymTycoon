-- Main UI component for DataExplorer
local MainUI = {}

-- Helper function to create text labels
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

-- Create the main UI frame
function MainUI.createMainUI(DataExplorer)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    mainFrame.BorderSizePixel = 0
    DataExplorer.mainFrame = mainFrame

    -- Create a split-pane layout (Using ScrollingFrame for potential future scrolling)
    local splitPane = Instance.new("ScrollingFrame")
    splitPane.Size = UDim2.new(1, 0, 1, 0)
    splitPane.Name = "SplitPane"
    splitPane.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted later
    splitPane.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    splitPane.ScrollBarInset = Enum.ScrollBarInset.Always
    splitPane.ElasticBehavior = Enum.ElasticBehavior.Never
    splitPane.Parent = mainFrame
    DataExplorer.splitPane = splitPane    -- Create a UIListLayout for the panes within the ScrollingFrame
    local horizontalLayout = Instance.new("UIListLayout")
    horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
    horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
    horizontalLayout.Parent = splitPane

    -- Create the navigation pane (tree view)
    local navigationPane = Instance.new("Frame")
    navigationPane.Size = UDim2.new(0.3, 0, 1, 0) -- 30% of the width
    navigationPane.Name = "NavigationPane"
    navigationPane.Parent = splitPane
    DataExplorer.navigationPane = navigationPane -- Save the navigation pane for later use

    -- Add a layout for potential items in the navigation pane
    local navigationLayout = Instance.new("UIListLayout")
    navigationLayout.FillDirection = Enum.FillDirection.Vertical
    navigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navigationLayout.Parent = navigationPane
    
    -- Create a Pane to display performance data
    local performancePane = Instance.new("Frame")
    performancePane.Size = UDim2.new(1, 0, 0.2, 0)
    performancePane.Position = UDim2.new(0,0,0.6,0) -- under the treeview
    performancePane.Name = "PerformancePane"
    performancePane.Parent = navigationPane
    DataExplorer.performancePane = performancePane

    -- Create the cache viewer pane
    local cacheViewerPane = Instance.new("Frame")
    cacheViewerPane.Size = UDim2.new(1, 0, 0.4, 0) -- 40% of the height
    cacheViewerPane.Position = UDim2.new(0, 0, 1, 0) -- At the bottom of the Navigation Pane
    cacheViewerPane.Name = "CacheViewerPane"
    cacheViewerPane.Parent = navigationPane
    DataExplorer.cacheViewerPane = cacheViewerPane -- Store the reference to the cache viewer panel
    
    -- Create the lock Status pane
    local lockStatusPane = Instance.new("Frame")
    lockStatusPane.Size = UDim2.new(1, 0, 0.2, 0) -- 20% of the height
    lockStatusPane.Position = UDim2.new(0,0,0.8,0) -- at the bottom of the Navigation Pane
    lockStatusPane.Name = "LockStatusPane"
    lockStatusPane.Parent = navigationPane
    DataExplorer.lockStatusPane = lockStatusPane

    -- Create a title for the lock status pane
    local lockStatusTitle = Instance.new("TextLabel")
    lockStatusTitle.Size = UDim2.new(1, -80, 0, 24)
    lockStatusTitle.Position = UDim2.new(0, 5, 0, 0)
    lockStatusTitle.BackgroundTransparency = 1
    lockStatusTitle.Text = "Session Locks"
    lockStatusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockStatusTitle.Font = Enum.Font.SourceSansBold
    lockStatusTitle.TextSize = 14
    lockStatusTitle.TextXAlignment = Enum.TextXAlignment.Left
    lockStatusTitle.Parent = lockStatusPane
    
    -- Create a button to open the session management UI
    local sessionManagementButton = Instance.new("TextButton")
    sessionManagementButton.Size = UDim2.new(0, 70, 0, 24)
    sessionManagementButton.Position = UDim2.new(1, -75, 0, 0)
    sessionManagementButton.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    sessionManagementButton.BorderSizePixel = 0
    sessionManagementButton.Text = "Manage"
    sessionManagementButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sessionManagementButton.Font = Enum.Font.SourceSansSemibold
    sessionManagementButton.TextSize = 14
    sessionManagementButton.Name = "SessionManagementButton"
    sessionManagementButton.Parent = lockStatusPane
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = sessionManagementButton
    
    -- Create a container for the lock status content
    local lockStatusContent = Instance.new("Frame")
    lockStatusContent.Size = UDim2.new(1, 0, 1, -24)
    lockStatusContent.Position = UDim2.new(0, 0, 0, 24)
    lockStatusContent.BackgroundTransparency = 1
    lockStatusContent.Name = "LockStatusContent"
    lockStatusContent.Parent = lockStatusPane
    DataExplorer.lockStatusContent = lockStatusContent
    
    -- Add a layout for the lock status content
    local lockStatusLayout = Instance.new("UIListLayout")
    lockStatusLayout.FillDirection = Enum.FillDirection.Vertical
    lockStatusLayout.SortOrder = Enum.SortOrder.LayoutOrder
    lockStatusLayout.Padding = UDim.new(0, 2)
    lockStatusLayout.Parent = lockStatusContent

    -- Create the content pane (for displaying data)
    local contentPane = Instance.new("ScrollingFrame")
    contentPane.Size = UDim2.new(0.7, 0, 1, 0) -- 70% of the width
    contentPane.Name = "ContentPane"
    contentPane.Parent = splitPane
    DataExplorer.contentPane = contentPane

    -- Add a layout for potential items in the content pane
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentPane

    -- Add a splitter to resize the panes (This will require scripting later)
    -- Placed outside the horizontal layout to overlap
    local splitter = Instance.new("Frame")
    splitter.Size = UDim2.new(0, 5, 1, 0)    
    splitter.Position = UDim2.new(navigationPane.Size.X.Scale, navigationPane.Size.X.Offset - splitter.Size.X.Offset / 2, 0, 0)
    splitter.Name = "Splitter"
    splitter.Draggable = true
    splitter.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    splitter.ZIndex = 2
    splitter.Parent = mainFrame

    return mainFrame
end

function MainUI.initBulkOperationsUI(DataExplorer, BulkOperationsUI)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open bulk operations
    local bulkOperationsButton = Instance.new("TextButton")
    bulkOperationsButton.Size = UDim2.new(0, 150, 0, 30)
    bulkOperationsButton.Position = UDim2.new(1, -160, 0, 10)
    bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    bulkOperationsButton.BorderSizePixel = 0
    bulkOperationsButton.Text = "Bulk Operations"
    bulkOperationsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    bulkOperationsButton.Font = Enum.Font.SourceSansBold
    bulkOperationsButton.TextSize = 14
    bulkOperationsButton.ZIndex = 5
    bulkOperationsButton.Parent = mainFrame
    
    -- Store reference in DataExplorer
    DataExplorer.bulkOperationsButton = bulkOperationsButton
    
    -- Create the bulk operations container (initially invisible)
    local bulkOperationsContainer = BulkOperationsUI.createTab(mainFrame)
    DataExplorer.bulkOperationsContainer = bulkOperationsContainer
      -- Toggle visibility when button is clicked
    bulkOperationsButton.MouseButton1Click:Connect(function()
        local contentPane = DataExplorer.contentPane
        local navPane = DataExplorer.navigationPane
        
        if bulkOperationsContainer.Visible then
            -- Hide bulk operations and show normal UI
            bulkOperationsContainer.Visible = false
            contentPane.Visible = true
            navPane.Visible = true
            bulkOperationsButton.Text = "Bulk Operations"
            bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        else
            -- Show bulk operations and hide normal UI
            bulkOperationsContainer.Visible = true
            contentPane.Visible = false
            navPane.Visible = false
            bulkOperationsButton.Text = "Back to Explorer"
            bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
              -- Also ensure schema builder is hidden
            if DataExplorer.schemaBuilderContainer and DataExplorer.schemaBuilderContainer.Visible then
                DataExplorer.schemaBuilderContainer.Visible = false
                DataExplorer.schemaBuilderButton.Text = "Schema Builder"
                DataExplorer.schemaBuilderButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            end
        end
    end)
end

return MainUI
