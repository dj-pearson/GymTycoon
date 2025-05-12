-- InstallModuleResolver.server.luau
-- This script should be run to update all the scripts in the plugin
-- to use the ModuleResolver for better cloud compatibility

-- Add the ModuleResolver to the script tree
local function executeUpdates()
    print("Running module resolver update...")

    -- Make the init script's resolveModule function accessible to other modules
    local initScript = script.Parent:FindFirstChild("init.server.luau") or script.Parent:FindFirstChild("init.server") or script.Parent:FindFirstChild("init")
    if not initScript then
        warn("Could not find init script")
        return
    end

    -- Get the UpdateModuleRequires script
    local updateModule = script.Parent:FindFirstChild("UpdateModuleRequires")
    if not updateModule then
        warn("Could not find UpdateModuleRequires module")
        return
    end

    local updater = require(updateModule)
    if not updater or not updater.processAllScripts then
        warn("UpdateModuleRequires module is invalid")
        return
    end

    -- Update all scripts in the plugin
    local changes = updater.processAllScripts(script.Parent)
    print("Updated " .. changes .. " module requires")

    -- Verify all scripts are using the correct naming convention
    local function verifyScriptNaming(instance)
        if instance:IsA("ModuleScript") or instance:IsA("Script") then
            local name = instance.Name
            local isServer = instance:IsA("Script") and instance.RunContext == Enum.RunContext.Server
            local isClient = instance:IsA("Script") and instance.RunContext == Enum.RunContext.Client
            
            if isServer and not name:match("%.server$") then
                warn("Server script missing .server suffix: " .. instance:GetFullName())
            elseif isClient and not name:match("%.client$") then
                warn("Client script missing .client suffix: " .. instance:GetFullName())
            end
        end
        
        for _, child in ipairs(instance:GetChildren()) do
            verifyScriptNaming(child)
        end
    end
    
    verifyScriptNaming(script.Parent)

    print("Module resolver update complete")
end

-- Execute the updates
executeUpdates()

-- Cleanup (to avoid this running again)
script:Destroy()

return true 