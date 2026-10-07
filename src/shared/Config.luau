--!strict
-- Config : tous les réglages chiffrés du jeu, partagés par le serveur et les joueurs.
-- Les autres étapes du brief ajouteront leurs propres sections ici (œufs, vol, dragons...).

local Config = {}

-- Sauvegarde des données joueur (DataStoreService)
Config.SaveData = {
	DataStoreName = "DragonsRoblox_PlayerData_v1",
	AutoSaveIntervalSeconds = 60,
	SaveRetryCount = 3,
	SaveRetryDelaySeconds = 2,
}

Config.Economy = {
	StartingMoney = 0,
}

-- Version du schéma de sauvegarde (voir BRIEF.md section 8), pour pouvoir migrer plus tard.
Config.DataVersion = 1

-- Nombre de perchoirs par parcelle (BRIEF.md section 7.4).
Config.PerchCount = 6

-- Construit la structure de données par défaut d'un nouveau joueur.
function Config.newDefaultPlayerData()
	-- false = emplacement vide (pas de dragon). On évite nil car un trou dans un
	-- tableau casse sa longueur une fois passé par le DataStore (encodage JSON).
	local perches = {}
	for i = 1, Config.PerchCount do
		perches[i] = false
	end

	return {
		version = Config.DataVersion,
		money = Config.Economy.StartingMoney,
		dragons = {},
		perches = perches,
		mountId = false,
		incubators = {},
	}
end

return Config
