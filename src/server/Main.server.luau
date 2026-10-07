--!strict
-- Point d'entrée du serveur.

local Players = game:GetService("Players")

local Config = require(game:GetService("ReplicatedStorage").Shared.Config)
local DataService = require(script.Parent.Services.DataService)
local WorldService = require(script.Parent.Services.WorldService)

WorldService.Generate()

Players.PlayerAdded:Connect(function(player)
	DataService.Load(player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataService.Save(player)
	DataService.Remove(player)
end)

-- Sauvegarde régulière pendant que le serveur tourne, pour ne pas tout perdre en cas de crash.
task.spawn(function()
	while true do
		task.wait(Config.SaveData.AutoSaveIntervalSeconds)
		DataService.SaveAll()
	end
end)

-- Dernière chance de sauvegarder quand le serveur ferme (tous les joueurs sont éjectés après).
game:BindToClose(function()
	DataService.SaveAll()
end)

print("Server DragonsRoblox started")
