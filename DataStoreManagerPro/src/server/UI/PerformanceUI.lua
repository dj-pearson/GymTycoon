-- Performance UI component for DataExplorer
local RunService = game:GetService("RunService")

local PerformanceUI = {}

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

function PerformanceUI.updatePerformanceDataUI(DataExplorer, CacheManager, PerformanceMonitor)
    local performancePane = DataExplorer.performancePane
    if not performancePane then return end

    -- Clear existing performance data UI
    for _, child in ipairs(performancePane:GetChildren()) do    
        child:Destroy()
    end

    -- Display cache analytics
    local cacheAnalytics = CacheManager.getCacheAnalytics()
    local cacheFrame = Instance.new("Frame")
    cacheFrame.Size = UDim2.new(1, 0, 0, 40)
    cacheFrame.BackgroundTransparency = 1
    cacheFrame.Parent = performancePane

    local cacheHitsLabel = createLabel("Cache Hits: " .. tostring(cacheAnalytics.hits), cacheFrame)
    local cacheMissesLabel = createLabel("Cache Misses: " .. tostring(cacheAnalytics.misses), cacheFrame)
    cacheMissesLabel.Position = UDim2.new(0, 0, 0, 20)

    -- Display cache hit rate percentage
    local hitRate = 0
    if cacheAnalytics.hits + cacheAnalytics.misses > 0 then
        hitRate = (cacheAnalytics.hits / (cacheAnalytics.hits + cacheAnalytics.misses)) * 100
    end
    local hitRateLabel = createLabel(string.format("Hit Rate: %.2f%%", hitRate), cacheFrame)
    hitRateLabel.Position = UDim2.new(0, 0, 0, 40) -- Position below misses

    -- Add cache memory usage display
    local memoryUsage = CacheManager.estimateMemoryUsage()
    local memoryUsageLabel = createLabel("Cache Memory: " .. string.format("%.2f", memoryUsage / 1024) .. " KB", cacheFrame) -- Display in KB
    memoryUsageLabel.Position = UDim2.new(0, 0, 0, 40) -- Position below misses
    memoryUsageLabel.Parent = cacheFrame

    -- Get performance data
    local operationSummary = PerformanceMonitor.getOperationSummary()

    if operationSummary then
        for operationName, summary in pairs(operationSummary) do
            local operationFrame = Instance.new("Frame")
            operationFrame.Size = UDim2.new(1, 0, 0, 40)
            operationFrame.Position = UDim2.new(0,0,0,cacheFrame.Size.Y.Offset)
            operationFrame.BackgroundTransparency = 1
            operationFrame.Parent = performancePane

            -- Create a frame for the table header
            local headerFrame = Instance.new("Frame")
            headerFrame.Size = UDim2.new(1, 0, 0, 20)
            headerFrame.BackgroundTransparency = 1
            headerFrame.Parent = operationFrame

            -- Create a frame for the table rows
            local rowFrame = Instance.new("Frame")
            rowFrame.Size = UDim2.new(1, 0, 0, 20)
            rowFrame.Position = UDim2.new(0,0,0,20)
            rowFrame.BackgroundTransparency = 1
            rowFrame.Parent = operationFrame

            -- Table header labels
            local headerLabels = {
                {name = "Operation", widthScale = 0.3},
                {name = "Count", widthScale = 0.2},
                {name = "Total Duration", widthScale = 0.25},
                {name = "Average Duration", widthScale = 0.25}
            }

            local headerOffset = 0
            for _, header in ipairs(headerLabels) do
                local headerLabel = createLabel(header.name, headerFrame)
                headerLabel.Size = UDim2.new(header.widthScale, 0, 1, 0)
                headerLabel.Position = UDim2.new(0, headerOffset, 0, 0)
                headerOffset += header.widthScale * 100
            end

            -- Row labels (data)
            local rowLabels = {
                {value = operationName, widthScale = 0.3, color = (summary.averageDuration > 0.5) and Color3.fromRGB(255, 100, 100) or nil},
                {value = tostring(summary.count), widthScale = 0.2},
                {value = string.format("%.2fms", summary.totalDuration * 1000), widthScale = 0.25},
                {value = string.format("%.2fms", summary.averageDuration * 1000), widthScale = 0.25}
            }

            local rowOffset = 0
            for _, row in ipairs(rowLabels) do
                local rowLabel = createLabel(row.value, rowFrame)
                rowLabel.Size = UDim2.new(row.widthScale, 0, 1, 0)
                rowLabel.Position = UDim2.new(0, rowOffset, 0, 0)
                rowLabel.TextColor3 = row.color or Color3.new(1,1,1)
                rowOffset += row.widthScale * 100
            end   
        end
    else
        local noDataLabel = createLabel("No performance data yet.", performancePane)
        noDataLabel.Parent = performancePane
    end
end

return PerformanceUI
