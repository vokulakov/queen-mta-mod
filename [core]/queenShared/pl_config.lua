PlayerConfig = {}

PlayerConfig.startSettings = { -- стартовый пакет
	cash = 20000, -- наличные деньги
	donate = 5,   -- донат валюта

	lvl = 1,      -- уровень
}

function getPlayerStartSettings()
	return PlayerConfig.startSettings
end