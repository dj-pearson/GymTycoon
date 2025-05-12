-- DataStore Plugin/init.luau

-- Plugin version information
local PluginVersion = "1.0.0"

-- Check if we're running in plugin context
local runningInPluginContext = typeof(plugin) == "Plugin"

-- Create a module resolver to handle both local and cloud environments
local moduleCache = {}

local function resolveModule(moduleName)
    if moduleCache[moduleName] then
        return moduleCache[moduleName]
    end

    -- Try to find the module with appropriate extension
    local moduleScript = script.Parent:FindFirstChild(moduleName)
    
    -- If not found, try with .server suffix for server scripts
    if not moduleScript then
        moduleScript = script.Parent:FindFirstChild(moduleName .. ".server")
    end
    
    -- If still not found, try with .client suffix for client scripts
    if not moduleScript then
        moduleScript = script.Parent:FindFirstChild(moduleName .. ".client")
    end
    
    if moduleScript then
        local success, result = pcall(function()
            return require(moduleScript)
        end)
        
        if success and result then
            moduleCache[moduleName] = result
            return result
        else
            warn("Failed to require module: " .. moduleName .. " - " .. tostring(result))
            return nil
        end
    else
        warn("Module not found: " .. moduleName)
        return nil
    end
end

-- Setup plugin UI if we're in plugin context
local toolbar, button
if runningInPluginContext then
    toolbar = plugin:CreateToolbar("DataStore Manager Pro")
    button = toolbar:CreateButton("Open DataStore Manager", "Open the DataStore Manager Pro Interface", "rbxassetid://7634658388")
end

-- Use our resolver to require modules
local DataStoreManager = resolveModule("DataStoreManager")
local DataExplorer = resolveModule("DataExplorer")
local PerformanceMonitor = resolveModule("PerformanceMonitor")
local SchemaManager = resolveModule("SchemaManager")
local SessionManager = resolveModule("SessionManager")
local CacheManager = resolveModule("CacheManager")
local SchemaValidator = resolveModule("SchemaValidator")
local SecurityManager = resolveModule("SecurityManager")

-- Initialize core systems
if DataStoreManager then DataStoreManager.initialize() end
if DataExplorer then DataExplorer.initialize() end
if PerformanceMonitor then PerformanceMonitor.initialize() end
if SchemaManager then SchemaManager.initialize() end
if SessionManager then SessionManager.initialize() end
if CacheManager then CacheManager.initialize() end
if SchemaValidator then SchemaValidator.initialize() end
if SecurityManager then SecurityManager.initialize() end

return {
    resolveModule = resolveModule,
    version = PluginVersion
} 