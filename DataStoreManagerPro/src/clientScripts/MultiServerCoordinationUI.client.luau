--luau
-- DataStore Plugin/MultiServerCoordinationUI.luau
-- This is a re-export file that forwards to the server version

-- Use direct reference to the server script instead of script.server
return require(script.Parent:FindFirstChild("MultiServerCoordinationUI.server"))