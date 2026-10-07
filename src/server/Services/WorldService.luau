--!strict
-- WorldService : construit la zone 1 par script (forêt, montagne, lac, limites).
-- Le Terrain Roblox n'est pas synchronisé par Rojo, donc on le (re)génère à chaque
-- démarrage du serveur ; ça prend quelques secondes à chaque Play en Studio.
-- BRIEF.md section 7.1.

local Workspace = game:GetService("Workspace")

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)

local WorldService = {}

local HALF = Config.Zone1.SizeStuds / 2
local GROUND_Y = 0
local PEAK_HEIGHT = Config.Zone1.MountainPeakHeight

local MOUNTAIN_CENTER = Vector3.new(150, GROUND_Y, 150)
local MOUNTAIN_BASE_RADIUS = 100

local LAKE_CENTER = Vector3.new(-150, GROUND_Y, -150)
local LAKE_RADIUS = 70

-- Zone réservée à la base (parcelles des joueurs), construite à l'étape 5.
local BASE_AREA_CENTER = Vector3.new(-150, GROUND_Y, 150)
local BASE_AREA_RADIUS = 90

local SPAWN_POSITION = Vector3.new(0, GROUND_Y + 5, 0)

WorldService.MountainCenter = MOUNTAIN_CENTER
WorldService.MountainPeak = MOUNTAIN_CENTER + Vector3.new(0, PEAK_HEIGHT, 0)
WorldService.LakeCenter = LAKE_CENTER
WorldService.BaseAreaCenter = BASE_AREA_CENTER
WorldService.BaseAreaRadius = BASE_AREA_RADIUS
WorldService.SpawnPosition = SPAWN_POSITION

-- Rayon approximatif de la montagne à une hauteur donnée (cône grossier).
local function mountainRadiusAtHeight(height: number): number
	local t = math.clamp(height / PEAK_HEIGHT, 0, 1)
	return MOUNTAIN_BASE_RADIUS * (1 - t) + 8
end

local function distanceXZ(a: Vector3, b: Vector3): number
	return Vector2.new(a.X - b.X, a.Z - b.Z).Magnitude
end

local function buildGround()
	local terrain = Workspace.Terrain
	terrain:FillBlock(CFrame.new(0, GROUND_Y - 10, 0), Vector3.new(Config.Zone1.SizeStuds, 20, Config.Zone1.SizeStuds), Enum.Material.Grass)
end

local function buildMountain()
	local terrain = Workspace.Terrain
	local steps = 9
	for i = 0, steps do
		local t = i / steps
		local height = PEAK_HEIGHT * t
		local radius = mountainRadiusAtHeight(height)
		local material = if t > 0.8 then Enum.Material.Snow else Enum.Material.Rock
		terrain:FillBall(MOUNTAIN_CENTER + Vector3.new(0, height, 0), radius, material)
	end
end

local function buildLake()
	local terrain = Workspace.Terrain
	-- Rive de sable (large et peu profonde), puis le lac (plus étroit et plus profond)
	-- creusé par-dessus pour laisser un anneau de sable visible.
	terrain:FillCylinder(CFrame.new(LAKE_CENTER + Vector3.new(0, -3, 0)), 6, LAKE_RADIUS + 18, Enum.Material.Sand)
	terrain:FillCylinder(CFrame.new(LAKE_CENTER + Vector3.new(0, -7, 0)), 14, LAKE_RADIUS, Enum.Material.Water)
end

