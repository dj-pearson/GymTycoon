local Constants = {}

-- Game Settings
Constants.GRID_SIZE = 4
Constants.INTERACTION_RANGE = 10
Constants.AUTO_SAVE_INTERVAL = 300 -- 5 minutes

-- Floor Settings
Constants.FLOOR_BOUNDS = {
    [1] = {
        min = Vector3.new(-50, 0, -50),
        max = Vector3.new(50, 0, 50)
    },
    [2] = {
        min = Vector3.new(-50, 10, -50),
        max = Vector3.new(50, 10, 50)
    },
    [3] = {
        min = Vector3.new(-50, 20, -50),
        max = Vector3.new(50, 20, 50)
    }
}

-- Equipment Settings
Constants.EQUIPMENT = {
    TREADMILL = {
        name = "Treadmill",
        category = "Cardio",
        baseCost = 1000,
        maintenanceCost = 100,
        cleaningCost = 50,
        durabilityDecayRate = 0.1, -- per minute
        cleanlinessDecayRate = 0.2, -- per minute
        usageTime = 300, -- 5 minutes
        satisfactionRating = 0.8,
        xpReward = 10
    },
    WEIGHT_BENCH = {
        name = "Weight Bench",
        category = "Strength",
        baseCost = 800,
        maintenanceCost = 80,
        cleaningCost = 40,
        durabilityDecayRate = 0.15,
        cleanlinessDecayRate = 0.25,
        usageTime = 240, -- 4 minutes
        satisfactionRating = 0.7,
        xpReward = 8
    },
    ELLIPTICAL = {
        name = "Elliptical",
        category = "Cardio",
        baseCost = 1200,
        maintenanceCost = 120,
        cleaningCost = 60,
        durabilityDecayRate = 0.08,
        cleanlinessDecayRate = 0.15,
        usageTime = 360, -- 6 minutes
        satisfactionRating = 0.9,
        xpReward = 12
    }
}

-- Staff Settings
Constants.STAFF = {
    MAINTENANCE = {
        name = "Maintenance Staff",
        specialization = "MAINTENANCE",
        hireCost = 2000,
        salary = 100, -- per day
        maxEnergy = 100,
        energyRegenRate = 5, -- per minute
        taskEfficiency = 1.0,
        experienceGain = 0.1 -- per task
    },
    CLEANING = {
        name = "Cleaning Staff",
        specialization = "CLEANING",
        hireCost = 1500,
        salary = 80, -- per day
        maxEnergy = 100,
        energyRegenRate = 5, -- per minute
        taskEfficiency = 1.0,
        experienceGain = 0.1 -- per task
    },
    TRAINER = {
        name = "Personal Trainer",
        specialization = "TRAINING",
        hireCost = 3000,
        salary = 150, -- per day
        maxEnergy = 100,
        energyRegenRate = 4, -- per minute
        taskEfficiency = 1.0,
        experienceGain = 0.15, -- per task
        memberSatisfactionBoost = 0.2, -- 20% boost to member satisfaction
        trainingDuration = 1800, -- 30 minutes
        energyCost = 30 -- per training session
    }
}

-- Membership Types
Constants.MEMBERSHIP = {
    BASIC = {
        name = "Basic",
        monthlyFee = 20,
        satisfactionThreshold = 0.5,
        equipmentAccess = {"TREADMILL", "WEIGHT_BENCH"}
    },
    PREMIUM = {
        name = "Premium",
        monthlyFee = 40,
        satisfactionThreshold = 0.7,
        equipmentAccess = {"TREADMILL", "WEIGHT_BENCH", "ELLIPTICAL"}
    },
    VIP = {
        name = "VIP",
        monthlyFee = 60,
        satisfactionThreshold = 0.9,
        equipmentAccess = {"TREADMILL", "WEIGHT_BENCH", "ELLIPTICAL"}
    }
}

-- Challenge Types
Constants.CHALLENGE = {
    DAILY = {
        name = "Daily",
        rewardMultiplier = 1.0,
        maxActive = 3
    },
    WEEKLY = {
        name = "Weekly",
        rewardMultiplier = 2.0,
        maxActive = 1
    },
    SPECIAL = {
        name = "Special",
        rewardMultiplier = 3.0,
        maxActive = 1
    }
}

-- Progression Settings
Constants.PROGRESSION = {
    FLOOR_UNLOCK = {
        [2] = {
            tilesRequired = 20,
            membersRequired = 10,
            playerLevel = 5,
            cost = 5000,
            rewards = {
                xp = 100,
                money = 1000
            }
        },
        [3] = {
            tilesRequired = 40,
            membersRequired = 25,
            playerLevel = 10,
            cost = 10000,
            rewards = {
                xp = 200,
                money = 2000
            }
        }
    },
    LEVEL_XP = {
        base = 100,
        multiplier = 1.5
    }
}

return Constants 