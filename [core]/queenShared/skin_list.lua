SkinList = { }

SkinList.character = {}

SkinList.character.femaleSkin = { -- женские скины (для создания персонажа)
	[1] = "31",
	[2] = "53",
	[3] = "131",
	[4] = "151",
	[5] = "157"
}

SkinList.character.maleSkin = { -- мужские скины (для создания персонажа)
	[1] = "35",
	[2] = "36",
	[3] = "30",
	[4] = "32",
	[5] = "44"
}

function getCharacterSkins()
	return {['female'] = SkinList.character.femaleSkin, ['male'] = SkinList.character.maleSkin}
end