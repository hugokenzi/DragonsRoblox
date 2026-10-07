--!strict
-- DragonService : inventaire de dragons (créer, poser sur un perchoir, choisir comme
-- monture) et revenu généré. BRIEF.md 7.6 (argent) et 7.7 (double rôle).

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local DragonStats = require(game:GetService("ReplicatedStorage").Shared.DragonStats)
local Remotes = require(game:GetService("ReplicatedStorage").Shared.Remotes)

local DataService = require(script.Parent.DataService)

local DragonService = {}

local function newDragonId(): string
	return HttpService:GenerateGUID(false)
end

function DragonService.CreateDragon(rarity: string, mutation: string, size: string, element: string)
	return {
		id = newDragonId(),
		rarity = rarity,
		mutation = mutation,
		size = size,
		element = element,
		createdAt = os.time(),
	}
end

-- Donne le dragon Commun de départ, déjà choisi comme monture (une seule fois par joueur).
function DragonService.GrantStarterDragonIfNeeded(player: Player)
	local data = DataService.Get(player)
	if not data or data.hasReceivedStarterDragon then
		return
	end

	local dragon = DragonService.CreateDragon("Common", "None", "Normal", Config.Zone1.Element)
	data.dragons[dragon.id] = dragon
	data.mountId = dragon.id
	data.hasReceivedStarterDragon = true

	DragonService.PushInventory(player)
	DragonService.PushMountStats(player)
end

function DragonService.PushInventory(player: Player)
	local data = DataService.Get(player)
	if not data then
		return
	end
	Remotes.InventoryChanged:FireClient(player, data.dragons, data.perches, data.mountId)
end

-- Stats de monture du dragon actuellement choisi comme monture (ou nil si aucun).
function DragonService.GetMountStats(player: Player): { Speed: number, MaxStamina: number }?
	local data = DataService.Get(player)
	if not data or not data.mountId then
		return nil
	end
	local dragon = data.dragons[data.mountId]
	if not dragon then
		return nil
	end
	return DragonStats.getMountStats(dragon.rarity, dragon.size)
end

function DragonService.PushMountStats(player: Player)
	local stats = DragonService.GetMountStats(player)
	Remotes.MountStatsChanged:FireClient(player, stats)
end

-- Choisit un dragon de l'inventaire comme monture. Un dragon monté ne produit plus
-- d'argent tant qu'il est la monture, même s'il reste posé sur son perchoir.
function DragonService.SetMount(player: Player, dragonId: string): boolean
	local data = DataService.Get(player)
	if not data then
		return false
	end
	local dragon = data.dragons[dragonId]
	if not dragon then
		return false
	end

	data.mountId = dragonId
	DragonService.PushMountStats(player)
	DragonService.PushInventory(player)
	return true
end

function DragonService.SetPerch(player: Player, perchIndex: number, dragonId: string): boolean
	local data = DataService.Get(player)
	if not data then
		return false
	end
	if perchIndex < 1 or perchIndex > Config.PerchCount then
		return false
	end
	local dragon = data.dragons[dragonId]
	if not dragon then
		return false
	end

	-- Un dragon ne peut pas occuper deux perchoirs à la fois.
	for i, placedId in data.perches do
		if placedId == dragonId then
			data.perches[i] = false
		end
	end
	data.perches[perchIndex] = dragonId

	DragonService.PushInventory(player)
	return true
end

function DragonService.RemoveFromPerch(player: Player, perchIndex: number): boolean
	local data = DataService.Get(player)
	if not data then
		return false
	end
	if perchIndex < 1 or perchIndex > Config.PerchCount then
		return false
	end
	data.perches[perchIndex] = false

	DragonService.PushInventory(player)
	return true
end

-- Revenu total par seconde de ce joueur (dragons posés, hors monture active).
function DragonService.GetIncomePerSecond(player: Player): number
	local data = DataService.Get(player)
	if not data then
		return 0
	end

	local total = 0
	for _, dragonId in data.perches do
		if dragonId and dragonId ~= data.mountId then
			local dragon = data.dragons[dragonId]
			if dragon then
				total += DragonStats.getIncomePerSecond(dragon.rarity, dragon.mutation, dragon.size)
			end
		end
	end
	return total
end

function DragonService.PushMoney(player: Player)
	local data = DataService.Get(player)
	if not data then
		return
	end
	Remotes.MoneyChanged:FireClient(player, data.money, DragonService.GetIncomePerSecond(player))
end

function DragonService.Init()
	Remotes.RequestSetMount.OnServerEvent:Connect(function(player, dragonId)
		if typeof(dragonId) == "string" then
			DragonService.SetMount(player, dragonId)
		end
	end)

	Remotes.RequestSetPerch.OnServerEvent:Connect(function(player, perchIndex, dragonId)
		if typeof(perchIndex) == "number" and typeof(dragonId) == "string" then
			DragonService.SetPerch(player, perchIndex, dragonId)
		end
	end)

	Remotes.RequestRemoveFromPerch.OnServerEvent:Connect(function(player, perchIndex)
		if typeof(perchIndex) == "number" then
			DragonService.RemoveFromPerch(player, perchIndex)
		end
	end)

	-- Verse le revenu chaque seconde pour les dragons posés sur un perchoir.
	task.spawn(function()
		while true do
			task.wait(1)
			for _, player in Players:GetPlayers() do
				local data = DataService.Get(player)
				if data then
					local income = DragonService.GetIncomePerSecond(player)
					if income > 0 then
						data.money += income
						DataService.SyncMoneyDisplay(player)
					end
					DragonService.PushMoney(player)
				end
			end
		end
	end)
end

return DragonService
