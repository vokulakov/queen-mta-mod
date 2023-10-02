addEvent('queenHunger.warning', true)
addEventHandler('queenHunger.warning', root, function()
	triggerEvent('queenNotification.addNotification', localPlayer, 'Вы голодны! Посетите ресторан\nбыстрого питания.', 1, true)
	
	local soundFX = exports.queenSounds:playSound('sound_eat1')
	setSoundVolume(soundFX, 0.2)
end)