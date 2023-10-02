addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Скрытие чата
	showChat(false) 
	-- Скрытие HUD
	setPlayerHudComponentVisible("all", false)
	-- Отключение размытия при движении
	setBlurLevel(0)
	-- Отключение скрытия объектов
	setOcclusionsEnabled(false)
	-- Отключение фоновых звуков стрельбы
	setWorldSoundEnabled(5, false)
	-- Измерение, чтобы не мешались игроки
	setElementDimension(localPlayer, 999) 
	-- Отключение клавиатуры
	toggleAllControls(false, true, true)

	setWeather(0)
	setTime(12, 0)
	setMinuteDuration(60000 * 60 * 24)

	-- Звуки ветра
	setWorldSoundEnabled(0, 0, false, true)
	setWorldSoundEnabled(0, 29, false, true)
	setWorldSoundEnabled(0, 30, false, true)
end)
