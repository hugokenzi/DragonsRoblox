--!strict
-- DragonStats : calcule les stats de monture et le revenu d'un dragon à partir de sa
-- rareté, mutation et taille (BRIEF.md 7.2 et 7.6). Pure logique, pas d'état.

local Config = require(script.Parent.Config)

export type Dragon = {
	id: string,
	rarity: string,
	mutation: string,
	size: string,
	element: string,
	createdAt: number,
}

local DragonStats = {}

function DragonStats.getMountStats(rarity: string, size: string): { Speed: number, MaxStamina: number }
	local base = Config.Rarities[rarity]
	local sizeMultiplier = Config.Sizes.Multiplier[size] or 1
	return {
		Speed = base.MountSpeed * sizeMultiplier,
		MaxStamina = base.MaxStamina * sizeMultiplier,
	}
end

function DragonStats.getIncomePerSecond(rarity: string, mutation: string, size: string): number
	local base = Config.Rarities[rarity].BaseIncome
	local mutationMultiplier = Config.Mutations.IncomeMultiplier[mutation] or 1
	local sizeMultiplier = Config.Sizes.Multiplier[size] or 1
	return base * mutationMultiplier * sizeMultiplier
end

return DragonStats
