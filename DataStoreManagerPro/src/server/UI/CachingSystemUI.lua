-- CachingSystem UI component for DataExplorer
local CachingSystemUI = {}

function CachingSystemUI.initCachingSystemUI(DataExplorer, CacheManager)
    local mainFrame = DataExplorer.mainFrame
    if not mainFrame then return end
    
    -- Create a button to open caching system
    local cachingSystemButton = Instance.new("TextButton")
    cachingSystemButton.Size = UDim2.new(0, 150, 0, 30)
    cachingSystemButton.Position = UDim2.new(1, -320, 0, 130) -- Below other buttons
    cachingSystemButton.BackgroundColor3 = Color3.fromRGB(100, 150, 180)
    cachingSystemButton.BorderSizePixel = 0
    cachingSystemButton.Text = "Caching System"
    cachingSystemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cachingSystemButton.Font = Enum.Font.SourceSansBold
    cachingSystemButton.TextSize = 14
    cachingSystemButton.ZIndex = 5
    cachingSystemButton.Parent = mainFrame
    
    -- Add rounded corners to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = cachingSystemButton
    
    -- Create the caching system container (initially invisible)
    local cachingSystemContainer = Instance.new("Frame")
    cachingSystemContainer.Size = UDim2.new(1, 0, 1, 0)
    cachingSystemContainer.Position = UDim2.new(0, 0, 0, 0)
    cachingSystemContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
    cachingSystemContainer.BorderSizePixel = 0
    cachingSystemContainer.Visible = false
    cachingSystemContainer.ZIndex = 10
    cachingSystemContainer.Parent = mainFrame
    
    -- Save reference to the container
    DataExplorer.cachingSystemContainer = cachingSystemContainer
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = cachingSystemContainer
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Caching System"
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
    contentArea.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = cachingSystemContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    -- Cache Overview Section
    local overviewSection = Instance.new("Frame")
    overviewSection.Size = UDim2.new(0.9, 0, 0, 160)
    overviewSection.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
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
    overviewTitle.Text = "Cache Overview"
    overviewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    overviewTitle.Font = Enum.Font.SourceSansBold
    overviewTitle.TextSize = 16
    overviewTitle.Parent = overviewSection
    
    -- Create stat items
    local createStatItem = function(name, value, yPos)
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.95, 0, 0, 30)
        statFrame.Position = UDim2.new(0.025, 0, 0, yPos)
        statFrame.BackgroundColor3 = Color3.fromRGB(50, 55, 60)
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
    local totalCachedFrame = createStatItem("Total Cached Items:", "0", 35)
    local hitRateFrame = createStatItem("Cache Hit Rate:", "0%", 70)
    local memoryUsageFrame = createStatItem("Memory Usage:", "0 KB", 105)
    
    -- Cache Config Section
    local configSection = Instance.new("Frame")
    configSection.Size = UDim2.new(0.9, 0, 0, 250)
    configSection.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    configSection.BorderSizePixel = 0
    configSection.LayoutOrder = 2
    configSection.Parent = contentArea
    
    -- Add rounded corners
    local configSectionCorner = Instance.new("UICorner")
    configSectionCorner.CornerRadius = UDim.new(0, 8)
    configSectionCorner.Parent = configSection
    
    local configTitle = Instance.new("TextLabel")
    configTitle.Size = UDim2.new(1, 0, 0, 30)
    configTitle.Position = UDim2.new(0, 0, 0, 0)
    configTitle.BackgroundTransparency = 1
    configTitle.Text = "Cache Configuration"
    configTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    configTitle.Font = Enum.Font.SourceSansBold
    configTitle.TextSize = 16
    configTitle.Parent = configSection
    
    -- Create a setting slider
    local createSliderSetting = function(name, value, min, max, yPos)
        local settingFrame = Instance.new("Frame")
        settingFrame.Size = UDim2.new(0.95, 0, 0, 50)
        settingFrame.Position = UDim2.new(0.025, 0, 0, yPos)
        settingFrame.BackgroundColor3 = Color3.fromRGB(50, 55, 60)
        settingFrame.BorderSizePixel = 0
        settingFrame.Parent = configSection
        
        -- Add rounded corners
        local settingFrameCorner = Instance.new("UICorner")
        settingFrameCorner.CornerRadius = UDim.new(0, 4)
        settingFrameCorner.Parent = settingFrame
        
        local settingName = Instance.new("TextLabel")
        settingName.Size = UDim2.new(0.95, 0, 0, 20)
        settingName.Position = UDim2.new(0.025, 0, 0, 5)
        settingName.BackgroundTransparency = 1
        settingName.Text = name
        settingName.TextColor3 = Color3.fromRGB(220, 220, 220)
        settingName.Font = Enum.Font.SourceSans
        settingName.TextSize = 14
        settingName.TextXAlignment = Enum.TextXAlignment.Left
        settingName.Parent = settingFrame
        
        local sliderBackground = Instance.new("Frame")
        sliderBackground.Size = UDim2.new(0.7, 0, 0, 6)
        sliderBackground.Position = UDim2.new(0.025, 0, 0.5, 8)
        sliderBackground.BackgroundColor3 = Color3.fromRGB(60, 65, 70)
        sliderBackground.BorderSizePixel = 0
        sliderBackground.Parent = settingFrame
        
        -- Add rounded corners to slider background
        local sliderBackgroundCorner = Instance.new("UICorner")
        sliderBackgroundCorner.CornerRadius = UDim.new(0, 3)
        sliderBackgroundCorner.Parent = sliderBackground
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBackground
        
        -- Add rounded corners to slider fill
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 3)
        sliderFillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 16, 0, 16)
        sliderButton.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 8)
        sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        sliderButton.BorderSizePixel = 0
        sliderButton.Text = ""
        sliderButton.Parent = sliderBackground
        
        -- Add rounded corners to slider button
        local sliderButtonCorner = Instance.new("UICorner")
        sliderButtonCorner.CornerRadius = UDim.new(0, 8)
        sliderButtonCorner.Parent = sliderButton
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.2, 0, 0, 20)
        valueLabel.Position = UDim2.new(0.775, 0, 0.5, 0)
        valueLabel.AnchorPoint = Vector2.new(0, 0.5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(value)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.Font = Enum.Font.SourceSansBold
        valueLabel.TextSize = 14
        valueLabel.Name = "Value"
        valueLabel.Parent = settingFrame
        
        -- Make slider interactive
        local dragging = false
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                
                -- Calculate value from mouse position
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativeX = mousePos.X - sliderBackground.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBackground.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + percentage * (max - min))
                
                -- Update UI
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderButton.Position = UDim2.new(percentage, 0, 0.5, 8)
                valueLabel.Text = tostring(newValue)
                
                -- Update cache settings if CacheManager is available
                if CacheManager then
                    if name == "Max Cache Size:" then
                        CacheManager:SetMaxCacheSize(newValue)
                    elseif name == "TTL (seconds):" then
                        CacheManager:SetTTL(newValue)
                    elseif name == "Priority Threshold:" then
                        CacheManager:SetPriorityThreshold(newValue)
                    end
                end
            end
        end)
        
        sliderBackground.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                -- Calculate value from mouse position
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local relativeX = mousePos.X - sliderBackground.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBackground.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(min + percentage * (max - min))
                
                -- Update UI
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderButton.Position = UDim2.new(percentage, 0, 0.5, 8)
                valueLabel.Text = tostring(newValue)
                
                -- Update cache settings if CacheManager is available
                if CacheManager then
                    if name == "Max Cache Size:" then
                        CacheManager:SetMaxCacheSize(newValue)
                    elseif name == "TTL (seconds):" then
                        CacheManager:SetTTL(newValue)
                    elseif name == "Priority Threshold:" then
                        CacheManager:SetPriorityThreshold(newValue)
                    end
                end
            end
        end)
        
        return settingFrame
    end
    
    -- Settings
    local cacheSizeSlider = createSliderSetting("Max Cache Size:", 100, 10, 1000, 40)
    local ttlSlider = createSliderSetting("TTL (seconds):", 600, 60, 3600, 100)
    local prioritySlider = createSliderSetting("Priority Threshold:", 5, 1, 10, 160)
    
    -- Action buttons
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Size = UDim2.new(0.95, 0, 0, 40)
    actionsFrame.Position = UDim2.new(0.025, 0, 0, 210)
    actionsFrame.BackgroundTransparency = 1
    actionsFrame.Parent = configSection
    
    local clearCacheButton = Instance.new("TextButton")
    clearCacheButton.Size = UDim2.new(0.48, 0, 0, 35)
    clearCacheButton.Position = UDim2.new(0, 0, 0, 0)
    clearCacheButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    clearCacheButton.BorderSizePixel = 0
    clearCacheButton.Text = "Clear Cache"
    clearCacheButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearCacheButton.Font = Enum.Font.SourceSansBold
    clearCacheButton.TextSize = 14
    clearCacheButton.Parent = actionsFrame
    
    -- Add rounded corners to button
    local clearCacheButtonCorner = Instance.new("UICorner")
    clearCacheButtonCorner.CornerRadius = UDim.new(0, 4)
    clearCacheButtonCorner.Parent = clearCacheButton
    
    local optimizeButton = Instance.new("TextButton")
    optimizeButton.Size = UDim2.new(0.48, 0, 0, 35)
    optimizeButton.Position = UDim2.new(0.52, 0, 0, 0)
    optimizeButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    optimizeButton.BorderSizePixel = 0
    optimizeButton.Text = "Optimize Cache"
    optimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    optimizeButton.Font = Enum.Font.SourceSansBold
    optimizeButton.TextSize = 14
    optimizeButton.Parent = actionsFrame
    
    -- Add rounded corners to button
    local optimizeButtonCorner = Instance.new("UICorner")
    optimizeButtonCorner.CornerRadius = UDim.new(0, 4)
    optimizeButtonCorner.Parent = optimizeButton
    
    -- Connect buttons to actions
    if CacheManager then
        clearCacheButton.MouseButton1Click:Connect(function()
            CacheManager:ClearCache()
            -- Update stats
            totalCachedFrame.Value.Text = "0"
            memoryUsageFrame.Value.Text = "0 KB"
        end)
        
        optimizeButton.MouseButton1Click:Connect(function()
            CacheManager:OptimizeCache()
        end)
    end
    
    -- Connect close button
    closeButton.MouseButton1Click:Connect(function()
        cachingSystemContainer.Visible = false
    end)
    
    -- Connect caching system button
    cachingSystemButton.MouseButton1Click:Connect(function()
        cachingSystemContainer.Visible = true
        
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
        
        if DataExplorer.performanceAnalyzerContainer and DataExplorer.performanceAnalyzerContainer.Visible then
            DataExplorer.performanceAnalyzerContainer.Visible = false
        end
        
        -- Hide main panes
        DataExplorer.contentPane.Visible = false
        DataExplorer.navigationPane.Visible = false
    end)
    
    -- Update cache stats if CacheManager is available
    if CacheManager then
        local updateStats = function()
            if not cachingSystemContainer.Visible then return end
            
            -- Get cache stats
            local stats = CacheManager:GetStats()
            if not stats then return end
            
            -- Update overview stats
            totalCachedFrame.Value.Text = tostring(stats.itemCount or 0)
            hitRateFrame.Value.Text = string.format("%.1f%%", (stats.hitRate or 0) * 100)
            
            -- Format memory usage
            local memoryKB = (stats.memoryUsage or 0) / 1024
            if memoryKB < 1024 then
                memoryUsageFrame.Value.Text = string.format("%.1f KB", memoryKB)
            else
                memoryUsageFrame.Value.Text = string.format("%.2f MB", memoryKB / 1024)
            end
        end
        
        -- Set up periodic updates
        local connection
        cachingSystemContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            if cachingSystemContainer.Visible then
                if connection then connection:Disconnect() end
                connection = game:GetService("RunService").Heartbeat:Connect(updateStats)
                updateStats() -- Initial update
            else
                if connection then connection:Disconnect() end
            end
        end)
    end
    
    return cachingSystemContainer
end

return CachingSystemUI
