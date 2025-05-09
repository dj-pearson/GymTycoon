local CoreRegistry = {}
local systems = {}

function CoreRegistry:Register(systemName, system)
    if systems[systemName] then
        warn("System", systemName, "is already registered!")
        return false
    end
    
    systems[systemName] = system
    return true
end

function CoreRegistry:GetSystem(systemName)
    if not systems[systemName] then
        warn("System", systemName, "is not registered!")
        return nil
    end
    
    return systems[systemName]
end

function CoreRegistry:Initialize()
    -- Initialize all registered systems in the correct order
    local initOrder = {
        "DataManager",
        "TileSystem",
        "MembershipSystem",
        "EquipmentSystem",
        "ChallengeSystem",
        "ProgressionSystem"
    }
    
    for _, systemName in ipairs(initOrder) do
        local system = systems[systemName]
        if system and system.Initialize then
            system:Initialize()
        end
    end
end

return CoreRegistry 