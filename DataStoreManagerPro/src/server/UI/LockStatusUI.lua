-- Lock Status UI component for DataExplorer
local LockStatusUI = {}

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

function LockStatusUI.updateLockStatusUI(DataExplorer, SessionManager)
    local lockStatusContent = DataExplorer.lockStatusContent
    if not lockStatusContent then return end

    -- Clear existing lock status UI
    for _, child in ipairs(lockStatusContent:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Get active locks
    local activeLocks = SessionManager.getActiveLocks()

    if #activeLocks > 0 then
        for i, lockInfo in ipairs(activeLocks) do
            local lockFrame = Instance.new("Frame")
            lockFrame.Size = UDim2.new(1, -10, 0, 24)
            lockFrame.Position = UDim2.new(0, 5, 0, 0)
            lockFrame.BackgroundColor3 = lockInfo.isExpired and Color3.fromRGB(70, 30, 30) or Color3.fromRGB(35, 35, 40)
            lockFrame.BorderSizePixel = 0
            lockFrame.Name = "LockFrame_" .. i
            lockFrame.LayoutOrder = i
            lockFrame.Parent = lockStatusContent
            
            -- Add rounded corners
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 4)
            frameCorner.Parent = lockFrame
            
            -- Create status indicator
            local statusIndicator = Instance.new("Frame")
            statusIndicator.Size = UDim2.new(0, 4, 1, 0)
            statusIndicator.Position = UDim2.new(0, 0, 0, 0)
            statusIndicator.BackgroundColor3 = lockInfo.isExpired and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 180, 80)
            statusIndicator.BorderSizePixel = 0
            statusIndicator.Parent = lockFrame
            
            -- Add rounded corners to indicator
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 4)
            indicatorCorner.Parent = statusIndicator
            
            -- Create lock label
            local lockLabel = Instance.new("TextLabel")
            lockLabel.Size = UDim2.new(1, -70, 1, 0)
            lockLabel.Position = UDim2.new(0, 10, 0, 0)
            lockLabel.BackgroundTransparency = 1
            lockLabel.Text = lockInfo.dataStoreName .. ":" .. lockInfo.keyName
            lockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            lockLabel.Font = Enum.Font.Code
            lockLabel.TextSize = 14
            lockLabel.TextXAlignment = Enum.TextXAlignment.Left
            lockLabel.TextTruncate = Enum.TextTruncate.AtEnd
            lockLabel.Parent = lockFrame
            
            -- Create force unlock button
            local forceUnlockButton = Instance.new("TextButton")
            forceUnlockButton.Size = UDim2.new(0, 60, 0, 20)
            forceUnlockButton.Position = UDim2.new(1, -65, 0.5, -10)
            forceUnlockButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            forceUnlockButton.BorderSizePixel = 0
            forceUnlockButton.Text = "Unlock"
            forceUnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            forceUnlockButton.Font = Enum.Font.SourceSans
            forceUnlockButton.TextSize = 14
            forceUnlockButton.Parent = lockFrame
            
            -- Add rounded corners to button
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = forceUnlockButton

            -- Force unlock function
            forceUnlockButton.MouseButton1Click:Connect(function()
                SessionManager.forceReleaseLock(lockInfo.dataStoreName, lockInfo.keyName)
                DataExplorer.updateLockStatusUI() -- Refresh the lock status UI
            end)
        end
    else
        local noLocksLabel = Instance.new("TextLabel")
        noLocksLabel.Size = UDim2.new(1, -10, 0, 24)
        noLocksLabel.Position = UDim2.new(0, 5, 0, 0)
        noLocksLabel.BackgroundTransparency = 1
        noLocksLabel.Text = "No active locks"
        noLocksLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        noLocksLabel.Font = Enum.Font.SourceSans
        noLocksLabel.TextSize = 14
        noLocksLabel.TextXAlignment = Enum.TextXAlignment.Center
        noLocksLabel.Parent = lockStatusContent
    end
end

return LockStatusUI
