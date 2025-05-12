-- PerformanceAnalyzer UI component for DataExplorer
local PerformanceAnalyzerUI = {}

function PerformanceAnalyzerUI.initPerformanceAnalyzerUI(DataExplorer, PerformanceMonitor)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open performance analyzer
    local performanceAnalyzerButton = Instance.new("TextButton")
    performanceAnalyzerButton.Size = UDim2.new(0, 150, 0, 30)
    performanceAnalyzerButton.Position = UDim2.new(1, -320, 0, 90) -- Below other buttons
    performanceAnalyzerButton.BackgroundColor3 = Color3.fromRGB(150, 100, 150)
    performanceAnalyzerButton.BorderSizePixel = 0
    performanceAnalyzerButton.Text = "Performance Analyzer"
    performanceAnalyzerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    performanceAnalyzerButton.Font = Enum.Font.SourceSansBold
    performanceAnalyzerButton.TextSize = 14
    performanceAnalyzerButton.ZIndex = 5
    performanceAnalyzerButton.Parent = mainFrame
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = performanceAnalyzerButton
    
    -- Create the performance analyzer container (initially invisible)
    local performanceAnalyzerContainer = Instance.new("Frame")
    performanceAnalyzerContainer.Size = UDim2.new(1, 0, 1, 0)
    performanceAnalyzerContainer.Position = UDim2.new(0, 0, 0, 0)
    performanceAnalyzerContainer.BackgroundColor3 = Color3.fromRGB(35, 30, 35)
    performanceAnalyzerContainer.BorderSizePixel = 0
    performanceAnalyzerContainer.Visible = false
    performanceAnalyzerContainer.ZIndex = 10
    performanceAnalyzerContainer.Parent = mainFrame
    
    -- Save reference to the container
    DataExplorer.performanceAnalyzerContainer = performanceAnalyzerContainer
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = performanceAnalyzerContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Performance Analyzer"
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
    contentArea.BackgroundColor3 = Color3.fromRGB(35, 30, 35)
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = performanceAnalyzerContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    -- Overview Section
    local overviewSection = Instance.new("Frame")
    overviewSection.Size = UDim2.new(0.9, 0, 0, 160)
    overviewSection.BackgroundColor3 = Color3.fromRGB(50, 40, 50)
    overviewSection.BorderSizePixel = 0
    overviewSection.LayoutOrder = 1
    overviewSection.Parent = contentArea
    
    -- Add rounded corners
    local overviewSectionCorner = Instance.new("UICorner")
    overviewSectionCorner.CornerRadius = UDim.new(0, 8)
    overviewSectionCorner.Parent = overviewSection
    
    local overviewTitle = Instance.new("TextLabel")
    overviewTitle.Size = UDim2.new(1, 0, 0, 30)
    overviewTitle.Position = UDim2.new(0, 0, 0, 0)
    overviewTitle.BackgroundTransparency = 1
    overviewTitle.Text = "Performance Overview"
    overviewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    overviewTitle.Font = Enum.Font.SourceSansBold
    overviewTitle.TextSize = 16
    overviewTitle.Parent = overviewSection
    
    -- Create stat items
    local createStatItem = function(name, value, yPos)
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.95, 0, 0, 30)
        statFrame.Position = UDim2.new(0.025, 0, 0, yPos)
        statFrame.BackgroundColor3 = Color3.fromRGB(60, 50, 60)
        statFrame.BorderSizePixel = 0
        statFrame.Parent = overviewSection
        
        -- Add rounded corners
        local statFrameCorner = Instance.new("UICorner")
        statFrameCorner.CornerRadius = UDim.new(0, 4)
        statFrameCorner.Parent = statFrame
        
        local statName = Instance.new("TextLabel")
        statName.Size = UDim2.new(0.6, 0, 1, 0)
        statName.Position = UDim2.new(0, 10, 0, 0)
        statName.BackgroundTransparency = 1
        statName.Text = name
        statName.TextColor3 = Color3.fromRGB(220, 220, 220)
        statName.Font = Enum.Font.SourceSans
        statName.TextSize = 14
        statName.TextXAlignment = Enum.TextXAlignment.Left
        statName.Parent = statFrame
        
        local statValue = Instance.new("TextLabel")
        statValue.Size = UDim2.new(0.35, 0, 1, 0)
        statValue.Position = UDim2.new(0.65, 0, 0, 0)
        statValue.BackgroundTransparency = 1
        statValue.Text = value
        statValue.TextColor3 = Color3.fromRGB(255, 255, 255)
        statValue.Font = Enum.Font.SourceSansSemibold
        statValue.TextSize = 14
        statValue.Name = "Value"
        statValue.Parent = statFrame
        
        return statFrame
    end
    
    -- Stats
    local totalOperationsFrame = createStatItem("Total Operations:", "0", 35)
    local avgResponseTimeFrame = createStatItem("Avg. Response Time:", "0 ms", 70)
    local dataStoreUsageFrame = createStatItem("DataStore Usage:", "0 / 0", 105)
    
    -- Details Section
    local detailsSection = Instance.new("Frame")
    detailsSection.Size = UDim2.new(0.9, 0, 0, 250)
    detailsSection.BackgroundColor3 = Color3.fromRGB(50, 40, 50)
    detailsSection.BorderSizePixel = 0
    detailsSection.LayoutOrder = 2
    detailsSection.Parent = contentArea
    
    -- Add rounded corners
    local detailsSectionCorner = Instance.new("UICorner")
    detailsSectionCorner.CornerRadius = UDim.new(0, 8)
    detailsSectionCorner.Parent = detailsSection
    
    local detailsTitle = Instance.new("TextLabel")
    detailsTitle.Size = UDim2.new(1, 0, 0, 30)
    detailsTitle.Position = UDim2.new(0, 0, 0, 0)
    detailsTitle.BackgroundTransparency = 1
    detailsTitle.Text = "Operation Details"
    detailsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    detailsTitle.Font = Enum.Font.SourceSansBold
    detailsTitle.TextSize = 16
    detailsTitle.Parent = detailsSection
    
    -- Create operation type breakdown
    local breakdownLayout = Instance.new("UIGridLayout")
    breakdownLayout.CellSize = UDim2.new(0.48, 0, 0, 40)
    breakdownLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
    
    local breakdownFrame = Instance.new("Frame")
    breakdownFrame.Size = UDim2.new(0.9, 0, 0, 150)
    breakdownFrame.Position = UDim2.new(0.05, 0, 0, 40)
    breakdownFrame.BackgroundTransparency = 1
    breakdownFrame.Parent = detailsSection
    breakdownLayout.Parent = breakdownFrame
    
    -- Create an operation stat for each type
    local createOpStat = function(name, color)
        local opFrame = Instance.new("Frame")
        opFrame.BackgroundColor3 = Color3.fromRGB(60, 50, 60)
        opFrame.BorderSizePixel = 0
        opFrame.Parent = breakdownFrame
        
        -- Add rounded corners
        local opFrameCorner = Instance.new("UICorner")
        opFrameCorner.CornerRadius = UDim.new(0, 4)
        opFrameCorner.Parent = opFrame
        
        local opName = Instance.new("TextLabel")
        opName.Size = UDim2.new(1, 0, 0, 20)
        opName.Position = UDim2.new(0, 0, 0, 0)
        opName.BackgroundTransparency = 1
        opName.Text = name
        opName.TextColor3 = Color3.fromRGB(255, 255, 255)
        opName.Font = Enum.Font.SourceSansSemibold
        opName.TextSize = 14
        opName.Parent = opFrame
        
        local colorIndicator = Instance.new("Frame")
        colorIndicator.Size = UDim2.new(0, 12, 0, 12)
        colorIndicator.Position = UDim2.new(0, 10, 0.5, 0)
        colorIndicator.AnchorPoint = Vector2.new(0, 0.5)
        colorIndicator.BackgroundColor3 = color
        colorIndicator.BorderSizePixel = 0
        colorIndicator.Parent = opFrame
        
        -- Add rounded corners to indicator
        local colorIndicatorCorner = Instance.new("UICorner")
        colorIndicatorCorner.CornerRadius = UDim.new(0, 2)
        colorIndicatorCorner.Parent = colorIndicator
        
        local opCount = Instance.new("TextLabel")
        opCount.Size = UDim2.new(0.4, 0, 0, 20)
        opCount.Position = UDim2.new(0.6, 0, 0.5, 0)
        opCount.AnchorPoint = Vector2.new(0, 0.5)
        opCount.BackgroundTransparency = 1
        opCount.Text = "0"
        opCount.TextColor3 = Color3.fromRGB(255, 255, 255)
        opCount.Font = Enum.Font.SourceSansBold
        opCount.TextSize = 14
        opCount.Name = "Count"
        opCount.Parent = opFrame
        
        return opFrame
    end
    
    local getOpFrame = createOpStat("GetAsync", Color3.fromRGB(52, 152, 219))
    local setOpFrame = createOpStat("SetAsync", Color3.fromRGB(46, 204, 113))
    local updateOpFrame = createOpStat("UpdateAsync", Color3.fromRGB(155, 89, 182))
    local removeOpFrame = createOpStat("RemoveAsync", Color3.fromRGB(231, 76, 60))
    
    -- Time chart
    local timeChartFrame = Instance.new("Frame")
    timeChartFrame.Size = UDim2.new(0.9, 0, 0, 40)
    timeChartFrame.Position = UDim2.new(0.05, 0, 0, 200)
    timeChartFrame.BackgroundColor3 = Color3.fromRGB(60, 50, 60)
    timeChartFrame.BorderSizePixel = 0
    timeChartFrame.Parent = detailsSection
    
    -- Add rounded corners
    local timeChartFrameCorner = Instance.new("UICorner")
    timeChartFrameCorner.CornerRadius = UDim.new(0, 4)
    timeChartFrameCorner.Parent = timeChartFrame
    
    local timeChartTitle = Instance.new("TextLabel")
    timeChartTitle.Size = UDim2.new(0.3, 0, 1, 0)
    timeChartTitle.BackgroundTransparency = 1
    timeChartTitle.Text = "Response Time:"
    timeChartTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    timeChartTitle.Font = Enum.Font.SourceSans
    timeChartTitle.TextSize = 14
    timeChartTitle.TextXAlignment = Enum.TextXAlignment.Right
    timeChartTitle.Parent = timeChartFrame
    
    -- Throttling Section
    local throttlingSection = Instance.new("Frame")
    throttlingSection.Size = UDim2.new(0.9, 0, 0, 120)
    throttlingSection.BackgroundColor3 = Color3.fromRGB(50, 40, 50)
    throttlingSection.BorderSizePixel = 0
    throttlingSection.LayoutOrder = 3
    throttlingSection.Parent = contentArea
    
    -- Add rounded corners
    local throttlingSectionCorner = Instance.new("UICorner")
    throttlingSectionCorner.CornerRadius = UDim.new(0, 8)
    throttlingSectionCorner.Parent = throttlingSection
    
    local throttlingTitle = Instance.new("TextLabel")
    throttlingTitle.Size = UDim2.new(1, 0, 0, 30)
    throttlingTitle.Position = UDim2.new(0, 0, 0, 0)
    throttlingTitle.BackgroundTransparency = 1
    throttlingTitle.Text = "Throttling Monitor"
    throttlingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    throttlingTitle.Font = Enum.Font.SourceSansBold
    throttlingTitle.TextSize = 16
    throttlingTitle.Parent = throttlingSection
    
    local budgetLabel = Instance.new("TextLabel")
    budgetLabel.Size = UDim2.new(0.3, 0, 0, 24)
    budgetLabel.Position = UDim2.new(0, 10, 0, 40)
    budgetLabel.BackgroundTransparency = 1
    budgetLabel.Text = "Current Budget:"
    budgetLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    budgetLabel.Font = Enum.Font.SourceSans
    budgetLabel.TextSize = 14
    budgetLabel.TextXAlignment = Enum.TextXAlignment.Left
    budgetLabel.Parent = throttlingSection
    
    local budgetValue = Instance.new("TextLabel")
    budgetValue.Size = UDim2.new(0.65, 0, 0, 24)
    budgetValue.Position = UDim2.new(0.35, 0, 0, 40)
    budgetValue.BackgroundTransparency = 1
    budgetValue.Text = "N/A"
    budgetValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    budgetValue.Font = Enum.Font.SourceSansSemibold
    budgetValue.TextSize = 14
    budgetValue.TextXAlignment = Enum.TextXAlignment.Left
    budgetValue.Name = "Value"
    budgetValue.Parent = throttlingSection
    
    local throttleLabel = Instance.new("TextLabel")
    throttleLabel.Size = UDim2.new(0.3, 0, 0, 24)
    throttleLabel.Position = UDim2.new(0, 10, 0, 70)
    throttleLabel.BackgroundTransparency = 1
    throttleLabel.Text = "Throttle Status:"
    throttleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    throttleLabel.Font = Enum.Font.SourceSans
    throttleLabel.TextSize = 14
    throttleLabel.TextXAlignment = Enum.TextXAlignment.Left
    throttleLabel.Parent = throttlingSection
    
    local throttleValue = Instance.new("TextLabel")
    throttleValue.Size = UDim2.new(0.65, 0, 0, 24)
    throttleValue.Position = UDim2.new(0.35, 0, 0, 70)
    throttleValue.BackgroundTransparency = 1
    throttleValue.Text = "Not Throttled"
    throttleValue.TextColor3 = Color3.fromRGB(46, 204, 113)
    throttleValue.Font = Enum.Font.SourceSansSemibold
    throttleValue.TextSize = 14
    throttleValue.TextXAlignment = Enum.TextXAlignment.Left
    throttleValue.Name = "Value"
    throttleValue.Parent = throttlingSection
    
    -- Connect close button
    closeButton.MouseButton1Click:Connect(function()
        performanceAnalyzerContainer.Visible = false
    end)
    
    -- Connect performance analyzer button
    performanceAnalyzerButton.MouseButton1Click:Connect(function()
        performanceAnalyzerContainer.Visible = true
        
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
        
        if DataExplorer.coordinationContainer and DataExplorer.coordinationContainer.Visible then
            DataExplorer.coordinationContainer.Visible = false
        end
        
        -- Hide main panes
        DataExplorer.contentPane.Visible = false
        DataExplorer.navigationPane.Visible = false
    end)
    
    -- Update UI with performance data if available
    if PerformanceMonitor then
        local updateStats = function()
            if not performanceAnalyzerContainer.Visible then return end
            
            -- Get stats from performance monitor
            local stats = PerformanceMonitor:GetStats()
            if not stats then return end
            
            -- Update overview stats
            totalOperationsFrame.Value.Text = tostring(stats.totalOperations or 0)
            avgResponseTimeFrame.Value.Text = string.format("%.2f ms", stats.avgResponseTime or 0)
            dataStoreUsageFrame.Value.Text = string.format("%d / %d", stats.currentUsage or 0, stats.maxUsage or 0)
            
            -- Update operation breakdown
            getOpFrame.Count.Text = tostring(stats.operations.get or 0)
            setOpFrame.Count.Text = tostring(stats.operations.set or 0)
            updateOpFrame.Count.Text = tostring(stats.operations.update or 0)
            removeOpFrame.Count.Text = tostring(stats.operations.remove or 0)
            
            -- Update throttling info
            budgetValue.Text = string.format("%d / %d", stats.budget.current or 0, stats.budget.max or 0)
            
            -- Update throttle status
            if stats.isThrottled then
                throttleValue.Text = "Throttled"
                throttleValue.TextColor3 = Color3.fromRGB(231, 76, 60)
            else
                throttleValue.Text = "Not Throttled"
                throttleValue.TextColor3 = Color3.fromRGB(46, 204, 113)
            end
        end
        
        -- Set up periodic updates
        local connection
        performanceAnalyzerContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            if performanceAnalyzerContainer.Visible then
                if connection then connection:Disconnect() end
                connection = game:GetService("RunService").Heartbeat:Connect(updateStats)
                updateStats() -- Initial update
            else
                if connection then connection:Disconnect() end
            end
        end)
    end
    
    return performanceAnalyzerContainer
end

return PerformanceAnalyzerUI
