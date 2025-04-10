-- Dungeon Generation Dictionary
local DungeonModules = {}

-- Local dictionary to store dungeon pieces organized by their attributes
DungeonModules.dict = {
	Hallway = {
		StandardHallways = {
			{
				ModelName = "LeftHallway1",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "LeftHallway2",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "LeftHallway3",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "LeftHallway4",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "RightHallway1",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "RightHallway2",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "RightHallway3",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "RightHallway4",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 70,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "SplitHallway1",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 100,
				SpawnPoints = false,
				SpecialRules = nil,
			},
		},
		SpecialHallways = {
			{
				ModelName = "Low Left Hallway",
				Difficulty = "Easy",
				Family = "Overgrown",
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 50,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "Low Right Hallway",
				Difficulty = "Easy",
				Family = "Overgrown",
				ItemsSpawns = nil,
				MobSpawns = nil,
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 50,
				SpawnPoints = false,
				SpecialRules = nil,
			},
			{
				ModelName = "PrisonHallway",
				Difficulty = "Medium",
				Family = "Prison",
				ItemsSpawns = nil, -- tbd
				MobSpawns = nil, -- tbd
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 30,
				SpawnPoints = false,
				SpecialRules = nil,
			},
		},
	},
	Room = {
		Wardens = {
			{
				ModelName = "Wardens Refuge",
				Difficulty = "Easy",
				Family = nil,
				ItemsSpawns = nil, -- tbd
				MobSpawns = nil, -- tbd
				Locked = false,
				NextNodeTypes = {"Room", "Hallway", "Chamber"},
				Rarity = 40,
				SpawnPoints = false,
				SpecialRules = nil,
			}
		},
	},
	Chamber = {

	},
	StartingRoom = {
		Prisoner = {
			{
				ModelName = "PrisonStart",
				Difficulty = "Easy",
				Family = "Prison",
				ItemsSpawns = nil, -- tbd
				MobSpawns = nil, -- tbd
				Locked = false,
				NextNodeTypes = {"Hallway"},
				Rarity = nil,
				SpawnPoints = true,
				SpecialRules = nil,
			}
		}, 
	}
}

return DungeonModules