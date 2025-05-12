-- Cache Viewer UI component for DataExplorer
local CacheViewerUI = {}

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

function CacheViewerUI.updateCacheViewerUI(DataExplorer, CacheManager)
    local cacheViewerPane = DataExplorer.cacheViewerPane
    if not cacheViewerPane then return end

    -- Clear existing cache viewer UI
    for _, child in ipairs(cacheViewerPane:GetChildren()) do
        child:Destroy()
    end

    -- Get cache contents
    local cacheContents = CacheManager.getCacheContents()

    if #cacheContents > 0 then
        for _, cacheEntry in ipairs(cacheContents) do
            local entryFrame = Instance.new("Frame")
            entryFrame.Size = UDim2.new(1, 0, 0, 20) -- Fixed height for each entry
            entryFrame.BackgroundTransparency = 1
            entryFrame.Parent = cacheViewerPane

            local entryLayout = Instance.new("UIListLayout")
            entryLayout.FillDirection = Enum.FillDirection.Horizontal
            entryLayout.SortOrder = Enum.SortOrder.LayoutOrder
            entryLayout.Parent = entryFrame
            
            local dataStoreLabel = createLabel(cacheEntry.dataStoreName, entryFrame)
            dataStoreLabel.Size = UDim2.new(0.2,0,1,0)
            local keyLabel = createLabel(cacheEntry.keyName, entryFrame)
            keyLabel.Size = UDim2.new(0.3,0,1,0)
            local sizeLabel = createLabel(string.format("%.2f KB", cacheEntry.estimatedSize / 1024), entryFrame)
            sizeLabel.Size = UDim2.new(0.15,0,1,0)
            local lastAccessedLabel = createLabel(os.date("%Y-%m-%d %H:%M:%S", cacheEntry.lastAccessed), entryFrame)
            lastAccessedLabel.Size = UDim2.new(0.25,0,1,0)
            local accessCountLabel = createLabel(tostring(cacheEntry.accessCount), entryFrame)
            accessCountLabel.Size = UDim2.new(0.1,0,1,0)
        end
    else
        local noDataLabel = createLabel("No data in cache", cacheViewerPane)
        noDataLabel.Parent = cacheViewerPane
    end
end

return CacheViewerUI
