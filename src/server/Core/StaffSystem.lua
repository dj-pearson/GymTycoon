local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Constants = require(ReplicatedStorage.shared.Constants)
local DataManager = require(script.Parent.DataManager)

local StaffSystem = {}
StaffSystem.__index = StaffSystem

-- Private variables
local staffData = {}
local activeStaff = {}
local taskQueue = {}

function StaffSystem.new()
    local self = setmetatable({}, StaffSystem)
    return self
end

function StaffSystem:Initialize()
    -- Load staff data from DataManager
    staffData = DataManager:GetData("staff") or {}
    
    -- Start staff update loop
    RunService.Heartbeat:Connect(function(deltaTime)
        self:UpdateStaff(deltaTime)
    end)
end

function StaffSystem:HireStaff(staffType)
    local staffTemplate = Constants.STAFF[staffType]
    if not staffTemplate then
        return nil, "Invalid staff type"
    end
    
    -- Create new staff instance
    local staffId = #staffData + 1
    local staff = {
        id = staffId,
        type = staffType,
        name = staffTemplate.name,
        specialization = staffTemplate.specialization,
        hireDate = os.time(),
        energy = staffTemplate.maxEnergy,
        experience = 0,
        efficiency = staffTemplate.taskEfficiency,
        satisfaction = 1.0,
        currentTask = nil,
        taskProgress = 0
    }
    
    -- Store staff data
    staffData[staffId] = staff
    DataManager:SetData("staff", staffData)
    
    -- Create physical staff
    self:CreatePhysicalStaff(staff)
    
    return staff
end

function StaffSystem:CreatePhysicalStaff(staff)
    -- Create staff model
    local staffModel = Instance.new("Model")
    staffModel.Name = "Staff_" .. staff.id
    
    -- Create staff character
    local character = Instance.new("Part")
    character.Name = "Character"
    character.Size = Vector3.new(1, 4, 1)
    character.Position = Vector3.new(0, 2, 0)
    character.Anchored = true
    character.CanCollide = true
    character.Parent = staffModel
    
    -- Create staff head
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1, 1, 1)
    head.Position = Vector3.new(0, 4.5, 0)
    head.Anchored = true
    head.CanCollide = true
    head.Parent = staffModel
    
    -- Create staff status indicator
    local statusGui = Instance.new("BillboardGui")
    statusGui.Name = "StatusGui"
    statusGui.Size = UDim2.new(0, 100, 0, 20)
    statusGui.StudsOffset = Vector3.new(0, 5, 0)
    statusGui.Parent = head
    
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 1, 0)
    statusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    statusBar.Parent = statusGui
    
    -- Store staff model
    activeStaff[staff.id] = staffModel
    staffModel.Parent = workspace.Staff
end

function StaffSystem:UpdateStaff(deltaTime)
    for staffId, staff in pairs(staffData) do
        -- Update energy
        local staffTemplate = Constants.STAFF[staff.type]
        staff.energy = math.min(
            staffTemplate.maxEnergy,
            staff.energy + staffTemplate.energyRegenRate * deltaTime
        )
        
        -- Update current task
        if staff.currentTask then
            staff.taskProgress = staff.taskProgress + deltaTime
            
            -- Check if task is complete
            if staff.taskProgress >= staff.currentTask.duration then
                self:CompleteTask(staff)
            end
        else
            -- Try to assign new task
            self:AssignTask(staff)
        end
        
        -- Update staff visuals
        self:UpdateStaffVisuals(staff)
    end
end

