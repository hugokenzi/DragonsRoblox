--!strict
-- Remotes : tous les points de communication client <-> serveur.
-- Seul le serveur crée ces instances (elles sont ensuite répliquées aux clients) ;
-- le client se contente d'attendre qu'elles existent.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = {}

local function getOrCreateFolder(): Instance
	if RunService:IsServer() then
		local folder = ReplicatedStorage:FindFirstChild("Remotes")
		if not folder then
			folder = Instance.new("Folder")
			folder.Name = "Remotes"
			folder.Parent = ReplicatedStorage
		end
		return folder
	end
	return ReplicatedStorage:WaitForChild("Remotes")
end

local function remoteEvent(name: string): RemoteEvent
	local folder = getOrCreateFolder()
	if RunService:IsServer() then
		local existing = folder:FindFirstChild(name)
		if existing then
			return existing :: RemoteEvent
		end
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
		return remote
	end
	return folder:WaitForChild(name) :: RemoteEvent
end

-- Monture et vol
Remotes.MountStatsChanged = remoteEvent("MountStatsChanged") -- server -> client : stats de la monture active
Remotes.RequestToggleFlight = remoteEvent("RequestToggleFlight") -- client -> server : décoller / atterrir
Remotes.FlightStateChanged = remoteEvent("FlightStateChanged") -- server -> client : en vol ou non, confirmé
Remotes.ReportFlightState = remoteEvent("ReportFlightState") -- client -> server : position/vitesse périodique
Remotes.StaminaChanged = remoteEvent("StaminaChanged") -- server -> client : endurance actuelle

-- Œufs
Remotes.PersonalEggsChanged = remoteEvent("PersonalEggsChanged") -- server -> client : œufs persos du joueur
Remotes.SharedEggChanged = remoteEvent("SharedEggChanged") -- server -> client : état de l'œuf rare partagé
Remotes.RequestPickupEgg = remoteEvent("RequestPickupEgg") -- client -> server : ramasser un œuf
Remotes.CarriedEggChanged = remoteEvent("CarriedEggChanged") -- server -> client : œuf porté + minuteur
Remotes.EggBroke = remoteEvent("EggBroke") -- server -> client : l'œuf porté a cassé

-- Base et incubation
Remotes.RequestDepositEgg = remoteEvent("RequestDepositEgg") -- client -> server : déposer l'œuf porté
Remotes.IncubatorsChanged = remoteEvent("IncubatorsChanged") -- server -> client : état des incubateurs
Remotes.DragonHatched = remoteEvent("DragonHatched") -- server -> client : un dragon vient d'éclore

-- Dragons, inventaire, argent
Remotes.InventoryChanged = remoteEvent("InventoryChanged") -- server -> client : inventaire de dragons
Remotes.RequestSetMount = remoteEvent("RequestSetMount") -- client -> server : choisir sa monture
Remotes.RequestSetPerch = remoteEvent("RequestSetPerch") -- client -> server : poser un dragon sur un perchoir
Remotes.RequestRemoveFromPerch = remoteEvent("RequestRemoveFromPerch") -- client -> server : retirer d'un perchoir
Remotes.MoneyChanged = remoteEvent("MoneyChanged") -- server -> client : argent + revenu/s total

-- Annonces et notifications
Remotes.ServerAnnouncement = remoteEvent("ServerAnnouncement") -- server -> tous : message serveur
Remotes.Notify = remoteEvent("Notify") -- server -> client : notification personnelle

return Remotes