-- Un arbre simple et provisoire : tronc + feuillage (BRIEF.md : pas d'assets externes).
local function createTree(position: Vector3): Model
	local model = Instance.new("Model")
	model.Name = "Tree"

	local trunkHeight = math.random(8, 14)
	local trunk = Instance.new("Part")
	trunk.Name = "Trunk"
	trunk.Size = Vector3.new(2, trunkHeight, 2)
	trunk.Anchored = true
	trunk.Material = Enum.Material.Wood
	trunk.Color = Color3.fromRGB(92, 64, 40)
	trunk.CFrame = CFrame.new(position + Vector3.new(0, trunkHeight / 2, 0))
	trunk.Parent = model

	local leavesSize = math.random(10, 16)
	local leaves = Instance.new("Part")
	leaves.Name = "Leaves"
	leaves.Shape = Enum.PartType.Ball
	leaves.Size = Vector3.new(leavesSize, leavesSize, leavesSize)
	leaves.Anchored = true
	leaves.Material = Enum.Material.Grass
	leaves.Color = Color3.fromRGB(56, 128, 54)
	leaves.CFrame = CFrame.new(position + Vector3.new(0, trunkHeight + leavesSize * 0.35, 0))
	leaves.Parent = model

	model.PrimaryPart = trunk
	return model
end

local function buildForest(forestFolder: Folder)
	local treeCount = 130
	local placed = 0
	local attempts = 0
	while placed < treeCount and attempts < treeCount * 10 do
		attempts += 1
		local x = math.random(-HALF + 20, HALF - 20)
		local z = math.random(-HALF + 20, HALF - 20)
		local position = Vector3.new(x, GROUND_Y, z)

		local tooCloseToMountain = distanceXZ(position, MOUNTAIN_CENTER) < MOUNTAIN_BASE_RADIUS + 15
		local tooCloseToLake = distanceXZ(position, LAKE_CENTER) < LAKE_RADIUS + 30
		local tooCloseToBase = distanceXZ(position, BASE_AREA_CENTER) < BASE_AREA_RADIUS + 15
		local tooCloseToSpawn = distanceXZ(position, SPAWN_POSITION) < 20

		if not (tooCloseToMountain or tooCloseToLake or tooCloseToBase or tooCloseToSpawn) then
			local tree = createTree(position)
			tree.Parent = forestFolder
			placed += 1
		end
	end
end

-- Hauts lieux difficiles d'accès pour les œufs rares (BRIEF.md 7.1 et 7.3) :
-- sommet de la montagne, îles flottantes, corniches.
local function buildRareEggSpots(spotsFolder: Folder)
	local function addSpot(name: string, position: Vector3, buildPlatform: boolean)
		if buildPlatform then
			local platform = Instance.new("Part")
			platform.Name = name .. "Platform"
			platform.Shape = Enum.PartType.Cylinder
			platform.Size = Vector3.new(4, 16, 16)
			platform.CFrame = CFrame.new(position - Vector3.new(0, 2, 0)) * CFrame.Angles(0, 0, math.rad(90))
			platform.Anchored = true
			platform.Material = Enum.Material.Rock
			platform.Color = Color3.fromRGB(110, 110, 100)
			platform.Parent = spotsFolder
		end

		-- Un Part invisible plutôt qu'un Attachment : simple à positionner et à lire
		-- depuis n'importe quel parent (une Attachment a besoin d'un BasePart parent).
		local marker = Instance.new("Part")
		marker.Name = name
		marker.Size = Vector3.new(1, 1, 1)
		marker.CFrame = CFrame.new(position)
		marker.Anchored = true
		marker.CanCollide = false
		marker.Transparency = 1
		marker.Parent = spotsFolder
	end

	-- Sommet de la montagne : accessible seulement avec une monture Rare ou mieux.
	addSpot("MountainPeak", WorldService.MountainPeak, false)

	-- Corniches sur le flanc de la montagne.
	local ledgeHeights = { 70, 130 }
	for i, height in ledgeHeights do
		local radius = mountainRadiusAtHeight(height) + 6
		local angle = math.rad(40 * i)
		local position = MOUNTAIN_CENTER + Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
		addSpot("Ledge" .. i, position, true)
	end

	-- Îles flottantes au-dessus de la plaine.
	local islandSpots = {
		Vector3.new(60, 90, -40),
		Vector3.new(-60, 120, 60),
		Vector3.new(20, 150, 120),
	}
	for i, position in islandSpots do
		addSpot("Island" .. i, position, true)
	end
end

