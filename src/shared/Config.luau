--!strict
-- Config : tous les réglages chiffrés du jeu, partagés par le serveur et les joueurs.
-- Toutes les valeurs viennent de BRIEF.md (valeurs de départ, à ajuster sans toucher au code).

local Config = {}

-- ============================================================
-- Sauvegarde
-- ============================================================

Config.DataVersion = 1

Config.SaveData = {
	DataStoreName = "DragonsRoblox_PlayerData_v1",
	AutoSaveIntervalSeconds = 60,
	SaveRetryCount = 3,
	SaveRetryDelaySeconds = 2,
}

Config.PerchCount = 6
Config.IncubatorCount = 2

Config.Economy = {
	StartingMoney = 0,
}

-- ============================================================
-- Raretés (BRIEF.md section 3 et 7.6)
-- ============================================================

export type RarityName = "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary" | "Mythic" | "Secret"

-- Du plus commun au plus rare : sert aussi à comparer deux raretés entre elles.
local rarityOrder: { RarityName } = {
	"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret",
}
Config.RarityOrder = rarityOrder

local rarityIndex: { [string]: number } = {}
for index, name in rarityOrder do
	rarityIndex[name] = index
end
Config.RarityIndex = rarityIndex

-- Vitesse (studs/s) et endurance max de la monture, revenu de base par seconde du dragon,
-- et couleur utilisée pour les formes provisoires / faisceaux lumineux des œufs.
Config.Rarities = {
	Common =    { MountSpeed = 40,  MaxStamina = 60,  BaseIncome = 1,   Color = Color3.fromRGB(200, 200, 200) },
	Uncommon =  { MountSpeed = 48,  MaxStamina = 75,  BaseIncome = 3,   Color = Color3.fromRGB(90, 200, 90) },
	Rare =      { MountSpeed = 56,  MaxStamina = 95,  BaseIncome = 8,   Color = Color3.fromRGB(70, 140, 230) },
	Epic =      { MountSpeed = 66,  MaxStamina = 120, BaseIncome = 20,  Color = Color3.fromRGB(165, 80, 225) },
	Legendary = { MountSpeed = 78,  MaxStamina = 150, BaseIncome = 50,  Color = Color3.fromRGB(240, 170, 40) },
	Mythic =    { MountSpeed = 90,  MaxStamina = 185, BaseIncome = 120, Color = Color3.fromRGB(225, 50, 60) },
	Secret =    { MountSpeed = 100, MaxStamina = 230, BaseIncome = 300, Color = Color3.fromRGB(15, 15, 15) },
}

-- Œufs personnels : raretés possibles Common à Rare.
Config.PersonalEggs = {
	CountPerPlayer = 3,
	MinRespawnDistance = 120,
	PossibleRarities = { "Common", "Uncommon", "Rare" },
	Weights = { Common = 60, Uncommon = 28, Rare = 12 },
}

-- Œuf rare partagé : raretés possibles Epic à Secret.
Config.SharedEggs = {
	SpawnIntervalSeconds = 180,
	PossibleRarities = { "Epic", "Legendary", "Mythic", "Secret" },
	Weights = { Epic = 70, Legendary = 22, Mythic = 6.5, Secret = 1.5 },
}

-- À partir de quelle rareté un œuf transporté a un minuteur (BRIEF.md 7.3).
Config.EggCarrying = {
	RareTimerSeconds = 75,
	RareTimerFromRarity = "Epic",
	DropOnObstacleHit = false,
}

Config.Incubation = {
	DurationSeconds = {
		Common = 10, Uncommon = 20, Rare = 40, Epic = 60, Legendary = 90, Mythic = 120, Secret = 180,
	},
}

-- ============================================================
-- Mutation et taille (BRIEF.md section 7.5)
-- ============================================================

export type MutationName = "None" | "Gold" | "Diamond" | "Rainbow"

Config.Mutations = {
	Order = { "None", "Gold", "Diamond", "Rainbow" },
	Weights = { None = 94, Gold = 4, Diamond = 1.5, Rainbow = 0.5 },
	IncomeMultiplier = { None = 1, Gold = 2, Diamond = 3, Rainbow = 5 },
}

export type SizeName = "Small" | "Normal" | "Large" | "Giant"

Config.Sizes = {
	Order = { "Small", "Normal", "Large", "Giant" },
	Weights = { Small = 30, Normal = 55, Large = 12, Giant = 3 },
	Multiplier = { Small = 0.8, Normal = 1, Large = 1.5, Giant = 2.5 },
}

Config.Announcements = {
	AnnounceHatchFromRarity = "Legendary",
	AnnounceRainbowMutation = true,
}

-- ============================================================
-- Vol et monture (BRIEF.md section 7.2)
-- ============================================================

Config.Flight = {
	StaminaDrainPerSecond = 5,
	StaminaDrainPerSecondAscending = 8,
	StaminaRegenPerSecondGrounded = 20,
	GlideDescentSpeed = 14,
	-- Hauteur maximale de vol pour toute la zone (le sommet de la montagne est vers 200).
	FlightCeiling = 260,
	-- Tolérance appliquée aux vérifications serveur de vitesse (latence réseau).
	ServerSpeedTolerance = 1.5,
	ServerCheckIntervalSeconds = 1,
}

-- ============================================================
-- Zone 1 (BRIEF.md section 7.1)
-- ============================================================

Config.Zone1 = {
	SizeStuds = 512,
	MountainPeakHeight = 200,
	Element = "Nature",
}

-- ============================================================
-- Structures de données par défaut
-- ============================================================

-- Construit la structure de données par défaut d'un nouveau joueur.
function Config.newDefaultPlayerData()
	-- false = emplacement vide. On évite nil car un trou dans un tableau casse sa
	-- longueur une fois passé par le DataStore (encodage JSON).
	local perches = {}
	for i = 1, Config.PerchCount do
		perches[i] = false
	end

	local incubators = {}
	for i = 1, Config.IncubatorCount do
		incubators[i] = false
	end

	return {
		version = Config.DataVersion,
		money = Config.Economy.StartingMoney,
		dragons = {},
		perches = perches,
		mountId = false,
		incubators = incubators,
		hasReceivedStarterDragon = false,
	}
end

return Config
