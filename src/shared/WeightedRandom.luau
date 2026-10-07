--!strict
-- WeightedRandom : tire une clé au hasard dans une table de poids
-- (ex. { Common = 60, Uncommon = 28, Rare = 12 }). Plus le poids est grand,
-- plus la clé a de chances de sortir. Utilisé pour les raretés, mutations, tailles.

local WeightedRandom = {}

function WeightedRandom.pick(weights: { [string]: number }, randomSource: Random?): string
	local total = 0
	for _, weight in weights do
		total += weight
	end

	local roll = if randomSource then randomSource:NextNumber(0, total) else math.random() * total

	local cumulative = 0
	local lastKey: string? = nil
	for key, weight in weights do
		cumulative += weight
		lastKey = key
		if roll <= cumulative then
			return key
		end
	end

	-- Filet de sécurité en cas d'imprécision flottante.
	return lastKey :: string
end

return WeightedRandom
