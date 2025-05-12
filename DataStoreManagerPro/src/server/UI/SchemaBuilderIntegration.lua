-- Schema Builder Integration for DataExplorer
local SchemaBuilderIntegration = {}

function SchemaBuilderIntegration.initSchemaBuilder(DataExplorer, SchemaBuilderUI)
    -- Add Schema Builder button
    local schemaBuilderButton = Instance.new("TextButton")
    schemaBuilderButton.Size = UDim2.new(0, 130, 0, 28)
    schemaBuilderButton.Position = UDim2.new(1, -280, 0, 10) -- Position to the left of Bulk Operations button
    schemaBuilderButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80) -- Green color
    schemaBuilderButton.BorderSizePixel = 0
    schemaBuilderButton.Text = "Schema Builder"
    schemaBuilderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    schemaBuilderButton.Font = Enum.Font.SourceSansSemibold
    schemaBuilderButton.TextSize = 14
    schemaBuilderButton.ZIndex = 5
    
    -- Store reference in DataExplorer
    DataExplorer.schemaBuilderButton = schemaBuilderButton
    
    -- Add rounded corners
    local schemaButtonCorner = Instance.new("UICorner")
    schemaButtonCorner.CornerRadius = UDim.new(0, 4)
    schemaButtonCorner.Parent = schemaBuilderButton
    
    schemaBuilderButton.Parent = DataExplorer.mainFrame
    
    -- Create the schema builder container (initially invisible)
    local schemaBuilderContainer = SchemaBuilderUI.createUI(DataExplorer.mainFrame)
    DataExplorer.schemaBuilderContainer = schemaBuilderContainer.container
    DataExplorer.schemaBuilderContainer.Visible = false
    
    -- Toggle visibility when schema builder button is clicked
    schemaBuilderButton.MouseButton1Click:Connect(function()
        local contentPane = DataExplorer.contentPane
        local navPane = DataExplorer.navigationPane
        
        if DataExplorer.schemaBuilderContainer.Visible then
            -- Hide schema builder and show normal UI
            DataExplorer.schemaBuilderContainer.Visible = false
            contentPane.Visible = true
            navPane.Visible = true
            schemaBuilderButton.Text = "Schema Builder"
            schemaBuilderButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            
            -- Also ensure bulk operations is hidden
            DataExplorer.bulkOperationsContainer.Visible = false
            DataExplorer.bulkOperationsButton.Text = "Bulk Operations"
            DataExplorer.bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
        else
            -- Show schema builder and hide normal UI
            DataExplorer.schemaBuilderContainer.Visible = true
            contentPane.Visible = false
            navPane.Visible = false
            schemaBuilderButton.Text = "Back to Explorer"
            schemaBuilderButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            
            -- Also ensure bulk operations is hidden
            DataExplorer.bulkOperationsContainer.Visible = false
            DataExplorer.bulkOperationsButton.Text = "Bulk Operations"
            DataExplorer.bulkOperationsButton.BackgroundColor3 = Color3.fromRGB(66, 133, 244)
        end
    end)
end

return SchemaBuilderIntegration
