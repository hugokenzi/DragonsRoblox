--!strict
-- DataService : charge et sauvegarde les données de chaque joueur avec DataStoreService.
-- Le serveur est seul responsable de ces données (BRIEF.md section 6).

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)

local playerDataStore = DataStoreService:GetDataStore(Config.SaveData.DataStoreName)

local DataService = {}

-- Données en mémoire pendant la session, indexées par UserId.
local cache: { [number]: any } = {}

-- Essaie un appel DataStore plusieurs fois avant d'abandonner.
local function attemptWithRetries(action: () -> ...any): (boolean, any)
	local lastError: any = nil
	for attempt = 1, Config.SaveData.SaveRetryCount do
		local ok, result = pcall(action)
		if ok then
			return true, result
		end
		lastError = result
		if attempt < Config.SaveData.SaveRetryCount then
			task.wait(Config.SaveData.SaveRetryDelaySeconds)
		end
	end
	return false, lastError
end

-- Crée (ou met à jour) l'affichage de l'argent dans les leaderstats du joueur.
local function syncMoneyDisplay(player: Player)
	local data = cache[player.UserId]
	if not data then
		return
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local money = leaderstats:FindFirstChild("Argent")
	if not money then
		money = Instance.new("NumberValue")
		money.Name = "Argent"
		money.Parent = leaderstats
	end
	money.Value = data.money
end

-- Renvoie les données en mémoire d'un joueur (déjà chargées via Load).
function DataService.Get(player: Player): any
	return cache[player.UserId]
end

function DataService.Load(player: Player)
	local ok, result = attemptWithRetries(function()
		return playerDataStore:GetAsync("Player_" .. player.UserId)
	end)

	local data
	if ok and result ~= nil then
		data = result
	else
		if not ok then
			warn(("DataService: échec du chargement pour %s, nouvelles données utilisées. Erreur : %s"):format(player.Name, tostring(result)))
		end
		data = Config.newDefaultPlayerData()
	end

	cache[player.UserId] = data
	syncMoneyDisplay(player)
	print(("DataService: données chargées pour %s"):format(player.Name))
end

function DataService.Save(player: Player)
	local data = cache[player.UserId]
	if not data then
		return
	end

	local ok, err = attemptWithRetries(function()
		playerDataStore:SetAsync("Player_" .. player.UserId, data)
	end)

	if ok then
		print(("DataService: données sauvegardées pour %s"):format(player.Name))
	else
		warn(("DataService: échec de la sauvegarde pour %s. Erreur : %s"):format(player.Name, tostring(err)))
	end
end

function DataService.Remove(player: Player)
	cache[player.UserId] = nil
end

-- Sauvegarde tout le monde ; utilisé pour la sauvegarde automatique et BindToClose.
function DataService.SaveAll()
	for _, player in Players:GetPlayers() do
		DataService.Save(player)
	end
end

return DataService
