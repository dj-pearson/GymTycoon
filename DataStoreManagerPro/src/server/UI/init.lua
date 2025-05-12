-- UI Module Collection for DataExplorer
-- This file makes it easier to require all UI modules

local UI = {}

-- Function to require each UI module in the same directory
local function requireModule(name)
    local moduleScript = script:FindFirstChild(name)
    if moduleScript then
        local success, result = pcall(function()
            return require(moduleScript)
        end)
        if success and result then
            return result
        end
    end
    warn("Failed to load UI module: " .. name)
    return {}
end

-- Expose all UI modules
UI.MainUI = requireModule("MainUI")
UI.PerformanceUI = requireModule("PerformanceUI")
UI.CacheViewerUI = requireModule("CacheViewerUI")
UI.LockStatusUI = requireModule("LockStatusUI")
UI.KeyContentUI = requireModule("KeyContentUI")
UI.SchemaBuilderIntegration = requireModule("SchemaBuilderIntegration")

-- New modularized UI components
UI.DataMigrationUI = requireModule("DataMigrationUI")
UI.MultiServerCoordinationUI = requireModule("MultiServerCoordinationUI")
UI.PerformanceAnalyzerUI = requireModule("PerformanceAnalyzerUI")
UI.CachingSystemUI = requireModule("CachingSystemUI")
UI.KeyContentViewer = requireModule("KeyContentViewer")

return UI
