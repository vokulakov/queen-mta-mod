local sounds = { 

	-- systems_sound --
	['load_sound'] = "assets/systems_sound/load_sound.mp3",
	['login_sound'] = "assets/systems_sound/login_sound.mp3",
	['mission_sound'] = "assets/systems_sound/mission_sound.mp3",
	['error'] = "assets/systems_sound/error.wav",
	['notify'] = "assets/systems_sound/notify.mp3",
	['sound_eat1'] = "assets/systems_sound/sound_eat1.mp3",
	['sound_eat2'] = "assets/systems_sound/sound_eat2.mp3",
	['azs_pistolet_insert'] = "assets/systems_sound/azs_pistolet_insert.wav",
	['azs_pistolet_remove'] = "assets/systems_sound/azs_pistolet_remove.wav",
	['azs_zapravka'] = "assets/systems_sound/azs_zapravka.wav",

	['ui_change'] = "assets/systems_sound/ui_change.wav",
	['ui_select'] = "assets/systems_sound/ui_select.wav",
	['ui_back'] = "assets/systems_sound/ui_back.wav",

	-- vehicles --
	['veh_horn_sound_a'] = "assets/vehicles/signal/sound_a.wav",
	['veh_horn_sound_b'] = "assets/vehicles/signal/sound_a.wav",

	['veh_doorlock'] = "assets/vehicles/doorlock.mp3",
	['veh_lightswitch'] = "assets/vehicles/lightswitch.mp3",
	['veh_starter_car'] = "assets/vehicles/starter_car.mp3",
	['veh_starter_moto'] = "assets/vehicles/starter_moto.wav",
	['veh_turnsignal'] = "assets/vehicles/turnsignal.mp3",

	-- interiors --
	['int_restaurant'] = "assets/interiors/sound_restaurant.mp3",
	['int_skinshop'] = "assets/interiors/sound_skinshop.mp3", 
}

function playSound(name, ...)
	local sound = sounds[name]
	
	if not sound then
		return false
	end

	if type(name) ~= "string" then
		return false
	end

	return Sound(sound, ...)
end

function playSound3D(name, ...)
	local sound = sounds[name]

	if not sound then
		return false
	end

	if type(name) ~= "string" then
		return false
	end

	return Sound3D(sound, ...)
end

-- НЕОБХОДИМО СДЕАЛТЬ ОЧИСТКУ!