local function buildBoundaryWalls(wallsFolder: Folder)
	local wallHeight = 400
	local wallThickness = 10
	local wallY = GROUND_Y + wallHeight / 2 - 20

	local wallDefs = {
		{ size = Vector3.new(Config.Zone1.SizeStuds + wallThickness * 2, wallHeight, wallThickness), cframe = CFrame.new(0, wallY, HALF) },
		{ size = Vector3.new(Config.Zone1.SizeStuds + wallThickness * 2, wallHeight, wallThickness), cframe = CFrame.new(0, wallY, -HALF) },
		{ size = Vector3.new(wallThickness, wallHeight, Config.Zone1.SizeStuds + wallThickness * 2), cframe = CFrame.new(HALF, wallY, 0) },
		{ size = Vector3.new(wallThickness, wallHeight, Config.Zone1.SizeStuds + wallThickness * 2), cframe = CFrame.new(-HALF, wallY, 0) },
	}

	for i, def in wallDefs do
		local wall = Instance.new("Part")
		wall.Name = "Wall" .. i
		wall.Size = def.size
		wall.CFrame = def.cframe
		wall.Anchored = true
		wall.Transparency = 1
		wall.CanCollide = true
		wall.Parent = wallsFolder
	end
end

local function buildSpawn()
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "Spawn"
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.Anchored = true
	spawn.CanCollide = true
	spawn.Material = Enum.Material.Grass
	spawn.Color = Color3.fromRGB(56, 128, 54)
	spawn.CFrame = CFrame.new(SPAWN_POSITION)
	spawn.Duration = 0
	spawn.Parent = Workspace
end

function WorldService.Generate()
	if Workspace:FindFirstChild("WorldGenerated") then
		return
	end

	buildGround()
	buildMountain()
	buildLake()

	local forestFolder = Instance.new("Folder")
	forestFolder.Name = "Forest"
	forestFolder.Parent = Workspace
	buildForest(forestFolder)

	local spotsFolder = Instance.new("Folder")
	spotsFolder.Name = "RareEggSpots"
	spotsFolder.Parent = Workspace
	buildRareEggSpots(spotsFolder)

	local wallsFolder = Instance.new("Folder")
	wallsFolder.Name = "BoundaryWalls"
	wallsFolder.Parent = Workspace
	buildBoundaryWalls(wallsFolder)

	buildSpawn()

	local marker = Instance.new("BoolValue")
	marker.Name = "WorldGenerated"
	marker.Value = true
	marker.Parent = Workspace

	print("WorldService: zone 1 generated")
end

-- Position aléatoire au sol, en dehors de la montagne, du lac et de la zone de base.
-- Utilisé pour faire apparaître les œufs personnels.
function WorldService.GetRandomGroundPosition(): Vector3
	for _ = 1, 50 do
		local x = math.random(-HALF + 30, HALF - 30)
		local z = math.random(-HALF + 30, HALF - 30)
		local position = Vector3.new(x, GROUND_Y + 2, z)

		local tooCloseToMountain = distanceXZ(position, MOUNTAIN_CENTER) < MOUNTAIN_BASE_RADIUS + 10
		local tooCloseToLake = distanceXZ(position, LAKE_CENTER) < LAKE_RADIUS + 15
		local tooCloseToBase = distanceXZ(position, BASE_AREA_CENTER) < BASE_AREA_RADIUS + 10

		if not (tooCloseToMountain or tooCloseToLake or tooCloseToBase) then
			return position
		end
	end

	-- Filet de sécurité : près du spawn si on n'a pas trouvé de bon emplacement.
	return SPAWN_POSITION + Vector3.new(math.random(-30, 30), 2, math.random(-30, 30))
end

-- Choisit un des emplacements difficiles d'accès pour l'œuf rare partagé.
function WorldService.GetRandomRareEggSpot(): (Vector3, string)
	local spotsFolder = Workspace:FindFirstChild("RareEggSpots")
	if not spotsFolder then
		return WorldService.MountainPeak, "MountainPeak"
	end

	local markers = {}
	for _, child in spotsFolder:GetChildren() do
		if child:IsA("BasePart") then
			table.insert(markers, child)
		end
	end

	if #markers == 0 then
		return WorldService.MountainPeak, "MountainPeak"
	end

	local chosen = markers[math.random(1, #markers)]
	return chosen.Position, chosen.Name
end

return WorldService