function StaffSystem:AssignTask(staff)
    if staff.energy < 20 then return end -- Minimum energy required for tasks
    
    -- Find suitable task based on specialization
    local task = nil
    if staff.specialization == "MAINTENANCE" then
        -- Find equipment needing maintenance
        for _, equipment in pairs(workspace.Equipment:GetChildren()) do
            local equipmentData = equipment:GetAttribute("EquipmentData")
            if equipmentData and equipmentData.durability < 0.7 then
                task = {
                    type = "MAINTENANCE",
                    target = equipment,
                    duration = 30, -- 30 seconds
                    energyCost = 20
                }
                break
            end
        end
    elseif staff.specialization == "CLEANING" then
        -- Find equipment needing cleaning
        for _, equipment in pairs(workspace.Equipment:GetChildren()) do
            local equipmentData = equipment:GetAttribute("EquipmentData")
            if equipmentData and equipmentData.cleanliness < 0.7 then
                task = {
                    type = "CLEANING",
                    target = equipment,
                    duration = 20, -- 20 seconds
                    energyCost = 15
                }
                break
            end
        end
    elseif staff.specialization == "TRAINING" then
        -- Find members who could benefit from training
        local membershipSystem = self:GetSystem("MembershipSystem")
        if membershipSystem then
            local members = membershipSystem:GetActiveMembers()
            for _, member in pairs(members) do
                if member.satisfaction < 0.8 and not member.currentActivity then
                    task = {
                        type = "TRAINING",
                        target = member,
                        duration = Constants.STAFF.TRAINER.trainingDuration,
                        energyCost = Constants.STAFF.TRAINER.energyCost
                    }
                    break
                end
            end
        end
    end
    
    if task then
        staff.currentTask = task
        staff.taskProgress = 0
        staff.energy = staff.energy - task.energyCost
        
        -- Move staff to task location
        local staffModel = activeStaff[staff.id]
        if staffModel then
            if task.type == "TRAINING" then
                -- Move to member's location
                local memberModel = task.target.model
                if memberModel then
                    staffModel:SetPrimaryPartCFrame(
                        CFrame.new(memberModel.PrimaryPart.Position + Vector3.new(0, 0, 2))
                    )
                end
            else
                staffModel:SetPrimaryPartCFrame(
                    CFrame.new(task.target.Position + Vector3.new(0, 0, 2))
                )
            end
        end
    end
end

function StaffSystem:CompleteTask(staff)
    if not staff.currentTask then return end
    
    local task = staff.currentTask
    
    -- Apply task effects
    if task.type == "MAINTENANCE" then
        local equipment = task.target
        local equipmentData = equipment:GetAttribute("EquipmentData")
        equipmentData.durability = 1.0
        equipment:SetAttribute("EquipmentData", equipmentData)
    elseif task.type == "CLEANING" then
        local equipment = task.target
        local equipmentData = equipment:GetAttribute("EquipmentData")
        equipmentData.cleanliness = 1.0
        equipment:SetAttribute("EquipmentData", equipmentData)
    elseif task.type == "TRAINING" then
        local member = task.target
        local staffTemplate = Constants.STAFF[staff.type]
        
        -- Boost member satisfaction
        member.satisfaction = math.min(1.0, member.satisfaction + staffTemplate.memberSatisfactionBoost)
        
        -- Update member loyalty
        member.loyalty = math.min(1.0, member.loyalty + 0.1)
        
        -- Update member data
        local membershipSystem = self:GetSystem("MembershipSystem")
        if membershipSystem then
            membershipSystem:UpdateMemberData(member)
        end
    end
    
    -- Update staff experience
    local staffTemplate = Constants.STAFF[staff.type]
    staff.experience = staff.experience + staffTemplate.experienceGain
    staff.efficiency = staffTemplate.taskEfficiency * (1 + staff.experience * 0.1)
    
    -- Clear task
    staff.currentTask = nil
    staff.taskProgress = 0
end

function StaffSystem:UpdateStaffVisuals(staff)
    local staffModel = activeStaff[staff.id]
    if not staffModel then return end
    
    local statusBar = staffModel.Head.StatusGui.StatusBar
    if statusBar then
        -- Update energy bar
        local energyPercent = staff.energy / Constants.STAFF[staff.type].maxEnergy
        statusBar.Size = UDim2.new(energyPercent, 0, 1, 0)
        
        -- Update color based on energy level
        if energyPercent > 0.7 then
            statusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif energyPercent > 0.3 then
            statusBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            statusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

function StaffSystem:FireStaff(staffId)
    local staff = staffData[staffId]
    if not staff then return false, "Staff not found" end
    
    -- Remove physical staff
    local staffModel = activeStaff[staffId]
    if staffModel then
        staffModel:Destroy()
        activeStaff[staffId] = nil
    end
    
    -- Remove staff data
    staffData[staffId] = nil
    DataManager:SetData("staff", staffData)
    
    return true
end

function StaffSystem:GetStaffData(staffId)
    return staffData[staffId]
end

function StaffSystem:GetAllStaff()
    return staffData
end

function StaffSystem:GetActiveStaff()
    return activeStaff
end

function StaffSystem:GetSystem(systemName)
    local coreRegistry = require(script.Parent.CoreRegistry)
    return coreRegistry:GetSystem(systemName)
end

return StaffSystem 